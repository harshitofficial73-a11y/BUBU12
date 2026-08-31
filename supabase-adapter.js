// BUBU.Market live Supabase adapter. All commercial data crosses this boundary.
(function () {
  'use strict';
  const url = window.BUBU_SUPABASE_URL || '';
  const key = window.BUBU_SUPABASE_ANON_KEY || '';
  const sb = window.supabase && url && key ? window.supabase.createClient(url, key, {
    auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true }
  }) : null;
  const client = () => { if (!sb) throw new Error('Supabase is not configured'); return sb; };
  const dataOf = ({ data, error }) => { if (error) throw error; return data; };
  // Every column of products and requirements EXCEPT the two the AI added.
  // Named explicitly because PostgREST cannot express "everything but these",
  // and a 384-number fingerprint is 3.6 KB per row — on a 100-row feed that is
  // 355 KB of waste on a phone, for data only ever compared inside Postgres.
  const PRODUCT_COLS = 'id,supplier_id,name,category_id,family,description,price,unit,moq,brand,status,rating,order_count,view_count,created_at,updated_at';
  const REQUIREMENT_COLS = 'id,buyer_id,title,category_id,quantity,quantity_unit,specification,purpose,deliver_to,district_id,needed_by,estimated_value,payment_method,state,created_at,expires_at';
  const money = n => 'UGX ' + Number(n || 0).toLocaleString('en-UG');
  // The figure and the unit are stored separately and joined here, so this is
  // the one place the two have to agree: "50 bags", "1 bag", "300 units".
  // Whoever typed the unit may have written it either way round.
  const qtyText = (n, unit) => {
    const q = Number(n || 0);
    let u = String(unit || 'unit').trim() || 'unit';
    if (q === 1) {
      if (/(ch|sh|s|x|z)es$/i.test(u)) u = u.slice(0, -2);
      else if (!/ss$/i.test(u) && /s$/i.test(u)) u = u.slice(0, -1);
    } else if (!/s$/i.test(u)) {
      u = /(ch|sh|x|z)$/i.test(u) ? u + 'es' : u + 's';   // box -> boxes, bar -> bars
    }
    return q + ' ' + u;
  };
  // A media path is one of three things: a full URL (a video link, or an
  // imported photograph), a file shipped with the site under img/, or a key in
  // the storage bucket. Only the last needs signing.
  const isDirectUrl = path => /^(https?:|img\/|\/)/i.test(String(path || ''));
  const mediaUrl = path => !path ? ''
    : isDirectUrl(path) ? path
    : client().storage.from('media').getPublicUrl(path).data.publicUrl;
  const user = async () => dataOf(await client().auth.getUser()).user;
  async function accountRow() {
    const u = await user();
    if (!u) return null;
    return dataOf(await sb.from('accounts').select('id,role,district_id').eq('auth_user_id', u.id).maybeSingle());
  }

  const auth = {
    requestOtp(phone) { return client().auth.signInWithOtp({ phone }); },
    requestEmailOtp(email, create) {
      return client().auth.signInWithOtp({ email: String(email).trim(), options: { shouldCreateUser: !!create } });
    },
    async verifyOtp(target, token, channel) {
      return dataOf(await client().auth.verifyOtp(channel === 'email'
        ? { email: target, token, type: 'email' } : { phone: target, token, type: 'sms' }));
    },
    signIn(email, password) { return client().auth.signInWithPassword({ email, password }); },
    // Supabase mails a link back to whichever page asked for it.
    resetPassword(email) {
      return client().auth.resetPasswordForEmail(String(email).trim(),
        { redirectTo: window.location.origin + window.location.pathname });
    },
    signUp(email, password, metadata) {
      return client().auth.signUp({ email, password, options: { data: metadata || {} } });
    },
    async verifyPlatformCode(email, code) {
      if (!window.BUBU_ALLOW_UNIVERSAL_OTP) throw new Error('Universal code is disabled');
      if (String(code) !== String(window.BUBU_UNIVERSAL_OTP || '')) throw new Error('Invalid code');
      return dataOf(await client().auth.signInWithPassword({
        email: String(email).trim(), password: String(window.BUBU_SEED_PASSWORD || '')
      }));
    },
    signOut() { return client().auth.signOut(); },
    async session() { return dataOf(await client().auth.getSession()).session; },
    onChange(fn) { return client().auth.onAuthStateChange(fn); }
  };

  async function loadAccount() {
    const u = await user();
    if (!u) return null;
    // Resolve identity and role from the core account row first. Optional joined
    // tables must never be allowed to hide a valid admin/supplier/buyer account.
    const a = dataOf(await sb.from('accounts').select('*')
      .eq('auth_user_id', u.id).maybeSingle());
    if (!a) return null;
    const safeRows = async (table, columns = '*') => {
      try {
        const result = await sb.from(table).select(columns).eq('account_id', a.id);
        return result.error ? [] : result.data || [];
      } catch (_) { return []; }
    };
    const [registrations, categories, addresses, payoutMethods, handsets, staff, documents, mediaItems, leadPreferences, subscriptions] =
      await Promise.all([
        safeRows('account_registration'), safeRows('account_categories', 'category_id'), safeRows('addresses'),
        safeRows('payout_methods'), safeRows('handsets'), safeRows('account_users'), safeRows('documents'),
        safeRows('media'), safeRows('lead_preferences'), safeRows('subscriptions')
      ]);
    const documentFiles = await Promise.all(documents.map(async d => {
      if (!d.storage_path) return { ...d, downloadUrl: '', viewUrl: '' };
      const filename = d.storage_path.split('/').pop() || 'document';
      // Two URLs per document: one that downloads, one the browser can render
      // inline so image uploads get a real thumbnail.
      const [signed, inline] = await Promise.all([
        sb.storage.from('media').createSignedUrl(d.storage_path, 900, { download: filename }),
        sb.storage.from('media').createSignedUrl(d.storage_path, 900)
      ]);
      return { ...d, filename,
        downloadUrl: signed.error ? '' : signed.data.signedUrl,
        viewUrl: inline.error ? '' : inline.data.signedUrl };
    }));
    const accountMedia = await Promise.all(mediaItems.map(async m => {
      if (!m.storage_path) return { ...m, url: '' };
      const signed = await sb.storage.from('media').createSignedUrl(m.storage_path, 900);
      return { ...m, url: signed.error ? '' : signed.data.signedUrl };
    }));
    const r = registrations[0] || {};
    return {
      id: a.id, id_phone: a.phone, role: a.role,
      bizType: a.business_type === 'manufacturer' ? 'Manufacturer' : 'Trader',
      tier: a.tier === 'industry_leader' ? 'Industry leader' : a.tier === 'star_supplier' ? 'Star supplier' : '',
      company: a.company, trade: a.trade_name || a.company, initials: a.initials || '',
      person: staff[0]?.full_name || u.user_metadata?.full_name || '',
      roleTitle: staff[0]?.role_title || '', alt: a.alt_phone || '',
      email: a.email || u.email || '', altEmail:a.alt_email || '', landline:a.landline || '', addr: a.address || '', district: a.district_id || '',
      ursb: r.ursb_number || '', tin: r.tin || '', licence: r.trading_licence || '',
      nin: r.director_nin || '', vatNumber: r.vat_number || '',
      verificationState: r.overall_state || 'unverified', cats: categories.map(x => x.category_id),
      about: a.about || '', coverage: a.coverage || '', nature: a.nature_of_business || '', legalForm:a.legal_form || '',
      staffCount: a.staff_count || '', turnover: a.turnover || '', brands: a.brands || '', warehouse:a.warehouse || '', fleet:a.fleet || '',
      banker:a.banker || '', paymentTerms:a.payment_terms || '', memberships:a.memberships || '', certifications:a.certifications || '',
      mtnMomo:(payoutMethods.find(x=>x.method==='mtn_momo')||{}).detail || '',
      airtelMoney:(payoutMethods.find(x=>x.method==='airtel_money')||{}).detail || '',
      bankTransfer:(payoutMethods.find(x=>x.method==='bank_transfer')||{}).detail || '',
      spend: money(a.spend_12m), suppliers: String(a.supplier_count || 0),
      addresses, payoutMethods, handsets, documents: documentFiles, mediaItems: accountMedia,
      leadPreferences: leadPreferences[0] || null,
      subscription: subscriptions[0] || null
    };
  }

  // One listing by id, for a product reached from somewhere other than the
  // capped marketplace feed — a comparison screen, a supplier's own grid.
  async function productById(id) {
    if (!id) return null;
    const rows = await searchProducts({ id, limit: 1 });
    return rows[0] || null;
  }
  async function searchProducts({ query = '', category = null, mine = false, id = null, ids = null, limit = 100 } = {}) {
    let q = sb.from('products').select(`${PRODUCT_COLS},categories(name,parent_id),accounts!products_supplier_id_fkey(company,district_id,business_type,tier),
      media(id,storage_path,approved,kind,caption),product_specs(key,value,sort)`).order('updated_at', { ascending: false }).limit(limit);
    if (mine) { const a = await accountRow(); if (!a) return []; q = q.eq('supplier_id', a.id); }
    else {
      q = q.eq('status', 'published');
      // One account now buys and sells, so without this a trader browsing the
      // marketplace finds their own cement and can "enquire" with themselves.
      // Skipped when fetching one listing by id: a supplier opening their own
      // product page from their catalogue is legitimate.
      if (!id) {
        const a = await accountRow().catch(() => null);
        if (a && a.id) q = q.neq('supplier_id', a.id);
      }
    }
    if (query) q = q.ilike('name', '%' + query.replace(/[%_]/g, '') + '%');
    if (category) q = q.eq('category_id', category);
    if (id) q = q.eq('id', id);
    if (ids) { if (!ids.length) return []; q = q.in('id', ids); }
    const rows = dataOf(await q) || [];
    return Promise.all(rows.map(async p => {
      const sign = async (item, opts) => {
        const path = item?.storage_path || '';
        if (!path || isDirectUrl(path)) return path;
        try { return dataOf(await sb.storage.from('media').createSignedUrl(path, 3600, opts))?.signedUrl || ''; }
        catch (_) { return ''; }
      };
      // A listing carries up to four photos; the first is the one search shows.
      const photoItems = (p.media || []).filter(m => m.kind === 'product').slice(0, 4);
      const videos = (p.media || []).filter(m => m.kind === 'video')
        .map(m => videoInfo(m.storage_path, m.id)).filter(Boolean);
      const pdfItem = (p.media || []).find(m => m.kind === 'product_pdf') || null;
      const pdfName = pdfItem
        ? (pdfItem.caption || String(pdfItem.storage_path || '').split('/').pop() || 'document.pdf')
        : '';
      const [photoUrls, pdf, pdfDownload] = await Promise.all([
        Promise.all(photoItems.map(i => sign(i))),
        sign(pdfItem),
        pdfItem ? sign(pdfItem, { download: pdfName }) : Promise.resolve('')
      ]);
      const photos = photoUrls.filter(Boolean);
      const photo = photos[0] || '';
      return {
      id: p.id, supplierId: p.supplier_id, name: p.name,
      cat: p.categories?.name || p.category_id || 'Uncategorised', categoryId: p.category_id,
      description: p.description || '', price: Number(p.price), unit: p.unit, moq: Number(p.moq),
      brand: p.brand || '', status: p.status, rating: Number(p.rating || 0), orders: Number(p.order_count || 0),
      views: Number(p.view_count || 0), supplier: p.accounts?.company || '', loc: p.accounts?.district_id || '',
      businessType: p.accounts?.business_type || '', tier: p.accounts?.tier || '',
      parentCategory: p.categories?.parent_id || '',
      photo, img: photo, photos, videos, pdf, pdfDownload, pdfName,
      media: p.media || [], specs: p.product_specs || []
    }; }));
  }
  async function saveProduct(body) {
    const a = await accountRow();
    if (!a || a.role !== 'supplier') throw new Error('Supplier account required');
    const specs = body.specs || [];
    let categoryId = body.category_id || null;
    if (categoryId) {
      const categories = dataOf(await sb.from('categories').select('id,name')) || [];
      const wanted = String(categoryId).toLowerCase();
      const match = categories.find(c => c.id === categoryId || c.name.toLowerCase() === wanted)
        || categories.find(c => wanted.includes(c.name.toLowerCase()) || c.name.toLowerCase().includes(wanted.split('>')[0].trim()));
      categoryId = match ? match.id : null;
    }
    const row = { supplier_id: a.id, name: body.name, category_id: categoryId,
      family: body.family || null, description: body.description || null, price: Number(body.price),
      unit: body.unit, moq: Number(body.moq || 1), brand: body.brand || null, status: body.status || 'draft' };
    const saved = body.id
      ? dataOf(await sb.from('products').update(row).eq('id', body.id).eq('supplier_id', a.id).select().single())
      : dataOf(await sb.from('products').insert(row).select().single());
    if (body.id) dataOf(await sb.from('product_specs').delete().eq('product_id', saved.id));
    if (specs.length) dataOf(await sb.from('product_specs').insert(specs.map((s, i) => ({
      product_id: saved.id, key: s.key || s[0], value: s.value || s[1], sort: i }))));
    // Belt and braces: fingerprinting is a background nicety. Wrapped so that
    // nothing here can ever fail a save the supplier has already completed.
    try { embedProduct(saved, body.category_name || null); } catch (_) {}
    return saved;
  }
  // Fingerprint the listing so it can be matched to requirements by meaning.
  // Not awaited: the product is already saved and word matching still covers it,
  // so a failure here must never surface to the supplier.
  function embedProduct(saved, categoryName) {
    if (!saved || !saved.id) return;
    embedRow('product', saved.id,
      [saved.name, saved.brand, saved.description, categoryName].filter(Boolean).join('. '));
  }
  const setProductStatus = async (id, status) => dataOf(await sb.from('products').update({ status }).eq('id', id).select().single());
  const deleteProduct = async id => dataOf(await sb.from('products').delete().eq('id', id));
  // Categories carry no count column, so every listing count read as zero. The
  // tally is done here, and a parent category counts what sits under it too —
  // products are filed on leaves like 'steel-metal', not 'building-construction'.
  const loadCategories = async () => {
    const rows = dataOf(await sb.from('categories').select('*').order('sort').order('name')) || [];
    let counts = {};
    try {
      const prods = dataOf(await sb.from('products').select('category_id').eq('status', 'published')) || [];
      prods.forEach(p => { if (p.category_id) counts[p.category_id] = (counts[p.category_id] || 0) + 1; });
    } catch (_) { counts = {}; }
    const kidsOf = {};
    rows.forEach(r => { if (r.parent_id) (kidsOf[r.parent_id] = kidsOf[r.parent_id] || []).push(r.id); });
    const descend = (id, seen) => {
      if (seen.has(id)) return [];
      seen.add(id);
      return (kidsOf[id] || []).reduce((all, kid) => all.concat(kid, descend(kid, seen)), []);
    };
    return rows.map(r => {
      const kids = descend(r.id, new Set());
      return { ...r, kids,
        own_count: counts[r.id] || 0,
        product_count: (counts[r.id] || 0) + kids.reduce((s, k) => s + (counts[k] || 0), 0) };
    });
  };

  // One category's listings, children included. The marketplace loads a capped
  // page for its home feed; opening a category asks the database for that
  // category instead of filtering the page it already has, which is what made a
  // category holding thirteen products show one.
  async function productsInCategory(categoryId, limit = 400) {
    if (!categoryId) return [];
    let rows = [];
    try {
      rows = dataOf(await sb.rpc('products_in_category',
        { p_category: categoryId, p_limit: limit })) || [];
    } catch (_) {
      // Before 0037 is applied, fall back to the leaf category alone.
      return searchProducts({ category: categoryId, limit });
    }
    if (!rows.length) return [];
    // Re-read through searchProducts so photos, videos and brochures are
    // hydrated by exactly the same code the rest of the app relies on.
    return searchProducts({ ids: rows.map(r => r.id), limit });
  }

  async function offersFor(productId) {
    return (dataOf(await sb.from('product_offers').select('*').eq('product_id', productId)) || []).map(o => ([
      o.supplier, o.district_id, Number(o.price), o.moq + ' ' + o.unit, null, !!o.verified,
      Number(o.years_on_platform || 0), o.supplier_id
    ]));
  }
  async function submitProductQuoteRequest(productId, supplierId, quantity) {
    return dataOf(await sb.rpc('submit_product_quote_request', {
      p_product: productId, p_supplier: supplierId, p_quantity: Number(quantity || 1)
    }));
  }
  async function revealSupplierContact(supplierId) {
    return dataOf(await sb.rpc('reveal_supplier_contact', { p_supplier: supplierId }));
  }
  // Credit and tax enquiries.
  async function submitFinanceEnquiry(kind, figures) {
    const f = figures || {};
    const num = v => { const n = Number(String(v == null ? '' : v).replace(/[^0-9]/g, '')); return n || null; };
    return dataOf(await sb.rpc('submit_finance_enquiry', {
      p_kind: kind, p_year: num(f.year), p_t1: num(f.t1), p_t2: num(f.t2), p_t3: num(f.t3),
      p_limit: num(f.limit),
      p_invoice: num(f.invoice), p_tenor: num(f.tenor),
      p_counterparty: f.counterparty || null }));
  }

  // Ship with BUBU. The estimate the trader saw is stored with the request, so
  // whoever calls them back knows what they were quoted.
  async function submitLogisticsRequest(body) {
    const b = body || {};
    const num = v => { const n = Number(String(v == null ? '' : v).replace(/[^0-9.]/g, '')); return n || null; };
    return dataOf(await sb.rpc('submit_logistics_request', {
      p_from: b.from || null, p_to: b.to || null, p_vehicle: b.vehicle || null,
      p_load: b.load || null, p_weight: num(b.weight),
      p_pickup: b.pickup || null, p_estimate: num(b.estimate), p_distance: num(b.distance) }));
  }
  // What this account may actually do. One account buys and sells; selling
  // needs admin approval, buying never does.
  async function myCapabilities() {
    try { return dataOf(await sb.rpc('my_capabilities')) || null; }
    catch (_) { return null; }
  }
  const applyToSell = async () => dataOf(await sb.rpc('apply_to_sell'));
  const decideSeller = (accountId, approve) =>
    sb.rpc('decide_seller', { p_account: accountId, p_approve: !!approve });

  // Which suppliers may see which leads, and what buyers are asking for.
  const myLeadBoard = async () => (dataOf(await sb.rpc('my_lead_board')) || []);
  const categoryDemand = async () => (dataOf(await sb.rpc('category_demand')) || []);

  // Products like this one. Tries meaning first — the embeddings are already
  // there and cost nothing per call — and falls back to word overlap, so a
  // product that has not been fingerprinted yet still gets neighbours.
  async function similarProducts(product, limit = 6) {
    const p = product || {};
    const text = [p.name, p.brand, p.cat, p.description].filter(Boolean).join('. ');
    if (!text) return [];
    let names = [];
    try {
      const vector = await embedText(text);
      if (vector) {
        names = (dataOf(await sb.rpc('suggest_products_semantic',
          { p_query: p.name || '', p_vector: vector })) || []).map(r => r.name);
      }
    } catch (_) { /* fall through to words */ }
    if (!names.length) {
      const words = String(p.name || '').toLowerCase()
        .replace(/[^a-z0-9]+/g, ' ').split(' ').filter(w => w.length >= 4);
      if (!words.length) return [];
      names = words.slice(0, 2);
    }
    const seen = new Set([String(p.name || '').toLowerCase()]);
    const out = [];
    for (const term of names.slice(0, 4)) {
      if (out.length >= limit) break;
      const rows = await searchProducts({ query: term, limit: 8 }).catch(() => []);
      for (const r of rows) {
        const k = String(r.name || '').toLowerCase();
        if (r.id === p.id || seen.has(k)) continue;
        seen.add(k); out.push(r);
        if (out.length >= limit) break;
      }
    }
    return out;
  }

  async function loadSupplierProfile(supplierId) {
    const d = dataOf(await sb.rpc('load_public_supplier_profile', { p_supplier: supplierId }));
    if (!d) return null;
    // Turn every storage path into something an <img> can load. An imported
    // photo is already a full URL; an uploaded one needs signing.
    const sign = async (path) => {
      if (!path) return '';
      if (isDirectUrl(path)) return path;
      const s = await sb.storage.from('media').createSignedUrl(path, 900);
      return s.error ? '' : s.data.signedUrl;
    };
    d.bannerUrl = await sign(d.banner);
    d.products = await Promise.all((d.products || []).map(async p => ({
      ...p,
      photoUrls: (await Promise.all((p.photos || []).slice(0, 4).map(sign))).filter(Boolean),
      videoList: (p.videos || []).map((u, i) => videoInfo(u, p.id + ':' + i)),
      brochureUrl: await sign(p.brochure)
    })));
    return d;
  }
  // The public profile any signed-in account may read: no phone, no email.
  async function supplierProfile(supplierId) {
    const d = dataOf(await sb.rpc('supplier_public_profile', { p_supplier: supplierId })) || null;
    if (!d) return null;
    const sign = async (path) => {
      if (!path) return '';
      if (isDirectUrl(path)) return path;
      const s = await sb.storage.from('media').createSignedUrl(path, 900);
      return s.error ? '' : s.data.signedUrl;
    };
    d.products = await Promise.all((d.products || []).map(async p => ({
      ...p,
      photoUrls: (await Promise.all((p.photos || []).slice(0, 4).map(sign))).filter(Boolean),
      videoList: (p.videos || []).map((u, i) => videoInfo(u, p.id + ':' + i)),
      brochureUrl: await sign(p.brochure)
    })));
    return d;
  }
  // Every published listing of one product name, across suppliers.
  async function listingsForProduct(name) {
    const rows = dataOf(await sb.rpc('listings_for_product', { p_name: String(name || '') })) || [];
    const sign = async (path) => {
      if (!path) return '';
      if (isDirectUrl(path)) return path;
      const s = await sb.storage.from('media').createSignedUrl(path, 900);
      return s.error ? '' : s.data.signedUrl;
    };
    return Promise.all(rows.map(async r => ({
      id: r.id, name: r.name, brand: r.brand,
      price: Number(r.price || 0), unit: r.unit, moq: r.moq,
      description: r.description, views: Number(r.view_count || 0),
      categoryId: r.category_id, category: r.category_name || '', parentCategory: r.parent_name || '',
      supplierId: r.supplier_id, supplier: r.supplier, tradeName: r.trade_name,
      businessType: r.business_type, tier: r.tier, district: r.district_id,
      verified: r.verification_state === 'verified',
      verificationState: r.verification_state,
      rating: r.rating ? Number(r.rating) : 0, ratingCount: Number(r.rating_count || 0),
      photoUrls: (await Promise.all((r.photos || []).slice(0, 4).map(sign))).filter(Boolean),
      videoList: (r.videos || []).map((u, i) => videoInfo(u, r.id + ':' + i)),
      brochureUrl: await sign(r.brochure),
      hasBrochure: !!r.brochure
    })));
  }
  async function startSupplierConversation(supplierId) {
    return dataOf(await sb.rpc('start_supplier_conversation', { p_supplier: supplierId }));
  }
  async function loadBuyerNotifications() {
    const a=await accountRow();
    if(!a || a.role!=='buyer') return [];
    return dataOf(await sb.from('buyer_notifications').select('*').eq('buyer_id',a.id)
      .order('created_at',{ascending:false}).limit(50)) || [];
  }
  async function revealContact({ requirementId = null, productId = null }) {
    return dataOf(await sb.rpc('reveal_contact', { p_requirement: requirementId, p_product: productId }));
  }
  async function leadBalance() {
    return dataOf(await sb.rpc('lead_balance'));
  }
  async function purchaseLead(requirementId, confirmCashPayment) {
    return dataOf(await sb.rpc('purchase_lead', {
      p_requirement: requirementId, p_confirm_cash_payment: !!confirmCashPayment
    }));
  }
  async function myBuyLeads() {
    // The board carries buyer detail and purchase state; fall back to the plain
    // requirement list if the RPC has not been installed yet.
    try {
      const rows = dataOf(await sb.rpc('my_lead_board')) || [];
      return rows.map(r => ({
        id: r.id, title: r.title, cat: r.category_id,
        qty: qtyText(r.quantity, r.quantity_unit),
        loc: r.district_id, spec: r.specification, deliverTo: r.deliver_to,
        value: money(r.estimated_value), estimatedValue: Number(r.estimated_value || 0),
        purpose: r.purpose, createdAt: r.created_at,
        purchased: !!r.purchased, purchasedAt: r.purchased_at,
        conversationId: r.conversation_id, charged: Number(r.charged || 0),
        myQuote: r.my_quote || null,
        buyer: r.buyer || {}
      }));
    } catch (_) {
      return (dataOf(await sb.rpc('my_buy_leads')) || []).map(r => ({ id: r.id, title: r.title,
        cat: r.category_id, qty: qtyText(r.quantity, r.quantity_unit), loc: r.district_id,
        neededBy: r.needed_by, value: money(r.estimated_value), spec: r.specification,
        deliverTo: r.deliver_to, estimatedValue: Number(r.estimated_value || 0),
        purpose: r.purpose, createdAt: r.created_at, purchased: false, buyer: {} }));
    }
  }
  // ── AI ─────────────────────────────────────────────────────────────────
  // One Edge Function, two jobs. `embed` runs on a model inside Supabase, so it
  // needs no API key and costs nothing per call. `tidy` needs the key.
  //
  // Every one of these fails soft: no function deployed, no key, no signal —
  // the caller gets null and the platform behaves exactly as it did before.
  async function callAi(action, payload) {
    const session = await auth.session();
    if (!session) return null;
    if (!url) return null;
    const base = url;
    try {
      const res = await fetch(base.replace(/\/$/, '') + '/functions/v1/bubu-ai', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json',
          Authorization: 'Bearer ' + session.access_token },
        body: JSON.stringify({ action, ...payload })
      });
      if (!res.ok) return null;
      return await res.json();
    } catch (_) { return null; }
  }

  // Turns a phrase into a meaning fingerprint. Free.
  async function embedText(text) {
    const out = await callAi('embed', { text });
    const v = out && out.vectors && out.vectors[0];
    return Array.isArray(v) ? v : null;
  }

  // Fingerprints one product or requirement so it can be matched by meaning.
  // Called after every save; a failure is silent because the row is already
  // saved and word matching still covers it.
  async function embedRow(kind, id, text) {
    if (!id || !text) return false;
    const vector = await embedText(text);
    if (!vector) return false;
    try {
      return !!dataOf(await sb.rpc('set_embedding',
        { p_kind: kind, p_id: id, p_vector: vector, p_text: text }));
    } catch (_) { return false; }
  }

  // Fingerprints whatever is still missing one, a few at a time. Safe to call
  // on sign-in: it does nothing when there is no backlog.
  async function embedBacklog(limit = 25) {
    let rows = [];
    try { rows = dataOf(await sb.rpc('embedding_backlog', { p_limit: limit })) || []; }
    catch (_) { return { done: 0, remaining: 0 }; }
    if (!rows.length) return { done: 0, remaining: 0 };
    const out = await callAi('embed', { texts: rows.map(r => r.content) });
    const vectors = (out && out.vectors) || [];
    let done = 0;
    for (let i = 0; i < rows.length; i++) {
      if (!Array.isArray(vectors[i])) continue;
      try {
        await sb.rpc('set_embedding', { p_kind: rows[i].kind, p_id: rows[i].id,
          p_vector: vectors[i], p_text: rows[i].content });
        done++;
      } catch (_) { /* keep going; the next pass retries it */ }
    }
    return { done, remaining: Math.max(0, rows.length - done) };
  }

  // Reads what a buyer typed and returns structured fields for them to check.
  // Returns null when clean-up is not switched on, so the caller carries on
  // without it rather than seeing an error.
  async function tidyRequirement(text, district) {
    const out = await callAi('tidy', { text, district });
    if (!out || !out.ok) return null;
    return out;
  }

  // The supplier-side mirror: a name in, the rest of the listing drafted out.
  async function tidyProduct(text) {
    const out = await callAi('tidyProduct', { text });
    if (!out || !out.ok) return null;
    return out;
  }

  // ── Reading a catalogue ───────────────────────────────────────────────
  // The PDF is turned into text HERE, in the browser, and only the text is
  // sent. That keeps a 4MB brochure off the wire, costs nothing to do, and
  // means the Edge Function never has to handle a file upload.
  async function pdfText(file) {
    return (await pdfContent(file)).text;
  }

  // Text AND photographs, both read in the browser.
  //
  // The photographs are the point of a catalogue: a listing without one is half
  // a listing, and re-photographing twenty products a supplier has already shot
  // is the single biggest reason a catalogue never gets typed up.
  //
  // Only the text is sent for interpretation. The pictures stay here, and travel
  // to storage only for the rows the supplier actually keeps.
  async function pdfContent(file) {
    const { PDFParse } = await import('https://cdn.jsdelivr.net/npm/pdf-parse@2.4.5/dist/pdf-parse/web/pdf-parse.es.js');
    PDFParse.setWorker('https://cdn.jsdelivr.net/npm/pdf-parse@2.4.5/dist/pdf-parse/web/pdf.worker.min.mjs');
    // Two independent copies: pdf.js hands the buffer to its worker and detaches
    // it, so a second parser built from the same bytes reads an empty file.
    const buf = await file.arrayBuffer();
    const forText = new Uint8Array(buf.slice(0));
    const forImages = new Uint8Array(buf.slice(0));

    // Text, page by page, so each product can say which page it came from.
    const textParser = new PDFParse({ data: forText });
    const t = await textParser.getText();
    let text = String((t && t.text) || '');
    if (Array.isArray(t && t.pages) && t.pages.length) {
      text = t.pages.map((p, i) => '[page ' + (p.pageNumber || i + 1) + ']\n'
        + String(p.text || '')).join('\n\n');
    }

    let pages = [];
    let photoError = null;
    try {
      const imgParser = new PDFParse({ data: forImages });
      const got = await imgParser.getImage();
      pages = await Promise.all(((got && got.pages) || []).map(async (p) => ({
        page: p.pageNumber,
        photos: (await Promise.all((p.images || [])
          // A catalogue is full of furniture: banner strips, rules, logos,
          // watermarks. A product photograph is reasonably large and roughly
          // rectangular, which separates the two cleanly.
          .filter(im => {
            const w = Number(im.width) || 0, h = Number(im.height) || 0;
            if (Math.min(w, h) < 180) return false;
            const ratio = w / h;
            return ratio > 0.33 && ratio < 2.6;
          })
          .slice(0, 8)
          .map(async im => {
            const full = await shrinkDataUrl(im.dataUrl, 1000);
            if (!full) return null;
            return { full, thumb: (await shrinkDataUrl(full, 150)) || full };
          })))
          .filter(Boolean)
      })));
    } catch (err) {
      // Text alone is still worth having, but say why rather than silently
      // producing a catalogue with no pictures.
      photoError = String((err && err.message) || err).slice(0, 160);
      pages = [];
    }
    return { text, pages: pages.filter(p => p.photos.length), photoError };
  }

  // Re-encodes a page image down to something worth uploading over a Ugandan
  // mobile connection. A catalogue photograph is often 3000px wide and 2MB.
  function shrinkDataUrl(dataUrl, maxSide) {
    return new Promise((resolve) => {
      if (!dataUrl) { resolve(null); return; }
      const img = new Image();
      img.onload = () => {
        try {
          const scale = Math.min(1, maxSide / Math.max(img.width, img.height));
          const c = document.createElement('canvas');
          c.width = Math.round(img.width * scale);
          c.height = Math.round(img.height * scale);
          c.getContext('2d').drawImage(img, 0, 0, c.width, c.height);
          resolve(c.toDataURL('image/jpeg', 0.82));
        } catch (_) { resolve(dataUrl); }
      };
      img.onerror = () => resolve(null);
      img.src = dataUrl;
    });
  }

  // A data URL back to a File, so the existing upload path handles it unchanged.
  function dataUrlToFile(dataUrl, name) {
    const [head, body] = String(dataUrl).split(',');
    const mime = (head.match(/data:([^;]+)/) || [])[1] || 'image/jpeg';
    const bin = atob(body);
    const bytes = new Uint8Array(bin.length);
    for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
    return new File([bytes], name, { type: mime });
  }

  // A brochure in, a list of draft listings out. Nothing is saved: the supplier
  // reviews every row first. Returns null when the feature is not switched on.
  async function readCatalogue(file, onProgress) {
    const say = (m) => { try { if (onProgress) onProgress(m); } catch (_) {} };
    let text = '';
    let pages = [];
    const isPdf = /pdf$/i.test(file.name || '') || file.type === 'application/pdf';
    try {
      say('Reading the file…');
      if (isPdf) {
        const content = await pdfContent(file);
        text = content.text;
        pages = content.pages;
      } else {
        text = await file.text();
      }
    } catch (err) {
      return { error: 'unreadable_file',
        message: 'Could not open that file. A PDF or a plain text price list works best.' };
    }
    if (text.trim().length < 40) {
      return { error: 'no_text',
        message: 'No text found in that file. A scanned photograph cannot be read — a PDF exported from a document can.' };
    }
    say(pages.length
      ? 'Working out what is for sale, and matching the photographs…'
      : 'Working out what is for sale…');
    const out = await callAi('catalogue', { text });
    if (!out) return { error: 'off', message: 'Reading catalogues is not switched on yet.' };
    if (!out.ok) return { error: out.error || 'failed', message: out.message || 'Could not read that catalogue.' };

    // Hand each product the photographs from its own page. Where a page holds
    // several products, they take different pictures in order rather than all
    // defaulting to the first — a page of eight photos and four products should
    // fill four listings, not repeat one. Every candidate stays available, so
    // the supplier can still change any of them.
    const byPage = {};
    pages.forEach(p => { byPage[p.page] = p.photos; });
    const taken = {};
    const products = (out.products || []).map(p => {
      const photos = byPage[p.page] || [];
      const at = taken[p.page] || 0;
      taken[p.page] = at + 1;
      const own = photos[at] || null;
      const shared = !own && photos.length ? photos[0] : null;
      const pick = own || shared;
      return { ...p,
        photos,
        photo: pick ? pick.full : null,
        photoThumb: pick ? pick.thumb : null,
        // borrowed rather than its own: say so, and let the amber flag work
        photoShared: !!shared,
        uncertain: p.uncertain || !!shared,
        note: shared
          ? [p.note, 'Photograph may belong to another product on page ' + p.page + '.']
              .filter(Boolean).join(' ')
          : p.note };
    });
    return { ...out, products,
      photoCount: pages.reduce((n, p) => n + p.photos.length, 0) };
  }

  // Saves the rows the supplier kept, one listing each, and reports what
  // happened per row rather than failing the whole batch on one bad line.
  async function saveCatalogueProducts(rows, opts) {
    const status = (opts && opts.status) || 'draft';
    const done = [];
    for (const r of (rows || [])) {
      try {
        // Description and specification are separate fields for a reason: the
        // description says what the product is, the specification carries the
        // dimensions buyers filter on. It is stored as a spec row, not folded
        // into the description text.
        const saved = await saveProduct({ name: r.name, category_id: r.category_id || null,
          price: Number(r.price) || 0, unit: r.unit || 'unit',
          moq: Number(r.moq) || 1,
          description: r.description || null,
          specs: r.specification ? [{ key: 'Specification', value: r.specification }] : [],
          status });
        // The photograph is uploaded after the row exists, and its failure is
        // reported separately: a listing saved without its picture is still a
        // listing, and telling the supplier which one is missing is more use
        // than losing the row.
        let photoOk = null;
        if (r.photo && saved && saved.id) {
          try {
            await uploadMedia(dataUrlToFile(r.photo, 'catalogue.jpg'),
              { productId: saved.id, kind: 'product' });
            photoOk = true;
          } catch (_) { photoOk = false; }
        }
        done.push({ name: r.name, ok: true, id: saved && saved.id, photo: photoOk });
      } catch (err) {
        done.push({ name: r.name, ok: false, error: String(err.message || err).slice(0, 120) });
      }
    }
    return done;
  }

  async function postRequirement(body) {
    const a = await accountRow();
    const saved = dataOf(await sb.from('requirements').insert({ ...body, buyer_id: a.id }).select().single());
    // Fingerprint it so it reaches suppliers by meaning as well as by word.
    // Deliberately not awaited: a slow or missing Edge Function must never hold
    // up a buyer on a patchy connection.
    if (saved && saved.id) {
      embedRow('requirement', saved.id,
        [saved.title, saved.specification].filter(Boolean).join('. '));
      // Allot the suppliers now, so the buyer's Manage requirements screen has a
      // list the moment they land on it. Awaited: the list IS the next screen.
      try { await sb.rpc('allot_requirement_suppliers', { p_requirement: saved.id }); }
      catch (_) { /* the screen re-tries on open */ }
    }
    return saved;
  }

  // Every requirement the buyer posted, each with its allotted suppliers.
  async function myRequirements() {
    const rows = dataOf(await sb.rpc('my_requirements')) || [];
    return rows.map(r => ({ ...r,
      suppliers: (r.suppliers || []).map(s => ({ ...s,
        photoUrl: s.photo ? mediaUrl(s.photo) : '' })) }));
  }
  // Idempotent — safe to call on every open, and fills a list that was empty
  // because the requirement predates this feature.
  const allotSuppliers = (id) => sb.rpc('allot_requirement_suppliers', { p_requirement: id });
  const rateMatch = (matchId, verdict) =>
    sb.rpc('rate_requirement_match', { p_match: matchId, p_verdict: verdict });
  const closeRequirement = (id) => sb.rpc('close_requirement', { p_requirement: id });
  async function loadDistricts() {
    return (dataOf(await sb.from('districts').select('id,name').order('name')) || []);
  }
  // Product names already on the platform that share a word stem with what the
  // buyer has typed so far.
  async function suggestProducts(query) {
    if (!query || String(query).trim().length < 2) return [];
    // Once there is enough typed to be a phrase rather than a prefix, ask for
    // meaning matches too: "roofing for a store" then also finds iron sheets.
    const q = String(query).trim();
    if (q.length >= 6) {
      try {
        const vector = await embedText(q);
        const rows = dataOf(await sb.rpc('suggest_products_semantic',
          { p_query: q, p_vector: vector })) || [];
        if (rows.length) return rows.map(r => ({ name: r.name, categoryId: r.category_id,
          category: r.category_name || '', suppliers: Number(r.supplier_count || 0),
          byMeaning: !!r.by_meaning }));
      } catch (_) { /* fall through to word matching */ }
    }
    try {
      return (dataOf(await sb.rpc('suggest_products', { p_query: String(query) })) || []).map(r => ({
        name: r.name, categoryId: r.category_id, category: r.category_name || '',
        suppliers: Number(r.supplier_count || 0) }));
    } catch (_) { return []; }
  }
  async function saveQuote(body, send) {
    const a = await accountRow();
    return dataOf(await sb.from('quotes').upsert({ ...body, supplier_id: a.id, state: send ? 'sent' : 'draft' },
      { onConflict: 'requirement_id,supplier_id' }).select().single());
  }
  const sendQuote = body => saveQuote(body, true);

  async function loadBuyerQuoteManager() {
    const a = await accountRow();
    if (!a || a.role !== 'buyer') return { requirements: [], quotes: [], conversations: [] };
    const [requirements, quotes, conversations] = await Promise.all([
      dataOf(await sb.from('requirements').select(REQUIREMENT_COLS + ',categories(name)').eq('buyer_id', a.id).order('created_at', { ascending: false })),
      dataOf(await sb.from('quotes').select('*,supplier:supplier_id(company,phone,district_id)').order('created_at', { ascending: false })),
      loadConversations()
    ]);
    return { requirements: requirements || [], quotes: quotes || [], conversations: conversations || [] };
  }
  async function decideQuote(quoteId, decision) {
    return dataOf(await sb.rpc('decide_quote', { p_quote: quoteId, p_decision: decision }));
  }

  async function loadConversations() {
    const a = await accountRow(); if (!a) return [];
    // Counterparty details come from an RPC: RLS blocks a direct join on
    // accounts, which used to leave the chat header with no name or number.
    try {
      const rows = dataOf(await sb.rpc('my_conversations')) || [];
      return rows.map(c => {
        const o = c.other || {};
        const messages = c.messages || [];
        const last = messages[messages.length - 1];
        return Object.assign([
          o.company || o.trade_name || '', '', o.district_id || '', o.phone || '',
          last?.body || '', c.requirement_title || '',
          c.last_message_at ? new Date(c.last_message_at).toLocaleDateString('en-GB') : ''
        ], { id: c.id, supplierId: c.supplier_id, buyerId: c.buyer_id,
          requirementId: c.requirement_id, requirementTitle: c.requirement_title || '',
          messages, labels: [], other: o, iAmSupplier: !!c.i_am_supplier });
      });
    } catch (_) { /* fall through to the direct query below */ }
    const rows = dataOf(await sb.from('conversations').select(`*,buyer:buyer_id(company,phone,district_id),
      supplier:supplier_id(company,phone,district_id),requirement:requirement_id(title),
      messages(id,sender_id,direction,channel,body,sent_at,read_at)`).order('last_message_at', { ascending: false })) || [];
    return rows.map(c => {
      const other = a.id === c.buyer_id ? c.supplier : c.buyer;
      const messages = (c.messages || []).sort((x, y) => String(x.sent_at).localeCompare(String(y.sent_at)));
      const last = messages[messages.length - 1];
      return Object.assign([other?.company || '', '', other?.district_id || '', other?.phone || '',
        last?.body || '', c.requirement?.title || '', c.last_message_at ? new Date(c.last_message_at).toLocaleDateString('en-GB') : ''],
        { id: c.id, supplierId: c.supplier_id, buyerId: c.buyer_id, requirementId: c.requirement_id,
          requirementTitle: c.requirement?.title || '', messages, labels: c.labels || [], other });
    });
  }
  async function loadTenders() {
    const rows = dataOf(await sb.from('tenders').select('*,categories(name,parent_id)').order('created_at',{ascending:false})) || [];
    return Promise.all(rows.map(async t => {
      let downloadUrl='';
      if(t.document_path){ const s=await sb.storage.from('media').createSignedUrl(t.document_path,900,{download:(t.document_path.split('/').pop()||'tender.pdf')}); downloadUrl=s.error?'':s.data.signedUrl; }
      return {...t,downloadUrl};
    }));
  }
  async function loadSupplierHistory() {
    const a=await accountRow(); if(!a||a.role!=='supplier') return {conversations:[],quotes:[]};
    const [conversations,quotes]=await Promise.all([
      loadConversations(),
      dataOf(await sb.from('quotes').select('*,requirements(title,buyer_id,accounts!requirements_buyer_id_fkey(company))').eq('supplier_id',a.id).order('created_at',{ascending:false}))
    ]);
    return {conversations:conversations||[],quotes:quotes||[]};
  }
  async function sendMessage(conversationId, body) {
    const a = await accountRow();
    return dataOf(await sb.from('messages').insert({ conversation_id: conversationId, sender_id: a.id,
      direction: 'out', channel: 'app', body: String(body).trim() }).select().single());
  }
  async function startConversation(supplierId, requirementId) {
    const a = await accountRow();
    if (!a || a.role !== 'buyer') throw new Error('Buyer account required');
    return dataOf(await sb.from('conversations').upsert({ supplier_id: supplierId, buyer_id: a.id,
      requirement_id: requirementId || null }, { onConflict: 'supplier_id,buyer_id,requirement_id' }).select().single());
  }
  function subscribeConversation(id, fn) {
    return sb.channel('conversation:' + id).on('postgres_changes', { event: 'INSERT', schema: 'public',
      table: 'messages', filter: 'conversation_id=eq.' + id }, p => fn(p.new)).subscribe();
  }

  const registerBuyer = async profile => dataOf(await sb.rpc('create_buyer_profile', profile));
  async function loadProductInterests() {
    const a=await accountRow();
    if (!a || a.role!=='buyer') return [];
    return dataOf(await sb.from('product_interests').select('*').eq('buyer_id',a.id).order('created_at',{ascending:false}));
  }
  async function loadProductInterestNotifications() {
    const a=await accountRow();
    if (!a || a.role!=='buyer') return [];
    return dataOf(await sb.from('product_interest_notifications').select('*').eq('buyer_id',a.id).order('created_at',{ascending:false}).limit(100));
  }
  async function addProductInterest(productId) {
    const a=await accountRow();
    if (!a || a.role!=='buyer') throw new Error('Buyer account required');
    return dataOf(await sb.from('product_interests').upsert({buyer_id:a.id,product_id:productId,
      notifications_enabled:true,updated_at:new Date().toISOString()},{onConflict:'buyer_id,product_id'}).select().single());
  }
  async function removeProductInterest(productId) {
    const a=await accountRow();
    if (!a || a.role!=='buyer') throw new Error('Buyer account required');
    dataOf(await sb.from('product_interests').delete().eq('buyer_id',a.id).eq('product_id',productId));
    return true;
  }
  const submitSupplierApplication = async profile => dataOf(await sb.rpc('submit_supplier_application', profile));
  async function updateProfile(body) {
    const a = await accountRow();
    return dataOf(await sb.from('accounts').update(body).eq('id', a.id).select().single());
  }
  async function saveSupplierProfile(payload) {
    const a = await accountRow();
    if (!a || a.role !== 'supplier') throw new Error('Supplier account required');
    const accountFields = ['company','trade_name','email','phone','alt_phone','alt_email','landline','address','district_id',
      'about','coverage','nature_of_business','staff_count','turnover','brands','legal_form','warehouse','fleet','banker',
      'payment_terms','memberships','certifications'];
    const accountPatch = {};
    accountFields.forEach(k => { if (Object.prototype.hasOwnProperty.call(payload, k)) accountPatch[k] = payload[k] || null; });
    if (Object.keys(accountPatch).length) dataOf(await sb.from('accounts').update(accountPatch).eq('id', a.id));
    const registrationFields = ['ursb_number','tin','trading_licence','director_nin','vat_number'];
    const registrationPatch = {};
    registrationFields.forEach(k => { if (Object.prototype.hasOwnProperty.call(payload, k)) registrationPatch[k] = payload[k] || null; });
    if (Object.keys(registrationPatch).length) dataOf(await sb.from('account_registration').update(registrationPatch).eq('account_id', a.id));
    if (Object.prototype.hasOwnProperty.call(payload, 'full_name') || Object.prototype.hasOwnProperty.call(payload, 'role_title')) {
      const existing = dataOf(await sb.from('account_users').select('id').eq('account_id', a.id).limit(1)) || [];
      const staffPatch = { account_id:a.id, full_name:payload.full_name || null, role_title:payload.role_title || null };
      if (existing[0]) dataOf(await sb.from('account_users').update(staffPatch).eq('id', existing[0].id));
      else dataOf(await sb.from('account_users').insert(staffPatch));
    }
    if (Array.isArray(payload.category_ids)) {
      dataOf(await sb.from('account_categories').delete().eq('account_id', a.id));
      if (payload.category_ids.length) dataOf(await sb.from('account_categories').insert(
        payload.category_ids.map(category_id => ({ account_id:a.id, category_id }))));
    }
    for (const [key, method] of [['mtn_momo','mtn_momo'],['airtel_money','airtel_money'],['bank_transfer','bank_transfer']]) {
      if (!Object.prototype.hasOwnProperty.call(payload,key)) continue;
      dataOf(await sb.from('payout_methods').delete().eq('account_id',a.id).eq('method',method));
      if (String(payload[key]||'').trim()) dataOf(await sb.from('payout_methods').insert({ account_id:a.id, method,
        detail:String(payload[key]).trim(), state:'unverified', is_default:method==='mtn_momo' }));
    }
    return loadAccount();
  }

  async function loadSupplierDashboard() {
    const a = await accountRow();
    if (!a || a.role !== 'supplier') return null;
    const [productResult, conversationResult, quoteResult, purchaseResult] = await Promise.all([
      sb.from('products').select('id,rating,view_count,status,created_at').eq('supplier_id', a.id),
      sb.from('conversations').select('id,created_at,last_message_at,messages(id,sender_id,read_at,sent_at)').eq('supplier_id', a.id),
      sb.from('quotes').select('id,state,created_at').eq('supplier_id', a.id),
      sb.from('lead_purchases').select('id,purchased_at,payment_amount,payment_state').eq('supplier_id', a.id)
    ]);
    const products = productResult.error ? [] : productResult.data || [];
    const conversations = conversationResult.error ? [] : conversationResult.data || [];
    const quotes = quoteResult.error ? [] : quoteResult.data || [];
    const purchases = purchaseResult.error ? [] : (purchaseResult.data || [])
      .filter(p => p.payment_state !== 'payment_required');
    const messages = conversations.flatMap(c => c.messages || []);
    const ratings = products.map(p => Number(p.rating)).filter(n => Number.isFinite(n) && n > 0);
    const months = [];
    const leadMonths = [];
    const now = new Date();
    for (let i = 8; i >= 0; i--) {
      const start = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - i, 1));
      const end = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - i + 1, 1));
      const inRange = (v) => { const d = new Date(v); return d >= start && d < end; };
      months.push({ label:start.toLocaleDateString('en-GB',{month:'short',year:'2-digit'}),
        count:conversations.filter(c => inRange(c.created_at)).length });
      if (i < 6) leadMonths.push({
        label: start.toLocaleDateString('en-GB', { month: 'short' }),
        full: start.toLocaleDateString('en-GB', { month: 'long', year: 'numeric' }),
        count: purchases.filter(p => p.purchased_at && inRange(p.purchased_at)).length,
        spent: purchases.filter(p => p.purchased_at && inRange(p.purchased_at))
          .reduce((s, p) => s + Number(p.payment_amount || 0), 0),
        quotes: quotes.filter(q => inRange(q.created_at)).length
      });
    }
    return {
      enquiries:conversations.length, messages:messages.length,
      unreadMessages:messages.filter(m => m.sender_id !== a.id && !m.read_at).length,
      storefrontViews:products.reduce((n,p)=>n+Number(p.view_count||0),0), catalogProducts:products.length,
      publishedProducts:products.filter(p=>p.status==='published').length, quotesSent:quotes.filter(q=>q.state==='sent').length,
      ratingCount:ratings.length, averageRating:ratings.length ? ratings.reduce((x,y)=>x+y,0)/ratings.length : 0,
      monthlyEnquiries:months, monthlyLeads:leadMonths,
      leadsBought:purchases.length,
      leadSpend:purchases.reduce((s,p)=>s+Number(p.payment_amount||0),0)
    };
  }
  async function purchasePlan(planCode, method, phone) {
    return dataOf(await sb.rpc('start_plan_purchase', { p_plan_code: planCode, p_method: method, p_phone: phone }));
  }

  const admin = {
    async applications() {
      const apps = dataOf(await sb.rpc('admin_application_directory')) || [];
      return Promise.all(apps.map(async app => {
        const documents=await Promise.all((app.documents||[]).map(async d=>{
          if(!d.storage_path) return {...d,filename:d.reference||String(d.kind||'document'),downloadUrl:''};
          const filename=d.reference||d.storage_path.split('/').pop()||'document';
          const signed=await sb.storage.from('media').createSignedUrl(d.storage_path,900,{download:filename});
          return {...d,filename,downloadUrl:signed.error?'':signed.data.signedUrl};
        }));
        return {...app,documents,accounts:{...(app.account||{}),account_registration:app.registration||{},documents,categories:app.categories||[]}};
      }));
    },
    approve: id => sb.rpc('approve_application', { p_app: id }),
    reject: (id, reason) => sb.rpc('reject_application', { p_app: id, p_reason: reason }),
    members: async () => dataOf(await sb.rpc('admin_member_directory')) || [],
    // Full record for one member, with every storage path turned into a usable URL.
    async member(accountId) {
      const d = dataOf(await sb.rpc('admin_member_detail', { p_account: accountId }));
      if (!d) return null;
      const sign = async (path, filename) => {
        if (!path) return '';
        try {
          if (isDirectUrl(path)) return path;
          const opts = filename ? { download: filename } : undefined;
          return dataOf(await sb.storage.from('media').createSignedUrl(path, 900, opts))?.signedUrl || '';
        } catch (_) { return ''; }
      };
      const documents = await Promise.all((d.documents || []).map(async doc => {
        const filename = doc.reference || (doc.storage_path || '').split('/').pop() || 'document';
        const [downloadUrl, viewUrl] = await Promise.all([
          sign(doc.storage_path, filename), sign(doc.storage_path)
        ]);
        return { ...doc, filename, downloadUrl, viewUrl };
      }));
      const products = await Promise.all((d.products || []).map(async p => {
        const photos = (await Promise.all((p.photos || []).slice(0, 4).map(x => sign(x)))).filter(Boolean);
        const docName = (p.document_path || '').split('/').pop() || 'document.pdf';
        return { ...p, photos,
          documentUrl: await sign(p.document_path, docName),
          documentName: p.document_path ? docName : '' };
      }));
      return { ...d, documents, products };
    },
    catalogAnalytics: async () => {
      const [products, requirements, categories] = await Promise.all([
        dataOf(await sb.from('products').select('id,name,status,category_id,supplier_id,view_count,order_count,accounts!products_supplier_id_fkey(company),categories(name,parent_id)')),
        dataOf(await sb.from('requirements').select('id,category_id,state,created_at')),
        loadCategories()
      ]);
      const supplierSets = {};
      (products || []).forEach(p => { (supplierSets[p.category_id] ||= new Set()).add(p.supplier_id); });
      const categoryRows = (categories || []).map(c => ({ ...c,
        productCount: (products || []).filter(p => p.category_id === c.id).length,
        supplierCount: (supplierSets[c.id] || new Set()).size,
        leadCount: (requirements || []).filter(r => r.category_id === c.id).length
      }));
      const productRows = (products || []).map(p => ({ ...p,
        leadCount: (requirements || []).filter(r => r.category_id === p.category_id).length
      }));
      return { products: productRows, categories: categoryRows };
    },
    categories: loadCategories,
    enquiries: async () => (dataOf(await sb.rpc('admin_finance_enquiries')) || []),
    setEnquiryState: (id, state) => sb.rpc('set_finance_enquiry_state', { p_id: id, p_state: state }),
    logistics: async () => (dataOf(await sb.rpc('admin_logistics_requests')) || []),
    setLogisticsState: (id, state) => sb.rpc('set_logistics_state', { p_id: id, p_state: state }),
    saveCategory: async row => dataOf(await sb.from('categories').upsert(row).select().single()),
    // Category artwork lives in the public bucket so anonymous visitors can see it.
    async uploadCategoryImage(file, slug) {
      const ext = String(file.name || '').split('.').pop().toLowerCase() || 'png';
      const path = 'categories/' + (slug || 'category') + '-' + Date.now() + '.' + ext;
      dataOf(await sb.storage.from('public-media').upload(path, file, {
        contentType: file.type || undefined, upsert: true }));
      return sb.storage.from('public-media').getPublicUrl(path).data.publicUrl;
    },
    saveTender: async row => { const a=await accountRow(); return dataOf(await sb.from('tenders').insert({...row,created_by:a.id}).select().single()); },
    plans: async () => dataOf(await sb.from('plans').select('*').eq('active', true).order('price'))
  };

  // ── Social video links ──────────────────────────────────────────────────
  // A pasted TikTok, Instagram, YouTube or Facebook link is stored as a media
  // row whose storage_path is the URL itself: mediaUrl and the signing helper
  // both pass an http(s) path through untouched, so no new table or policy is
  // needed and the row cascades away with its product.
  //
  // Instagram and TikTok do not publish a thumbnail to third parties, so only
  // YouTube gets a real poster frame. The UI covers the rest with the listing's
  // own photo behind a play button.
  function videoInfo(url, id) {
    const raw = String(url || '').trim();
    if (!/^https?:\/\//i.test(raw)) return null;
    let m;
    if ((m = raw.match(/instagram\.com\/(?:reel|reels|p|tv)\/([A-Za-z0-9_-]+)/i)))
      return { id, url: raw, platform: 'Instagram', key: m[1],
        embed: 'https://www.instagram.com/reel/' + m[1] + '/embed/', thumb: '', tall: true };
    if ((m = raw.match(/tiktok\.com\/(?:@[\w.-]+\/video|v|embed(?:\/v2)?)\/(\d+)/i)))
      return { id, url: raw, platform: 'TikTok', key: m[1],
        embed: 'https://www.tiktok.com/embed/v2/' + m[1], thumb: '', tall: true };
    if (/(?:vm|vt)\.tiktok\.com\//i.test(raw))
      return { id, url: raw, platform: 'TikTok', key: '', embed: '', thumb: '', tall: true };
    if ((m = raw.match(/(?:youtube\.com\/(?:watch\?v=|shorts\/|embed\/)|youtu\.be\/)([A-Za-z0-9_-]{6,})/i)))
      return { id, url: raw, platform: 'YouTube', key: m[1],
        embed: 'https://www.youtube.com/embed/' + m[1] + '?rel=0&playsinline=1',
        thumb: 'https://img.youtube.com/vi/' + m[1] + '/hqdefault.jpg',
        tall: /shorts\//i.test(raw) };
    if (/facebook\.com\/|fb\.watch\//i.test(raw))
      return { id, url: raw, platform: 'Facebook', key: '',
        embed: 'https://www.facebook.com/plugins/video.php?href=' + encodeURIComponent(raw) + '&show_text=false',
        thumb: '', tall: false };
    if (/\.(mp4|webm|mov)(\?|$)/i.test(raw))
      return { id, url: raw, platform: 'Video', key: '', embed: raw, thumb: '', tall: false, file: true };
    return { id, url: raw, platform: 'Link', key: '', embed: '', thumb: '', tall: false };
  }
  async function addProductVideo(productId, url) {
    const info = videoInfo(url);
    if (!info) throw new Error('That does not look like a video link.');
    if (info.platform === 'Link') throw new Error('Paste a TikTok, Instagram, YouTube or Facebook video link.');
    const a = await accountRow();
    const row = dataOf(await sb.from('media').insert({ account_id: a.id, product_id: productId,
      kind: 'video', storage_path: info.url, caption: info.platform, approved: true })
      .select().single());
    return videoInfo(row.storage_path, row.id);
  }
  const removeProductVideo = async id => dataOf(await sb.from('media').delete().eq('id', id));

  async function uploadMedia(file, { productId = null, kind = 'product' } = {}) {
    const a = await accountRow();
    const folder = kind === 'company' ? 'company' : kind === 'document' ? 'documents' : 'products';
    const path = folder + '/' + a.id + '/' + crypto.randomUUID() + '-' + String(file.name).replace(/[^a-zA-Z0-9._-]/g, '-');
    dataOf(await sb.storage.from('media').upload(path, file));
    // A supplier's own listing photos are their content, not something waiting on
    // moderation: media_read hides unapproved rows from everyone but the uploader,
    // so leaving these false makes the photo invisible to every buyer.
    const row = dataOf(await sb.from('media').insert({ account_id: a.id, product_id: productId,
      kind, storage_path: path, caption: file.name,
      approved: kind !== 'document' }).select().single());
    return { ...row, url: kind === 'document' ? '' : mediaUrl(path) };
  }
  async function uploadDocument(file, kind) {
    const a = await accountRow();
    const path = 'documents/' + a.id + '/' + crypto.randomUUID() + '-' + String(file.name).replace(/[^a-zA-Z0-9._-]/g, '-');
    dataOf(await sb.storage.from('media').upload(path, file));
    return dataOf(await sb.from('documents').insert({ account_id: a.id, kind: kind || 'other',
      reference: file.name, storage_path: path, state: 'pending' }).select().single());
  }

  async function myRatingsSafe() {
    try { return dataOf(await sb.rpc('my_ratings')); }
    catch (_) { return { mine: null, received: [], ratable: [] }; }
  }

  async function bootstrap() {
    const session = await auth.session();
    const categories = await loadCategories().catch(() => []);
    const districts = await loadDistricts().catch(() => []);
    if (!session) return { signedIn: false, account: null, categories, districts, products: await searchProducts({}).catch(() => []) };
    const account = await loadAccount();
    if (!account) return { signedIn: true, account: null, products: [], ownProducts: [], orders: [], conversations: [], leads: [] };
    const [products, ownProducts, conversations, leads, dashboard, leadCredit, buyerQuoteManager, adminMembers, adminAnalytics, tenders, ratings, supplierHistory, productInterests, interestNotifications, buyerNotifications] = await Promise.all([
      searchProducts({}).catch(() => []), account.role === 'supplier' ? searchProducts({ mine: true }).catch(() => []) : [],
      loadConversations().catch(() => []), account.role === 'supplier' ? myBuyLeads().catch(() => []) : [],
      account.role === 'supplier' ? loadSupplierDashboard().catch(() => null) : null,
      account.role === 'supplier' ? leadBalance().catch(() => null) : null,
      account.role === 'buyer' ? loadBuyerQuoteManager().catch(() => ({ requirements: [], quotes: [], conversations: [] })) : null,
      account.role === 'admin' ? admin.members().catch(() => []) : [],
      account.role === 'admin' ? admin.catalogAnalytics().catch(() => ({ products:[], categories:[] })) : { products:[], categories:[] },
      loadTenders().catch(()=>[]),
      myRatingsSafe(),
      account.role === 'supplier' ? loadSupplierHistory().catch(()=>({conversations:[],quotes:[]})) : {conversations:[],quotes:[]},
      account.role === 'buyer' ? loadProductInterests().catch(()=>[]) : [],
      account.role === 'buyer' ? loadProductInterestNotifications().catch(()=>[]) : [],
      account.role === 'buyer' ? loadBuyerNotifications().catch(()=>[]) : []
    ]);
    return { signedIn: true, account, categories, districts, products, ownProducts, orders: [], conversations, leads, dashboard, leadCredit, buyerQuoteManager, adminMembers, adminAnalytics, tenders, ratings, supplierHistory, productInterests, interestNotifications, buyerNotifications };
  }

  window.BUBU_API = { client: sb, auth, bootstrap, loadAccount, loadCategories, searchProducts, productsInCategory, productById, saveProduct,
    setProductStatus, deleteProduct, offersFor, revealContact, submitProductQuoteRequest, revealSupplierContact,
    loadSupplierProfile, startSupplierConversation, loadBuyerNotifications, leadBalance, purchaseLead, myBuyLeads, postRequirement,
    loadDistricts, suggestProducts, submitFinanceEnquiry, supplierProfile, listingsForProduct,
    myRequirements, allotSuppliers, rateMatch, closeRequirement, submitLogisticsRequest,
    myCapabilities, applyToSell, decideSeller, myLeadBoard, categoryDemand, similarProducts,
    tidyRequirement, tidyProduct, readCatalogue, saveCatalogueProducts, pdfContent,
    embedBacklog, embedRow, embedText,
    myRatings: async () => { try { return dataOf(await sb.rpc('my_ratings')); }
      catch (_) { return { mine: null, received: [], ratable: [] }; } },
    rateSupplier: async (supplierId, rating, body) => dataOf(await sb.rpc('rate_supplier',
      { p_supplier: supplierId, p_rating: Number(rating), p_body: body || null })),
    rateBuyer: async (buyerId, rating, body) => dataOf(await sb.rpc('rate_buyer',
      { p_buyer: buyerId, p_rating: Number(rating), p_body: body || null })),
    saveQuote, sendQuote, loadBuyerQuoteManager, decideQuote, loadOrders: async () => [], loadConversations, startConversation, sendMessage,
    subscribeConversation, registerBuyer, submitSupplierApplication, updateProfile, saveSupplierProfile, loadSupplierDashboard,
    purchasePlan, admin, uploadMedia, uploadDocument, mediaUrl,
    videoInfo, addProductVideo, removeProductVideo, loadProductInterests, loadProductInterestNotifications, addProductInterest, removeProductInterest,
    createCatalogCategory: (name, parentId) => dataOf(sb.rpc('create_catalog_category', { p_name:name, p_parent_id:parentId || null })) };
})();

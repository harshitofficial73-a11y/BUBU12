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
  const money = n => 'UGX ' + Number(n || 0).toLocaleString('en-UG');
  const mediaUrl = path => !path ? '' : /^https?:/i.test(path) ? path
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

  async function searchProducts({ query = '', category = null, mine = false, limit = 100 } = {}) {
    let q = sb.from('products').select(`*,categories(name,parent_id),accounts!products_supplier_id_fkey(company,district_id),
      media(storage_path,approved,kind,caption),product_specs(key,value,sort)`).order('updated_at', { ascending: false }).limit(limit);
    if (mine) { const a = await accountRow(); if (!a) return []; q = q.eq('supplier_id', a.id); }
    else q = q.eq('status', 'published');
    if (query) q = q.ilike('name', '%' + query.replace(/[%_]/g, '') + '%');
    if (category) q = q.eq('category_id', category);
    const rows = dataOf(await q) || [];
    return Promise.all(rows.map(async p => {
      const sign = async (item, opts) => {
        const path = item?.storage_path || '';
        if (!path || /^https?:/i.test(path)) return path;
        try { return dataOf(await sb.storage.from('media').createSignedUrl(path, 3600, opts))?.signedUrl || ''; }
        catch (_) { return ''; }
      };
      // A listing carries up to four photos; the first is the one search shows.
      const photoItems = (p.media || []).filter(m => m.kind === 'product').slice(0, 4);
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
      photo, img: photo, photos, pdf, pdfDownload, pdfName,
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
    return saved;
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
  async function loadSupplierProfile(supplierId) {
    return dataOf(await sb.rpc('load_public_supplier_profile', { p_supplier: supplierId }));
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
        qty: r.quantity + ' ' + r.quantity_unit,
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
        cat: r.category_id, qty: r.quantity + ' ' + r.quantity_unit, loc: r.district_id,
        neededBy: r.needed_by, value: money(r.estimated_value), spec: r.specification,
        deliverTo: r.deliver_to, estimatedValue: Number(r.estimated_value || 0),
        purpose: r.purpose, createdAt: r.created_at, purchased: false, buyer: {} }));
    }
  }
  async function postRequirement(body) {
    const a = await accountRow();
    return dataOf(await sb.from('requirements').insert({ ...body, buyer_id: a.id }).select().single());
  }
  async function loadDistricts() {
    return (dataOf(await sb.from('districts').select('id,name').order('name')) || []);
  }
  // Product names already on the platform that share a word stem with what the
  // buyer has typed so far.
  async function suggestProducts(query) {
    if (!query || String(query).trim().length < 2) return [];
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
      dataOf(await sb.from('requirements').select('*,categories(name)').eq('buyer_id', a.id).order('created_at', { ascending: false })),
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
    const [productResult, conversationResult, quoteResult] = await Promise.all([
      sb.from('products').select('id,rating,view_count,status,created_at').eq('supplier_id', a.id),
      sb.from('conversations').select('id,created_at,last_message_at,messages(id,sender_id,read_at,sent_at)').eq('supplier_id', a.id),
      sb.from('quotes').select('id,state,created_at').eq('supplier_id', a.id)
    ]);
    const products = productResult.error ? [] : productResult.data || [];
    const conversations = conversationResult.error ? [] : conversationResult.data || [];
    const quotes = quoteResult.error ? [] : quoteResult.data || [];
    const messages = conversations.flatMap(c => c.messages || []);
    const ratings = products.map(p => Number(p.rating)).filter(n => Number.isFinite(n) && n > 0);
    const months = [];
    const now = new Date();
    for (let i = 8; i >= 0; i--) {
      const start = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - i, 1));
      const end = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - i + 1, 1));
      months.push({ label:start.toLocaleDateString('en-GB',{month:'short',year:'2-digit'}),
        count:conversations.filter(c => { const d=new Date(c.created_at); return d>=start && d<end; }).length });
    }
    return {
      enquiries:conversations.length, messages:messages.length,
      unreadMessages:messages.filter(m => m.sender_id !== a.id && !m.read_at).length,
      storefrontViews:products.reduce((n,p)=>n+Number(p.view_count||0),0), catalogProducts:products.length,
      publishedProducts:products.filter(p=>p.status==='published').length, quotesSent:quotes.filter(q=>q.state==='sent').length,
      ratingCount:ratings.length, averageRating:ratings.length ? ratings.reduce((x,y)=>x+y,0)/ratings.length : 0,
      monthlyEnquiries:months
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

  window.BUBU_API = { client: sb, auth, bootstrap, loadAccount, loadCategories, searchProducts, saveProduct,
    setProductStatus, deleteProduct, offersFor, revealContact, submitProductQuoteRequest, revealSupplierContact,
    loadSupplierProfile, startSupplierConversation, loadBuyerNotifications, leadBalance, purchaseLead, myBuyLeads, postRequirement,
    loadDistricts, suggestProducts,
    myRatings: async () => { try { return dataOf(await sb.rpc('my_ratings')); }
      catch (_) { return { mine: null, received: [], ratable: [] }; } },
    rateSupplier: async (supplierId, rating, body) => dataOf(await sb.rpc('rate_supplier',
      { p_supplier: supplierId, p_rating: Number(rating), p_body: body || null })),
    rateBuyer: async (buyerId, rating, body) => dataOf(await sb.rpc('rate_buyer',
      { p_buyer: buyerId, p_rating: Number(rating), p_body: body || null })),
    saveQuote, sendQuote, loadBuyerQuoteManager, decideQuote, loadOrders: async () => [], loadConversations, startConversation, sendMessage,
    subscribeConversation, registerBuyer, submitSupplierApplication, updateProfile, saveSupplierProfile, loadSupplierDashboard,
    purchasePlan, admin, uploadMedia, uploadDocument, mediaUrl, loadProductInterests, loadProductInterestNotifications, addProductInterest, removeProductInterest,
    createCatalogCategory: (name, parentId) => dataOf(sb.rpc('create_catalog_category', { p_name:name, p_parent_id:parentId || null })) };
})();

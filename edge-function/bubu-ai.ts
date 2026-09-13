// BUBU.Market — the one server-side file.
//
// Deploy this in Supabase: Dashboard → Edge Functions → Deploy a new function,
// name it exactly  bubu-ai  , paste this file, deploy.
//
// It does two jobs, and only one of them needs an API key.
//
//   embed   Turns a phrase into a meaning fingerprint. Runs on a small model
//           built into Supabase itself — NO API KEY, NO PER-CALL CHARGE. This
//           is what powers lead matching by meaning.
//
//   tidy    Turns what a buyer typed into a proper requirement: quantity,
//           unit, category, district, specification. Needs ANTHROPIC_API_KEY.
//           Set it under Edge Functions → Secrets.
//
// If the key is missing, embed keeps working and tidy returns a plain message
// saying so. Nothing else in the platform is affected either way.
//
// The caller's session is verified on every request. Without that check anyone
// on the internet could point at this endpoint and spend your money.

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS'
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status, headers: { ...CORS, 'Content-Type': 'application/json' }
  });

// The fingerprint model, loaded once and reused across requests.
// @ts-ignore — Supabase.ai is provided by the Edge runtime.
const embedder = new Supabase.ai.Session('gte-small');

// Pinned rather than "-latest": the alias is not resolvable on every account
// and fails with a 404 that looks like an outage. One place to change it.
const MODEL = 'claude-haiku-4-5-20251001';

// A trader typing on a phone is brief and mixes in Luganda trade words. The
// model is told to read them as the trade terms they are, and — this matters —
// to leave anything it was not told blank rather than inventing it. A guessed
// quantity or price is worse than an empty field, because nobody knows to
// correct it.
const SYSTEM = `You clean up purchase requirements on BUBU.Market, a wholesale trade platform in Uganda.

A buyer types something short and rough. Turn it into structured fields.

RULES, in order of importance:
1. Never invent a number. If the buyer did not state a quantity, a budget or a
   date, leave that field null. Guessing costs a trader real money.
2. Ugandan and Luganda trade words are normal vocabulary, not noise. Read them:
   mabaati = iron sheets, simsim = sesame, posho/maize flour, matoke = bananas,
   nkejje, jerrycan, kaveera = polythene, mukene, ballast, murram, hardcore,
   g-nuts = groundnuts, sacco, boda. Keep the buyer's own word in the title.
3. Units are what Ugandan trade actually uses: bag, sheet, tonne, kg, litre,
   piece, roll, box, jerrycan, trip, carton, bundle, metre.
4. The title stays close to what they typed. Correct spelling and capitalise
   properly; do not rewrite it into marketing language or add adjectives.
5. Write the specification as the buyer would say it to a supplier. If they gave
   no detail at all, leave it null rather than padding it out.

Reply with JSON only, no prose, in exactly this shape:
{"title":string,"quantity":number|null,"unit":string|null,"category":string|null,
 "district":string|null,"specification":string|null,"budget":number|null,
 "notes":string|null}

category must be exactly one of the names given to you, or null.
district must be exactly one of the district names given to you, or null.
budget is a per-unit figure in UGX, digits only.
notes is one short sentence for the buyer about anything you could not work out
— or null if everything was clear.`;

const SYSTEM_PRODUCT = `You clean up product listings on BUBU.Market, a wholesale trade platform in Uganda.

A supplier types the name of something they sell, briefly and roughly. Draft the
rest of the listing for them to check.

RULES, in order of importance:
1. NEVER invent a price. If the supplier did not state one, leave it null. A
   made-up price on a wholesale listing loses a trader real money.
2. Ugandan and Luganda trade words are normal vocabulary, not noise. Read them:
   mabaati = iron sheets, simsim = sesame, posho/maize flour, matoke = bananas,
   g-nuts = groundnuts, kaveera = polythene, ballast, murram, hardcore,
   jerrycan, trip. Keep the supplier's own word in the name.
3. The unit MUST be exactly one of these, singular: bag, bar, sheet, piece,
   unit, tonne, kg, litre, carton, box, roll, bundle, jerrycan, trip, metre.
   Nothing else — the supplier's form can only show these.
4. The name stays close to what they typed — corrected spelling and proper
   capitalisation, not marketing language and no invented adjectives.
5. The description is two or three plain sentences a buyer can act on: what it
   is, the grade or size if they gave one, and how it is supplied. Never claim
   a certification, a standard or an origin the supplier did not state.
6. A sensible minimum order for that kind of goods sold wholesale. If you have
   no idea, leave it null.

Reply with JSON only, no prose, in exactly this shape:
{"name":string,"category":string|null,"unit":string|null,"moq":number|null,
 "brand":string|null,"price":number|null,"description":string|null,
 "notes":string|null}

category must be exactly one of the names given to you, or null.
price is per unit in UGX, digits only, and only if the supplier stated it.
notes is one short sentence about anything you could not work out, or null.`;

const SYSTEM_CATALOGUE = `You read wholesale product catalogues from Uganda and list what is for sale.

The text comes from a PDF, so it arrives jumbled: prices in one block, names in
another, specifications in a third. Piece them back together.

RULES, in order of importance:
1. Only list something you can actually see in the text. Never pad the list out
   to look thorough. Twelve real products beat twenty with eight invented.
2. Never guess a price. If you cannot tell which price belongs to which product,
   leave that price null and say so in the note for that row. A wrong price on a
   wholesale listing costs the supplier real money.
3. Where the layout is ambiguous — several prices listed together, several names
   listed together — match them in the order they appear, and set "uncertain" to
   true on every row you had to guess at. The supplier checks each row, so
   flagging doubt is far more useful than hiding it.
4. Skip anything that is not a product for sale: company history, quality
   standards, harvesting practices, FAQs, contact details, page furniture.
5. The name is what a buyer would search for. Keep the supplier's own product
   name; do not translate a species name into a generic one.
6. Two separate fields, and do not merge them:
   specification is the technical line only — dimensions, grades, treatments,
   tolerances. "Length 6m, diameter 80-120mm, treated with 10% boron salts."
   description is what the product is and what it is used for, in one or two
   plain sentences a buyer would understand. Leave it null rather than
   restating the specification in words.
7. Units are what Ugandan wholesale uses: pole, piece, sheet, bag, tonne, kg,
   litre, metre, sqm, unit. Use sqm for anything priced per square metre.
8. Prices are UGX. Ugandan and European catalogues both write 30.000 to mean
   thirty thousand — read a dot or a comma as a thousands separator, never as a
   decimal point.

9. The text is marked with [page N] before each page. Record which page each
   product appears on — that is how its photograph is found, so the page number
   matters as much as the name.

Reply with JSON only, no prose:
{"products":[{"name":string,"category":string|null,"price":number|null,
  "unit":string|null,"moq":number|null,"specification":string|null,
  "uncertain":boolean,"note":string|null,"page":number|null}],
 "skipped":string|null,"summary":string|null}

category must be exactly one of the names given to you, or null.
skipped: one short sentence on what you left out and why.
summary: one short sentence on what the supplier should check first.`;

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: CORS });

  try {
    // ── who is calling ────────────────────────────────────────────────
    const auth = req.headers.get('Authorization') ?? '';
    if (!auth.startsWith('Bearer ')) return json({ error: 'Sign in first' }, 401);

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_ANON_KEY')!,
      { global: { headers: { Authorization: auth } } }
    );
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    if (authError || !user) return json({ error: 'Sign in first' }, 401);

    const body = await req.json().catch(() => ({}));
    const action = String(body.action || '');

    // ── embed: free, no key ───────────────────────────────────────────
    if (action === 'embed') {
      const texts: string[] = Array.isArray(body.texts)
        ? body.texts.map((t: unknown) => String(t || '').slice(0, 2000))
        : [String(body.text || '').slice(0, 2000)];

      const vectors: (number[] | null)[] = [];
      for (const t of texts) {
        if (!t.trim()) { vectors.push(null); continue; }
        const v = await embedder.run(t, { mean_pool: true, normalize: true });
        vectors.push(v as number[]);
      }
      return json({ vectors, dimensions: 384 });
    }

    // ── ask: the next questions for a requirement ─────────────────────
    //
    // A buyer naming "cement" and one naming "octagonal poles" need different
    // questions asked of them. Quantity and district are the same either way;
    // grade, length, class and treatment are not. Asking the right three or
    // four is what makes quotes comparable instead of a conversation.
    //
    // Called with the product name and whatever has been answered so far, and
    // answers with the NEXT batch — so an answer can change what comes next.
    if (action === 'ask') {
      const key = Deno.env.get('ANTHROPIC_API_KEY');
      const product = String(body.product || '').slice(0, 160).trim();
      if (!product) return json({ error: 'Name the product first' }, 400);
      const answers = body.answers && typeof body.answers === 'object' ? body.answers : {};

      // Without a key the buyer still gets a sensible run of questions, just
      // not ones shaped to their trade. Never a dead end.
      if (!key) {
        return json({ questions: Object.keys(answers).length ? [] : [
          { id: 'spec', label: 'Any specification that matters?',
            help: 'Grade, size, standard, finish — whatever a supplier must match.',
            kind: 'text', required: false }
        ], done: Object.keys(answers).length > 0 }, 200);
      }

      const asked = Object.entries(answers)
        .map(([k, v]) => '- ' + k + ': ' + String(v).slice(0, 120))
        .join('\n') || '(nothing yet)';

      const SYSTEM_ASK = `You help a Ugandan wholesale buyer describe what they
need, so suppliers can quote a firm price without ringing back.

Ask only what changes the PRICE or what a supplier must MATCH. For cement that
is grade and bag count. For steel bar, diameter and length. For poles, length,
class and whether treated. For gloves, size and box count. For a vehicle,
model year and condition.

Never ask quantity, district, budget or delivery date — the form already has
those. Never ask anything answered above. Never ask more than 3 at a time.

Uganda: prices in UGX, common units are bags, sheets, tonnes, pieces, lengths,
rolls, cartons. Plain words, no jargon.

Reply with JSON only:
{"questions":[{"id":"grade","label":"Which grade?","help":"32.5N suits general
work, 42.5N sets faster","kind":"chips","options":["32.5N","42.5N","Not sure"],
"required":true}],"done":false}

kind is "chips" (3-6 short options, always include an escape like "Not sure" or
"Any"), "number" (add "unit"), or "text".

Set done true when you have enough to quote — usually after 3 to 5 questions
in total. When done is true, questions must be empty.`;

      const res = await fetch('https://api.anthropic.com/v1/messages', {
        method: 'POST',
        headers: { 'content-type': 'application/json', 'x-api-key': key,
          'anthropic-version': '2023-06-01' },
        body: JSON.stringify({
          model: MODEL, max_tokens: 700, system: SYSTEM_ASK,
          messages: [{ role: 'user', content:
            'Product: ' + product + '\n\nAlready answered:\n' + asked }]
        })
      });

      if (!res.ok) {
        const detail = await res.text();
        return json({ error: 'upstream', status: res.status,
          message: 'Could not fetch the next question.',
          detail: detail.slice(0, 400) }, 200);
      }

      const data = await res.json();
      const raw = (data?.content ?? []).map((c: { text?: string }) => c.text ?? '').join('');
      let parsed: Record<string, unknown> = {};
      try {
        const m = raw.match(/\{[\s\S]*\}/);
        parsed = m ? JSON.parse(m[0]) : {};
      } catch (_) { parsed = {}; }

      // Shape every question here, so a malformed one cannot reach the screen.
      const list = Array.isArray(parsed.questions) ? parsed.questions : [];
      const questions = list.slice(0, 3).map((q: Record<string, unknown>, i: number) => {
        const kind = ['chips', 'number', 'text'].includes(String(q.kind)) ? String(q.kind) : 'text';
        const opts = Array.isArray(q.options)
          ? q.options.map((o: unknown) => String(o).slice(0, 40)).filter(Boolean).slice(0, 6)
          : [];
        return {
          id: String(q.id || ('q' + i)).replace(/[^a-z0-9_]/gi, '').slice(0, 24) || ('q' + i),
          label: String(q.label || 'Anything else?').slice(0, 120),
          help: String(q.help || '').slice(0, 160),
          kind: kind === 'chips' && opts.length < 2 ? 'text' : kind,
          options: opts,
          unit: String(q.unit || '').slice(0, 16),
          required: q.required === true
        };
      }).filter((q: { label: string }) => q.label);

      // The prompt forbids asking quantity, district, budget or date — the form
      // asks those itself. But a model drifts once the real specifics run out
      // and starts asking them anyway, so the rule is enforced here rather
      // than hoped for. A buyer asked "how many?" twice loses confidence in
      // the whole thing.
      const OWNED = /\b(how many|quantity|qty|how much do you need|budget|price range|district|location|where|delivery date|when do you need|deadline|by when)\b/i;
      const kept = questions.filter((q: { id: string; label: string }) =>
        !OWNED.test(q.label) && !/^(quantity|qty|budget|district|location|date|deadline)$/i.test(q.id));

      return json({ questions: kept,
        done: parsed.done === true || kept.length === 0 }, 200);
    }

    // ── tidy: needs the key ───────────────────────────────────────────
    if (action === 'tidy' || action === 'tidyProduct') {
      const key = Deno.env.get('ANTHROPIC_API_KEY');
      if (!key) {
        return json({ error: 'no_key',
          message: 'Clean-up is not switched on yet.' }, 200);
      }

      const text = String(body.text || '').slice(0, 1200).trim();
      if (!text) return json({ error: 'Nothing to read' }, 400);

      // The real category and district names, so the model can only ever
      // return one that exists in this database.
      const [cats, districts] = await Promise.all([
        supabase.from('categories').select('name').order('name').limit(200),
        supabase.from('districts').select('name').order('name').limit(200)
      ]);
      const catNames = (cats.data ?? []).map((c: { name: string }) => c.name);
      const districtNames = (districts.data ?? []).map((d: { name: string }) => d.name);

      const isProduct = action === 'tidyProduct';
      const prompt = isProduct
        ? [
            'Categories: ' + (catNames.join(', ') || '(none)'),
            '',
            'The supplier typed: ' + text
          ].join('\n')
        : [
            'Categories: ' + (catNames.join(', ') || '(none)'),
            'Districts: ' + (districtNames.join(', ') || '(none)'),
            body.district ? 'The buyer is based in ' + body.district + '.' : '',
            '',
            'The buyer typed: ' + text
          ].filter(Boolean).join('\n');

      const res = await fetch('https://api.anthropic.com/v1/messages', {
        method: 'POST',
        headers: {
          'x-api-key': key,
          'anthropic-version': '2023-06-01',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          model: MODEL,
          max_tokens: 700,
          system: isProduct ? SYSTEM_PRODUCT : SYSTEM,
          messages: [{ role: 'user', content: prompt }]
        })
      });

      if (!res.ok) {
        const detail = await res.text();
        console.error('anthropic', res.status, detail.slice(0, 300));
        return json({ error: 'upstream',
          upstreamStatus: res.status,
          upstreamMessage: ((() => { try { return JSON.parse(detail)?.error?.message; }
            catch (_) { return null; } })() || detail).toString().slice(0, 200),
          message: 'Could not read that just now. Post it as typed and edit later.' }, 200);
      }

      const out = await res.json();
      const raw = (out.content ?? []).map((c: { text?: string }) => c.text || '').join('');

      // The model is asked for bare JSON; a fence occasionally arrives anyway.
      const match = raw.match(/\{[\s\S]*\}/);
      if (!match) return json({ error: 'unreadable', raw: raw.slice(0, 200) }, 200);

      let parsed: Record<string, unknown>;
      try { parsed = JSON.parse(match[0]); }
      catch { return json({ error: 'unreadable', raw: raw.slice(0, 200) }, 200); }

      // Never trust the reply. A category or district that is not really in
      // this database is dropped rather than passed on to the app.
      const pick = (v: unknown, allowed: string[]) => {
        const s = String(v ?? '').trim();
        if (!s) return null;
        const hit = allowed.find(a => a.toLowerCase() === s.toLowerCase());
        return hit ?? null;
      };
      const num = (v: unknown) => {
        const n = Number(String(v ?? '').replace(/[^0-9.]/g, ''));
        return Number.isFinite(n) && n > 0 ? n : null;
      };

      if (isProduct) {
        return json({
          ok: true,
          name: String(parsed.name ?? text).slice(0, 200),
          category: pick(parsed.category, catNames),
          unit: parsed.unit ? String(parsed.unit).slice(0, 30) : null,
          moq: num(parsed.moq),
          brand: parsed.brand ? String(parsed.brand).slice(0, 80) : null,
          price: num(parsed.price),
          description: parsed.description ? String(parsed.description).slice(0, 1000) : null,
          notes: parsed.notes ? String(parsed.notes).slice(0, 300) : null
        });
      }

      return json({
        ok: true,
        title: String(parsed.title ?? text).slice(0, 200),
        quantity: num(parsed.quantity),
        unit: parsed.unit ? String(parsed.unit).slice(0, 30) : null,
        category: pick(parsed.category, catNames),
        district: pick(parsed.district, districtNames),
        specification: parsed.specification ? String(parsed.specification).slice(0, 1000) : null,
        budget: num(parsed.budget),
        notes: parsed.notes ? String(parsed.notes).slice(0, 300) : null
      });
    }

    // ── catalogue: a brochure's text in, draft listings out ───────────
    if (action === 'catalogue') {
      const key = Deno.env.get('ANTHROPIC_API_KEY');
      if (!key) {
        return json({ error: 'no_key',
          message: 'Reading catalogues is not switched on yet.' }, 200);
      }

      // The PDF is turned into text in the browser, so only text arrives here.
      // 60k characters is roughly a 30-page catalogue.
      const text = String(body.text || '').slice(0, 60000).trim();
      if (text.length < 40) return json({ error: 'Not enough text to read' }, 400);

      const cats = await supabase.from('categories').select('name').order('name').limit(200);
      const catNames = (cats.data ?? []).map((c: { name: string }) => c.name);

      const res = await fetch('https://api.anthropic.com/v1/messages', {
        method: 'POST',
        headers: { 'x-api-key': key, 'anthropic-version': '2023-06-01',
          'Content-Type': 'application/json' },
        body: JSON.stringify({
          model: MODEL,
          max_tokens: 8000,
          system: SYSTEM_CATALOGUE,
          messages: [{ role: 'user', content:
            'Categories: ' + (catNames.join(', ') || '(none)') + '\n\nCatalogue text:\n' + text }]
        })
      });

      if (!res.ok) {
        const detail = await res.text();
        console.error('anthropic catalogue', res.status, detail.slice(0, 300));
        return json({ error: 'upstream',
          message: 'Could not read that catalogue just now. Try again, or add the products by hand.' }, 200);
      }

      const out = await res.json();
      const raw = (out.content ?? []).map((c: { text?: string }) => c.text || '').join('');
      const match = raw.match(/\{[\s\S]*\}/);
      if (!match) return json({ error: 'unreadable', raw: raw.slice(0, 200) }, 200);

      let parsed: { products?: unknown[]; skipped?: string; summary?: string };
      try { parsed = JSON.parse(match[0]); }
      catch { return json({ error: 'unreadable', raw: raw.slice(0, 200) }, 200); }

      const pick = (v: unknown) => {
        const s = String(v ?? '').trim();
        if (!s) return null;
        return catNames.find(a => a.toLowerCase() === s.toLowerCase()) ?? null;
      };
      const num = (v: unknown) => {
        const nn = Number(String(v ?? '').replace(/[^0-9.]/g, ''));
        return Number.isFinite(nn) && nn > 0 ? nn : null;
      };

      const products = (Array.isArray(parsed.products) ? parsed.products : [])
        .slice(0, 60)
        .map((p) => {
          const row = p as Record<string, unknown>;
          const name = String(row.name ?? '').trim();
          if (!name) return null;
          return {
            name: name.slice(0, 200),
            category: pick(row.category),
            price: num(row.price),
            unit: row.unit ? String(row.unit).slice(0, 30) : null,
            moq: num(row.moq),
            specification: row.specification ? String(row.specification).slice(0, 1000) : null,
            description: row.description ? String(row.description).slice(0, 1000) : null,
            // which page it sits on, so the browser can offer that page's photographs
            page: (() => { const pn = Number(row.page); return Number.isFinite(pn) && pn > 0 ? Math.round(pn) : null; })(),
            uncertain: !!row.uncertain || num(row.price) === null,
            note: row.note ? String(row.note).slice(0, 200) : null
          };
        })
        .filter(Boolean);

      return json({ ok: true, products,
        skipped: parsed.skipped ? String(parsed.skipped).slice(0, 300) : null,
        summary: parsed.summary ? String(parsed.summary).slice(0, 300) : null });
    }

    // Diagnostic: which models this key can actually reach. Model availability
    // varies by account, and a wrong id fails as a 404 that reads like an
    // outage. Admin only — it exposes nothing but public model names.
    if (action === 'models') {
      const key = Deno.env.get('ANTHROPIC_API_KEY');
      if (!key) return json({ error: 'no key set' }, 200);
      const res = await fetch('https://api.anthropic.com/v1/models?limit=40', {
        headers: { 'x-api-key': key, 'anthropic-version': '2023-06-01' }
      });
      const body = await res.text();
      if (!res.ok) return json({ status: res.status, body: body.slice(0, 400) }, 200);
      let ids: string[] = [];
      try { ids = (JSON.parse(body).data || []).map((m: { id: string }) => m.id); }
      catch (_) { return json({ status: res.status, body: body.slice(0, 400) }, 200); }
      return json({ status: res.status, models: ids }, 200);
    }

    return json({ error: 'Unknown action: ' + action }, 400);

  } catch (err) {
    console.error(err);
    return json({ error: 'failed', message: String((err as Error).message).slice(0, 200) }, 200);
  }
});

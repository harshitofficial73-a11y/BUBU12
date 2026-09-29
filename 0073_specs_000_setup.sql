-- Carbon platform · product specifications, setup  (run FIRST)
--
-- Staging for the reference specifications in the 10,800-product workbook.
-- Each long text is stored once (7,066 distinct) and every product row points
-- at its texts, which keeps each file small enough for the SQL editor.
--
-- ORDER: this file → 101-102 (texts) → 201-207 (rows) → 301-308 (apply).
-- Every file is safe to re-run.

create table if not exists public.catalogue_spec_text (id int primary key, txt text not null);
create table if not exists public.catalogue_spec_rows (
  product_code text primary key,
  name text not null, main_name text, main_slug text,
  variant int, tech int, quality int, pack int, use_note int, storage int, confirm int
);
create index if not exists catalogue_spec_rows_name on public.catalogue_spec_rows (name);
create index if not exists products_name_idx on public.products (name);

-- Reference data only, read by the function below. No policies means the public
-- API cannot read these tables directly.
alter table public.catalogue_spec_text enable row level security;
alter table public.catalogue_spec_rows enable row level security;

-- Writes the specification rows for one slice of the imported catalogue.
--
-- A product is matched to its sheet row by name. 684 names appear in more than
-- one trade with DIFFERENT specifications (butter as farm produce and as dairy
-- wholesale, for example), so when a name has several rows the one from the
-- product's own main category wins — first by the category id the import gave
-- it, then by its current top-level category name.
--
-- The catalogue is split into 8 slices so no single run is long enough to hit
-- the SQL editor's time limit.
create or replace function public.apply_catalogue_specs(p_bucket int, p_buckets int default 8)
returns int
language plpgsql
security definer
set search_path = public
as $$
declare v_n int;
begin
  create temp table if not exists _spec_pick (pid uuid primary key, code text) on commit drop;
  truncate _spec_pick;

  insert into _spec_pick (pid, code)
  select distinct on (p.id) p.id, r.product_code
  from products p
  join catalogue_spec_rows r on r.name = p.name
  left join categories c on c.id = p.category_id
  left join categories root on root.id = coalesce(c.parent_id, c.id)
  where p.import_source = 'uganda-b2b'
    and (hashtext(p.id::text) & 2147483647) % p_buckets = p_bucket
  order by p.id,
    case when r.main_slug = split_part(p.category_id, '--', 1) then 0
         when r.main_name = root.name then 1
         else 2 end,
    r.product_code;

  get diagnostics v_n = row_count;

  -- Replace, never duplicate: a re-run writes the same rows again.
  delete from product_specs s
   using _spec_pick k
   where s.product_id = k.pid
     and s.key in ('Standard variant', 'Technical specification', 'Quality check',
                   'Packaging / unit of sale', 'Use / compatibility', 'Storage / handling',
                   'Confirm with supplier', 'Specification basis');

  insert into product_specs (product_id, key, value, sort)
  select k.pid, v.key, t.txt, v.sort
  from _spec_pick k
  join catalogue_spec_rows r on r.product_code = k.code
  cross join lateral (values
    ('Standard variant',          r.variant,  1),
    ('Technical specification',   r.tech,     2),
    ('Quality check',             r.quality,  3),
    ('Packaging / unit of sale',  r.pack,     4),
    ('Use / compatibility',       r.use_note, 5),
    ('Storage / handling',        r.storage,  6),
    ('Confirm with supplier',     r.confirm,  7)
  ) as v(key, tid, sort)
  join catalogue_spec_text t on t.id = v.tid;

  -- The sheet's own caveat, on every product: these are reference
  -- specifications for the product family, not the supplier's confirmed SKU.
  insert into product_specs (product_id, key, value, sort)
  select pid, 'Specification basis',
         'Reference specification for this product type — confirm the supplier''s exact product before ordering', 8
  from _spec_pick;

  return v_n;
end;
$$;

-- One category's published listings, fetched a category at a time.
--
-- The marketplace loaded a single capped page of products and then filtered it
-- in the browser for everything: the category tallies and the drill-down both
-- read that one array. With 485 published listings and a cap of 100, most
-- categories read "No listings yet" and opening one that held thirteen showed
-- a single product.
--
-- Counting was already done properly against the database elsewhere; what was
-- missing was a way to ask for one category's listings without dragging the
-- whole catalogue over the wire.
--
-- A parent category returns its children's listings too, because products are
-- filed on leaves like 'steel-metal' rather than on 'building-construction'.
-- Listings that have a photograph come first: a buyer opening a category
-- should not land on a wall of blank tiles.

create or replace function public.products_in_category(p_category text, p_limit int default 400)
returns setof products
language sql stable security definer set search_path=public as $$
  select p.*
  from products p
  where p.status = 'published'
    and (
      p_category is null
      or p.category_id = p_category
      or p.category_id in (select id from categories where parent_id = p_category)
    )
  order by (exists (select 1 from media m
                    where m.product_id = p.id and m.kind = 'product' and m.approved)) desc,
           p.updated_at desc
  limit greatest(1, least(p_limit, 1000));
$$;

grant execute on function public.products_in_category(text, int) to authenticated, anon;

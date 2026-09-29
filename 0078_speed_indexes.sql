-- Speed: indexes for the queries every page runs.
--
-- The catalogue grew from ~500 listings to ~44,000 with the import. The home
-- feed, category pages, a supplier's own catalogue and the lead board all
-- filter products by status, category or supplier and sort by date — with no
-- index on those columns each of those reads the whole table. These let the
-- database go straight to the rows it needs.
--
-- Safe to re-run. Takes under a minute.

create index if not exists products_status_updated_idx   on public.products (status, updated_at desc);
create index if not exists products_category_status_idx  on public.products (category_id, status);
create index if not exists products_supplier_idx         on public.products (supplier_id, updated_at desc);
create index if not exists media_product_kind_idx        on public.media (product_id, kind);
create index if not exists categories_parent_idx         on public.categories (parent_id);
create index if not exists requirements_state_created_idx on public.requirements (state, created_at desc);
create index if not exists conversations_buyer_idx       on public.conversations (buyer_id);
create index if not exists conversations_supplier_idx    on public.conversations (supplier_id);
create index if not exists messages_conversation_idx     on public.messages (conversation_id, created_at);

analyze public.products;
analyze public.media;
analyze public.categories;
analyze public.requirements;
analyze public.conversations;
analyze public.messages;

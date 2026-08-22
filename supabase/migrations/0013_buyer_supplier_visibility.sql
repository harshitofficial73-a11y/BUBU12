-- A buyer may see supplier identity only after the two accounts share a quote or chat.
drop policy if exists accounts_buyer_supplier_relationship on accounts;
create policy accounts_buyer_supplier_relationship on accounts for select using (
  role='supplier' and (
    exists(select 1 from conversations c
      where c.supplier_id=accounts.id and c.buyer_id=current_account_id())
    or exists(select 1 from quotes q join requirements r on r.id=q.requirement_id
      where q.supplier_id=accounts.id and r.buyer_id=current_account_id())
  )
);

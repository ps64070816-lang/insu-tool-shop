-- 장바구니(cart_items) 보안 설정
-- 로그인한 회원이 "자기 장바구니"만 보고, 담고, 고치고, 지울 수 있게 해요.
-- Supabase 대시보드 → SQL Editor 에 붙여넣고 Run 을 누르세요. (여러 번 실행해도 괜찮아요)

alter table public.cart_items enable row level security;

drop policy if exists "내 장바구니 조회" on public.cart_items;
drop policy if exists "내 장바구니 추가" on public.cart_items;
drop policy if exists "내 장바구니 수정" on public.cart_items;
drop policy if exists "내 장바구니 삭제" on public.cart_items;

create policy "내 장바구니 조회" on public.cart_items
  for select to authenticated using (auth.uid() = user_id);

create policy "내 장바구니 추가" on public.cart_items
  for insert to authenticated with check (auth.uid() = user_id);

create policy "내 장바구니 수정" on public.cart_items
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "내 장바구니 삭제" on public.cart_items
  for delete to authenticated using (auth.uid() = user_id);

-- 확인: 아래 결과에 위 4개 말고 다른 정책(예: 누구나 허용하는 정책)이 있으면 지워 주세요.
select policyname, cmd, roles from pg_policies where tablename = 'cart_items';

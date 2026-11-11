-- ========== profiles: 모두 읽기 + 본인만 수정 ==========
-- (insert는 트리거가 하니까 정책 필요 없음)
create policy "프로필 누구나 조회" on public.profiles
  for select to anon, authenticated using (true);

create policy "본인 프로필만 수정" on public.profiles
  for update to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

-- ========== posts: 모두 읽기 + 본인만 쓰기/수정/삭제 ==========
create policy "글 누구나 조회" on public.posts
  for select to anon, authenticated using (true);

create policy "로그인 유저 글쓰기 (본인 명의로만)" on public.posts
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "본인 글만 수정" on public.posts
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "본인 글만 삭제" on public.posts
  for delete to authenticated
  using ((select auth.uid()) = user_id);

-- ========== comments: posts와 같은 패턴 ==========
create policy "댓글 누구나 조회" on public.comments
  for select to anon, authenticated using (true);

create policy "로그인 유저 댓글쓰기" on public.comments
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "본인 댓글만 수정" on public.comments
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "본인 댓글만 삭제" on public.comments
  for delete to authenticated
  using ((select auth.uid()) = user_id);

-- ========== likes: 누르기/취소만 (수정은 없음) ==========
create policy "좋아요 누구나 조회" on public.likes
  for select to anon, authenticated using (true);

create policy "본인 좋아요 누르기" on public.likes
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "본인 좋아요 취소" on public.likes
  for delete to authenticated
  using ((select auth.uid()) = user_id);
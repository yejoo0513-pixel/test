-- 01_todos.sql : 할 일 테이블 (패턴 ① 본인만)
create table public.todos (
  id bigint generated always as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title text not null,
  done boolean not null default false,
  created_at timestamptz not null default now()
);

create index todos_user_id_idx on public.todos(user_id);

alter table public.todos enable row level security;

create policy "본인 할 일 조회" on public.todos
  for select to authenticated using ((select auth.uid()) = user_id);

create policy "본인 할 일 추가" on public.todos
  for insert to authenticated with check ((select auth.uid()) = user_id);

create policy "본인 할 일 수정" on public.todos
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

create policy "본인 할 일 삭제" on public.todos
  for delete to authenticated using ((select auth.uid()) = user_id);
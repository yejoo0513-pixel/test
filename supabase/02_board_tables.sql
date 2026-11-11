-- 1. 함수: 새 유저가 생기면 profiles에 한 줄 넣기
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer            -- 관리자 권한으로 실행 (RLS 때문에 막히지 않게)
set search_path = ''        -- 보안: 엉뚱한 스키마의 함수가 끼어들지 못하게
as $$
begin
  insert into public.profiles (id, username)
  values (
    new.id,                                       -- new = 방금 가입한 유저
    new.raw_user_meta_data ->> 'username'         -- 가입할 때 넘긴 닉네임 (없으면 null)
  );
  return new;
end;
$$;

-- 2. 트리거: auth.users에 INSERT가 일어날 때마다 위 함수 실행
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 3. 이미 있는 테스트 유저는 트리거 전에 가입했으니까 직접 채워주기
insert into public.profiles (id, username)
select id, split_part(email, '@', 1)   -- 이메일 @ 앞부분을 닉네임으로
from auth.users
on conflict (id) do nothing;
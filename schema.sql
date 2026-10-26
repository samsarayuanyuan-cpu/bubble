-- 池 — 数据库结构
-- 在 Supabase 的 SQL Editor 里整段执行

create table if not exists bubbles (
  id         uuid primary key default gen_random_uuid(),
  text       text not null check (char_length(text) between 1 and 300),
  day        date not null default (now() at time zone 'utc')::date,
  page       int  not null default 0,
  hue        int,
  created_at timestamptz not null default now()
);

create table if not exists pages (
  day   date   not null,
  page  int    not null,
  seed  bigint not null,
  primary key (day, page)
);

create index if not exists bubbles_day_page_idx on bubbles (day, page);

alter table bubbles enable row level security;
alter table pages   enable row level security;

-- 所有人可读
create policy "public read bubbles" on bubbles for select using (true);
create policy "public read pages"   on pages   for select using (true);

-- 只有登录用户可写
create policy "editor insert bubbles" on bubbles for insert with check (auth.role() = 'authenticated');
create policy "editor delete bubbles" on bubbles for delete using      (auth.role() = 'authenticated');
create policy "editor insert pages"   on pages   for insert with check (auth.role() = 'authenticated');

-- 实时推送
alter publication supabase_realtime add table bubbles;

-- 若建项目时关掉了「自动显示新表格」，补这几句授权
grant select on bubbles, pages to anon, authenticated;
grant insert, delete on bubbles to authenticated;
grant insert on pages to authenticated;

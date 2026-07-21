-- ============================================================================
-- Touch the Number — オンラインデイリーランキング用スキーマ
--
-- Supabase の SQL Editor に貼り付けて実行する。
-- 前提: プロジェクト作成済み、Authentication で「Anonymous sign-ins」を有効化。
--
-- 設計:
--   - クライアントは daily_scores に直接書き込めない（RLSでSELECTのみ許可）。
--   - スコア投稿は Edge Function `submit-score` が service_role で行う。
--     Edge Function は認証・妥当性チェックの後、下の関数 upsert_daily_score を呼ぶ。
--   - 「デイリー」の日付境界はサーバー時刻（Asia/Tokyo）で決める（改ざん防止）。
--   - 1日1モード1ユーザー1エントリ。速い記録が出たときだけ上書き（自己ベスト）。
-- ============================================================================

create table if not exists public.daily_scores (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  play_date   date        not null,
  mode        text        not null check (mode in ('easy', 'medium', 'hard')),
  time_ms     integer     not null check (time_ms > 0),
  player_name text        not null check (char_length(player_name) between 1 and 20),
  user_id     uuid        not null references auth.users (id) on delete cascade,
  unique (play_date, mode, user_id)
);

-- 「その日・そのモードの速い順トップN」を高速に取るためのインデックス
create index if not exists idx_daily_scores_rank
  on public.daily_scores (play_date, mode, time_ms);

-- ---------------------------------------------------------------------------
-- 行レベルセキュリティ: 閲覧は全員可、書き込みポリシーは作らない
-- （＝anon/authenticated からの INSERT/UPDATE/DELETE は不可。service_role のみ）
-- ---------------------------------------------------------------------------
alter table public.daily_scores enable row level security;

drop policy if exists "daily_scores_read_all" on public.daily_scores;
create policy "daily_scores_read_all"
  on public.daily_scores for select
  using (true);

-- ---------------------------------------------------------------------------
-- 自己ベストのみ上書きする投稿関数。
-- Edge Function（service_role）からのみ呼ばれる想定。play_date はサーバー時刻。
-- ---------------------------------------------------------------------------
create or replace function public.upsert_daily_score(
  p_user_id uuid,
  p_mode    text,
  p_time_ms integer,
  p_name    text
) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_date date := (now() at time zone 'Asia/Tokyo')::date;
begin
  insert into public.daily_scores (play_date, mode, time_ms, player_name, user_id)
  values (v_date, p_mode, p_time_ms, p_name, p_user_id)
  on conflict (play_date, mode, user_id)
  do update
     set time_ms     = excluded.time_ms,
         player_name = excluded.player_name,
         created_at  = now()
   where excluded.time_ms < public.daily_scores.time_ms;
end;
$$;

-- 一般ユーザー（anon/authenticated）からは直接実行させない。service_role のみ。
revoke all on function public.upsert_daily_score(uuid, text, integer, text) from public;
revoke all on function public.upsert_daily_score(uuid, text, integer, text) from anon, authenticated;

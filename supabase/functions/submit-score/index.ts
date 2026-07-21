// Touch the Number — スコア投稿 Edge Function
//
// クライアントはこの関数を通してのみスコアを投稿できる（daily_scores への
// 直接書き込みは RLS で禁止）。ここで認証・妥当性チェックを行い、問題なければ
// service_role で RPC upsert_daily_score を呼ぶ（サーバー時刻で日付を確定）。
//
// デプロイ:
//   supabase functions deploy submit-score
// 必要なenv（supabase secrets set ... で設定。URL/anonは自動注入される場合あり）:
//   SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY
//
// 呼び出し（Flutter側）: functions.invoke('submit-score',
//   body: { mode, timeMs, playerName })  ※Authorizationヘッダに匿名認証のJWT

import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

// モードごとのタップ数。人間には不可能な速さ（1タップあたり下限ms）を弾く下限に使う。
const TAP_COUNT: Record<string, number> = { easy: 25, medium: 36, hard: 49 };
const MIN_MS_PER_TAP = 40; // これ×タップ数より速い記録は不正とみなす
const MAX_MS = 60 * 60 * 1000; // 1時間を上限（明らかな異常値を弾く）

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") return json({ error: "method not allowed" }, 405);

  try {
    const authHeader = req.headers.get("Authorization") ?? "";
    const url = Deno.env.get("SUPABASE_URL")!;
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

    // 呼び出し元の匿名ユーザーを検証
    const userClient = createClient(url, anonKey, {
      global: { headers: { Authorization: authHeader } },
    });
    const { data: { user }, error: authErr } = await userClient.auth.getUser();
    if (authErr || !user) return json({ error: "unauthorized" }, 401);

    const payload = await req.json().catch(() => null);
    if (!payload) return json({ error: "invalid body" }, 400);

    const mode = String(payload.mode ?? "");
    const timeMs = Number(payload.timeMs);
    const rawName = String(payload.playerName ?? "");

    if (!(mode in TAP_COUNT)) return json({ error: "invalid mode" }, 400);
    const minMs = TAP_COUNT[mode] * MIN_MS_PER_TAP;
    if (!Number.isFinite(timeMs) || timeMs < minMs || timeMs > MAX_MS) {
      return json({ error: "invalid time" }, 400);
    }
    const name = rawName.trim().slice(0, 20) || "Player";

    const admin = createClient(url, serviceKey);
    const { error } = await admin.rpc("upsert_daily_score", {
      p_user_id: user.id,
      p_mode: mode,
      p_time_ms: Math.round(timeMs),
      p_name: name,
    });
    if (error) return json({ error: error.message }, 500);

    return json({ ok: true });
  } catch (e) {
    return json({ error: String(e) }, 500);
  }
});

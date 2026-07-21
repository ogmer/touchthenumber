import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/game_mode.dart';
import '../models/online_ranking_entry.dart';

/// オンラインデイリーランキング。Supabaseの匿名認証でユーザーを識別し、
/// 投稿はEdge Function経由（サーバー検証）、閲覧はテーブルを直接SELECTする。
///
/// このクラスは SupabaseConfig が設定済みのときだけ生成される
/// （[onlineRankingServiceProvider] 参照）。
class OnlineRankingService {
  final SupabaseClient _client;

  OnlineRankingService(this._client);

  /// 端末ごとに一意な匿名ユーザーでサインインしておく（セッションは永続化される）。
  Future<void> _ensureSignedIn() async {
    if (_client.auth.currentSession == null) {
      await _client.auth.signInAnonymously();
    }
  }

  /// スコアを投稿する。サーバー側で日付確定・妥当性チェック・自己ベスト上書きを行う。
  Future<void> submitScore({
    required GameMode mode,
    required int timeMs,
    required String playerName,
  }) async {
    await _ensureSignedIn();
    await _client.functions.invoke(
      'submit-score',
      body: {
        'mode': mode.name,
        'timeMs': timeMs,
        'playerName': playerName,
      },
    );
  }

  /// 今日（日本時間）の、指定モードの速い順ランキングを取得する。
  Future<List<OnlineRankingEntry>> getDailyRankings(
    GameMode mode, {
    int limit = 50,
  }) async {
    await _ensureSignedIn();
    final data = await _client
        .from('daily_scores')
        .select('player_name, time_ms, created_at')
        .eq('play_date', _jstToday())
        .eq('mode', mode.name)
        .order('time_ms', ascending: true)
        .limit(limit);
    return data
        .map((e) => OnlineRankingEntry.fromJson(e))
        .toList(growable: false);
  }

  /// 日本時間の「今日」を YYYY-MM-DD で返す（サーバーの日付境界に合わせる）。
  static String _jstToday() {
    final jst = DateTime.now().toUtc().add(const Duration(hours: 9));
    String two(int n) => n.toString().padLeft(2, '0');
    return '${jst.year}-${two(jst.month)}-${two(jst.day)}';
  }
}

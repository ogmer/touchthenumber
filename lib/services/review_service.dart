import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ストアレビュー依頼。クリア直後の「気持ちいい瞬間」に、節目の回数で
/// 一度だけOS標準のレビューダイアログを表示する。
/// 評価の数と鮮度はストアランキングの主要因のひとつ。
class ReviewService {
  static const String _requestedKey = 'review_requested_milestones';

  /// レビューを依頼するクリア回数の節目。
  /// 5回=楽しさが分かった頃、25回=定着した頃、100回=ファンになった頃。
  /// iOSはシステム側で年3回までに制限されるため、間隔を空けている
  static const List<int> milestones = [5, 25, 100];

  final SharedPreferences _prefs;
  final InAppReview _inAppReview;

  ReviewService(this._prefs, {InAppReview? inAppReview})
      : _inAppReview = inAppReview ?? InAppReview.instance;

  /// 総クリア回数が節目に達していたらレビューを依頼する。
  /// 各節目につき一度だけ。表示するかどうかの最終判断はOSが行う
  Future<void> maybeRequestReview(int totalGames) async {
    if (!milestones.contains(totalGames)) return;

    final requested = _prefs.getStringList(_requestedKey) ?? [];
    if (requested.contains('$totalGames')) return;

    // 依頼済みとして先に記録する（失敗時に連打で再依頼しないため）
    await _prefs.setStringList(_requestedKey, [...requested, '$totalGames']);

    try {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
      }
    } catch (e) {
      // Webやストア外配布などレビュー非対応の環境では何もしない
    }
  }
}

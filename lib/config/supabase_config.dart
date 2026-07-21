/// Supabase（オンラインランキング）の接続設定。
///
/// キーはソースにコミットしない。ビルド/実行時に --dart-define で注入する:
///   flutter run \
///     --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
///     --dart-define=SUPABASE_ANON_KEY=eyJhbGciOi...
///
/// anon key はクライアントに埋め込む前提の公開キーで、DB側のRLS（行レベル
/// セキュリティ）で保護する。service_role キーは絶対にここへ入れないこと。
///
/// 未設定（空）の場合、オンラインランキングは自動的に無効になり、アプリは
/// ローカルランキングのみで従来どおり動作する。
class SupabaseConfig {
  const SupabaseConfig._();

  static const String url = String.fromEnvironment('SUPABASE_URL');
  static const String anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// オンライン機能を有効にできるか（URL/anonKey が両方注入されているか）。
  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}

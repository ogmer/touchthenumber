# Touch the Number

数字を1から順にタップしてタイムを競う脳トレゲーム（Flutter製）。

- 3段階の難易度（5×5 / 6×6 / 7×7）
- ランキング・統計・アチーブメント・テーマカラー・BGM/効果音・多言語対応
- Android / iOS / Web / Windows 対応

## 開発

```sh
flutter pub get
flutter run       # アプリ起動
flutter test      # テスト
flutter analyze   # 静的解析
```

## 素材の再生成

日本語テキストを追加したらフォントのサブセットを再生成する（未実行だとWebで未収録の漢字が表示されない）:

```sh
py -m pip install fonttools brotli   # 初回のみ
py tool/subset_font.py
```

音源（BGM・効果音）を変更したら:

```sh
dart run tool/generate_sounds.dart
py -m pip install lameenc     # 初回のみ
py tool/compress_bgm.py       # BGMをMP3圧縮（サイズ削減。効果音はWAVのまま）
```

## オンラインランキング（任意）

Supabaseを使ったデイリーオンラインランキング。**未設定でもアプリはローカルのみで通常どおり動く**（キーを渡したときだけ有効化）。

セットアップ:

1. [Supabase](https://supabase.com) でプロジェクトを作成し、**Authentication → Providers で「Anonymous」を有効化**。
2. SQL Editor で [`supabase/schema.sql`](supabase/schema.sql) を実行（テーブル・RLS・投稿関数）。
3. Edge Function をデプロイ（要 [Supabase CLI](https://supabase.com/docs/guides/cli)）:
   ```sh
   supabase functions deploy submit-score
   # SUPABASE_SERVICE_ROLE_KEY はプロジェクトのSecretsに設定しておく
   ```
4. アプリ実行/ビルド時にキーを渡す（キーはソースにコミットしない）:
   ```sh
   flutter run \
     --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=<anon または publishable key>
   ```

設計メモ:
- スコア投稿は Edge Function `submit-score` 経由。サーバー側で日付確定（JST）・妥当性チェックを行い、クライアントからの直接書き込みは RLS で禁止。
- 1日1モード1エントリ（自己ベストのみ上書き）。
- プレイヤーは匿名認証で識別。表示名は設定画面のニックネーム。

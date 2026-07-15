# Touch the Number

数字を1から順にタップしてタイムを競う脳トレゲーム（Flutter製）。

- 3段階の難易度（5×5 / 6×6 / 7×7）
- ランキング・統計・アチーブメント・テーマカラー・BGM/効果音
- Android / iOS / Web / Windows 対応

## 開発

```sh
flutter pub get
flutter run -d chrome   # Web（開発）
flutter test            # テスト
```

音源は合成で生成している。曲や効果音を変更したら:

```sh
dart run tool/generate_sounds.dart
```

日本語テキストを追加したらフォントサブセットを再生成する:

```sh
py -m pip install fonttools brotli   # 初回のみ
py tool/subset_font.py
```

## リリースビルド（サイズ最適化）

アプリサイズを抑えるため、以下のオプションでビルドすること。

```sh
# Android: ストア配布はAABで（端末ごとに必要なABI/リソースだけ配信され、
# APK一括配布よりダウンロードサイズが大幅に小さくなる）
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols

# 直接APKを配る場合はABI分割で（全ABI同梱の巨大APKを避ける）
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/symbols

# Web
flutter build web --release
```

- `--split-debug-info` はデバッグシンボルを本体から分離して縮小する
  （クラッシュ解析には build/symbols を保管しておくこと）
- `--obfuscate` は難読化（リバースエンジニアリング対策とサイズ削減を兼ねる）
- R8によるコード縮小・リソース縮小は `android/app/build.gradle.kts` で有効化済み
- アイコンフォントのtree-shakingはreleaseビルドで自動適用される

### サイズに関する設計メモ

- 音源WAVは22.05kHzモノラルで生成（合成音の最高倍音約7.3kHzに対して十分。
  44.1kHz比で半減）
- 日本語フォントはアプリで使う文字だけにサブセット済み（3.4MB → 約200KB×2）

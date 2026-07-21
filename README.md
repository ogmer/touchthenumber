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
```

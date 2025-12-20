# Touch The Number

1 から順番に数字をタップしていくパズルゲーム。全部クリアするまでのタイムを競う。

## ゲームモード

- 5×5: 1〜25
- 6×6: 1〜36
- 7×7: 1〜49

## 遊び方

1 から順番に数字をタップしていくだけ。正解するとアニメーションが動いて、間違えると音が鳴る。全部タップし終わったらクリア。タイムはランキングに保存される。

## 主な機能

- 3 つの難易度
- タイマー（ミリ秒表示）
- ランキング（各モード別、上位 10 件）
- 音声の ON/OFF
- アニメーション

## セットアップ

Flutter 3.0 以上が必要。

```bash
git clone <repository-url>
cd touchthenumber
flutter pub get
flutter run
```

## ビルド

```bash
flutter build windows --release
flutter build apk --release
flutter build web --release
```

## ライセンス

MIT

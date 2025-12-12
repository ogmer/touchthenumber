# Touch The Number

数字を順番にタップするパズルゲームです。1 から順番に数字をタップして、すべての数字をクリアするまでの時間を競います。

## ゲームモード

- **5×5 モード**: 1 から 25 まで（25 個の数字）
- **6×6 モード**: 1 から 36 まで（36 個の数字）
- **7×7 モード**: 1 から 49 まで（49 個の数字）

## ゲームのルール

1. 画面に表示された数字を 1 から順番にタップします
2. 正しい数字をタップするとスコアが増加し、バウンスアニメーションが再生されます
3. 間違った数字をタップすると効果音が再生されます
4. すべての数字を順番にタップするとゲームクリアです
5. クリアまでの時間が記録され、モード別ランキングに保存されます

## 機能

- 3 つの難易度モード（5×5、6×6、7×7）
- リアルタイムタイマー（ミリ秒単位での計測）
- スコア表示と進捗管理
- モード別ランキング（各モードで独立した記録、上位 10 件を保存）
- バウンスアニメーション（正解時）
- 音声 ON/OFF 切り替え
- レスポンシブデザイン対応

## 技術仕様

- **フレームワーク**: Flutter 3.x
- **言語**: Dart 3.x
- **状態管理**: StatefulWidget
- **データ保存**: SharedPreferences
- **アニメーション**: AnimationController, Tween
- **UI**: Material Design 3
- **音声**: audioplayers パッケージ
- **プラットフォーム**: Windows, Web, Android, iOS

## セットアップ

### 前提条件

- Flutter SDK (3.0 以上)
- Dart SDK
- Android Studio / VS Code

### インストール手順

1. リポジトリをクローン

```bash
git clone <repository-url>
cd touchthenumber
```

2. 依存関係をインストール

```bash
flutter pub get
```

3. アプリを実行

```bash
# Windows版
flutter run -d windows

# Web版
flutter run -d chrome

# Android版
flutter run -d android
```

## テスト

```bash
flutter test
```

## ビルド

```bash
# Windows
flutter build windows --release

# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## プロジェクト構造

```
lib/
├── main.dart              # メインアプリケーション
│   ├── TouchTheNumberApp  # アプリケーションルート
│   ├── MainMenu          # メインメニュー画面
│   ├── TouchTheNumberGame # ゲーム画面
│   ├── RankingScreen     # ランキング画面
│   ├── GameRecord        # ゲーム記録モデル
│   └── GameMode          # ゲームモード列挙型

test/
└── widget_test.dart      # ウィジェットテスト

assets/
└── sounds/               # 音声ファイル
    ├── correct.mp3
    ├── wrong.mp3
    ├── start.mp3
    └── complete.mp3
```

## ライセンス

このプロジェクトは MIT ライセンスの下で公開されています。

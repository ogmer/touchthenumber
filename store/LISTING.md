# ストア掲載情報ドラフト（ASO最適化）

ストアコンソールに入力する掲載文のドラフト。検索ボリュームの見込める
「脳トレ」「反射神経」「数字」「タッチ」「タイムアタック」を軸に構成している。

## 画像素材（生成済み）

| ファイル | 用途 |
|---|---|
| `store/icon_512.png` | Google Play ストア掲載アイコン (512x512) |
| `store/feature_graphic.png` | Google Play フィーチャーグラフィック (1024x500) |
| `assets/icon/app_icon.png` | マスターアイコン (1024x1024)。App Store 用アイコンにもそのまま使える |

アプリ本体のアイコン（Android / iOS / Web / Windows）は生成・適用済み。
デザインを変えたいときは `tool/generate_icons.py` を編集して:

```sh
py tool/generate_icons.py
dart run flutter_launcher_icons
```

スクリーンショットは実機/エミュレータでゲーム画面（グリッド）・クリア演出
（紙吹雪）・ランキングを撮影して用意すること（1枚目が最重要）。

## アプリ名（Google Play: 30文字 / App Store: 30文字）

```
Touch the Number - 数字タッチ脳トレ
```

## 短い説明（Google Play: 80文字）／サブタイトル（App Store: 30文字）

Google Play:
```
1から順に数字をタップ！タイムを競うシンプル脳トレ。反射神経・動体視力のトレーニングに。
```

App Store サブタイトル:
```
数字を順にタップして脳を鍛える
```

## 詳しい説明（共通）

```
「Touch the Number」は、バラバラに並んだ数字を1から順にタップして
クリアタイムを競う、シンプルで奥深い脳トレゲームです。

■ 遊び方はかんたん
盤面に散らばった数字を 1 → 2 → 3… と順番にタップするだけ。
すべてタップしたらクリア！ タイムは0.001秒単位で記録されます。

■ 特徴
・3段階の難易度（5×5 / 6×6 / 7×7）
・ベストタイムのランキング（各難易度トップ10）
・プレイ回数や平均タイムがわかる統計機能
・条件を達成して集めるアチーブメント（実績）
・8色から選べるテーマカラー
・軽快な効果音とBGM（ワンタップでミュート可能）
・完全無料・オフラインでプレイ可能

■ こんな方におすすめ
・スキマ時間にサクッと遊べるゲームを探している
・反射神経や動体視力を鍛えたい
・集中力を高めるウォーミングアップをしたい
・家族や友達とタイムを競いたい

自己ベストの更新を目指して、今日も指先の反射神経を鍛えましょう！
```

## キーワード（App Store: 100文字、カンマ区切り）

```
脳トレ,数字,タッチ,反射神経,動体視力,タイムアタック,集中力,無料,ゲーム,シュルテ,暇つぶし,トレーニング
```

---

# English Listing（英語ストア掲載文）

アプリ本体が6言語対応になったため、まず英語の掲載文を用意する。
（ストアの「翻訳を追加」から en-US として登録する）

## App Name (30 chars)

```
Touch the Number - Tap & Focus
```

## Short Description (Google Play: 80 chars) / Subtitle (App Store: 30 chars)

Google Play:
```
Tap numbers in order as fast as you can! A simple brain-training time attack.
```

App Store subtitle:
```
Tap numbers in order. Fast!
```

## Full Description

```
Touch the Number is a simple yet addictive brain-training game:
tap the scattered numbers in order, starting from 1, as fast as you can.

■ Easy to play
Just tap 1 → 2 → 3... in order. Tap them all to clear the board!
Your time is recorded down to the millisecond.

■ Features
- 3 difficulty levels (5x5 / 6x6 / 7x7)
- Best-time ranking (top 10 per difficulty)
- Statistics: play count, best and average times
- Achievements to unlock
- 8 theme colors
- Cheerful sound effects and BGM (one-tap mute)
- Free and fully playable offline
- Available in 16 languages (EN, JA, ZH-Hans/Hant, KO, ES, FR, DE, IT, PT, RU, AR, HI, ID, TH, VI)

■ Great for
- Quick play sessions in your spare time
- Training reflexes and visual attention
- Warming up your focus before work or study
- Competing with friends and family

Beat your personal best and sharpen your reflexes today!
```

## Keywords (App Store, 100 chars)

```
brain,training,numbers,tap,reflex,speed,time attack,focus,schulte,puzzle,free,concentration
```

---

# ランキングを上げるためのコンソール側チェックリスト

コードでは対応できない、ストア運用側の施策。効果の大きい順。

1. **スクリーンショット・動画**: プレイ中のグリッド／クリア演出（紙吹雪）／
   ランキング画面を撮影して掲載。1枚目が最重要（CVRに直結）
2. **評価への返信**: 低評価レビューに返信すると改善率・再評価率が上がる
3. **定期アップデート**: 更新頻度はランキングシグナル。リリースノートに
   キーワードを自然に含める
4. **カテゴリ選択**: 「パズル」より「ボード」「教育（脳トレ）」等、
   競合が少ないカテゴリのほうが上位を取りやすい
5. **ローカライズ**: 英語の掲載文を追加するだけで検索流入の対象が大きく広がる
6. **Google Play の A/Bテスト**: アイコン・スクリーンショットのストア
   掲載情報テストを回す

# アプリ内で実装済みのASO施策

- クリア直後（5回・25回・100回の節目）にOS標準のレビューダイアログを表示
  （`ReviewService`）。評価の数と鮮度はランキングの主要因
- applicationId を `io.github.ogmer.touchthenumber` に変更済み
  （`com.example.*` のままではストアに公開できない）。独自ドメインが
  あれば `android/app/build.gradle.kts` で変更する
- 端末表示名を「Touch the Number」に統一（Android / iOS）
- Web版のtitle・description・manifest を検索向けに整備（PWA/SEO）

# Donglish

通勤中にAirPods Proの**首振りジェスチャー**で英語を学べるiOSアプリ。

## 特徴

- **ハンズフリー学習** - うなずき（Yes）/ 首振り（No）で回答。AirPods ProのCoreMotionを活用
- **音声ドリル** - テキスト読み上げ（TTS）による英語・日本語の音声出力
- **間隔反復** - 難易度に応じた最適な復習スケジューリング
- **朝・夜セッション** - 時間帯に合わせたドリル構成
- **進捗管理** - 新規 → 復習中 → 習得済みの3段階ステータス

## 技術スタック

| カテゴリ | 技術 |
|---|---|
| 言語 | Swift |
| UI | SwiftUI |
| データ永続化 | SwiftData |
| 音声 | AVFoundation（TTS） |
| モーション検出 | CoreMotion（ヘッドフォンモーション） |
| 並行処理 | Swift Concurrency（async/await） |

## プロジェクト構成

```
Donglish/
├── Models/          # データモデル（Question, DrillSession 等）
├── Views/           # SwiftUI ビュー
├── Services/        # ビジネスロジック（TTS, ジェスチャー検出, 間隔反復）
└── Tests/           # ユニットテスト・UIテスト
```

## 要件

- iOS 17.0+
- Xcode 16.0+
- AirPods Pro（ジェスチャー入力に必要）

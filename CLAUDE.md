@AGENTS.md

---

# @claude fix コマンド仕様

レビューBot（`claude-code-review.yml`）がインラインレビューコメントに `@claude fix` を書いた場合、このリポジトリへの修正PRを自動作成する。

## 動作ルール

- **必ずPRを作成する**。直接コミットは禁止。
- ブランチ名: `claude/fix/<元PR番号>-<短い説明>`（例: `claude/fix/42-guard-let`）
- PRのベースブランチ: 元PRのブランチ（`main` ではない）
- 元コメントへのリプライ: `🔧 修正PRを作成しました → #<PR番号>` の1行のみ

## 修正PR本文テンプレート

```
## 概要

<元PRへの参照: Fixes の指摘 in #<元PR番号>>

## 元レビューコメント

> <元レビューコメントを引用>

## 変更内容

- <変更点1>
- <変更点2>
```

## 禁止事項

- 直接コミット（`main` や元PRブランチへの直pushは不可）
- 指示されたスコープ外のリファクタリング
- テストの削除・無効化

---

# コーディング規約（iOS / Swift）

このプロジェクトは **iOS（Swift）のみ**で構成されます。

## Swift

- **Swift Concurrency**: `async/await`・`@MainActor`・`Sendable` を積極的に使用する
- **オプショナル**: `guard let` / `if let` を推奨。強制アンラップ（`!`）は原則禁止
- **値型優先**: `struct` を優先し、`class` は `@MainActor` などの参照セマンティクスが必要な場合のみ
- **アクセス制御**: 外部公開が不要なプロパティ・メソッドは `private` にする
- **SwiftUI**: `@State` / `@StateObject` / `@EnvironmentObject` を適切に使い分ける

---

# レビューBot向けガイド（`@claude fix` の書き方）

`@claude fix` はインラインレビューコメントの先頭に書く。Claude が指示を読んで修正PRを作成する。

## フォーマット

```
@claude fix <何を・どのように直すか（具体的に）>
```

## 良い例

```
@claude fix guard let に変更して、強制アンラップを除去してください
```

```
@claude fix TTSService.speak() の continuation をアクター分離に合わせて @MainActor で保護してください
```

## 悪い例（避けること）

```
@claude fix これを直して   # 指示が曖昧すぎる
@claude fix コード全体をリファクタリング   # スコープが広すぎる
```

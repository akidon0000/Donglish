# Review Guidelines

- レビューコメントは **日本語** で記述する
- 文末は **「ドン」** で終える
- Use severity levels: 🚫 MUST FIX / ⚠️ SHOULD FIX
- レビューは **Review Body（サマリー）** と **Inline Comment（各指摘）** の2層構成で投稿する
- 各インラインコメントには必ず `suggestion` ブロックを含めること
- 指摘がない場合は "コードレビュー結果: 問題なし" とコメントする

For detailed workflow and template, see:
- `.agents/skills/git-review-pr/SKILL.md`
- `.agents/skills/ios-review-code/SKILL.md` (iOS-specific criteria)


## レビューコメント例

**Review Body（レビュー結果サマリー）:**

````markdown
レビュー結果

**判定: 🔄 Request Changes**

| レベル | 件数 |
|---|---|
| 🚫 MUST FIX | 1 |
| ⚠️ SHOULD FIX | 1 |
````

**Inline Comment 例1: 🚫 MUST FIX**

````markdown
🚫 MUST FIX: 強制アンラップの使用

`user.name!` で強制アンラップしていますが、`nil` の場合にクラッシュするドン。`guard let` を使用して安全にアンラップしてくださいドン。

```suggestion
guard let name = user.name else { return }
```
````

**Inline Comment 例2: ⚠️ SHOULD FIX**

````markdown
⚠️ SHOULD FIX: アクセス制御の不足

`fetchData()` メソッドはこの View 内でのみ使用されているため、`private` を付与してスコープを限定してくださいドン。

```suggestion
private func fetchData() async { ... }
```
````


## GitHub Actions 上での動作ルール

- **元PRのブランチへの直接コミット・直接プッシュは一切禁止。例外なし。**
- 修正は `suggestion` ブロックで提案し、PR作成者がワンクリックで適用する運用とする。

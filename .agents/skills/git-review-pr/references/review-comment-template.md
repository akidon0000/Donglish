# レビューコメントテンプレート

## ルール

- レビューコメントは **日本語** で記述する
- 文末は **「ドン」** で終える（AGENTS.md 準拠）
- 各指摘は `<details>` トグルで折りたたむ
- 対応確認用の `- [ ]` チェックボックスを各指摘に付与する
- コード例がある場合は必ず修正前/修正後の両方を示す

## 重要度レベル

| レベル | ラベル | 意味 | PR判定への影響 |
|---|---|---|---|
| 🚫 MUST FIX | `🚫 must` | 修正必須。セキュリティ、クラッシュ、データ破損等 | Request Changes |
| ⚠️ SHOULD FIX | `⚠️ should` | 強く推奨。品質・保守性に影響 | 件数が多ければ Request Changes |
| 💬 NIT | `💬 nit` | 軽微。命名・スタイル・改善提案 | Approve でも可 |
| 👍 GOOD | `👍 good` | 良い実装。肯定フィードバック | — |

## PR 判定基準

| 判定 | 条件 |
|---|---|
| ✅ **Approve** | MUST FIX が 0 件、かつ SHOULD FIX が 2 件以下 |
| 🔄 **Request Changes** | MUST FIX が 1 件以上、または SHOULD FIX が 3 件以上 |

## テンプレート

````markdown
## Code Review

**判定: ✅ Approve** or **判定: 🔄 Request Changes**

| レベル | 件数 |
|---|---|
| 🚫 MUST FIX | X |
| ⚠️ SHOULD FIX | X |
| 💬 NIT | X |
| 👍 GOOD | X |

---

### 🚫 MUST FIX

<details>
<summary>🚫 <code>ファイル名:行番号</code> — 簡潔な問題タイトル</summary>

**問題ドン:**
問題の詳細な説明ドン。

**修正前:**
```swift
// 現在のコード
```

**修正後:**
```swift
// 修正案のコード
```

- [ ] 対応済み

</details>

---

### ⚠️ SHOULD FIX

<details>
<summary>⚠️ <code>ファイル名:行番号</code> — 簡潔な改善タイトル</summary>

**提案ドン:**
改善の詳細な説明ドン。

```swift
// 改善案のコード例
```

- [ ] 対応済み

</details>

---

### 💬 NIT

<details>
<summary>💬 <code>ファイル名:行番号</code> — 軽微な指摘タイトル</summary>

指摘の説明ドン。

- [ ] 対応済み

</details>

---

### 👍 GOOD

<details>
<summary>👍 <code>ファイル名:行番号</code> — 良い実装のタイトル</summary>

良い点の説明ドン。

</details>
````

## 出力ルール

1. **該当なしのセクションは省略**する（MUST FIX が 0 件なら見出しごと省略）
2. **GOOD は最低 1 件**出す（良い点も認める）
3. **指摘にはコード例を添える**（NIT と GOOD は省略可）
4. **1 つの `<details>` に 1 つの指摘**（複合させない）
5. **ファイル名は相対パス**で記載する（例: `Models/DrillFlow.swift:42`）

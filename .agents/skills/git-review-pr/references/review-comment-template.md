## Review Body（レビュー結果サマリー）

レビュー本文として投稿する。

````markdown
レビュー結果

**判定: ✅ Approve** or **判定: 🔄 Request Changes**

| レベル | 件数 |
|---|---|
| 🚫 MUST FIX | X |
| ⚠️ SHOULD FIX | X |
````

---

## Inline Comment（各指摘）

該当コード行に対するインラインコメントとして投稿する。
各指摘には必ず `suggestion` ブロックを含めること。

### 🚫 MUST FIX テンプレート

````markdown
🚫 MUST FIX: 簡潔な問題タイトル

問題の説明ドン。

```suggestion
修正後のコード
```
````

### ⚠️ SHOULD FIX テンプレート

````markdown
⚠️ SHOULD FIX: 簡潔な改善タイトル

改善の説明ドン。

```suggestion
修正後のコード
```
````

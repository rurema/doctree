---
library:
#%since 3.4
  - rdoc/code_object/context
#%end
#%until 3.4
  - rdoc/context
#%end
include:
  - RDoc::Text
---
# class RDoc::Context::Section

section に関する情報を保持するクラスです。

ドキュメント中で以下のように記述した情報を保持しています。

```text
# :section: The title
# The body
```

## Class Methods

### def RDoc::Context::Section.new(parent, title, comment) -> RDoc::Context::Section

自身を初期化します。

- **param** `parent` -- [c:RDoc::Context] オブジェクトを指定します。

- **param** `title` -- section のタイトルを文字列で指定します。

- **param** `comment` -- section のコメントを文字列で指定します。

また、section のシーケンス番号を新しく作成します。

## Instance Methods

### def title -> String | nil

section のタイトルを返します。

### def comment -> String | nil

section のコメントを返します。

### def ==(other) -> bool

自身と other のシーケンス番号を比較した結果を返します。

- **param** `other` -- [c:RDoc::Context::Section] オブジェクトを指定します。

### def inspect -> String

自身の情報を人間に読みやすい文字列にして返します。

### def parent -> RDoc::Context

自身が所属する [c:RDoc::Context] オブジェクトを返します。

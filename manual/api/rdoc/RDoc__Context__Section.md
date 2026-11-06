---
library:
#%since 3.4
  - rdoc/code_object/context
#%else
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

#%since 4.1
### def RDoc::Context::Section.new(parent, title, comment, store = nil) -> RDoc::Context::Section
#%else
### def RDoc::Context::Section.new(parent, title, comment) -> RDoc::Context::Section
#%end

自身を初期化します。

- **param** `parent` -- [c:RDoc::Context] オブジェクトを指定します。

- **param** `title` -- section のタイトルを文字列で指定します。

- **param** `comment` -- section のコメントを `RDoc::Comment` オブジェクト(またはその配列)で指定します。nil も指定できます。

#%since 4.1
- **param** `store` -- このオブジェクトが属する `RDoc::Store` オブジェクトを指定します。

#%end
- **raise** `TypeError` -- `comment` に文字列など受け付けない型のオブジェクトを指定した場合に発生します。

## Instance Methods

### def title -> String | nil

section のタイトルを返します。

### def comment -> String | nil

section のコメントを返します。

### def ==(other) -> bool
### def eql?(other) -> bool
{: since=""}

`other` が [c:RDoc::Context::Section] オブジェクトで、タイトルが自身と同じ場合に真を返します。

- **param** `other` -- [c:RDoc::Context::Section] オブジェクトを指定します。

### def inspect -> String

自身の情報を人間に読みやすい文字列にして返します。

### def parent -> RDoc::Context

自身が所属する [c:RDoc::Context] オブジェクトを返します。

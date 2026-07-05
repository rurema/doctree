---
library: json
---
# reopen Class

## Public Instance Methods

### def json_creatable? -> bool

シリアライズされた JSON 形式の文字列から、インスタンスを作成するのにこのクラスを使用できる場合は
真を返します。そうでない場合は、偽を返します。

このメソッドが真を返すクラスは json_create というメソッドを実装していなければなりません。
また json_create の第一引数は必要なデータを含むハッシュを期待しています。

```ruby title="例"
require "json"

String.json_creatable?  # => true
Dir.json_creatable?     # => false
```


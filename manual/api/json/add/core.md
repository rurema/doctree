---
type: library
require:
  - json/add/date
  - json/add/date_time
  - json/add/exception
  - json/add/range
  - json/add/regexp
  - json/add/struct
  - json/add/symbol
  - json/add/time
---
Ruby のコアクラスに JSON 形式の文字列に変換するメソッドや
JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

json/add/core サブライブラリを require すると、例えば [c:Range] オブ
ジェクトを JSON 形式の文字列にしたり、[c:Range] オブジェクトに戻す事
ができます。

```ruby title="例"
require 'json/add/core'
(1..10).to_json            # => "{\"json_class\":\"Range\",\"a\":[1,10,false]}"
JSON.load((1..10).to_json) # => 1..10
```

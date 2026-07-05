---
library: json
---
# reopen Kernel

## Private Instance Methods

### def j(*objects) -> nil

与えられたオブジェクトを JSON 形式の文字列で標準出力に一行で出力します。

- **param** `objects` -- JSON 形式で出力したいオブジェクトを指定します。

```ruby title="例"
require "json"

j([1,2,{"name" => "tanaka","age" => 19}])
# => [1,2,{"name":"tanaka","age":19}]
```

- **SEE** [m:Kernel?.p]

### def jj(*objects) -> nil

与えられたオブジェクトを JSON 形式の文字列で標準出力に人間に読みやすく整形して出力します。

- **param** `objects` -- JSON 形式で出力したいオブジェクトを指定します。

```ruby title="例"
require "json"

jj([1,2,{"name" => "tanaka","age" => 19}])
# => [
#      1,
#      2,
#      {
#        "name": "tanaka",
#        "age": 19
#      }
#    ]
```

- **SEE** [m:Kernel?.pp]

### def JSON(object, options = {}) -> object

第一引数に与えられたオブジェクトの種類によって Ruby のオブジェクトか JSON 形式の文字列を返します。

第一引数に文字列のようなオブジェクトを指定した場合は、それを [m:JSON?.parse] を用いてパースした結果を返します。
そうでないオブジェクトを指定した場合は、それを [m:JSON?.generate] を用いて変換した結果を返します。

- **param** `object` -- 任意のオブジェクトを指定します。

- **param** `options` -- [m:JSON?.parse], [m:JSON?.generate] に渡すオプションを指定します。

```ruby title="例"
require "json"

JSON('[1,2,{"name":"tanaka","age":19}]')
# => [1, 2, {"name"=>"tanaka", "age"=>19}]

JSON('[1,2,{"name":"tanaka","age":19}]', symbolize_names: true)
# => [1, 2, {:name=>"tanaka", :age=>19}]
```

- **SEE** [m:JSON?.parse], [m:JSON?.generate]


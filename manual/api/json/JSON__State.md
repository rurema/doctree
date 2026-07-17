---
library: json
alias:
  - JSON::Ext::Generator::State
---
# class JSON::State < Object

Ruby オブジェクトから JSON 形式の文字列を生成する間、
JSON 形式の文字列を生成するための設定を保持しておくために使用するクラスです。

実体は [c:JSON::Ext::Generator::State] であり、JSON::State はそれを指す別名(定数)です。
そのため、生成したインスタンスの `class` メソッドや `inspect` の結果には
`JSON::Ext::Generator::State` と表示されます。

## Singleton Methods

### def new(options = {}) -> JSON::State

自身を初期化します。

- **param** `options` -- ハッシュを指定します。
       指定可能なオプションは以下の通りです。

- **`:indent`**:
  インデントに使用する文字列を指定します。デフォルトは空文字列です。
- **`:space`**:
  JSON 形式の文字列のトークン間に挿入する文字列を指定します。デフォルトは空文字列です。
- **`:space_before`**:
  JSON 形式の文字列中で JavaScript のオブジェクトを表す部分にある ':' の
  前に挿入する文字列をセットします。デフォルトは空文字列です。
- **`:object_nl`**:
  JSON 形式の文字列中に現れる JavaScript のオブジェクトの行末に挿入する文字列を指定します。
  デフォルトは空文字列です。
- **`:array_nl`**:
  JSON 形式の文字列中に現れる JavaScript の配列の行末に挿入する文字列を指定します。
  デフォルトは空文字列です。
- **`:check_circular`**:
  真を指定した場合、生成するオブジェクトの循環をチェックします。
  この動作がデフォルトです。
- **`:allow_nan`**:
  真を指定した場合、[m:JSON::NaN], [m:JSON::Infinity],
  [m:JSON::MinusInfinity] を生成することを許すようになります。
  偽を指定した場合、これらの値を生成しようとすると例外が発生します。
  デフォルトは偽です。
- **`:ascii_only`**:
  真を指定した場合、ASCII 文字列のみを用いて JSON 形式の文字列を生成します。
  デフォルトは偽です。
- **`:buffer_initial_length`**:
  sets the initial length of the generator's internal buffer.

  ```ruby title="例 Hash を指定"
  require "json"

  json_state = JSON::State.new(indent: "\t")
  json_state.class  # => JSON::Ext::Generator::State
  json_state.indent # => "\t"
  ```

  ```ruby title="例 JSON::State を指定"
  require "json"

  json_state = JSON::State.new(indent: "\t")
  copy = JSON::State.new(json_state)
  copy.class  # => JSON::Ext::Generator::State
  copy.indent # => "\t"
  ```

### def from_state(options) -> JSON::State

与えられた options によって生成した [c:JSON::State] のインスタンスを返します。

- **param** `options` -- [c:JSON::State] のインスタンスか、ハッシュを指定します。

- **return** -- options がハッシュである場合は、それによって初期化した [c:JSON::State] を
        返します。options が [c:JSON::State] のインスタンスである場合は単に
        options を返します。いずれでも無い場合は、何も設定されていない [c:JSON::State] の
        インスタンスを返します。

```ruby title="例 Hash を指定"
require "json"

json_state = JSON::State.from_state(indent: "\t")
json_state.class  # => JSON::Ext::Generator::State
json_state.indent # => "\t"
```

```ruby title="例 JSON::State を指定"
require "json"

json_state = JSON::State.from_state(indent: "\t")
# JSON を出力する何らかの処理を実行する
same = JSON::State.from_state(json_state)
same.equal?(json_state) # => true
same.class               # => JSON::Ext::Generator::State
same.indent              # => "\t"
```

## Public Instance Methods

### def allow_nan? -> bool

NaN, Infinity, -Infinity を生成できる場合、真を返します。
そうでない場合は偽を返します。

```ruby title="例"
require "json"

json_state = JSON::State.new({})
json_state.allow_nan? # => false
json_state = JSON::State.new(allow_nan: true)
json_state.allow_nan? # => true
```

- **SEE** [rfc:4627]

### def array_nl -> String

JSON の配列の後に出力する文字列を返します。

```ruby title="例"
require "json"

json_state = JSON::State.new({})
json_state.array_nl # => ""
json_state = JSON::State.new(array_nl: "\n")
json_state.array_nl # => "\n"
```

### def array_nl=(str)

JSON の配列の後に出力する文字列をセットします。

```ruby title="例"
require "json"

json_state = JSON::State.new({})
json_state.array_nl        # => ""
json_state.array_nl = "\n"
json_state.array_nl        # => "\n"
```

### def check_circular? -> bool

循環参照のチェックを行う場合は、真を返します。
そうでない場合は偽を返します。

```ruby title="例 ネストをチェックするケース"
require "json"

a = [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[0]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
s = JSON.state.new
begin
  JSON.generate(a, s)
rescue JSON::NestingError => e
  [e, s.max_nesting, s.check_circular?] # => [#<JSON::NestingError: nesting of 100 is too deep>, 100, true]
end
```

```ruby title="例 ネストをチェックしないケース"
require "json"

a = [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[0]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
s2 = JSON.state.new(max_nesting: 0)
json = JSON.generate(a, s2)
[json, s2.max_nesting, s2.check_circular?] # => ["[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[0]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]", 0, false]
```

### def configure(options = {}) -> self
### def merge(options = {})     -> self

与えられたハッシュで自身を設定します。

オプションで使用するハッシュのキーについては [m:JSON::State.new] を参照してください。

- **param** `options` -- このオブジェクトの設定をするためのハッシュを指定します。

```ruby title="例"
require "json"

json_state = JSON::State.new(indent: "\t")
json_state.indent # => "\t"
JSON.generate({key1: "value1", key2: "value2"}, json_state)
# => "{\t\"key1\":\"value1\",\t\"key2\":\"value2\"}"

json_state.configure(indent: "  ")
json_state.indent # => "  "
JSON.generate({key1: "value1", key2: "value2"}, json_state)
# => "{  \"key1\":\"value1\",  \"key2\":\"value2\"}"
```

- **SEE** [m:JSON::State.new]

### def indent -> String

インデントに使用する文字列を返します。

```ruby title="例"
require "json"

json_state = JSON::State.new(indent: "\t")
json_state.indent # => "\t"
JSON.generate({key1: "value1", key2: "value2"}, json_state)
# => "{\t\"key1\":\"value1\",\t\"key2\":\"value2\"}"
```

### def indent=(string)

インデントに使用する文字列をセットします。

- **param** `string` -- インデントに使用する文字列を指定します。

```ruby title="例"
require "json"

json_state = JSON::State.new(indent: "\t")
json_state.indent # => "\t"
JSON.generate({key1: "value1", key2: "value2"}, json_state)
# => "{\t\"key1\":\"value1\",\t\"key2\":\"value2\"}"
json_state.indent = "  "
JSON.generate({key1: "value1", key2: "value2"}, json_state)
# => "{  \"key1\":\"value1\",  \"key2\":\"value2\"}"
```

### def max_nesting -> Integer

生成される JSON 形式の文字列のネストの深さの最大値を返します。

この値がゼロである場合は、ネストの深さのチェックを行いません。

```ruby title="例 ネストの深さチェックを行う"
require "json"

json_state = JSON::State.new(max_nesting: 2)
json_state.max_nesting            # => 2
JSON.generate([[]], json_state)
JSON.generate([[[]]], json_state) # => JSON::NestingError
```

```ruby title="例 ネストの深さチェックを行わない"
require "json"

json_state = JSON::State.new(max_nesting: 0)
json_state.max_nesting            # => 0
JSON.generate([[[[[[[[[[]]]]]]]]]], json_state)
```

### def max_nesting=(depth)

生成される JSON 形式の文字列のネストの深さの最大値をセットします。

この値にゼロをセットすると、ネストの深さのチェックを行いません。

```ruby title="例"
require "json"

json_state = JSON::State.new(max_nesting: 2)
json_state.max_nesting            # => 2
JSON.generate([[]], json_state)
json_state.max_nesting = 3
json_state.max_nesting            # => 3
JSON.generate([[[[]]]], json_state) # => JSON::NestingError
```

### def object_nl -> String

JSON 形式の文字列中に現れる JavaScript のオブジェクトの行末に挿入する文字列を返します。

```ruby title="例"
require "json"

json_state = JSON::State.new(object_nl: "")
json_state.object_nl             # => ""
puts JSON.generate([1, 2, { name: "tanaka", age: 19 }], json_state)
# => [1,2,{"name":"tanaka","age":19}]

json_state = JSON::State.new(object_nl: "\n")
json_state.object_nl             # => "\n"
puts JSON.generate([1, 2, { name: "tanaka", age: 19 }], json_state)

# => [1,2,{
#    "name":"tanaka",
#    "age":19
#    }]
```

### def object_nl=(string)

JSON 形式の文字列中に現れる JavaScript のオブジェクトの行末に挿入する文字列をセットします。

- **param** `string` -- JSON 形式の文字列中に現れる JavaScript のオブジェクトの行末に挿入する文字列を指定します。

```ruby title="例"
require "json"

json_state = JSON::State.new(object_nl: "")
json_state.object_nl             # => ""
puts JSON.generate([1, 2, { name: "tanaka", age: 19 }], json_state)
# => [1,2,{"name":"tanaka","age":19}]

json_state.object_nl = "\n"
json_state.object_nl             # => "\n"
puts JSON.generate([1, 2, { name: "tanaka", age: 19 }], json_state)
 # => [1,2,{
#    "name":"tanaka",
#    "age":19
#    }]
```

### def space -> String

JSON 形式の文字列のトークン間に挿入する文字列を返します。

```ruby title="例"
require "json"

json_state = JSON::State.new(space: "")
json_state.space             # => ""
puts JSON.generate([1, 2, { name: "tanaka", age: 19 }], json_state)
# => [1,2,{"name":"tanaka","age":19}]

json_state = JSON::State.new(space: "\t")
json_state.space             # => "\t"
puts JSON.generate([1, 2, { name: "tanaka", age: 19 }], json_state)
# => [1,2,{"name":  "tanaka","age": 19}]
```

### def space=(string)

JSON 形式の文字列のトークン間に挿入する文字列をセットします。

- **param** `string` -- JSON 形式の文字列のトークン間に挿入する文字列を指定します。

```ruby title="例"
require "json"

json_state = JSON::State.new(space: "")
json_state.space             # => ""
puts JSON.generate([1, 2, { name: "tanaka", age: 19 }], json_state)
# => [1,2,{"name":"tanaka","age":19}]

json_state.space = "\t"
json_state.space             # => "\t"
puts JSON.generate([1, 2, { name: "tanaka", age: 19 }], json_state)
# => [1,2,{"name":  "tanaka","age": 19}]
```

### def space_before -> String

JSON 形式の文字列中で JavaScript のオブジェクトを表す部分にある ':' の
前に挿入する文字列を返します。

```ruby title="例"
require "json"

json_state = JSON::State.new(space_before: "")
json_state.space_before             # => ""
puts JSON.generate([1, 2, { name: "tanaka", age: 19 }], json_state)
# => [1,2,{"name":"tanaka","age":19}]

json_state = JSON::State.new(space_before: " ")
json_state.space_before             # => " "
puts JSON.generate([1, 2, { name: "tanaka", age: 19 }], json_state)
# => [1,2,{"name" :"tanaka","age" :19}]
```

### def space_before=(string)

JSON 形式の文字列中で JavaScript のオブジェクトを表す部分にある ':' の
前に挿入する文字列をセットします。

- **param** `string` -- JSON 形式の文字列中で JavaScript のオブジェクトを表す部分にある ':' の
              前に挿入する文字列をセットします。

```ruby title="例"
require "json"

json_state = JSON::State.new(space_before: "")
json_state.space_before             # => ""
puts JSON.generate([1, 2, { name: "tanaka", age: 19 }], json_state)
# => [1,2,{"name":"tanaka","age":19}]

json_state.space_before = " "
json_state.space_before             # => " "
puts JSON.generate([1, 2, { name: "tanaka", age: 19 }], json_state)
# => [1,2,{"name" :"tanaka","age" :19}]
```

### def to_h    -> Hash
### def to_hash -> Hash

自身をハッシュに変換します。

```ruby title="例"
require "json"
require "pp"

json_state = JSON::State.new
pp json_state.to_h

# => {:indent=>"",
#     :space=>"",
#     :space_before=>"",
#     :object_nl=>"",
#     :array_nl=>"",
#     :allow_nan=>false,
#     :ascii_only=>false,
#     :max_nesting=>100,
#     :depth=>0,
#     :buffer_initial_length=>1024}
```

### def ascii_only? -> bool

ASCII 文字列のみを用いて JSON 形式の文字列を生成する場合に真を返します。
そうでない場合に偽を返します。

### def quirks_mode? -> bool
### def quirks_mode  -> bool

Returns true, if quirks mode is enabled. Otherwise returns false.

### def quirks_mode=(enable)

If set to true, enables the quirks_mode mode.

### def depth -> Integer

This integer returns the current depth of data structure nesting.

### def depth=(depth)

This sets the maximum level of data structure nesting in the generated
JSON to the integer depth, max_nesting = 0 if no maximum should be
checked.

### def buffer_initial_length -> Integer

This integer returns the current initial length of the buffer.

### def buffer_initial_length=(length)

This sets the initial length of the buffer to length, if length > 0,
otherwise its value isn't changed.

### def [](name) -> object

Return the value returned by method name.

### def []=(name, value)

Set the attribute name to value.

### def generate(obj) -> String

Generates a valid JSON document from object obj and returns the
result. If no valid JSON document can be created this method raises a
GeneratorError exception.

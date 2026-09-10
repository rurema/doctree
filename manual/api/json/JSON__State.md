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

### def JSON::State.new(options = {}) -> JSON::State

自身を初期化します。

- **param** `options` -- ハッシュを指定します。
       指定可能なオプションは以下の通りです。

- **`:indent`**:
  インデントに使用する文字列を指定します。デフォルトは空文字列です。
- **`:space`**:
  JSON 形式の文字列のトークン間に挿入する文字列を指定します。デフォルトは空文字列です。
- **`:space_before`**:
  JSON 形式の文字列中で JavaScript のオブジェクトを表す部分にある ':' の前に挿入する文字列をセットします。デフォルトは空文字列です。
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
  JSON 形式の文字列を生成する際に使用する内部バッファの初期の長さを指定します。デフォルトは 1024 です。

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

### def JSON::State.from_state(options) -> JSON::State

与えられた options によって生成した [c:JSON::State] のインスタンスを返します。

- **param** `options` -- [c:JSON::State] のインスタンスか、ハッシュを指定します。

- **return** -- options がハッシュである場合は、それによって初期化した [c:JSON::State] を返します。options が [c:JSON::State] のインスタンスである場合は単に
        options を返します。いずれでも無い場合は、何も設定されていない [c:JSON::State] のインスタンスを返します。

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

#%since 4.1
### def JSON::State.default_sort_keys_proc=(prc)

`sort_keys=` に真を指定したときに使用する、デフォルトの並べ替え用 `Proc` を設定します。

- **param** `prc` -- ハッシュを引数に取り、並べ替えたハッシュを返す `Proc` を指定します。

- **raise** `TypeError` -- `prc` が `Proc` でない場合に発生します。

```ruby title="例"
require "json"

JSON::State.default_sort_keys_proc = ->(hash) { hash.sort.to_h }
state = JSON::State.new(sort_keys: true)
JSON.generate({b: 1, a: 2}, state) # => "{\"a\":2,\"b\":1}"
```

- **SEE** [m:JSON::State#sort_keys=]

#%end

#%since 3.4
### def JSON::State.generate(obj, options, io) -> String | IO

`obj` と `options` から一時的な [c:JSON::State] を作成し、それを使って
`obj` から JSON 形式の文字列を生成します。

- **param** `obj` -- JSON 形式の文字列に変換するオブジェクトを指定します。
- **param** `options` -- [m:JSON::State.new] に指定するのと同様のオプションをハッシュで指定します。
           nil を指定した場合、オプション無しで初期化した [c:JSON::State] を使用します。
- **param** `io` -- 生成した文字列の書き込み先を、write メソッドを持つオブジェクトで指定します。
           nil を指定した場合は、生成した文字列をそのまま返します。
- **return** -- `io` を指定しなかった場合は生成した JSON 形式の文字列を返します。
           `io` を指定した場合は、そこに書き込んだ上で `io` を返します。

```ruby title="例"
require "json"

JSON::State.generate({b: 1, a: 2}, nil, nil) # => "{\"b\":1,\"a\":2}"
JSON::State.generate({b: 1, a: 2}, {indent: "  ", object_nl: "\n"}, nil)
# => "{\n  \"b\":1,\n  \"a\":2\n}"
```

- **SEE** [m:JSON::State.new], [m:JSON::State#generate]

#%end

## Public Instance Methods

### def allow_nan? -> bool
#%since 3.4
### def allow_nan=(enable)
#%end

NaN, Infinity, -Infinity を生成できる場合、`allow_nan?` は真を返します。
そうでない場合は偽を返します。

#%since 3.4
`allow_nan=` は、NaN, Infinity, -Infinity を生成できるかどうかを設定します。
#%end

#%since 3.4
- **param** `enable` -- 真を指定すると NaN, Infinity, -Infinity を生成できるようにします。
           偽を指定すると生成できないようにします。
#%end

```ruby title="例"
require "json"

json_state = JSON::State.new({})
json_state.allow_nan? # => false
json_state = JSON::State.new(allow_nan: true)
json_state.allow_nan? # => true
```

#%since 3.4

```ruby title="例 allow_nan= を使う"
require "json"

json_state = JSON::State.new(allow_nan: true)
json_state.allow_nan? # => true
json_state.allow_nan = false
json_state.allow_nan? # => false
```

#%end

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
p JSON.generate({key1: "value1", key2: "value2"}, json_state)
# => "{\t\"key1\":\"value1\",\t\"key2\":\"value2\"}"

json_state.configure(indent: "  ")
json_state.indent # => "  "
p JSON.generate({key1: "value1", key2: "value2"}, json_state)
# => "{  \"key1\":\"value1\",  \"key2\":\"value2\"}"
```

- **SEE** [m:JSON::State.new]

### def indent -> String

インデントに使用する文字列を返します。

```ruby title="例"
require "json"

json_state = JSON::State.new(indent: "\t")
json_state.indent # => "\t"
p JSON.generate({key1: "value1", key2: "value2"}, json_state)
# => "{\t\"key1\":\"value1\",\t\"key2\":\"value2\"}"
```

### def indent=(string)

インデントに使用する文字列をセットします。

- **param** `string` -- インデントに使用する文字列を指定します。

```ruby title="例"
require "json"

json_state = JSON::State.new(indent: "\t")
json_state.indent # => "\t"
p JSON.generate({key1: "value1", key2: "value2"}, json_state)
# => "{\t\"key1\":\"value1\",\t\"key2\":\"value2\"}"
json_state.indent = "  "
p JSON.generate({key1: "value1", key2: "value2"}, json_state)
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
JSON.generate([[[]]], json_state) # ~> JSON::NestingError
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
JSON.generate([[[[]]]], json_state) # ~> JSON::NestingError
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

JSON 形式の文字列中で JavaScript のオブジェクトを表す部分にある ':' の前に挿入する文字列を返します。

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

JSON 形式の文字列中で JavaScript のオブジェクトを表す部分にある ':' の前に挿入する文字列をセットします。

- **param** `string` -- JSON 形式の文字列中で JavaScript のオブジェクトを表す部分にある ':' の前に挿入する文字列をセットします。

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
#%since 3.4
### def ascii_only=(enable)
#%end

ASCII 文字列のみを用いて JSON 形式の文字列を生成する場合に `ascii_only?` は真を返します。
そうでない場合に偽を返します。

#%since 3.4
`ascii_only=` は、ASCII 文字列のみを用いて JSON 形式の文字列を生成するかどうかを設定します。

- **param** `enable` -- 真を指定すると ASCII 文字列のみを生成するようになります。
           偽を指定すると、ASCII 以外の文字列もそのまま生成するようになります。
#%end

#%since 3.4

```ruby title="例"
require "json"

json_state = JSON::State.new(ascii_only: true)
JSON.generate(["日本語"], json_state) # => "[\"\\u65e5\\u672c\\u8a9e\"]"
json_state.ascii_only = false
JSON.generate(["日本語"], json_state) # => "[\"日本語\"]"
```

#%end

### def depth -> Integer

現在のデータ構造のネストの深さを整数で返します。

### def depth=(depth)

データ構造のネストの深さの現在値を整数 depth にセットします。
インデントを伴う生成では、この深さを起点として出力されます。
ネストの深さの上限([m:JSON::State#max_nesting])とは別の値です。

### def buffer_initial_length -> Integer

現在のバッファの初期の長さを整数で返します。

### def buffer_initial_length=(length)

バッファの初期の長さを length にセットします。length が 0 より大きい場合のみ値がセットされ、それ以外の場合は値は変更されません。

### def [](name) -> object

name という名前のメソッドを呼び出し、その戻り値を返します。

#%since 4.0
このメソッドは非推奨です(json 2.16.0 から)。json 3.0.0 で削除される予定で、代わりの手段として JSON::Coder が挙げられています。
#%end

### def []=(name, value)

属性 name に value をセットします。

#%since 4.0
このメソッドは非推奨です(json 2.16.0 から)。json 3.0.0 で削除される予定で、代わりの手段として JSON::Coder が挙げられています。
#%end

### def generate(obj) -> String

オブジェクト obj から有効な JSON 形式の文字列を生成し、その結果を返します。
有効な JSON 形式の文字列を生成できない場合は、[c:JSON::GeneratorError] 例外が発生します。

#%since 4.0
### def as_json -> Proc | nil
### def as_json=(prc)

`strict?` が真のとき、そのままでは JSON 形式の文字列に変換できないオブジェクトを
変換するために使用する `Proc` を取得・設定します。

設定した `Proc` は、変換できないオブジェクトが現れるたびに、そのオブジェクトと、
それがハッシュのキーとして使われているかどうかを表す真偽値の 2 引数で呼び出されます。
`Proc` の返り値が、代わりに JSON 形式の文字列への変換に使われます。

- **param** `prc` -- 変換できないオブジェクトを変換するための `Proc` を指定します。

```ruby title="例"
require "json"

state = JSON::State.new(strict: true, as_json: ->(obj, is_key) { obj.to_s })
state.as_json.class             # => Proc
JSON.generate([1, 2..3], state) # => "[1,\"2..3\"]"
```

- **SEE** [m:JSON::State#strict]

#%end

#%since 3.3
### def script_safe -> bool
### def script_safe? -> bool
### def script_safe=(enable)
#%end
#%until 4.1
### def escape_slash -> bool
### def escape_slash? -> bool
### def escape_slash=(enable)
#%end

生成する JSON 形式の文字列中のスラッシュ(`/`)をエスケープするかどうかを取得・設定します。
真を指定すると、スラッシュを `\/` としてエスケープします。

#%since 3.3
Ruby 3.3 以降は、スラッシュに加えて U+2028, U+2029 もエスケープするようになりました。
`escape_slash`, `escape_slash?`, `escape_slash=` は、この設定が `script_safe` という
名前になる前から使われている別名です。Ruby 4.1 で削除されます。

#%end

- **param** `enable` -- 真を指定するとエスケープを有効にします。偽を指定すると無効にします。

```ruby title="例"
require "json"

state = JSON::State.new(script_safe: true)
state.script_safe?            # => true
JSON.generate(["a/b"], state) # => "[\"a\\/b\"]"
```

#%since 3.3
### def strict -> bool
### def strict? -> bool
### def strict=(enable)

JSON 形式で表現できない型のオブジェクトが現れたときの挙動を取得・設定します。

偽の場合(デフォルト)、JSON 形式で表現できない型のオブジェクトは文字列に変換されて出力されます。
真の場合、そのようなオブジェクトが現れると [c:JSON::GeneratorError] が発生します。

- **param** `enable` -- 真を指定すると、JSON 形式で表現できない型のオブジェクトが現れたときに
           例外を発生させるようになります。

- **raise** `JSON::GeneratorError` -- `strict?` が真の状態で、JSON 形式で表現できない
           型のオブジェクトを変換しようとした場合に発生します。

```ruby title="例"
require "json"

state = JSON::State.new(strict: true)
state.strict?                            # => true
begin
  JSON.generate([Object.new], state)
rescue JSON::GeneratorError => e
  e.message # => "Object not allowed in JSON"
end
```

- **SEE** `JSON::State#as_json=`

#%end

#%since 4.1
### def sort_keys -> bool | Proc
### def sort_keys=(value)

生成する JSON 形式の文字列で、オブジェクト(ハッシュ)のキーを並べ替えるかどうかを取得・設定します。

`value` に真を指定すると、キーを昇順に並べ替えます。`Proc` を指定すると、
ハッシュ全体を引数としてその `Proc` を呼び出し、返り値のハッシュをそのままの順序で使用します。
これにより任意の並べ替えができます。偽を指定すると並べ替えを行いません(デフォルト)。

- **param** `value` -- 真偽値または `Proc` を指定します。

- **raise** `TypeError` -- `value` が真偽値でも `Proc` でもない場合に発生します。

```ruby title="例"
require "json"

state = JSON::State.new(sort_keys: true)
JSON.generate({b: 1, a: 2}, state) # => "{\"a\":2,\"b\":1}"

state2 = JSON::State.new(sort_keys: ->(hash) { hash.sort_by { |k, v| -v }.to_h })
JSON.generate({a: 1, b: 2}, state2) # => "{\"b\":2,\"a\":1}"
```

- **SEE** [m:JSON::State.default_sort_keys_proc=]

#%end


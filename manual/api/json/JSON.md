---
library: json
---
# module JSON

JSON (JavaScript Object Notation) を扱うためのモジュールです。

## Singleton Methods

### def JSON.[](object, options) -> object

文字列のように扱えるデータを受け取った場合は Ruby のオブジェクトに変換して返します。
そうでない場合は JSON に変換して返します。

- **param** `object` -- 任意のオブジェクト指定可能です。

- **param** `options` -- [m:JSON?.parse], [m:JSON?.generate] の説明を参照してください。

```ruby title="例"
require "json"
string=<<JSON
{ "a":1, "b":2, "c":3 }
JSON
hash = { a: 1, b: 2, c: 3 }

p JSON[string].class                 # => Hash
#%since 3.4
p JSON[string]                       # => {"a" => 1, "b" => 2, "c" => 3}
p JSON[string, symbolize_names: true]  # => {a: 1, b: 2, c: 3}
#%else
p JSON[string]                       # => {"a"=>1, "b"=>2, "c"=>3}
p JSON[string, symbolize_names: true]  # => {:a=>1, :b=>2, :c=>3}
#%end
p JSON[hash].class                   # => String
p JSON[hash]                         # => "{\"a\":1,\"b\":2,\"c\":3}"
```

- **SEE** [m:JSON?.parse], [m:JSON?.generate]

#%until 4.1
### def JSON.create_id -> String

json_create メソッドで使用するクラスを決定するために使用する値を返します。

デフォルトは "json_class" です。

```ruby title="例"
require "json"

class User
  attr :id, :name
  def initialize(id, name)
    @id, @name = id, name
  end

  def self.json_create(object)
    new(object['id'], object["name"])
  end

  def as_json(*)
    {
      JSON.create_id => self.class.name,
      "id" => id,
      "name" => name,
    }
  end

  def to_json(*)
    as_json.to_json
  end
end

json = JSON.generate(User.new(1, "tanaka"))
p json # => "{\"json_class\":\"User\",\"id\":1,\"name\":\"tanaka\"}"
p JSON.parse(json, create_additions: true)
# => #<User:0x0000557709b269e0 @id=1, @name="tanaka">
```

### def JSON.create_id=(identifier)

json_create メソッドで使用するクラスを決定するために使用する値をセットします。

- **param** `identifier` -- 識別子を指定します。

```ruby title="例"
require "json"
require "json/add/core"

p JSON.create_id                 # => "json_class"
puts (1..5).to_json              # => {"json_class":"Range","a":[1,5,false]}
JSON.create_id = "my_json_class" # => "my_json_class"
p JSON.create_id                 # => "my_json_class"
puts (1..5).to_json              # => {"my_json_class":"Range","a":[1,5,false]}
```

#%end

#%# nodoc
#%# --- deep_const_get

### def JSON.generator -> JSON::Ext::Generator

JSON ライブラリがジェネレータとして使用するモジュールを返します。

#%#noexample

#%# nodoc
#%# --- generator=(generator)

### def JSON.parser -> JSON::Ext::Parser

JSON ライブラリがパーサとして使用するクラスを返します。

```ruby title="例"
require "json"

p JSON.parser # => JSON::Ext::Parser
```

#%# nodoc
#%# --- parser=(parser)

### def JSON.state -> JSON::Ext::Generator::State

JSON ライブラリがジェネレータの状態を表すクラスとして使用するクラスを返します。

```ruby title="例"
require "json"

p JSON.state # => JSON::Ext::Generator::State
```

#%# 他のメソッドから考えると nodoc のはず。
#%# --- state=(state)

#%until 4.1
### def JSON.dump_default_options -> {Symbol => object}
{: since="2.0.0"}
### def JSON.dump_default_options=(val)
{: since="2.0.0"}

[m:JSON?.dump] が使用するデフォルトのオプションを取得・設定します。

初期値は `{max_nesting: false, allow_nan: true}` です。

#%since 4.0
Ruby 4.0 では非推奨で、Ruby 4.1 で削除されます。

#%end

- **param** `val` -- デフォルトのオプションとして使用するハッシュを指定します。

```ruby title="例"
require "json"

p JSON.dump_default_options[:max_nesting] # => false
p JSON.dump_default_options[:allow_nan]   # => true
```

- **SEE** [m:JSON?.dump]

#%end

#%until 4.1
### def JSON.load_default_options -> {Symbol => object}
{: since="2.0.0"}
### def JSON.load_default_options=(val)
{: since="2.0.0"}

[m:JSON?.load] が使用するデフォルトのオプションを取得・設定します。

初期値は `{allow_nan: true, allow_blank: true, create_additions: nil}` です。

#%since 4.0
Ruby 4.0 では非推奨で、Ruby 4.1 で削除されます。

#%end

- **param** `val` -- デフォルトのオプションとして使用するハッシュを指定します。

```ruby title="例"
require "json"

p JSON.load_default_options[:allow_nan]   # => true
p JSON.load_default_options[:allow_blank] # => true
```

- **SEE** [m:JSON?.load]

#%end

#%version 3.4...4.1
### def JSON.unsafe_load_default_options -> {Symbol => object}
### def JSON.unsafe_load_default_options=(val)

`JSON.unsafe_load` が使用するデフォルトのオプションを取得・設定します。

初期値は `{max_nesting: false, allow_nan: true, allow_blank: true, create_additions: true}` です。

#%since 4.0
Ruby 4.0 では非推奨で、Ruby 4.1 で削除されます。

#%end

- **param** `val` -- デフォルトのオプションとして使用するハッシュを指定します。

```ruby title="例"
require "json"

p JSON.unsafe_load_default_options[:create_additions] # => true
```

- **SEE** [m:JSON?.unsafe_load]

#%end

#%until 4.0
### def JSON.iconv(to, from, string) -> String
{: since="1.9.2"}

文字列 `string` の文字エンコーディングを `from` から `to` に変換して返します。

内部的には [m:String#encode] を呼び出しているだけです。

- **param** `to` -- 変換先の文字エンコーディングを文字列で指定します。
- **param** `from` -- 変換元の文字エンコーディングを文字列で指定します。
- **param** `string` -- 変換の対象となる文字列を指定します。

```ruby title="例"
require "json"

p JSON.iconv("UTF-8", "EUC-JP", "test".encode("EUC-JP")) # => "test"
```

#%end

## Module Functions

#%since 3.3
### module_function def dump(object, io = nil, limit = nil, options = nil) -> String | IO
#%else
### module_function def dump(object, io = nil, limit = nil) -> String | IO
#%end

与えられたオブジェクトを JSON 形式の文字列に変換してダンプします。

与えられたオブジェクトを引数として [m:JSON?.generate] を呼び出します。

- **param** `object` -- ダンプするオブジェクトを指定します。

- **param** `io` --  [c:IO] のように write メソッドを実装しているオブジェクトを指定します。

- **param** `limit` -- 指定した場合、limit 段以上深くリンクしたオブジェクトをダンプできません。
#%since 4.1
           `limit` は非推奨です。代わりに `options` の `:max_nesting` を指定してください。
#%end

#%since 3.3
- **param** `options` -- [m:JSON?.generate] と同じオプションをハッシュで指定します。
           キーワード引数の形でも指定できます。
#%since 4.1
           `rfc8785: true` を指定した場合は、`allow_nan` を偽として扱います。
#%end

#%end
#%since 4.1
- **raise** `JSON::NestingError` -- オブジェクトのネストの深さが `limit` または `:max_nesting` を越えた場合に発生します。
#%else
- **raise** `ArgumentError` -- オブジェクトのネストの深さが limit を越えた場合に発生します。
#%end

```ruby title="例"
require "json"

p JSON.dump({ name: "tanaka", age: 19 }) # => "{\"name\":\"tanaka\",\"age\":19}"
```

```ruby title="例"
require "json"

File.open("test.txt", "w") do |f|
  p JSON.dump([[[[[[[[[[]]]]]]]]]], f, 10) # => #<File:test.txt>
#%since 4.1
  JSON.dump([[[[[[[[[[[]]]]]]]]]]], f, 10) # ~> nesting of 11 is too deep. Did you try to serialize objects with circular references? (JSON::NestingError)
#%else
  JSON.dump([[[[[[[[[[[]]]]]]]]]]], f, 10) # => exceed depth limit (ArgumentError)
#%end
end
```

- **SEE** [c:Marshal], [m:Marshal?.dump]

#%until 4.1
### module_function def fast_generate(object) -> String
### module_function def fast_unparse(object) -> String

与えられたオブジェクトを一行の JSON 形式の文字列に変換して返します。

このメソッドは循環参照のチェックを無効にしています。また、
[m:JSON::NaN], [m:JSON::Infinity], [m:JSON::MinusInfinity] を生成することがあります。
このため容易に無限ループを発生させることができるので、気をつけてください。

fast_unparse は将来削除される予定です。

- **param** `object` -- JSON 形式の文字列に変換するオブジェクトを指定します。

```ruby title="例"
require "json"

p JSON.fast_generate({ name: "tanaka", age: 19 }) # => "{\"name\":\"tanaka\",\"age\":19}"
```

#%end

### module_function def generate(object, state = nil) -> String
#%until 4.1
### module_function def unparse(object, state = nil) -> String
#%end

与えられたオブジェクトを一行の JSON 形式の文字列に変換して返します。

デフォルトでは、サイズが最小となる JSON 形式の文字列を生成します。
また、循環参照のチェックを行います。[m:JSON::NaN], [m:JSON::Infinity],
[m:JSON::MinusInfinity] を生成することもありません。

#%until 4.1
unparse は将来削除される予定です。
#%end

- **param** `object` -- JSON 形式の文字列に変換するオブジェクトを指定します。

- **param** `state` -- [c:JSON::State] または、to_hash や to_h メソッドでハッシュに変換可能なオブジェクトを指定できます。
       ハッシュを使用する場合指定可能なオプションは以下の通りです。

- **`:indent`**:
  インデントに使用する文字列を指定します。デフォルトは空文字列です。
- **`:space`**:
  a string that is put after, a : or , delimiter (default: '')
- **`:space_before`**:
  a string that is put before a : pair delimiter (default: '')
- **`:object_nl`**:
  a string that is put at the end of a JSON object (default: '')
- **`:array_nl`**:
  a string that is put at the end of a JSON array (default: '')
- **`:check_circular`**:
  真を指定した場合、生成するオブジェクトの循環をチェックします。
  この動作がデフォルトです。
- **`:allow_nan`**:
  真を指定した場合、[m:JSON::NaN], [m:JSON::Infinity],
  [m:JSON::MinusInfinity] を生成することを許すようになります。
  偽を指定した場合、これらの値を生成しようとすると例外が発生します。
  デフォルトは偽です。
- **`:max_nesting`**:
  入れ子になっているデータの最大の深さを指定します。
  偽を指定すると深さのチェックを行いません。デフォルトは 19 です。
#%since 4.1
- **`:sort_keys`**:
  真を指定すると、オブジェクト(ハッシュ)のキーを昇順に並べ替えます。
  `Proc` を指定すると、その `Proc` で並べ替えます。
  詳しくは [m:JSON::State#sort_keys=] を参照してください。デフォルトは偽です。
- **`:rfc8785`**:
  真を指定すると、[rfc:8785] の JSON Canonicalization Scheme に従って正規化した
  JSON 形式の文字列を生成します。
  詳しくは [m:JSON::State#rfc8785=] を参照してください。デフォルトは偽です。
#%end

- **raise** `JSON::GeneratorError` -- [m:JSON::NaN], [m:JSON::Infinity],[m:JSON::MinusInfinity]
       を生成しようとした場合に発生します。

- **raise** `JSON::CircularDatastructure` -- 与えられたオブジェクトが循環参照を持つ場合に発生します。

```ruby title="例"
require "json"

p JSON.generate([1, 2, { name: "tanaka", age: 19 }])
# => "[1,2,{\"name\":\"tanaka\",\"age\":19}]"
json_state = JSON::State.new(space: " ")
p JSON.generate([1, 2, { name: "tanaka", age: 19 }], json_state)
# => "[1,2,{\"name\": \"tanaka\",\"age\": 19}]"
```

- **SEE** [c:JSON::State], [m:JSON?.pretty_generate]

#%since 4.1
### module_function def load(source, proc = nil, allow_blank: true, **options) -> object
#%else
### module_function def load(source, proc = nil, options = {}) -> object
### module_function def restore(source, proc = nil, options = {}) -> object
#%end

与えられた JSON 形式の文字列を Ruby オブジェクトとしてロードして返します。

[m:JSON?.parse] との違いは、load は信頼できる入力源を読み込むための簡易メソッドである点です。
source には JSON 形式の文字列だけでなく、to_str, to_io, read のいずれかに応答するオブジェクト
(File などの IO や、パスを表すオブジェクトなど) も指定でき、その内容を読み込んだ上で内部的に [m:JSON?.parse] を呼び出します。
#%until 4.1
また、[m:JSON?.parse] とはデフォルトのオプション
(特に create_additions) が異なります。

restore は将来削除される予定です。
#%end

proc として手続きオブジェクトが与えられた場合は、読み込んだオブジェクトを引数にその手続きを呼び出します。

#%since 4.1
オプションはキーワード引数で指定します。
`proc` の位置にハッシュを渡してもオプションとしては扱われず、[m:Hash#to_proc] で変換した手続きとして各値に適用されます。
#%end

```ruby
require 'json'
  
str=<<JSON
[1,2,3]
JSON
  
p JSON.load(str) # => [1,2,3]
p JSON.load(str, proc{|v| p v }) # => [1,2,3]
# 以下が表示される
# 1
# 2
# 3
# [1,2,3]
  
str=<<JSON
{ "a":1, "b":2, "c":3 }
JSON
  
#%since 3.4
p JSON.load(str) # => {"a" => 1, "b" => 2, "c" => 3}
p JSON.load(str, proc{|v| p v }) # => {"a" => 1, "b" => 2, "c" => 3}
#%else
p JSON.load(str) # => {"a"=>1, "b"=>2, "c"=>3}
p JSON.load(str, proc{|v| p v }) # => {"a"=>1, "b"=>2, "c"=>3}
#%end
# 以下が表示される
# "a"
# 1
# "b"
# 2
# "c"
# 3
#%since 3.4
# {"a" => 1, "b" => 2, "c" => 3}
#%else
# {"a"=>1, "b"=>2, "c"=>3}
#%end
```

- **param** `source` -- JSON 形式の文字列を指定します。他には、to_str, to_io, read メソッドを持つオブジェクトも指定可能です。

- **param** `proc` -- [c:Proc] オブジェクトを指定します。

#%since 4.1
- **param** `allow_blank` -- 真を指定すると、`source` が nil または空文字列の場合に nil を返します。
           偽を指定すると、`source` が nil の場合は [c:TypeError] が、
           空文字列の場合は [c:JSON::ParserError] が発生します。デフォルトは真です。

- **param** `options` -- その他のオプションをキーワード引数で指定します。指定可能なオプションは以下の通りです。
#%else
- **param** `options` -- オプションをハッシュで指定します。指定可能なオプションは以下の通りです。
#%end

- **`:max_nesting`**:
  入れ子になっているデータの最大の深さを指定します。
  偽を指定すると深さのチェックを行いません。デフォルトは偽です。
- **`:allow_nan`**:
  真を指定した場合、[m:JSON::NaN], [m:JSON::Infinity],
  [m:JSON::MinusInfinity] を生成することを許すようになります。
  偽を指定した場合、これらの値を生成しようとすると例外が発生します。デフォルトは真です。
#%until 4.1
- **`:allow_blank`**:
  真を指定すると、sourceがnilの場合にnilを返します。デフォルトは真です。
#%end
#%until 4.1
- **`:create_additions`**:
  偽を指定するとマッチするクラスや [m:JSON.create_id] が見つかっても付加情報を生成しません。
  デフォルトは真です。
#%end
- **`:symbolize_names`**:
  真を指定するとハッシュのキーを文字列ではなくシンボルにします。デフォルトは偽です。

#%since 4.1
- **raise** `ArgumentError` -- オプションのハッシュを位置引数で渡した場合や、未知のキーワードを指定した場合に発生します。

#%end
#%since 4.1
### module_function def load_file(filespec, **options) -> object
#%else
### module_function def load_file(filespec, opts = {}) -> object
#%end

filespec で指定した JSON 形式のファイルを Ruby オブジェクトとしてロードして返します。

#%since 4.1
オプションはキーワード引数で指定します。

#%end
- **param** `filespec` -- ファイル名を指定します。

#%since 4.1
- **param** `options` -- オプションをキーワード引数で指定します。指定可能なオプションは [m:JSON?.parse] と同様です。

- **raise** `ArgumentError` -- オプションのハッシュを位置引数で渡した場合や、未知のキーワードを指定した場合に発生します。
#%else
- **param** `opts` -- オプションをハッシュで指定します。指定可能なオプションは [m:JSON?.parse] と同様です。
#%end

- **SEE** [m:JSON?.parse]

#%since 4.1
### module_function def load_file!(filespec, **options) -> object
#%else
### module_function def load_file!(filespec, opts = {}) -> object
#%end

filespec で指定した JSON 形式のファイルを Ruby オブジェクトとしてロードして返します。

#%since 4.1
オプションはキーワード引数で指定します。

#%end
- **param** `filespec` -- ファイル名を指定します。

#%since 4.1
- **param** `options` -- オプションをキーワード引数で指定します。指定可能なオプションは [m:JSON?.parse!] と同様です。

- **raise** `ArgumentError` -- オプションのハッシュを位置引数で渡した場合や、未知のキーワードを指定した場合に発生します。
#%else
- **param** `opts` -- オプションをハッシュで指定します。指定可能なオプションは [m:JSON?.parse!] と同様です。
#%end

- **SEE** [m:JSON?.parse!]

#%since 4.1
### module_function def parse(source, on_load: nil, object_class: nil, array_class: nil, **options) -> object
#%else
### module_function def parse(source, options = {}) -> object
#%end

与えられた JSON 形式の文字列を Ruby オブジェクトに変換して返します。

#%since 4.1
オプションはキーワード引数で指定します。

#%end
- **param** `source` -- JSON 形式の文字列を指定します。

#%since 4.1
- **param** `on_load` -- パースで生成した値ごとに呼び出す手続きオブジェクトを指定します。下記の `:on_load` を参照してください。

- **param** `object_class` -- JSON のオブジェクトを変換するクラスを指定します。下記の `:object_class` を参照してください。

- **param** `array_class` -- JSON の配列を変換するクラスを指定します。下記の `:array_class` を参照してください。

- **param** `options` -- その他のオプションをキーワード引数で指定します。
       指定可能なオプションは以下の通りです。
#%else
- **param** `options` -- オプションをハッシュで指定します。
       指定可能なオプションは以下の通りです。
#%end

- **`:max_nesting`**:
  入れ子になっているデータの最大の深さを指定します。
  偽を指定すると深さのチェックを行いません。デフォルトは 19 です。
- **`:allow_nan`**:
  真を指定すると [rfc:4627] を無視してパース時に [m:JSON::NaN], [m:JSON::Infinity],
  [m:JSON::MinusInfinity] を許可するようになります。デフォルトは偽です。
#%until 4.1
- **`:create_additions`**:
  偽を指定するとマッチするクラスや [m:JSON.create_id] が見つかっても付加情報を生成しません。
  デフォルトは偽です。
#%end
- **`:object_class`**:
  JSON のオブジェクトを変換するクラスを指定します。デフォルトは [c:Hash] です。
- **`:array_class`**:
  JSON の配列を変換するクラスを指定します。デフォルトは [c:Array] です。
#%since 4.1
- **`:on_load`**:
  パースで生成したすべての値(文字列・数値・true・false・nil・配列・ハッシュ。オブジェクトのキーの文字列も含みます)ごとに
  呼び出す手続きオブジェクトを指定します。手続きの返り値が、その値の代わりに使われます。
  デフォルトは nil です。
#%end
- **`:symbolize_names`**:
  真を指定するとハッシュのキーを文字列ではなくシンボルにします。デフォルトは偽です。

  ```ruby title="例"
  require "json"

  JSON.parse('[1,2,{"name":"tanaka","age":19}]')
#%since 3.4
  # => [1, 2, {"name" => "tanaka", "age" => 19}]

  JSON.parse('[1,2,{"name":"tanaka","age":19}]', symbolize_names: true)
  # => [1, 2, {name: "tanaka", age: 19}]
#%else
  # => [1, 2, {"name"=>"tanaka", "age"=>19}]

  JSON.parse('[1,2,{"name":"tanaka","age":19}]', symbolize_names: true)
  # => [1, 2, {:name=>"tanaka", :age=>19}]
#%end
  ```

#%since 4.1
- **raise** `ArgumentError` -- オプションのハッシュを位置引数で渡した場合や、未知のキーワードを指定した場合に発生します。

```ruby title="例 on_load を指定する"
require "json"

JSON.parse('[1,2]', on_load: ->(o) { o.is_a?(Integer) ? o * 10 : o }) # => [10, 20]
```

```ruby title="例 オプションをハッシュで渡した場合と未知のキーワードを指定した場合"
require "json"

JSON.parse('{"a":1}', {symbolize_names: true}) # ~> wrong number of arguments (given 2, expected 1) (ArgumentError)
JSON.parse('{"a":1}', foo: 1)                  # ~> unknown keyword: foo (ArgumentError)
```

#%end
- **SEE** [m:JSON::Parser#parse]

#%since 4.1
### module_function def parse!(source, **options) -> object
#%else
### module_function def parse!(source, options = {}) -> object
#%end

与えられた JSON 形式の文字列を Ruby オブジェクトに変換して返します。

[m:JSON?.parse] よりも危険なデフォルト値が指定されているので信頼できる文字列のみを入力として使用するようにしてください。

#%since 4.1
オプションはキーワード引数で指定します。

#%end
- **param** `source` -- JSON 形式の文字列を指定します。

#%since 4.1
- **param** `options` -- オプションをキーワード引数で指定します。
       指定可能なオプションは以下の通りです。
#%else
- **param** `options` -- オプションをハッシュで指定します。
       指定可能なオプションは以下の通りです。
#%end

- **`:max_nesting`**:
  入れ子になっているデータの最大の深さを指定します。
  数値を指定すると深さのチェックを行います。偽を指定すると深さのチェックを行いません。
  デフォルトは偽です。
- **`:allow_nan`**:
  真を指定すると [rfc:4627] を無視してパース時に [m:JSON::NaN], [m:JSON::Infinity],
  [m:JSON::MinusInfinity] を許可するようになります。デフォルトは真です。
#%until 4.1
- **`:create_additions`**:
  偽を指定するとマッチするクラスや [m:JSON.create_id] が見つかっても付加情報を生成しません。
  デフォルトは偽です。
#%end

  ```ruby title="例"
  require "json"

  json_text = "[1,2,{\"name\":\"tanaka\",\"age\":19}, NaN]"
  JSON.parse!(json_text)
#%since 3.4
  # => [1, 2, {"name" => "tanaka", "age" => 19}, NaN]

  JSON.parse!(json_text, symbolize_names: true)
  # => [1, 2, {name: "tanaka", age: 19}, NaN]
#%else
  # => [1, 2, {"name"=>"tanaka", "age"=>19}, NaN]

  JSON.parse!(json_text, symbolize_names: true)
  # => [1, 2, {:name=>"tanaka", :age=>19}, NaN]
#%end

  JSON.parse(json_text) # => unexpected token at 'NaN]' (JSON::ParserError)
  ```

#%since 4.1
- **raise** `ArgumentError` -- オプションのハッシュを位置引数で渡した場合や、未知のキーワードを指定した場合に発生します。

#%end
- **SEE** [m:JSON::Parser#parse]

### module_function def pretty_generate(object, options = nil) -> String
#%until 4.1
### module_function def pretty_unparse(object, options = nil) -> String
#%end

Ruby のオブジェクトを JSON 形式の文字列に変換して返します。

このメソッドは [m:JSON?.generate] よりも人間に読みやすい文字列を返します。

#%until 4.1
pretty_unparse は将来削除される予定です。
#%end

- **param** `object` -- JSON 形式の文字列に変換するオブジェクトを指定します。

- **param** `options` -- [c:JSON::State] または、to_hash や to_h メソッドでハッシュに変換可能なオブジェクトを指定できます。
       ハッシュを使用する場合指定可能なオプションは [m:JSON?.generate] を参照してください。

#%since 4.1
- **raise** `ArgumentError` -- `:rfc8785` オプションに真を指定した場合に発生します。
#%end

```ruby title="例"
require "json"

hash = { "name": "tanaka", "age": 19 }
puts JSON.generate(hash)
# => {"name":"tanaka","age":19}

puts JSON.pretty_generate(hash)
# => {
#      "name": "tanaka",
#      "age": 19
#    }

puts JSON.pretty_generate(hash, space: "\t")
# => {
#      "name":  "tanaka",
#      "age": 19
#    }
```

- **SEE** [m:JSON?.generate]

#%# nodoc?
#%# --- recurse_proc(result, &proc) -> object

#%since 3.4
#%since 4.1
### module_function def unsafe_load(source, proc = nil, **options) -> object
#%else
### module_function def unsafe_load(source, proc = nil, options = nil) -> object
#%end

与えられた JSON 形式の文字列を Ruby オブジェクトとしてロードして返します。

[m:JSON?.load] と同様のメソッドですが、こちらは信頼できる入力を読み込むためのメソッドであることを
名前で明示しています。
#%until 4.1
デフォルトのオプション(`create_additions: true` を含みます)は
`JSON.unsafe_load_default_options` で変更できます。
#%end

`source` には JSON 形式の文字列だけでなく、`to_str`, `to_io`, `read` のいずれかに応答するオブジェクト
(File などの [c:IO] や、パスを表すオブジェクトなど) も指定でき、その内容を読み込んだ上で
内部的に [m:JSON?.parse] を呼び出します。

`proc` として手続きオブジェクトが与えられた場合は、読み込んだ結果を引数にその手続きを呼び出し、
その返り値を最終的な結果とします。

#%since 4.1
オプションはキーワード引数で指定します。
`proc` の位置にハッシュを渡してもオプションとしては扱われず、[m:Hash#to_proc] で変換した手続きとして各値に適用されます。

#%end
- **param** `source` -- JSON 形式の文字列を指定します。他には、`to_str`, `to_io`, `read` メソッドを持つオブジェクトも指定可能です。
- **param** `proc` -- [c:Proc] オブジェクトを指定します。
#%since 4.1
- **param** `options` -- オプションをキーワード引数で指定します。指定可能なオプションは [m:JSON?.parse] と同様です。
- **raise** `ArgumentError` -- オプションのハッシュを位置引数で渡した場合や、未知のキーワードを指定した場合に発生します。
#%else
- **param** `options` -- オプションをハッシュで指定します。指定可能なオプションは [m:JSON?.parse] と同様です。
#%end

#%until 4.1

```ruby title="例"
require "json"
require "json/add/core"

json = (1..5).to_json
p JSON.parse(json).class # => Hash
p JSON.unsafe_load(json) # => 1..5
```

#%else

```ruby title="例"
require "json"

p JSON.unsafe_load('[1, [2, [3]]]') # => [1, [2, [3]]]
```

#%end

- **SEE** [m:JSON?.load], [m:JSON?.parse]

#%end

## Constants

### const JSON::VERSION -> String

このライブラリのバージョンを表す文字列です。

#%# nodoc
#%# --- JSON::VERSION_ARRAY -> Array
#%#
#%# --- JSON::VERSION_BUILD -> Fixnum
#%#
#%# --- JSON::VERSION_MAJOR -> Fixnum
#%#
#%# --- JSON::VERSION_MINOR -> Fixnum
#%#

### const Infinity -> Float

正の無限大を表します。

- **SEE** [c:Float]

### const MinusInfinity -> Float

負の無限大を表します。

- **SEE** [c:Float]

### const NaN -> Float

NaN (Not a Number) を表します。

- **SEE** [c:Float]

### const JSON_LOADED -> bool

JSON ライブラリがロード済みである場合に真を返します。
そうでない場合は偽を返します。


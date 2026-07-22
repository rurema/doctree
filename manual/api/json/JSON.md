---
library: json
---
# module JSON

JSON (JavaScript Object Notation) を扱うためのモジュールです。

## Singleton Methods

### def [](object, options) -> object

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
p JSON[string]                       # => {"a"=>1, "b"=>2, "c"=>3}
p JSON[string, symbolize_names: true]  # => {:a=>1, :b=>2, :c=>3}
p JSON[hash].class                   # => String
p JSON[hash]                         # => "{\"a\":1,\"b\":2,\"c\":3}"
```

- **SEE** [m:JSON?.parse], [m:JSON?.generate]

### def create_id -> String

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

### def create_id=(identifier)

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

#@# nodoc
#@# --- deep_const_get

### def generator -> JSON::Ext::Generator

JSON ライブラリがジェネレータとして使用するモジュールを返します。

#@#noexample

#@# nodoc
#@# --- generator=(generator)

### def parser -> JSON::Ext::Parser

JSON ライブラリがパーサとして使用するクラスを返します。

```ruby title="例"
require "json"

p JSON.parser # => JSON::Ext::Parser
```

#@# nodoc
#@# --- parser=(parser)

### def state -> JSON::Ext::Generator::State

JSON ライブラリがジェネレータの状態を表すクラスとして使用するクラスを返します。

```ruby title="例"
require "json"

p JSON.state # => JSON::Ext::Generator::State
```

#@# 他のメソッドから考えると nodoc のはず。
#@# --- state=(state)

## Module Functions

### module_function def dump(object, io = nil, limit = nil) -> String | IO

与えられたオブジェクトを JSON 形式の文字列に変換してダンプします。

与えられたオブジェクトを引数として [m:JSON?.generate] を呼び出します。

- **param** `object` -- ダンプするオブジェクトを指定します。

- **param** `io` --  [c:IO] のように write メソッドを実装しているオブジェクトを指定します。

- **param** `limit` -- 指定した場合、limit 段以上深くリンクしたオブジェクトをダンプできません。

- **raise** `ArgumentError` -- オブジェクトのネストの深さが limit を越えた場合に発生します。

```ruby title="例"
require "json"

p JSON.dump({ name: "tanaka", age: 19 }) # => "{\"name\":\"tanaka\",\"age\":19}"
```

```ruby title="例"
require "json"

File.open("test.txt", "w") do |f|
  p JSON.dump([[[[[[[[[[]]]]]]]]]], f, 10) # => #<File:test.txt>
  JSON.dump([[[[[[[[[[[]]]]]]]]]]], f, 10) # => exceed depth limit (ArgumentError)
end
```

- **SEE** [c:Marshal], [m:Marshal?.dump]

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

### module_function def generate(object, state = nil) -> String
### module_function def unparse(object, state = nil) -> String

与えられたオブジェクトを一行の JSON 形式の文字列に変換して返します。

デフォルトでは、サイズが最小となる JSON 形式の文字列を生成します。
また、循環参照のチェックを行います。[m:JSON::NaN], [m:JSON::Infinity],
[m:JSON::MinusInfinity] を生成することもありません。

unparse は将来削除される予定です。

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

### module_function def load(source, proc = nil, options = {}) -> object
### module_function def restore(source, proc = nil, options = {}) -> object

与えられた JSON 形式の文字列を Ruby オブジェクトとしてロードして返します。

[m:JSON?.parse] との違いは、load は信頼できる入力源を読み込むための簡易メソッドである点です。
source には JSON 形式の文字列だけでなく、to_str, to_io, read のいずれかに応答するオブジェクト
(File などの IO や、パスを表すオブジェクトなど) も指定でき、その内容を読み込んだ上で
内部的に [m:JSON?.parse] を呼び出します。また、[m:JSON?.parse] とはデフォルトのオプション
(特に create_additions) が異なります。

proc として手続きオブジェクトが与えられた場合は、読み込んだオブジェクトを
引数にその手続きを呼び出します。

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
  
p JSON.load(str) # => {"a"=>1, "b"=>2, "c"=>3}
p JSON.load(str, proc{|v| p v }) # => {"a"=>1, "b"=>2, "c"=>3}
# 以下が表示される
# "a"
# 1
# "b"
# 2
# "c"
# 3
# {"a"=>1, "b"=>2, "c"=>3}
```

- **param** `source` -- JSON 形式の文字列を指定します。他には、to_str, to_io, read メソッドを持つオブジェクトも指定可能です。

- **param** `proc` -- [c:Proc] オブジェクトを指定します。

- **param** `options` -- オプションをハッシュで指定します。指定可能なオプションは以下の通りです。

- **`:max_nesting`**:
  入れ子になっているデータの最大の深さを指定します。
  偽を指定すると深さのチェックを行いません。デフォルトは偽です。
- **`:allow_nan`**:
  真を指定した場合、[m:JSON::NaN], [m:JSON::Infinity],
  [m:JSON::MinusInfinity] を生成することを許すようになります。
  偽を指定した場合、これらの値を生成しようとすると例外が発生します。デフォルトは真です。
- **`:allow_blank`**:
  真を指定すると、sourceがnilの場合にnilを返します。デフォルトは真です。
- **`:create_additions`**:
  偽を指定するとマッチするクラスや [m:JSON.create_id] が見つかっても付加情報を生成しません。
  デフォルトは真です。
- **`:symbolize_names`**:
  真を指定するとハッシュのキーを文字列ではなくシンボルにします。デフォルトは偽です。

### module_function def load_file(filespec, opts = {}) -> object

filespec で指定した JSON 形式のファイルを Ruby オブジェクトとしてロードして返します。

- **param** `filespec` -- ファイル名を指定します。

- **param** `options` -- オプションをハッシュで指定します。指定可能なオプションは [m:JSON?.parse] と同様です。

- **SEE** [m:JSON?.parse]

### module_function def load_file!(filespec, opts = {}) -> object

filespec で指定した JSON 形式のファイルを Ruby オブジェクトとしてロードして返します。

- **param** `filespec` -- ファイル名を指定します。

- **param** `options` -- オプションをハッシュで指定します。指定可能なオプションは [m:JSON?.parse!] と同様です。

- **SEE** [m:JSON?.parse!]

### module_function def parse(source, options = {}) -> object

与えられた JSON 形式の文字列を Ruby オブジェクトに変換して返します。

- **param** `source` -- JSON 形式の文字列を指定します。

- **param** `options` -- オプションをハッシュで指定します。
       指定可能なオプションは以下の通りです。

- **`:max_nesting`**:
  入れ子になっているデータの最大の深さを指定します。
  偽を指定すると深さのチェックを行いません。デフォルトは 19 です。
- **`:allow_nan`**:
  真を指定すると [rfc:4627] を無視してパース時に [m:JSON::NaN], [m:JSON::Infinity],
  [m:JSON::MinusInfinity] を許可するようになります。デフォルトは偽です。
- **`:create_additions`**:
  偽を指定するとマッチするクラスや [m:JSON.create_id] が見つかっても付加情報を生成しません。
  デフォルトは偽です。
- **`:symbolize_names`**:
  真を指定するとハッシュのキーを文字列ではなくシンボルにします。デフォルトは偽です。

  ```ruby title="例"
  require "json"

  JSON.parse('[1,2,{"name":"tanaka","age":19}]')
  # => [1, 2, {"name"=>"tanaka", "age"=>19}]

  JSON.parse('[1,2,{"name":"tanaka","age":19}]', symbolize_names: true)
  # => [1, 2, {:name=>"tanaka", :age=>19}]
  ```

- **SEE** [m:JSON::Parser#parse]

### module_function def parse!(source, options = {}) -> object

与えられた JSON 形式の文字列を Ruby オブジェクトに変換して返します。

[m:JSON?.parse] よりも危険なデフォルト値が指定されているので
信頼できる文字列のみを入力として使用するようにしてください。

- **param** `source` -- JSON 形式の文字列を指定します。

- **param** `options` -- オプションをハッシュで指定します。
       指定可能なオプションは以下の通りです。

- **`:max_nesting`**:
  入れ子になっているデータの最大の深さを指定します。
  数値を指定すると深さのチェックを行います。偽を指定すると深さのチェックを行いません。
  デフォルトは偽です。
- **`:allow_nan`**:
  真を指定すると [rfc:4627] を無視してパース時に [m:JSON::NaN], [m:JSON::Infinity],
  [m:JSON::MinusInfinity] を許可するようになります。デフォルトは真です。
- **`:create_additions`**:
  偽を指定するとマッチするクラスや [m:JSON.create_id] が見つかっても付加情報を生成しません。
  デフォルトは偽です。

  ```ruby title="例"
  require "json"

  json_text = "[1,2,{\"name\":\"tanaka\",\"age\":19}, NaN]"
  JSON.parse!(json_text)
  # => [1, 2, {"name"=>"tanaka", "age"=>19}, NaN]

  JSON.parse!(json_text, symbolize_names: true)
  # => [1, 2, {:name=>"tanaka", :age=>19}, NaN]

  JSON.parse(json_text) # => unexpected token at 'NaN]' (JSON::ParserError)
  ```

- **SEE** [m:JSON::Parser#parse]

### module_function def pretty_generate(object, options = nil) -> String
### module_function def pretty_unparse(object, options = nil) -> String

Ruby のオブジェクトを JSON 形式の文字列に変換して返します。

このメソッドは [m:JSON?.generate] よりも人間に読みやすい文字列を返します。

pretty_unparse は将来削除される予定です。

- **param** `object` -- JSON 形式の文字列に変換するオブジェクトを指定します。

- **param** `options` -- [c:JSON::State] または、to_hash や to_h メソッドでハッシュに変換可能なオブジェクトを指定できます。
       ハッシュを使用する場合指定可能なオプションは [m:JSON?.generate] を参照してください。

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

#@# nodoc?
#@# --- recurse_proc(result, &proc) -> object

## Constants

### const VARIANT_BINARY -> bool

拡張ライブラリ版を使用している場合に真を返します。
そうでない場合は偽を返します。

### const JSON::VERSION -> String

このライブラリのバージョンを表す文字列です。

#@# nodoc
#@# --- JSON::VERSION_ARRAY -> Array
#@# 
#@# --- JSON::VERSION_BUILD -> Fixnum
#@# 
#@# --- JSON::VERSION_MAJOR -> Fixnum
#@# 
#@# --- JSON::VERSION_MINOR -> Fixnum
#@#

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


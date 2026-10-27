---
library: json
since: "4.0"
---
# class JSON::Coder < Object

JSON のエンコード(シリアライズ)・デコード(パース)の設定をひとつのオブジェクトにまとめ、再利用可能にするためのクラスです。

[m:JSON?.generate], [m:JSON?.parse] のようなモジュール関数はプロセス全体で設定を共有しますが、
JSON::Coder を使うとライブラリやアプリケーションごとに独立した設定(オプションや、
JSON にネイティブ対応していない型の変換方法)を持つことができます。

[c:JSON::State] の `#[]`, `#[]=` メソッドの代替の手段として、
JSON::Coder の使用が案内されています。

```ruby title="例"
require "json"
require "time"

module MyApp
  API_JSON_CODER = JSON::Coder.new do |object|
    case object
    when Time
      object.iso8601(3)
    else
      object # 未対応の型。ブロックの戻り値も JSON にネイティブ対応していなければエラーになる
    end
  end
end

t = Time.utc(2025, 1, 21, 8, 41, 44, 286_000)
p MyApp::API_JSON_CODER.dump(t) # => "\"2025-01-21T08:41:44.286Z\""
```

## Singleton Methods

#%since 4.1
### def JSON::Coder.new(object_class: nil, array_class: nil, on_load: nil, strict: true, **options) {|object, is_key| ... } -> JSON::Coder
#%else
### def JSON::Coder.new(options = nil) {|object, is_key| ... } -> JSON::Coder
#%end

自身を初期化します。

#%since 4.1
`options` には、JSON 形式の文字列を生成する際([m:JSON?.generate])とパースする際([m:JSON?.parse])の両方に使われるオプションをキーワード引数で指定します。
#%else
options には、JSON 形式の文字列を生成する際([m:JSON?.generate])とパースする際([m:JSON?.parse])の両方に使われるオプションをハッシュで指定します。
#%end
ただし、生成に関しては常に `strict: true` を指定した場合と同様に扱われます。
すなわち、文字列・シンボル・整数・浮動小数点数・配列・ハッシュ・true・false・nil
以外のオブジェクトを変換しようとすると、ブロックが指定されていない限り
[c:JSON::GeneratorError] が発生します。

ブロックを指定すると、上記のような JSON にネイティブ対応していない型のオブジェクトを生成しようとしたときにそのブロックが呼び出されます。
ブロックには対象のオブジェクトと、それがハッシュのキーとして使われているかどうかを表す真偽値が渡されます。
ブロックの返り値が、そのオブジェクトの代わりに変換されます。
返り値の中にさらにネイティブ対応していないオブジェクトが含まれていれば、それに対してもブロックが呼び出されます。[c:JSON::Fragment] を返すと、その内容がそのまま挿入されます。
ハッシュのキーに対する返り値は [c:String] か [c:Symbol] でなければなりません。
不正なエンコーディングの文字列や、ASCII 以外のバイトを含む BINARY(ASCII-8BIT)エンコーディングの文字列に対してもブロックが呼び出されます。
ブロックの返り値もネイティブ対応していない型であった場合は [c:JSON::GeneratorError] が発生します。

#%since 4.1
`strict` に true 以外を指定すると [c:ArgumentError] が発生します。
オプションのハッシュを位置引数で渡した場合も [c:ArgumentError] が発生します。

- **param** `object_class` -- JSON のオブジェクトを変換するクラスを指定します。[m:JSON?.parse] の `object_class` と同じです。

- **param** `array_class` -- JSON の配列を変換するクラスを指定します。[m:JSON?.parse] の `array_class` と同じです。

- **param** `on_load` -- パースで生成した値ごとに呼び出す手続きオブジェクトを指定します。[m:JSON?.parse] の `on_load` と同じです。

- **param** `strict` -- true のみ指定できます。

- **param** `options` -- その他のオプションをキーワード引数で指定します。指定可能なオプションは
  [m:JSON?.generate], [m:JSON?.parse] を参照してください。

- **raise** `ArgumentError` -- `strict` に true 以外を指定した場合や、オプションのハッシュを位置引数で渡した場合、未知のキーワードを指定した場合に発生します。
#%else
- **param** `options` -- ハッシュを指定します。指定可能なオプションは
  [m:JSON?.generate], [m:JSON?.parse] を参照してください。
#%end

```ruby title="例 options はパースと生成の両方に適用される"
require "json"

coder = JSON::Coder.new(symbolize_names: true)
p coder.load('{"name":"Ruby","version":"3.4"}') # => {name: "Ruby", version: "3.4"}
p coder.dump(name: "Ruby", version: "3.4")       # => "{\"name\":\"Ruby\",\"version\":\"3.4\"}"
```

```ruby title="例 ブロックを指定しない場合、未対応の型はエラーになる"
require "json"

coder = JSON::Coder.new
begin
  coder.dump(1..3)
rescue JSON::GeneratorError => e
  p e.message # => "Range not allowed in JSON"
end
```

```ruby title="例 ハッシュのキーと値でブロックの引数が異なる"
require "json"

coder = JSON::Coder.new do |object, is_key|
  is_key ? object.to_s : object.to_a
end
p coder.dump({1..2 => 3..4, "k" => 5..6}) # => "{\"1..2\":[3,4],\"k\":[5,6]}"
```

```ruby title="例 JSON::Fragment で生成済みの JSON を埋め込む"
require "json"

cached = '{"id":1,"name":"Ruby"}'
coder = JSON::Coder.new { |object| JSON::Fragment.new(cached) }
p coder.dump({"item" => Object.new}) # => "{\"item\":{\"id\":1,\"name\":\"Ruby\"}}"
```

- **SEE** [m:JSON::State#as_json=], [m:JSON::State#strict=]

## Public Instance Methods

### def dump(object) -> String
### def dump(object, io) -> IO
### def generate(object) -> String
### def generate(object, io) -> IO

object を JSON 形式の文字列に変換します。

io を指定した場合は、生成した JSON 形式の文字列を io に書き込み、io 自身を返します。
指定しない場合は、生成した文字列を返します。

generate は dump の別名です。

- **param** `object` -- JSON 形式の文字列に変換するオブジェクトを指定します。

- **param** `io` -- [c:IO] のように write メソッドを実装しているオブジェクトを指定します。

- **raise** `JSON::GeneratorError` -- object(またはその内部の値)が JSON にネイティブ対応しておらず、[m:JSON::Coder.new] にブロックも指定されていなかった場合や、ブロックの返り値も JSON にネイティブ対応していなかった場合に発生します。

```ruby title="例"
require "json"

coder = JSON::Coder.new
p coder.dump({ "name" => "Ruby" }) # => "{\"name\":\"Ruby\"}"
p coder.generate({ "name" => "Ruby" }) # => "{\"name\":\"Ruby\"}"
```

### def load(source) -> object
### def parse(source) -> object

source を Ruby のオブジェクトに変換します。

parse は load の別名です。

- **param** `source` -- JSON 形式の文字列を指定します。

- **raise** `JSON::ParserError` -- source が正しい JSON 形式の文字列ではない場合に発生します。

```ruby title="例"
require "json"

coder = JSON::Coder.new
#%since 3.4
p coder.load('{"name":"Ruby"}')  # => {"name" => "Ruby"}
p coder.parse('{"name":"Ruby"}') # => {"name" => "Ruby"}
#%else
p coder.load('{"name":"Ruby"}')  # => {"name"=>"Ruby"}
p coder.parse('{"name":"Ruby"}') # => {"name"=>"Ruby"}
#%end
```

### def load_file(path) -> object

path で指定したファイルの中身を JSON 形式の文字列として読み込み、
Ruby のオブジェクトに変換します。

- **param** `path` -- 読み込む JSON ファイルのパスを指定します。

```ruby title="例"
require "json"
require "tempfile"

coder = JSON::Coder.new
Tempfile.create(["sample", ".json"]) do |f|
  f.write(coder.dump({ "name" => "Ruby" }))
  f.flush
#%since 3.4
  p coder.load_file(f.path) # => {"name" => "Ruby"}
#%else
  p coder.load_file(f.path) # => {"name"=>"Ruby"}
#%end
end
```

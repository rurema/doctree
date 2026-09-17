---
library: json
since: "4.1"
---
# module JSON::GeneratorMethods

オブジェクトを JSON 形式の文字列に変換する [m:JSON::GeneratorMethods#to_json] を提供するモジュールです。

json ライブラリを require すると [c:Object] に include されるため、
すべてのオブジェクトで to_json が使えるようになります。

Ruby 4.0 まで(json 2.x)は [c:Array] や [c:Hash] などのクラスごとに
`JSON::Ext::Generator::GeneratorMethods::Array` のようなモジュールが用意され、
それぞれのクラスに include されていました。json 3.0 でこれらのモジュールは削除され、
このモジュールの to_json ひとつにまとめられました。
JSON のデータ型に対応するオブジェクト(nil、true、false、[c:Integer]、[c:Float]、
[c:Array]、[c:Hash])の変換は生成器側で型ごとに行われるため、
利用者から見た変換結果は Ruby 4.0 までと変わりません。

## Public Instance Methods

### def to_json(state_or_hash = nil) -> String

自身から生成した JSON 形式の文字列を返します。

自身が nil、true、false、[c:Integer]、[c:Float]、[c:Array]、[c:Hash] のいずれかである場合は、
それに対応する JSON の値に変換します。
[c:String] は JSON の文字列に変換します。
それ以外のオブジェクトは to_s で文字列にした結果を JSON の文字列に変換します。
このため、独自のクラスのインスタンスを構造を持った JSON にしたい場合は、
そのクラスで to_json を定義する必要があります。

- **param** `state_or_hash` -- 生成する JSON 形式の文字列をカスタマイズするために [c:JSON::State] のインスタンスか、
                     [m:JSON::State.new] の引数と同じ [c:Hash] を指定します。

```ruby title="例"
require "json"

p [1, 2, 3].to_json                          # => "[1,2,3]"
p({ "name" => "tanaka", "age" => 19 }.to_json) # => "{\"name\":\"tanaka\",\"age\":19}"
p 10.to_json                                 # => "10"
p 1.0.to_json                                # => "1.0"
p nil.to_json                                # => "null"
p true.to_json                               # => "true"
p "test".to_json                             # => "\"test\""
p [1, { a: 1 }].to_json(space: " ")          # => "[1,{\"a\": 1}]"
```

```ruby title="例: 独自クラスの to_json"
require "json"

class Point
  def initialize(x, y)
    @x, @y = x, y
  end

  def to_s
    "(#{@x}, #{@y})"
  end
end

p Point.new(1, 2).to_json # => "\"(1, 2)\""

class Point
  def to_json(*args)
    { "x" => @x, "y" => @y }.to_json(*args)
  end
end

p Point.new(1, 2).to_json # => "{\"x\":1,\"y\":2}"
p [Point.new(1, 2)].to_json # => "[{\"x\":1,\"y\":2}]"
```

- **SEE** [m:JSON?.generate], [c:JSON::State]

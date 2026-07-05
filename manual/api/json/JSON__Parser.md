---
library: json
alias:
  - JSON::Ext::Parser
---
# class JSON::Parser < Object

## Singleton Methods

### def new(source, options => {}) -> JSON::Parser

パーサを初期化します。

第二引数のハッシュには以下のキーを指定できます。

- **`:max_nesting`**:
  データ構造のネストの深さの最大値を指定します。デフォルトは 19 です。
  チェックを無効にするにはゼロまたは偽を指定してください。
- **`:allow_nan`**:
  真を指定すると [rfc:4627] を無視して NaN, Infinity, -Infinity をパースエラーにしません。
  デフォルトは偽です。
- **`:create_additions`**:
  偽を指定するとマッチするクラスや ID があっても付加情報を生成しません。デフォルトは真です。
- **`:object_class`**:
  JSON のオブジェクトを変換するクラスを指定します。デフォルトは [c:Hash] です。
- **`:array_class`**:
  JSON の配列を変換するクラスを指定します。デフォルトは [c:Array] です。

- **param** `source` -- パーサの元となる文字列を指定します。

- **param** `options` -- オプションを指定するためのハッシュです。

```ruby title="例"
require 'json'

parser = JSON::Parser.new(DATA.read)
print parser.source

# => {
# =>   "Tanaka": {
# =>     "name":"tanaka",
# =>     "age":20
# =>   },
# =>   "Suzuki": {
# =>     "name":"suzuki",
# =>     "age":25
# =>   }
# => }

__END__
{
  "Tanaka": {
    "name":"tanaka",
    "age":20
  },
  "Suzuki": {
    "name":"suzuki",
    "age":25
  }
}
```

```ruby title="例 object_class を指定する"
require 'json'

class Person
  attr_accessor :name, :age

  def []=(key, value)
    instance_variable_set("@#{key}", value)
  end
end

parser = JSON::Parser.new(DATA.read, object_class: Person)
person = parser.parse
person.class # => Person
person.name  # => "tanaka"
person.age   # => 20

__END__
{
  "name":"tanaka",
  "age":20
}
```

## Public Instance Methods

### def parse -> object

現在のソースをパースして結果を Ruby のオブジェクトとして返します。

```ruby title="例"
require 'json'

class Person
  attr_accessor :name, :age

  def []=(key, value)
    instance_variable_set("@#{key}", value)
  end
end

parser = JSON::Parser.new(DATA.read, object_class: Person)
person = parser.parse
person.class # => Person
person.name  # => "tanaka"
person.age   # => 20

__END__
{
  "name":"tanaka",
  "age":20
}
```

- **SEE** [m:JSON::Parser#source]

### def source -> String

現在のソースのコピーを返します。

```ruby title="例"
require 'json'

parser = JSON::Parser.new(DATA.read)
print parser.source

# => {
# =>   "Tanaka": {
# =>     "name":"tanaka",
# =>     "age":20
# =>   },
# =>   "Suzuki": {
# =>     "name":"suzuki",
# =>     "age":25
# =>   }
# => }

__END__
{
  "Tanaka": {
    "name":"tanaka",
    "age":20
  },
  "Suzuki": {
    "name":"suzuki",
    "age":25
  }
}
```

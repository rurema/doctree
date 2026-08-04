---
library: _builtin
since: "3.1"
---
# class NoMatchingPatternKeyError < NoMatchingPatternError

パターンマッチのハッシュパターンで、対応するキーが見つからない場合に発生します。

キーは存在するものの値がパターンに一致しない場合は、親クラスの [c:NoMatchingPatternError] が発生します。

パターンマッチについては [d:spec/pattern_matching] を参照してください。

```ruby
data = {name: "ken"}
begin
  data => {age: Integer}
rescue NoMatchingPatternKeyError => e
  p e.key                # => :age
  p e.matchee == data    # => true
end
```

## Class Methods

### def NoMatchingPatternKeyError.new(message = nil, matchee: nil, key: nil) -> NoMatchingPatternKeyError

例外オブジェクトを生成して返します。

- **param** `message` -- エラーメッセージを表す文字列です。

- **param** `matchee` -- パターンマッチの対象となったオブジェクトです。
             [m:NoMatchingPatternKeyError#matchee] で取り出せます。

- **param** `key` -- 見つからなかったキーです。
             [m:NoMatchingPatternKeyError#key] で取り出せます。

```ruby
data = {name: "ken"}
e = NoMatchingPatternKeyError.new("key not found", matchee: data, key: :age)
p e.matchee.equal?(data) # => true
p e.key                  # => :age
```

## Instance Methods

### def matchee -> object

パターンマッチの対象となったオブジェクトを返します。

生成時に matchee が設定されていない場合は [c:ArgumentError] が発生します。

### def key -> object

見つからなかったキーを返します。

生成時に key が設定されていない場合は [c:ArgumentError] が発生します。

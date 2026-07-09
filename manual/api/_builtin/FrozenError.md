---
library: _builtin
since: "2.5.0"
---
# class FrozenError < RuntimeError

[m:Object#freeze]されたオブジェクトを変更しようとした時に発生します。


```ruby title="例"
[1, 2, 3].freeze << 4 # FrozenError: can't modify frozen Array
```

## Class Methods

### def new(error_message = "") -> FrozenError
#@since 2.7.0
### def new(error_message = "", receiver:) -> FrozenError
#@end

例外オブジェクトを生成して返します。

- **param** `error_message` -- エラーメッセージを表す文字列です

#@since 2.7.0
- **param** `receiver` -- 原因となったメソッド呼び出しのレシーバです
#@end

```ruby
err = FrozenError.new("message")
p err       # => #<FrozenError: message>
```

## Instance Methods

#@since 2.7.0
### def receiver -> object

self が発生した時のレシーバオブジェクトを返します。

- **raise** `ArgumentError` -- レシーバが設定されていない時に発生します。

```ruby
begin
  [1, 2, 3].freeze << 4
rescue FrozenError => err
  p err.receiver  # => [1, 2, 3]
end
```
#@end

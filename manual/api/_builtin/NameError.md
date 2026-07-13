---
library: _builtin
---
# class NameError < StandardError

未定義のローカル変数や定数を使用したときに発生します。

例:

`````
bar
`````
#@since 3.4
`````
# => NameError: undefined local variable or method 'bar' for main:Object
`````
#@else
`````
# => NameError: undefined local variable or method `bar' for main:Object
`````
#@end

## Class Methods

### def new(error_message = "", name = nil) -> NameError
#@since 2.6.0
### def new(error_message = "", name = nil, receiver:) -> NameError
#@end

例外オブジェクトを生成して返します。

- **param** `error_message` -- エラーメッセージを表す文字列です

- **param** `name` -- 未定義だったシンボルです

#@since 2.6.0
- **param** `receiver` -- 原因となったメソッド呼び出しのレシーバです
#@end

```ruby title="例"
err = NameError.new("message", "foo")
p err       # => #<NameError: message>
p err.name  # => "foo"
```

## Instance Methods

### def name -> Symbol | String | nil

この例外オブジェクトを発生させる原因となった
変数や定数、メソッドの名前をシンボルで返します。
ただし、不正な定数名を指定して [m:Module#const_get] を呼んだ場合など、
シンボルにできない名前が原因のときは文字列で返すことがあります。
名前が不明な場合は nil を返すこともあります。

例:

`````
begin
  foobar
rescue NameError => err
`````
#@since 3.4
```````
p err       # => #<NameError: undefined local variable or method 'foobar' for main:Object>
```````
#@else
```````
p err       # => #<NameError: undefined local variable or method `foobar' for main:Object>
```````
#@end
`````
  p err.name  # => :foobar
end
`````

### def to_s -> String

例外オブジェクトを文字列に変換して返します。

例:

`````
begin
  foobar
rescue NameError => err
`````
#@since 3.4
```````
p err       # => #<NameError: undefined local variable or method 'foobar' for main:Object>
p err.to_s  # => "undefined local variable or method 'foobar' for main:Object"
```````
#@else
```````
p err       # => #<NameError: undefined local variable or method `foobar' for main:Object>
p err.to_s  # => "undefined local variable or method `foobar' for main:Object"
```````
#@end
`````
end
`````

#@since 2.3.0
### def receiver -> object

self が発生した時のレシーバオブジェクトを返します。

```ruby title="例"
class Sample
  def foo
    return "foo"
  end
end

bar = Sample.new
begin
  bar.bar
rescue NameError => err
  p err.receiver  # => #<Sample:0x007fd4d89b3110>
  p err.receiver.foo  # => "foo"
end
```

### def local_variables -> [Symbol]

self が発生した時に定義されていたローカル変数名の一覧を返します。

内部での使用に限ります。

```ruby title="例"
def foo
  begin
    b = "bar"
    c = 123
    d
  rescue NameError => err
    p err.local_variables #=> [:b, :c, :err]
  end
end

a = "buz"
foo
```

#@end

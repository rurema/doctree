---
library: _builtin
---
# class NoMethodError < NameError

定義されていないメソッドの呼び出しが行われたときに発生します。

```ruby title="例"
self.bar
#@if("3.4" <= version)
# => -:1: undefined method 'bar' for main (NoMethodError)
#@end
#@if("3.3" <= version and version < "3.4")
# => -:1: undefined method `bar' for main (NoMethodError)
#@end
#@if(version < "3.3")
# => -:1: undefined method `bar' for main:Object (NoMethodError)
#@end
```

プライベートなインスタンスメソッドを呼び出そうとした場合にも発生します。

```ruby title="例"
"".puts
#@if("3.4" <= version)
# => -:1:in '<main>': private method 'puts' called for an instance of String (NoMethodError)
#@end
#@if("3.3" <= version and version < "3.4")
# => -:1:in `<main>': private method `puts' called for an instance of String (NoMethodError)
#@end
#@if(version < "3.3")
# => -:1:in `<main>': private method `puts' called for "":String (NoMethodError)
#@end
```

メソッド呼び出しの形式でなければ [c:NameError] 例外が発生します。

```ruby title="例"
bar
#@if("3.4" <= version)
# => -:1: undefined local variable or method 'bar' for main (NameError)
#@end
#@if("3.3" <= version and version < "3.4")
# => -:1: undefined local variable or method `bar' for main (NameError)
#@end
#@if(version < "3.3")
# => -:1: undefined local variable or method `bar' for main:Object (NameError)
#@end
```

## Class Methods

### def new(error_message = "", name = nil, args = nil, priv = false) -> NoMethodError
### def new(error_message = "", name = nil, args = nil, priv = false, receiver:) -> NoMethodError

例外オブジェクトを生成して返します。

- **param** `error_message` -- エラーメッセージを表す文字列です

- **param** `name` -- 未定義だったシンボルです

- **param** `args` -- メソッド呼び出しに使われた引数です

- **param** `priv` -- private なメソッドを呼び出せる形式 (関数形式(レシーバを省略した形式)) で呼ばれたかどうかを指定します
- **param** `receiver` -- 原因となったメソッド呼び出しのレシーバです

```ruby title="例"
nom = NoMethodError.new("message", "foo", [1,2,3])
p nom.name
p nom.args
  
# => "foo"
[1, 2, 3]
```

## Instance Methods

### def args -> [object]

メソッド呼び出しに使われた引数を配列で返します。

```ruby title="例"
begin
  foobar(1,2,3)
rescue NoMethodError
  p $!
  p $!.name
  p $!.args
end

#@if("3.4" <= version)
# => #<NoMethodError: undefined method 'foobar' for main>
#@end
#@if("3.3" <= version and version < "3.4")
# => #<NoMethodError: undefined method `foobar' for main>
#@end
#@if(version < "3.3")
# => #<NoMethodError: undefined method `foobar' for main:Object>
#@end
# => :foobar
# => [1, 2, 3]
```

### def private_call? -> bool

メソッド呼び出しが private なメソッドを呼び出せる形式
(関数形式(レシーバを省略した形式)) で呼ばれたかどうかを返します。

#@since 3.0
### def attr(*name) -> [Symbol]
### def attr(name, true) -> [Symbol]
### def attr(name, false) -> [Symbol]
#@else
### def attr(*name) -> nil
### def attr(name, true) -> nil
### def attr(name, false) -> nil
#@end

インスタンス変数読み取りのためのインスタンスメソッド name を定義します。

#@since 3.0
```ruby title="例"
class User
  p attr :name # => [:name]
  # 複数の名前を渡すこともできる
  p attr :id, :age # => [:id, :age]
end
```
#@end

このメソッドで定義されるアクセスメソッドの定義は次の通りです。

```ruby title="例"
def name
  @name
end
```

第 2 引数 が true で指定された場合には、属性の書き込み用メソッド name= も同時に定義されます。
その定義は次の通りです。

```ruby title="例"
def name=(val)
  @name = val
end
```

第 2 引数 に true か false を指定する方法は非推奨です。

- **param** `name` -- [c:String] または [c:Symbol] で指定します。
#@since 3.0
- **return** -- 定義されたメソッド名を [c:Symbol] の配列で返します。
#@end

#@since 3.0
### def attr_accessor(*name) -> [Symbol]
#@else
### def attr_accessor(*name) -> nil
#@end

インスタンス変数 name に対する読み取りメソッドと書き込みメソッドの両方を
定義します。

#@since 3.0
```ruby title="例"
class User
  p attr_accessor :name # => [:name, :name=]
  # 複数の名前を渡すこともできる
  p attr_accessor :id, :age # => [:id, :id=, :age, :age=]
end
```
#@end

このメソッドで定義されるメソッドの定義は以下の通りです。

```ruby title="例"
def name
  @name
end
def name=(val)
  @name = val
end
```

- **param** `name` -- [c:String] または [c:Symbol] を 1 つ以上指定します。
#@since 3.0
- **return** -- 定義されたメソッド名を [c:Symbol] の配列で返します。
#@end

#@since 3.0
### def attr_reader(*name) -> [Symbol]
#@else
### def attr_reader(*name) -> nil
#@end

インスタンス変数 name の読み取りメソッドを定義します。

#@since 3.0
```ruby title="例"
class User
  p attr_reader :name # => [:name]
  # 複数の名前を渡すこともできる
  p attr_reader :id, :age # => [:id, :age]
end
```
#@end

このメソッドで定義されるメソッドの定義は以下の通りです。

```ruby title="例"
def name
  @name
end
```

- **param** `name` -- [c:String] または [c:Symbol] を 1 つ以上指定します。
#@since 3.0
- **return** -- 定義されたメソッド名を [c:Symbol] の配列で返します。
#@end

#@since 3.0
### def attr_writer(*name) -> [Symbol]
#@else
### def attr_writer(*name) -> nil
#@end

インスタンス変数 name への書き込みメソッド (name=) を定義します。

#@since 3.0
```ruby title="例"
class User
  p attr_writer :name # => [:name=]
  # 複数の名前を渡すこともできる
  p attr_writer :id, :age # => [:id=, :age=]
end
```
#@end

このメソッドで定義されるメソッドの定義は以下の通りです。

```ruby title="例"
def name=(val)
  @name = val
end
```

- **param** `name` -- [c:String] または [c:Symbol] を 1 つ以上指定します。
#@since 3.0
- **return** -- 定義されたメソッド名を [c:Symbol] の配列で返します。
#@end

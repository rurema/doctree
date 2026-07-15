### def singleton_method_added(name) -> object

特異メソッドが追加された時にインタプリタから呼び出されます。

通常のメソッドの追加に対するフックには
[m:Module#method_added]を使います。

- **param** `name` -- 追加されたメソッド名が [c:Symbol] で渡されます。

```ruby title="例"
class Foo
  def singleton_method_added(name)
    puts "singleton method \"#{name}\" was added"
  end
end

obj = Foo.new
def obj.foo
end

#=> singleton method "foo" was added
```

- **SEE** [m:Module#method_added],[m:BasicObject#singleton_method_removed],[m:BasicObject#singleton_method_undefined]

### def singleton_method_removed(name) -> object

特異メソッドが [m:Module#remove_method] に
より削除された時にインタプリタから呼び出されます。

通常のメソッドの削除に対するフックには
[m:Module#method_removed]を使います。

- **param** `name` -- 削除されたメソッド名が [c:Symbol] で渡されます。

```ruby title="例"
class Foo
  def singleton_method_removed(name)
    puts "singleton method \"#{name}\" was removed"
  end
end

obj = Foo.new
def obj.foo
end

class << obj
  remove_method :foo
end

#=> singleton method "foo" was removed
```

- **SEE** [m:Module#method_removed],[m:BasicObject#singleton_method_added],[m:BasicObject#singleton_method_undefined]

### def singleton_method_undefined(name) -> object

特異メソッドが [m:Module#undef_method] または
undef により未定義にされた時にインタプリタから呼び出されます。

通常のメソッドの未定義に対するフックには
[m:Module#method_undefined] を使います。

- **param** `name` -- 未定義にされたメソッド名が [c:Symbol] で渡されます。

```ruby title="例"
class Foo
  def singleton_method_undefined(name)
    puts "singleton method \"#{name}\" was undefined"
  end
end

obj = Foo.new
def obj.foo
end
def obj.bar
end

class << obj
  undef_method :foo
end
obj.instance_eval {undef bar}

#=> singleton method "foo" was undefined
#   singleton method "bar" was undefined
```

- **SEE** [m:Module#method_undefined],[m:BasicObject#singleton_method_added],[m:BasicObject#singleton_method_removed] , [ref:d:spec/def#undef]

### def define_method(name, method) -> Symbol
### def define_method(name) { ... } -> Symbol

インスタンスメソッド name を定義します。

ブロックを与えた場合、定義したメソッドの実行時にブロックが
レシーバクラスのインスタンスの上で [m:BasicObject#instance_eval] されます。

- **param** `name` -- メソッド名を [c:String] または [c:Symbol] を指定します。

- **param** `method` -- [c:Proc]、[c:Method] あるいは [c:UnboundMethod] の
       いずれかのインスタンスを指定します。

- **return** -- メソッド名を表す [c:Symbol] を返します。

- **raise** `TypeError` -- method に同じクラス、サブクラス、モジュール以外のメソッ
                 ドを指定した場合に発生します。

```ruby title="例"
class Foo
  def foo() p :foo end
  define_method(:bar, instance_method(:foo))
end
p Foo.new.bar  # => :foo
```

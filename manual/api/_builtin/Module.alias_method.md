### def alias_method(new, original) -> Symbol

メソッドの別名を定義します。

```ruby title="例"
module Kernel
  p alias_method :hoge, :puts # => :hoge
  p alias_method "foo", :puts # => :foo
end
```

alias との違いは以下の通りです。

  - メソッド名は [c:String] または [c:Symbol] で指定します
  - グローバル変数の別名をつけることはできません

また、クラスメソッドに対して使用することはできません。

#%since 4.1
Ruby 4.1 から、モジュールの中で元のメソッドが [c:Object] へのフォールバックでだけ見つかる場合と、元のメソッドが prepend したモジュールで定義されている場合に deprecation 警告が出ます。詳しくは [ref:d:spec/def#alias] を参照してください。

#%end
- **param** `new` -- 新しいメソッド名。[c:String] または [c:Symbol] で指定します。

- **param** `original` -- 元のメソッド名。[c:String] または [c:Symbol] で指定します。

- **return** -- 作成したエイリアスのメソッド名を表す [c:Symbol] を返します。

- **SEE** [ref:d:spec/def#alias]

```ruby title="例"
module Kernel
  alias_method :foo, :puts
end

foo "bar" # bar
```

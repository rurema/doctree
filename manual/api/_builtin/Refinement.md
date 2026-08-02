---
library: _builtin
since: "3.1"
---
# class Refinement < Module

[m:Module#refine] のブロックの中の `self` のクラスです。

[m:Refinement#import_methods]で他のモジュールからメソッドを
インポートできます。

#%since 3.2
## Instance Methods

#%since 3.3
### def target -> Class | Module

`self` が [m:Module#refine] の対象にしているクラスまたはモジュールを返します。

```ruby
module M
  refine String do
  end
end

p M.refinements[0].target # => String
```

- **SEE** [m:Module#refinements], [m:Module#refine]

#%end
#%until 3.4
### def refined_class -> Class

`self` が [m:Module#refine] の対象にしているクラスを返します。

#%since 3.3
Ruby 3.3 で deprecated になり、Ruby 3.4 で削除されました。
[m:Refinement#target] を使ってください。
`-W:deprecated` を指定すると警告が出ます。
#%end

```ruby
module M
  refine String do
  end
end

p M.refinements[0].refined_class # => String
```

- **SEE** [m:Module#refinements], [m:Module#refine]

#%end
#%end

## Private Instance Methods

### def import_methods(*modules) -> self

モジュールからメソッドをインポートします。

[m:Module#include]と違って、`import_methods` はメソッドをコピーして
refinement に追加して、refinementでインポートしたメソッドを有効化します。

メソッドをコピーするため、Rubyコードで定義されたメソッドだけしか
インポートできないことに注意してください。

```ruby
module StrUtils
  def indent(level)
    ' ' * level + self
  end
end

module M
  refine String do
    import_methods StrUtils
  end
end

using M
p "foo".indent(3) # => "   foo"

module M
  refine String do
    import_methods Enumerable
    # Can't import method which is not defined with Ruby code: Enumerable#drop
  end
end
```

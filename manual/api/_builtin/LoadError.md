---
library: _builtin
---
# class LoadError < ScriptError

[m:Kernel?.require] や [m:Kernel?.load] が失敗したときに発生します。

## Instance Methods

### def path -> String | nil

[m:Kernel?.require] や [m:Kernel?.load] に失敗したパスを返します。

```ruby
begin
  require 'this/file/does/not/exist'
rescue LoadError => e
  p e.path # => 'this/file/does/not/exist'
end
```

パスが定まらない場合は nil を返します。
#@# irb 中で [[m:Kernel.#require_relative]] を実行した場合など。

---
library: _builtin
---
# class LoadError < ScriptError

[m:Kernel?.require]、[m:Kernel?.require_relative]、[m:Kernel?.load] が失敗したときに発生します。

```ruby title="LoadError を捕捉する例"
# lib-a が require できなければ代替の lib-b を使う
begin
  require "lib-a"
rescue LoadError
  require "lib-b"
end
```

`LoadError` は [c:StandardError] のサブクラスではないので、例外型を指定しない `rescue` では捕捉できないことに注意してください。

## Instance Methods

### def path -> String | nil

[m:Kernel?.require]、[m:Kernel?.require_relative]、[m:Kernel?.load] に失敗したパスを返します。

```ruby
begin
  require 'this/file/does/not/exist'
rescue LoadError => e
  p e.path # => 'this/file/does/not/exist'
end
```

[m:Kernel?.eval] に与えた文字列中での [m:Kernel?.require_relative] は、読み込み元のファイルが存在しないため、読み込み先のパスが定まらず、`LoadError` が発生し、`LoadError#path` は `nil` を返します。

```ruby title="LoadError#path が nil になる例"
begin
  eval "require_relative 'foo'"
rescue LoadError => e
  p e.path    # => nil
  p e.message # => "cannot infer basepath"
end
```

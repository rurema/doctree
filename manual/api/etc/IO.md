---
library: etc
---
# reopen IO

## Instance Methods

### def pathconf(name) -> Integer | nil

[man:fpathconf(3)] で取得したファイルの設定変数の値を返します。

引数 name が制限に関する設定値であり、設定が制限がない状態の場合は nil
を返します。([man:fpathconf(3)] が -1 を返し、errno が設定されていない
場合)

- **param** `name` -- [c:Etc] モジュールの PC_ で始まる定数のいずれかを指定します。

```ruby
require 'etc'
IO.pipe {|r, w|
  p w.pathconf(Etc::PC_PIPE_BUF) # => 4096
}
```

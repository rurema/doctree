---
library: rake
---
# reopen FileUtils

## Public Instance Methods

### def sh(*cmd){|result, status| ... }

与えられたコマンドを実行します。

与えられた引数が複数の場合、シェルを経由しないでコマンドを実行します。

- **param** `cmd` -- 引数の解釈に関しては [m:Kernel?.exec] を参照してください。

```ruby title="例"
sh %{ls -ltr}
   
sh 'ls', 'file with spaces'
   
# check exit status after command runs
sh %{grep pattern file} do |ok, res|
  if ! ok
    puts "pattern not found (status = #{res.exitstatus})"
  end
end
```

- **SEE** [m:Kernel?.exec], [m:Kernel?.system]

### def ruby(*args){|result, status| ... }

与えられた引数で Ruby インタプリタを実行します。

- **param** `args` -- Ruby インタプリタに与える引数を指定します。

```ruby title="例"
ruby %{-pe '$_.upcase!' <README}
```

- **SEE** [m:Kernel?.sh]

### def safe_ln(*args)

安全にリンクを作成します。

リンクの作成に失敗した場合はファイルをコピーします。

- **param** `args` -- [m:FileUtils?.cp], [m:FileUtils?.ln] に渡す引数を指定します。

- **SEE** [m:FileUtils?.cp], [m:FileUtils?.ln]

### def split_all(path) -> Array

与えられたパスをディレクトリごとに分割します。

- **param** `path` -- 分割するパスを指定します。

```ruby title="例"
p split_all("a/b/c") # => ["a", "b", "c"]
```


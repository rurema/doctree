ファイル操作のためのライブラリです。

=== 注意
1.8 以降では、ftools の利用は推奨しません。ファイル操作をするには [[lib:fileutils]] を使ってください。

=== 概要
require 'ftools' とすると、ファイルのコピーや削除などのメソッドが追加されます。
to は新たなファイル名かディレクトリ名です。
verbose が真のとき、標準エラー出力に処理の経過が出ます。

= reopen File

== Class Methods

--- copy(from, to[, verbose = false])
--- cp(from, to[, verbose = false])

ファイルをコピーします。より正確には from を読んで to
に書き、モードを変更します。ファイルの更新時刻はコピーした時刻に更
新されます。

例えば、更新時刻を保持したい場合は

  File.copy(from, to)
  stat = File.stat(from)
  File.utime(stat.atime, stat.mtime, to)

などとします。
コピーに成功したなら ture、失敗したなら false を返します。

--- move(from, to[, verbose = false]) 
--- mv(from, to[, verbose = false])

ファイルを移動します。[[m:File.rename]] と異なりパーティション
をまたがる移動もできます。

移動に成功したなら ture、失敗したなら false を返します。

--- compare(from, to[, verbose = false])
--- cmp(from, to[, verbose = false])

2つのファイルを比較します。
同じなら true、異なるなら false を返します。

--- safe_unlink(files[, ...][, verbose = false])
--- rm_f(files[, ...][, verbose = false])

(複数の)ファイルを可能な限り削除します。削除できたファイルの数を
返します。rm -f([[man:rm(1)]]) に相当します。

--- makedirs(dirs[, ...][, verbose = false])
--- mkpath(dirs[, ...][, verbose = false])

(複数の)ディレクトリを作成します。多階層のパスを一度に作成することも可能です。
ディレクトリが既にあれば何もしません。
mkdir -p([[man:mkdir(1)]])に相当します。

--- install(from, to[, mode = nil[, verbose = false]])

ファイルをコピーし、モードを設定します。
コピー先が存在する場合は一旦削除されますので、コピー先のファイルが
他のファイルにハードリンクされていれば、そのリンクは切れます。
install ([[man:install(1)]])コマンドに相当します。

#@# bc-rdoc: detected missing name: catname
--- catname(from, to)

If to is a valid directory, from will be appended to to, adding
and escaping backslashes as necessary. Otherwise, to will be
returned. Useful for appending from to to only if the filename
was not specified in to.

#@# bc-rdoc: detected missing name: syscopy
--- syscopy(from, to)

Copies a file from to to. If to is a directory, copies from to
to/from.

= redefine File
== Class Methods

--- chmod(mode, files[, ...][, verbose = false])

(複数の)ファイルの属性を変えます。
オリジナルの [[m:File.chmod]] に verbose の指定が
追加されるだけです。

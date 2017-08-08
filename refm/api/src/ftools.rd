category Obsolete

ファイル操作のためのライブラリです。

=== 注意
1.8 以降では、ftools の利用は推奨しません。ファイル操作をするには [[lib:fileutils]] を使ってください。

=== 概要
require 'ftools' とすると、ファイルのコピーや削除などのメソッドが追加されます。

= reopen File

== Class Methods

--- copy(from, to, verbose = false) -> bool
--- cp(from, to, verbose = false)  -> bool

ファイルをコピーします。

より正確には from を読んで to に書き、モードを変更します。
ファイルの更新時刻はコピーした時刻に更新されます。

@param from コピー元のファイル。

@param to コピー先のファイル。

@param verbose 真をセットすると詳細を表示します。

@return コピーに成功したなら true、失敗したなら false を返します。

例:
  require "ftools"
  # 更新時刻を保持したい場合
  File.copy(from, to)
  stat = File.stat(from)
  File.utime(stat.atime, stat.mtime, to)


--- move(from, to, verbose = false) -> bool
--- mv(from, to, verbose = false)   -> bool

ファイルを移動します。

[[m:File.rename]] と異なりパーティションをまたがる移動もできます。

@param from 移動元のファイル。

@param to 移動先のファイル。

@param verbose 真をセットすると詳細を表示します。

@return 移動に成功したなら true、失敗したなら false を返します。

--- compare(from, to, verbose = false) -> bool
--- cmp(from, to, verbose = false)     -> bool

2つのファイルを比較します。

@param from 一つのファイル。

@param to もう一つのファイル。

@return 同じなら true、異なるなら false を返します。

#@since 1.8.3
--- safe_unlink(*files) -> Array
--- rm_f(*files)        -> Array
#@else
--- safe_unlink(*files) -> Integer
--- rm_f(*files)        -> Integer
#@end

(複数の)ファイルを可能な限り削除します。

rm -f([[man:rm(1)]]) に相当します。

@param files 削除するファイルを指定します。
             最後の引数が文字列でない場合または真の場合、詳細を出力します。

#@since 1.8.3
@return files を返します。
        最後の引数が文字列でない場合は、最後の引数は取り除かれます。
#@else
@return 削除できたファイル数を返します。
#@end

--- makedirs(*dirs) -> Array
--- mkpath(*dirs)   -> Array

(複数の)ディレクトリを作成します。

多階層のパスを一度に作成することも可能です。
ディレクトリが既にあれば何もしません。
mkdir -p([[man:mkdir(1)]])に相当します。

@param dirs 作成するディレクトリを指定します。
             最後の引数が文字列でない場合または真の場合、詳細を出力します。


--- install(from, to, mode = nil, verbose = false) -> ()

ファイルをコピーし、モードを設定します。

コピー先が存在する場合は一旦削除されますので、コピー先のファイルが
他のファイルにハードリンクされていれば、そのリンクは切れます。
install ([[man:install(1)]])コマンドに相当します。

@param from コピー元のファイル。

@param to コピー先のファイル。

@param mode ファイルのアクセスモード。8進数で指定します。

@param verbose 真を指定すると詳細を表示します。

--- catname(from, to) -> String

from, to から新しい to を作成して返します。

to が有効なディレクトリの場合、to の後ろに from を追加します。
また必要であれば、バックスラッシュをエスケープし、スラッシュを追加します。
to がディレクトリでない場合は、 to をそのまま返します。

--- syscopy(from, to) -> bool

from から to へファイルをコピーします。

to がディレクトリの場合は、 to/from へコピーします。

= redefine File
== Class Methods

--- chmod(mode, *files) -> Integer

(複数の)ファイルの属性を変えます。

オリジナルの [[m:File.chmod]] に verbose の指定が
追加されるだけです。

@param mode

@param files ファイルを指定します。
             最後の引数が文字列でない場合または真の場合、詳細を出力します。


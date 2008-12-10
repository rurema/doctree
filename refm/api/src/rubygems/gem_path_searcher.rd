require rubygems

Gem パッケージに含まれているファイルのうちロード可能なものを検索するためのライブラリです。

= class Gem::GemPathSearcher

Gem パッケージに含まれているファイルのうちロード可能なものを検索するためのクラスです。

== Public Instance Methods

--- find(path) -> nil | Gem::Specification
#@todo

与えられたパスにマッチする [[c:Gem::Specification]] を一つだけ返します。

@see [[m:Array#find]]

--- find_all(path)
#@todo

与えられたパスにマッチする [[c:Gem::Specification]] を全て返します。

@see [[m:Array#find_all]]

--- init_gemspecs -> Array
#@todo

インストール済みの Gem の [[c:Gem::Specification]] のリストを返します。

リストはアルファベット順かつバージョンの新しい順にソートされています。

--- lib_dirs_for(spec) -> String
#@todo

ライブラリの格納されているディレクトリを glob に使える形式で返します。

例:
  '/usr/local/lib/ruby/gems/1.8/gems/foobar-1.0/{lib,ext}'


--- matching_file?(spec, path) -> bool
#@todo

与えられた spec に path が含まれている場合、真を返します。
そうでない場合は偽を返します。

@param spec [[c:Gem::Specification]] のインスタンスを指定します。

@param path 探索対象のパスを指定します。

--- matching_files -> Array
#@todo

与えられた spec に path が含まれている場合、その path のリストを返します。

@param spec [[c:Gem::Specification]] のインスタンスを指定します。

@param path 探索対象のパスを指定します。


== Singleton Methods

--- new
#@todo

検索を行うのに必要なデータを初期化します。



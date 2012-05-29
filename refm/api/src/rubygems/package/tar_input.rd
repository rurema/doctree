gem-format な tar ファイルを読み込む [[c:Gem::Package::TarReader]] のラッ
パークラスを提供するライブラリです。

= class Gem::Package::TarInput
include Gem::Package::FSyncDir
include Enumerable

gem-format な tar ファイルを読み込む [[c:Gem::Package::TarReader]] のラッ
パークラスです。

== Singleton Methods

--- open(io, security_policy = nil){|is| ... }
#@todo ???
ブロックに [[c:Gem::Package::TarInput]] のインスタンスを与えて評価します。

@param io 自身に関連付ける IO を指定します。

@param security_policy ???

== Private Singleton Methods

--- new(io, security_policy = nil)
#@todo ???
このクラスを初期化します。

@param io 自身に関連付ける IO を指定します。

@param security_policy ???


== Public Instance Methods

--- close
#@# -> discard
自身と自身に関連付けられた IO を close します。

--- each{|entry| ... }
#@# -> discard
data.tar.gz の各エントリをブロックに渡してブロックを評価します。

@see [[m:Gem::Package::TarReader#each]]

--- extract_entry(destdir, entry, expected_md5sum = nil)
#@# -> discard
指定された destdir に entry を展開します。

@param destdir 展開先のディレクトリを指定します。

@param entry エントリを指定します。

@param expected_md5sum 期待する MD5 チェックサムを指定します。

@raise Gem::Package::BadCheckSum チェックサムが一致しなかった場合に発生します。

--- load_gemspec(io) -> Gem::Specification | nil

YAML 形式の gemspec を io から読み込みます。

@param io 文字列か [[c:IO]] オブジェクトを指定します。

@see [[m:Gem::Specification.from_yaml]]

--- metadata -> Gem::Specification

メタデータを返します。

--- zipped_stream(entry) -> StringIO

与えられた entry の圧縮したままの StringIO を返します。

@param entry エントリを指定します。

gem-format な tar ファイルを読むためのクラスを提供するライブラリです。

= class Gem::Package::TarReader
include Gem::Package

gem-format な tar ファイルを読むためのクラスです。

== Public Instance Methods

--- close -> nil

自身を close します。

--- each{|entry| ... }
--- each_entry{|entry| ... }

ブロックに一つずつエントリを渡して評価します。

--- rewind -> Integer

自身に関連付けられた IO のファイルポインタを先頭に移動します。または、
[[m:Gem::Package::TarReader.new]] したときの [[m:IO#pos]] にファイルポ
インタを先頭に移動します。

[[m:Gem::Package::TarReader#each]] の実行中に呼ばないようにしてください。

@return 戻った位置を返します。

@raise Gem::Package::NonSeekableIO 自身に関連付けられた IO がシーク可能
                                   でない場合に発生します。

== Singleton Methods

--- new(io) -> Gem::Package::TarReader

io に関連付けて [[c:Gem::Package::TarReader]] を初期化します。

@param io pos, eof?, read, getc, pos= というインスタンスメソッドを持つ
          オブジェクトを指定します。

= class Gem::Package::TarReader::UnexpectedEOF < StandardError

IO がシーク可能でない場合に発生する例外です。


require rubygems
require rubygems/format

Gem リポジトリのインデックスを作成するためのクラスを扱うためのライブラリです。

= class Gem::Indexer
include Gem::UserInteraction

Gem リポジトリのインデックスを作成するためのクラスです。

== Public Instance Methods

--- abbreviate(spec) -> Gem::Specification
#@todo

ダウンロードを速くするために与えられた [[c:GemSpecification]] の持つデータを
小さくします。

@param spec

--- build_indicies
#@todo

インデックスを構築します。

--- collect_specs -> Gem::SourceIndex
#@todo

Gem のキャッシュディレクトリ内の *.gem ファイルから [[c:Gem::Specification]] を集めます。

--- compact_specs(specs) -> Array
#@todo

与えられたスペックを元にスペックを一意に特定できるだけの情報を持った配列を作成して
返します。

@param specs [[c:Gem::Specification]] の配列を指定します。

--- compress(filename, extension)
#@todo

与えられたファイルを圧縮して保存します。

@param filename 圧縮対象のファイル名を指定します。

@param extension 保存するファイル名の拡張子を指定します。

--- dest_directory -> String
#@todo

インデックスを保存するディレクトリを返します。

--- directory -> String
#@todo

インデックスをビルドするための一時的なディレクトリを返します。

--- gem_file_list -> Array
#@todo

インデックスを作成するために使用する Gem ファイルのリストを返します。

--- generate_index
#@todo

インデックスを構築して保存します。

--- gzip(filename)
#@todo

[[m:Zlib::GzipWriter.open]] へのラッパーです。
与えられたファイル名を圧縮して保存します。

--- install_indicies
#@todo

作成済みのインデックスを所定のディレクトリに保存します。

--- make_temp_directories
#@todo

一時的に使用するディレクトリを作成します。

--- paranoid(path, extension)
#@todo

圧縮されたデータと圧縮されていないデータを比較して一致しなければ例外を発生させます。

@param path 圧縮されていないファイルのパスを指定します。

@param extension 圧縮されたファイルの拡張子を指定します。

@raise RuntimeError 圧縮されたデータと圧縮されていないデータが一致しない場合に発生します。

--- sanitize(spec) -> Gem::Specification
#@todo

与えられたスペックの詳細を表す属性をサニタイズします。

non-ASCII の文字列は、サイトインデックスを文字化けさせることがあります。
non-ASCII の文字列を XML エンティティに置換します。

--- sanitize_string(string) -> String
#@todo

与えられた文字列をサニタイズします。

@param string サニタイズ対象の文字列を指定します。

@see [[Gem::Indexer#sanitize]]

== Singleton Methods

--- new(directory)

与えられたディレクトリに Gem リポジトリのインデックスを作成するために
自身を初期化します。

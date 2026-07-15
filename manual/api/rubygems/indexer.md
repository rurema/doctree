---
type: library
include:
  - Gem::UserInteraction
require:
  - rubygems
  - rubygems/format
---
Gem リポジトリのインデックスを作成するためのクラスを扱うためのライブラリです。

# class Gem::Indexer

Gem リポジトリのインデックスを作成するためのクラスです。

## Public Instance Methods

### def abbreviate(spec) -> Gem::Specification

ダウンロードを速くするために与えられた [c:Gem::Specification] の持つデータを
小さくします。

- **param** `spec` -- [c:Gem::Specification] を指定します。

### def build_indices
#@# -> discard

インデックスを構築します。

### def collect_specs -> Gem::SourceIndex

Gem のキャッシュディレクトリ内の *.gem ファイルから [c:Gem::Specification] を集めます。

### def compact_specs(specs) -> Array

与えられたスペックを元にスペックを一意に特定できるだけの情報を持った配列を作成して
返します。

- **param** `specs` -- [c:Gem::Specification] の配列を指定します。

### def compress(filename, extension)
#@# -> discard

与えられたファイルを圧縮して保存します。

- **param** `filename` -- 圧縮対象のファイル名を指定します。

- **param** `extension` -- 保存するファイル名の拡張子を指定します。

### def dest_directory -> String

インデックスを保存するディレクトリを返します。

### def directory -> String

インデックスをビルドするための一時的なディレクトリを返します。

### def gem_file_list -> Array

インデックスを作成するために使用する Gem ファイルのリストを返します。

### def generate_index
#@# -> discard
インデックスを構築して保存します。

### def gzip(filename)
#@# -> discard
[m:Zlib::GzipWriter.open] へのラッパーです。
与えられたファイル名を圧縮して保存します。

### def install_indices
#@# -> discard
作成済みのインデックスを所定のディレクトリに保存します。

### def make_temp_directories
#@# -> discard
一時的に使用するディレクトリを作成します。

### def paranoid(path, extension)
#@# -> discard
圧縮されたデータと圧縮されていないデータを比較して一致しなければ例外を発生させます。

- **param** `path` -- 圧縮されていないファイルのパスを指定します。

- **param** `extension` -- 圧縮されたファイルの拡張子を指定します。

- **raise** `RuntimeError` -- 圧縮されたデータと圧縮されていないデータが一致しない場合に発生します。

### def sanitize(spec) -> Gem::Specification

与えられたスペックの詳細を表す属性をサニタイズします。

non-ASCII の文字列は、サイトインデックスを文字化けさせることがあります。
non-ASCII の文字列を XML エンティティに置換します。

### def sanitize_string(string) -> String

与えられた文字列をサニタイズします。

- **param** `string` -- サニタイズ対象の文字列を指定します。

- **SEE** [m:Gem::Indexer#sanitize]

## Singleton Methods

### def new(directory) -> Gem::Indexer

与えられたディレクトリに Gem リポジトリのインデックスを作成するために
自身を初期化します。

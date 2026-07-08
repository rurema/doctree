---
type: library
---
RubyGems の Gem ファイルの内部構造を扱うためのライブラリです。

- **SEE** [lib:rubygems/format]

# class Gem::OldFormat

RubyGems の Gem ファイルの内部構造を表すクラスです。

- **SEE** [c:Gem::Format]

## Public Instance Methods

### def file_entries -> Array

Gem パッケージに含まれるファイルの配列を返します。

### def file_entries=(file_entries)

Gem パッケージに含まれるファイルの配列をセットします。

- **param** `file_entries` --

### def gem_path -> String

Gem のパスを返します。

### def gem_path=(path)

Gem のパスをセットします。

- **param** `path` -- Gem のパスをセットします。

### def spec -> Gem::Specification

Gem の [c:Gem::Specification] を返します。

### def spec=(spec)

Gem の [c:Gem::Specification] をセットします。

- **param** `spec` -- Gem の [c:Gem::Specification] をセットします。

## Singleton Methods

### def from_file_by_path(file_path) -> Gem::OldFormat

Gem ファイルのパスからデータを読み込んで、自身を初期化して返します。

- **param** `file_path` -- Gem ファイルへのパスを指定します。

### def from_io(io, gem_path = '(io)') -> Gem::OldFormat

Gem ファイルからデータを読み込んだ IO を受け取り、自身を初期化して返します。

- **param** `io` -- Gem パッケージの内容を読み込んだ IO オブジェクトを指定します。

- **param** `gem_path` -- Gem ファイルのパスを指定します。

### def new(gem_path) -> Gem::OldFormat

自身を初期化します。

- **param** `gem_path` -- Gem ファイルへのパスを指定します。

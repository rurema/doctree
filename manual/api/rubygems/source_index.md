---
type: library
include:
  - Enumerable
  - Gem::UserInteraction
extend:
  - Gem::UserInteraction
alias:
  - Gem::Cache
require:
  - rubygems
  - rubygems/user_interaction
  - rubygems/specification
  - rubygems/spec_fetcher
  - rubygems/digest/sha2
  - rubygems/remote_fetcher
  - rubygems/source_info_cache
---
個々のソースから取得した全ての有効な Gem パッケージをインデックス化するためのライブラリです。

# class Gem::SourceIndex

個々のソースから取得した全ての有効な Gem パッケージをインデックス化するためのクラスです。

Gem パッケージのフルネームと それぞれの [c:Gem::Specification] オブジェクトを対応付けます。

## Instance Methods

### def add_spec(gem_spec) -> Gem::Specification

自身に引数で与えられた [c:Gem::Specification] のインスタンスを追加します。

- **param** `gem_spec` -- [c:Gem::Specification] のインスタンスを指定します。

### def add_specs(*gem_specs) -> Hash

自身に引数で与えられた [c:Gem::Specification] のインスタンスを全て追加します。

- **param** `gem_specs` -- 複数の [c:Gem::Specification] のインスタンスを指定します。

### def dump -> ()

自身を [m:Marshal?.dump] します。

### def each{|full_name, gem| ... } -> Hash
### def each -> Enumerator

自身に登録されているそれぞれの Gem についてブロックを評価します。

### def find_name(gem_name, version_requirement = Gem::Requirement.default) -> Gem::Specification

短い名前で正確にマッチする Gem を返します。

- **param** `gem_name` -- Gem の名前を指定します。

- **param** `version_requirement` --

- **SEE** [c:Gem::Requirement]

### def gem_signature(gem_full_name) -> String

与えられた名前を持つ Gem の SHA256 ダイジェストを返します。

- **param** `gem_full_name` -- Gem の名前を指定します。

### def index_signature -> String

ソースインデックスの SHA256 ダイジェストを返します。

この値はインデックスが変更されると変化します。

### def latest_specs -> Array

自身に含まれる最新の [c:Gem::Specification] のリストを返します。

### def size   -> Integer
### def length -> Integer

自身に含まれる Gem の個数を返します。

### def load_gems_in(*spec_dirs) -> self

引数で与えられたディレクトリに含まれる gemspec から自身を再構築して返します。

- **param** `spec_dirs` -- gemspec の含まれているディレクトリを複数指定します。

### def outdated -> Array

更新されていない [c:Gem::Specification] のリストを返します。

### def refresh! -> self

自身を再作成します。

- **raise** `StandardError` -- 自身がディスクから読み込んで作成されていない場合に発生します。

### def remove_spec(full_name) -> Gem::Specification

引数で指定された名前を持つ Gem をインデックスから削除します。

### def search(gem_pattern, platform_only = false) -> [Gem::Specification]

引数で指定された条件を満たす Gem のリストを返します。

- **param** `gem_pattern` -- 検索したい Gem を表す [c:Gem::Dependency] のインスタンスを指定します。

- **param** `platform_only` -- 真を指定するとプラットフォームが一致するもののみを返します。デフォルトは偽です。

### def size -> Integer

自身のサイズを返します。

### def spec_dirs -> [String]

[m:Gem::SourceIndex#refresh!] で自身を更新する時に使用するディレクトリを取得します。

### def spec_dirs=(dirs)

[m:Gem::SourceIndex#refresh!] で自身を更新する時に使用するディレクトリを設定します。

### def specification(full_name) -> Gem::Specification | nil

指定された名前の [c:Gem::Specification] オブジェクトを返します。

- **param** `full_name` -- Gem のフルネームを指定します。

### def update(source_uri, all) -> bool

第一引数で指定された URI を使用して自身を更新します。

- **param** `source_uri` -- 更新に使用する URI を指定します。文字列か [c:URI::Generic] のサブクラスを指定します。

- **param** `all` -- 偽を指定すると最新バージョンの Gem のみ取得します。真を指定すると全てのバージョンの Gem を取得します。

## Singleton Methods

### def new(specifications = {}) -> Gem::SourceIndex

与えられたハッシュを元に自身を初期化します。

- **param** `specifications` -- キーを Gem の名前、値を [c:Gem::Specification] のインスタンスとするハッシュを指定します。

### def from_gems_in(*spec_dirs) -> Gem::SourceIndex

引数で与えられたディレクトリに置かれている Ruby スクリプト形式の gemspec ファイルを使用して
新しいインスタンスを作成します。

- **param** `spec_dirs` -- gemspec ファイルが置かれているディレクトリを一つ以上指定します。

### def from_installed_gems(*deprecated) -> Gem::SourceIndex

与えられたパスをもとに、インスタンスを作成するファクトリメソッドです。

- **param** `deprecated` -- この引数は非推奨です。後方互換性のためにのみ提供されているので使用すべきではありません。

- **SEE** [m:Gem::SourceIndex.from_gems_in]

### def installed_spec_directories -> [String]

gemspec ファイルがインストールされているディレクトリのリストを返します。

- **SEE** [m:Gem?.path]

### def load_specification(file_name) -> Gem::Specification | nil

与えられたファイル名から Ruby スクリプト形式の gemspec をロードして
[c:Gem::Specification] のインスタンスを返します。

- **param** `file_name` -- ファイル名を指定します。

- **raise** `SignalException` -- gemspec をロードしているときに発生します。

- **raise** `SystemExit` -- gemspec をロードしているときに発生します。

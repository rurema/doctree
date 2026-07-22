---
type: library
include:
  - Gem::UserInteraction
require:
  - rubygems
  - rubygems/source_info_cache_entry
  - rubygems/user_interaction
---
個々の Gem パッケージのインデックス情報のコピーを保存するためのライブラリです。

# class Gem::SourceInfoCache

個々の Gem パッケージのインデックス情報のコピーを保存するためのクラスです。

キャッシュの保存場所として以下の二つが存在します。

- **システムキャッシュ**:
  ファイルに対する書き込み権限や作成権限がある場合はこちらを使用します。
- **ユーザーキャッシュ**:
  システムキャッシュが使用できない場合に使用します。

使用するキャッシュを選択すると、全ての操作で選択されたキャッシュを使用します。
また、このクラスは動的にキャッシュの種類を切り替えません。

キャッシュデータはキーが取得元の URI で値が [c:Gem::SourceInfoCacheEntry] のインスタンスであるハッシュです。

## Public Instance Methods

### def cache_data -> Hash

最新のキャッシュデータを返します。

### def cache_file -> String

使用可能なキャッシュファイル名を返します。

システムキャッシュが使用可能な場合はシステムキャッシュのファイル名を返します。
そうでない場合はユーザーキャッシュのファイル名を返します。

### def flush -> false

キャッシュをローカルファイルに書き込みます。

### def latest_cache_data -> Hash

最新のキャッシュデータを返します。

### def latest_cache_file -> String

使用可能な最新のキャッシュファイル名を返します。

システムキャッシュが使用可能な場合はシステムキャッシュのファイル名を返します。
そうでない場合はユーザーキャッシュのファイル名を返します。

- **SEE** [m:Gem::SourceInfoCache#cache_file]

### def latest_system_cache_file -> String

最新のシステムキャッシュのファイル名を返します。

### def latest_user_cache_file -> String

最新のユーザーキャッシュのファイル名を返します。

### def read_all_cache_data -> ()

自身に完全なキャッシュファイルの内容をマージします。

### def read_cache_data(file) -> Hash

与えられたファイル名からデータを読み込んでキャッシュデータを返します。

- **param** `file` -- キャッシュのファイル名を指定します。

- **return** -- 内部で例外が発生した場合は、空のハッシュを返します。

### def refresh(all) -> false

取得元ごとにキャッシュデータを更新します。

- **param** `all` -- 真を指定すると全てのキャッシュを更新します。そうでない場合は、
           最新の Gem パッケージの情報のみ更新します。

### def reset_cache_data -> true

キャッシュデータをリセットします。

### def reset_cache_file -> nil

強制的にキャッシュファイル名をリセットします。

RubyGems ライブラリの結合テストをするのに便利です。

### def reset_cache_for(url, cache_data) -> Hash

指定された URL に対応するキャッシュデータを更新します。

- **param** `url` -- 取得元 URL を指定します。

- **param** `cache_data` -- キャッシュデータを指定します。　

### def search(pattern, platform_only = false, all = false) -> [Gem::Specification]

与えられた条件を満たす [c:Gem::Specification] のリストを返します。

- **param** `pattern` -- 検索したい Gem を表す [c:Gem::Dependency] のインスタンスを指定します。

- **param** `platform_only` -- 真を指定するとプラットフォームが一致するもののみを返します。デフォルトは偽です。

- **param** `all` -- 真を指定するとキャッシュを更新してから検索を実行します。

- **SEE** [m:Gem::SourceIndex#search]

### def search_with_source(pattern, only_platform = false, all = false) -> Array

与えられた条件を満たす [c:Gem::Specification] と URL のリストを返します。

- **param** `pattern` -- 検索したい Gem を表す [c:Gem::Dependency] のインスタンスを指定します。

- **param** `only_platform` -- 真を指定するとプラットフォームが一致するもののみを返します。デフォルトは偽です。

- **param** `all` -- 真を指定するとキャッシュを更新してから検索を実行します。

- **return** -- 第一要素を [c:Gem::Specification]、第二要素を取得元の URL とする配列を要素とする配列を返します。

### def set_cache_data(hash) -> true

直接キャッシュデータをセットします。

このメソッドは主にユニットテストで使用します。

- **param** `hash` -- キャッシュデータとして使用するハッシュを指定します。

### def system_cache_file -> String

システムキャッシュファイルの名前を返します。

### def try_file(path) -> String | nil

与えられたパスがキャッシュファイルとして利用可能な場合、そのパスを返します。
そうでない場合は nil を返します。

- **param** `path` -- キャッシュファイルの候補となるパスを指定します。

### def update -> true

キャッシュが更新されたことをマークします。更新自体は行いません。

### def user_cache_file -> String

ユーザーキャッシュのファイル名を返します。

### def write_cache -> nil

適切なキャッシュファイルにキャッシュデータを書き込みます。

## Singleton Methods

### def cache(all = false) -> Gem::SourceInfoCache

自身のインスタンスを生成するためのメソッドです。

- **param** `all` -- 真を指定すると、インスタンス生成時に全てのキャッシュを再作成します。

### def cache_data -> Hash

キャッシュしているデータを返します。

### def latest_system_cache_file -> String

最新のシステムキャッシュのファイル名を返します。

### def latest_user_cache_file -> String

最新のユーザーキャッシュのファイル名を返します。

### def reset -> nil

自身の内容をクリアします。

### def search(*args) -> [Gem::Specification]

与えられた条件を満たす [c:Gem::Specification] のリストを返します。

- **param** `args` -- 検索条件を指定します。[m:Gem::SourceInfoCache#search] と引数を合わせてください。

- **SEE** [m:Gem::SourceInfoCache#search]

### def search_with_source(*args) -> Array

与えられた条件を満たす [c:Gem::Specification] と URL のリストを返します。

- **param** `args` -- 検索条件を指定します。[m:Gem::SourceInfoCache#search_with_source] と引数を合わせてください。

- **SEE** [m:Gem::SourceInfoCache#search_with_source]

### def system_cache_file -> String

システムキャッシュのファイル名を返します。

### def user_cache_file -> String

ユーザーキャッシュのファイル名を返します。

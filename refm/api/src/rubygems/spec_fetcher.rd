require rubygems
require rubygems/remote_fetcher
require rubygems/user_interaction

リモートリポジトリから Gem のメタデータを取得して更新するためのライブラリです。

= class Gem::SpecFetcher
include Gem::UserInteraction

リモートリポジトリから Gem のメタデータを取得して更新するためのクラスです。

== Singleton Methods

--- fetcher -> Gem::SpecFetcher

このクラスの唯一のインスタンスを返します。

#@# singleton ?

--- fetcher=(fetcher)
#@todo

== Instance Methods

--- cache_dir(uri) -> String

uri の内容を書き込むローカルのディレクトリ名を返します。

@param uri 

--- dir -> String

このクラスが使用するキャッシュ用ディレクトリの名前を返します。

--- fetch(dependency, all = false, matching_platform = true) -> Array

依存関係を満たす gemspec の配列を返します。

@param dependency 依存関係を指定します。
@param all 真を指定するとマッチする全てのバージョンの情報を返します。
@param matching_platform 偽を指定すると全てのプラットフォームの情報を返します。

@see [[c:Gem::Dependency]]

--- fetch_spec(spec, source_uri) -> object
#@todo

@param spec 
@param source_uri

--- find_matching(dependency, all = false, matching_platform = true) -> Array

依存関係を満たす gemspec の名前の配列を返します。

@param dependency 依存関係を指定します。
@param all 真を指定するとマッチする全てのバージョンの情報を返します。
@param matching_platform 偽を指定すると全てのプラットフォームの情報を返します。

@see [[c:Gem::Dependency]]

--- latest_specs -> Hash

キャッシュされている最新の gemspec を返します。

--- legacy_repos -> Array

RubyGems 1.2 未満で作成されたリポジトリの配列を返します。

--- list(all = false) -> Array

[[m:Gem::sources]] に格納されている各ソースから利用可能な Gem のリストを取得して返します。

@param list 真を指定すると全てのバージョンの情報を返します。

--- load_specs(source_uri, file) -> object

指定された source_uri, file から gemspec をロードします。

また、内部ではキャッシュの更新も行っています。

@param source_uri gemspec の置いてある URI を指定します。

@param file gemspec のファイル名を指定します。

--- specs -> Hash

キャッシュされている全ての gemspec を返します。


--- warn_legacy(exception){ ... } -> bool

[[m:Gem::SpecFetcher#fetch]] で例外が発生した場合に呼び出されます。

RubyGems 1.2 未満で作成したリポジトリにアクセスした事が原因で例外が発生した場合には
警告が表示されます。またこの場合、ブロックを与えていればブロックは評価されます。

それ以外の原因で例外が発生した場合は偽を返します。

@param exception 例外オブジェクトを指定します。

@see [[m:Gem::SpecFetcher#fetch]]

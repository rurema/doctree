require rubygems
require rubygems/version
require rubygems/requirement
require rubygems/platform

Gem パッケージのメタデータを扱うためのライブラリです。

通常 gemspec ファイルや Rakefile でメタデータを定義します。

例:

   spec = Gem::Specification.new do |s|
     s.name = 'rfoo'
     s.version = '1.0'
     s.summary = 'Example gem specification'
     ...
   end

#@# @see 

= class Gem::Specification

Gem パッケージのメタデータを扱うためのクラスです。


== Instance Methods

--- _dump -> String

重要なインスタンス変数のみを [[m:Marshal.#dump]] します。

@see [[m:Marshal.#dump]]

--- add_bindir(executables) -> Array | nil

実行コマンドの格納場所を返します。

@param executables 実行コマンド名を格納した配列を指定します。

--- add_dependency
#@todo

--- add_development_dependency(gem, *requirements) -> Array
--- add_runtime_dependency(gem, *requirements) -> Array
#@todo

この Gem を実行するための依存関係を追加します。

例:
  spec.add_runtime_dependency('jabber4r', '> 0.1', '<= 0.5')


@param gem 依存する Gem の名前か [[c:Gem::Dependency]] のインスタンスを指定します。

@param requirements バージョンの必須条件を指定します。デフォルトは ">= 0" です。

@see [[c:Gem::Dependency]]

--- assign_defaults -> ()

全ての属性にデフォルト値をセットします。

これはアクセサメソッドを使用して行われるので、ブロックを用いた特別な初期化も
きちんと実行されます。セットされる値はデフォルト値のコピーです。

--- author -> String

作成者の名前を返します。

--- author=(name)

作成者の名前をセットします。

--- authors -> Array

作成者の名前の配列を返します。

--- authors=(names)

作成者の名前の配列をセットします。

--- autorequire -> String

非推奨の属性です。

--- autorequire=(lib)

非推奨の属性です。

--- bindir -> String

実行ファイルを格納するディレクトリを返します。

--- bindir=(dir)

実行ファイルを格納するディレクトリをセットします。

@param dir 実行ファイルを格納するディレクトリを指定します。デフォルトは "bin" です。

--- cert_chain -> Array
#@todo

--- cert_chain=(arr)
#@todo

@param arr デフォルトは空の配列です。

--- date -> Time

日付を返します。

--- date=(date)

@param date 日付をセットします。デフォルトは今日です。

--- default_executable -> String | nil

Gem パッケージ内で gem コマンド経由で実行するファイルを返します。

--- default_executable=(executable)

Gem パッケージ内で gem コマンド経由で実行するファイルをセットします。

@param executable 実行ファイルを指定します。

--- dependencies -> Array

依存している Gem のリストを返します。

@see [[c:Gem::Dependency]]

--- dependent_gems -> Array

この Gem に依存している全ての Gem の情報のリストを返します。

それぞれのエントリは配列になっており、各要素は以下のようになっています。

 (0) [[c:Gem::Specification]]
 (1) [[c:Gem::Dependency]]
 (2) [[c:Gem::Specification]] の配列


--- description -> String

Gem パッケージの説明を返します。

--- description=(desc)

Gem パッケージの説明をセットします。

@param desc パッケージの詳細を説明する文章を指定します。

--- development_dependencies -> Array

この Gem が依存している Gem のリストを返します。

--- email -> String

メールアドレスを返します。

--- email=(email)

メールアドレスをセットします。

@param email メールアドレスを指定します。

--- executable -> String

実行可能ファイル名を返します。

--- executable=(executable)

実行可能ファイル名をセットします。

@param executable 実行可能ファイル名を指定します。

--- executables -> [String]

実行可能ファイル名のリストを返します。

--- executables=(executables)

実行可能ファイル名のリストをセットします。

@param executables 実行可能ファイル名のリストを指定します。

--- extensions -> [String]

拡張ライブラリをコンパイルするために必要な extconf.rb 形式のファイルのリストを返します。

--- extensions=(paths)

拡張ライブラリをコンパイルするために必要な extconf.rb 形式のファイルのリストをセットします。

@param paths 拡張ライブラリをコンパイルするために必要な extconf.rb 形式のファイルのリストを指定します。

--- extra_rdoc_files -> [String]

RDoc でドキュメントを作成する際に使用する特別なファイルのリストを返します。

--- extra_rdoc_files=(paths)

RDoc でドキュメントを作成する際に使用する特別なファイルのリストをセットします。

@param paths RDoc でドキュメントを作成する際に使用する特別なファイルのリストを指定します。

--- file_name -> String

生成される Gem パッケージの名前を返します。

--- files -> [String]

この Gem パッケージに含まれるファイル名の配列を返します。

--- files=(files)

この Gem パッケージに含まれるファイル名の配列をセットします。

@param files この Gem パッケージに含まれるファイル名の配列を指定します。


--- full_gem_path -> String

この Gem パッケージへのフルパスを返します。

--- full_name -> String

この Gem パッケージのバージョンを含む完全な名前 (name-version) を返します。

プラットフォームの情報が指定されている場合は、それも含みます (name-version-platform)。

--- has_rdoc -> bool

真の場合は RDoc を生成しせん。偽の場合は RDoc を生成します。

--- has_rdoc=(flag)

RDoc を生成するかどうかをセットします。デフォルトは偽です。

--- has_rdoc? -> bool

真の場合は RDoc を生成しせん。偽の場合は RDoc を生成します。

@see [[m:Gem::Specification#has_rdoc]]

--- has_test_suite? -> bool

このメソッドは非推奨です。 [[m:Gem::Specification#has_unit_tests?]] を使用してください。

--- has_unit_tests? -> bool

この Gem パッケージがユニットテストを含むかどうか返します。

真の場合はユニットテストを含みます。そうでない場合は偽を返します。

--- homepage -> String

この Gem パッケージを作成しているプロジェクトか作成者のウェブサイトの URI を返します。

--- homepage=(uri)

この Gem パッケージを作成しているプロジェクトか作成者のウェブサイトの URI をセットします。

@param uri この Gem パッケージを作成しているプロジェクトか作成者のウェブサイトの URI を指定します。

--- installation_path -> String

この Gem パッケージのインストール先のパスを返します。

--- lib_files -> [String]

この Gem パッケージに含まれているファイルのうち [[m:Gem::Specification#require_paths]]
以下にあるファイルのリストを返します。

--- loaded=(flag)

この Gem パッケージの gemspec が既にロードされているかどうかをセットします。

この属性は永続化しません。

@param flag 既にロードされている場合は真を指定します。

--- loaded? -> bool

この Gem パッケージの gemspec が既にロードされているかどうかを返します。

既にロードされている場合は真を返します。そうでない場合は偽を返します。

--- loaded_from -> String

この Gem パッケージの gemspec がある場所を返します。

この属性は永続化されません。

--- loaded_from=(path)

この Gem パッケージの gemspec がある場所をセットします。

@param path この Gem パッケージの gemspec がある場所を指定します。

--- mark_version -> String

RubyGems のバージョンを内部にセットします。

--- name -> String

この Gem パッケージの名前を返します。

--- name=(name)

この Gem パッケージの名前をセットします。

@param name この Gem パッケージの名前を指定します。

--- normalize -> [String]

この Gem パッケージの含まれるファイルリストから重複を取り除きます。

--- original_name -> String

このメソッドは後方互換性のために残されています。

@see [[m:Gem::Specification#full_name]]

--- original_platform -> String

この属性は古いバージョンの Gem パッケージをアンインストールするために残されています。

--- original_platform=(platform)

この属性は古いバージョンの Gem パッケージをアンインストールするために残されています。

@param platform プラットフォームを指定します。

--- platform -> String

この Gem パッケージを使用できるプラットフォームを返します。

--- platform=(platform)

この Gem パッケージを使用できるプラットフォームをセットします。

@param platform この Gem パッケージを使用できるプラットフォームを指定します。
       デフォルトは [[m:Gem::Platform::RUBY]] です。

@see [[m:Gem::Platform::RUBY]]

--- post_install_message -> String

インストール完了後に表示するメッセージを返します。

--- post_install_message=(message)

インストール完了後に表示するメッセージをセットします。

@param message メッセージを指定します。

--- rdoc_options -> [String]

API ドキュメントを生成するときに rdoc コマンドに与えるオプションを返します。

--- rdoc_options=(options)

API ドキュメントを生成するときに rdoc コマンドに与えるオプションをセットします。

@param options API ドキュメントを生成するときに rdoc コマンドに与えるオプションを指定します。

--- require_path -> String

[[m:Gem::Specification#require_paths]] の単数バージョンです。

@see [[m:Gem::Specification#require_paths]]

--- require_path=(path)

[[m:Gem::Specification#require_paths=]] の単数バージョンです。

@param path この Gem パッケージを使用した際に require するファイルが置かれているディレクトリを指定します。

@see [[m:Gem::Specification#require_paths=]]

--- require_paths -> [String]

この Gem パッケージを使用した際に require するファイルが置かれているディレクトリ
のリストを返します。

--- require_paths=(paths)

この Gem パッケージを使用した際に require するファイルが置かれているディレクトリ
のリストをセットします。

@param paths この Gem パッケージを使用した際に require するファイルが置かれているディレクトリ
             のリストを指定します。


--- required_ruby_version -> Gem::Requirement

この Gem パッケージを動作させるのに必要な Ruby のバージョンを返します。

--- required_ruby_version=(requirement)

この Gem パッケージを動作させるのに必要な Ruby のバージョンをセットします。

@param requirement [[m:Gem::Requirement.create]] が受け付ける形式のオブジェクトを指定します。

@see [[c:Gem::Requirement]]

--- required_rubygems_version -> Gem::Requirement

この Gem パッケージを動作させるのに必要な RubyGems のバージョンを返します。

--- required_rubygems_version=(requirement)

この Gem パッケージを動作させるのに必要な RubyGems のバージョンをセットします。

@param requirement [[m:Gem::Requirement.create]] が受け付ける形式のオブジェクトを指定します。

@see [[c:Gem::Requirement]]

--- requirements -> Array

この Gem パッケージを動作させるのに必要な条件を返します。
これはユーザのためのシンプルな情報です。

--- requirements=(informations)

この Gem パッケージを動作させるのに必要な条件をセットします。
これはユーザのためのシンプルな情報をセットします。

@param informations 情報を文字列の配列で指定します。

--- rubygems_version -> String

この Gem パッケージを作成した RubyGems のバージョンを返します。

--- rubygems_version=(version)

この Gem パッケージを作成した RubyGems のバージョンをセットします。
この属性は Gem パッケージが作成された時に自動的にセットされます。

@param version RubyGems のバージョンを指定します。

--- runtime_dependencies -> Array

この Gem パッケージが依存している Gem パッケージのリストを返します。

--- satisfies_requirement?(dependency) -> bool

この Gem パッケージが与えられた依存関係を満たすかどうかを返します。

依存関係を満たす場合は真を返します。そうでない場合は偽を返します。

@param dependency チェックしたい依存関係を指定します。

@see [[c:Gem::Dependency]]

--- signing_key -> String

この Gem パッケージの署名に使用するキーを返します。

--- signing_key=(key)

この Gem パッケージの署名に使用するキーをセットします。

@param key 署名に使用するキーを指定します。

--- specification_version -> Integer

この Gem パッケージに用いられている gemspec のバージョンを返します。

--- specification_version=(version)

この Gem パッケージに用いられている gemspec のバージョンをセットします。

@param version gemspec のバージョンを指定します。

@see [[m:Gem::Specification::SPECIFICATION_VERSION_HISTORY]]

--- summary -> String

この Gem パッケージの短い説明を返します。

--- summary=(summary)

この Gem パッケージの短い説明をセットします。

@param summary 短い説明を指定します。

--- test_file -> String

[[m:Gem::Specification#test_files]] の単数バージョンです。

--- test_file=(file)

[[m:Gem::Specification#test_files=]] の単数バージョンです。

--- test_files -> [String]

ユニットテストのファイルのリストを返します。


--- test_files=(files)

ユニットテストのファイルのリストをセットします。

@param files ユニットテストのファイルのリストを指定します。

--- test_suite_file -> String

この属性は非推奨です。 [[m:Gem::Specification#test_files]] を使用してください。

--- test_suite_file=(file)

この属性は非推奨です。 [[m:Gem::Specification#test_files=]] を使用してください。

@param file テストスイートのファイルを指定します。

--- to_ruby -> String

自身を再現するための Ruby スクリプトを文字列で返します。

省略されている値はデフォルト値が使用されます。

--- validate -> bool

必須属性のチェックと自身の基本的な正当性チェックを行います。

チェックにパスした場合は常に true を返します。そうでない場合は例外が発生します。

@raise Gem::InvalidSpecificationException チェックにパスしなかった場合に発生します。

--- version -> Gem::Version

この Gem パッケージのバージョンを返します。

--- version=(version)

この Gem パッケージのバージョンをセットします。

@param version バージョンを文字列か [[c:Gem::Version]] のインスタンスで指定します。

--- yaml_initialize
#@todo

== Singleton Methods

--- _load(str) -> Gem::Specification

マーシャルされたデータをロードするためのメソッドです。

@param str マーシャルされたデータを指定します。

--- array_attribute(name) -> ()

[[m:Gem::Specification.attribute]] と同じですが、値を配列に格納するアクセサを作ります。

@param name 属性の名前を指定します。

@see [[m:Gem::Specification.attribute]]

--- array_attributes -> Array

@@array_attributes の複製を返します。

@see [[m:Object#dup]]

--- attribute(name) -> ()

デフォルト値を指定したアクセサを定義するために使用します。

以下の副作用があります。

 * クラス変数 @@attributes, @@default_value を変更します。
 * 通常の属性書き込みメソッドを定義します。
 * デフォルト値を持つ属性読み取りメソッドのように振る舞うメソッドを定義します。

--- attribute_alias_singular(singular, plural) -> ()

既に存在する複数形の属性の単数形バージョンを定義します。

これは単に一つの引数を受け取りそれを配列に追加するようなヘルパーメソッドを定義するということです。

例:

  # このように定義すると
  attribute_alias_singular :require_path, :require_paths
  # こう書くかわりに
  s.require_paths = ['mylib']
  # こう書くことができます。
  s.require_path = 'mylib'

@param singular 属性名の単数形を指定します。

@param plural 属性名の複数形を指定します。

--- attribute_defaults -> Array
#@todo

@@attributes の複製を返します。

--- attribute_names -> Array

属性名の配列を返します。

--- attributes(*args) -> ()

複数の属性を一度に作成するために使用します。

各属性のデフォルト値は nil になります。

@param args 属性名を一つ以上指定します。

--- default_value(name) -> object

与えられた名前の属性のデフォルト値を返します。

@param name 属性名を指定します。

--- from_yaml(input) -> Gem::Specification

YAML ファイルから gemspec をロードします。

YAML ファイルから [[c:Gem::Specification]] をロードすると、通常の Ruby オブジェクトの
初期化ルーチン (#initialize) を通りません。このメソッドは初期化ルーチンの一部を実行し、
gemspec のバージョンチェックも行います。

@param input 文字列か [[c:IO]] オブジェクトを指定します。

--- list -> Array

実行中の Ruby のインスタンスで作成された [[c:Gem::Specification]] のインスタンスを返します。

--- load(filename) -> Gem::Specification

gemspec ファイルをロードします。

@param filename gemspec のファイル名を指定します。

@raise StandardError gemspec ファイル内でこのメソッドを呼んでいる場合に発生します。

--- normalize_yaml_input(input) -> String

YAML 形式の gemspec を正しくフォーマットします。

@param input 文字列か [[c:IO]] オブジェクトを指定します。

--- overwrite_accessor(name){ ... } -> ()

呼び出し時に特別な動作をする必要のある属性があります。
このメソッドはそういうことを可能にします。

ブロックパラメータは任意のものを使用することができます。

@param name 属性名を指定します。

--- read_only(*names) -> ()

与えられた属性名を読み取り専用にします。

@param names 属性名を一つ以上指定します。

--- required_attribute(name, default = nil) -> ()

必須の属性を作成します。

@param name 属性名を指定します。

@param default デフォルト値を指定します。

@see [[m:Gem::Specification.attribute]]

--- required_attribute?(name) -> bool

必須属性であれば真を返します。

@param name 属性名を指定します。

--- required_attributes -> Array

必須属性のリストを返します。


== Constants

--- CURRENT_SPECIFICATION_VERSION -> 2

現在の gemspec のバージョンを表す定数です。


--- MARSHAL_FIELDS -> Hash
#@todo


--- NONEXISTENT_SPECIFICATION_VERSION -> -1

明確に指定されていない時の gemspec のバージョンを表します。

--- SPECIFICATION_VERSION_HISTORY -> Hash

gemspec ファイルのバージョンの歴史を表す定数です。

--- TODAY -> Time

本日の日付を返します。



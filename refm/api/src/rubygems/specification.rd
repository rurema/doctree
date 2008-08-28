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

--- <=>
#@todo

--- ==
#@todo

--- _dump
#@todo

--- add_bindir
#@todo

--- add_dependency
#@todo

--- add_development_dependency
#@todo

--- add_runtime_dependency
#@todo

--- assign_defaults
#@todo

--- author
#@todo

--- author=
#@todo

--- authors
#@todo

--- authors=
#@todo

--- autorequire
#@todo

--- autorequire=
#@todo

--- bindir
#@todo

--- bindir=
#@todo

--- cert_chain
#@todo

--- cert_chain=
#@todo

--- date
#@todo

--- date=
#@todo

--- default_executable
#@todo

--- default_executable=
#@todo

--- dependencies
#@todo

--- dependent_gems
#@todo

--- description
#@todo

--- description=
#@todo

--- development_dependencies
#@todo

--- email
#@todo

--- email=
#@todo

--- eql?
#@todo

--- executable
#@todo

--- executable=
#@todo

--- executables
#@todo

--- executables=
#@todo

--- extensions
#@todo

--- extensions=
#@todo

--- extra_rdoc_files
#@todo

--- extra_rdoc_files=
#@todo

--- file_name
#@todo

--- files
#@todo

--- files=
#@todo

--- full_gem_path
#@todo

--- full_name
#@todo

--- has_rdoc
#@todo

--- has_rdoc=
#@todo

--- has_rdoc?
#@todo

--- has_test_suite?
#@todo

--- has_unit_tests?
#@todo

--- hash
#@todo

--- homepage
#@todo

--- homepage=
#@todo

--- installation_path
#@todo

--- lib_files
#@todo

--- loaded=
#@todo

--- loaded?
#@todo

--- loaded_from
#@todo

--- loaded_from=
#@todo

--- mark_version
#@todo

--- method_missing
#@todo

--- name
#@todo

--- name=
#@todo

--- normalize
#@todo

--- original_name
#@todo

--- original_platform
#@todo

--- original_platform=
#@todo

--- platform
#@todo

--- platform=
#@todo

--- post_install_message
#@todo

--- post_install_message=
#@todo

--- rdoc_options
#@todo

--- rdoc_options=
#@todo

--- require_path
#@todo

--- require_path=
#@todo

--- require_paths
#@todo

--- require_paths=
#@todo

--- required_ruby_version
#@todo

--- required_ruby_version=
#@todo

--- required_rubygems_version
#@todo

--- required_rubygems_version=
#@todo

--- requirements
#@todo

--- requirements=
#@todo

--- rubyforge_project
#@todo

--- rubyforge_project=
#@todo

--- rubygems_version
#@todo

--- rubygems_version=
#@todo

--- runtime_dependencies
#@todo

--- satisfies_requirement?
#@todo

--- signing_key
#@todo

--- signing_key=
#@todo

--- sort_obj
#@todo

--- specification_version
#@todo

--- specification_version=
#@todo

--- summary
#@todo

--- summary=
#@todo

--- test_file
#@todo

--- test_file=
#@todo

--- test_files
#@todo

--- test_files=
#@todo

--- test_suite_file
#@todo

--- test_suite_file=
#@todo

--- to_ruby
#@todo

--- to_s
#@todo

--- to_yaml
#@todo

--- validate
#@todo

--- version
#@todo

--- version=
#@todo

--- yaml_initialize
#@todo

== Singleton Methods

--- _load(str) -> Gem::Specification
#@todo

マーシャルされたデータをロードするためのメソッドです。

@param str マーシャルされたデータを指定します。

--- array_attribute(name) -> ()
#@todo

[[m:Gem::Specification.attribute]] と同じですが、値を配列に格納するアクセサを作ります。

@param name 属性の名前を指定します。

@see [[m:Gem::Specification.attribute]]

--- array_attributes -> Array
#@todo

@@array_attributes の複製を返します。

@see [[m:Object#dup]]

--- attribute(name) -> ()
#@todo

デフォルト値を指定したアクセサを定義するために使用します。

以下の副作用があります。

 * クラス変数 @@attributes, @@default_value を変更します。
 * 通常の属性書き込みメソッドを定義します。
 * デフォルト値を持つ属性読み取りメソッドのように振る舞うメソッドを定義します。

--- attribute_alias_singular(singular, plural) -> ()
#@todo

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
#@todo

属性名の配列を返します。

--- attributes(*args) -> ()
#@todo

複数の属性を一度に作成するために使用します。

各属性のデフォルト値は nil になります。

@param args 属性名を一つ以上指定します。

--- default_value(name) -> object
#@todo

与えられた名前の属性のデフォルト値を返します。

@param name 属性名を指定します。

--- from_yaml(input) -> Gem::Specification
#@todo

YAML ファイルから gemspec をロードします。

YAML ファイルから [Gem::Specification]] をロードすると、通常の Ruby オブジェクトの
初期化ルーチン (#initialize) を通りません。このメソッドは初期化ルーチンの一部を実行し、
gemspec のバージョンチェックも行います。

@param input 文字列か [[c:IO]] オブジェクトを指定します。

--- list -> Array
#@todo

実行中の Ruby のインスタンスで作成された [[c:Gem::Specification]] のインスタンスを返します。

--- load(filename) -> Gem::Specification
#@todo

gemspec ファイルをロードします。

@param filename gemspec のファイル名を指定します。

@raise StandardError gemspec ファイル内でこのメソッドを呼んでいる場合に発生します。

--- normalize_yaml_input(input) -> String
#@todo

YAML 形式の gemspec を正しくフォーマットします。

@param input 文字列か [[c:IO]] オブジェクトを指定します。

--- overwrite_accessor(name){ ... } -> ()
#@todo

呼び出し時に特別な動作をする必要のある属性があります。
このメソッドはそういうことを可能にします。

ブロックパラメータは任意のものを使用することができます。

@param name 属性名を指定します。

--- read_only(*names) -> ()
#@todo

与えられた属性名を読み取り専用にします。

@param names 属性名を一つ以上指定します。

--- required_attribute(name, default = nil) -> ()
#@todo

必須の属性を作成します。

@param name 属性名を指定します。

@param default デフォルト値を指定します。

@see [[m:Gem::Specification.attribute]]

--- required_attribute?(name) -> bool
#@todo

必須属性であれば真を返します。

@param name 属性名を指定します。

--- required_attributes -> Array
#@todo

必須属性のリストを返します。


== Constants

--- CURRENT_SPECIFICATION_VERSION -> 2
#@todo

現在の gemspec のバージョンを表す定数です。


--- MARSHAL_FIELDS -> Hash
#@todo


--- NONEXISTENT_SPECIFICATION_VERSION -> -1
#@todo

明確に指定されていない時の gemspec のバージョンを表します。

--- SPECIFICATION_VERSION_HISTORY -> Hash
#@todo

gemspec ファイルのバージョンの歴史を表す定数です。

--- TODAY -> Time
#@todo

本日の日付を返します。



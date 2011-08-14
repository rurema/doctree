require rubygems/format
require rubygems/ext
require rubygems/require_paths_builder

RubyGems の Gem をインストールするためのライブラリです。

= class Gem::Installer
include Gem::UserInteraction
include Gem::RequirePathsBuilder

[[c:Gem::Installer]] は Gem を展開し、  Gem に含まれていたファイルを
ファイルシステム上の正しい位置に配置します。

また、gemspec を specifications ディレクトリに、キャッシュを cache ディレクトリに、
実行ファイルやシンボリックリンクなどを bin ディレクトリに配置します。

== Public Instance Methods

--- app_script_text -> String

アプリケーションのための実行ファイルの雛形のテキストを返します。

--- bin_dir -> String

実行ファイルをインストールするディレクトリを返します。

--- build_extensions
#@# -> discard
拡張ライブラリをビルドします。

拡張ライブラリをビルドするためのファイルタイプとして有効であるのは、
extconf.rb, configure script, Rakefile, mkmf_files です。

--- ensure_dependency(spec, dependency) -> true

インストールしようとしている Gem が依存関係を満たしている事を確認します。

依存関係を満たしていない場合は、例外 [[c:Gem::InstallError]] が発生します。

@param spec [[c:Gem::Specification]] のインスタンスを指定します。

@param dependency [[c:Gem::Dependency]] のインスタンスを指定します。

@raise Gem::InstallError 依存関係を満たしていない場合に発生します。

--- extract_files
#@# -> discard
ファイルのインデックスを読み取って、それぞれのファイルを Gem のディレクトリに展開します。

また、ファイルを Gem ディレクトリにインストールしないようにします。

@raise ArgumentError 自身に [[c:Gem::Format]] がセットされていない場合に発生します。

@raise Gem::InstallError インストール先のパスが不正な場合に発生します。

--- formatted_program_filename(filename) -> String

Ruby のコマンドと同じプレフィックスとサフィックスを付けたファイル名を返します。

@param filename 実行ファイルのファイル名を指定します。

--- gem_home -> String

Gem のインストール先を返します。

--- generate_bin
#@# -> discard
Gem でインストールされる実行ファイルを作成します。

@raise Gem::FilePermissionError インストール先に書込み出来ない場合に発生します。

--- generate_bin_script(filename, bindir)
#@# -> discard
Gem に入っているアプリケーションを実行するためのスクリプトを作成します。

@param filename ファイル名を指定します。

@param bindir 実行ファイルを配置するディレクトリを指定します。

--- generate_bin_symlink(filename, bindir)
#@# -> discard
Gem に入っているアプリケーションを実行するためのシンボリックリンクを作成します。

現在インストールされている Gem よりも新しい Gem をインストールするときは、
シンボリックリンクを更新します。

@param filename ファイル名を指定します。

@param bindir 実行ファイルを配置するディレクトリを指定します。

#@since 1.9.2
--- generate_windows_script(filename, bindir)
#@else
--- generate_windows_script(bindir, filename)
#@end
#@# -> discard
コマンドの実行を容易にするために Windows 向けのバッチファイルを作成します。

@param bindir 実行ファイルを配置するディレクトリを指定します。

@param filename ファイル名を指定します。

--- install -> Gem::Specification

Gem をインストールします。

以下のディレクトリ構造で Gem をインストールします。

   @gem_home/
     cache/<gem-version>.gem              #=> インストールした Gem のコピー
     gems/<gem-version>/...               #=> インストール時に展開したファイル
     specifications/<gem-version>.gemspec #=> gemspec ファイル

@return ロードされた [[c:Gem::Specification]] のインスタンスを返します。

@raise Gem::InstallError 要求された Ruby のバージョンを満たしていない場合に発生します。

@raise Gem::InstallError 要求された RubyGems のバージョンを満たしていない場合に発生します。

@raise Gem::InstallError [[c:Zlib::GzipFile::Error]] が発生した場合に発生します。

--- installation_satisfies_dependency?(dependency) -> bool

登録されているソースインデックスが与えられた依存関係を
満たすことができる場合は、真を返します。そうでない場合は偽を返します。

@param dependency [[c:Gem::Dependency]] のインスタンスを指定します。

--- shebang(bin_file_name) -> String

実行ファイル内で使用する shebang line (#! line) を表す文字列を返します。

@param bin_file_name 実行ファイルの名前を指定します。

--- spec -> Gem::Specification

インストールしようとしている Gem に対応する [[c:Gem::Specification]] のインスタンスを返します。

--- unpack(directory)
#@# -> discard
与えられたディレクトリに Gem を展開します。

@param directory Gem を展開するディレクトリを指定します。

--- windows_stub_script -> String

コマンドを起動するために使用する Windows 用のバッチファイルの内容を
文字列として返します。

--- write_spec
#@# -> discard
Ruby スクリプト形式で .gemspec ファイルを作成します。

== Singleton Methods

--- new(gem, options = {}) -> Gem::Installer
#@todo 書いてないオプションがいっぱいある

与えられた引数で自身を初期化します。

@param gem インストール対象の Gem のパスを指定します。

@param options インストーラが使用するオプションをハッシュで指定します。
               使用できるキーは以下の通りです。
: :env_shebang
  コマンドのラッパーで shebang line に /usr/bin/env を使用します。
: :force
  署名された Gem のみをインストールするというポリシー以外、
  全てのバージョンチェックとセキュリティポリシーのチェックを行わないようにします。
: :ignore_dependencies
  依存関係を満たしていない場合でも例外を発生させません。
: :install_dir
  Gem をインストールするディレクトリを指定します。
: :format_executable
  実行ファイルの名前を ruby と同じフォーマットにするかどうか指定します。
  インストールされている ruby が ruby19 という名前の場合、foo_exec という名前の
  実行ファイルは foo_exec19 という名前でインストールされます。
: :security_policy
  特定のセキュリティポリシーを使用します。詳細は [[c:Gem::Security]] を参照してください。
: :wrappers
  この値が真の場合は、ラッパーをインストールします。偽の場合は、シンボリックリンクを作成します。
: :user_install
  この値が false の場合は、ユーザのホームディレクトリに Gem をインストールしません。
  この値が nil の場合は、ユーザのホームディレクトリに Gem をインストールしますが、警告が表示されます。

@raise Gem::InstallError Gem のフォーマットが不正である場合に発生します。

@raise Gem::FilePermissionError 書き込み先のディレクトリに書き込み権限がない場合に発生します。

--- exec_format -> String

実行ファイル名のフォーマットを返します。

指定しない場合は ruby コマンドと同じフォーマットを使用します。

--- exec_format=(format)

実行ファイル名のフォーマットをセットします。

@param format 実行ファイル名のフォーマットを指定します。

--- home_install_warning -> bool

この値が真の場合、ホームディレクトリに Gem をインストールしようとすると警告を表示します。

--- home_install_warning=(flag)

ホームディレクトリに Gem をインストールしようとすると警告を表示するかどうかセットします。

@param flag 真を指定するとホームディレクトリに Gem をインストールしよう
            とすると警告を表示するようになります。

--- path_warning -> bool

この値が 真の場合は Gem.bindir が PATH に含まれていない場合に警告を表示します。

--- path_warning=(flag)

Gem.bindir が PATH に含まれていない場合に警告を表示するかどうかセットします。

@param flag 真を指定すると、Gem.bindir が PATH に含まれていない場合に警
            告を表示するようになります。

= class Gem::Installer::ExtensionBuildError < Gem::InstallError

拡張ライブラリをビルド中にエラーが発生した場合に発生します。

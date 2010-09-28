require rake
require rake/packagetask

Gem Spec ファイルを元にして Gem パッケージを作成するタスクを定義するためのライブラリです。

Gem パッケージだけでなく zip, tgz, tar.gz, tar.bz2 の各ファイルを作成する事もできます。

以下のタスクを定義します。

: PACKAGE_DIR/NAME-VERSION.gem
  Gem パッケージを作成します。

例:
   require 'rubygems'
   
   spec = Gem::Specification.new do |s|
     s.platform = Gem::Platform::RUBY
     s.summary = "Ruby based make-like utility."
     s.name = 'rake'
     s.version = PKG_VERSION
     s.requirements << 'none'
     s.require_path = 'lib'
     s.autorequire = 'rake'
     s.files = PKG_FILES
     s.description = <<EOF
   Rake is a Make-like program implemented in Ruby. Tasks
   and dependencies are specified in standard Ruby syntax. 
   EOF
   end
   
   Rake::GemPackageTask.new(spec) do |pkg|
     pkg.need_zip = true
     pkg.need_tar = true
   end

= class Rake::GemPackageTask < Rake::PackageTask

Gem Spec ファイルを元にして Gem パッケージを作成するタスクを定義するためのクラスです。


== Public Instance Methods

--- define
#@# discard

タスクを定義します。

[[m:GemPackageTask.new]] にブロックが与えられている場合に、自動的に呼び出されます。

--- gem_file -> String

Gem パッケージの名前を返します。

--- gem_spec -> Gem::Specification

package ターゲットで使用する gemspec を返します。

gemspec にはパッケージ名、バージョン、パッケージに含まれるファイルなどが定義
されているので、それらを明示的に指定する必要はありません。

--- gem_spec=(gem_spec)

gemspec をセットします。

@param gem_spec [[c:Gem::Specification]] のインスタンスを指定します。

--- init(gem_spec)
#@# discard

自身の各属性に初期値をセットします。

== Singleton Methods

--- new(gem_spec){|t| ... } -> Rake::GemPackageTask

自身を初期化してタスクを定義します。

ブロックが与えられた場合は、自身をブロックパラメータとして
ブロックを評価します。

@param gem_spec [[c:Gem::Specification]] のインスタンスを指定します。

require rake
require rake/tasklib

配布するパッケージ (zip, tar, etc...) を作成するためのタスクを定義します。

このライブラリをロードすると以下のタスクが使用可能になります。

: package
  パッケージを作成します。
: clobber_package
  作成したパッケージを削除します。このタスクは clobber タスクにも追加されます。
: repackage
  パッケージが古くない場合でもパッケージを再作成します。
: PACKAGE_DIR/NAME-VERSION.tgz
  [[m:Rake::PackageTask#need_tar]] が真の場合 gzip された tar パッケージを作成します。
: PACKAGE_DIR/NAME-VERSION.tar.gz
  [[m:Rake::PackageTask#need_tar_gz]] が真の場合 gzip された tar パッケージを作成します。
: PACKAGE_DIR/NAME-VERSION.tar.bz2
  [[m:Rake::PackageTask#need_tar_bz2]] が真の場合 bzip2 された tar パッケージを作成します。
: PACKAGE_DIR/NAME-VERSION.zip
  [[m:Rake::PackageTask#need_zip]] が真の場合 zip されたパッケージを作成します。

例:
   Rake::PackageTask.new("rake", "1.2.3") do |t|
     t.need_tar = true
     t.package_files.include("lib/**/*.rb")
   end

= class Rake::PackageTask < Rake::TaskLib

配布するパッケージ (zip, tar, etc...) を作成するためのタスクを定義するクラスです。

== Public Instance Methods

--- define -> self

タスクを定義します。

@raise RuntimeError バージョン情報をセットしていない場合に発生します。
                    初期化時に :noversion が指定されている場合は発生しません。

--- init(name, version)
#@# discard

自身の各属性にデフォルト値をセットします。

@param name パッケージの名前を指定します。

@param version パッケージのバージョンを指定します。

--- name -> String

バージョン情報を含まないパッケージの名前を返します。

--- name=(name)

バージョン情報を含まないパッケージの名前をセットします。

@param name パッケージの名前を指定します。

--- need_tar -> bool

この値が真である場合は gzip した tar ファイル (tgz) を作成します。
デフォルトは偽です。

--- need_tar=(flag)

gzip した tar ファイル (tgz) を作成するかどうかを設定します。

@param flag 真または偽を指定します。

--- need_tar_bz2 -> bool

この値が真である場合は bzip2 した tar ファイル (tar.bz2) を作成します。
デフォルトは偽です。

#@samplecode
# Rakefile での記載例とする
require 'rake/packagetask'

Rake::PackageTask.new("sample", "1.0.0") do |package_task|
  package_task.need_tar_bz2 # => false
end
#@end

--- need_tar_bz2=(flag)

bzip2 した tar ファイル (tar.bz2) を作成するかどうかを設定します。

@param flag 真または偽を指定します。

--- need_tar_gz -> bool

この値が真である場合は gzip した tar ファイル (tar.gz) を作成します。
デフォルトは偽です。

--- need_tar_gz=(flag)

gzip した tar ファイル (tar.gz) を作成するかどうかを設定します。

@param flag 真または偽を指定します。

--- need_zip -> bool

この値が真である場合は zip ファイルを作成します。
デフォルトは偽です。

--- need_zip=(flag)

zip ファイル (tgz) を作成するかどうかを設定します。

@param flag 真または偽を指定します。

--- package_dir -> String

パッケージに入れるファイルを保存するディレクトリ名を返します。

--- package_dir=(dirname)

パッケージに入れるファイルを保存するディレクトリ名をセットします。

@param dirname パッケージに入れるファイルを保存するディレクトリ名を指定します。

--- package_dir_path -> String

パッケージに含むファイルを配置するディレクトリを返します。

--- package_files -> Rake::FileList

パッケージに含むファイルリストを返します。

--- package_files=(file_list)

パッケージに含むファイルリストを設定します。

@param file_list ファイルリストを指定します。

--- package_name -> String

バージョン情報を含むパッケージ名を返します。

--- tar_bz2_file -> String

tar.bz2 用のファイル名を返します。

--- tar_command -> String

tar コマンドとして使用するコマンドを返します。

デフォルトは 'tar' です。

--- tar_command=(command)

tar コマンドとして使用するコマンドを設定します。

@param command コマンドを文字列で指定します。

--- tar_gz_file -> String

tar.gz 用のファイル名を返します。

--- tgz_file -> String

tgz 用のファイル名を返します。

--- version -> String

作成するパッケージのバージョンを表す文字列を返します。

--- version=(str)

作成するパッケージのバージョンをセットします。

@param str バージョンを表す文字列を指定します。

--- zip_command -> String

zip コマンドとして使用するコマンドを返します。

デフォルトは 'zip' です。

--- zip_command=(command)

zip コマンドとして使用するコマンドを設定します。

@param command コマンドを文字列で指定します。

--- zip_file -> String

zip ファイル用のファイル名を返します。


== Singleton Methods

--- new(name = nil, version = nil){|t| ... } -> Rake::PackageTask

自身を初期化してタスクを定義します。

ブロックが与えられた場合は、自身をブロックパラメータとして
ブロックを評価します。

@param name パッケージ名を指定します。

@param version パッケージのバージョンを指定します。
               ':noversion' というシンボルを指定するとバージョン情報をセットしません。

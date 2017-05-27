#@since 1.9.1
#@# require rdoc/ri/paths
require optparse
#@else
#@# require rdoc/ri/ri_paths
require singleton
require getoptlong
#@end
#@since 2.0.0
require pathname
#@end

rdoc コマンドのオプションを解析するためのサブライブラリです。

#@since 1.9.1
= class RDoc::Options
#@else
= class Options

include Singleton
#@end

rdoc コマンドのオプションを解析するためのクラスです。

それぞれのオプションの詳細に関しては、[[ref:lib:rdoc#usage]] を参照してくだ
さい。

#@until 1.9.1
[注意] クラス名は RDoc::Option ではない事に注意してください。(1.9 系で
は RDoc::Option クラスとして使用できます。)
#@end

#@since 2.0.0
===[a:custom_options] カスタムオプション

[[c:RDoc]] のジェネレータでは、[[c:RDoc::Options]] をフックして独自の
オプションを指定できます。

[[m:Object::ARGV]] に --format が含まれていた場合、[[c:RDoc]] はジェネ
レータ独自のオプションを解析するために setup_options メソッドを呼び出し
ます。カスタムオプションを指定する場合は --format オプションは必ず指定
する必要があります。rdoc --help を実行すると追加したオプションの一覧が
確認できます。

例:

  class RDoc::Generator::Spellcheck
    RDoc::RDoc.add_generator self

    def self.setup_options rdoc_options
      op = rdoc_options.option_parser

      op.on('--spell-dictionary DICTIONARY',
            RDoc::Options::Path) do |dictionary|
        # RDoc::Options に spell_dictionary アクセサの定義が必要
        rdoc_options.spell_dictionary = dictionary
      end
    end
  end

#@# Path や Template などには Object.new したものが入っているため、全て
#@# のオブジェクトが通るように見えるため除外。
#@#
#@# === オプションの検証
#@#
#@# OptionParser validators will validate and cast user input values.  In
#@# addition to the validators that ship with OptionParser (String, Integer,
#@# Float, TrueClass, FalseClass, Array, Regexp, Date, Time, URI, etc.),
#@# RDoc::Options adds Path, PathArray and Template.
#@end

== Instance Methods

--- exclude -> Regexp

コマンドライン引数の --exclude オプションで指定した正規表現を返します。
複数指定していた場合は、1 つの [[c:Regexp]] オブジェクトにまとめられた
ものを返します。

--- exclude=(val)

コマンドライン引数の --exclude オプションと同様の指定を行います。

@param val 設定するパターンを [[c:Regexp]] オブジェクトで指定します。

--- op_dir -> String

コマンドライン引数の --op オプションで指定したディレクトリを返します。

--ri、--ri-site、--ri-system オプションにも影響される事に注意してください。

@return 設定されたディレクトリを文字列で返します。

--- op_dir=(val)

コマンドライン引数の --op オプションと同様の指定を行います。

@param val 設定するディレクトリを文字列で指定します。

--- op_name -> String

コマンドライン引数の --opname オプションで指定した名前を文字列で返しま
す。

--- show_all -> bool

コマンドライン引数の --all オプションを指定していた場合、true を返しま
す。そうでない場合は false を返します。

--- show_all=(val)

val に true を指定した場合、コマンドライン引数の --all オプションと同様
の指定を行います。

@param val --all オプションと同じ指定を行う場合は true、そうでない場合
           は false を指定します。

--- main_page -> String | nil

コマンドライン引数の --main オプションで指定したファイル名、クラス/モ
ジュール名を返します。

指定しなかった場合は nil を返します。

--- main_page=(val)

コマンドライン引数の --main オプションと同様の指定を行います。

@param val 設定するファイル名、クラス/モジュール名を文字列で指定します。

--- merge -> true | nil

コマンドライン引数の --merge オプションを指定していた場合、true を返し
ます。そうでない場合は nil を返します。

--- quiet -> bool

コマンドライン引数の --quiet オプションを指定していた場合、true を返し
ます。そうでない場合は nil を返します。

--- generator -> Generator

コマンドライン引数の --fmt オプションで指定した文字列に応じた
Generator を返します。

指定しなかった場合は、HTML に対応する Generator を返します。

--- generator=(val)

コマンドライン引数の --fmt オプションと同様の指定を行います。

@param val 設定する Generator を指定します。

--- files -> [String]

解析するファイルの一覧を文字列の配列で返します。

--- rdoc_include -> [String]

コマンドライン引数の --include オプションで指定したディレクトリを文字列
の配列で返します。

指定しなかった場合は ['.'] を返します。

--- template -> String

コマンドライン引数の --template オプションで指定した名前を文字列の配列
で返します。

指定しなかった場合は 'html' を返します。

--- diagram -> bool

コマンドライン引数の --diagram オプションを指定していた場合、true を返
します。そうでない場合は false を返します。

--- fileboxes -> bool

コマンドライン引数の --diagram オプション、--fileboxes オプションを指定
していた場合、true を返します。そうでない場合は false を返します。

--- show_hash -> bool

コマンドライン引数の --show-hash オプションを指定していた場合、true を
返します。そうでない場合は false を返します。

--- image_format -> String

コマンドライン引数の --image-format オプションで指定した名前を文字列の
配列で返します。

指定しなかった場合は 'png' を返します。

--- charset -> String

コマンドライン引数の --charset オプションで指定した文字コードを文字列で
返します。

指定しなかった場合は、[[m:$KCODE]] に応じた値になります。

--- inline_source -> bool

コマンドライン引数の --inline-source オプションか --one-file を指定して
いた場合、もしくは --fmt オプションに xml 指定した場合に true を返しま
す。そうでない場合は false を返します。

--- all_one_file -> bool

コマンドライン引数の --one-file を指定していた場合、もしくは --fmt オプ
ションに xml 指定した場合に true を返します。そうでない場合は false を
返します。

--- tab_width -> Integer

コマンドライン引数の --tab-width オプションで指定した数値を返します。

--- include_line_numbers -> bool

コマンドライン引数の --include-line-numbers を指定していた場合に true
を返します。そうでない場合は false を返します。

--- extra_accessors -> Regexp | nil

コマンドライン引数の --accessor オプションで指定したアクセサの名前すべ
てにマッチする正規表現オブジェクトを返します。

指定しなかった場合は nil を返します。

--- extra_accessor_flags -> {String => String}

コマンドライン引数の --accessor オプションで指定したアクセサがキー、ア
クセサの種類が値のハッシュを返します。

値は r、w、rw のいずれかです。それぞれ attr_reader、attr_writer、
attr_accessor に対応します。

--- css -> String

コマンドライン引数の --style オプションで指定した URL を文字列で返しま
す。

--- webcvs -> String | nil

コマンドライン引数の --webcvs オプションで指定した URL を文字列で返しま
す。

指定しなかった場合は nil を返します。

--- promiscuous

コマンドライン引数の --promiscuous を指定していた場合に true を返します。
そうでない場合は false を返します。

--- force_update -> bool

コマンドライン引数の --force_update を指定していた場合に true を返しま
す。そうでない場合は false を返します。

#@since 1.9.1
--- parse(argv) -> ()
#@else
--- parse(argv, generators) -> ()
#@end

コマンドライン引数を解析します。

@param argv コマンドライン引数を文字列の配列で指定します。

#@until 1.9.1
@param generators Generator の配列を指定します。
#@end

また、以下のような指定をした場合は標準エラーに出力を行い、終了コード 1
でプログラムを終了します。

 * --extension オプションに拡張子を 2 つ指定しなかった場合
 * --extension オプションに new=old を指定した時に old を扱えるフォーマッ
   タがない場合
 * --fmt オプションに扱えない出力を指定した場合
#@until 1.9.1
 * --image-format オプションを指定した時に、指定したフォーマットが png、
   gif、jpeg、jpg のいずれでもなかった場合
 * --tab-width オプションに数値以外を指定した場合
#@end

#@since 1.9.1
--- title -> String | nil

ドキュメントのタイトルを返します。指定されていない場合は nil を返します。

#@else
--- title -> String | "RDoc Documentation"

ドキュメントのタイトルを返します。指定されていない場合は "RDoc
Documentation" を返します。
#@end

--- title=(string)

ドキュメントのタイトルがまだ設定されていない場合に string で指定した文
字列に設定します。

コマンドライン引数で既に --title オプションが指定されていた場合には、そ
ちらを優先します。

@param string 設定するタイトルを文字列で指定します。

#@since 1.9.1

--- formatter -> nil

使用されていません。常に nil を返します。

#@# 少なくとも --fmt オプションは @generator_name に値を代入する。参照
#@# もない。

--- formatter=(val)

使用されていません。

--- verbosity -> 0 | 1 | 2

プログラムの解析時に表示する情報の詳細さを数値で返します。

以下の値を指定する事ができます。

: 0(--quiet オプションを指定した場合)

  情報を表示しません。

: 1

  通常の表示を行います。

: 2(--verbose オプションを指定した場合)

  詳細な情報を表示します。

--- verbosity=(val)

プログラムの解析時に表示する情報の詳細さを数値で指定します。

@param val 何も表示しない場合は 0、通常の表示を行う場合は 1、詳細な表示
           を行う場合は 2 を指定します。

@see [[m:RDoc::Options#verbosity]]

#@end

#@since 1.9.2
--- pipe -> bool

コマンドライン引数の --pipe オプションを指定していた場合、true を返しま
す。そうでない場合は false を返します。

--- pipe=(val)

val に true を指定した場合、コマンドライン引数の --pipe オプションと同
様の指定を行います。

@param val --pipe オプションと同じ指定を行う場合は true、そうでない場合
           は false を指定します。

#@end

#@since 1.9.3
--- dry_run -> bool

コマンドライン引数の --dry-run オプションを指定していた場合、true を返
します。--no-dry-run オプションを指定していた場合、false を返します。

どちらも指定しなかった場合は false を返します。

--- dry_run=(val)

val に true を指定した場合、コマンドライン引数の --dry-run オプションと
同様の指定を行います。

@param val --dry-run オプションと同じ指定を行う場合は true、そうでない
           場合は false を指定します。

--- encoding -> Encoding

コマンドライン引数の --encoding オプションを指定していた場合、指定した
エンコーディングに対応する [[c:Encoding]] オブジェクトを返します。

指定しなかった場合は [[m:Encoding.default_external]] の値を返します。

--- encoding=(val)

コマンドライン引数の --encoding オプションと同様の指定を行います。

@param val 設定する [[c:Encoding]] オブジェクトを指定します。

--- force_output -> bool

コマンドライン引数の --force_output オプションを指定していた場合、true
を返します。--no-force_output オプションを指定していた場合、false を返
します。

どちらも指定しなかった場合は true を返します。

--- force_output=(val)

val に true を指定した場合、コマンドライン引数の --force_output オプショ
ンと同様の指定を行います。

@param val --force_output オプションと同じ指定を行う場合は true、そうで
           ない場合は false を指定します。

#@# 特に使用していないようなので、記述しない。
#@#
#@#--- generator_options
#@#
#@#--- generator_options=(val)
#@#

--- hyperlink_all -> bool

コマンドライン引数の --hyperlink-all オプションを指定していた場合、
true を返します。

指定しなかった場合は false を返します。

--- hyperlink_all=(val)

val に true を指定した場合、コマンドライン引数の --hyperlink-all オプショ
ンと同様の指定を行います。

@param val --hyperlink-all オプションと同じ指定を行う場合は true、そう
           でない場合は false を指定します。

--- line_numbers -> bool

コマンドライン引数の --line-numbers オプションを指定していた場合、true
を返します。--no-line-numbers オプションを指定していた場合、false を返
します。

どちらも指定しなかった場合は false を返します。

--- line_numbers=(val)

val に true を指定した場合、コマンドライン引数の --line-numbers オプショ
ンと同様の指定を行います。

@param val --line-numbers オプションと同じ指定を行う場合は true、そうで
           ない場合は false を指定します。

--- coverage_report -> Integer | false

コマンドライン引数の --coverage-report オプションを指定していた場合、指
定した数値を返します。

指定しなかった場合は false を返します。

--- coverage_report=(val)

コマンドライン引数の --coverage-report オプションと同様の指定を行います。

@param val 数値オブジェクトか false を指定します。

#@# 特に使用していないようなので、記述しない。
#@#
#@#--- option_parser
#@#
#@#--- option_parser=(val)
#@#

--- template_dir -> String | nil

コマンドライン引数の --template オプションで指定したテンプレートに対応
するディレクトリを返します。

オプションの解析前は nil を返します。

--- template_dir=(val)

コマンドライン引数の --template オプションで指定したテンプレートに対応
するディレクトリを設定します。

@param val パスを文字列で指定します。

#@# initialize 時に true が指定してあるのみで、他に影響しないため、記述
#@# しない。
#@#
#@#--- update_output_dir -> bool
#@#
#@#--- update_output_dir=(val)
#@#

--- visibility -> :public | :protected | :private

コマンドライン引数の --visibility で指定したオプションを [[c:Symbol]]
で返します。

--- visibility=(val)

コマンドライン引数の --visibility オプションと同様の指定を行います。

@param val :public、:protected、:private のいずれかを指定します。
#@end

--- option_parser -> OptionParser | nil

コマンドライン引数の解析のための [[c:OptionParser]] オブジェクトを返し
ます。

--- option_parser=(val)

コマンドライン引数の解析のための [[c:OptionParser]] オブジェクトを設定
します。

@param val [[c:OptionParser]] オブジェクトを指定します。

#@# 1.8 系の Options::OptionList については、内部だけで使用しているため、
#@# 記述しない。

#@since 2.0.0
--- markup -> String

コマンドライン引数の --markup オプションで指定したフォーマットを返しま
す。

指定されていない場合は 'rdoc' を返します。

--- markup=(val)

コマンドライン引数の --markup オプションと同様の指定を行います。

@param val フォーマットを文字列で指定します。

--- page_dir -> Pathname | nil

コマンドライン引数の --page-dir オプションで指定したディレクトリを返し
ます。

指定されていない場合は nil を返します。

--- page_dir=(val)

コマンドライン引数の --page-dir オプションと同様の指定を行います。

@param val パスを文字列で指定します。

--- root -> Pathname

コマンドライン引数の --root オプションで指定したディレクトリを返します。

指定されていない場合はカレントディレクトリを返します。

--- root=(val)

コマンドライン引数の --root オプションと同様の指定を行います。

@param val パスを文字列で指定します。

--- static_path -> [String]

コマンドライン引数の --copy-files オプションで指定したパスの一覧を返し
ます。

--- static_path=(vals)

コマンドライン引数の --copy-files オプションと同様の指定を行います。

@param vals パスを文字列の配列で指定します。

--- finish_page_dir

ライブラリ内部で使用します。

--- sanitize_path(path)

ライブラリ内部で使用します。

--- warn(message) -> nil

--verbose オプションを指定していた場合に message を 標準エラー出力
$stderr に出力します。

--- write_options -> object

カレントディレクトリの .rdoc_options ファイルに指定した設定を YAML 形式
で保存します。
#@end

== Constants

#@since 1.9.3
--- DEPRECATED -> {String -> String}

非推奨のオプションの一覧を返します。

#@# #@since 2.0.0
#@# --- Template -> Object
#@# #@else
#@# --- Template -> nil
#@# #@end
#@#
#@# Option validator for OptionParser that matches a template directory for an
#@# installed generator that lives in
#@# <tt>"rdoc/generator/template/#{template_name}"</tt>

#@end
#@since 2.0.0
--- SPECIAL -> [String]

--write-options を指定した際に .rdoc_options ファイルに保存されないオプ
ションの一覧を返します。

#@# --- Directory -> Object
#@#
#@# Option validator for OptionParser that matches a directory that exists on
#@# the filesystem.
#@#
#@# --- Path -> Object
#@#
#@# Option validator for OptionParser that matches a comma-separated list of
#@# files or directories that exist on the filesystem.
#@#
#@# --- PathArray -> Object
#@#
#@# Option validator for OptionParser that matches a comma-separated list of
#@# files or directories that exist on the filesystem.
#@end

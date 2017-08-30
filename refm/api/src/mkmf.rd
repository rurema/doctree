category Development

Ruby の拡張ライブラリのための Makefile を作成するライブラリです。

このライブラリは通常、extconf.rb という名前の ruby スクリプトから require されます。
この extconf.rb を実行して Makefile を作成するのが慣習です。

extconf.rb の書きかたについては、
Ruby のアーカイブに含まれる doc/extension.rdoc (日本語版は doc/extension.ja.rdoc)
も参照してください。

このライブラリでは extconf.rb を記述するのに有用なメソッドを定義しています。
ヘッダファイルの存在チェック、ライブラリの存在チェックなど、
システム間の差異を調べシステムに適した Makefile を生成するために
これらのメソッドが必要となります。

=== 使い方

架空の拡張ライブラリ foo.so を作成することを考えます。
この拡張ライブラリを作成するためには、
ヘッダファイル bar.h とライブラリ libbar.a の関数 baz() が必要だとします。
このための extconf.rb は以下のように書きます。

  require 'mkmf'

  dir_config('bar')
  if have_header('bar.h') and have_library('bar', 'baz')
    create_makefile('foo')
  end

拡張ライブラリ foo.so を作成、インストールするには以下のようにします。

  $ ruby extconf.rb
  $ make
  $ make site-install

foo.so の extconf.rb では dir_config('bar') を実行しているので、
ユーザは以下のようにコマンドラインオプション --with-bar-dir
などを使って、ヘッダファイルのパスやライブラリのパスを指定できます。

  $ ruby extconf.rb --with-bar-include=/usr/local/include \
                    --with-bar-lib=/usr/local/lib

  または

  $ ruby extconf.rb --with-bar-dir=/usr/local

dir_config 関数の詳細については
[[m:Kernel#dir_config]] を参照してください。

=== configure オプション

configure オプションとは Ruby インタプリタのコンパイル時に指定された
configure スクリプトのオプション、
または extconf.rb 実行時のオプションのことです。

extconf.rb の作成者は任意のオプションを定義できます。
[[m:Kernel#arg_config]] も参照してください。

また、以下のオプションがデフォルトで利用可能です。

: --with-opt-include=DIR
    ヘッダファイルを探索するディレクトリ DIR を追加します。

: --with-opt-lib=DIR
    ライブラリファイルを探索するディレクトリ DIR を追加します。

: --with-opt-dir=DIR

    ヘッダファイル、ライブラリファイルを探索するディレクトリ
    DIR/include、DIR/lib をそれぞれ追加します。

: --with-TARGET-include=DIR

    ヘッダファイルを探索するディレクトリ DIR を追加します。

    extconf.rb の中で dir_config(TARGET)
    を実行していればこのオプションを指定できます。

: --with-TARGET-lib=DIR

    ライブラリを探索するディレクトリ DIR を追加します。

    extconf.rb の中で dir_config(TARGET)
    を実行していればこのオプションを指定できます。

: --with-TARGET-dir=DIR

    ヘッダファイル、ライブラリファイルを探索するディレクトリ
    DIR/include、DIR/lib をそれぞれ追加します。

    extconf.rb の中で dir_config(TARGET)
    を実行していればこのオプションを指定できます。

=== depend ファイル

カレントディレクトリに depend という名前のファイルがある場合、
生成される Makefile の最後に depend ファイルの内容が追加されます。

depend ファイルはソースファイルの依存関係を記述するために使います。
例えば拡張ライブラリのソースコード foo.c が foo.h をインクルードしている場合、
foo.h が更新されたときにも foo.c を再コンパイルしたいでしょう。
このような依存関係を記述するには depend ファイルに以下の 1 行を書きます。

  foo.o: foo.c foo.h

このように書くと、foo.o が foo.c と foo.h に依存していることを示します。
つまり、foo.c か foo.h のどちらかが更新された場合に
foo.o がリコンパイルされるようになります。

C コンパイラによっては、このような記述を自動生成できます。
一般に、このためのオプションは「-M」です。
「-M」オプションを持つ C コンパイラを使っている場合は、
以下のコマンドを実行するだけで適切な depend が生成できます。

  $ cc -M *.c > depend

gcc には、-M オプションを改善した -MM というオプションもあります。
このオプションは、通常更新することのない stdio.h など、
システムのヘッダファイルを依存関係に含めません。
この -MM オプションでは、「#include <...>」の形式で参照される
ヘッダファイルをシステムのヘッダファイルとみなしているようです。

gcc の -MM オプションを使う場合は、
以下のコマンドを実行すれば適切な depend が生成できます。

  $ gcc -MM *.c > depend

なお、depend ファイルを依存関係の記述以外に使うべきではありません。
mkmf.rb が depend ファイルを Makefile に連結するときに、
その内容を加工する場合があるからです。

=== extconf.rb が生成する make ターゲット

extconf.rb が生成する Makefile には以下のターゲットが定義されています。

: all
    拡張ライブラリを作成します。

: clean
    作成した拡張ライブラリ、オブジェクトファイルなどを削除します。

: distclean
: realclean
    clean ターゲットが削除するファイルに加えて、
    Makefile, extconf.h, core, ruby なども削除します。

: install
: site-install
    作成した拡張ライブラリを $sitearchdir にインストールします。
    カレントディレクトリにディレクトリ lib があれば
    その配下の ruby スクリプト (*.rb ファイル) を、
    ディレクトリ階層を保ったまま $sitelibdir にインストールします。

= reopen Kernel

== Private Instance Methods

#@since 1.9.3
--- xsystem(command, opts = nil) -> ()
#@else
--- xsystem(command) -> ()
#@end

[[m:Kernel.#system]] と同じですが、コマンドの出力は(標準出力、標準エラー
出力ともに)ログファイルに出力します。ログファイル名は mkmf.log です。

@param command コマンドを指定します。
#@since 1.9.3
@param opts オプションを [[c:Hash]] で指定します。
            :werror というキーに真を指定すると
#@end

@see [[m:Kernel.#system]]

--- xpopen(command, *mode) -> IO
--- xpopen(command, *mode){ ... } -> object

command を表示してから [[m:IO.popen]] の実行します。

@param command コマンド名を指定します。

@param mode オープンする IO ポートのモードを指定します。mode の詳細は [[m:Kernel.#open]] 参照して下さい。

@see [[m:IO.popen]]

--- log_src(src) -> ()

与えられた C プログラムのソースコードをログ出力します。

@param src C プログラムのソースコードを指定します。

--- create_tmpsrc(src) -> String

与えられた C プログラムのソースコードを一時ファイルに出力して与えられたソースコードを返します。

@param src C プログラムのソースコードを指定します。

#@# --- try_link0(src[, opt])
#@# nodoc

--- have_devel? -> bool

開発環境がインストールされているかどうか検査するために何もしない実行ファ
イルを作成しようと試みます。成功した場合は、真を返します。失敗した場合
は、偽を返します。

--- try_do(src, command, *opts) -> ()
--- try_do(src, command, *opts){ ... } -> ()

@param src C プログラムのソースコードを指定します。

@param command コマンドを指定します。

@param opts オプションを [[c:Hash]] で指定します。

@raise RuntimeError 開発環境がインストールされていない場合に発生します。

@see [[m:Kernel#xsystem]]

--- link_command(ldflags, opt = "", libpath = $DEFLIBPATH|$LIBPATH) -> String

実際にリンクする際に使用するコマンドを返します。

@param ldflags LDFLAGS に追加する値を指定します。

@param opt LIBS に追加する値を指定します。

@param libpath LIBPATH に指定する値を指定します。

@see [[m:RbConfig.expand]]

--- cc_command(opt = "") -> String

実際にコンパイルする際に使用するコマンドを返します。

@param opt コンパイラに与える追加のコマンドライン引数を指定します。

@see [[m:RbConfig.expand]]

--- cpp_command(outfile, opt = "") -> String

実際にプリプロセッサを実行する際に使用するコマンドを返します。

@param outfile 出力ファイルの名前を指定します。

@param opt プリプロセッサに与える追加のコマンドライン引数を指定します。

@see [[m:RbConfig.expand]]

--- libpathflag(libpath = $DEFLIBPATH|$LIBPATH) -> String

与えられた libpath を -L 付きの文字列に変換して返します。

@param libpath LIBPATH に指定する値を指定します。

--- with_werror(opt, opts = nil){|opt| ... } -> object
--- with_werror(opt, opts = nil){|opt, opts| ... } -> object
#@todo 内部用？

???

@param opt ????

@param opts ????

@return ブロックを評価した結果を返します。

--- rm_f(*files) -> ()

[[m:FileUtils.#rm_f]] のラッパーメソッドです。

@param files ファイルのリストか、[[m:Dir.glob]]で利用できる glob パターンを指定します。
             最後の要素が [[c:Hash]] の場合は [[m:FileUtils.#rm_f]] の第二引数になります。

@see [[m:FileUtils.#rm_f]], [[m:Dir.glob]]

--- rm_rf(*files) -> ()

[[m:FileUtils.#rm_rf]] のラッパーメソッドです。

@param files ファイルのリストか、[[m:Dir.glob]]で利用できる glob パターンを指定します。
             最後の要素が [[c:Hash]] の場合は [[m:FileUtils.#rm_f]] の第二引数になります。

@see [[m:FileUtils.#rm_rf]], [[m:Dir.glob]]

--- modified?(target, times) -> Time | nil

target が times の全ての要素よりも新しい場合は target の更新時刻を返します。
そうでない場合は nil を返します。target が存在しない場合も nil を返します。

@param target 対象のファイル名を指定します。

@param times [[c:Time]] の配列か [[c:Time]] を一つ指定します。

--- merge_libs(*libs) -> [String]
#@todo 使われてない

@param libs ???

--- try_link(src, opt = "", *options) -> bool
--- try_link(src, opt = "", *options){ ... } -> bool

C プログラムのソースコード src をコンパイル、リンクします。

このメソッドは [[m:$CFLAGS]] と [[m:$LDFLAGS]] の値もコンパイラまたはリ
ンカに渡します。

問題なくリンクできたら true を返します。
コンパイルとリンクに失敗したら false を返します。

@param src C プログラムのソースコードを指定します。

@param opt リンカにコマンド引数として渡す値を指定します。

例：

  require 'mkmf'
  if try_link("int main() { sin(0.0); }", '-lm')
    $stderr.puts "sin() exists"
  end

--- try_cpp(src, opt = "", *opts) -> bool
--- try_cpp(src, opt = "", *opts){ ... } -> bool

C プログラムのソースコード src をプリプロセスします。

[[m:$CPPFLAGS]], [[m:$CFLAGS]] の値もプリプロセッサにコマンドライン引数
として渡します。

このメソッドはヘッダファイルの存在チェックなどに使用します。

@param src C プログラムのソースコードを指定します。

@param opt プリプロセッサにコマンドライン引数として渡す値を指定します。

@return 問題なくプリプロセスできたら true を返します。
        プリプロセスに失敗したら false を返します。

例：

  require 'mkmf'
  if try_cpp("#include <stdio.h>")
    $stderr.puts "stdio.h exists"
  end

--- egrep_cpp(pattern, src, opt = "") -> bool
--- egrep_cpp(pattern, src, opt = ""){ ... } -> bool

C プログラムのソースコード src をプリプロセスし、
その結果が正規表現 pattern にマッチするかどうかを判定します。

  CPP $CFLAGS opt | egrep pat

を実行し、その結果が正常かどうかを true または false で返します。

このメソッドはヘッダファイルに関数などの宣言があるかどうか
検査するために使用します。

@param pattern 「egrep の」正規表現を文字列で指定します。
                Ruby の正規表現ではありません。

@param src C 言語のソースコードを文字列で記述します。

@see [[man:egrep(1)]]

--- try_run(src, opt = "") -> bool
--- try_run(src, opt = ""){ ... } -> bool

C プログラムのソースコード src をコンパイルし、
生成した実行ファイルを実行します。

生成した実行ファイルが正常に実行できれば true を返します。
実行が失敗した場合は false を返します。

@param src C 言語のソースコードを文字列で記述します。

@param opt C コンパイラのオプションを指定します。

--- install_rb(mfile, dest, srcdir = nil) -> Array

このメソッドは create_makefile が使用します。
内部用のメソッドです。

ディレクトリ srcdir/lib 配下の Ruby スクリプト (*.rb ファイル)
を dest にインストールするための Makefile 規則を mfile に出力します。

srcdir/lib のディレクトリ構造はそのまま dest 配下に反映されます。

@param mfile Makefile を表す [[c:File]] のインスタンスです。

@param dest インストールする先のディレクトリを指定します。

@param srcdir ソースディレクトリを指定します。

#@# --- append_library(libs, lib)
#@#  nodoc
#@# 
#@# ライブラリのリスト libs の先頭にライブラリ lib を追加し、
#@# その結果を返します。
#@# 
#@# 引数 libs とこのメソッドの戻り値は
#@# リンカに渡す引数形式の文字列です。
#@# すなわち、UNIX 系 OS では
#@# 
#@#   "-lfoo -lbar"
#@# 
#@# であり、MS Windows などでは
#@# 
#@#   "foo.lib bar.lib"
#@# 
#@# です。
#@# 第 2 引数 lib は、この例での "foo" や "bar" にあたります。

--- have_macro(macro, headers = nil, opt = "") -> bool
--- have_macro(macro, headers = nil, opt = ""){ ... } -> bool

与えられた macro が共通のヘッダファイルか headers に定義されている場合は真を返します。
そうでない場合は偽を返します。

@param macro マクロの名前を指定します。

@param headers 追加のヘッダファイルを指定します。

@param opt C コンパイラに渡すコマンドライン引数を指定します。

--- have_library(lib, func = nil, headers = nil) -> bool
--- have_library(lib, func = nil, headers = nil){ ... } -> bool

ライブラリ lib がシステムに存在し、関数 func が定義されているかどうかをチェックします。
チェックが成功すれば [[m:$libs]] に lib を追加し true を返します。
チェックが失敗したら false を返します。

@param lib ライブラリの名前を指定します。

@param func 検査する関数名を指定します。
            nil または空文字列のときは、"main" になります。

@param headers 追加のヘッダファイルを指定します。

--- find_library(lib, func, *paths) -> bool
--- find_library(lib, func, *paths){ ... } -> bool

関数 func が定義されたライブラリ lib を探します。

最初はパスを指定せずに探し、
それに失敗したら paths[0] を指定して探し、
それにも失敗したら paths[1] を指定して探し……
というように、リンク可能なライブラリを探索します。

上記の探索でライブラリ lib を発見できた場合は lib を [[m:$libs]] に追加し、
見つかったパスを [[m:$LDFLAGS]] に追加して true を返します。
指定されたすべてのパスを検査してもライブラリ lib が見つからないときは、
変数を変更せず false を返します。

paths を指定しないときは [[m:Kernel#have_library]] と同じ動作です。

@param lib ライブラリ名を指定します。

@param func 関数名を指定します。
            nil または空文字列を指定した場合は "main" になります。

@param paths ライブラリを検索するパスを文字列の配列で指定します。

--- find_header(header, *paths) -> bool

与えられた paths から header を検索し、見つかった場合は真を返します。
そうでない場合は偽を返します。

ヘッダが見つかったディレクトリをコンパイラに渡すコマンドラインオプショ
ンに追加します(-I オプションを経由します)。

@param header ヘッダを指定します。

@param paths ヘッダを検索するパスを指定します。

--- have_func(func, headers = nil) -> bool
--- have_func(func, headers = nil){ ... } -> bool

関数 func がシステムに存在するかどうかを検査します。

関数 func が存在すれば [[m:$defs]] に "-DHAVE_func" (func は大文字に変
換されます) を追加して true を返します。関数 func が見つからないときは
グローバル変数を変更せず false を返します。

@param func 関数名を指定します。

@param headers 関数 func を使用するのに必要なヘッダファイル名を指定しま
               す。これは関数の型をチェックするためではなく、関数が実際
               にはマクロで定義されている場合などのために使用します。

#@since 1.9.2
--- have_header(header, preheaders = nil) -> bool
--- have_header(header, preheaders = nil){ ... } -> bool
#@else
--- have_header(header, preheaders = nil) -> bool
--- have_header(header, preheaders = nil){ ... } -> bool
#@end

ヘッダファイル header がシステムに存在するかどうか検査します。

ヘッダファイル header が存在する場合は、グローバル変数 [[m:$defs]] に
"-DHAVE_header" を追加して true を返します。ヘッダファイル header が存
在しない場合は $defs は変更せず false を返します。

@param header 検査したいヘッダファイルを指定します。

#@since 1.9.2
@param preheaders ヘッダファイルを検査する前に読み込んでおくヘッダファイルを指定します。
#@end

--- have_struct_member(type, member, headers = nil) -> bool
--- have_struct_member(type, member, headers = nil){ ... } -> bool

member というメンバを持つ構造体 type がシステムに存在するかどうか検査します。

member というメンバを持つ構造体 type がシステムに存在する場合は、
グローバル変数 [[m:$defs]] に "-DHAVE_type_member" を追加し、真を返します。
member というメンバを持つ構造体 type が存在しない場合は、偽を返します。

例えば

  require 'mkmf'
  have_struct_member('struct foo', 'bar') # => true

#@since 1.9.1
である場合、HAVE_STRUCT_FOO_BAR というプリプロセッサマクロをコンパイラに渡します。
また、後方互換性のために HAVE_ST_BAR というプリプロセッサマクロも定義します。
#@else
である場合、HAVE_ST_BAR というプリプロセッサマクロをコンパイラに渡します。
#@end

@param type 検査したい構造体の名前を指定します。

@param member 検査したい構造体のメンバの名前を指定します。

@param headers 追加のヘッダファイルを指定します。

--- have_type(type, headers = nil, opt = "") -> bool
--- have_type(type, headers = nil, opt = ""){ ... } -> bool

静的な型 type がシステムに存在するかどうか検査します。

型 type がシステムに存在する場合は、グローバル変数 [[m:$defs]] に
"-DHAVE_type" を追加し、真を返します。型 type がシステムに存在しない場
合は、偽を返します。

例えば、

  require 'mkmf'
  have_type('foo') # => true

である場合、HAVE_TYPE_FOO をというプリプロセッサマクロをコンパイラに渡します。

@param type 検査したい型の名前を指定します。

@param headers 追加のヘッダを指定します。

@param opt コンパイラに渡す追加のオプションを指定します。

--- find_type(type, opt, *headers) -> Array
--- find_type(type, opt, *headers){ ... } -> Array

静的な型 type がシステムに存在するかどうか検査します。

@param type 検査したい型の名前を指定します。

@param opt コンパイラに渡す追加のオプションを指定します。

@param headers 追加のヘッダを指定します。

@see [[m:Kernel#have_type]] 

--- have_var(var, headers = nil) -> bool
--- have_var(var, headers = nil){ ... } -> bool

変数 var がシステムに存在するかどうか検査します。

変数 var がシステムに存在する場合は、グローバル変数 [[m:$defs]] に
"-DHAVE_var" を追加し、真を返します。変数 var がシステムに存在しない場
合は、偽を返します。

例えば、

  require 'mkmf'
  have_var('foo') # => true

である場合、HAVE_FOO というプリプロセッサマクロをコンパイラに渡します。

@param var 検査したい変数名を指定します。

@param headers 追加のヘッダを指定します。

#@since 1.9.3
--- have_framework(framework) -> bool
--- have_framework(framework){ ... } -> bool

フレームワーク framework がシステムに存在するかどうか検査します。

フレームワーク framework がシステムに存在する場合は、グローバル変数
[[m:$defs]] に "-DHAVE_FRAMEWORK_framework" を追加し、真を返します。ま
た、グローバル変数 [[m:$LDFLAGS]] に "-framework #{framework}" を追加し
ます。 フレームワーク framework がシステムに存在しない場合は、偽を返し
ます。

例えば、

  require 'mkmf'
  have_framework('Ruby') # => true

である場合、HAVE_FRAMEWORK_RUBY というプリプロセッサマクロをコンパイラに渡します。

@param framework フレームワークの名前を指定します。

#@end

--- check_sizeof(type, headers = nil) -> Integer | nil
--- check_sizeof(type, headers = nil){ ... } -> Integer | nil

与えられた型のサイズを返します。

型 type がシステムに存在する場合は、グローバル変数 [[m:$defs]] に
"-DSIZEOF_type=X" を追加し、型のサイズを返します。型 type がシステムに
存在しない場合は、nil を返します。

例えば、

  require 'mkmf'
  check_sizeof('mystruct') # => 12

である場合、SIZEOF_MYSTRUCT=12 というプリプロセッサマクロをコンパイラに渡します。

@param type 検査したい型を指定します。

@param headers 追加のヘッダファイルを指定します。

#@since 1.9.3
--- check_signedness(type, headers = nil, opts = nil) -> "signed" | "unsigned" | nil
--- check_signedness(type, headers = nil, opts = nil){ ... } -> "signed" | "unsigned" | nil

 Returns the signedness of the given +type+.  You may optionally
 specify additional +headers+ to search in for the +type+.
 
 If the +type+ is found and is a numeric type, a macro is passed as a
 preprocessor constant to the compiler using the +type+ name, in
 uppercase, prepended with 'SIGNEDNESS_OF_', followed by the +type+
 name, followed by '=X' where 'X' is positive integer if the +type+ is
 unsigned, or negative integer if the +type+ is signed.
 
 For example, if size_t is defined as unsigned, then
 check_signedness('size_t') would returned +1 and the
 SIGNEDNESS_OF_SIZE_T=+1 preprocessor macro would be passed to the
 compiler, and SIGNEDNESS_OF_INT=-1 if check_signedness('int') is
 done.

#@end
#@since 1.9.2
--- convertible_int(type, headers = nil, opts = nil)
--- convertible_int(type, headers = nil, opts = nil){ ... }

 Returns the convertible integer type of the given +type+.  You may
 optionally specify additional +headers+ to search in for the +type+.
 _Convertible_ means actually same type, or typedefed from same type.
 
 If the +type+ is a integer type and _convertible_ type is found,
 following macros are passed as preprocessor constants to the
 compiler using the +type+ name, in uppercase.
 
 * 'TYPEOF_', followed by the +type+ name, followed by '=X' where 'X'
   is the found _convertible_ type name.  * 'TYP2NUM' and 'NUM2TYP,
   where 'TYP' is the +type+ name in uppercase with replacing '_t'
   suffix with 'T', followed by '=X' where 'X' is the macro name to
   convert +type+ to +Integer+ object, and vice versa.
 
 For example, if foobar_t is defined as unsigned long, then
 convertible_int("foobar_t") would return "unsigned long", and define
 macros:
 
   #define TYPEOF_FOOBAR_T unsigned long
   #define FOOBART2NUM ULONG2NUM
   #define NUM2FOOBART NUM2ULONG

#@end

--- arg_config(config, default) { ... } -> object | String | true | nil

configure オプション --config の値を返します。

@param config オプションを文字列で指定します。

@param default 引数 config で指定したオプションのデフォルト値を指定します。

@return オプションが指定されてた場合は true を、指定されなかった場合は
        nil を返します。
        引数 default、あるいはブロックを指定すると、オプションが指定さ
        れていない場合に引数 default の値かブロックの評価結果を返します
        (両方指定した場合はブロックが優先されます)。
        オプションに引数が指定されていた場合は指定した文字列を返します。

例えば extconf.rb で arg_config メソッドを使う場合、

  $ ruby extconf.rb --foo --bar=baz

と実行したとき、arg_config("--foo") の値は true、
arg_config("--bar") の値は "baz" です。

--- with_config(config, default = nil) -> bool | String
--- with_config(config, default = nil){|config, default| ... } -> bool | String

configure のオプションを検査します。

configure のオプションに --with-<config> が指定された場合は真を返しま
す。--without-<config> が指定された場合は偽を返します。どちらでもない場
合は default を返します。

これはデバッグ情報などのカスタム定義を、追加するのに役立ちます。

@param config configure のオプションの名前を指定します。

@param default デフォルト値を返します。

例
  require 'mkmf'
  if with_config("debug")
     $defs.push("-DOSSL_DEBUG") unless $defs.include? "-DOSSL_DEBUG"
  end

--- enable_config(config, default) -> bool | String
--- enable_config(config, default){|config, default| ... } -> bool | String

configure のオプションを検査します。

configure のオプションに --enable-<config> が指定された場合は、真を返し
ます。--disable-<config> が指定された場合は。偽を返します。どちらでもな
い場合は default を返します。

これはデバッグ情報などのカスタム定義を、追加するのに役立ちます。

@param config configure のオプションの名前を指定します。

@param default デフォルト値を返します。

例
  require 'mkmf'
  if enable_config("debug")
     $defs.push("-DOSSL_DEBUG") unless $defs.include? "-DOSSL_DEBUG"
  end

--- create_header(header = "extconf.h") -> String

[[m:Kernel#have_func]], [[m:Kernel#have_header]] などの検査結果を元に、
ヘッダファイルを生成します。

このメソッドは extconf.rb の最後で呼び出すようにしてください。

@param header ヘッダファイルの名前を指定します。

@return ヘッダファイルの名前を返します。

例

  # extconf.rb
  require 'mkmf'
  have_func('realpath')
  have_header('sys/utime.h')
  create_header
  create_makefile('foo')

上の extconf.rb は以下の extconf.h を生成します。

  #ifndef EXTCONF_H
  #define EXTCONF_H
  #define HAVE_REALPATH 1
  #define HAVE_SYS_UTIME_H 1
  #endif

--- dir_config(target, idefault = nil, ldefault = nil) -> [String, String]

configure オプション
--with-TARGET-dir,
--with-TARGET-include,
--with-TARGET-lib
をユーザが extconf.rb に指定できるようにします。

--with-TARGET-dir オプションは
システム標準ではない、
ヘッダファイルやライブラリがあるディレクトリをまとめて指定するために使います。
ユーザが extconf.rb に --with-TARGET-dir=PATH を指定したときは
[[m:$CFLAGS]] に "-IPATH/include" を、
[[m:$LDFLAGS]] に "-LPATH/lib" を、
それぞれ追加します。

--with-TARGET-include オプションは
システム標準ではないヘッダファイルのディレクトリを指定するために使います。
ユーザが extconf.rb に --with-TARGET-include=PATH を指定したときは
[[m:$CFLAGS]] に PATH を追加します。

--with-TARGET-lib オプションは
システム標準ではないライブラリのディレクトリを指定するために使います。
ユーザが extconf.rb に --with-TARGET-lib=PATH を指定したときは
[[m:$CFLAGS]] に PATH を追加します。

@param target ターゲットの名前を指定します。

@param idefault システム標準ではないヘッダファイルのディレクトリのデフォルト値を指定します。

@param ldefault システム標準ではないライブラリのディレクトリのデフォルト値を指定します。

例
  require 'mkmf'
  # xml2 の configure オプションを指定できるようにします。
  xml2_dirs = dir_config('xml2', '/opt/local/include/libxml2', '/opt/local/lib')

--- create_makefile(target, srcprefix = nil) -> true
#@todo

[[m:Kernel#have_library]] などの各種検査の結果を元に、拡張ライブラリを
ビルドするための Makefile を生成します。

extconf.rb は普通このメソッドの呼び出しで終ります。

@param target ターゲットとなる拡張ライブラリの名前を指定します。
              例えば、拡張ライブラリで "Init_foo" という関数を定義して
              いる場合は、"foo" を指定します。
              '/' を含む場合は、最後のスラッシュ以降のみをターゲット名
              として使用します。残りはトップレベルのディレクトリ名と見
              なされ、生成された Makefile はそのディレクトリ構造に従い
              ます。
              例えば、'test/foo' を指定した場合、拡張ライブラリは
              'test' ディレクトリにインストールされます。この拡張ライブ
              ラリを Ruby スクリプトから使用するときは
              "require 'test/foo'" とする必要があります。

@param srcprefix ソースコードがあるディレクトリ名を指定します。
                 省略した場合は extconf.rb があるディレクトリを使用します。
                 
以下のようなディレクトリ構成の場合:

   ext/
      extconf.rb
      test/
         foo.c

このようにします。

   require 'mkmf'
   create_makefile('test/foo', 'test')

このようにして作った Makefile で 'make install' すると拡張ライブラリは、
以下のパスにインストールされます。

  /path/to/ruby/sitearchdir/test/foo.so

--- find_executable(bin, path = nil) -> String | nil

パス path から実行ファイル bin を探します。

実行ファイルが見つかった場合は、そのフルパスを返します。
実行ファイルが見つからなかった場合は、nilを返します。

このメソッドは Makefile を変更しません。

@param bin 実行ファイルの名前を指定します。

@param path パスを指定します。デフォルトは環境変数 PATH です。
            環境変数 PATH が定義されていない場合は /usr/local/bin,
            /usr/ucb, /usr/bin, /bin を使います。

--- dummy_makefile(srcdir) -> String

ダミーの Makefile を作成します。

@param srcdir ソースディレクトリを指定します。

#@since 1.9.1
--- depend_rules(depend) -> Array

ファイルの依存関係の書かれた depend ファイルの内容を処理します。

@param depend depend ファイルの内容を指定します。

@return 見つかった依存関係を Makefile 形式で返します。
#@end

#@# --- init_mkmf(config = CONFIG, rbconfig = RbConfig::CONFIG)
#@# nodoc
#@# --- mkmf_failed(path
#@# nodoc
#@# --- pkg_config(pkg)
#@# nodoc
#@# --- with_destdir
#@# nodoc
#@# --- winsep
#@# nodoc
#@# --- mkintpath
#@# nodoc
#@# --- configuration(srcdir)
#@# nodoc
#@# --- scalar_ptr_type?(type, member = nil, headers = nil)
#@# --- scalar_ptr_type?(type, member = nil, headers = nil){ ... }
#@# nodoc
#@# --- scalar_type?(type, member = nil, headers = nil)
#@# --- scalar_type?(type, member = nil, headers = nil){ ... }
#@# nodoc
#@# --- have_typeof?
#@# nodoc
#@# --- what_type?(type, member = nil, headers = nil)
#@# --- what_type?(type, member = nil, headers = nil){ ... }
#@# nodoc
#@# --- find_executable0(bin, path = nil)
#@# nodoc

#@# --- checking_for(message, format = nil){ ... } -> object
#@# 内部用
#@# have_*, find_* 系メソッドの実行結果を標準出力に出力するためのメソッドです。
#@# 
#@# @param message メッセージを指定します。
#@# 
#@# @param format フォーマット文字列を指定します。

#@# #@since 1.8.6
#@# --- checking_message(target, place = nil, opt = nil) -> String
#@# 内部用
#@# #@end

--- try_run(src, opt = "") -> bool | nil
--- try_run(src, opt = ""){ ... } -> bool | nil

与えられたソースコードが、コンパイルやリンクできるかどうか検査します。

以下の全ての検査に成功した場合は、真を返します。そうでない場合は偽を返します。

  * src が C のソースとしてコンパイルできるか
  * 生成されたオブジェクトが依存しているライブラリとリンクできるか
  * リンクしたファイルが実行可能かどうか
  * 実行ファイルがきちんと存在しているかどうか

ブロックを与えた場合、そのブロックはコンパイル前に評価されます。
ブロック内でソースコードを変更することができます。

@param src C のソースコードを指定します。

@param opt リンカに渡すオプションを指定します。
           $CFLAGS, $LDFLAGS もリンカには渡されます。

@return 実行ファイルが存在する場合は true を返します。そうでない場合は
        false を返します。プリプロセス、コンパイル、リンクのいずれかの
        段階で失敗した場合は nil を返します。

--- try_compile(src, opt = "", *opts) -> bool
--- try_compile(src, opt = "", *opts){ ... } -> bool

与えられた C のソースコードがコンパイルできた場合は真を返します。
コンパイルできなかった場合は偽を返します。

ブロックを与えた場合、そのブロックはコンパイル前に評価されます。
ブロック内でソースコードを変更することができます。

@param src C のソースコードを指定します。

@param opt コンパイラに渡すオプションを指定します。
           $CFLAGS もコンパイラには渡されます。

--- try_static_assert(expr, headers = nil, opt = "") -> bool
--- try_static_assert(expr, headers = nil, opt = ""){ ... } -> bool
#@todo ???

...

@param expr C 言語の式を指定します。

@param headers 追加のヘッダファイルを指定します。

@param opt コンパイラに渡すオプションを指定します。
           $CFLAGS もコンパイラには渡されます。

--- try_constant(const, headers = nil, opt = "") -> Integer | nil
--- try_constant(const, headers = nil, opt = ""){ ... } -> Integer | nil

定数 const がシステムに存在するかどうか検査します。
[[m:Kernel#have_const]] を使ってください。

@param const C 言語の定数名を指定します。

@param headers 追加のヘッダファイルを指定します。

@param opt コンパイラに渡すオプションを指定します。
           $CFLAGS もコンパイラには渡されます。

@return 定数 const がシステムに存在する場合はその値を返します。
        定数 const がシステムに存在しない場合は nil を返します。

--- try_func(func, libs, headers = nil) -> bool
--- try_func(func, libs, headers = nil){ ... } -> bool

関数 func がシステムに存在するかどうか検査します。
[[m:Kernel#have_func]] を使ってください。

@param func 関数名を指定します。

@param libs ライブラリの名前を指定します。

@param headers 関数 func を使用するのに必要なヘッダファイル名を指定しま
               す。これは関数の型をチェックするためではなく、関数が実際
               にはマクロで定義されている場合などのために使用します。

--- try_var(var, headers = nil) -> bool
--- try_var(var, headers = nil){ ... } -> bool

[[m:Kernel#have_var]] を使ってください。

@param var 検査したい変数名を指定します。

@param headers 追加のヘッダを指定します。

--- try_type(type, headers = nil, opt = "") -> bool
--- try_type(type, headers = nil, opt = ""){ ... } -> bool

[[m:Kernel#have_type]] を使ってください。

@param type 検査したい型の名前を指定します。

@param headers 追加のヘッダを指定します。

@param opt コンパイラに渡す追加のオプションを指定します。

--- install_files(mfile, ifiles, map = nil, srcprefix = nil) -> []

このメソッドは create_makefile, install_rb が使用します。
内部用のメソッドです。

@param mfile Makefile を表す [[c:File]] のインスタンスです。

@param ifiles インストールするファイルのリストを指定します。

@param map ???

@param srcprefix ソースディレクトリを指定します。

--- message(format, *arg) -> nil

[[m:Kernel.#printf]] と同じように標準出力にメッセージを出力します。
メッセージ出力後すぐに [[m:IO#flush]] します。

$VERBOSE が真のときは何もしません。

@param format フォーマット文字列です。

@param arg フォーマットされる引数です。

@see [[m:Kernel.#printf]]

#@# --- typedef_expr(type, headers)
#@# nodoc
#@# --- try_signedness(tyep, member, headers = nil, opts = nil)
#@# --- try_signedness(tyep, member, headers = nil, opts = nil){ ... }
#@# nodoc

#@# --- macro_defined?(macro, src, opt = "") -> bool
#@# --- macro_defined?(macro, src, opt = ""){ ... } -> bool
#@# internal use Only
#@# --- config_string
#@# nodoc
#@# --- dir_re
#@# nodoc
#@# --- relative_from
#@# nodoc
#@# --- install_dirs
#@# nodoc
#@# --- map_dir
#@# nodoc

== Constants

--- CONFIG -> Hash
#@since 1.8.5
[[m:RbConfig::MAKEFILE_CONFIG]] と同じです。
#@else
[[m:Config::MAKEFILE_CONFIG]] と同じです。
#@end

#@# --- INSTALL_DIRS
#@# nodoc
#@# --- OUTFLAG
#@# nodoc
#@# --- COUTFLAG
#@# nodoc
#@# --- CPPOUTFILE
#@# nodoc
#@# --- CONFTEST_C
#@# nodoc
#@# --- STRING_OR_FAILED_FORMAT
#@# internal use only

== Special Variables

--- $srcdir -> String

Ruby インタプリタを make したときのソースディレクトリです。

--- $libdir -> String

Ruby のライブラリを置くディレクトリです。
通常は "/usr/local/lib/ruby/バージョン" です。

--- $archdir -> String

マシン固有のライブラリを置くディレクトリです。
通常は "/usr/local/lib/ruby/バージョン/arch" です。

--- $sitelibdir -> String

サイト固有のライブラリを置くディレクトリです。
通常は "/usr/local/lib/ruby/site_ruby/バージョン" です。

--- $sitearchdir -> String

サイト固有でかつマシン固有のライブラリを置くディレクトリです。
通常は "/usr/local/lib/ruby/site_ruby/バージョン/arch" です。

--- $hdrdir -> String

Ruby のヘッダファイル ruby.h が存在するディレクトリです。
通常は [[m:$archdir]] と同じで、"/usr/local/lib/ruby/バージョン/arch" です。

--- $topdir -> String

拡張ライブラリを make するためのヘッダファイル、
ライブラリ等が存在するディレクトリです。
通常は [[m:$archdir]] と同じで、"/usr/local/lib/ruby/バージョン/arch" です。

--- $defs -> [String]

拡張ライブラリをコンパイルするときのマクロ定義を指定する配列です。

この変数の値は、例えば

  ["-DHAVE_FUNC", "-DHAVE_HEADER_H"]

のような形式の配列です。

[[m:Kernel#have_func]] または [[m:Kernel#have_header]]
を呼び出すと、その検査結果が $defs に追加されます。

[[m:Kernel#create_header]]
はこの変数の値を参照してヘッダファイルを生成します。

--- $libs -> String

拡張ライブラリをリンクするときに
一緒にリンクされるライブラリを指定する文字列です。

この変数の値は、例えば

  "-lfoo -lbar"

のような形式の文字列です。

[[m:Kernel#have_library]] または [[m:Kernel#find_library]]
を呼び出すと、その検査結果が
間に空白をはさみつつ $libs に連結されます。

--- $CFLAGS -> String

拡張ライブラリをコンパイルするときの C コンパイラのオプションや、
ヘッダファイルのディレクトリを指定する文字列です。

[[m:Kernel#dir_config]] の検査が成功すると、
この変数の値に " -Idir" が追加されます。

--- $LDFLAGS -> String

拡張ライブラリをリンクするときのリンカのオプション、
ライブラリファイルのディレクトリを指定する文字列です。

[[m:Kernel#find_library]] または [[m:Kernel#dir_config]]
の検査が成功すると、$LDFLAGS の値に "-Ldir" を追加します。

#@# おそらくユーザに解放されていない変数
#@# --- $LOCAL_LIBS
#@#     ライブラリを指定する文字列です。
#@# 
#@# --- $local_flags
#@#     リンカオプションを指定する文字列です。

#@# = reopen String
#@# 内部用
#@# == Instance Methods
#@# 
#@# --- quote -> String
#@# 
#@# スペースを含む文字列をクオートして返します。
#@# 
#@# --- tr_cpp -> String
#@# 
#@# C プリプロセッサに使用できる名前を生成して返します。
#@# 
#@# = reopen Array
#@# 内部用
#@# == Instance Methods
#@# 
#@# --- quote -> Array
#@# 
#@# 全ての要素を [[m:String#quote]] して返します。
#@# 
#@# = module Logging
#@# 内部利用のみ


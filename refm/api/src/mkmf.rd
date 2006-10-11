Ruby の拡張ライブラリのための Makefile を作成するライブラリです。
このライブラリは通常、extconf.rb という名前の ruby スクリプトから require されます。
この extconf.rb を実行して Makefile を作成するのが慣習です。

extconf.rb の書きかたについては、
Ruby のアーカイブに含まれる README.EXT (日本語版は README.EXT.ja)
も参照してください。

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
#@# 以下は、extconf.rb を記述するのに有用な関数です。
#@# ヘッダファイルの存在チェック、ライブラリの存在チェックなど、
#@# システム間の差異を調べシステムに適した Makefile を生成するために
#@# これらの関数が必要となります。

#@# --- rm_f(files...)
#@#     ファイル ((|files|)) を削除します。((|files|)) には 
#@#     ((<Dir.glob|Dir>)) のワイルドカードを指定することができ
#@#     ます。
#@# 
#@# --- xsystem(command)
#@#     ruby の組み込み関数 ((<system|組み込み関数>))() と同じです
#@#     が、コマンドの出力は(標準出力、標準エラー出力ともに)ログ
#@#     ファイルに出力されます。ログファイル名は mkmf.log です。
#@# 
#@#     ruby をデバッグオプション((({-d})))付きで実行した場合は、コマンド
#@#     を表示した後に((<system|組み込み関数>))(((|command|))) を実行します。
#@# 
#@# --- try_link0(src[, opt])
#@#     ((<mkmf/try_link>)) の実体です。

--- try_link(src[, opt])

C プログラムのソースコード src をコンパイル、リンクします。
問題なくリンクできたら true を返します。
コンパイルとリンクに失敗したら false を返します。

第 2 引数 opt が指定されたときは、リンカにコマンド引数として渡します。
また、このメソッドは [[m:$CFLAGS]] と [[m:$LDFLAGS]] の値も
コンパイラまたはリンカに渡します。

例：

  if try_link("int main() { sin(0.0); }", '-lm')
    $stderr.puts "sin() exists"
  end

--- try_cpp(src[, opt])

C プログラムのソースコード src をプリプロセスします。
問題なくプリプロセスできたら true を返します。
プリプロセスに失敗したら false を返します。

第 1 引数 src は文字列で渡します。

第 2 引数 opt と [[m:$CFLAGS]] の値を
プリプロセッサにコマンドライン引数として渡します。

このメソッドはヘッダファイルの存在チェックなどに使用します。

例：

  if try_cpp("#include <stdio.h>")
    $stderr.puts "stdio.h exists"
  end

--- egrep_cpp(pat, src[, opt])

C プログラムのソースコード src をプリプロセスし、
その結果が正規表現 pat にマッチするかどうかを判定します。

  CPP $CFLAGS opt | egrep pat

を実行し、その結果が正常かどうかを true または false で返します。

第 1 引数 pat には「egrep の」正規表現を文字列で指定します。
Ruby の正規表現ではありません。

第 2 引数 src には C 言語のソースコードを文字列で記述します。

このメソッドはヘッダファイルに関数などの宣言があるかどうか
検査するために使用します。

--- try_run(src[, opt])

C プログラムのソースコード src をコンパイルし、
生成された実行ファイルを実行します。
正常に実行できれば true を返します。
実行が失敗した場合は false を返します。

第 1 引数 src には C 言語のソースコードを文字列で記述します。

第 2 引数 opt には C コンパイラのオプションを指定します。

--- install_rb(mfile, dest, srcdir = '.')
#@# このメソッドは create_makefile が使用します

ディレクトリ srcdir/lib 配下の Ruby スクリプト (*.rb ファイル)
を dest にインストールするための Makefile 規則を mfile に出力します。
mfile は [[c:IO]] クラスのインスタンスです。

srcdir/lib のディレクトリ構造はそのまま dest 配下に反映されます。

--- append_library(libs, lib)

ライブラリのリスト libs の先頭にライブラリ lib を追加し、
その結果を返します。

引数 libs とこのメソッドの戻り値は
リンカに渡す引数形式の文字列です。
すなわち、UNIX 系 OS では

  "-lfoo -lbar"

であり、MS Windows などでは

  "foo.lib bar.lib"

です。
第 2 引数 lib は、この例での "foo" や "bar" にあたります。

--- have_library(lib[, func])

ライブラリ lib がシステムに存在し、
関数 func が定義されているかどうかをチェックします。
チェックが成功すれば [[m:$libs]] に lib を追加し true を返します。
チェックが失敗したら false を返します。

第 2 引数 func を省略した場合、関数の存在までは検査せず、
ライブラリが存在するかどうかだけをチェックします。

第 2 引数 func が nil または空文字列 ("") のときは、
何も検査をせず、無条件で lib を追加します。

--- find_library(lib, func, *pathes)

関数 func が定義されたライブラリ lib を探します。
最初はパスを指定せずに探し、
それに失敗したら pathes[0] を指定して探し、
それにも失敗したら pathes[1] を指定して探し……
というように、リンク可能なライブラリを探索します。

上記の探索でライブラリ lib を発見できた場合は lib を [[m:mkmf#$libs]] に追加し、
見つかったパスを [[m:$LDFLAGS]] に追加して true を返します。
指定されたすべてのパスを検査してもライブラリ lib が見つからないときは、
変数を変更せず false を返します。

pathes を指定しないときは [[m:Kernel#have_library]] と同じ動作です。

--- have_func(func[, header])

関数 func がシステムに存在するかどうかを検査します。

関数 func が存在すれば [[m:$defs]] に
"-DHAVE_func" (func は大文字に変換されます) を追加して true を返します。
関数 func が見つからないときはグローバル変数を変更せず false を返します。

第 2 引数 header には、
関数 func を使用するのに必要なヘッダファイル名を指定します。
これは関数の型をチェックするためではなく、
関数が実際にはマクロで定義されている場合などのために使用します。

--- have_header(header)

ヘッダファイル header がシステムに存在するかどうか調べます。

ヘッダファイル header が存在すれば
グローバル変数 [[m:$defs]] に "-DHAVE_header" を追加して true を返します。
ヘッダファイル header が存在しないときは $defs は変更せず false を返します。
なお、-DAHVE_header の header には、
実際には header.upcase.tr('-.', '_') が使われます。

--- arg_config(config[, default])

configure オプション --config の値を返します。
オプションが指定されていないときは第 2 引数 default を返します。

例えば extconf.rb で arg_config メソッドを使う場合、

  $ ruby extconf.rb --foo --bar=baz

と実行したとき、arg_config("foo") の値は true、
arg_config("bar") の値は "baz" です。

--- with_config(config[, default])

[[m:Kernel#arg_config]] と同じですが、
--with-config オプションの値だけを参照します。

--- enable_config(config[, default])

[[m:Kernel#arg_config]] と同じですが、
--enable-config オプション、
または--disable-config オプションの値だけを参照します。

--- create_header

[[m:Kernel#have_func]] などの検査結果を元に、

  #define HAVE_FUNC 1
  #define HAVE_HEADER_H 1

のように定数を定義した extconf.h ファイルを生成します。

--- dir_config(target[, default])
--- dir_config(target[, idefault, ldefault])

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

以上 3 つの configure オプションがいずれも指定されていないときは、
デフォルト値として引数 default、idefault、ldefault の値が使われます。
第 2 引数のみ与えた場合は "-Idefault/include" と "-Ldefault/lib" をそれぞれ追加し、
第 3 引数も与えた場合は "-Iidefault" と "-Lldefault" をそれぞれ追加します。

--- create_makefile(target[, srcdir])

[[m:Kernel#have_library]] などの各種検査の結果を元に、
拡張ライブラリ TARGET.so をビルドするための Makefile を生成します。

第 2 引数 srcdir は make 変数 srcdir の値を指定します。
この変数には、ソースコードがあるディレクトリ名を指定します。
この引数を省略した場合は、extconf.rb があるディレクトリが使われます。

extconf.rb は普通このメソッドの呼び出しで終ります。

== Constants

--- CONFIG

[[m:Config::MAKEFILE_CONFIG]] と同じです。

--- CFLAGS

C コンパイラに渡されるコマンドラインオプションです。
この値は Makefile にも反映されます。

--- LINK

リンカを起動するときのコマンドラインのフォーマットです。
[[m:Kernel#try_link]] などが使用します。

--- CPP

プリプロセッサを起動するときのコマンドラインのフォーマットです。
[[m:Kernel#try_cpp]] などが使用します。

== Special Variables

#@# --- $config_cache
#@#     この変数は obsolete です。現在使用されていません。
--- $srcdir

Ruby インタプリタを make したときのソースディレクトリです。

--- $libdir

Ruby のライブラリを置くディレクトリです。
通常は "/usr/local/lib/ruby/バージョン" です。

--- $archdir

マシン固有のライブラリを置くディレクトリです。
通常は "/usr/local/lib/ruby/バージョン/arch" です。

--- $sitelibdir

サイト固有のライブラリを置くディレクトリです。
通常は "/usr/local/lib/ruby/site_ruby/バージョン" です。

--- $sitearchdir

サイト固有でかつマシン固有のライブラリを置くディレクトリです。
通常は "/usr/local/lib/ruby/site_ruby/バージョン/arch" です。

--- $hdrdir

Ruby のヘッダファイル ruby.h が存在するディレクトリです。
通常は [[m:$archdir]] と同じで、"/usr/local/lib/ruby/バージョン/arch" です。

--- $topdir

拡張ライブラリを make するためのヘッダファイル、
ライブラリ等が存在するディレクトリです。
通常は [[m:$archdir]] と同じで、"/usr/local/lib/ruby/バージョン/arch" です。

--- $defs

拡張ライブラリをコンパイルするときのマクロ定義を指定する配列です。

この変数の値は、例えば

  ["-DHAVE_FUNC", "-DHAVE_HEADER_H"]

のような形式の配列です。

[[m:Kernel#have_func]] または [[m:Kernel#have_header]]
を呼び出すと、その検査結果が $defs に追加されます。

[[m:Kernel#create_header]]
はこの変数の値を参照してヘッダファイルを生成します。

--- $libs

拡張ライブラリをリンクするときに
一緒にリンクされるライブラリを指定する文字列です。

この変数の値は、例えば

  "-lfoo -lbar"

のような形式の文字列です。

[[m:mkmf#have_library]] または [[m:mkmf#find_library]]
を呼び出すと、その検査結果が
間に空白をはさみつつ $libs に連結されます。

--- $CFLAGS

拡張ライブラリをコンパイルするときの C コンパイラのオプションや、
ヘッダファイルのディレクトリを指定する文字列です。

[[m:Kernel#dir_config]] の検査が成功すると、
この変数の値に " -Idir" が追加されます。

--- $LDFLAGS

拡張ライブラリをリンクするときのリンカのオプション、
ライブラリファイルのディレクトリを指定する文字列です。

[[m:mkmf#find_library]] または [[m:mkmf#dir_config]]
の検査が成功すると、$LDFLAGS の値に "-Ldir" を追加します。

#@# おそらくユーザに解放されていない変数
#@# --- $LOCAL_LIBS
#@#     ライブラリを指定する文字列です。
#@# 
#@# --- $local_flags
#@#     リンカオプションを指定する文字列です。

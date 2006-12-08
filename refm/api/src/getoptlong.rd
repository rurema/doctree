getoptlong は、GNU の getopt_long() とまったく同じ方式でコマンド
行オプションの解析を行う Ruby のライブラリです。

Author: 笠原 基之 (m-kasahr@sra.co.jp)

Copyright 1998, 1999  Motoyuki Kasahara

You may redistribute it and/or modify it under the same license
terms as Ruby.

#@#はじめに
#@#========
#@#Ruby と同一の条項に従って本プログラムを再頒布または変更することができます。
#@#
#@#このプログラムは有用とは思いますが、頒布にあたっては、市場性及び特定目
#@#的適合性についての暗黙の保証を含めて、いかなる保証も行ないません。詳細
#@#については GNU General Public License をお読みください。


=== GNU getopt_long() とは?

GNU geopt_long() は、コマンド行オプションの解析を行う C の関数です。多
くの GNU ソフトウェアがこの関数を使用しています。GNU geopt_long() そし
て getoptlong には、以下のような特徴があります。

 * 伝統的な一文字オプションに加えて、長いオプションに対応しています。長
   いオプションは `-' の代わりに `--' で始まります (例: `--version')。
 * 長いオプションは、一意に定まる限り後方を省略することができます
   (例: `--version' は、`--ver' と略すことができます。ただし、他のオプ
   ション名が `--ver' で始まらない場合に限ります)。
 * 特殊な引数 `--' によって、オプションの解析を強制的に終了します。


=== 順序形式 (Ordering)

GNU getopt_long() および geoptlong.rb には、`REQUIRE_ORDER',
`PERMUTE', `RETURN_IN_ORDER' という、3 つの「順序形式 (ORDERING)」が用
意されています。それぞれの処理形式は、非オプション引数についての扱い方
が異なります。

 * REQUIRE_ORDER: 
  非オプション引数の後に来たオプションは、オプションとして認識しません。
  最初に非オプション引数が現れた時点で、オプションの解析処理を中止します。

 * PERMUTE: 
   コマンド行引数の内容を、走査した順に入れ替え、最終的にはすべての非オプ
   ションを末尾に寄せます。この方式では、オプションはどの順序で書いても良
   いことになります。これは、たとえプログラム側でそうなることを期待しなく
   ても、そうなります。この方式がデフォルトです。

 * RETURN_IN_ORDER: 
   オプションと他の非オプション引数はどんな順序で並んでも良いが、お互いの
   順序は保持したままにしたいというプログラムのための形式です。


=== POSIXLY_CORRECT

環境変数 POSIXLY_CORRECT が定義されていると、処理形式に `PERMUTE' を
選択していても、REQUIRE_ORDER 形式で処理されます。


=== 使い方

あなたの作ったプログラムのヘルプメッセージが、次のようになっているもの
とします。

    Usage: command [option...]
    Options:
      -m SIZE  --max-size SIZE    Set maximum size
      -q  --quiet  --silence      Suppress all warnings
      --help                      Output this help, then exit
      --version                   Output version number, then exit

まず、`getoptlong.rb' を Ruby で書かれたあなたのプログラムに取り込みま
す。

    require 'getoptlong.rb'

[[lib:getopts]] や [[lib:parsearg]] とは異なり、getoptlong はモジュール
ではなくクラスを提供します。クラスの名前は GetoptLong です。
[[c:GetoptLong]] クラスのオブジェクトを生成します。

    parser = GetoptLong.new

そして、set_optins メソッドを呼び出し、この parser にオプションを
セットします。

    parser.set_options(
        ['--max-size',           '-m', GetoptLong::REQUIRED_ARGUMENT],
        ['--quiet', '--silence', '-q', GetoptLong::NO_ARGUMENT],
        ['--help',                     GetoptLong::NO_ARGUMENT],
        ['--version',                  GetoptLong::NO_ARGUMENT])

getopts モジュールが行っているように、与えられたオプションを 
`$OPT_...' という定数に入れたいときは、次のコードをあなたのプログラム
に足して下さい。

    begin
       parser.each_option do |name, arg|
          eval "$OPT_#{name.sub(/^--/, '').gsub(/-/, '_').upcase} = '#{arg}'"
       end
    rescue
       exit(1)
    end

each_option メソッドは、常にオプション名を「正式名 (CANONICAL NAME)」
の形で返してきます。「正式名」とは、`set_options' へ渡した個々の引数に
おいて、一番左にあるオプション名のことです。たとえば、`--quiet' は、
`-q' と `--silence' の正式名になります。したがって、この節の例で定義さ
れる可能性があるのは、`$OPT_MAX_SIZE', `$OPT_QUIET', `$OPT_HELP',
`$OPT_VERSION' です。後方が省略されたオプションが与えられたときも、対
応する正式名に変換されます。


=== 順序形式の設定

先に記したように、順序形式 (ORDEING) のデフォルトは `PERMUTE' です。
順序形式を変えるには `ordering=' メソッドを用います。

    parser.ordering = GetoptLong::REQUIRE_ORDER


=== エラー

オプションの処理中は、次のような理由でエラーが発生します。

 * 与えれたオプションは名前の後方が省略されていると思われるが、一意に決
   まらない。
 * 知らないオプションが与えられた。
 * 与えられたオプションには引数が欠けている。
 * 与えられたオプションには引数が伴っているが、そのオプションは引数をと
   らない。

エラーが発生した場合、「静粛 (quiet)」フラグが設定されていなければ、標
準エラー出力にエラーメッセージが出力され、例外が発生します。例外には、
エラーメッセージも渡されます。

一旦エラーが起きてしまうと、続きのオプションを得ようとする試みはすべて
失敗します。`GetoptLong' には、エラーを解除する方法はありません。言い
換えると、エラーが起きたら、オプションの処理は諦めなければなりません。


=== 静粛フラグ

エラーが発生すると、デフォルトではエラーメッセージが標準エラー出力に出
力されます。「静粛 (quiet)」フラグを設定すると、エラーメッセージの出力
は抑制されます。

    parser.quiet = TRUE


= class GetoptLong < Object

== Class Methods
--- new
--- new(option...)

GetoptLong のオブジェクトを生成します。option が与えられる
たときは、それを set_options メソッドに渡します。

== Instance Methods

--- each {|optname, optarg|...}
--- each_option {|optname, optarg|...}
get メソッドのイテレータ版です。オプションとその引数の取得を
繰り返し行います。詳しくは get の説明を参照して下さい。

--- get
--- get_option
ARGV から、次のオプションの名前と、もしあればその引数の組を取
得します。メソッドは 2 つの値を返し、1 つ目の値がオプション名
(例: --max-size) で、2 つ目がオプションの引数 (例: 20K) で
す。get の通常の呼び出し方は次の通りです。

    optname, optarg = option_parser.get

get と get_option は常にオプション名を正式名 (canonical
name) で返します。与えられたオプションが引数を取らないときは、
空の文字列 ('') が optarg にセットされます。オプションが
ARGV に残っていないときは、optname, optarg ともに nil に
セットされます。メソッドから戻る際に、取得したオプションと引数
は自動的に ARGV から取り除かれます。

与えられたコマンド行引数があなたのプログラムのオプションの設定
に合わない場合は、エラーとなって、以下のいずれかの例外が発生し
ます。

: GetoptLong::AmbigousOption
    与えられたオプションは名前の後方が省略されていると思われる
    が、一意に決まらない。

: GetoptLong::InvalidOption
    知らないオプションが与えられた。

: GetoptLong::MissingArgument
    与えられたオプションには引数が欠けている。

: GetoptLong::NeedlessArgument
    与えられたオプションは引数を伴っているが、そのオプションは
    引数をとらない。

加えて、静粛 (quiet) フラグが有効になっていない限り、エラーメッ
セージを標準エラー出力に出力します。

--- error
--- error?
現在のエラーの型を返します。エラーが発生していなければ、nil
を返します。

--- error_message
現在のエラーのエラーメッセージを返します。エラーが発生していな
ければ、nil を返します。

--- ordering=(ordering)
順序形式 (ordering) を設定します。引数 ordering は、
PERMUTE, REQUIRE_ORDER, RETURN_IN_ORDER のいずれかでなく
てはなりません。それ以外の値を代入しようとすると、例外
ArgumentError が発生します。

順序形式を設定できるのは、get, get_option, each,
each_option メソッドを呼び出す前だけです。これらのメソッドを
呼び出した後で順序形式を設定しようとすると、RuntimeError 例
外が発生します。

環境変数 POSIXLY_CORRECT が定義されていると、引数に 
PERMUTE を与えてこのメソッドを呼び出しても、実際のところの順
序形式は REQUIRE_ORDER に設定されます。

環境変数 POSIXLY_CORRECT が定義されていない限り、PERMUTE 
が初期値です。定義されていれば、REQUIRE_ORDER が初期値になり
ます。

ordering を返します。

--- ordering
現在の順序形式を返します。

--- quiet=(flag)
flag が TRUE なら、静粛 (quiet) モードが有効になります。
静粛モードが有効になっていると、レシーバのオブジェクトは、
get, get_option, each, each_option メソッドでエラーが
発生しても、エラーメッセージを出力しません。初期値は、FALSE
になっています。

flag を返します。

--- quiet
--- quiet?
静粛モードが有効であれば、TRUE が返ります。そうでなければ、
FALSE が返ります。

--- set_options(option...)
あなたのプログラムで、認識させたいオプションをセットします。
個々の option は、オプション名と引数のフラグからなる配列でな
ければいけません。

    parser.set_options(['-d', '--debug', GetoptLong::NO_ARGUMENT],
                       ['--version',     GetoptLong::NO_ARGUMENT],
                       ['--help',        GetoptLong::NO_ARGUMENT])

配列中のオプション名は、一文字オプション (例: -d) か長いオプ
ション (例: --debug) を表した文字列のいずれかでなければなり
ません。配列の中の一番左端のオプション名が、オプションの正式名
になります。配列中の引数のフラグは、NO_ARGUMENT, REQUIRE_ARGUMENT,
OPTIONAL_ARGUMENT のいずれかでなくてはなりません。

オプション名と引数のフラグの順番に決まりはないので、次のような
形式でも構いません。

    parser.set_options([GetoptLong::NO_ARGUMENT, '-d', '--debug'],
                       [GetoptLong::NO_ARGUMENT, '--version'],
                       [GetoptLong::NO_ARGUMENT, '--help'])

不正な引数が set_options メソッドに与えられると、例外
ArgumentError が発生します。

オプションを設定できるのは、get, get_option, each,
each_option メソッドを呼び出す前だけです。これらのメソッドを
呼び出した後でオプションを設定しようとすると、RuntimeError
例外が発生します。

メソッドのレシーバであるオブジェクトを返します。

--- terminate
オプションの処理を、強制的に終了させます。ただし、エラーが起き
ている状態でこのメソッドを起動しても、終了させることはできませ
ん。エラーが起きている状態でこのメソッドを起動すると、
RuntimeError 例外が発生します。すでにオプションの処理が終了
しているときは、このメソッドは何も行いません。

メソッドのレシーバであるオブジェクトを返します。

--- terminated?
エラーが起きずにオプションの処理が終了しているときは TRUE が
返ります。それ以外のときは、FALSE が返ります。

== Constants
--- PERMUTE
--- REQUIRE_ORDER
--- RETURN_IN_ORDER
順序形式を表しています。

--- NO_ARGUMENT
--- REQUIRED_ARGUMENT
--- OPTIONAL_ARGUMENT
オプションへの引数のフラグです。

= class GetoptLong::Error < StandardError

#@if (version < '1.9.0')
= class GetoptLong::AmbigousOption < GetoptLong::Error
#@else
= class GetoptLong::AmbiguousOption < GetoptLong::Error
#@end
与えられたオプションは名前の後方が省略されていると思われる
が、一意に決まらない。

= class GetoptLong::InvalidOption < GetoptLong::Error
知らないオプションが与えられた。

= class GetoptLong::MissingArgument < GetoptLong::Error
与えられたオプションには引数が欠けている。

= class GetoptLong::NeedlessArgument < GetoptLong::Error
与えられたオプションは引数を伴っているが、そのオプションは
引数をとらない。

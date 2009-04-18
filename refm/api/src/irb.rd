#@# Author: Keiju ISHITSUKA

irb は Interactive Ruby の略です。
irb を使うと、Ruby の式を標準入力から簡単に入力・実行することができます。

=== irb の使い方

Ruby さえ知っていれば irb を使うのは簡単です。
irb コマンドを実行すると、以下のようなプロンプトが表れます。

  $ irb
  irb(main):001:0>

あとは Ruby の式を入力するだけで、その式が実行され、結果が表示されます。

  irb(main):001:0> 1+2
  3
  irb(main):002:0> class Foo
  irb(main):003:1>   def foo
  irb(main):004:2>     print 1
  irb(main):005:2>   end
  irb(main):006:1> end
  nil
  irb(main):007:0> 

また irb コマンドは [[lib:readline]] ライブラリにも対応しています。
readline ライブラリがインストールされている時には
自動的にコマンドライン編集や履歴の機能が使えるようになります。

=== irb のコマンドラインオプション

  irb [options] file_name opts
  options:
  -f                ~/.irbrc を読み込まない
  -m                bc モード (分数と行列の計算ができる)
  -d                $DEBUG を true にする (ruby -d と同じ)
  -Kc               ruby -Kc と同じ
  -r library        ruby -r と同じ
#@since 1.8.2
  -I                ruby -I と同じ
#@end
  --verbose         これから実行する行を表示する (デフォルト)
  --noverbose       これから実行する行を表示しない
  --echo            実行結果を表示する (デフォルト)
  --noecho          実行結果を表示しない
  --inspect         結果出力にinspectを用いる (bc モード以外ではデフォルト)
  --noinspect       結果出力にinspectを用いない
  --readline        readlineライブラリを利用する
  --noreadline      readlineライブラリを利用しない。デフォルトでは
                    inf-ruby-mode 以外で readline ライブラリを利用する。
  --prompt prompt-mode
  --prompt-mode prompt-mode
                    プロンプトモードを切り替える。現在定義されているプ
                    ロンプトモードは、default/simple/xmp/inf-ruby。
  --inf-ruby-mode   emacsのinf-ruby-mode 用のプロンプト表示を行なう。
                    特に指定がない限り readline ライブラリは使わなくなる。
  --simple-prompt
                    非常にシンプルなプロンプトを用いるモード。
  --noprompt        プロンプトを表示しない。
  --tracer          コマンド実行時にトレースする。
  --back-trace-limit n
                    バックトレース表示をバックトレースの頭から n、
                    うしろから n だけ行なう。デフォルト値は 16。
  --irb_debug n     irb のデバッグレベルを n に設定する
                    (ユーザは利用すべきではない)
  -v, --version     irb のバージョンを表示する

=== irb のカスタマイズ

irb コマンドは起動時にホームディレクトリの .irbrc というファイルを読み込みます。
.irbrc は Ruby スクリプトです。ホームディレクトリに .irbrc が存在しない場合は、
カレントディレクトリの .irbrc, irb.rc, _irbrc, $irbrc を順番にロードしようと
試みます。

以下のような (Ruby の) 式を .irbrc に記述すると、
irb コマンドのオプションを指定したのと同じ効果が得られます。

  IRB.conf[:AUTO_INDENT] = false
  IRB.conf[:BACK_TRACE_LIMIT] = 16
  IRB.conf[:DEBUG_LEVEL] = 1
  IRB.conf[:ECHO] = nil
  IRB.conf[:EVAL_HISTORY] = nil
#@since 1.9.1
  IRB.conf[:HISTORY_FILE] = nil
#@end
  IRB.conf[:IGNORE_EOF] = true
  IRB.conf[:IGNORE_SIGINT] = true
  IRB.conf[:INSPECT_MODE] = nil
  IRB.conf[:IRB_NAME] = "irb"
  IRB.conf[:IRB_RC] = nil
  IRB.conf[:MATH_MODE] = false
  IRB.conf[:PROMPT] = {....}
  IRB.conf[:PROMPT_MODE] = :DEFALUT
  IRB.conf[:SINGLE_IRB] = false
#@since 1.9.1
  IRB.conf[:SAVE_HISTORY] = nil
#@end
  IRB.conf[:USE_LOADER] = true
  IRB.conf[:USE_READLINE] = nil
  IRB.conf[:USE_TRACER] = true
  IRB.conf[:VERBOSE] = true

==== プロンプトのカスタマイズ

irb のプロンプトをカスタマイズしたい時は、
まず独自のプロンプトモードを作成し、
それをコマンドラインや .irbrc に指定します。

まず、新しいプロンプトモードを作成するには、
例えば .irbrc で以下のように記述します。

  # 新しいプロンプトモード MY_PROMPT を作成する
  IRB.conf[:PROMPT][:MY_PROMPT] = {
    :PROMPT_I => nil,          # 通常時のプロンプト
    :PROMPT_S => nil,          # 文字列などの継続行のプロンプト
    :PROMPT_C => nil,          # 式が継続している時のプロンプト
    :RETURN => "    ==>%s\n"   # メソッドから戻る時のプロンプト
  }

いま作成した新しいプロンプトモードを使うには、
以下のように irb コマンドに --prompt オプションを指定します。

  $ irb --prompt my-prompt

毎回指定するのが面倒なら、.irbrc に以下の式を記述します。

  # プロンプトモード MY_PROMPT を使う
  IRB.conf[:PROMPT_MODE] = :MY_PROMPT

PROMPT_I, PROMPT_S, PROMPT_C にはフォーマット文字列を指定します。
フォーマット文字列では [[m:Kernel.#printf]] のように
「%」を用いた記法が使えます。
フォーマット文字列で使用可能な記法は以下の通りです。

: %N
    起動しているコマンド名
: %m
    main オブジェクト (self) を to_s した文字列
: %M
    main オブジェクト (self) を inspect した文字列
: %l
    文字列中のタイプを表す (", ', /, ], `]'は%wの中の時)
: %NNi
    インデントのレベルを、NN 桁に右詰めした文字列。
    NN は省略可能。
: %NNn
    行番号を、NN 桁に右詰めした文字列。
    NN は省略可能。
: %%
    文字「%」それ自体

また、RETURN は現在のところ printf と全く同じ形式で指定します。
ただし、将来は仕様が変わる可能性があります。

例えば、デフォルトのプロンプトモードである
「default」プロンプトモードは以下のように設定されています。

  IRB.conf[:PROMPT_MODE][:DEFAULT] = {
    :PROMPT_I => "%N(%m):%03n:%i> ",
    :PROMPT_S => "%N(%m):%03n:%i%l ",
    :PROMPT_C => "%N(%m):%03n:%i* ",
    :RETURN => "%s\n"
  } 

プロンプトモードは :DEFAULT
の他に :NULL, :CLASSIC, :SIMPLE, :XMP が定義されています。

=== サブ irb

irb では、起動時の irb インタプリタとは独立した環境を持つ
「サブ irb」を任意の数だけ起動することができます。
サブ irb は、irb 実行中に「irb」と入力すると起動します。

例えば以下の実行例を見てください。

  irb(main):004:0> x = "OK"          # ローカル変数 x を定義
  => "OK"
  irb(main):005:0> x                 # x を表示
  => "OK"
  irb(main):006:0> irb               # サブ irb を起動
  irb#1(main):001:0> x               # x を表示
  NameError: undefined local variable or method `x' for main:Object
	  from (irb#1):1:in `Kernel#binding'

起動時のインタプリタでローカル変数 x を定義しましたが、
「irb」でサブ irb を起動すると、
ローカル変数 x が見えなくなっています。
これが「独立した環境」の意味です。

=== サブ irb の設定

irb コマンド起動時のインタプリタの設定は
コマンドラインオプションと IRB.conf の値で決まります。
それに対して、サブ irb インタプリタの設定は、
各インタプリタの「conf」オブジェクトの値で決まります。

conf オブジェクトの値を変更するには、
まず以下のようにサブ irb を起動してから conf オブジェクトの
値を一つ一つ変更する方法があります。

  $ irb
  irb(main):001:0> irb                     # サブ irb を起動
  irb#1(main):001:0> conf.prompt_i         # prompt_i の値を確認
  => "%N(%m):%03n:%i> "
  irb#1(main):002:0> conf.prompt_i = ">"   # prompt_i の値を変更
  => ">"
  >                                        # プロンプトが変わった

しかし、サブ irb を起動するたびに設定を入力するのは面倒です。
そこで、IRB.conf[:IRB_RC] を使う方法を紹介します。

IRB.conf[:IRB_RC] に Proc オブジェクトを設定しておくと、
サブ irb が起動されるたびに、その Proc オブジェクトに
IRB::Context オブジェクトを渡して実行します。
これによってサブ irb の設定をまとめて設定することができます。

以下に例を示します。

  $ irb
  irb(main):001:0> IRB.conf[:IRB_RC] = lambda {|conf| conf.prompt_i = "> " }
  => #<Proc:0x00002a95fa3fd8@(irb):2>
  irb(main):002:0> irb
  > 

=== irb の使用例

irb のいろいろな使用例を以下に示します。

  $ irb
  irb(main):001:0> irb                        # サブirbの立ちあげ
  irb#1(main):001:0> jobs                     # サブirbのリスト
  #0->irb on main (#<Thread:0x400fb7e4> : stop)
  #1->irb#1 on main (#<Thread:0x40125d64> : running)
  nil
  irb#1(main):002:0> fg 0                     # jobのスイッチ
  nil
  irb(main):002:0> class Foo;end
  nil
  irb(main):003:0> irb Foo                    # Fooをコンテキストしてirb
                                              # 立ちあげ
  irb#2(Foo):001:0> def foo                   # Foo#fooの定義
  irb#2(Foo):002:1>   print 1
  irb#2(Foo):003:1> end
  nil
  irb#2(Foo):004:0> fg 0                      # jobをスイッチ
  nil
  irb(main):004:0> jobs                       # jobのリスト
  #0->irb on main (#<Thread:0x400fb7e4> : running)
  #1->irb#1 on main (#<Thread:0x40125d64> : stop)
  #2->irb#2 on Foo (#<Thread:0x4011d54c> : stop)
  nil
  irb(main):005:0> Foo.instance_methods       # Foo#fooがちゃんと定義さ
                                              # れている
  ["foo"]
  irb(main):006:0> fg 2                       # jobをスイッチ
  nil
  irb#2(Foo):005:0> def bar                   # Foo#barを定義
  irb#2(Foo):006:1>  print "bar"
  irb#2(Foo):007:1> end
  nil
  irb#2(Foo):010:0>  Foo.instance_methods
  ["bar", "foo"]
  irb#2(Foo):011:0> fg 0                      
  nil
  irb(main):007:0> f = Foo.new
  #<Foo:0x4010af3c>
  irb(main):008:0> irb f                      # Fooのインスタンスでirbを
                                              # 立ちあげる.
  irb#3(#<Foo:0x4010af3c>):001:0> jobs
  #0->irb on main (#<Thread:0x400fb7e4> : stop)
  #1->irb#1 on main (#<Thread:0x40125d64> : stop)
  #2->irb#2 on Foo (#<Thread:0x4011d54c> : stop)
  #3->irb#3 on #<Foo:0x4010af3c> (#<Thread:0x4010a1e0> : running)
  nil
  irb#3(#<Foo:0x4010af3c>):002:0> foo         # f.fooの実行
  nil
  irb#3(#<Foo:0x4010af3c>):003:0> bar         # f.barの実行
  barnil
  irb#3(#<Foo:0x4010af3c>):004:0> kill 1, 2, 3# jobのkill
  nil
  irb(main):009:0> jobs
  #0->irb on main (#<Thread:0x400fb7e4> : running)
  nil
  irb(main):010:0> exit                       # 終了
  $

=== 使用上の制限

irbは, 評価できる時点(式が閉じた時点)での逐次実行を行ないます. 
したがって, rubyを直接使った時と若干異なる動作を行なう場合があります.

現在明らかになっている問題点を説明します.

==== ローカル変数の宣言

Ruby では以下のプログラムはエラーになります.

  eval "foo = 0"
  p foo    # -:2: undefined local variable or method `foo' for #<Object:0x40283118> (NameError)

ところが irb を用いると、以下のように、エラーになりません。

  >> eval "foo = 0"
  => 0
  >> foo
  => 0

この違いは、Ruby と irb のプログラムのコンパイル方法の差に起因します。
Ruby は最初にスクリプト全体をコンパイルしてローカル変数を決定します。
それに対し、irb は式が完結して実行可能になった時点で順番にコンパイルします。
上記の例では、

  evel "foo = 0" 

が入力された時点でまずその式をコンパイル・実行します。
この時点で変数 foo が定義されるため、
次の式を入力する時点ですでに変数 foo が定義されているのです。

この Ruby と irb の動作の違いをなくしたい場合は、
irb では以下のように式を begin 〜 end でくくって入力してください。

  >> begin
  ?>   eval "foo = 0"
  >>   foo
  >> end
  NameError: undefined local variable or method `foo' for #<Object:0x4013d0f0>
  (irb):3
  (irb_local_binding):1:in `eval'

==== ヒアドキュメント

現在のところヒアドキュメントの実装は不完全です。

==== シンボル

irb はシンボルであるかどうかの判断を間違えることがあります。
具体的には、式が完了しているのに継続行と見なすことがあります。



= class IrbCommands

このクラスは irb のコマンドをまとめるためのプレースホルダです。
実際には IrbCommands というクラスは定義されていません。
このクラスのドキュメントに記述されているメソッドは、
irb のプロンプトでレシーバなしで使うことができます。

irb のコマンドは、
簡単な名前と頭に「irb_」をつけた名前との両方が定義されています。
これは、簡単な名前がオーバーライドされた場合にも
irb のコマンドが実行できるようにするためです。

== Methods

--- exit
--- quit
--- irb_exit        
#@todo

irb を終了します。
サブ irb で呼び出した場合は、そのサブ irb だけを終了します。

--- conf
--- irb_context
#@todo

irb の現在の設定です。[[c:IRB::Context]] オブジェクトです。
このメソッドで得た IRB::Context オブジェクトに対してメソッドを
呼び出すことで、現在稼働中の irb インタプリタの設定を表示・変更できます。

--- cws([obj])
--- chws([obj])
--- irb_cws([obj])
--- irb_chws([obj])
--- irb_change_workspace([obj])
#@todo

irb の self を obj に変更します。
obj が省略されたときは、
irb を起動したときの main オブジェクトを self にします。

--- pushws([obj])
--- irb_pushws([obj])
--- irb_push_workspace([obj])
#@todo

UNIX シェルコマンドの pushd と同じです。

--- popws
--- irb_popws
--- irb_pop_workspace
#@todo

UNIX シェルコマンドの popd と同じです。

--- irb([obj])
#@todo

新しいサブ irb インタプリタを起動します。
オブジェクト obj が指定された時はその obj を self にします。

--- jobs
--- irb_jobs
#@todo

サブ irb のリストを返します。

--- fg(n)
--- irb_fg(n)
#@todo

n で指定したサブ irb に移動します。
n は以下のいずれかの値で指定します。

  * irb インタプリタ番号
  * irb オブジェクト
  * スレッド ID
  * 各インタプリタの self (「irb(obj)」で起動した時の obj)

--- kill(n)
--- irb_kill(n)
#@todo

n で指定したサブ irb を停止します。
n は以下のいずれかの値で指定します。

  * irb インタプリタ番号
  * irb オブジェクト
  * スレッド ID
  * 各インタプリタの self (「irb(obj)」で起動した時の obj)

--- souce(path)
--- irb_source(path)
#@todo

現在の irb インタプリタ上で、
Ruby スクリプト path を評価します。

source という名前は UNIX シェルの source コマンドに由来します。

--- irb_load(path, prev)
#@todo

ファイル path を Ruby スクリプトとみなし、
現在の irb インタプリタ上で実行します。
Ruby の load の irb 版です。

--- _  
#@todo

直前の式の実行結果です。

例：

  $ irb
  irb(main):001:0> 10
  => 10
  irb(main):002:0> 2**32
  => 4294967296
  irb(main):003:0> _
  => 4294967296
  irb(main):004:0> _ - 2**31
  => 2147483648
  irb(main):005:0> 

--- __ 
#@todo

実行結果の履歴です。
__[lineno] で、lineno 行で実行した結果を得られます。
lineno が負の時は、最新の結果から -lineno 行だけ前の
結果を得られます。

この変数はデフォルトでは使えません。
この変数を使用するには、あらかじめ .irbrc などで
conf.eval_history の値を指定しておかなければいけません。

例：

  $ irb
  irb(main):001:0> conf.eval_history = 100
  => 100
  irb(main):002:0> 1 + 2
  => 3
  irb(main):003:0> 'hoge' + 'foo'
  => "hogefoo"
  irb(main):004:0> __[2]
  => 3
  irb(main):005:0> __[3]
  => "hogefoo"
  irb(main):006:0> __[-1]
  => "hogefoo"
  irb(main):007:0> 

#@since 1.9.1
#@# 1.8.2 に入っていない理由は ((<ruby-dev:25595>)) を参照してください
=== 履歴の保存

さらに、.irbrc で以下のように
conf.save_history の値を指定しておくと、
実行結果の履歴がファイルに保存されます。

  IRB.conf[:SAVE_HISTORY] = 100

履歴ファイルの名前はデフォルトでは ~/.irb_history です。
履歴ファイルの名前は IRB.conf[:HISTORY_FILE] で指定できます。
#@end



= class IRB::Context

== Methods

--- eval_history=(n)
#@todo

実行結果のヒストリ機能の設定.
n は整数か nil で n > 0 であればその数だけヒストリにためる。
n = 0の時は無制限に記憶する.
n = nil だとヒストリ機能はやめる (デフォルト). 

--- back_trace_limit
#@todo

バックトレース表示をバックトレースの頭から n,
後ろから n だけ行なう.
デフォルトは 16.
    
--- debug_level=(n)
#@todo

irb のデバッグレベルの設定

--- ignore_eof
--- ignore_eof=(bool)
#@todo

Ctrl-D が入力された時の動作を設定する.
true の時は Ctrl-D を無視する.
false の時は irb を終了する. 

--- ignore_sigint
--- ignore_sigint=(bool)
#@todo

Ctrl-C が入力された時の動作を設定します。
false 時は irb を終了します。
true の時の動作は以下のようになる.

: 入力中
    これまで入力したものをキャンセルしトップレベルに戻る. 
: 実行中
    実行を中止する.

--- inf_ruby_mode
--- inf_ruby_mode=(bool)
#@todo

inf-ruby-mode 用のプロンプト表示を行なうかどうかを表します。
デフォルト値は false です。

--- inspect_mode=(val)
#@todo

インスペクトモードを設定する.

: true
    inspect の結果を表示する
: false
    to_s の結果を表示する
: nil
    irb が通常モードであれば inspect mode、
    math モードなら non inspect mode

--- math_mode
#@todo

分数と行列の計算ができる bc モードかどうかを表します。

--- use_loader
--- use_loader=(bool)
#@todo

load または require 時に
irb のファイル読み込み機能を使うかどうかを示します。
デフォルト値は false です。

use_loader の値は irb 全体に反映されます。

--- prompt_c
#@todo

if の直後など, 行が継続している時のプロンプトを
表現するフォーマット文字列を返します。

--- prompt_i
#@todo

通常のプロンプトを表現するフォーマット文字列を返します。

--- prompt_s
#@todo

文字列中のプロンプトを表現するフォーマット文字列を返します。

--- rc
#@todo

~/.irbrc を読み込んでいたら true を返します。
読み込んでいなければ false を返します。

--- use_prompt
--- use_prompt=(bool)
#@todo

プロンプトを表示するかどうかを指定します。
use_prompt の値が true ならプロンプトを表示し、
false ならプロンプトを表示しません。

デフォルト値は true です。

--- use_readline=(val)
#@todo

[[lib:readline]] を使うかどうかを指定します。
val の値によって、このメソッドの効果は以下のように分かれます。

: true
    readline ライブラリを使う
: false
    readline ライブラリを使わない
: nil
    inf-ruby-mode 以外で readline ライブラリを利用しようとする (デフォルト)

#@#--- verbose=(bool)
#@#
#@#irbからいろいろなメッセージを出力するか
#@#

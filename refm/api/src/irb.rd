#@# Author: Keiju ISHITSUKA

category Development

require e2mmap
require irb/init
require irb/context
require irb/extend-command
require irb/ruby-lex
require irb/input-method
require irb/locale
#@# IRB.conf[:VERSION] を設定していない場合のみ。
require irb/version

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
#@since 1.9.2
  -w                ruby -w と同じ
  -W[level=2]       ruby -W と同じ
#@end
#@until 1.9.1
  -Kc               ruby -Kc と同じ
#@end
  -r library        ruby -r と同じ
#@since 1.8.2
  -I                ruby -I と同じ
#@end
#@since 1.9.1
  -U                ruby -U と同じ
  -E enc            ruby -E と同じ
#@end
  --verbose         これから実行する行を表示する
  --noverbose       これから実行する行を表示しない (デフォルト)
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
  --sample-book-mode
  --simple-prompt
                    非常にシンプルなプロンプトを用いるモード。
  --noprompt        プロンプトを表示しない。
  --tracer          コマンド実行時にトレースする。
  --back-trace-limit n
                    バックトレース表示をバックトレースの頭から n、
                    うしろから n だけ行なう。デフォルト値は 16。
  --context-mode n  新しいワークスペースを作成した時に関連する Binding
                    オブジェクトの作成方法を 0 から 3 で設定する。
                    (IRB::Context 参照)
  --single-irb      irb 中で self を実行して得られるオブジェクトをサブ irb と共
                    有する
  --irb_debug n     irb のデバッグレベルを n に設定する
                    (ユーザは利用すべきではない)
  -v, --version     irb のバージョンを表示する
  -h, --help        irb のヘルプを表示する
#@since 1.9.1
  --                以降のコマンドライン引数をオプションとして扱わない
#@end

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
  IRB.conf[:HISTORY_FILE] = nil
  IRB.conf[:IGNORE_EOF] = true
  IRB.conf[:IGNORE_SIGINT] = true
  IRB.conf[:INSPECT_MODE] = nil
  IRB.conf[:IRB_NAME] = "irb"
  IRB.conf[:IRB_RC] = nil
  IRB.conf[:MATH_MODE] = false
  IRB.conf[:PROMPT] = {....}
  IRB.conf[:PROMPT_MODE] = :DEFAULT
  IRB.conf[:SINGLE_IRB] = false
  IRB.conf[:SAVE_HISTORY] = nil
  IRB.conf[:USE_LOADER] = true
  IRB.conf[:USE_READLINE] = nil
  IRB.conf[:USE_TRACER] = true
  IRB.conf[:VERBOSE] = true

それぞれの設定値の詳細については、[[c:IRB::Context]] を参照してください。

====[a:customize_prompt] プロンプトのカスタマイズ

irb のプロンプトをカスタマイズしたい時は、
まず独自のプロンプトモードを作成し、
それをコマンドラインや .irbrc に指定します。

まず、新しいプロンプトモードを作成するには、
例えば .irbrc で以下のように記述します。

  # 新しいプロンプトモード MY_PROMPT を作成する
  IRB.conf[:PROMPT][:MY_PROMPT] = {
    :PROMPT_I => nil,          # 通常時のプロンプト
    :PROMPT_N => nil,          # 継続行のプロンプト
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
    起動しているコマンド名([[m:IRB::Context#irb_name]])
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

===[a:configure_sub_irb] サブ irb の設定

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

=== irb で使用可能なコマンド一覧

この一覧に記述されているコマンドは、irb のプロンプトでレシーバなしで使
うことができます。

irb のコマンドは、簡単な名前と頭に「irb_」をつけた名前との両方が定義さ
れています。これは、簡単な名前がオーバーライドされた場合にもirb のコマ
ンドが実行できるようにするためです。

: exit
: irb_exit
: quit
: irb_quit

  irb を終了します。
  サブ irb で呼び出した場合は、そのサブ irb だけを終了します。

#@# ret は使用されていないようなので、削除しました。

: conf
: context
: irb_context

  irb の現在の設定です。[[c:IRB::Context]] オブジェクトです。
  このメソッドで得た IRB::Context オブジェクトに対してメソッドを
  呼び出すことで、現在稼働中の irb インタプリタの設定を表示・変更できます。

: cwws
: pwws
: irb_cwws
: irb_pwws
: irb_print_working_workspace
: irb_current_working_binding
: irb_print_working_binding
: irb_cwb
: irb_pwb

  irb の self を返します。

: cws(*obj)
: chws(*obj)
: irb_cws(*obj)
: irb_chws(*obj)
: irb_change_workspace(*obj)
: cb(*obj)
: irb_cb(*obj)
: irb_change_binding(*obj)

  irb の self を obj に変更します。
  obj が省略されたときは、
  irb を起動したときの main オブジェクトを self にします。

: workspaces
: irb_workspaces
: irb_bindings
: bindings

  現在のワークスペースの一覧を返します。

: pushws(*obj)
: irb_pushws(*obj)
: irb_push_workspace(*obj)
: irb_push_binding(*obj)
: irb_pushb(*obj)
: pushb(*obj)

  UNIX シェルコマンドの pushd と同じです。

: popws
: irb_popws
: irb_pop_workspace
: irb_pop_binding
: irb_popb
: popb

  UNIX シェルコマンドの popd と同じです。

: irb
: irb(obj)

  新しいサブ irb インタプリタを起動します。
  オブジェクト obj が指定された時はその obj を self にします。

: jobs
: irb_jobs

  サブ irb のリストを返します。

: fg(n)
: irb_fg(n)

  n で指定したサブ irb に移動します。
  n は以下のいずれかの値で指定します。

//emlist{
  * irb インタプリタ番号
  * irb オブジェクト
  * スレッド ID
  * 各インタプリタの self (「irb(obj)」で起動した時の obj)
//}

: kill(n)
: irb_kill(n)

  n で指定したサブ irb を停止します。
  n は以下のいずれかの値で指定します。

//emlist{
  * irb インタプリタ番号
  * irb オブジェクト
  * スレッド ID
  * 各インタプリタの self (「irb(obj)」で起動した時の obj)
//}

: source(path)
: irb_source(path)

  現在の irb インタプリタ上で、
  Ruby スクリプト path を評価します。

  path の内容を irb で一行ずつタイプしたかのように、irb 上で一行ずつ評
  価されます。[[m:$"]] は更新されず、何度でも実行し直す事ができます。

  source という名前は UNIX シェルの source コマンドに由来します。

#@since 1.9.1
: irb_load(path, prev = nil)
#@else
: irb_load(path, prev)
#@end

  Ruby の load の irb 版です。
  ファイル path を Ruby スクリプトとみなし、
  現在の irb インタプリタ上で実行します。
  ただし、prev に true を指定した場合は実行は内部的に生成される無名モジュー
  ル上で行われ、グローバルな名前空間を汚染しません。

  [[m:Kernel.#load]] と異なり、path の内容を irb で一行ずつタイプしたか
  のように、irb 上で一行ずつ評価されます。

: irb_require(path)

  Ruby の require の irb 版です。
  ファイル path を現在の irb インタプリタ上で実行します。

  path に Ruby スクリプトを指定した場合は、[[m:Kernel.#kernel]] と異な
  り、path の内容を irb で一行ずつタイプしたかのように、irb 上で一行ず
  つ評価されます。require に成功した場合は true を、そうでない場合は
  false を返します。

  拡張ライブラリ(*.so,*.o,*.dll など)を指定した場合は単純に require さ
  れます。

: help(*names)
: irb_help(*names)

  RI から Ruby のドキュメントを参照します。

//emlist{
  irb(main):001:0> help String#match
  ...
//}

#@since 1.9.2
  names を指定しなかった場合は、RI を対話的なモードで起動します。メソッ
  ド名などを入力する事でドキュメントの検索が行えます。入力のタブ補完を
  する事ができます。また、空行を入力する事で irb のプロンプトに戻る事が
  できます。

//emlist{
  irb(main):001:0> help

  Enter the method name you want to look up.
  You can use tab to autocomplete.
  Enter a blank line to exit.

  >> String#match
  String#match
  
  (from ruby core)
  ------------------------------------------------------------------------------
    str.match(pattern)        -> matchdata or nil
    str.match(pattern, pos)   -> matchdata or nil
  ...
//}
#@end

#@until 1.9.1
==== コマンド実行時の注意

以下のコマンドは引数を指定せずに実行した場合にはエラーが発生します。

 * cwws
 * cws
 * workspaces
 * irb
 * irb_load

また、help コマンドは 1.8 系では動作しないバグがあります。
#@end

=== システム変数

: _

  直前の式の実行結果です。

  例：

//emlist{
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
//}

: __

  実行結果の履歴です。
  __[lineno] で、lineno 行で実行した結果を得られます。
  lineno が負の時は、最新の結果から -lineno 行だけ前の
  結果を得られます。

  この変数はデフォルトでは使えません。
  この変数を使用するには、あらかじめ .irbrc などで
  conf.eval_history の値を指定しておかなければいけません。

  例：

//emlist{
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
//}

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

  eval "foo = 0"

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

===[a:history] 履歴の保存

さらに、.irbrc で以下のように
conf.save_history の値を指定しておくと、
実行結果の履歴がファイルに保存されます。

  IRB.conf[:SAVE_HISTORY] = 100

履歴ファイルの名前はデフォルトでは ~/.irb_history です。
履歴ファイルの名前は IRB.conf[:HISTORY_FILE] で指定できます。

#@since 1.9.2
===[a:inspect_mode] 実行結果の出力方式

irb のプロンプト中では conf.inspect_mode で、.irbrc 中では
IRB.conf[:INSPECT_MODE] に以下のいずれかの値を設定する事で、結果出力の
方式を変更する事ができます。

: false, :to_s, :raw

  出力結果を to_s したものを表示します。

: true, :p, :inspect

  出力結果を inspect したものを表示します。

: :pp, :pretty_inspect

  出力結果を pretty_inspect したものを表示します。

: :yaml, :YAML

  出力結果を YAML 形式にしたものを表示します。

: :marshal, :Marshal, :MARSHAL, [[c:Marshal]]

  出力結果を [[m:Marshal.#dump]] したものを表示します。

例:

  $ irb
  irb(main):001:0> conf.inspect_mode = :yaml
  irb(main):002:0> :foo # => --- :foo

また、irb の起動時に --inspect オプションを指定する事でも同様の設定を行
えます。

  $ irb --inspect [raw|p|pp|yaml|marshal|...]

上記以外にも独自の出力方式を追加する事ができます。詳しくは
[[m:IRB::Inspector.def_inspector]] を参照してください。
#@end

= module IRB

irb のメインモジュールです。

== Class Methods

--- conf -> Hash

irb の設定をハッシュで返します。

--- version -> String

IRB のバージョンを文字列で返します。

~/.irbrc などの設定ファイル内で IRB.conf[:VERSION] を設定していた場合は
任意のバージョンを返すように設定できます。

--- CurrentContext -> IRB::Context

現在の irb に関する [[c:IRB::Context]] を返します。

--- start(ap_path = nil) -> ()

[[c:IRB]] を初期化して、トップレベルの irb を開始します。

@param ap_path irb コマンドのパスを指定します。

--- irb_at_exit -> ()

at_exit で登録された処理を実行します。

ユーザが直接使用するものではありません。

--- irb_exit(irb, ret) -> object

irb を終了します。ret で指定したオブジェクトを返します。

@param irb 現在の [[c:IRB::Irb]] オブジェクトを指定します。

@param ret 戻り値を指定します。

ユーザが直接使用するものではありません。

--- irb_abort(irb, exception = Abort)

実行中の処理を中断します。必ず例外が発生するため、何も返しません。

@param irb 現在の [[c:IRB::Irb]] オブジェクトを指定します。

@param exception 発生させる例外を指定します。指定しなかった場合は
                 [[c:IRB::Abort]] が発生します。

@raise exception 引数 exception で指定した例外が発生します。

ユーザが直接使用するものではありません。

= class IRB::Irb

irb インタプリタのメインルーチンです。

ユーザが直接使用するものではありません。

= class IRB::Abort < Exception

実行中の処理を中断する時に発生させる例外クラスです。

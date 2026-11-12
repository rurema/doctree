---
type: library
#%# Author: Keiju ISHITSUKA
category: Development
require:
#%until 4.1
  - ripper
#%else
  - prism
#%end
  - reline
  - irb/init
  - irb/context
#%until 3.4
  - irb/extend-command
#%else
  - irb/default_commands
#%end
  - irb/ruby-lex
#%since 3.3
  - irb/statement
#%end
#%since 3.4
  - irb/history
#%end
  - irb/input-method
  - irb/locale
  - irb/color
#%# IRB.conf[:VERSION] を設定していない場合のみ。
  - irb/version
  - irb/easter-egg
#%since 4.1
  - irb/startup_message
#%end
#%since 3.3
  - irb/debug
  - irb/pager
#%end
---
irb は Interactive Ruby の略です。
irb を使うと、Ruby の式を標準入力から簡単に入力・実行できます。

### irb の使い方

Ruby さえ知っていれば irb を使うのは簡単です。
irb コマンドを実行すると、以下のようなプロンプトが表れます。

```console
$ irb
irb(main):001:0>
```

あとは Ruby の式を入力するだけで、その式が実行され、結果が表示されます。

```irb
irb(main):001:0> 1+2
3
irb(main):002:0> class Foo
irb(main):003:1>   def foo
irb(main):004:2>     print 1
irb(main):005:2>   end
irb(main):006:1> end
:foo
irb(main):007:0>
```

また irb コマンドは [lib:readline] ライブラリにも対応しています。
readline ライブラリがインストールされている時には自動的にコマンドライン編集や履歴の機能が使えるようになります。

### irb のコマンドラインオプション

```console
irb [options] file_name opts
options:
-f                ~/.irbrc を読み込まない
-d                $DEBUG を true にする (ruby -d と同じ)
-w                ruby -w と同じ
-W[level=2]       ruby -W と同じ
-r library        ruby -r と同じ
-I                ruby -I と同じ
-U                ruby -U と同じ
-E enc            ruby -E と同じ
--verbose         これから実行する行を表示する
--noverbose       これから実行する行を表示しない (デフォルト)
--echo            実行結果を表示する (デフォルト)
--noecho          実行結果を表示しない
--echo-on-assignment
                  代入式の結果を表示する
--noecho-on-assignment
                  代入式の結果を表示しない
--truncate-echo-on-assignment
                  代入式の結果を切り詰めて表示する (デフォルト)
--inspect         結果出力にinspectを用いる
--noinspect       結果出力にinspectを用いない
#%since 3.3
--no-pager        ページャを使わない
#%end
--multiline       マルチラインエディタを利用する
--nomultiline     マルチラインエディタを利用しない
--singleline      シングルラインエディタを利用する
--nosingleline    シングルラインエディタを利用しない
--colorize        色付けを利用する
--nocolorize      色付けを利用しない
#%since 3.1
--autocomplete    オートコンプリートを利用する
--noautocomplete  オートコンプリートを利用しない
#%end
#%since 3.3
--regexp-completor
                  補完に正規表現を利用する
--type-completor  補完に型情報を利用する
#%end
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
#%since 3.2
--script          最初の引数をスクリプトファイルとして扱う (デフォルト)
--noscript        引数をスクリプトファイルとして扱わず、ARGV に残す
#%end
#%since 4.1
--nobanner        起動時のバナーを表示しない
#%end
--tracer          コマンド実行時にトレースする。
--back-trace-limit n
                  バックトレース表示をバックトレースの頭から n、
                  うしろから n だけ行なう。デフォルト値は 16。
--context-mode n  新しいワークスペースを作成した時に関連する Binding
#%until 4.0
                  オブジェクトの作成方法を 0 から 4 で設定する。
#%else
                  オブジェクトの作成方法を 0 から 5 で設定する。
#%end
                  (IRB::Context 参照)
#%since 3.1
--extra-doc-dir dir
                  ドキュメント表示 (doc dialog) で参照する RI ドキュメントの
                  ディレクトリを追加する
#%end
--single-irb      irb 中で self を実行して得られるオブジェクトをサブ irb と共
                  有する
-v, --version     irb のバージョンを表示する
-h, --help        irb のヘルプを表示する
--                以降のコマンドライン引数をオプションとして扱わない
```

### irb のカスタマイズ

#%until 3.4
irb コマンドは起動時に以下のパスを上から順番に探索し、最初に見つかったファイルを読み込みます。
#%else
irb コマンドは起動時に以下のパスを上から順番に探索し、見つかったファイルをすべて読み込みます。
#%end

  - $IRBRC (もし環境変数 IRBRC が設定されていれば)
  - $XDG_CONFIG_HOME/irb/irbrc (もし環境変数 XDG_CONFIG_HOME が設定されていれば)
  - $HOME/.irbrc (もし環境変数 HOME が設定されていれば)
#%until 3.3
  - ./.config/irb/irbrc
#%end
#%version 3.3...3.4
  - $HOME/.config/irb/irbrc (もし環境変数 HOME が設定されていれば)
#%end
#%since 3.4
  - $HOME/.config/irb/irbrc (もし環境変数 HOME が設定されていて、環境変数 XDG_CONFIG_HOME が設定されていなければ)
#%end
  - ./.irbrc
#%until 3.4
  - ./irb.rc
#%else
  - ./irbrc
#%end
  - ./_irbrc
  - ./$irbrc (環境変数ではなく $irbrc というファイル名)

このように実際に読み込まれるファイル名は環境により異なりますが、このマニュアルでは単に「.irbrc」と呼称します。

以下のような (Ruby の) 式を .irbrc に記述すると、
irb コマンドのオプションを指定したのと同じ効果が得られます。

```ruby
IRB.conf[:AUTO_INDENT] = false
IRB.conf[:BACK_TRACE_LIMIT] = 16
IRB.conf[:ECHO] = nil
IRB.conf[:EVAL_HISTORY] = nil
IRB.conf[:HISTORY_FILE] = nil
IRB.conf[:IGNORE_EOF] = true
IRB.conf[:IGNORE_SIGINT] = true
IRB.conf[:INSPECT_MODE] = nil
IRB.conf[:IRB_NAME] = "irb"
IRB.conf[:IRB_RC] = nil
IRB.conf[:PROMPT] = {
  # ...(「プロンプトのカスタマイズ」を参照)
}
IRB.conf[:PROMPT_MODE] = :DEFAULT
IRB.conf[:SINGLE_IRB] = false
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:USE_LOADER] = true
IRB.conf[:USE_READLINE] = nil
IRB.conf[:USE_TRACER] = true
IRB.conf[:VERBOSE] = true
```

それぞれの設定値の詳細については、[c:IRB::Context] を参照してください。

上記以外にも、[m:IRB.conf] には以下のキーがあります。

- **`:AP_NAME`**:

  アプリケーション名です。初期値は `"irb"` です。[m:IRB::Context#ap_name] で参照できます。

- **`:AT_EXIT`**:

  irb の終了時に呼び出す [c:Proc] の配列です。初期値は `[]` です。

#%since 3.2
- **`:COMMAND_ALIASES`**:

  コマンドの別名を `{ 別名のシンボル => コマンド名のシンボル }` の [c:Hash] で指定します。
  `$`(`show_source`)と `@`(`whereami`)が初期値として定義されています。

#%end
#%since 3.3
- **`:COMPLETOR`**:

  補完の方式です。`:regexp`(正規表現)または `:type`(型情報。gem の `repl_type_completor` が必要)を指定します。
#%until 3.4
  環境変数 `IRB_COMPLETOR` を設定していない場合の初期値は `:regexp` です。
#%else
  環境変数 `IRB_COMPLETOR` を設定していない場合の初期値は `nil` で、[lib:repl_type_completor] が使える場合は `:type`、使えない場合は `:regexp` として扱われます。
#%end

#%end
- **`:CONTEXT_MODE`**:

  新しいワークスペースを作成した時の [c:Binding] オブジェクトの作成方法です。
  コマンドラインオプション `--context-mode` と同じ意味で、初期値は `4` です。

#%since 4.0
- **`:COPY_COMMAND`**:

  `copy` コマンドがクリップボードへの書き込みに使うプログラムです。初期値は環境変数 `IRB_COPY_COMMAND` の値です。

#%end
- **`:ECHO_ON_ASSIGNMENT`**:

  代入式の結果の表示方法です。`true`(表示する)・`false`(表示しない)・`:truncate`(切り詰めて表示する)のいずれかを指定します。
  初期値は `nil` で、`:truncate` として扱われます。

#%since 3.1
- **`:EXTRA_DOC_DIRS`**:

  ドキュメント表示 (doc dialog) で参照する RI ドキュメントのディレクトリの配列です。初期値は `[]` です。
  コマンドラインオプション `--extra-doc-dir` で追加できます。

#%end
- **`:IRB_LIB_PATH`**:

  irb のライブラリが置かれているディレクトリのパスです。

- **`:LC_MESSAGES`**:

  メッセージのロケールを表す `IRB::Locale` のオブジェクトです。

- **`:LOAD_MODULES`**:

  起動時に require するライブラリ名の配列です。初期値は `[]` で、`-r` オプションで追加されます。

- **`:MAIN_CONTEXT`**:

  メインの irb の [c:IRB::Context] オブジェクトです。

- **`:MEASURE`**:

  `measure` コマンドによる実行時間の計測が有効かどうかです。初期値は `false` です。

- **`:MEASURE_CALLBACKS`**:

  有効になっている計測のコールバックの配列です。初期値は `[]` です。

- **`:MEASURE_PROC`**:

  `measure` コマンドで選べる計測方法を、名前をキー、[c:Proc] を値として保持する [c:Hash] です。
  初期値として `:TIME` と `:STACKPROF` が定義されています。

- **`:RC`**:

  設定ファイルの読み込みを行うかどうかです。初期値は `true` で、`-f` オプションを指定すると `false` になります。
  [m:IRB::Context#rc?] でも参照できます。

#%since 4.1
- **`:SHOW_BANNER`**:

  起動時のバナーを表示するかどうかです。初期値は `true` で、`--nobanner` オプションを指定すると `false` になります。

#%end
#%since 3.1
- **`:USE_AUTOCOMPLETE`**:

  オートコンプリートを使うかどうかです。初期値は `true` で、`--noautocomplete` オプションを指定すると `false` になります。
#%since 3.2
  環境変数 `IRB_USE_AUTOCOMPLETE` に `false` を設定した場合も、初期値は `false` になります。
#%end

#%end
- **`:USE_COLORIZE`**:

  色付けを使うかどうかです。コマンドラインオプション `--colorize`・`--nocolorize` で指定できます。

#%since 3.3
- **`:USE_PAGER`**:

  長い出力をページャで表示するかどうかです。初期値は `true` で、`--no-pager` オプションを指定すると `false` になります。

#%end
- **`:__MAIN__`**:

  irb の main オブジェクト (self) です。

#### 環境変数 {#environment_variables}

irb は以下の環境変数を参照します。

- **`IRBRC`**:
- **`XDG_CONFIG_HOME`**:

  設定ファイルの探索に使います。前述の「irb のカスタマイズ」を参照してください。

#%since 3.1
- **`NO_COLOR`**:

#%until 3.2
  設定されている場合、`:USE_COLORIZE` の初期値が `false` になります。
#%else
  空でない値が設定されている場合、`:USE_COLORIZE` の初期値が `false` になります。
#%end

#%end
#%since 3.2
- **`IRB_USE_AUTOCOMPLETE`**:

  `false` を設定すると、`:USE_AUTOCOMPLETE` の初期値が `false` になります。

#%end
#%since 3.3
- **`IRB_COMPLETOR`**:

  `:COMPLETOR` の初期値を指定します。`regexp` または `type` を設定します。

#%end
#%since 4.0
- **`IRB_COPY_COMMAND`**:

  `:COPY_COMMAND` の初期値を指定します。

#%end
#%since 3.2
#%since 3.3
- **`VISUAL`**:
#%end
- **`EDITOR`**:

#%until 3.3
  `edit` コマンドが起動するエディタを指定します。
#%else
  `edit` コマンドが起動するエディタを指定します。`VISUAL` が設定されていれば `VISUAL` が優先されます。
#%end

#%end
#%since 3.3
- **`RI_PAGER`**:
- **`PAGER`**:

  長い出力を表示するページャを指定します。`RI_PAGER`・`PAGER` の順に参照します。

#%end
- **`IRB_LANG`**:
- **`LC_MESSAGES`**:
- **`LC_ALL`**:
- **`LANG`**:

  メッセージのロケールの決定に使います。この順に参照し、最初に見つかったものを使います。

#### プロンプトのカスタマイズ {#customize_prompt}

irb のプロンプトをカスタマイズしたい時は、まず独自のプロンプトモードを作成し、それをコマンドラインや .irbrc に指定します。

まず、新しいプロンプトモードを作成するには、例えば .irbrc で以下のように記述します。

```ruby
# 新しいプロンプトモード MY_PROMPT を作成する
IRB.conf[:PROMPT][:MY_PROMPT] = {
  :PROMPT_I => nil,          # 通常時のプロンプト
  :PROMPT_N => nil,          # 継続行のプロンプト
  :PROMPT_S => nil,          # 文字列などの継続行のプロンプト
  :PROMPT_C => nil,          # 式が継続している時のプロンプト
  :RETURN => "    ==>%s\n"   # メソッドから戻る時のプロンプト
}
```

いま作成した新しいプロンプトモードを使うには、以下のように irb コマンドに --prompt オプションを指定します。

```console
$ irb --prompt my-prompt
```

毎回指定するのが面倒なら、.irbrc に以下の式を記述します。

```ruby
# プロンプトモード MY_PROMPT を使う
IRB.conf[:PROMPT_MODE] = :MY_PROMPT
```

PROMPT_I, PROMPT_S, PROMPT_C にはフォーマット文字列を指定します。
フォーマット文字列では [m:Kernel?.printf] のように「%」を用いた記法が使えます。
フォーマット文字列で使用可能な記法は以下の通りです。

- **`%N`**:
    起動しているコマンド名([m:IRB::Context#irb_name])
- **`%m`**:
    main オブジェクト (self) を to_s した文字列
- **`%M`**:
    main オブジェクト (self) を inspect した文字列
- **`%l`**:
    文字列中のタイプを表す (", ', /, ], `]`は%wの中の時)
- **`%NNi`**:
    インデントのレベルを、NN 桁に右詰めした文字列。
    NN は省略可能。
- **`%NNn`**:
    行番号を、NN 桁に右詰めした文字列。
    NN は省略可能。
- **`%%`**:
    文字「%」それ自体

また、RETURN は現在のところ printf と全く同じ形式で指定します。
ただし、将来は仕様が変わる可能性があります。

例えば、デフォルトのプロンプトモードである「default」プロンプトモードは以下のように設定されています。

```ruby
IRB.conf[:PROMPT][:DEFAULT] = {
#%until 3.3
  :PROMPT_I => "%N(%m):%03n:%i> ",
  :PROMPT_S => "%N(%m):%03n:%i%l ",
  :PROMPT_C => "%N(%m):%03n:%i* ",
#%else
  :PROMPT_I => "%N(%m):%03n> ",
  :PROMPT_S => "%N(%m):%03n%l ",
  :PROMPT_C => "%N(%m):%03n* ",
#%end
  :RETURN => "=> %s\n"
}
```

プロンプトモードは :DEFAULT
の他に :NULL, :CLASSIC, :SIMPLE, :XMP が定義されています。

### サブ irb

irb では、起動時の irb インタプリタとは独立した環境を持つ「サブ irb」を任意の数だけ起動できます。
サブ irb は、irb 実行中に「irb」と入力すると起動します。

例えば以下の実行例を見てください。

```irb
irb(main):004:0> x = "OK"          # ローカル変数 x を定義
=> "OK"
irb(main):005:0> x                 # x を表示
=> "OK"
irb(main):006:0> irb               # サブ irb を起動
#%since 3.3
Multi-irb commands are deprecated and will be removed in IRB 2.0.0. Please use workspace commands instead.
If you have any use case for multi-irb, please leave a comment at https://github.com/ruby/irb/issues/653
#%end
irb#1(main):001:0> x               # x を表示
#%since 3.4
(irb#1):1:in '<top (required)>': undefined local variable or method 'x' for main (NameError)
        from <internal:kernel>:168:in 'Kernel#loop'
#%else
(irb#1):1:in `<top (required)>': undefined local variable or method `x' for main (NameError)
        from <internal:kernel>:187:in `loop'
#%end
```

起動時のインタプリタでローカル変数 x を定義しましたが、「irb」でサブ irb を起動すると、ローカル変数 x が見えなくなっています。
これが「独立した環境」の意味です。

#%since 3.3
なお、「irb」コマンドによるサブ irb の起動(multi-irb)は非推奨となっており、将来の IRB 2.0.0 で削除される予定です。
今後は後述の「irb で使用可能なコマンド一覧」にある workspace 関連のコマンド
(`cws`、`pushws` など)の利用が推奨されています。
#%end

### サブ irb の設定 {#configure_sub_irb}

irb コマンド起動時のインタプリタの設定はコマンドラインオプションと IRB.conf の値で決まります。
それに対して、サブ irb インタプリタの設定は、各インタプリタの「conf」オブジェクトの値で決まります。

conf オブジェクトの値を変更するには、まず以下のようにサブ irb を起動してから conf オブジェクトの値を一つ一つ変更する方法があります。

```console
$ irb
irb(main):001:0> irb                     # サブ irb を起動
irb#1(main):001:0> conf.prompt_i         # prompt_i の値を確認
=> "%N(%m):%03n:%i> "
irb#1(main):002:0> conf.prompt_i = ">"   # prompt_i の値を変更
=> ">"
>                                        # プロンプトが変わった
```

しかし、サブ irb を起動するたびに設定を入力するのは面倒です。
そこで、IRB.conf[:IRB_RC] を使う方法を紹介します。

IRB.conf[:IRB_RC] に Proc オブジェクトを設定しておくと、サブ irb が起動されるたびに、その Proc オブジェクトに
IRB::Context オブジェクトを渡して実行します。
これによってサブ irb の設定をまとめて設定できます。

以下に例を示します。

```console
$ irb
irb(main):001:0> IRB.conf[:IRB_RC] = lambda {|conf| conf.prompt_i = "> " }
=> #<Proc:0x00002a95fa3fd8 (irb):2 (lambda)>
irb(main):002:0> irb
>
```

### irb の使用例

irb のいろいろな使用例を以下に示します。

```console
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
```

### irb で使用可能なコマンド一覧

この一覧に記述されているコマンドは、irb のプロンプトでレシーバなしで使うことができます。

irb のコマンドは、簡単な名前と頭に「irb_」をつけた名前との両方が定義されています。これは、簡単な名前がオーバーライドされた場合にもirb のコマンドが実行できるようにするためです。

- **`exit`**:
- **`irb_exit`**:
- **`quit`**:
- **`irb_quit`**:

  irb を終了します。
  サブ irb で呼び出した場合は、そのサブ irb だけを終了します。

#%since 3.4
- **`exit!`**:
- **`irb_exit!`**:

  irb を終了したあと、続けて [m:Kernel?.exit] を呼び出してプロセスを終了します。

#%end
#%# ret は使用されていないようなので、削除しました。

- **`conf`**:
- **`context`**:
- **`irb_context`**:

  irb の現在の設定です。[c:IRB::Context] オブジェクトです。
  このメソッドで得た IRB::Context オブジェクトに対してメソッドを
  呼び出すことで、現在稼働中の irb インタプリタの設定を表示・変更できます。

- **`cwws`**:
- **`pwws`**:
- **`irb_cwws`**:
- **`irb_pwws`**:
- **`irb_print_working_workspace`**:
- **`irb_current_working_binding`**:
- **`irb_print_working_binding`**:
- **`irb_cwb`**:
- **`irb_pwb`**:

  irb の self を返します。

- **`cws(*obj)`**:
- **`chws(*obj)`**:
- **`irb_cws(*obj)`**:
- **`irb_chws(*obj)`**:
- **`irb_change_workspace(*obj)`**:
- **`cb(*obj)`**:
- **`irb_cb(*obj)`**:
- **`irb_change_binding(*obj)`**:

  irb の self を obj に変更します。
  obj が省略されたときは、
  irb を起動したときの main オブジェクトを self にします。

- **`workspaces`**:
- **`irb_workspaces`**:
- **`irb_bindings`**:
- **`bindings`**:

  現在のワークスペースの一覧を返します。

- **`pushws(*obj)`**:
- **`irb_pushws(*obj)`**:
- **`irb_push_workspace(*obj)`**:
- **`irb_push_binding(*obj)`**:
- **`irb_pushb(*obj)`**:
- **`pushb(*obj)`**:

  UNIX シェルコマンドの pushd と同じです。

- **`popws`**:
- **`irb_popws`**:
- **`irb_pop_workspace`**:
- **`irb_pop_binding`**:
- **`irb_popb`**:
- **`popb`**:

  UNIX シェルコマンドの popd と同じです。

- **`irb`**:
- **`irb(obj)`**:

  新しいサブ irb インタプリタを起動します。
  オブジェクト obj が指定された時はその obj を self にします。

- **`jobs`**:
- **`irb_jobs`**:

  サブ irb のリストを返します。

- **`fg(n)`**:
- **`irb_fg(n)`**:

  n で指定したサブ irb に移動します。
  n は以下のいずれかの値で指定します。

  ```text
    * irb インタプリタ番号
    * irb オブジェクト
    * スレッド ID
    * 各インタプリタの self (「irb(obj)」で起動した時の obj)
  ```

- **`kill(n)`**:
- **`irb_kill(n)`**:

  n で指定したサブ irb を停止します。
  n は以下のいずれかの値で指定します。

  ```text
    * irb インタプリタ番号
    * irb オブジェクト
    * スレッド ID
    * 各インタプリタの self (「irb(obj)」で起動した時の obj)
  ```

- **`source(path)`**:
- **`irb_source(path)`**:

  現在の irb インタプリタ上で、
  Ruby スクリプト path を評価します。

  path の内容を irb で一行ずつタイプしたかのように、irb 上で一行ずつ評
  価されます。[m:$"] は更新されず、何度でも実行し直す事ができます。

  source という名前は UNIX シェルの source コマンドに由来します。

- **`irb_load(path, prev = nil)`**:

  Ruby の load の irb 版です。
  ファイル path を Ruby スクリプトとみなし、
  現在の irb インタプリタ上で実行します。
  ただし、prev に true を指定した場合は実行は内部的に生成される無名モジュー
  ル上で行われ、グローバルな名前空間を汚染しません。

  [m:Kernel?.load] と異なり、path の内容を irb で一行ずつタイプしたか
  のように、irb 上で一行ずつ評価されます。

- **`irb_require(path)`**:

  Ruby の require の irb 版です。
  ファイル path を現在の irb インタプリタ上で実行します。

  path に Ruby スクリプトを指定した場合は、[m:Kernel?.require] と異な
  り、path の内容を irb で一行ずつタイプしたかのように、irb 上で一行ず
  つ評価されます。require に成功した場合は true を、そうでない場合は
  false を返します。

  拡張ライブラリ(*.so,*.o,*.dll など)を指定した場合は単純に require さ
  れます。

#%until 3.4
- **`help(*names)`**:
- **`irb_help(*names)`**:

  RI から Ruby のドキュメントを参照します。
#%since 3.3
  このコマンドは非推奨で、実行すると `show_doc` コマンドを使うようにという警告が表示されます。
#%end

  ```irb
    irb(main):001:0> help String#match
    ...
  ```

  names を指定しなかった場合は、RI を対話的なモードで起動します。メソッ
  ド名などを入力する事でドキュメントの検索が行えます。入力のタブ補完を
  する事ができます。また、空行を入力する事で irb のプロンプトに戻る事が
  できます。

  ```irb
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
  ```

#%else
- **`help`**:
- **`irb_help`**:

  使用できるコマンドとヘルパーメソッドの一覧を表示します。
  `help ls` のようにコマンド名を指定すると、そのコマンドの説明を表示します。

#%end
#%since 3.2
- **`show_doc(*names)`**:
#%since 3.3
- **`irb_show_doc(*names)`**:
#%end
#%since 4.0
- **`ri(*names)`**:
#%end

  RI から Ruby のドキュメントを参照します。
  `show_doc String#match` のようにメソッド名などを指定します。
  指定しなかった場合は、RI を対話的なモードで起動します。

#%end
#%since 3.2
- **`show_cmds`**:
#%version 3.2...3.4
- **`irb_show_cmds`**:
#%end

  使用できるコマンドの一覧を表示します。

#%end
#%since 3.1
- **`ls`**:
- **`irb_ls`**:

  オブジェクトのメソッド・定数・変数を一覧表示します。
  `ls obj` のようにオブジェクトを指定します。省略した場合は `self` が対象です。
#%since 3.2
  `ls obj -g パターン` のように `-g` を指定すると、出力をパターンで絞り込めます。
#%end

- **`show_source`**:
- **`irb_show_source`**:
#%since 3.2
- **`$`**:
#%end

  メソッド・クラス・モジュール・定数のソースコードを表示します。
#%until 3.2
  `show_source "Foo#bar"` や `show_source "Foo"` のように文字列で指定します。
#%else
  `show_source Foo#bar` や `show_source Foo` のように指定します。
#%end
#%since 3.3
  `-s` を付けるとスーパークラス側の定義を表示し、`-ss` のように重ねるとさらに上位の定義を表示します。
#%end

- **`whereami`**:
- **`irb_whereami`**:
#%since 3.2
- **`@`**:
#%end

  `binding.irb` を呼び出した位置の周辺のソースコードをもう一度表示します。

#%end
#%since 3.2
- **`edit`**:
- **`irb_edit`**:

  ファイルをエディタで開きます。
  `edit foo.rb` のようにファイル名を指定するほか、`edit Foo#bar` のようにメソッドや定数を指定すると、その定義があるファイルを開きます。
  省略した場合は、現在のコンテキストが定義されているファイルを開きます。
  エディタは環境変数 `EDITOR` で指定します。
#%since 3.3
  `VISUAL` が設定されている場合は、`VISUAL` が優先されます。
#%end

#%end
#%since 3.3
- **`history`**:
- **`irb_history`**:
- **`hist`**:

  入力履歴を表示します。`history -g パターン` のように `-g` を指定すると、パターンに一致する履歴だけを表示します。

#%end
#%since 3.4
- **`cd`**:

  指定したオブジェクトをワークスペースのスタックに積みます(`pushws` に相当)。
  `cd ..` で一つ前のワークスペースに戻り(`popws` に相当)、引数なしの `cd` で最初のワークスペースまで戻ります。

#%end
#%since 4.0
- **`copy`**:

  式の実行結果の `inspect` をクリップボードにコピーします。
  式を省略した場合は、直前の実行結果(`_`)をコピーします。
  コピーに使うプログラムは `:COPY_COMMAND` で変更できます。

#%end
- **`measure`**:
#%since 3.1
- **`irb_measure`**:
#%end

  式の実行時間を計測するモードを有効にします。`measure :off` で無効にします。
  計測方法は `IRB.conf[:MEASURE_PROC]` で追加できます。

- **`irb_info`**:

  Ruby と irb のバージョンなど、irb の情報を表示します。

#%since 3.4
- **`disable_irb`**:
- **`irb_disable_irb`**:

  現在の irb を終了し、以降の `binding.irb` の呼び出しを何もしないようにします。

#%end
#%since 3.2
- **`debug`**:
- **`irb_debug`**:

  [lib:debug] (debug gem) のデバッガを起動します。
  `binding.irb` から起動した irb でのみ使え、debug gem がインストールされている必要があります。

- **`break`**:
- **`irb_break`**:
- **`catch`**:
- **`irb_catch`**:
- **`next`**:
- **`irb_next`**:
- **`delete`**:
- **`irb_delete`**:
- **`step`**:
- **`irb_step`**:
- **`continue`**:
- **`irb_continue`**:
- **`finish`**:
- **`irb_finish`**:
- **`backtrace`**:
- **`bt`**:
- **`irb_backtrace`**:
- **`info`**:
- **`irb_debug_info`**:

  デバッガを起動し、debug gem の同名のコマンドを実行します。
  `debug` コマンドと同様、`binding.irb` から起動した irb でのみ使えます。

#%end

#%since 3.4
### irb の拡張 {#extend_irb}

ライブラリや .irbrc から、独自のコマンドやヘルパーメソッドを irb に追加できます。

コマンドは `ls -g pattern` のように、シェルのコマンドに似た形で使うものです。
Ruby の構文として正しくない引数も受け取れます。
ヘルパーメソッドは `my_helper("foo").upcase` のように、Ruby のメソッドとして使うものです。
どちらにするか迷った場合は、コマンドを選んでください。

#### コマンドの登録

`IRB::Command::Base` を継承したクラスを作り、`IRB::Command.register` でコマンド名と一緒に登録します。
`execute` は、コマンド名の後ろに続く入力を 1 つの文字列として受け取ります。

```ruby
require "irb/command"

class Greet < IRB::Command::Base
  category "Greeting"
  description "Greets the user"
  help_message <<~HELP
    Greets the user with the given name.

    Usage: greet <name>
  HELP

  def execute(arg)
    puts "Hello! #{arg}"
  end
end

IRB::Command.register(:greet, Greet)
```

irb を起動する前にこのコードが読み込まれていれば、`greet Stan` のように使えます。
`category` と `description` は `help` コマンドの一覧に表示され、`help_message` は `help greet` で表示されます。

#### ヘルパーメソッドの登録

`IRB::HelperMethod::Base` を継承したクラスを作り、`IRB::HelperMethod.register` でメソッド名と一緒に登録します。
ヘルパーメソッドは Ruby のメソッドとして呼び出され、`execute` の引数にはその呼び出しの引数がそのまま渡されます。

```ruby
require "irb/helper_method"

class MyHelper < IRB::HelperMethod::Base
  description "This is a test helper"

  def execute(arg, kwarg:)
    "arg: #{arg}, kwarg: #{kwarg}"
  end
end

IRB::HelperMethod.register(:my_helper, MyHelper)
```

irb を起動する前にこのコードが読み込まれていれば、`my_helper("foo", kwarg: "bar").upcase` のように使えます。
登録したヘルパーメソッドは `help` コマンドの一覧にも表示されます。

#%end
### システム変数

- **`_`**:

  直前の式の実行結果です。

  ```console title="例"
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
  ```

- **`__`**:

  実行結果の履歴です。
  __[lineno] で、lineno 行で実行した結果を得られます。
  lineno が負の時は、最新の結果から -lineno 行だけ前の
  結果を得られます。

  この変数はデフォルトでは使えません。
  この変数を使用するには、あらかじめ .irbrc などで
  conf.eval_history の値を指定しておかなければいけません。

  ```console title="例"
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
  ```

### 使用上の制限

irbは、 評価できる時点(式が閉じた時点)での逐次実行を行ないます。
したがって、 Rubyを直接使った時と若干異なる動作を行なう場合があります。

現在明らかになっている問題点を説明します。

#### ローカル変数の宣言

以下のコードは、 Ruby スクリプトとして実行するとエラーになりません。

```ruby
eval "foo"
foo = 0
```

ところが、 irb ではエラーになります。

```irb
irb(main):001:0> eval "foo"
#%since 3.4
NameError (undefined local variable or method 'foo' for main)
#%else
NameError (undefined local variable or method `foo' for main)
#%end
irb(main):002:0> foo = 0
```

この違いは、Ruby スクリプト と irb の構文解析のタイミングの差に起因します。 Ruby は最初にスクリプト全体を解析して、宣言されているローカル変数を定義し、コードを評価します。それに対し、irb は式が完結して実行可能になった時点で評価します。
上記の Ruby スクリプトの例では、2行目に

```ruby
foo = 0
```

が宣言されているため、スクリプト全体を解析するとローカル変数 foo が定義されます。
そのため1行目の eval "foo" で NameError になりません。

irb の場合は1行目に入力した eval "foo" が実行可能になった時点で評価されます。その時点ではローカル変数 foo は宣言されていないため、 NameError になります。

Ruby と irb の動作の違いをなくしたい場合は、 irb では以下のように式を begin 〜 end でくくって入力してください。

```irb
irb(main):001:1* begin
irb(main):002:1*   eval "foo"
irb(main):003:1*   foo = 42
irb(main):004:0> end
```

#### ヒアドキュメント

現在のところヒアドキュメントの実装は不完全です。

#### シンボル

irb はシンボルであるかどうかの判断を間違えることがあります。
具体的には、式が完了しているのに継続行と見なすことがあります。

### 履歴の保存 {#history}

デフォルトで実行結果の履歴1000件がファイルに保存されます。保存先は $XDG_CONFIG_HOME/irb/irb_history (Ruby 2.7.2 以降かつ $XDG_CONFIG_HOME が定義されている場合) か ~/.irb_history です。

もし履歴を保存したくない場合は、.irbrc で以下のように指定します。

```ruby
IRB.conf[:SAVE_HISTORY] = nil
```

履歴ファイルの名前は IRB.conf[:HISTORY_FILE] で指定できます。

### 実行結果の出力方式 {#inspect_mode}

irb のプロンプト中では conf.inspect_mode で、.irbrc 中では
IRB.conf[:INSPECT_MODE] に以下のいずれかの値を設定する事で、結果出力の方式を変更する事ができます。

- **`false, :to_s, :raw`**:

  出力結果を to_s したものを表示します。

- **`true, :p, :inspect`**:

  出力結果を inspect したものを表示します。

- **`:pp, :pretty_inspect`**:

  出力結果を pretty_inspect したものを表示します。

- **`:yaml, :YAML`**:

  出力結果を YAML 形式にしたものを表示します。

- **:marshal, :Marshal, :MARSHAL, [c:Marshal]**:

  出力結果を [m:Marshal?.dump] したものを表示します。

  ```console title="例"
  $ irb
  irb(main):001:0> conf.inspect_mode = :yaml
  irb(main):002:0> :foo # => --- :foo
  ```

また、irb の起動時に --inspect オプションを指定する事でも同様の設定を行えます。

```console
$ irb --inspect [raw|p|pp|yaml|marshal|...]
```

上記以外にも独自の出力方式を追加する事ができます。詳しくは
[m:IRB::Inspector.def_inspector] を参照してください。

# module IRB

irb のメインモジュールです。

## Class Methods

### def IRB.conf -> Hash

irb の設定をハッシュで返します。

### def IRB.version -> String

IRB のバージョンを文字列で返します。

~/.irbrc などの設定ファイル内で IRB.conf[:VERSION] を設定していた場合は任意のバージョンを返すように設定できます。

### def IRB.CurrentContext -> IRB::Context

現在の irb に関する [c:IRB::Context] を返します。

### def IRB.start(ap_path = nil) -> ()

[c:IRB] を初期化して、トップレベルの irb を開始します。

- **param** `ap_path` -- irb コマンドのパスを指定します。

#%until 3.3
### def IRB.irb_at_exit -> ()

at_exit で登録された処理を実行します。

ユーザが直接使用するものではありません。

#%end
#%since 3.4
### def IRB.irb_exit(*)

irb を終了します。引数は無視されます。

ユーザが直接使用するものではありません。

#%else
### def IRB.irb_exit(irb, ret) -> object

irb を終了します。ret で指定したオブジェクトを返します。

- **param** `irb` -- 現在の [c:IRB::Irb] オブジェクトを指定します。

- **param** `ret` -- 戻り値を指定します。

ユーザが直接使用するものではありません。

#%end
### def IRB.irb_abort(irb, exception = Abort)

実行中の処理を中断します。必ず例外が発生するため、何も返しません。

- **param** `irb` -- 現在の [c:IRB::Irb] オブジェクトを指定します。

- **param** `exception` -- 発生させる例外を指定します。指定しなかった場合は
                 [c:IRB::Abort] が発生します。

- **raise** `exception` -- 引数 exception で指定した例外が発生します。

ユーザが直接使用するものではありません。

# class IRB::Irb

irb インタプリタのメインルーチンです。

ユーザが直接使用するものではありません。

# class IRB::Abort < Exception

実行中の処理を中断する時に発生させる例外クラスです。

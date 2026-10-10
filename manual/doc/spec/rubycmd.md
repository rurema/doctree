# Rubyの起動 {#ruby}

  - [ref:cmd_option]
  - [ref:shebang]

Rubyインタプリタの起動は以下の書式のコマンドラインにより行います。
#%#((-[[c:Win32ネイティブ版]] には、コマンドプロンプトを使用しない
#%#rubyw.exe コマンドがあります-))

```console
ruby [ option ...] [ -- ] [ programfile ] [ argument ...]
```

ここで、option は後述の[ref:cmd_option]
のいずれかを指定します。-- は、オプション列の終りを明示するために使用できます。programfile は、Ruby スクリプトを記述したファイルです。これを省略したり`-` を指定した場合には標準入力を Ruby スクリプトとみなします。

programfile が `#!` で始まるファイルである場合、特殊な解釈が行われます。詳細は後述の[ref:shebang] を参照してください。

argument に指定した文字列は組み込み定数 [m:Object::ARGV] の初期値として設定されます。標準のシェルがワイルドカードを展開しない環境
([d:platform/Win32])では、Ruby インタプリタが自前でワイルドカードを展開して
[m:Object::ARGV] に設定します。この場合ワイルドカードとして
`*`, `?`, `[]`, `**/` が使用できます。Win32 環境で、ワイルドカード展開を抑止したい場合は引数をシングルクォート(') で括ります。

### コマンドラインオプション {#cmd_option}

Rubyインタプリタは以下のコマンドラインオプションを受け付けます。基本的にPerlのものと良く似ています。

- **-0数字**:

  入力レコードセパレータ([m:$/])を8進数で指定します。

  数字を指定しない場合はヌルキャラクタがセパレータになります
  ($/ = "\0" と同じ)。
  数の後に他のスイッチがあっても構いません。

  -00で, パラグラフモード($/=""と同じ), -0777で
  (そのコードを持つ文字は存在しないので)ファイルの内容を全部一度に読み
  込むモード($/=nilと同じ)に設定できます。

- **`-a`**:

  `-n`や`-p`とともに用いて, オートスプリットモードをONにします。
  オートスプリットモードでは各ループの先頭で,
  ```text
      $F = $_.split
  ```
  が実行されます。`-n`か`-p`オプションが同時に指定されない限り,
  このオプションは意味を持ちません。

- **`--backtrace-limit=num`**:

  バックトレースの最大行数を指定します。

  ```ruby
  # test.rb
  def f6 = raise
  def f5 = f6
  def f4 = f5
  def f3 = f4
  def f2 = f3
  def f1 = f2
  f1
  ```

  ```console
  % ruby --backtrace-limit=3 test.rb
#%since 3.4
  test.rb:1:in 'Object#f6': unhandled exception
    from test.rb:2:in 'Object#f5'
    from test.rb:3:in 'Object#f4'
    from test.rb:4:in 'Object#f3'
     ... 3 levels...
#%else
  test.rb:1:in `f6': unhandled exception
    from test.rb:2:in `f5'
    from test.rb:3:in `f4'
    from test.rb:4:in `f3'
     ... 3 levels...
#%end
  ```

- **`-C directory`**:

  スクリプト実行前に指定されたディレクトリに移動します。

- **`-c`**:

  スクリプトの内部形式へのコンパイルのみを行い, 実行しません。コンパイル終
  了後, 文法エラーが無ければ, "Syntax OK"と出力します。

- **`--copyright`**:

  著作権表示をします。

#%since 3.3
- **`--crash-report=template`**:

  クラッシュレポートを書き出すファイル名のテンプレートを指定します。環境変数 `RUBY_CRASH_REPORT` でも指定できます。テンプレートの書式の詳細は ruby(1) の man ページを参照してください。

#%end
- **`-d`**:
- **`--debug`**:

  デバッグモードでスクリプトを実行します。[m:$DEBUG] と [m:$VERBOSE] を
  true にします。

- **`--dump=items`**:

  指定した項目のデバッグ情報を出力して終了します。items には以下のいずれかを指定できます。
  ```text
#%version 3.0...3.1
      * insns                   命令列
      * yydebug                 yacc パーサの yydebug 出力
      * parsetree               抽象構文木 (AST)
      * parsetree_with_comment  注釈付きの AST
#%end
#%version 3.1...3.2
      * insns                   命令列
      * insns_without_opt       最適化なしでコンパイルした命令列
      * yydebug                 yacc パーサの yydebug 出力
      * parsetree               抽象構文木 (AST)
      * parsetree_with_comment  注釈付きの AST
#%end
#%version 3.2...3.3
      * insns                                    命令列
      * insns_without_opt                        最適化なしでコンパイルした命令列
      * yydebug(+error-tolerant)                 yacc パーサの yydebug 出力
      * parsetree(+error-tolerant)               抽象構文木 (AST)
      * parsetree_with_comment(+error-tolerant)  注釈付きの AST
#%end
#%version 3.3...3.4
      * insns                                    命令列
      * insns_without_opt                        最適化なしでコンパイルした命令列
      * yydebug(+error-tolerant)                 yacc パーサの yydebug 出力
      * parsetree(+error-tolerant)               抽象構文木 (AST)
      * parsetree_with_comment(+error-tolerant)  注釈付きの AST
      * prism_parsetree                          注釈付きの Prism の AST
#%end
#%since 3.4
      * insns            命令列
      * yydebug          yacc パーサの yydebug 出力
      * parsetree        抽象構文木 (AST)
      修飾子(項目名の後ろに付けます):
      * -optimize        最適化を無効にする (insns に影響)
      * +error-tolerant  エラー耐性のある構文解析を行う (yydebug, parsetree に影響)
      * +comment         AST に注釈を付加する (--parser=parse.y の parsetree に影響)
#%end
  ```

#%version 3.2...3.4
  `+error-tolerant` を付けるとエラー耐性のある構文解析を行います。

#%end
- **`-E ex[:in]`**:
- **`--encoding ex[:in]`**:

  デフォルトの外部エンコーディングと内部エンコーディングを:区切りで指定
  します。内部エンコーディングを省略した場合は
  [m:Encoding.default_internal] は nil になります。また、:エンコーディ
  ング のように外部エンコーディングを省略した場合は内部エンコーディング
  のみを変更します。

  ```console
  # 変更しない場合

  $ ruby -e 'p Encoding.default_external; p Encoding.default_internal'
  #<Encoding:UTF-8>
  nil


  # 外部エンコーディングをEUC-JPにする場合

  $ ruby -E EUC-JP -e 'p Encoding.default_external; p Encoding.default_internal'
  #<Encoding:EUC-JP>
  nil

  $ ruby --encoding EUC-JP -e 'p Encoding.default_external; p Encoding.default_internal'
  #<Encoding:EUC-JP>
  nil


  # 内部エンコーディングをWindows-31Jにする場合

  $ ruby -E :Windows-31J -e 'p Encoding.default_external; p Encoding.default_internal'
  #<Encoding:UTF-8>
  #<Encoding:Windows-31J>

  $ ruby --encoding :Windows-31J -e 'p Encoding.default_external; p Encoding.default_internal'
  #<Encoding:UTF-8>
  #<Encoding:Windows-31J>


  # 外部エンコーディングをEUC-JP、内部エンコーディングをWindows-31Jにする場合

  $ ruby -E EUC-JP:Windows-31J -e 'p Encoding.default_external; p Encoding.default_internal'
  #<Encoding:EUC-JP>
  #<Encoding:Windows-31J>

  $ ruby --encoding EUC-JP:Windows-31J -e 'p Encoding.default_external; p Encoding.default_internal'
  #<Encoding:EUC-JP>
  #<Encoding:Windows-31J>
  ```

- **`--external-encoding encoding`**:

  デフォルトの外部エンコーディングを指定します。

  ```console
  $ ruby --external-encoding EUC-JP -e 'p Encoding.default_external; p Encoding.default_internal'
  #<Encoding:EUC-JP>
  nil
  ```

- **`--internal-encoding encoding`**:

  デフォルトの内部エンコーディングを指定します。

  ```console
  $ ruby --internal-encoding EUC-JP -e 'p Encoding.default_external; p Encoding.default_internal'
  #<Encoding:UTF-8>
  #<Encoding:EUC-JP>
  ```

- **`--enable feature`**:

  指定した feature を有効にします。以下のいずれかを指定できます。
  ```text
      * gems            rubygems (無効にするのはデバッグ専用、default: enabled)
#%since 3.1
      * error_highlight error_highlight (default: enabled)
#%end
      * did_you_mean    did_you_mean (default: enabled)
#%since 3.2
      * syntax_suggest  syntax_suggest (default: enabled)
#%end
      * rubyopt         RUBYOPT 環境変数 (default: enabled)
      * frozen-string-literal 全ての文字列リテラルを freeze (default: disabled)
#%version 3.0...3.1
      * jit             JIT (default: disabled)
#%end
#%version 3.1...3.3
      * mjit            MJIT (default: disabled)
      * yjit            YJIT (default: disabled)
#%end
#%version 3.3...4.0
      * yjit            YJIT (default: disabled)
      * rjit            RJIT (実験的、default: disabled)
#%end
#%since 4.0
      * yjit            YJIT (default: disabled)
      * zjit            ZJIT (default: disabled)
#%end
  ```

- **`--disable`**:

  指定した feature(--enable を参照)を無効にします。

- **`-e script`**:

  コマンドラインからスクリプトを指定します。-eオ
  プションを付けた時には引数からスクリプトファイル名を取りませ
  ん。

  -e オプションを複数指定した場合、各スクリプトの間に改行を
  挟んで解釈します。
  ```console
      以下は等価です。
      ruby -e "5.times do |i|" -e "puts i" -e "end"

      ruby -e "5.times do |i|
        puts i
      end"

      ruby -e "5.times do |i|; puts i; end"
  ```

- **`-Fregexp`**:

  入力フィールドセパレータ([m:$;])に regexp をセットします。

- **`-h`**:

  コマンドラインオプションの概要を表示します。

- **`--help`**:

  コマンドラインオプションの概要を表示します。-h よりも詳しい情報が表示されます。

- **`-i[extension]`**:

  引数で指定されたファイルの内容を置き換える(in-place edit)こ
  とを指定します。元のファイルは拡張子をつけた形で保存されます。
  拡張子を省略するとバックアップは行われず、変更されたファイル
  だけが残ります。ただし [d:platform/Win32] では省略出来ません
  ([ruby-list:38066] 参照)。

  ```console title="例"
      % echo matz > /tmp/junk
      % cat /tmp/junk
      matz
      % ruby -p -i.bak -e '$_.upcase!' /tmp/junk
      % cat /tmp/junk
      MATZ
      % cat /tmp/junk.bak
      matz
  ```

- **`-I directory`**:

  ファイルをロードするパスを指定(追加)します。指定されたディレ
  クトリはRubyの配列変数([m:$:])に追加されます。

- **`-l`**:

  行末の自動処理を行います。まず、[m:$\\] を
  [m:$/] と同じ値に設定し, printでの出力
  時に改行を付加するようにします。それから, -n
  フラグまたは-pフラグが指定されていると
  gets
  で読み込まれた各行の最後に対して
  [m:String#chomp!]を行います。

- **`-n`**:

  このフラグがセットされるとプログラム全体が
  sed -nやawk
  のように
  ```text
      while gets
       ...
      end
  ```
  で囲まれているように動作します。

- **`-p`**:

  -nフラグとほぼ同じですが, 各ループの最後に変数 [m:$_]
  の値を出力するようになります。

  ```console title="例"
      % echo matz | ruby -p -e '$_.tr! "a-z", "A-Z"'
      MATZ
  ```

#%since 3.3
- **`--parser=parser`**:

  Ruby スクリプトの構文解析に使うパーサを `parse.y` か `prism` から指定します。

#%end
#%version 3.3...3.4
  Ruby 3.3 ではデフォルトは `parse.y` で、`prism` は実験的です。`--parser=prism` を指定すると警告が出力されます。

#%end
#%since 3.4
  Ruby 3.4 からデフォルトは `prism` です。従来のパーサを使うには `--parser=parse.y` を指定してください。

#%end
- **`-r feature`**:

  スクリプト実行前に feature で指定されるライブラリを
  [m:Kernel?.require] します。
  `-n`オプション、`-p`オプションとともに使う時に特に有効です。

- **`-s`**:

  スクリプト名に続く, `-`で始まる引数を解釈して, 同名のグローバル変数に値
  を設定します。`--`なる引数以降は解釈を行ないません。該当する引数は
  [m:Object::ARGV] から取り除かれます。

  ```ruby title="例"
      #! /usr/local/bin/ruby -s
      # prints "true" if invoked with `-xyz' switch.
      print "true\n" if $xyz
  ```

- **`-S`**:

  スクリプト名が`/`で始まっていない場合, 環境変数
  PATHの値を使ってスクリプトを探すことを指定しま
  す。 これは、#!をサポートしていないマシンで、
  #! による実行をエミュレートするために、以下の
  ようにして使うことができます:
  ```sh
      #!/bin/sh
      exec ruby -S -x $0 "$@"
      #! ruby
  ```

  システムは最初の行により、スクリプトを/bin/sh
  に渡します。/bin/shは2行目を実行しRubyインタプリタを起動します。
  Rubyインタプリタは-x
  オプションにより`#!`で始まり, "ruby"という文字列を含む行までを
  読み飛ばします。

  システムによっては [m:$0]は必ずしもフルパスを含まな
  いので、`-S`を用いてRubyに必要に応じてスクリプトを探すように
  指示する必要があります。

- **`-v`**:
  冗長モード。起動時にバージョンの表示を行い, 組み込み変数
  [m:$VERBOSE]をtrueにセットします。この変数がtrueである時, いくつかのメソッドは実行時に冗長なメッセージを出力します。`-v`オプションが指定されて, それ以外の引数がない時にはバージョンを表示した後, 実行を終了します(標準入力からのスクリプトを待たない)。

- **`--verbose`**:
  冗長モード。 組み込み変数 [m:$VERBOSE] をtrueにセットします。この変数がtrueである時, いくつかのメソッドは実行時に冗長なメッセージを出力します。標準入力からのスクリプトは読み込みません。

- **`--version`**:

  Rubyのバージョンを表示します。

- **`-w`**:

  バージョンの表示を行う事無く冗長モードになります。

- **`-W[level]`**:
- **`-W:category`**:

    冗長モードを三段階のレベルで指定します。それぞれ以下の通りです。
  ```text
       * -W0: 警告を出力しない
       * -W1: 重要な警告のみ出力(デフォルト)
       * -W2 or -W: すべての警告を出力する
  ```
    組み込み変数 [m:$VERBOSE] はそれぞれ nil, false, true
    に設定されます。

    また category には以下の値を設定できます。deprecated と experimental は別々に設定することもできます。
  ```text
       * -W:deprecated : 非推奨な機能を使用した際に警告を出力する
       * -W:no-deprecated : 非推奨な機能を使用した際に警告を出力しない(デフォルト)
       * -W:experimental : 実験的な機能を使用した際に警告を出力する(デフォルト)
       * -W:no-experimental : 実験的な機能を使用した際に警告を出力しない
#%since 3.3
       * -W:performance : パフォーマンスに関する警告を出力する
       * -W:no-performance : パフォーマンスに関する警告を出力しない(デフォルト)
#%end
#%since 3.4
       * -W:strict_unused_block : ブロックを使わないメソッドに渡される無駄なブロックを、別クラスの同名メソッドがブロックを使う場合を含めて常に警告する
       * -W:no-strict_unused_block : 上記の警告を出力しない(デフォルト)
#%end
  ```
    ここで設定された値は [m:Warning.\[\]] で参照できます。

    NOTE: Ruby 2.7.2 からは `-W:no-deprecated` がデフォルトになります。警告を出力したい場合は `-W:deprecated` を使ってください。

- **`-x[directory]`**:

  メッセージ中のスクリプトを取り出して実行します。スクリプトを
  読み込む時に、`#!`で始まり, "ruby"という文字列を含む行までを
  読み飛ばします。スクリプトの終りはEOF(ファイル
  の終り), ^D(コントロールD), ^Z(コ
  ントロールZ)または予約語__END__で指定されます。

  ディレクトリ名を指定すると、スクリプト実行前に指定されたディ
  レクトリに移動します。

- **`-y`**:
- **`--yydebug`**:

  コンパイラデバッグモード。スクリプトを内部表現にコンパイルす
  る時の構文解析の過程を表示します。この表示は非常に冗長なので,
  コンパイラそのものをデバッグする人以外には必要ないと思います。

#%version 3.0...3.3
#### JIT のオプション (実験的)
#%else
#### JIT のオプション
#%end

- **`--jit`**:

#%version 3.0...3.1
  デフォルトの設定でMJITを有効にします。`--jit-[option]` で設定を指定できます。
#%end
#%version 3.1...3.3
  YJITを組み込んでビルドされたRubyではYJIT(`--yjit` と同じ)を、そうでなければMJIT(`--mjit` と同じ)を有効にします。
#%end
#%version 3.3...4.0
  YJITを組み込んでビルドされたRubyではYJIT(`--yjit` と同じ)を、そうでなければRJIT(`--rjit` と同じ)を有効にします。
#%end
#%since 4.0
  ビルドのデフォルトのJIT、すなわちYJIT(`--yjit` と同じ)を有効にします。ZJITは `--jit` では有効になりません。
#%end

  `--enable=jit` も `--jit` と同じ意味になります。

#%version 3.0...3.3
#### MJIT のオプション (実験的)

#%end

#%version 3.1...3.3
- **`--mjit`**:

  デフォルトの設定でMJITを有効にします。

- **`--mjit-[option]`**:

  指定した設定でMJITを有効にします。

#%end
#%version 3.0...3.1
- **`--jit-warnings`**:

  JITの警告の出力を有効にします。

- **`--jit-debug`**:

  JITのデバッグを有効にします。(非常に遅くなります。)
  また、指定されていれば cflags を追加します。

- **`--jit-wait`**:

  毎回JITコンパイルが終わるまで待ちます。(テスト用)

- **`--jit-save-temps`**:

  一時ファイルを $TMP か /tmp の中に残します。(テスト用)

- **`--jit-verbose=num`**:

  ログレベルがnum以下のログが標準エラー出力に出力されます。(デフォルト: 0)

- **`--jit-max-cache=num`**:

  キャッシュに残すJITされたメソッドの最大個数を指定します。(デフォルト: 100)

- **`--jit-min-calls=num`**:

  JITが起動する呼び出し回数を指定します。(テスト用、デフォルト: 10000)
#%end
#%version 3.1...3.3
- **`--mjit-warnings`**:

  JITの警告の出力を有効にします。

- **`--mjit-debug`**:

  JITのデバッグを有効にします。(非常に遅くなります。)
  また、指定されていれば cflags を追加します。

- **`--mjit-wait`**:

  毎回JITコンパイルが終わるまで待ちます。(テスト用)

- **`--mjit-save-temps`**:

  一時ファイルを $TMP か /tmp の中に残します。(テスト用)

- **`--mjit-verbose=num`**:

  ログレベルがnum以下のログが標準エラー出力に出力されます。(デフォルト: 0)

- **`--mjit-max-cache=num`**:

  キャッシュに残すJITされたメソッドの最大個数を指定します。(デフォルト: 100)

#%end
#%version 3.1...3.2
- **`--mjit-min-calls=num`**:

  JITが起動する呼び出し回数を指定します。(テスト用、デフォルト: 10000)
#%end
#%version 3.2...3.3
- **`--mjit-call-threshold=num`**:

  JITが起動する呼び出し回数を指定します。(テスト用、デフォルト: 10000)
#%end

#%version 3.1...3.2
#### YJIT のオプション (実験的)

#%end
#%since 3.2
#### YJIT のオプション

#%end
#%since 3.1
- **`--yjit`**:

  デフォルトの設定でYJITを有効にします。[c:RubyVM::YJIT] も参照してください。

- **`--yjit-[option]`**:

  指定した設定でYJITを有効にします。

#%end
#%version 3.1...3.2
- **`--yjit-stats`**:

  統計情報を収集します。統計機能付きでビルドされたRubyでのみ有効です。

- **`--yjit-exec-mem-size=num`**:

  MiB単位で実行可能メモリブロックのサイズを指定します。(デフォルト: 256)

- **`--yjit-call-threshold=num`**:

  JITが起動する呼び出し回数を指定します。(デフォルト: 10)

- **`--yjit-max-versions=num`**:

  ベーシックブロックごとのバージョンの最大数を指定します。(デフォルト: 4)

- **`--yjit-greedy-versioning`**:

  貪欲なバージョニングモードを指定します。(デフォルト: disabled)

#%end
#%version 3.2...3.3
- **`--yjit-stats`**:

  統計情報を収集します。

- **`--yjit-exec-mem-size=num`**:

  MiB単位で実行可能メモリブロックのサイズを指定します。(デフォルト: 64)

- **`--yjit-call-threshold=num`**:

  JITが起動する呼び出し回数を指定します。(デフォルト: 10)

- **`--yjit-max-versions=num`**:

  ベーシックブロックごとのバージョンの最大数を指定します。(デフォルト: 4)

- **`--yjit-greedy-versioning`**:

  貪欲なバージョニングモードを指定します。(デフォルト: disabled)

#%end
#%version 3.3...3.4
- **`--yjit-exec-mem-size=num`**:

  MiB単位で実行可能メモリブロックのサイズを指定します。(デフォルト: 48。Ruby 3.3.0 のみ 64)

- **`--yjit-call-threshold=num`**:

  JITが起動する呼び出し回数を指定します。

- **`--yjit-cold-threshold=num`**:

  この回数を超えた累計の呼び出し以降は、まだコンパイルされていないISEQをコンパイルしません。(デフォルト: 200K)

- **`--yjit-stats`**:

  統計情報を収集します。

- **`--yjit-disable`**:

  YJITを無効のまま起動します。後から [m:RubyVM::YJIT.enable] で有効にするためのオプションです。

- **`--yjit-code-gc`**:

  コードサイズが上限に達したらコードGCを実行します。

- **`--yjit-perf`**:

  フレームポインタとperfによるプロファイリングを有効にします。

- **`--yjit-trace-exits`**:

  生成されたコードから抜けるときのRubyソースの位置を記録します。

- **`--yjit-trace-exits-sample-rate=num`**:

  N回に1回だけ、抜けるときの位置を記録します。

#%end
#%since 3.4
- **`--yjit-mem-size=num`**:

  YJITのメモリ使用量のソフトリミットをMiB単位で指定します。(デフォルト: 128)

- **`--yjit-exec-mem-size=num`**:

  実行可能メモリブロックのハードリミットをMiB単位で指定します。

- **`--yjit-call-threshold=num`**:

  JITが起動する呼び出し回数を指定します。

- **`--yjit-cold-threshold=num`**:

  この回数を超えた累計の呼び出し以降は、まだコンパイルされていないISEQをコンパイルしません。(デフォルト: 200K)

- **`--yjit-stats`**:

  統計情報を収集します。

- **`--yjit-log[=file|dir]`**:

  YJITのコンパイル活動のログを出力します。

- **`--yjit-disable`**:

  YJITを無効のまま起動します。後から [m:RubyVM::YJIT.enable] で有効にするためのオプションです。

- **`--yjit-code-gc`**:

  コードサイズが上限に達したらコードGCを実行します。

- **`--yjit-perf`**:

  フレームポインタとperfによるプロファイリングを有効にします。

- **`--yjit-trace-exits`**:

  生成されたコードから抜けるときのRubyソースの位置を記録します。

- **`--yjit-trace-exits-sample-rate=num`**:

  N回に1回だけ、抜けるときの位置を記録します。

#%end
#%since 3.1
YJITは、環境変数 `RUBY_YJIT_ENABLE` を設定しても有効にできます。

#%end
#%version 3.3...4.0
#### RJIT のオプション (実験的)

- **`--rjit`**:

  デフォルトの設定でRJITを有効にします。[c:RubyVM::RJIT] も参照してください。

- **`--rjit-[option]`**:

  指定した設定でRJITを有効にします。

- **`--rjit-exec-mem-size=num`**:

  MiB単位で実行可能メモリブロックのサイズを指定します。(デフォルト: 64)

- **`--rjit-call-threshold=num`**:

  JITが起動する呼び出し回数を指定します。(デフォルト: 10)

- **`--rjit-stats`**:

  RJITの統計情報を収集します。

- **`--rjit-disable`**:

  RJITを無効のまま起動します。後から [m:RubyVM::RJIT.enable] で有効にするためのオプションです。

- **`--rjit-trace`**:

  JITコンパイル中の [c:TracePoint] を許可します。

- **`--rjit-trace-exits`**:

  サイドエグジットの位置を記録します。

#%end
#%since 4.0
#### ZJIT のオプション (実験的)

- **`--zjit`**:

  デフォルトの設定でZJITを有効にします。[c:RubyVM::ZJIT] も参照してください。YJITとZJITを同時に有効にすることはできません。

- **`--zjit-[option]`**:

  指定した設定でZJITを有効にします。

- **`--zjit-mem-size=num`**:

  ZJITが使えるメモリの上限をMiB単位で指定します。(デフォルト: 128)

- **`--zjit-call-threshold=num`**:

  JITが起動する呼び出し回数を指定します。(デフォルト: 30)

- **`--zjit-num-profiles=num`**:

  JITの前にプロファイルする呼び出し回数を指定します。(デフォルト: 5)

- **`--zjit-stats-quiet`**:

  統計情報を収集し、出力は抑制します。

#%end
#%version 4.0...4.1
- **`--zjit-stats[=file]`**:

  統計情報を収集します。`=file` を指定するとファイルに書き出します。

#%end
#%since 4.1
- **`--zjit-stats[=file]`**:

  統計情報を収集します。`=file` を指定するとファイルに書き出します。ファイルの拡張子が `.json` ならJSON形式で出力します。

#%end
#%since 4.0
- **`--zjit-disable`**:

  ZJITを無効のまま起動します。後から [m:RubyVM::ZJIT.enable] で有効にするためのオプションです。

#%end
#%version 4.0...4.1
- **`--zjit-perf`**:

  Linuxのperf用に、ISEQのシンボルを /tmp/perf-{}.map に書き出します。

#%end
#%since 4.1
- **`--zjit-perf[=iseq|hir]`**:

  Linuxのperf用に、シンボルを /tmp/perf-{}.map に書き出します。(デフォルト: iseq)

#%end
#%since 4.0
- **`--zjit-log-compiled-iseqs=path`**:

  コンパイルしたISEQをpathのファイルに記録します。ファイルは切り詰められます。

- **`--zjit-trace-exits[=counter]`**:

  サイドエグジット時のソースを記録します。`counter` を指定すると特定のカウンタを選びます。

- **`--zjit-trace-exits-sample-rate=num`**:

  サイドエグジットを記録する頻度を指定します。

#%end
#%since 4.1
- **`--zjit-trace-compiles`**:

  コンパイルの各段階をPerfettoのトレースイベントとして記録します。

- **`--zjit-trace-invalidation`**:

  無効化イベントをPerfettoのトレースイベントとして記録します。

#%end
#%since 4.0
ZJITは、環境変数 `RUBY_ZJIT_ENABLE` を設定しても有効にできます。

#%end

### インタプリタ行の解釈 {#shebang}

コマンドラインに指定したスクリプトが \`#!\` で始まるファイルで、その行に
\`ruby\` という文字列を含まない場合、その行を読み飛ばします。\`#!\` に続く文字列が \`ruby\` という文字列を含む行を見つけたらその行以下を Ruby スクリプトとして実行します。

例えば、以下のようなスクリプトを sh で実行すると sh から Ruby を起動できます。

```text
#!/bin/sh
exec ruby -x "$0" "$@"
#!ruby
p ARGV
puts "Hello, World!"
```

これは Ruby をスペースを含むパスにインストールした場合などに有用です。


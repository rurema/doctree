# Rubyの起動 {#ruby}

  - [ref:cmd_option]
  - [ref:shebang]

Rubyインタプリタの起動は以下の書式のコマンドラインにより行います。
#@#((-[[c:Win32ネイティブ版]] には、コマンドプロンプトを使用しない
#@#rubyw.exe コマンドがあります-))

```console
ruby [ option ...] [ -- ] [ programfile ] [ argument ...]
```

ここで、option は後述の[ref:cmd_option]
のいずれかを指定します。-- は、オプション列の終りを明示するため
に使用できます。programfile は、Ruby スクリプトを記述したファイ
ルです。これを省略したり`-` を指定した場合には標準入力を Ruby ス
クリプトとみなします。

programfile が `#!` で始まるファイルである場合、特殊な解釈
が行われます。詳細は後述の[ref:shebang] を参照
してください

argument に指定した文字列は組み込み定数 [m:Object::ARGV] の初
期値として設定されます。標準のシェルがワイルドカードを展開しない環境
([d:platform/Win32])では、Ruby インタプリタが自前でワイルドカードを展開して
[m:Object::ARGV] に設定します。この場合ワイルドカードとして
`*`, `?`, `[]`, `**/` が使用できます。Win32 環境で、
ワイルドカード展開を抑止したい場合は引数をシングルクォート(') で括りま
す。

### コマンドラインオプション {#cmd_option}

Rubyインタプリタは以下のコマンドラインオプションを受け付けま
す。基本的にPerlのものと良く似ています。

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
test.rb:1:in `f6': unhandled exception
  from test.rb:2:in `f5'
  from test.rb:3:in `f4'
  from test.rb:4:in `f3'
   ... 3 levels...
```

- **`-C directory`**:

  スクリプト実行前に指定されたディレクトリに移動します。

- **`-c`**:

  スクリプトの内部形式へのコンパイルのみを行い, 実行しません。コンパイル終
  了後, 文法エラーが無ければ, "Syntax OK"と出力します。

- **`--copyright`**:

  著作権表示をします。


- **`-d`**:
- **`--debug`**:

  デバッグモードでスクリプトを実行します。[m:$DEBUG] と [m:$VERBOSE] を
  true にします。

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
#@since 3.1
    * error_highlight error_highlight (default: enabled)
#@end
    * did_you_mean    did_you_mean (default: enabled)
    * rubyopt         RUBYOPT 環境変数 (default: enabled)
    * frozen-string-literal 全ての文字列リテラルをfreeze (default: disabled)
    * jit             JIT (default: disabled)
#@since 3.1
    * mjit            MJIT (default: disabled)
    * yjit            YJIT (default: disabled)
#@end
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
  で囲まれているように動作します.

- **`-p`**:

  -nフラグとほぼ同じですが, 各ループの最後に変数 [m:$_]
  の値を出力するようになります。

```console title="例"
    % echo matz | ruby -p -e '$_.tr! "a-z", "A-Z"'
    MATZ
```

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
  [m:$VERBOSE]をtrueにセットします。この変数がtrueで
  ある時, いくつかのメソッドは実行時に冗長なメッセージを出力し
  ます。`-v`オプションが指定されて, それ以外の引数がない時には
  バージョンを表示した後, 実行を終了します(標準入力からのスク
  リプトを待たない).

- **`--verbose`**:
  冗長モード。 組み込み変数 [m:$VERBOSE] をtrueにセットします。この変数がtrueで
  ある時, いくつかのメソッドは実行時に冗長なメッセージを出力します。

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

#@since 3.1
#### JIT のオプション (実験的)

- **`--jit`**:

  JITを有効にします。
  YJITが有効な環境ではYJITを、それ以外の環境ではMJITを有効にします。

#### MJIT のオプション (実験的)

- **`--mjit`**:

  デフォルトの設定でMJITを有効にします。

- **`--mjit-[option]`**:

  指定した設定でMJITを有効にします。

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

  キャッシュに残すJITされたメソッドの最大個数を指定します。(デフォルト: 10000)

- **`--mjit-min-calls=num`**:

  JITが起動する呼び出し回数を指定します。(テスト用、デフォルト: 10000)

#### YJIT のオプション (実験的)

- **`--yjit`**:

  デフォルトの設定でYJITを有効にします。

- **`--yjit-[option]`**:

  指定した設定でYJITを有効にします。

- **`--yjit-exec-mem-size=num`**:

  MiB単位で実行可能メモリブロックのサイズを指定します。(デフォルト: 256)

- **`--yjit-call-threshold=num`**:

  JITが起動する呼び出し回数を指定します。(テスト用、デフォルト: 10)

- **`--yjit-max-versions=num`**:

  ベーシックブロックごとのバージョンの最大数を指定します。(デフォルト: 4)

- **`--yjit-greedy-versioning`**:

  貪欲なバージョニングモードを指定します。(デフォルト: disabled)
#@end
#@until 3.1
#### JIT のオプション (実験的)

- **`--jit`**:

  デフォルトの設定でJITを有効にします。

- **`--jit-[option]`**:

  指定した設定でJITを有効にします。

- **`--jit-warnings`**:

  JITの警告の出力を有効にします。

- **`--jit-debug`**:

  JITのデバッグを有効にします。(非常に遅くなります。)

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
#@end

### インタプリタ行の解釈 {#shebang}


コマンドラインに指定したスクリプトが \`#!\` で始まるファイルで、その行に
\`ruby\` という文字列を含まない場合、その行を読み飛ばします。\`#!\` に続く
文字列が \`ruby\` という文字列を含む行を見つけたらその行以下を Ruby スク
リプトとして実行します。

例えば、以下のようなスクリプトを sh で実行すると sh から Ruby を起動できます。

```text
#!/bin/sh
exec ruby -x "$0" "$@"
#!ruby
p ARGV
puts "Hello, World!"
```

これは Ruby をスペースを含むパスにインストールした場合などに有用です。


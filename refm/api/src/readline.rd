GNU Readline によるコマンドライン入力インタフェースを提供するライブラリです。

= module Readline

GNU Readline によるコマンドライン入力インタフェースを提供するモジュールです。

GNU Readline 互換ライブラリのひとつである Edit Line(libedit) もサポートしています。

  * [[url:http://www.gnu.org/directory/readline.html]]
  * [[url:http://www.thrysoee.dk/editline/]]

Readline.readline を使用してユーザからの入力を取得できます。
このとき、 GNU Readline のように入力の補完や
Emacs のようなキー操作などができます。

例: プロンプト"> "を表示して、ユーザからの入力を取得する。

  while buf = Readline.readline("> ", true)
    print("-> ", buf, "\n")
  end

ユーザが入力した内容を履歴(以下、ヒストリ)として記録することができます。
定数 [[m:Readline::HISTORY]] を使用して入力履歴にアクセスできます。
例えば、Readline::HISTORY.to_a により、
全ての入力した内容を文字列の配列として取得できます。

例: ヒストリを配列として取得する。

  while buf = Readline.readline("> ", true)
    p Readline::HISTORY.to_a
    print("-> ", buf, "\n")
  end

== Module Functions

--- readline([prompt, [add_hist]]) -> String | nil

prompt を出力し、ユーザからのキー入力を待ちます。
エンターキーの押下などでユーザが文字列を入力し終えると、
入力した文字列を返します。
このとき、add_hist が true であれば、入力した文字列を入力履歴に追加します。
何も入力していない状態で EOF(UNIX では ^D) を入力するなどで、
ユーザからの入力がない場合は nil を返します。

@param prompt カーソルの前に表示する文字列を指定します。デフォルトは""です。
@param add_hist 真ならば、入力した文字列をヒストリに記録します。デフォルトは偽です。

次の条件を全て満たす場合、例外 IOError が発生します。
  (1) 標準入力が tty でない。
  (2) 標準入力をクローズしている。(isatty(2) の errno が EBADF である。)

本メソッドはスレッドに対応しています。
入力待ち状態のときはスレッドコンテキストの切替えが発生します。

入力時には行内編集が可能で、vi モードと Emacs モードが用意されています。
デフォルトは Emacs モードです。

例: 

  require "readline"

  input = Readline.readline
  (プロンプトなどは表示せずに、入力待ちの状態になります。
   ここでは「abc」を入力後、エンターキーを押したと想定します。)
  abc

  p input # => "abc"

  input = Readline.readline("> ")
  (">"を表示し、入力待ちの状態になります。
   ここでは「ls」を入力後、エンターキーを押したと想定します。)
  > ls

  p input # => "ls"

  input = Readline.readline("> ", true)
  (">"を表示し、入力待ちの状態になります。
   ここでは「cd」を入力後、エンターキーを押したと想定します。)
  > cd

  p input # => "cd"

  input = Readline.readline("> ", true)
  (">"を表示し、入力待ちの状態になります。
   ここで、カーソルの上キー、または ^P を押すと、
   先ほど入力した「cd」が表示されます。
   そして、エンターキーを押したと想定します。)
  > cd

  p input # => "cd"

本メソッドには注意事項があります。
入力待ちの状態で ^C すると ruby インタプリタが終了し、端末状態を復帰しません。
これを回避するための例を2つ挙げます。

例: ^CによるInterrupt例外を補足して、端末状態を復帰する。

  stty_save = `stty -g`.chomp
  begin
    while buf = Readline.readline
        p buf
        end
      rescue Interrupt
        system("stty", stty_save)
        exit
      end
    end
  end

例: INTシグナルを補足して、端末状態を復帰する。

  stty_save = `stty -g`.chomp
  trap("INT") { system "stty", stty_save; exit }

  while buf = Readline.readline
    p buf
  end

また、単に ^C を無視する方法もあります。

  trap("INT", "SIG_IGN")

  while buf = Readline.readline
    p buf
  end

入力履歴 Readline::HISTORY を使用して、次のようなこともできます。

例: 空行や直前の入力と同じ内容は入力履歴に残さない。

  while buf = Readline.readline("> ", true)
    # p Readline::HISTORY.to_a
    Readline::HISTORY.pop if /^\s*$/ =~ buf
 
    begin
      if Readline::HISTORY[Readline::HISTORY.length-2] == buf
        Readline::HISTORY.pop 
      end
    rescue IndexError
    end
 
    # p Readline::HISTORY.to_a
    print "-> ", buf, "\n"
  end

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.vi_editing_mode=]]、[[m:Readline.vi_editing_mode]]、
     [[m:Readline.emacs_editing_mode=]]、[[m:Readline.emacs_editing_mode]]、
     [[m:Readline::HISTORY]]

== Singleton Methods

#@since 1.9.0
--- input=(input) -> input

readline メソッドで使用する入力用の [[c:File]] オブジェクト input を指定します。
戻り値は指定した [[c:File]] オブジェクト input です。

@param input [[c:File]] オブジェクトを指定します。

--- output=(output) -> output

readline メソッドで使用する出力用の [[c:File]] オブジェクト output を指定します。
戻り値は指定した [[c:File]] オブジェクト output です。

@param output [[c:File]] オブジェクトを指定します。
#@end

--- completion_proc=(proc)

ユーザからの入力を補完する時の候補を取得する [[c:Proc]] オブジェクト
proc を指定します。
proc は、次のものを想定しています。
  (1) callメソッドを持つ。callメソッドを持たない場合、例外 ArgumentError を発生します。
  (2) 引数にユーザからの入力文字列を取る。
  (3) 候補の文字列の配列を返す。

@param proc ユーザからの入力を補完する時の候補を取得する [[c:Proc]] オブジェクトを指定します。

#@since 1.8.0
「/var/lib /v」の後で補完を行うと、
デフォルトでは proc の引数に「/v」が渡されます。
このように、ユーザが入力した文字列を
[[m:Readline.completer_word_break_characters]] に含まれる文字で区切ったものを単語とすると、
カーソルがある単語の最初の文字から現在のカーソル位置までの文字列が proc の引数に渡されます。
#@end

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

例: foo、foobar、foobazを補完する。

  require 'readline'

  WORDS = %w(foo foobar foobaz)

  Readline.completion_proc = proc {|word|
      WORDS.grep(/\A#{Regexp.quote word}/)
  }

  while buf = Readline.readline("> ")
    print "-> ", buf, "\n"
  end

@see [[m:Readline.completion_proc=]]

--- completion_proc -> proc

ユーザからの入力を補完する時の候補を取得する [[c:Proc]] オブジェクト
proc を取得します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.completion_proc]]

--- completion_case_fold=(bool)

ユーザの入力を補完する際、大文字と小文字を区別する／しないを指定します。
bool が真ならば区別しません。 bool が偽ならば区別します。
セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@param bool 大文字と小文字を区別する(true)／しない(false)を指定します。

@see [[m:Readline.completion_case_fold]]

--- completion_case_fold -> bool

ユーザの入力を補完する際、大文字と小文字を区別する／しないを取得します。
bool が真ならば区別しません。bool が偽ならば区別します。

なお、Readline.completion_case_fold= メソッドで指定したオブジェクトを
そのまま取得するので、次のような動作をします。

  Readline.completion_case_fold = "This is a String."
  p Readline.completion_case_fold # => "This is a String."

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.completion_case_fold=]]

--- vi_editing_mode

編集モードを vi モードにします。
vi モードの詳細は、GNU Readline のマニュアルを参照してください。

  * [[url:http://www.gnu.org/directory/readline.html]]

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- emacs_editing_mode

編集モードを Emacs モードにします。デフォルトは Emacs モードです。

Emacs モードの詳細は、 GNU Readline のマニュアルを参照してください。

  * [[url:http://www.gnu.org/directory/readline.html]]

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

#@todo 今日(2008/07/24)はここまで

#@since 1.8.0
--- basic_word_break_characters=(s)
--- basic_word_break_characters
#@todo
補完時の単語同士の区切りを指定する basic な文字列。デフォルトでは
Bash用の文字列 " \t\n\"\\'`@$><=;|&{(" (スペース含む)になっています。

--- completer_word_break_characters=(s)
--- completer_word_break_characters
#@todo
rl_complete_internal() で使われる、補完時の単語同士の区切りを指定する
文字列です。デフォルトでは Readline.basic_word_break_characters です。

--- basic_quote_characters=(s)
--- basic_quote_characters
#@todo
引用符を指定します。デフォルトでは、/"'/ です。

--- completer_quote_characters=(s)
--- completer_quote_characters
#@todo
補完時の引用符を指定します。この引用符の間では、completer_word_break_characters
も、普通の文字列として扱われます。

--- filename_quote_characters=(s)
--- filename_quote_characters
#@todo
補完時のファイル名の引用符を指定します。デフォルトでは nil です。
#@end

--- completion_append_character
--- completion_append_character=
#@todo

== Constants

--- FILENAME_COMPLETION_PROC
--- USERNAME_COMPLETION_PROC
#@todo
ライブラリに組み込みで用意された補完用 [[c:Proc]] オブジェクトです。
それぞれファイル名、ユーザ名の補完を行います。
[[m:Readline.completion_proc=]] で使用します。

--- VERSION
#@todo

= object Readline::HISTORY

extend Enumerable

#@todo
Readlineモジュールで入力した内容は入力履歴として記録されます(有効にし
ていればですが。[[m:Readline.#readline]] を参照)

この定数により、入力履歴の内容にアクセスすることができます。おおよそ、
[[c:Array]] クラスのインスタンスのように振舞います。
([[c:Enumerable]] モジュールをextend しています)

  while buf = Readline.readline("> ", true)
    p Readline::HISTORY.to_a
    print "-> ", buf, "\n"
  end

空行や直前の入力と同じ内容は入力履歴に残したくないと思うかも知れません。
この場合、以下のようにします。

  while buf = Readline.readline("> ", true)
    # p Readline::HISTORY.to_a
    Readline::HISTORY.pop if /^\s*$/ =~ buf

    begin
      Readline::HISTORY.pop if Readline::HISTORY[Readline::HISTORY.length-2] == buf
    rescue IndexError
    end

    # p Readline::HISTORY.to_a
    print "-> ", buf, "\n"
  end

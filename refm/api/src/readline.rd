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

--- completion_append_character=(string)

ユーザの入力の補完が完了した場合に、最後に付加する文字 string を指定します。

@param string 1文字を指定します。

半角スペース「" "」などの単語を区切る文字を指定すれば、
連続して入力する際に便利です。

  Readline.readline("> ", true)
  Readline.completion_append_character = " "
  > /var/li
  ここで補完(TABキーを押す)を行う。
  > /var/lib 
  最後に" "が追加されているため、すぐに「/usr」などを入力できる。
  > /var/lib /usr

なお、1文字しか指定することはできないため、
例えば、"string"を指定した場合は最初の文字である"s"だけを使用します。

  Readline.completion_append_character = "string"
  p Readline.completion_append_character # => "s"

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.completion_append_character]]

--- completion_append_character -> string

ユーザの入力の補完が完了した場合に、最後に付加する文字を取得します。

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.completion_append_character=]]

#@since 1.8.0
--- basic_word_break_characters=(string)

ユーザの入力の補完を行う際、
単語の区切りを示す複数の文字で構成される文字列 string を指定します。

@param string 文字列を指定します。

GNU Readline のデフォルト値は、Bash の補完処理で使用している文字列
" \t\n\"\\'`@$><=;|&{(" (スペースを含む) になっています。

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.basic_word_break_characters]]

--- basic_word_break_characters

ユーザの入力の補完を行う際、
単語の区切りを示す複数の文字で構成される文字列を取得します。

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.basic_word_break_characters=]]

--- completer_word_break_characters=(string)

ユーザの入力の補完を行う際、
単語の区切りを示す複数の文字で構成される文字列 string を指定します。
[[m:Readline.basic_word_break_characters=]] との違いは、
GNU Readline の rl_complete_internal 関数で使用されることです。

@param string 文字列を指定します。

GNU Readline のデフォルトの値は、 
[[m:Readline.basic_word_break_characters]] と同じです。

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.completer_word_break_characters]]

--- completer_word_break_characters

ユーザの入力の補完を行う際、
単語の区切りを示す複数の文字で構成された文字列を取得します。
[[m:Readline.basic_word_break_characters]] との違いは、
GNU Readline の rl_complete_internal 関数で使用されることです。

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.completer_word_break_characters=]]

--- basic_quote_characters=(string)

スペースなどの単語の区切りをクオートするための
複数の文字で構成される文字列 string を指定します。

@param string 文字列を指定します。

GNU Readline のデフォルト値は、「"'」です。

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.basic_quote_characters]]

--- basic_quote_characters

スペースなどの単語の区切りをクオートするための
複数の文字で構成される文字列を取得します。

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.basic_quote_characters=]]

--- completer_quote_characters=(string)

ユーザの入力の補完を行う際、スペースなどの単語の区切りを
クオートするための複数の文字で構成される文字列 string を指定します。
指定した文字の間では、[[m:Readline::completer_word_break_characters=]]
で指定した文字列に含まれる文字も、普通の文字列として扱われます。

@param string 文字列を指定します。

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.completer_quote_characters]]

--- completer_quote_characters

ユーザの入力の補完を行う際、スペースなどの単語の区切りを
クオートするための複数の文字で構成される文字列を取得します。

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.completer_quote_characters=]]

--- filename_quote_characters=(string)

ユーザの入力時にファイル名の補完を行う際、スペースなどの単語の区切りを
クオートするための複数の文字で構成される文字列 string を指定します。

@param string 文字列を指定します。

GNU Readline のデフォルト値は nil(NULL) です。

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.filename_quote_characters]]

--- filename_quote_characters

ユーザの入力時にファイル名の補完を行う際、スペースなどの単語の区切りを
クオートするための複数の文字で構成される文字列を取得します。

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Readline.filename_quote_characters=]]
#@end

== Constants

--- VERSION

Readlineモジュールが使用している GNU Readline や liedit のバージョンを
示す文字列です。

--- FILENAME_COMPLETION_PROC

GNU Readline で定義されている関数を使用してファイル名の補完を行うための
[[c:Proc]] オブジェクトです。
[[m:Readline.completion_proc=]] で使用します。

@see [[m:Readline.completion_proc=]]

--- USERNAME_COMPLETION_PROC

GNU Readline で定義されている関数を使用してユーザ名の補完を行うための
[[c:Proc]] オブジェクトです。
[[m:Readline.completion_proc=]] で使用します。

@see [[m:Readline.completion_proc=]]

= object Readline::HISTORY

extend Enumerable

Readline::HISTORY を使用してヒストリにアクセスできます。
[[c:Enumerable]] モジュールを extend しており、
[[c:Array]] クラスのように振る舞うことができます。
例えば、HISTORY[4] により 5 番目に入力した内容を取り出すことができます。

--- to_s -> "HISTORY"

文字列"HISTORY"を返します。

--- [](index) -> string

@param index

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- []=(index, string)

@param index
@param string

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- <<(string) -> self
    
@param string

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- push(*string) -> self

@param string

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- pop -> string

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- shift -> string

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- each -> Enumerable::Enumerator
--- each { |s| }

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- length -> integer

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- empty? -> bool

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- delete_at(index) -> nil

サポートしていない環境では、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

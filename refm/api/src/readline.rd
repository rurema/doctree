category CUI

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

  require 'readline'
  while buf = Readline.readline("> ", true)
    print("-> ", buf, "\n")
  end

ユーザが入力した内容を履歴(以下、ヒストリ)として記録することができます。
定数 [[c:Readline::HISTORY]] を使用して入力履歴にアクセスできます。
例えば、[[c:Readline::HISTORY]].to_a により、
全ての入力した内容を文字列の配列として取得できます。

例: ヒストリを配列として取得する。

  require 'readline'
  while buf = Readline.readline("> ", true)
    p Readline::HISTORY.to_a
    print("-> ", buf, "\n")
  end

== Module Functions

--- readline(prompt = "", add_hist = false) -> String | nil

prompt を出力し、ユーザからのキー入力を待ちます。
エンターキーの押下などでユーザが文字列を入力し終えると、
入力した文字列を返します。
このとき、add_hist が true であれば、入力した文字列を入力履歴に追加します。
何も入力していない状態で EOF(UNIX では ^D) を入力するなどで、
ユーザからの入力がない場合は nil を返します。

本メソッドはスレッドに対応しています。
入力待ち状態のときはスレッドコンテキストの切替えが発生します。

入力時には行内編集が可能で、vi モードと Emacs モードが用意されています。
デフォルトは Emacs モードです。

@param prompt カーソルの前に表示する文字列を指定します。デフォルトは""です。
@param add_hist 真ならば、入力した文字列をヒストリに記録します。デフォルトは偽です。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@raise IOError 標準入力が tty でない、かつ、標準入力をクローズしている
               ([[man:isatty(2)]] の errno が EBADF である。) 場合に発生します。

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

例: ^CによるInterrupt例外を捕捉して、端末状態を復帰する。

  require 'readline'

  stty_save = `stty -g`.chomp
  begin
    while buf = Readline.readline
        p buf
    end
  rescue Interrupt
    system("stty", stty_save)
    exit
  end

例: INTシグナルを捕捉して、端末状態を復帰する。

  require 'readline'

  stty_save = `stty -g`.chomp
  trap("INT") { system "stty", stty_save; exit }

  while buf = Readline.readline
    p buf
  end

また、単に ^C を無視する方法もあります。

  require 'readline'

  trap("INT", "SIG_IGN")

  while buf = Readline.readline
    p buf
  end

入力履歴 Readline::HISTORY を使用して、次のようなこともできます。

例: 空行や直前の入力と同じ内容は入力履歴に残さない。

  require 'readline'

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

@see [[m:Readline.vi_editing_mode]]、[[m:Readline.emacs_editing_mode]]、
     [[c:Readline::HISTORY]]

== Singleton Methods

#@since 1.9.1
--- input=(input)

readline メソッドで使用する入力用の [[c:File]] オブジェクト input を指定します。
戻り値は指定した [[c:File]] オブジェクト input です。

@param input [[c:File]] オブジェクトを指定します。

--- output=(output)

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

#@since 1.8.0
「/var/lib /v」の後で補完を行うと、
デフォルトでは proc の引数に「/v」が渡されます。
このように、ユーザが入力した文字列を
[[m:Readline.completer_word_break_characters]] に含まれる文字で区切ったものを単語とすると、
カーソルがある単語の最初の文字から現在のカーソル位置までの文字列が proc の引数に渡されます。
#@end

@param proc ユーザからの入力を補完する時の候補を取得する [[c:Proc]] オブジェクトを指定します。
#@since 1.9.2
            nil を指定した場合はデフォルトの動作になります。
#@end

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

例: foo、foobar、foobazを補完する。

  require 'readline'

  WORDS = %w(foo foobar foobaz)

  Readline.completion_proc = proc {|word|
      WORDS.grep(/\A#{Regexp.quote word}/)
  }

  while buf = Readline.readline("> ")
    print "-> ", buf, "\n"
  end

@see [[m:Readline.completion_proc]]

--- completion_proc -> Proc

ユーザからの入力を補完する時の候補を取得する [[c:Proc]] オブジェクト
proc を取得します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see [[m:Readline.completion_proc=]]

--- completion_case_fold=(bool)

ユーザの入力を補完する際、大文字と小文字を同一視する／しないを指定します。
bool が真ならば同一視します。bool が偽ならば同一視しません。

@param bool 大文字と小文字を同一視する(true)／しない(false)を指定します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see [[m:Readline.completion_case_fold]]

--- completion_case_fold -> bool

ユーザの入力を補完する際、大文字と小文字を同一視する／しないを取得します。
bool が真ならば同一視します。bool が偽ならば同一視しません。

なお、Readline.completion_case_fold= メソッドで指定したオブジェクトを
そのまま取得するので、次のような動作をします。

  require 'readline'
  Readline.completion_case_fold = "This is a String."
  p Readline.completion_case_fold # => "This is a String."

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see [[m:Readline.completion_case_fold=]]

--- vi_editing_mode -> nil

編集モードを vi モードにします。
vi モードの詳細は、GNU Readline のマニュアルを参照してください。

  * [[url:http://www.gnu.org/directory/readline.html]]

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

--- emacs_editing_mode -> nil

編集モードを Emacs モードにします。デフォルトは Emacs モードです。

Emacs モードの詳細は、 GNU Readline のマニュアルを参照してください。

  * [[url:http://www.gnu.org/directory/readline.html]]

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

--- completion_append_character=(string)

ユーザの入力の補完が完了した場合に、最後に付加する文字 string を指定します。

@param string 1文字を指定します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

半角スペース「" "」などの単語を区切る文字を指定すれば、
連続して入力する際に便利です。

  require 'readline'
  Readline.readline("> ", true)
  Readline.completion_append_character = " "
  > /var/li
  ここで補完(TABキーを押す)を行う。
  > /var/lib
  最後に" "が追加されているため、すぐに「/usr」などを入力できる。
  > /var/lib /usr

なお、1文字しか指定することはできないため、
例えば、"string"を指定した場合は最初の文字である"s"だけを使用します。

  require 'readline'
  Readline.completion_append_character = "string"
  p Readline.completion_append_character # => "s"

@see [[m:Readline.completion_append_character]]

--- completion_append_character -> String

ユーザの入力の補完が完了した場合に、最後に付加する文字を取得します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see [[m:Readline.completion_append_character=]]

#@since 1.8.0
--- basic_word_break_characters=(string)

ユーザの入力の補完を行う際、
単語の区切りを示す複数の文字で構成される文字列 string を指定します。

GNU Readline のデフォルト値は、Bash の補完処理で使用している文字列
" \t\n\"\\'`@$><=;|&{(" (スペースを含む) になっています。

@param string 文字列を指定します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see [[m:Readline.basic_word_break_characters]]

--- basic_word_break_characters -> String

ユーザの入力の補完を行う際、
単語の区切りを示す複数の文字で構成される文字列を取得します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see [[m:Readline.basic_word_break_characters=]]

--- completer_word_break_characters=(string)

ユーザの入力の補完を行う際、
単語の区切りを示す複数の文字で構成される文字列 string を指定します。
[[m:Readline.basic_word_break_characters=]] との違いは、
GNU Readline の rl_complete_internal 関数で使用されることです。

GNU Readline のデフォルトの値は、
[[m:Readline.basic_word_break_characters]] と同じです。

@param string 文字列を指定します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see [[m:Readline.completer_word_break_characters]]

--- completer_word_break_characters -> String

ユーザの入力の補完を行う際、
単語の区切りを示す複数の文字で構成された文字列を取得します。
[[m:Readline.basic_word_break_characters]] との違いは、
GNU Readline の rl_complete_internal 関数で使用されることです。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see [[m:Readline.completer_word_break_characters=]]

--- basic_quote_characters=(string)

スペースなどの単語の区切りをクオートするための
複数の文字で構成される文字列 string を指定します。

GNU Readline のデフォルト値は、「"'」です。

@param string 文字列を指定します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see [[m:Readline.basic_quote_characters]]

--- basic_quote_characters -> String

スペースなどの単語の区切りをクオートするための
複数の文字で構成される文字列を取得します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see [[m:Readline.basic_quote_characters=]]

--- completer_quote_characters=(string)

ユーザの入力の補完を行う際、スペースなどの単語の区切りを
クオートするための複数の文字で構成される文字列 string を指定します。
指定した文字の間では、[[m:Readline.completer_word_break_characters=]]
で指定した文字列に含まれる文字も、普通の文字列として扱われます。

@param string 文字列を指定します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see [[m:Readline.completer_quote_characters]]

--- completer_quote_characters -> String

ユーザの入力の補完を行う際、スペースなどの単語の区切りを
クオートするための複数の文字で構成される文字列を取得します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see [[m:Readline.completer_quote_characters=]]

--- filename_quote_characters=(string)

ユーザの入力時にファイル名の補完を行う際、スペースなどの単語の区切りを
クオートするための複数の文字で構成される文字列 string を指定します。

GNU Readline のデフォルト値は nil(NULL) です。

@param string 文字列を指定します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see [[m:Readline.filename_quote_characters]]

--- filename_quote_characters -> String

ユーザの入力時にファイル名の補完を行う際、スペースなどの単語の区切りを
クオートするための複数の文字で構成される文字列を取得します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see [[m:Readline.filename_quote_characters=]]
#@end

#@since 1.9.2
--- Readline.set_screen_size(rows, columns) -> Readline

端末のサイズを引数 row、columns に設定します。

@param rows 行数を整数で指定します。

@param columns 列数を整数で指定します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see GNU Readline ライブラリの rl_set_screen_size 関数

--- Readline.get_screen_size -> [Integer, Integer]

端末のサイズを [rows, columns] で返します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

@see GNU Readline ライブラリの rl_get_screen_size 関数
#@end

== Constants

--- VERSION -> String

Readlineモジュールが使用している GNU Readline や libedit のバージョンを
示す文字列です。

--- FILENAME_COMPLETION_PROC -> Proc

GNU Readline で定義されている関数を使用してファイル名の補完を行うための
[[c:Proc]] オブジェクトです。
[[m:Readline.completion_proc=]] で使用します。

@see [[m:Readline.completion_proc=]]

--- USERNAME_COMPLETION_PROC -> Proc

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

例:

  require 'readline'
  Readline::HISTORY.to_s #=> "HISTORY"

--- [](index) -> String

ヒストリから index で指定したインデックスの内容を取得します。
例えば index に 0 を指定すると最初の入力内容が取得できます。
また、 -1 は最後の入力内容というように、index に負の値を指定することで、
最後から入力内容を取得することもできます。

@param index 取得対象のヒストリのインデックスを整数で指定します。
             インデックスは [[c:Array]] ように 0 から指定します。
             また、 -1 は最後の入力内容というように、負の数を指定することもできます。

@raise IndexError index で指定したインデックスに該当する入力内容がない場合に発生します。

@raise RangeError index で指定したインデックスが int 型よりも大きな値の場合に発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

例:

  require "readline"

  Readline::HISTORY[0] #=> 最初の入力内容
  Readline::HISTORY[4] #=> 5番目の入力内容
  Readline::HISTORY[-1] #=> 最後の入力内容
  Readline::HISTORY[-5] #=> 最後から5番目の入力内容

例: 1000000 番目の入力内容が存在しない場合、例外 IndexError が発生します。

  require "readline"

  Readline::HISTORY[1000000] #=> 例外 IndexError が発生します。

例: 32 bit のシステムの場合、例外 RangeError が発生します。

  require "readline"

  Readline::HISTORY[2 ** 32 + 1] #=> 例外 RangeError が発生します。

例: 64 bit のシステムの場合、例外 RangeError が発生します。

  require "readline"

  Readline::HISTORY[2 ** 64 + 1] #=> 例外 RangeError が発生します。

--- []=(index, string)

ヒストリの index で指定したインデックスの内容を string で指定した文字列で書き換えます。
例えば index に 0 を指定すると最初の入力内容が書き換えます。
また、 -1 は最後の入力内容というように、index に負の値を指定することで、
最後から入力内容を取得することもできます。
指定した string を返します。

@param index 取得対象のヒストリのインデックスを整数で指定します。
             インデックスは [[c:Array]] ように 0 から指定します。
             また、 -1 は最後の入力内容というように、負の数を指定することもできます。
@param string 文字列を指定します。この文字列でヒストリを書き換えます。

@raise IndexError index で指定したインデックスに該当する入力内容がない場合に発生します。

@raise RangeError index で指定したインデックスが int 型よりも大きな値の場合に発生します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

--- <<(string) -> self

ヒストリの最後に string で指定した文字列を追加します。
self を返します。

@param string 文字列を指定します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

例: "foo"を追加する。

  require "readline"

  Readline::HISTORY << "foo"
  p Readline::HISTORY[-1] #=> "foo"

例: "foo"、"bar"を追加する。

  require "readline"

  Readline::HISTORY << "foo" << "bar"
  p Readline::HISTORY[-1] #=> "bar"
  p Readline::HISTORY[-2] #=> "foo"

@see [[m:Readline::HISTORY.push]]

--- push(*string) -> self

ヒストリの最後に string で指定した文字列を追加します。複数の string を指定できます。
self を返します。

@param string 文字列を指定します。複数指定できます。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

例: "foo"を追加する。

  require "readline"

  Readline::HISTORY.push("foo")
  p Readline::HISTORY[-1] #=> "foo"

例: "foo"、"bar"を追加する。

  require "readline"

  Readline::HISTORY.push("foo", "bar")
  p Readline::HISTORY[-1] #=> "bar"
  p Readline::HISTORY[-2] #=> "foo"

@see [[m:Readline::HISTORY.<<]]

--- pop -> String

ヒストリの最後の内容を取り出します。
最後の内容は、ヒストリから取り除かれます。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

例:

  require "readline"
  
  Readline::HISTORY.push("foo", "bar", "baz")
  p Readline::HISTORY.pop #=> "baz"
  p Readline::HISTORY.pop #=> "bar"
  p Readline::HISTORY.pop #=> "foo"

@see [[m:Readline::HISTORY.push]]、[[m:Readline::HISTORY.shift]]、
     [[m:Readline::HISTORY.delete_at]]

--- shift -> String

ヒストリの最初の内容を取り出します。
最初の内容は、ヒストリから取り除かれます。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

例:

  require "readline"
  
  Readline::HISTORY.push("foo", "bar", "baz")
  p Readline::HISTORY.shift #=> "foo"
  p Readline::HISTORY.shift #=> "bar"
  p Readline::HISTORY.shift #=> "baz"

@see [[m:Readline::HISTORY.push]]、[[m:Readline::HISTORY.pop]]、
     [[m:Readline::HISTORY.delete_at]]

#@since 1.9.1
--- each -> Enumerator
#@end
--- each {|string| ... }

ヒストリの内容に対してブロックを評価します。
ブロックパラメータにはヒストリの最初から最後までの内容を順番に渡します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

例: ヒストリの内容を最初から順番に出力する。

  require "readline"
  
  Readline::HISTORY.push("foo", "bar", "baz")
  Readline::HISTORY.each do |s|
    p s #=> "foo", "bar", "baz"
  end

#@since 1.9.1
例: [[c:Enumerator]] オブジェクトを返す場合。

  require "readline"
  
  Readline::HISTORY.push("foo", "bar", "baz")
  e = Readline::HISTORY.each
  e.each do |s|
    p s #=> "foo", "bar", "baz"
  end
#@end

--- length -> Integer
--- size -> Integer

ヒストリに格納された内容の数を取得します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

例: ヒストリの内容を最初から順番に出力する。

  require "readline"
  
  Readline::HISTORY.push("foo", "bar", "baz")
  p Readline::HISTORY.length #=> 3

@see [[m:Readline::HISTORY.empty?]]

--- empty? -> bool

ヒストリに格納された内容の数が 0 の場合は true を、
そうでない場合は false を返します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

例:

  require "readline"
  
  p Readline::HISTORY.empty? #=> true
  Readline::HISTORY.push("foo", "bar", "baz")
  p Readline::HISTORY.empty? #=> false

@see [[m:Readline::HISTORY.length]]

--- delete_at(index) -> String | nil

index で指定したインデックスの内容をヒストリから削除し、その内容を返します。
該当する index の内容がヒストリになければ、 nil を返します。
index に 0 を指定すると [[m:Readline::HISTORY.shift]]
と同様に最初の入力内容を削除します。
また、 -1 は最後の入力内容というように、index に負の値を指定することで、
最後から入力内容を取得することもできます。
index が -1 の場合は [[m:Readline::HISTORY.pop]] と同様に動作します。

@param index 削除対象のヒストリのインデックスを指定します。

@raise NotImplementedError サポートしていない環境で発生します。

#@until 2.1.0
@raise SecurityError セーフレベル ($SAFE) が 4 の場合に発生します。
#@end

例:

  require "readline"
  
  Readline::HISTORY.push("foo", "bar", "baz")
  Readline::HISTORY.delete_at(1)
  p Readline::HISTORY.to_a #=> ["foo", "baz"]

#@since 1.9.1
--- clear -> self

ヒストリの内容をすべて削除して空にします。

@raise NotImplementedError サポートしていない環境で発生します。
#@end

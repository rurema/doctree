---
library: readline
---
# module Readline

GNU Readline によるコマンドライン入力インタフェースを提供するモジュールです。

GNU Readline 互換ライブラリのひとつである Edit Line(libedit) もサポートしています。

  - [url:https://directory.fsf.org/wiki/Readline]
  - [url:https://thrysoee.dk/editline/]

Readline.readline を使用してユーザからの入力を取得できます。
このとき、 GNU Readline のように入力の補完や
Emacs のようなキー操作などができます。

例: プロンプト"> "を表示して、ユーザからの入力を取得する。

`````
require 'readline'
while buf = Readline.readline("> ", true)
  print("-> ", buf, "\n")
end
`````

ユーザが入力した内容を履歴(以下、ヒストリ)として記録できます。
定数 [c:Readline::HISTORY] を使用して入力履歴にアクセスできます。
例えば、[c:Readline::HISTORY].to_a により、
全ての入力した内容を文字列の配列として取得できます。

例: ヒストリを配列として取得する。

`````
require 'readline'
while buf = Readline.readline("> ", true)
  p Readline::HISTORY.to_a
  print("-> ", buf, "\n")
end
`````

## Module Functions

### module_function def readline(prompt = "", add_hist = false) -> String | nil

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

- **param** `prompt` -- カーソルの前に表示する文字列を指定します。デフォルトは""です。
- **param** `add_hist` -- 真ならば、入力した文字列をヒストリに記録します。デフォルトは偽です。

- **raise** `IOError` -- 標準入力が tty でない、かつ、標準入力をクローズしている
               ([man:isatty(2)] の errno が EBADF である。) 場合に発生します。

例:

`````
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
`````

本メソッドには注意事項があります。
入力待ちの状態で ^C すると ruby インタプリタが終了し、端末状態を復帰しません。
これを回避するための例を2つ挙げます。

例: ^CによるInterrupt例外を捕捉して、端末状態を復帰する。

`````
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
`````

例: INTシグナルを捕捉して、端末状態を復帰する。

`````
require 'readline'

stty_save = `stty -g`.chomp
trap("INT") { system "stty", stty_save; exit }

while buf = Readline.readline
  p buf
end
`````

また、単に ^C を無視する方法もあります。

`````
require 'readline'

trap("INT", "SIG_IGN")

while buf = Readline.readline
  p buf
end
`````

入力履歴 Readline::HISTORY を使用して、次のようなこともできます。

例: 空行や直前の入力と同じ内容は入力履歴に残さない。

`````
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
`````

- **SEE** [m:Readline.vi_editing_mode]、[m:Readline.emacs_editing_mode]、
     [c:Readline::HISTORY]

## Singleton Methods

#@since 1.9.1
### def input=(input)

readline メソッドで使用する入力用の [c:File] オブジェクト input を指定します。
戻り値は指定した [c:File] オブジェクト input です。

- **param** `input` -- [c:File] オブジェクトを指定します。

### def output=(output)

readline メソッドで使用する出力用の [c:File] オブジェクト output を指定します。
戻り値は指定した [c:File] オブジェクト output です。

- **param** `output` -- [c:File] オブジェクトを指定します。
#@end

### def completion_proc=(proc)

ユーザからの入力を補完する時の候補を取得する [c:Proc] オブジェクト
proc を指定します。
proc は、次のものを想定しています。
  1. callメソッドを持つ。callメソッドを持たない場合、例外 ArgumentError を発生します。
  2. 引数にユーザからの入力文字列を取る。
  3. 候補の文字列の配列を返す。

「/var/lib /v」の後で補完を行うと、
デフォルトでは proc の引数に「/v」が渡されます。
このように、ユーザが入力した文字列を
[m:Readline.completer_word_break_characters] に含まれる文字で区切ったものを単語とすると、
カーソルがある単語の最初の文字から現在のカーソル位置までの文字列が proc の引数に渡されます。

- **param** `proc` -- ユーザからの入力を補完する時の候補を取得する [c:Proc] オブジェクトを指定します。
#@since 1.9.2
            nil を指定した場合はデフォルトの動作になります。
#@end

例: foo、foobar、foobazを補完する。

`````
require 'readline'

WORDS = %w(foo foobar foobaz)

Readline.completion_proc = proc {|word|
    WORDS.grep(/\A#{Regexp.quote word}/)
}

while buf = Readline.readline("> ")
  print "-> ", buf, "\n"
end
`````

- **SEE** [m:Readline.completion_proc]

### def completion_proc -> Proc

ユーザからの入力を補完する時の候補を取得する [c:Proc] オブジェクト
proc を取得します。

- **SEE** [m:Readline.completion_proc=]

### def completion_case_fold=(bool)

ユーザの入力を補完する際、大文字と小文字を同一視する／しないを指定します。
bool が真ならば同一視します。bool が偽ならば同一視しません。

- **param** `bool` -- 大文字と小文字を同一視する(true)／しない(false)を指定します。

- **SEE** [m:Readline.completion_case_fold]

### def completion_case_fold -> bool

ユーザの入力を補完する際、大文字と小文字を同一視する／しないを取得します。
bool が真ならば同一視します。bool が偽ならば同一視しません。

なお、Readline.completion_case_fold= メソッドで指定したオブジェクトを
そのまま取得するので、次のような動作をします。

`````
require 'readline'
Readline.completion_case_fold = "This is a String."
p Readline.completion_case_fold # => "This is a String."
`````

- **SEE** [m:Readline.completion_case_fold=]

### def vi_editing_mode -> nil

編集モードを vi モードにします。
vi モードの詳細は、GNU Readline のマニュアルを参照してください。

  - [url:http://www.gnu.org/directory/readline.html]

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

### def emacs_editing_mode -> nil

編集モードを Emacs モードにします。デフォルトは Emacs モードです。

Emacs モードの詳細は、 GNU Readline のマニュアルを参照してください。

  - [url:http://www.gnu.org/directory/readline.html]

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

### def completion_append_character=(string)

ユーザの入力の補完が完了した場合に、最後に付加する文字 string を指定します。

- **param** `string` -- 1文字を指定します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

半角スペース「" "」などの単語を区切る文字を指定すれば、
連続して入力する際に便利です。

`````
require 'readline'
Readline.readline("> ", true)
Readline.completion_append_character = " "
> /var/li
ここで補完(TABキーを押す)を行う。
> /var/lib
最後に" "が追加されているため、すぐに「/usr」などを入力できる。
> /var/lib /usr
`````

なお、1文字しか指定することはできないため、
例えば、"string"を指定した場合は最初の文字である"s"だけを使用します。

`````
require 'readline'
Readline.completion_append_character = "string"
p Readline.completion_append_character # => "s"
`````

- **SEE** [m:Readline.completion_append_character]

### def completion_append_character -> String

ユーザの入力の補完が完了した場合に、最後に付加する文字を取得します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

- **SEE** [m:Readline.completion_append_character=]

### def basic_word_break_characters=(string)

ユーザの入力の補完を行う際、
単語の区切りを示す複数の文字で構成される文字列 string を指定します。

GNU Readline のデフォルト値は、Bash の補完処理で使用している文字列
" \t\n\"\\'\`@$><=;|&{(" (スペースを含む) になっています。

- **param** `string` -- 文字列を指定します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

- **SEE** [m:Readline.basic_word_break_characters]

### def basic_word_break_characters -> String

ユーザの入力の補完を行う際、
単語の区切りを示す複数の文字で構成される文字列を取得します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

- **SEE** [m:Readline.basic_word_break_characters=]

### def completer_word_break_characters=(string)

ユーザの入力の補完を行う際、
単語の区切りを示す複数の文字で構成される文字列 string を指定します。
[m:Readline.basic_word_break_characters=] との違いは、
GNU Readline の rl_complete_internal 関数で使用されることです。

GNU Readline のデフォルトの値は、
[m:Readline.basic_word_break_characters] と同じです。

- **param** `string` -- 文字列を指定します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

- **SEE** [m:Readline.completer_word_break_characters]

### def completer_word_break_characters -> String

ユーザの入力の補完を行う際、
単語の区切りを示す複数の文字で構成された文字列を取得します。
[m:Readline.basic_word_break_characters] との違いは、
GNU Readline の rl_complete_internal 関数で使用されることです。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

- **SEE** [m:Readline.completer_word_break_characters=]

### def basic_quote_characters=(string)

スペースなどの単語の区切りをクオートするための
複数の文字で構成される文字列 string を指定します。

GNU Readline のデフォルト値は、「"'」です。

- **param** `string` -- 文字列を指定します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

- **SEE** [m:Readline.basic_quote_characters]

### def basic_quote_characters -> String

スペースなどの単語の区切りをクオートするための
複数の文字で構成される文字列を取得します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

- **SEE** [m:Readline.basic_quote_characters=]

### def completer_quote_characters=(string)

ユーザの入力の補完を行う際、スペースなどの単語の区切りを
クオートするための複数の文字で構成される文字列 string を指定します。
指定した文字の間では、[m:Readline.completer_word_break_characters=]
で指定した文字列に含まれる文字も、普通の文字列として扱われます。

- **param** `string` -- 文字列を指定します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

- **SEE** [m:Readline.completer_quote_characters]

### def completer_quote_characters -> String

ユーザの入力の補完を行う際、スペースなどの単語の区切りを
クオートするための複数の文字で構成される文字列を取得します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

- **SEE** [m:Readline.completer_quote_characters=]

### def filename_quote_characters=(string)

ユーザの入力時にファイル名の補完を行う際、スペースなどの単語の区切りを
クオートするための複数の文字で構成される文字列 string を指定します。

GNU Readline のデフォルト値は nil(NULL) です。

- **param** `string` -- 文字列を指定します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

- **SEE** [m:Readline.filename_quote_characters]

### def filename_quote_characters -> String

ユーザの入力時にファイル名の補完を行う際、スペースなどの単語の区切りを
クオートするための複数の文字で構成される文字列を取得します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

- **SEE** [m:Readline.filename_quote_characters=]

#@since 1.9.2
### def Readline.set_screen_size(rows, columns) -> Readline

端末のサイズを引数 row、columns に設定します。

- **param** `rows` -- 行数を整数で指定します。

- **param** `columns` -- 列数を整数で指定します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

- **SEE** GNU Readline ライブラリの rl_set_screen_size 関数

### const Readline.get_screen_size -> [Integer, Integer]

端末のサイズを [rows, columns] で返します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

- **SEE** GNU Readline ライブラリの rl_get_screen_size 関数
#@end

## Constants

### const VERSION -> String

Readlineモジュールが使用している GNU Readline や libedit のバージョンを
示す文字列です。

### const FILENAME_COMPLETION_PROC -> Proc

GNU Readline で定義されている関数を使用してファイル名の補完を行うための
[c:Proc] オブジェクトです。
[m:Readline.completion_proc=] で使用します。

- **SEE** [m:Readline.completion_proc=]

### const USERNAME_COMPLETION_PROC -> Proc

GNU Readline で定義されている関数を使用してユーザ名の補完を行うための
[c:Proc] オブジェクトです。
[m:Readline.completion_proc=] で使用します。

- **SEE** [m:Readline.completion_proc=]


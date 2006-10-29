= module Readline
GNU Readline によるコマンドライン入力インタフェースを提供するモジュー
ルです。

=== 備考
* Readline.readline メソッドはスレッドに対応しています。
  入力待ち状態のときはスレッドコンテキストの切替えが発生します。

* [[url:http://www.gnu.org/directory/readline.html]]

#@#=== 履歴
#@#: version 1.8
#@#   * Readline.basic_word_break_characters
#@#   * Readline.completer_word_break_characters
#@#   * Readline.basic_quote_characters
#@#   * Readline.completer_quote_characters
#@#   * Readline.filename_quote_characters
#@#
#@#以上が追加されました。
#@#
#@#: version 1.5 (ruby version 1.6.5?)
#@#   * Readline.completion_append_character が追加されました [[unknown:ruby-ext:01760]]。
#@#
#@#   * [[unknown:ruby-dev:14574]] を提案中

=== 使い方
このようにして使います。

  require "readline"

  while buf = Readline.readline("> ", true)
      print "-> ", buf, "\n"
  end

== Module Functions

--- readline([prompt, [add_hist]])
ユーザからのキー入力を求め、入力した文字列を返します。EOF(UNIX で
は ^D)を入力すると nil を返します。

入力時には行内編集が可能で、vi モードと Emacs モードが用意されています。
([[m:Readline.vi_editing_mode]]、[[m:Readline.emacs_editing_mode]]
を参照)。デフォルトは Emacs モードです。

文字列 prompt を指定するとカーソルの前にこの文字列を表示します。

add_hist が真ならば、入力した文字列はヒストリに記録されます。
Emacs モードなら ^P を入力することで前に入力した文字列を呼び出した
り、[[m:Readline::HISTORY]] モジュールによりヒストリの内容を操作す
ることができます。このデフォルト値は nil です。

: 注意
入力待ちの状態で ^C すると ruby インタプリタもろとも終了し端末状
態を復帰しません。これを回避するには、

    stty_save = `stty -g`.chomp
    begin
      while buf = Readline.readline
          p buf
          end
        rescue Interrupt
          system("stty", stty_save)
          exit
        end

または、

    stty_save = `stty -g`.chomp
    trap("INT") { system "stty", stty_save; exit }

    while buf = Readline.readline
      p buf
    end

などとします。単に、^C を受け付けなくするだけならば以下で十分です。

    trap("INT", "SIG_IGN")

    while buf = Readline.readline
      p buf
    end

== Singleton Methods

--- completion_proc=(proc)
補完時の動作を決定する[[c:Proc]]オブジェクトを指定します。
procは引数に入力文字列を取り、候補文字列の配列を返すようにしてください。

#@since 1.8.0
入力文字列は Readline.completer_word_break_characters に含まれる文字で単語ごとに区切られます。
つまり、それらの文字の直後からカーソルの直前までの文字列が proc の引数に渡されます。
#@end
    require 'readline'

    WORDS = %w(foo foobar foobaz)

    Readline.completion_proc = proc {|word|
        WORDS.grep(/\A#{Regexp.quote word}/)
    }

    while buf = Readline.readline("> ")
      p buf
    end

#@since 1.8.0
--- basic_word_break_characters=()
--- basic_word_break_characters
補完時の単語同士の区切りを指定する basic な文字列。デフォルトでは
Bash用の文字列 " \t\n\"\\'`@$><=;|&{(" (スペース含む)になっています。

--- completer_word_break_characters=()
--- completer_word_break_characters
rl_complete_internal() で使われる、補完時の単語同士の区切りを指定する
文字列です。デフォルトでは Readline.basic_word_break_characters です。

--- basic_quote_characters=()
--- basic_quote_characters
引用符を指定します。デフォルトでは、/"'/ です。

--- completer_quote_characters=()
--- completer_quote_character
補完時の引用符を指定します。この引用符の間では、completer_word_break_characters
も、普通の文字列として扱われます。

--- filename_quote_characters=()
--- filename_quote_characters
補完時のファイル名の引用符を指定します。デフォルトでは nil です。
#@end

--- completion_proc
補完時の動作を決定する[[c:Proc]]オブジェクトを返します。

--- completion_case_fold=()
--- completion_case_fold
入力補完時に大文字／小文字の区別をするかどうかを決定します。
bool が真ならば区別しません。

--- vi_editing_mode
編集モードを vi モードにします。詳細は、GNU Readline のマニュアル
を参照してください。

--- emacs_editing_mode
編集モードを Emacs モードにします。デフォルトは Emacs モードです。

詳細は、GNU Readline のマニュアルを参照してください。

== Constants

--- FILENAME_COMPLETION_PROC
--- USERNAME_COMPLETION_PROC
ライブラリに組み込みで用意された補完用 [[c:Proc]] オブジェクトです。
それぞれファイル名、ユーザ名の補完を行います。
[[m:readline#Readline.completion_proc=]] で使用します。

--- HISTORY
Readlineモジュールで入力した内容は入力履歴として記録されます(有効にし
ていればですが。[[m:readline#Readline.readline]] を参照)

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

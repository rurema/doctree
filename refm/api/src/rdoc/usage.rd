require rdoc/markup/simple_markup
require rdoc/markup/simple_markup/to_flow
#@# require rdoc/ri/ri_formatter
#@# require rdoc/ri/ri_options

プログラムの使い方(RDoc.usage を呼び出したソースファイルの先頭に記述さ
れたコメント)を表示するためのサブライブラリです。

[注意] rdoc/usage ライブラリは 1.9 系では廃止されました。

===[a:usage] 使い方

以下のように実行します。exit_status、section のどちらも省略可能です。

  RDoc.usage(exit_status, section, ...)
  RDoc.usage_no_exit(section, ...)

それぞれの引数は以下のような意味です。

: exit_status

  プログラムの終了ステータスを数値に変換可能なオブジェクトで指定します。
  指定しなかった場合は 0 です。

: section

  見出し部に指定した名前を 1 つ、または複数指定します。指定があれば、そ
  の見出しの部分だけを表示し、指定しなかった場合は全て表示します。見出
  しレベルや名前の大文字、小文字の区別はありません。

=== 使用例

以下のように使用します。実際には RDoc::usage の行を適宜コメントアウトし
て実行してください。

  # Comment block describing usage
  # with (optional) section headings
  #
  # = Summary
  # . . .
  # == Author
  # . . .
  # == Copyright
  # . . .

  require 'rdoc/usage'

  # プログラムの使い方を全て表示し、終了ステータス 0 でプログラムを終了。
  RDoc::usage

  # プログラムの使い方を全て表示し、終了ステータス 99 でプログラムを終
  # 了。
  RDoc::usage(99)

  # 「= Summary」から「== Author」の手前までを表示し、終了ステータス
  # 99 でプログラムを終了。
  RDoc::usage(99, 'Summary')

  # Author、Copyright を表示し、終了ステータス 0 でプログラムを終了。
  RDoc::usage('Author', 'Copyright')

  # Author、Copyright を表示し、プログラムを継続。
  RDoc::usage_no_exit('Author', 'Copyright')

= reopen RDoc

== Singleton Methods

--- usage(*args) -> ()

プログラムの使い方(RDoc.usage を呼び出したソースファイルの先頭に記述さ
れたコメント)を標準出力に表示してプログラムを終了します。

数値に変換可能なオブジェクトを args[0] に指定した場合、終了ステータスを
args[0] で指定した値にします。指定しなかった場合は 0 です。

@param args プログラムの終了ステータスや表示するセクションの指定を
            配列で指定します。詳しくは [[ref:lib:rdoc/usage#usage]] を
            ご覧ください。

--- usage_no_exit(*args) -> ()

プログラムの使い方(RDoc.usage を呼び出したソースファイルの先頭に記述さ
れたコメント)を標準出力に表示します。

@param args 表示するセクションの指定を配列で指定します。詳しくは
            [[ref:lib:rdoc/usage#usage]] をご覧ください。

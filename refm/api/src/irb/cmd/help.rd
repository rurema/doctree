#@# require rdoc/ri/driver
#@# require rdoc/ri/util
require irb/cmd/nop

irb 中の help コマンドのための拡張を定義したサブライブラリです。

このライブラリで定義されているメソッドはユーザが直接使用するものではあ
りません。

= class IRB::ExtendCommand::Help < IRB::ExtendCommand::Nop

irb 中の help コマンドのための拡張を定義したクラスです。

== Instance Methods

--- execute(*names) -> nil

RI から Ruby のドキュメントを参照します。

  irb(main):001:0> help String#match
  ...

@param names 参照したいクラス名やメソッド名などを文字列で指定します。

#@since 1.9.2
names を指定しなかった場合は、RI を対話的なモードで起動します。メソッド
名などを入力する事でドキュメントの検索が行えます。入力のタブ補完をする
事ができます。また、空行を入力する事で irb のプロンプトに戻る事ができま
す。

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
#@end

#@# TODO: RDoc::RI::Driver.new が SystemExit になる場合を追記。

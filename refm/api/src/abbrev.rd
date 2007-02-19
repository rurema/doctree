#@since 1.8.1
与えられた文字列の短縮形を生成するモジュールです。



= module Abbrev

与えられた文字列の短縮形を生成するモジュールです。

=== 例

  require 'abbrev'
  require 'pp'

  pp Abbrev.abbrev(%w[ruby rules]).sort
      # => [["rub", "ruby"],
      #    ["ruby", "ruby"],
      #    ["rul", "rules"],
      #    ["rule", "rules"],
      #    ["rules", "rules"]]

== Module Functions

--- abbrev(words, pattern = nil)
#@todo

words は文字列の配列です。短縮形と元の文字列の配列の配列を返します。
上の例のように短縮形からは必ず元の文字列が一意に決まるようになっています。
もし words に同じ文字列が含まれている場合は
以下のようにその文字列しか返しません。

  pp Abbrev.abbrev(%w[ruby ruby]).sort
      # => [["ruby", "ruby"]]

空白が含まれていても適切に処理します。

  pp Abbrev.abbrev(['ru by']).sort" 
      # => [["r", "ru by"],
      #     ["ru", "ru by"],
      #     ["ru ", "ru by"],
      #     ["ru b", "ru by"],
      #     ["ru by", "ru by"]]



= reopen Array

== Instance Methods

--- abbrev(pattern = nil)
#@todo

[[m:Abbrev.abbrev]](self, pattern) と同じです。

#@end

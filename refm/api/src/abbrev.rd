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

--- abbrev(words, pattern = nil) -> Hash

文字列の配列から一意に決まる短縮形を計算し、
短縮形をキー、元の文字列を値とするハッシュを返します。

第二引数に正規表現を指定すると、words のうちそのパターンにマッチしたものから短縮形を計算します。
第二引数に文字列を指定すると、words のうちその文字列で始まるものから短縮形を計算します。

@param words   元となる文字列の配列。
@param pattern [[c:Regexp]] か [[c:String]] を指定します。

@return 短縮形をキー、元の文字列を値とするハッシュを返します。

  require 'abbrev'
  
  # words に同じ文字列が含まれている場合は
  # 以下のようにその文字列しか返しません。
  pp Abbrev.abbrev(%w[ruby ruby]).sort
      # => [["ruby", "ruby"]]
  
  # 空白が含まれていても適切に処理します。
  pp Abbrev.abbrev(['ru by']).sort
      # => [["r", "ru by"],
      #     ["ru", "ru by"],
      #     ["ru ", "ru by"],
      #     ["ru b", "ru by"],
      #     ["ru by", "ru by"]]
  # sort していない例
  p %w[ruby rubyist].abbrev
    #=> {"ruby"    => "ruby",
    #    "rubyi"   => "rubyist",
    #    "rubyis"  => "rubyist",
    #    "rubyist" => "rubyist"}

= reopen Array

== Instance Methods

--- abbrev(pattern = nil) -> Hash

self が文字列の配列の場合、self から一意に決まる短縮形を計算し、
短縮形をキー、元の文字列を値とするハッシュを返します。

引数に正規表現を指定すると、self のうちそのパターンにマッチしたものから短縮形を計算します。
引数に文字列を指定すると、self のうちその文字列で始まるものから短縮形を計算します。

[[m:Abbrev.#abbrev]](self, pattern) と同じです。

@param pattern [[c:Regexp]] か [[c:String]] を指定します。


  require 'abbrev'
  p %w[ruby rubyist].abbrev
  #=> {"ruby"    => "ruby",
  #    "rubyi"   => "rubyist",
  #    "rubyis"  => "rubyist",
  #    "rubyist" => "rubyist"}

@see [[m:Abbrev.#abbrev]]

#@end

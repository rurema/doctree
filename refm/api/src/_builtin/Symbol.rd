= class Symbol < Object

シンボルを表すクラス。シンボルは任意の文字列と一対一に対応するオブジェ
クトです。Ruby スクリプトからは

  * :symbol
  * 'symbol'.intern

のようにして得られます。リテラルでシンボルを表す場合、`:' の後に
は識別子、メソッド名(`!',`?' などの接尾辞を含む)、変数名
(`$'などの接頭辞を含む)、再定義できる演算子のいずれかに適合する
ものしか書くことはできません(そうでなければ文法エラーになります)。

#@since 1.8.0
例:

  p :"foo#{"bar"}"
    => :foobar
  p :'foo#{"bar"}'
    => :"foo\#{\"bar\"}"
  p %s{foo#{"bar"}}
    => :"foo\#{\"bar\"}"
#@end

== Class Methods

#@since 1.8.0
--- all_symbols

定義済みの全てのシンボルオブジェクトの配列を返します。

例:

  p Symbol.all_symbols  # => [:RUBY_PLATFORM, :RUBY_VERSION, ...]

シンボルの生成はコンパイル時に行われるので以下のようにしても結果に
差はありません。

  a = Symbol.all_symbols
  :foo
  b = Symbol.all_symbols
  p b - a
  # => []
#@end

== Instance Methods

#@since 1.8.0
--- to_sym

self を返します。
#@end

--- id2name()
--- to_s

シンボルに対応する文字列を返します。

逆に、文字列に対応するシンボルを得るには
[[m:String#intern]] を使います。

例:

  p :foo.id2name.intern == :foo
  => true

--- to_i

シンボルに対応する整数を返します。

逆にこの整数から対応するシンボルを得るには
[[m:Fixnum#id2name]] を使って一旦文字列を得る必要が
あります。
#@since 1.8.0
直接シンボルを得るには
[[m:Fixnum#to_sym]] が使えます)
#@end

例:

   id = :foo.to_i
   p id                  # => 8881
   p id.id2name.intern   # => :foo
#@since 1.8.0
   p id.to_sym           # => :foo  (version 1.7)
#@end

Rubyの実装では予約語、変数名、メソッド名などをこの整数で管理してい
ます。オブジェクトに対応する整数([[m:Object#__id__]] で得ら
れます)と Symbol に対応する整数は別のものです。

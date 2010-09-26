コマンドラインのオプションを取り扱うためのライブラリです。

#@include(optparse/optparse-tut)
#@include(optparse/Arguable)
#@include(optparse/OptionParser)

= class OptionParser::ParseError < StandardError

OptionParser の例外クラスの基底クラスです。

== Instance Methods

--- recover(argv) -> Array

argv の先頭に self.args を戻します。

argv を返します。

@return argv を返します。

--- set_option(opt, eq) -> self

#@todo

--- args -> Array

エラーのあったオプションの一覧を配列で返します。

@return エラーのあったオプションの一覧。

--- reason -> String

エラーの内容を文字列で返します。

@return 文字列を返します。

--- reason=(reason)

エラーの内容を指定します。

@param reason 文字列

--- inspect -> String

自身を人間が読みやすい形の文字列表現にして返します。

@return 文字列を返します。

--- message -> String
--- to_s    -> String

標準エラーに出力するメッセージを返します。

@return 文字列を返します。

#@since 1.8.8
--- set_backtrace(array)

#@todo

@see [[m:OptionParser::ParseError.filter_backtrace]]

== Class Methods

--- filter_backtrace(array)

#@todo

#@end

= class OptionParser::AmbiguousOption < OptionParser::ParseError

補完が曖昧にしかできないオプションがあった場合に投げられます。

= class OptionParser::NeedlessArgument < OptionParser::ParseError

引数を取らないはずのオプションに引数が与えられた場合に投げられます。

= class OptionParser::MissingArgument < OptionParser::ParseError

引数が必要なオプションに引数が与えられなかった場合に投げられます。

= class OptionParser::InvalidOption < OptionParser::ParseError

定義されていないオプションが与えられた場合に投げられます。

= class OptionParser::InvalidArgument < OptionParser::ParseError

オプションの引数が指定されたパターンにマッチしない時に投げられます。

= class OptionParser::AmbiguousArgument < OptionParser::ParseError

オプションの引数が曖昧にしか補完できない場合に投げられます。

= redefine Kernel
== Constants
--- ARGV -> Array

Ruby スクリプトに与えられた引数を表す配列です。

[[lib:optparse]] を require することにより、ARGV は
OptionParser::Arguable を [[m:Object#extend]] します。

@see [[c:OptionParser::Arguable]]

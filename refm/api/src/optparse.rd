コマンドラインのオプションを取り扱うためのライブラリです。

#@include(optparse/optparse-tut)
#@include(optparse/Arguable)
#@include(optparse/OptionParser)

= class OptionParser::ParseError < StandardError

OptionParser の例外クラスの基底クラスです。

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
--- ARGV
#@todo
optparse を require することにより、ARGV は 
[[c:OptionParser::Arguable]] を extend します。

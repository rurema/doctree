= class RegexpError < StandardError

正規表現のコンパイルに失敗した場合に発生します。

例:

  Regexp.new("*")
  => in `initialize': invalid regular expression; there's no previous \
     pattern, to which '*' would define cardinality at 1: /*/ (RegexpError)

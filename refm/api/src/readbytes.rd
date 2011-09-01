[[m:IO#readbytes]] を提供するライブラリです。

= reopen IO
== Instance Methods

--- readbytes(size) -> String
[[m:IO#read]] と同様に size バイト読み込みますが、
EOFに到達した時に例外 [[c:EOFError]] を発生させます。

@param size 読み込む長さを整数で指定します。nil を指定した場合は EOF まで読み込みます。

@raise EOFError EOF に到達した場合に発生します。

@raise TruncatedDataError size バイト未満しか読み込めなかった場合に発生します。

= class TruncatedDataError < IOError

[[m:IO#readbytes]] が発生させる例外です。

== Instance Methods

--- data -> String

例外が発生するまでに読み込んだデータを文字列で返します。

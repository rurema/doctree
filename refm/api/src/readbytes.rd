= reopen IO
== Instance Methods

--- readbytes(size)
[[m:IO#read]]と同様にsizeバイト読み込みますが、
EOFに到達した時に例外 [[c:EOFError]] を発生させます。
sizeバイト未満しか読み込めなかった時には
例外 [[c:TruncatedDataError]] を発生させます。

= class TruncatedDataError < IOError

IO#readbytes が発生させる例外

== Instance Methods

--- data
例外が発生するまでに読み込んだデータを文字列で返します。

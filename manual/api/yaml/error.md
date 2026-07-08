YAML 関連のエラーを扱うためのサブライブラリです。

#@# YAML::ERROR_NO_HEADER_NODE などは使用されていないため、省略した。

# class Syck::Error < StandardError

意図しない入力がメソッドに与えられた時などに発生します。

# class Syck::ParseError < Syck::Error

将来のために予約されています。現在は発生しません。

# class Syck::TypeError < StandardError

意図しない入力がメソッドに与えられた時などに発生します。

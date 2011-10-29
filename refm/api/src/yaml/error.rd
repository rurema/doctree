YAML 関連のエラーを扱うためのサブライブラリです。

#@# YAML::ERROR_NO_HEADER_NODE などは使用されていないため、省略した。

#@since 1.9.2
= class Syck::Error < StandardError
#@else
= class YAML::Error < StandardError
#@end

意図しない入力がメソッドに与えられた時などに発生します。

#@since 1.9.2
= class Syck::ParseError < Syck::Error
#@else
= class YAML::ParseError < YAML::Error
#@end

将来のために予約されています。現在は発生しません。

#@since 1.9.2
= class Syck::TypeError < StandardError
#@else
= class YAML::TypeError < StandardError
#@end

意図しない入力がメソッドに与えられた時などに発生します。

require mathn

irb コマンドで実行結果を [[m:Object#inspect]] の代わりに
[[c:Object#to_s]] した結果で表示するためのサブライブラリです。

conf.math_mode か IRB.conf[:MATH_MODE] に true を設定する事で使用できま
す。ただし、inspect_mode が設定されていた場合は inspect_mode が優先され
ます。

このライブラリで定義されているメソッドはユーザが直接使用するものではあ
りません。

= reopen IRB::Context

== Instance Methods

--- math_mode -> bool
--- math?     -> bool

math_mode が有効かどうかを返します。

@see [[m:IRB::Context#inspect?]]

--- math_mode=(opt)

math_mode を有効にするかどうかを指定します。

@param opt math_mode を有効にする場合に true を指定します。

@raise IRB::CantReturnToNormalMode 既に math_mode の状態で opt に
                                   false を指定した場合に発生します。

#@# TODO: nil は指定できるのは問題ないのか確認する。

--- inspect? -> bool

math_mode が有効かどうかを返します。

ただし、inspect_mode が優先されるため、inspect_mode が有効な場合には
false を返します。

@see [[m:IRB::Context#math?]]

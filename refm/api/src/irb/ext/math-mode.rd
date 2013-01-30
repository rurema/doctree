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

@see [[m:IRB::Context#math_mode=]], [[m:IRB::Context#inspect?]]

--- math_mode=(opt)

math_mode を有効にするかどうかを指定します。

.irbrc ファイル中で IRB.conf[:MATH_MODE] を設定する事でも同様の事が行え
ます。

[[lib:mathn]] ライブラリを include するため、math_mode を有効にした後は
無効にする事ができません。

@param opt math_mode を有効にする場合に true を指定します。

#@since 2.0.0
@raise IRB::CantReturnToNormalMode 既に math_mode の状態で opt に
                                   false か nil を指定した場合に発生します。
#@else
@raise IRB::CantReturnToNormalMode 既に math_mode の状態で opt に
                                   false を指定した場合に発生します。
#@end

@see [[m:IRB::Context#math_mode]]

--- inspect? -> bool

[[c:IRB::Context#inspect_mode]] が有効かどうかを返します。

ただし、[[c:IRB::Context#inspect_mode]] が未設定で math_mode が有効な場
合には false を返します。

@see [[m:IRB::Context#math?]]

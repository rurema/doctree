組み込みの [[c:Time]] クラスを拡張します。
日時を表す文字列をパースして [[c:Time]] オブジェクトに変換したり、
逆に [[c:Time]] オブジェクトを RFC などで定められた文字列に
変換する機能を提供します。

 * date-time は [[c:RFC:2822]] で定義されています。
 * HTTP-date は [[c:RFC:2616]] で定義されています。
 * dateTime は XML Schema Part 2: Datatypes (ISO 8601) で定義されています。
 * 文字列から [[c:Time]] オブジェクトへの変換では [[unknown:parsedate]] により様々な形式を扱えます。

= reopen Time

== Class Methods

--- parse(date, now=Time.now)
--- parse(date, now=Time.now) {|year| year}

dateを[[m:parsedate#ParseDate.parsedate]] によって
パースして[[c:Time]]オブジェクトに変換します。

ブロック付きで呼ばれた場合、dateの年はブロックによって変換されます。

//ex{
Time.parse(...) {|y| y < 100 ? (y >= 69 ? y + 1900 : y + 2000) : y}
//}

与えられた時刻に上位の要素がなかったり壊れていた場合、nowの
該当要素が使われます。
下位の要素がなかったり壊れていた場合、最小値(1か0)が使われます。

//ex{
#@# 現在時刻が "Thu Nov 29 14:33:20 GMT 2001" で
#@# タイムゾーンがGMTとすると:
Time.parse("16:30")     #=> Thu Nov 29 16:30:00 GMT 2001
Time.parse("7/23")      #=> Mon Jul 23 00:00:00 GMT 2001
Time.parse("2002/1")    #=> Tue Jan 01 00:00:00 GMT 2002
//}

[[unknown:parsedate]]がdateから情報を取り出せないとき、
または [[c:Time]] クラスが指定された日時を表現できないときに
[[c:ArgumentError]] が発生します。

このメソッドは他のパース用メソッドのフェイルセーフとして
以下のように使用できます:

//emlist{
Time.rfc2822(date) rescue Time.parse(date)
Time.httpdate(date) rescue Time.parse(date)
Time.xmlschema(date) rescue Time.parse(date)
//}

従って [[m:Time.parse]] の失敗はチェックすべきです。

--- rfc2822(date)
--- rfc822(date)

[[c:RFC:2822]]で定義されているdate-timeとしてdateをパースして
[[c:Time]]オブジェクトに変換します。
この形式は[[c:RFC:822]]で定義されて[[c:RFC:1123]]で更新された形式と
同じです。

dateが[[c:RFC:2822]]に準拠していない、または
[[c:Time]]クラスが指定された日時を表現できないときに[[c:ArgumentError]]が
発生します。

--- httpdate(date)

[[c:RFC:2616]]で定義されているHTTP-dateとしてdateをパースして
[[c:Time]]オブジェクトに変換します。

dateが[[c:RFC:2616]]に準拠していない、または
[[c:Time]]クラスが指定された日時を表現できないときに[[c:ArgumentError]]が
発生します。

--- xmlschema(date)
--- iso8601(date)

XML Schema で定義されている dateTime として
date をパースして [[c:Time]] オブジェクトに変換します。

date がISO 8601で定義されている形式に準拠していない、
または [[c:Time]] クラスが指定された日時を表現できないときに
[[c:ArgumentError]] が発生します。

== Instance Methods

--- rfc2822
--- rfc822

[[c:RFC:2822]] で定義されている date-time として表現される
以下の形式の文字列を返します:

//emlist{
day-of-week, DD month-name CCYY hh:mm:ss zone
//}

ただし zone は [+-]hhmm です。

self が UTC time の場合、zone は +0000 になります。

--- httpdate

[[c:RFC:2616]]で定義されているHTTP-dateのrfc1123-dateとして
表現される以下の形式の文字列を返します:

//emlist{
day-of-week, DD month-name CCYY hh:mm:ss GMT
//}

注意: 結果はいつも UTC (GMT) です。

--- xmlschema([fractional_seconds])
--- iso8601([fractional_seconds])

XML Schema で定義されている dateTime として
表現される以下の形式の文字列を返します:

//emlist{
CCYY-MM-DDThh:mm:ssTZD
CCYY-MM-DDThh:mm:ss.sssTZD
//}

ただし TZD は Z または [+-]hh:mm です。

If self is a UTC time, Z is used as TZD.
[+-]hh:mm is used otherwise.

fractional_seconds は小数点以下の秒を指定します。
fractional_seconds のデフォルト値は 0 です。

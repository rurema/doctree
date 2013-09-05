category Date/Time

組み込みの [[c:Time]] クラスを拡張します。
日時を表す文字列をパースして [[c:Time]] オブジェクトに変換したり、
逆に [[c:Time]] オブジェクトを RFC などで定められた文字列に
変換する機能を提供します。

 * date-time は [[RFC:2822]] で定義されています。
 * HTTP-date は [[RFC:2616]] で定義されています。
 * dateTime は XML Schema Part 2: Datatypes (ISO 8601) で定義されています。
 * 文字列から [[c:Time]] オブジェクトへの変換では [[m:Date._parse]] により様々な形式を扱えます。

= reopen Time

== Class Methods

--- parse(date, now = Time.now) -> Time
--- parse(date, now = Time.now) {|year| year } -> Time


date を [[m:Date._parse]] によって
パースして [[c:Time]]オブジェクトに変換します。

ブロック付きで呼ばれた場合、dateの年はブロックによって変換されます。

  Time.parse(...) {|y| y < 100 ? (y >= 69 ? y + 1900 : y + 2000) : y}

与えられた時刻に上位の要素がなかったり壊れていた場合、nowの
該当要素が使われます。
下位の要素がなかったり壊れていた場合、最小値(1か0)が使われます。

@param date [[c:Time]] オブジェクトに変換可能な文字列を指定します。
@param now  現在時刻を[[c:Time]] オブジェクトで指定します。
            デフォルトは[[m:Time.now]]となります。

#@since 1.9.2
@raise ArgumentError dateに空文字列を与えた場合、発生します。
                     なお、1.9.2より前は例外は発生せず、現在時刻を表す
                     Time のインスタンスを返していました。
#@end

  # 現在時刻が "Thu Nov 29 14:33:20 GMT 2001" で
  # タイムゾーンがGMTとすると:
  Time.parse("16:30")     #=> Thu Nov 29 16:30:00 GMT 2001
  Time.parse("7/23")      #=> Mon Jul 23 00:00:00 GMT 2001
  Time.parse("2002/1")    #=> Tue Jan 01 00:00:00 GMT 2002

[[m:Date._parse]]がdateから情報を取り出せないとき、
または [[c:Time]] クラスが指定された日時を表現できないときに
[[c:ArgumentError]] が発生します。

このメソッドは他のパース用メソッドのフェイルセーフとして
以下のように使用できます:

  Time.rfc2822(date) rescue Time.parse(date)
  Time.httpdate(date) rescue Time.parse(date)
  Time.xmlschema(date) rescue Time.parse(date)

従って [[m:Time.parse]] の失敗はチェックすべきです。

--- rfc2822(date) -> Time
--- rfc822(date) -> Time

[[RFC:2822]]で定義されているdate-timeとしてdateをパースして
[[c:Time]]オブジェクトに変換します。
この形式は[[RFC:822]]で定義されて[[RFC:1123]]で更新された形式と
同じです。

dateが[[RFC:2822]]に準拠していない、または
[[c:Time]]クラスが指定された日時を表現できないときに[[c:ArgumentError]]が
発生します。

@param date [[RFC:2822]] で定義されるdate-time として文字列を指定します。

@raise ArgumentError dateが[[RFC:2822]]に準拠していない、または 
                     [[c:Time]]クラスが指定された日時を表現できないときに
                     発生します。

使用例
  require 'time'

  rfc2822_time = 'Sun, 31 Aug 2008 12:08:19 +0900'
  t = Time.rfc2822(rfc2822_time)
  p t.kind_of?(Time) #=> true
  non_rfc2822_time = 'Sun 31 Aug 2008 12:08:19 +0900'

  begin
    p Time.rfc2822(non_rfc2822_time)
  rescue ArgumentError => err
    puts "format err: #{err}"
  end

--- httpdate(date) -> Time

[[RFC:2616]]で定義されているHTTP-dateとしてdateをパースして
[[c:Time]]オブジェクトに変換します。

dateが[[RFC:2616]]に準拠していない、または
[[c:Time]]クラスが指定された日時を表現できないときに[[c:ArgumentError]]が
発生します。

@param date [[RFC:2616]]で定義されているHTTP-dateとしてパースされる文字列を指定します。

@raise ArgumentError dateが[[RFC:2616]]に準拠していない、または [[c:Time]]クラスが指定された日時を表現できないときに発生します。

  require 'time'
  rfc2616_time = 'Sun, 31 Aug 2008 12:34:56 GMT'

  t = Time.httpdate(rfc2616_time)
  p t.kind_of?(Time) #=> true

  non_rfc2616_time = 'San, 31 Aug 2008 12:34:56 GMT'
  begin
    Time.httpdate(non_rfc2616_time)
  rescue ArgumentError => err
    puts err #=>  not RFC 2616 compliant date: "San, 31 Aug 2008 12:34:56 GMT"
  end


--- xmlschema(date) -> Time
--- iso8601(date) -> Time

XML Schema で定義されている dateTime として
date をパースして [[c:Time]] オブジェクトに変換します。

date がISO 8601で定義されている形式に準拠していない、
または [[c:Time]] クラスが指定された日時を表現できないときに
[[c:ArgumentError]] が発生します。

@param date XML Schema で定義されている dateTime として
            パースされる文字列を指定します。

@raise ArgumentError date がISO 8601で定義されている形式に準拠していない、
                     または [[c:Time]] クラスが指定された日時を表現できないとき
                     に発生します。
使用例
  require 'time'

  iso8601_time = '2008-08-31T12:34:56+09:00'
  t = Time.iso8601(iso8601_time)
  p t #=> Sun Aug 31 03:34:56 UTC 2008
  p t.kind_of?(Time) #=> true

  begin
    non_iso8601_time = '2008-08-31A12:34:56+09:00'
    Time.iso8601(non_iso8601_time)
  rescue ArgumentError => err
    puts err #=> invalid date: "2008-08-31A12:34:56+09:00"
  end

#@since 1.9.1
--- strptime(date, format) -> Time
--- strptime(date, format){|y| ... } -> Time
文字列を [[m:Date._strptime]] を用いて [[c:Time]] オブジェクト
に変換します。

  Time.strptime('2001-02-03T04:05:06+09:00', '%Y-%m-%dT%H:%M:%S%z')
  #=> 2001-02-03 06:05:06 +0900

ブロックを渡すと年の部分をブロックによって変換できます。
  Time.strptime('91/5/18 4:13:00', '%Y/%m/%d %T'){|y| 
    if y > 100 then y
    elsif y >= 69 then y + 1900
    else y + 2000
    end
  }
  #=> 1991-05-18 04:13:00 +0900
  
  Time.strptime('01/5/18 4:13:00', '%Y/%m/%d %T'){|y| 
    if y > 100 then y
    elsif y >= 69 then y + 1900
    else y + 2000
    end
  }
  #=>  2001-05-18 04:13:00 +0900

詳しくは [[m:DateTime.strptime]], [[m:Date.strptime]] を見てください。

@param date 時刻を表す文字列
@param format 書式文字列
#@end

== Instance Methods

--- rfc2822 -> String
--- rfc822 -> String

[[RFC:2822]] で定義されている date-time として表現される形式の文字列を
返します。

@return 以下の形式の文字列を返します。
//emlist{
  day-of-week, DD month-name CCYY hh:mm:ss zone
//}
        ただし zone は [+-]hhmm です。
        self が UTC time の場合、zone は +0000 になります。

使用例
  require 'time'

  iso8601_time = '2008-08-31T12:34:56+09:00'
  t = Time.iso8601(iso8601_time)
  p t.rfc2822      #=> "Sun, 31 Aug 2008 03:34:56 -0000"

--- httpdate -> String

[[RFC:2616]] で定義されている HTTP-date の rfc1123-date 形式の文字列を
返します。

@return 以下の形式の文字列を返します。
//emlist{
  day-of-week, DD month-name CCYY hh:mm:ss GMT
//}
        注意: 結果はいつも UTC (GMT) です。

使用例
  require 'time'

  iso8601_time = '2008-08-31T12:34:56+09:00'
  t = Time.iso8601(iso8601_time)
  p t.httpdate     #=> "Sun, 31 Aug 2008 03:34:56 GMT"


--- xmlschema(fractional_seconds = 0) -> String
--- iso8601(fractional_seconds = 0) -> String

XML Schema で定義されている dateTime として
表現される形式の文字列を返します:

@param fractional_seconds 小数点以下の秒の桁数を整数で指定します。
                          省略した場合は0 となります。

@return 以下の形式の文字列を返します。
//emlist{
  CCYY-MM-DDThh:mm:ssTZD
  CCYY-MM-DDThh:mm:ss.sssTZD
//}
        ただし TZD は Z または [+-]hh:mm です。

使用例
  require 'time'

  iso8601_time = '2008-08-31T12:34:56+09:00'
  t = Time.iso8601(iso8601_time)
  p t.xmlschema    #=> "2008-08-31T03:34:56Z"
  p t.xmlschema(9) #=> "2008-08-31T03:34:56.000000000Z"


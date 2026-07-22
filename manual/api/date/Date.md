---
library: date
include:
  - Comparable
---
# class Date < Object

日付だけでなく時刻も扱える [c:Time] も利用できます。

### 簡単なつかいかた

```ruby title="例"
require 'date'

a = Date.new(1993, 2, 24)
b = Date.parse('1993-02-24')
b += 10

p b - a          #=> 10
p b.year         #=> 1993
p b.strftime('%a') #=> "Sat"

yesterday = Date.today - 1
```

### 用語の定義

いくつか用語の定義は、ISO 8601、および JIS X 0301 に基づきます。

#### 暦日付

暦日付は、暦年、暦月、および暦月の中の序数によって
指定される特定の日の日付です。

つまり、ごく当たり前の年月日による日付です。

#### 年間通算日 (年日付)

年間通算日 (年日付) は、暦年、および暦年の中の序数によって指定される
特定の日の日付です。

#### 暦週日付

暦週日付は、暦週と暦年中の序数による日付です。

暦週は、暦年中の序数によって指定される特定の7日の期間であり、月曜から
始まります。その年の第1暦週は、最初の木曜日を含む週とします。これは、
1月4日を含む週と同じです。

#### ユリウス日

ユリウス日は紀元前4713年1月1日 (ユリウス暦) 正午 (グリニッジ平均時) を
暦元とした通日 (経過日数) です。

この文書で、天文学的なユリウス日とは、本来のユリウス日と同じものです。
また、年代学的なユリウス日とは、地方時における零時を一日の始まりとする
流儀です。

この文書で、単に「ユリウス日」といった場合、それは本来のユリウス日でな
く、「年代学的なユリウス日」を意味しています。

#### 修正ユリウス日

修正ユリウス日は西暦1858年11月17日 (グレゴリオ暦) 正子/零時 (協定世界時) を
暦元とした通日 (経過日数) です。

この文書で、天文学的な修正ユリウス日とは、本来の修正ユリウス日と同じも
のです。また、年代学的な修正ユリウス日とは、地方時における零時を一日の
始まりとする流儀です。

この文書で、単に「修正ユリウス日」といった場合、それは本来の修正ユリウ
ス日でなく、「年代学的な修正ユリウス日」を意味しています。

## Constants

### const ENGLAND -> Integer

英国がグレゴリオ暦をつかい始めた日 (1752年9月14日) をあらわすユリウス日です。
この "ENGLAND" の名前は、旧い UNIX の [man:cal(1)] の記述に由来します。

- **SEE** <https://web.archive.org/web/20240119232540/https://www.bell-labs.com/usr/dmr/www/pdfs/man61.pdf>

ちなみに、本実装で英国の改暦日を尊重する姿勢がみられるのは前実装からの影響です。
前実装が英国の改暦日を尊重していたのは、おそらく [man:cal(1)] の影響です。
もっとも本実装で一番に尊重されているのは、伊国の改暦日であり、多くの場合、
改暦日の既定値は [m:Date::ITALY] です。

### const GREGORIAN -> Date::Infinity

常にグレゴリオ暦であることを示します。
改暦日は無限の過去にあると考えられます。

### const ITALY -> Integer

伊国がグレゴリオ暦をつかい始めた日 (1582年10月15日) をあらわすユリウス日です。

### const JULIAN -> Date::Infinity

常にユリウス暦であることを示します。
改暦日は無限の未来にあると考えられます。

## Class Methods

### def civil(year = -4712, mon = 1, mday = 1, start = Date::ITALY) -> Date
### def new(year = -4712, mon = 1, mday = 1, start = Date::ITALY) -> Date

暦日付に相当する日付オブジェクトを生成します。

このクラスでは、紀元前の年を天文学の流儀で勘定します。
1年の前は零年、零年の前は-1年、のようにします。
月、および月の日は負、
または正の数でなければなりません (負のときは最後からの序数)。
零であってはなりません。

最後の引数は、グレゴリオ暦をつかい始めた日をあらわすユリウス日です。
省略した場合は、[m:Date::ITALY] (1582年10月15日) になります。

[m:Date.jd] も参照してください。

- **param** `year` -- 年
- **param** `mon` -- 月
- **param** `mday` -- 日
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日
- **raise** `Date::Error` -- 正しくない日付になる組み合わせである場合に発生します。

```ruby title="例"
require 'date'
p Date.new(2017, 9, 20)  # => #<Date: 2017-09-20 ...>
```

### def commercial(cwyear = -4712, cweek = 1, cwday = 1, start = Date::ITALY) -> Date

暦週日付に相当する日付オブジェクトを生成します。

週、および週の日 (曜日) は負、
または正の数でなければなりません(負のときは最後からの序数)。
零であってはなりません。

このメソッドに改暦前の日付を与えることはできません。

[m:Date.jd]、および [m:Date.new] も参照してください。

- **param** `cwyear` -- 年
- **param** `cweek` -- 週
- **param** `cwday` -- 週の日 (曜日)
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日
- **raise** `Date::Error` -- 正しくない日付になる組み合わせである場合に発生します。

### def gregorian_leap? (year) -> bool
### def leap? (year) -> bool

グレゴリオ暦の閏年なら真を返します。

- **param** `year` -- 年

#@# exp
### def _httpdate(str) -> Hash

このメソッドは [m:Date.httpdate] と似ていますが、日付オブジェクトを生成せずに、
見いだした要素をハッシュで返します。

[m:Date.httpdate] も参照してください。

- **param** `str` -- 日付をあらわす文字列

### def httpdate(str = 'Mon, 01 Jan -4712 00:00:00 GMT', start = Date::ITALY) -> Date

[RFC:2616] で定められた書式の日付を解析し、
その情報に基づいて日付オブジェクトを生成します。

[m:Date._httpdate] も参照してください。

- **param** `str` -- 日付をあらわす文字列
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日

#@# exp
### def _iso8601(str) -> Hash

このメソッドは [m:Date.iso8601] と似ていますが、日付オブジェクトを生成せずに、
見いだした要素をハッシュで返します。

[m:Date.iso8601] も参照してください。

- **param** `str` -- 日付をあらわす文字列

### def iso8601(str = '-4712-01-01', start = Date::ITALY) -> Date

いくつかの代表的な ISO 8601 書式の日付を解析し、
その情報に基づいて日付オブジェクトを生成します。

- **param** `str` -- 日付をあらわす文字列

[m:Date._iso8601] も参照してください。

- **param** `str` -- 日付をあらわす文字列
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日

#@# exp
### def _jisx0301(str) -> Hash

このメソッドは [m:Date.jisx0301] と似ていますが、日付オブジェクトを生成せずに、
見いだした要素をハッシュで返します。

[m:Date.jisx0301] も参照してください。

- **param** `str` -- 日付をあらわす文字列

### def jisx0301(str = '-4712-01-01', start = Date::ITALY) -> Date

いくつかの代表的な JIS X 0301 書式の日付を解析し、
その情報に基づいて日付オブジェクトを生成します。

[m:Date._jisx0301] も参照してください。

- **param** `str` -- 日付をあらわす文字列
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日

### def jd(jd = 0, start = Date::ITALY) -> Date

ユリウス日に相当する日付オブジェクトを生成します。

このクラスのいくつかの重要なメソッドで、
負のユリウス日は保証されません。

[m:Date.new] も参照してください。

- **param** `jd` -- ユリウス日
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日

### def julian_leap? (year) -> bool

ユリウス暦の閏年なら真を返します。

西暦4年は真になりますが、
これは歴史的には正しくありません。

- **param** `year` -- 年

### def ordinal(year = -4712, yday = 1, start = Date::ITALY) -> Date

年間通算日 (年日付) に相当する日付オブジェクトを生成します。

年の日は負、
または正の数でなければなりません (負のときは最後からの序数)。
零であってはなりません。

[m:Date.jd]、および [m:Date.new] も参照してください。

- **param** `year` -- 年
- **param** `yday` -- 年の日
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日
- **raise** `Date::Error` -- 正しくない日付になる組み合わせである場合に発生します。

### def _parse(str, complete = true) -> Hash

このメソッドは [m:Date.parse] と似ていますが、日付オブジェクトを生成せずに、
見いだした要素をハッシュで返します。

[m:Date.parse] も参照してください。

- **param** `str` -- 日付をあらわす文字列
- **param** `complete` -- 年を補完するか

### def parse(str = '-4712-01-01', complete = true, start = Date::ITALY) -> Date

与えられた日付表現を解析し、
その情報に基づいて日付オブジェクトを生成します。

年が "00" から "99" の範囲であれば、
年の下2桁表現であるとみなしこれを補います。
この振舞いを抑止したい場合は、ヒントとして、complete に false を与えます。

[m:Date._parse] も参照してください。

- **param** `str` -- 日付をあらわす文字列
- **param** `complete` -- 年を補完するか
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日
- **raise** `Date::Error` -- 正しくない日付になる組み合わせである場合に発生します。

#@# exp
### def _rfc2822(str) -> Hash
### def _rfc822(str) -> Hash

このメソッドは [m:Date.rfc2822] と似ていますが、日付オブジェクトを生成せずに、
見いだした要素をハッシュで返します。

[m:Date.rfc2822] も参照してください。

- **param** `str` -- 日付をあらわす文字列

### def rfc2822(str = 'Mon, 1 Jan -4712 00:00:00 +0000', start = Date::ITALY) -> Date
### def rfc822(str = 'Mon, 1 Jan -4712 00:00:00 +0000', start = Date::ITALY) -> Date

[RFC:2822] で定められた書式の日付を解析し、
その情報に基づいて日付オブジェクトを生成します。

[m:Date._rfc2822] も参照してください。

- **param** `str` -- 日付をあらわす文字列
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日

#@# exp
### def _rfc3339(str) -> Hash

このメソッドは [m:Date.rfc3339] と似ていますが、日付オブジェクトを生成せずに、
見いだした要素をハッシュで返します。

[m:Date.rfc3339] も参照してください。

- **param** `str` -- 日付をあらわす文字列

### def rfc3339(str = '-4712-01-01T00:00:00+00:00', start = Date::ITALY) -> Date

[RFC:3339] 書式の日付を解析し、
その情報に基づいて日付オブジェクトを生成します。

[m:Date._rfc3339] も参照してください。

- **param** `str` -- 日付をあらわす文字列
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日

### def _strptime(str, format = '%F') -> Hash

このメソッドは [m:Date.strptime] と似ていますが、日付オブジェクトを生成せずに、
見いだした要素をハッシュで返します。

- **param** `str` -- 日付をあらわす文字列
- **param** `format` -- 書式文字列

書式文字列に使用できるものは以下の通りです。

  - %A: 曜日の名称(Sunday, Monday ... )
  - %a: 曜日の省略名(Sun, Mon ... )
  - %B: 月の名称(January, February ... )
  - %b: 月の省略名(Jan, Feb ... )
  - %C: 世紀 (2009年であれば 20)
  - %c: 日付と時刻 (%a %b %e %T %Y)
  - %D: 日付 (%m/%d/%y)
  - %d: 日(01-31)
  - %e: 日。一桁の場合、半角空白で埋める ( 1..31)
  - %F: %Y-%m-%d と同等 (ISO 8601の日付フォーマット)
  - %H: 24時間制の時(00-23)
  - %h: %b と同等
  - %I: 12時間制の時(01-12)
  - %j: 年中の通算日(001-366)
  - %k: 24時間制の時。一桁の場合、半角空白で埋める ( 0..23)
  - %L: ミリ秒 (000..999)
  - %l: 12時間制の時。一桁の場合、半角空白で埋める ( 0..12)
  - %M: 分(00-59)
  - %m: 月を表す数字(01-12)
  - %n: 改行 (\n)
  - %N: 秒の小数点以下
  - %P: 午前または午後(am,pm)
  - %p: 午前または午後(AM,PM)
  - %Q: 1970-01-01 00:00:00 UTC からの経過ミリ秒
  - %R: 24時間制の時刻。%H:%M と同等。
  - %r: 12時間制の時刻。%I:%M:%S %p と同等。
  - %S: 秒(00-60) (60はうるう秒)
  - %s: 1970-01-01 00:00:00 UTC からの経過秒
  - %T: 24時間制の時刻。%H:%M:%S と同等。
  - %t: タブ文字 (\t)
  - %U: 週を表す数。最初の日曜日が第1週の始まり(00-53)
  - %u: 月曜日を1とした、曜日の数値表現 (1..7)
  - %V: ISO 8601形式の暦週 (01..53)
  - %v: VMS形式の日付 (%e-%b-%Y)
  - %W: 週を表す数。最初の月曜日が第1週の始まり(00-53)
  - %w: 曜日を表す数。日曜日が0(0-6)
  - %X: 時刻 (%Tと同等)
  - %x: 日付 (%Dと同等)
  - %Y: 西暦を表す数
  - %y: 西暦の下2桁(00-99)
  - %z: タイムゾーン。UTCからのオフセット (例 +0900)
  - %:z: タイムゾーン。コロンが入ったUTCからのオフセット (例 +09:00)
  - %::z: タイムゾーン。コロンが入った秒まで含むUTCからのオフセット (例 +09:00:00)
  - %Z: タイムゾーン名
  - %%: %自身
  - %+: [man:date(1)]の形式 (%a %b %e %H:%M:%S %Z %Y)

### def strptime(str = '-4712-01-01', format = '%F', start = Date::ITALY) -> Date

与えられた雛型で日付表現を解析し、
その情報に基づいて日付オブジェクトを生成します。

[m:Date._strptime] も参照してください。
また [man:strptime(3)]、および [m:Date#strftime] も参照してください。

- **param** `str` -- 日付をあらわす文字列
- **param** `format` -- 書式
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日
- **raise** `Date::Error` -- 正しくない日付になる組み合わせである場合に発生します。

### def today(start = Date::ITALY) -> Date

現在の日付に相当する日付オブジェクトを生成します。

- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日

```ruby title="例"
require 'date'
p Date.today  # => #<Date: 2017-09-20 ...>
```

### def valid_civil? (year, mon, mday, start = Date::GREGORIAN) -> bool
### def valid_date? (year, mon, mday, start = Date::GREGORIAN) -> bool

正しい暦日付であれば真、そうでないなら偽を返します。

[m:Date.jd]、および [m:Date.civil] も参照してください。

- **param** `year` -- 年
- **param** `mon` -- 月
- **param** `mday` -- 日
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日

### def valid_commercial? (cwyear, cweek, cwday, start = Date::GREGORIAN) -> bool

正しい暦週日付であれば真、そうでないなら偽を返します。

[m:Date.jd]、および [m:Date.commercial] も参照してください。

- **param** `cwyear` -- 年
- **param** `cweek` -- 週
- **param** `cwday` -- 週の日 (曜日)
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日

### def valid_jd? (jd, start = Date::GREGORIAN) -> bool

真を返します。

対称性のため用意されていますが、実際的に意味はありません。

[m:Date.jd] も参照してください。

- **param** `jd` -- ユリウス日
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日

### def valid_ordinal? (year, yday, start = Date::GREGORIAN) -> bool

正しい年間通算日 (年日付) であれば真、そうでないなら偽を返します。

[m:Date.jd]、および [m:Date.ordinal] も参照してください。

- **param** `year` -- 年
- **param** `yday` -- 年の日
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日

#@# exp
### def _xmlschema(str) -> Hash

このメソッドは [m:Date.xmlschema] と似ていますが、日付オブジェクトを生成せずに、
見いだした要素をハッシュで返します。

[m:Date.xmlschema] も参照してください。

- **param** `str` -- 日付をあらわす文字列

### def xmlschema(str = '-4712-01-01', start = Date::ITALY) -> Date

XML Schema による書式の日付を解析し、
その情報に基づいて日付オブジェクトを生成します。

[m:Date._xmlschema] も参照してください。

- **param** `str` -- 日付をあらわす文字列
- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日

## Instance Methods

### def + (n) -> Date

self から n 日後の日付オブジェクトを返します。
n は数値でなければなりません。

- **param** `n` -- 日数
- **raise** `TypeError` -- n が数値でない場合に発生します。

### def - (x) -> Rational | Date

x が日付オブジェクトなら、ふたつの差を [c:Rational] で返します。単位は日です。
あるいは
x が数値ならば、self より x 日前の日付を返します。

- **param** `x` -- 日数、あるいは日付オブジェクト
- **raise** `TypeError` -- x が数値でも日付オブジェクトでもない場合に発生します。

### def << (n) -> Date

self より n ヶ月前の日付オブジェクトを返します。
n は数値でなければなりません。

```ruby
require 'date'
p Date.new(2001,2,3)  <<  1 #=> #<Date: 2001-01-03 ...>
p Date.new(2001,2,3)  << -2 #=> #<Date: 2001-04-03 ...>
```

対応する月に同じ日が存在しない時は、代わりにその月の末日が使われます。

```ruby
require 'date'
p Date.new(2001,3,28) << 1 #=> #<Date: 2001-02-28 ...>
p Date.new(2001,3,31) << 1 #=> #<Date: 2001-02-28 ...>
```

このことは以下のように、もしかすると予期しない振る舞いをするかもしれません。

```ruby
require 'date'
p Date.new(2001,3,31) << 2       #=> #<Date: 2001-01-31 ...>
p Date.new(2001,3,31) << 1 << 1  #=> #<Date: 2001-01-28 ...>

p Date.new(2001,3,31) << 1 << -1 #=> #<Date: 2001-03-28 ...>
```

[m:Date#prev_month] も参照してください。

- **param** `n` -- 月数

### def <=> (other) -> -1 | 0 | 1 | nil

二つの日付を比較します。
同じ日付なら 0 を、self が other よりあとの日付なら 1 を、
その逆なら -1 を返します。

other は日付オブジェクトか、
天文学的なユリウス日をあらわす数値を指定します。
そうでない場合、比較ができないので nil を返します。

```ruby
require "date"

p Date.new(2001, 2, 3) <=> Date.new(2001, 2, 4) # => -1
p Date.new(2001, 2, 3) <=> Date.new(2001, 2, 3) # => 0
p Date.new(2001, 2, 3) <=> Date.new(2001, 2, 2) # => 1
p Date.new(2001, 2, 3) <=> Object.new           # => nil
p Date.new(2001, 2, 3) <=> 4903887/2r           # => 0
```

- **param** `other` -- 日付オブジェクトまたは数値

### def === (other) -> bool

同じ日なら真を返します。

- **param** `other` -- 日付オブジェクト

### def >> (n) -> Date

self から n ヶ月後の日付オブジェクトを返します。
n は数値でなければなりません。

```ruby
require 'date'
p Date.new(2001,2,3)  >>  1 #=> #<Date: 2001-03-03 ...>
p Date.new(2001,2,3)  >> -2 #=> #<Date: 2000-12-03 ...>
```

対応する月に同じ日が存在しない時は、代わりにその月の末日が使われます。

```ruby
require 'date'
p Date.new(2001,1,28) >> 1 #=> #<Date: 2001-02-28 ...>
p Date.new(2001,1,31) >> 1 #=> #<Date: 2001-02-28 ...>
```

このことは以下のように、もしかすると予期しない振る舞いをするかもしれません。

```ruby
require 'date'
p Date.new(2001,1,31) >> 2       #=> #<Date: 2001-03-31 ...>
p Date.new(2001,1,31) >> 1 >> 1  #=> #<Date: 2001-03-28 ...>

p Date.new(2001,1,31) >> 1 >> -1 #=> #<Date: 2001-01-28 ...>
```

[m:Date#next_month] も参照してください。

- **param** `n` -- 月数

### def ajd -> Rational

このメソッドは [m:Date#jd] と似ていますが、天文学的なユリウス日を返します。
時刻を含みます。

### def amjd -> Rational

このメソッドは [m:Date#mjd] と似ていますが、天文学的な修正ユリウス日を返します。
時刻を含みます。

### def asctime -> String
### def ctime -> String

[man:asctime(3)] 書式の文字列を返します (ただし、末尾の "\n\0" は除く)。

### def cwday -> Integer

暦週の日 (曜日) を返します (1-7、月曜は1)。

### def cweek -> Integer

暦週を返します (1-53)。

### def cwyear -> Integer

暦週における年を返します。

### def downto(min){|date| ...} -> self
### def downto(min) -> Enumerator

このメソッドは、step(min, -1){|date| ...} と等価です。

- **param** `min` -- 日付オブジェクト

- **SEE** [m:Date#step], [m:Date#upto]

### def england -> Date

このメソッドは、new_start(Date::ENGLAND) と等価です。

[m:Date#new_start]、および [m:Date::ENGLAND] を参照してください。

### def friday? -> bool

金曜日なら真を返します。

### def gregorian -> Date

このメソッドは、new_start(Date::GREGORIAN) と等価です。

[m:Date#new_start]、および [m:Date::GREGORIAN] を参照してください。

### def gregorian? -> bool

グレゴリオ暦なら真を返します。

#@# exp
### def httpdate -> String

[RFC:2616] ([RFC:1123]) で定められた書式の文字列を返します。

### def iso8601 -> String

ISO 8601 書式の文字列を返します (拡大表記はつかいません)。
[m:Date#strftime] に `'%Y-%m-%d'` を指定した場合と同様、時刻を含まない日付のみの文字列になります。

```ruby title="例"
p Date.new(2001, 2, 3).iso8601 # => "2001-02-03"
```

- **SEE** [m:Date#rfc3339]

### def italy -> Date

このメソッドは、new_start(Date::ITALY) と等価です。

[m:Date#new_start]、および [m:Date::ITALY] を参照してください。

### def jd -> Integer

ユリウス日を返します。
時刻を含みません。

[m:Date#ajd] も参照してください。

### def jisx0301 -> String

JIS X 0301 書式の文字列を返します。
ただし、明治以前については ISO 8601 書式になります。
なお、明治6年以前についても太陰太陽暦を使用することはありません。

### def julian -> Date

このメソッドは、new_start(Date::JULIAN) と等価です。

[m:Date#new_start]、および [m:Date::JULIAN] を参照してください。

### def julian? -> bool

ユリウス暦なら真を返します。

### def ld -> Integer

リリウス日を返します。

### def leap? -> bool

閏年なら真を返します。

### def mday -> Integer
### def day -> Integer

月の日を返します (1-31)。

### def mjd -> Integer

修正ユリウス日を返します。
時刻の情報を含みません。

[m:Date#amjd] も参照してください。

### def mon -> Integer
### def month -> Integer

月を返します (1-12)。

### def monday? -> bool

月曜日なら真を返します。

### def new_start(start = Date::ITALY) -> Date

self を複製して、その改暦日を設定しなおします。
引数を省略した場合は、[m:Date::ITALY] (1582年10月15日) になります。

[m:Date.new] も参照してください。

- **param** `start` -- グレゴリオ暦をつかい始めた日をあらわすユリウス日

### def next_day(n = 1) -> Date

n 日後を返します。

[m:Date#succ] も参照してください。

- **param** `n` -- 日数

### def next_month(n = 1) -> Date

n ヶ月後を返します。

[m:Date#>>] も参照してください。

- **param** `n` -- 月数

### def next_year(n = 1) -> Date

n 年後を返します。

self >> (n * 12) に相当します。

```ruby title="例"
require 'date'
p Date.new(2001,2,3).next_year    #=> #<Date: 2002-02-03 ...>
p Date.new(2008,2,29).next_year   #=> #<Date: 2009-02-28 ...>
p Date.new(2008,2,29).next_year(4)  #=> #<Date: 2012-02-29 ...>
```

[m:Date#>>] も参照してください。

- **param** `n` -- 年数

### def prev_day(n = 1) -> Date

n 日前を返します。

- **param** `n` -- 日数

### def prev_month(n = 1) -> Date

n ヶ月前を返します。

[m:Date#<<] も参照してください。

- **param** `n` -- 月数

### def prev_year(n = 1) -> Date

n 年前を返します。

self << (n * 12) に相当します。

```ruby title="例"
require 'date'
p Date.new(2001,2,3).prev_year    #=> #<Date: 2000-02-03 ...>
p Date.new(2008,2,29).prev_year   #=> #<Date: 2007-02-28 ...>
p Date.new(2008,2,29).prev_year(4)  #=> #<Date: 2004-02-29 ...>
```

[m:Date#<<] も参照してください。

- **param** `n` -- 年数

### def rfc2822 -> String
### def rfc822 -> String

[RFC:2822] で定められた書式の文字列を返します。

### def rfc3339 -> String

[RFC:3339] 書式の文字列を返します。
[m:Date#strftime] に `'%FT%T%:z'` を指定した場合と同様、時刻・タイムゾーンを含む文字列になります
(時刻は 00:00:00 固定です)。

```ruby title="例"
p Date.new(2001, 2, 3).rfc3339 # => "2001-02-03T00:00:00+00:00"
```

- **SEE** [m:Date#iso8601]

### def saturday? -> bool

土曜日なら真を返します。

### def start -> Integer

改暦日をあらわすユリウス日を返します。

[m:Date.new] も参照してください。

### def step(limit, step = 1){|date| ...} -> self
### def step(limit, step = 1) -> Enumerator

ブロックの評価を繰り返します。ブロックは日付オブジェクトをとります。
limit は日付オブジェクトでなければなりません、
また step は非零でなければなりません。

- **param** `limit` -- 日付オブジェクト
- **param** `step` -- 歩幅

- **SEE** [m:Date#downto], [m:Date#upto]

### def sunday? -> bool

日曜日なら真を返します。

### def strftime(format = '%F') -> String

与えられた雛型で日付を書式づけます。

つぎの変換仕様をあつかいます:

%A, %a, %B, %b, %C, %c, %D, %d, %e, %F, %G, %g, %H, %h, %I, %j, %k, %L, %l,
%M, %m, %N, %n, %P, %p, %Q, %R, %r, %S, %s, %T, %t, %U, %u, %V, %v, %W, %w, %X,
%x, %Y, %y, %Z, %z, %:z, %::z, %:::z, %%, %+

GNU 版にあるような幅指定などもできます。
#@# %[123]?

[man:strftime(3)]、および [m:Date.strptime] も参照してください。

- **param** `format` -- 書式

### def succ -> Date
### def next -> Date

翌日の日付オブジェクトを返します。

### def thursday? -> bool

木曜日なら真を返します。

### def to_date -> self

self を返します。

### def to_datetime -> DateTime

対応する [c:DateTime] オブジェクトを返します。

### def to_s -> String

ISO 8601 書式の文字列を返します (拡大表記 ('%Y-%m-%d') を使います)。

### def to_time -> Time

対応する [c:Time] オブジェクトを返します。

### def tuesday? -> bool

火曜日なら真を返します。

### def upto(max){|date| ...} -> self
### def upto(max) -> Enumerator

このメソッドは、step(max, 1){|date| ...} と等価です。

- **param** `max` -- 日付オブジェクト

- **SEE** [m:Date#step], [m:Date#downto]

### def wday -> Integer

曜日を返します (0-6、日曜日は零)。

### def wednesday? -> bool

水曜日なら真を返します。

#@# exp
### def xmlschema -> String

XML Scheme (date) による書式の文字列を返します。

### def yday -> Integer

年の日を返します (1-366)。

### def year -> Integer

年を返します。

#@since 3.2
### def deconstruct_keys(array_of_names_or_nil) -> Hash

パターンマッチに使用する名前と値の [c:Hash] を返します。

キーに利用できる名前は以下の通りです。

  - :year
  - :month
  - :day
  - :yday
  - :wday

- **param** `array_of_names_or_nil` -- パターンマッチに使用する名前の配列を指定します。nil の場合は全てをパターンマッチに使用します。

```ruby title="例"
d = Date.new(2022, 10, 5)

if d in wday: 3, day: ..7 # deconstruct_keys が使われます
  puts "first Wednesday of the month"
end
#=> "first Wednesday of the month" が出力される

case d
in year: ...2022
  puts "too old"
in month: ..9
  puts "quarter 1-3"
in wday: 1..5, month:
  puts "working day in month #{month}"
end
#=> "working day in month 10" が出力される

# クラスのチェックと組み合わせて利用することもできます
if d in Date(wday: 3, day: ..7)
  puts "first Wednesday of the month"
end
```

- **SEE** [ref:d:spec/pattern_matching#matching_non_primitive_objects]
#@end


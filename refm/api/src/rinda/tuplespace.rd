= class Rinda::TupleSpace

include MonitorMixin
include DRbUndumped

((<執筆者募集>))

Tuple Space のためのクラスです。
普通は [[c:Rinda::TupleSpaceProxy]] を介して使います。

== Class Methods

--- new(period = 60)

Rinda::TupleSpace オブジェクトを生成します。

== Methods

--- move(port, tuple, sec = nil)

((<執筆者募集>))

--- notify(event, tuple, sec = nil)

((<執筆者募集>))

--- read(tuple, sec=nil)

((<執筆者募集>))

--- read_all(tuple)

((<執筆者募集>))

--- take(tuple, sec = nil)
--- take(tuple, sec = nil) {|template| ... }

tuple にマッチするタプルをタプルスペースから取り出して返します。
マッチするタプルが存在しない場合は、マッチするタプルがタプルスペースに
投入されるまで待ちます。

待ち時間が sec 秒を過ぎた時には take をあきらめ   
例外 [[c:RequestExpiredError]] を投げます。
   
--- write(tuple, sec = nil)

[[c:Rinda::Tuple]] オブジェクト tuple をタプルスペースに加えます。
tuple を管理するための [[c:Rinda::TupleEntry]] オブジェクトを返します。



= class Rinda::TupleEntry

((<執筆者募集>))

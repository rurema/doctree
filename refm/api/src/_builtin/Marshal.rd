= module Marshal

Ruby オブジェクトをファイル(または文字列)に書き出したり、読み戻したり
する機能を提供するモジュール。大部分のクラスのインスタンスを書き出す事
ができますが、書き出しの不可能なクラスも存在します(後述)。

ここで「マーシャルデータ」と言う用語は、Marshal.dump が出力する文字列
を指すものとします。

== Module Functions

--- dump(obj[,port][,limit])

obj を再帰的にファイルに書き出します。ファイルに書き出せない
オブジェクトをファイルに書き出そうとすると例外 [[c:TypeError]] が
発生します。ファイルに書き出せないオブジェクトは以下の通りです。

 * 名前のついてない [[c:Class]]/[[c:Module]] オブジェクト。(この場
   合は、例外 [[c:ArgumentError]] が発生します。無名クラスについて
   は、[[m:Module.new]] を参照。)
 * システムがオブジェクトの状態を保持するもの。具体的には以下のイン
   スタンス。[[c:Dir]], [[c:File::Stat]], [[c:IO]] とそのサブクラス
   [[c:File]], [[c:Socket]] など。
 * [[c:MatchData]], [[c:Data]], [[c:Method]], [[c:UnboundMethod]],
   [[c:Proc]], [[c:Thread]], [[c:ThreadGroup]], [[c:Continuation]]
   のインスタンス。
 * 特異メソッドを定義したオブジェクト

また、これらのオブジェクトを間接的に指すオブジェクトなども書き出せ
ません。例えば、デフォルト値を求めるブロックを持った [[c:Hash]] は
[[c:Proc]] を間接的に指していることになります。

  p Marshal.dump(Hash.new {})
  => -:1:in `dump': cannot dump hash with default proc (TypeError)

port には [[c:IO]](またはそのサブクラス)のインスタンスを指定
します。この場合、port を返します。省略した場合には
dump はそのオブジェクトをダンプした文字列を返します。

limit を指定した場合、limit 段以上深くリンクしたオブジェ
クトをダンプできません(デフォルトは 100 レベル)。負の limit
を指定すると深さチェックを行いません。

マーシャルの動作を任意に定義することもできます。詳細は、
[[m:Marshal#ユーザ定義のMarshal]] を参照してください。

--- load(port[,proc])
--- restore(port[,proc])

port からマーシャルデータを読み込んで、元のオブジェクトと同
じ状態をもつオブジェクトを生成します。port は文字列か
IO(またはそのサブクラス)のインスタンスを指定します。

proc として手続きオブジェクトが与えられた場合には読み込んだ
オブジェクトを引数にその手続きを呼び出します。
#@# ((-以前 [[c:Fixnum]], [[c:Symbol]] が渡されない不具合があったが、
#@# 1.6.7 2002-03-15 ごろに改修済み-))

  str = Marshal.dump(["a", 1, 10 ** 10, 1.0, :foo])
  p Marshal.load(str, proc {|obj| p obj})

  => "a"
     1
     10000000000
     1.0
     :foo
     ["a", 1, 10000000000, 1.0, :foo]
     ["a", 1, 10000000000, 1.0, :foo]

#@since 1.7.0
== Constants

--- MAJOR_VERSION
--- MINOR_VERSION

[[m:Marshal.dump]] が出力するデータフォーマットのバージョン番号です。

[[m:Marshal.load]] は、メジャーバージョンが異なるか、バージョンの大きな
マーシャルデータを読み込んだとき例外 [[c:TypeError]] を発生させます。

マイナーバージョンが古いだけのフォーマットは読み込み可能ですが、
[[m:$VERBOSE]] = true のときには警告メッセージが出力されます

マーシャルされたデータのバージョン番号は以下のようにして取得するこ
とができます。

  obj = Object.new
  major, minor = Marshal.dump(obj).unpack("cc")
  p [major, minor]
#@end

= reopen Class
== Instance Methods
--- _load(str)
[[m:Object#_dump]]を参照。

= reopen Object
== Instance Methods

--- _dump(limit)

Marshal.dump において出力するオブジェクトがメソッド `_dump'
を定義している場合には、そのメソッドの結果が書き出されます。メソッ
ド `_dump' は引数として再帰を制限するレベル limit を受
け取り、オブジェクトを文字列化したものを返します。

インスタンスがメソッド `_dump' を持つクラスは必ず同じフォー
マットを読み戻すクラスメソッド `_load' を定義する必要があり
ます。`_load' はオブジェクトを表現した文字列を受け取り、それ
をオブジェクトに戻したものを返す必要があります。

  class Foo
    def initialize(obj)
      p "initialize() called"
      @foo = obj
    end
    def _dump(limit)
      Marshal.dump(@foo, limit)
    end
    def self._load(obj)
      Foo.new(Marshal.load(obj))
    end
  end

  p Marshal.load(Marshal.dump(Foo.new(['foo', 'bar'])))

  => "initialize() called"
     "initialize() called"
     #<Foo:0x4019eb88 @foo=["foo", "bar"]>

インスタンス変数の情報は普通マーシャルデータに含まれるので、この例
のように _dump を定義する必要はありません(ただし _dump を定義すると
インスタンス変数の情報は dump されなくなります)。
_dump/_load はより高度な制御を行いたい場合や拡張ライブラリで定義し
たクラスのインスタンスがインスタンス変数以外に情報を保持する場合に
利用します。(例えば、クラス [[c:Time]] は、_dump/_load を定義して
います)

#@since 1.8.0
--- marshal_dump
--- marshal_load(obj)

marshal_dump/marshal_load の仕組みは
ruby 1.8.0 から導入されました。_dump/_load よりも使いやすいので、
こちらの利用が推奨されます。_dump/_load はまだ obsolete にはなって
いませんが、遠い将来そうなるかもしれません。
[[ruby-dev:21088]]

[[m:Marshal.dump]] において、出力するオブジェクトがメソッド
`marshal_dump' を定義している場合には、その戻り値が dump されます。
メソッド marshal_dump は任意のオブジェクトを返すメソッドとし
て定義します。

このようなオブジェクトを load するにはメソッド `marshal_load' が定
義されていなくてはならず、load 時に利用されます。
marshal_load は marshal_dump の戻り値のコピーを引数に受け取
ります。marshal_load 時の self は、生成されたばかり
([[m:Class#allocate]] されたばかり)の状態です。
なお、marshal_load の戻り値は無視されます。

dump するオブジェクトが _dump と marshal_dump の両方のメソッドを持
つ場合 marshal_dump が利用されます。

  class Foo
    def initialize
      p "initialize() called"
      @foo = ['foo', 'bar']
    end
    def marshal_dump
      @foo
    end
    def marshal_load(obj)
      @foo = obj
    end
  end
  
  p Marshal.load(Marshal.dump(Foo.new))
  
  "initialize() called"
  #<Foo:0x4019ed2c @foo=["foo", "bar"]>

インスタンス変数の情報は普通マーシャルデータに含まれるので、この例
のように marshal_dump を定義する必要はありません(ただし
marsahl_dump を定義するとインスタンス変数の情報は dump されなくな
りますので、marshal_dump/marshal_load で扱う必要があります)。
marshal_dump/marshal_load はより高度な制御を行いたい場合や
拡張ライブラリで定義したクラスのインスタンスがインスタンス変数以外
に情報を保持する場合に利用します。

特に、marshal_dump/marshal_load を定義したオブジェクトは特異メソッドが
定義されていてもマーシャルできるようになります。
(特異メソッドの情報が自動的に dump されるようになるわけではなく、
marshal_dump/marshal_load によりそれを実現する余地があるということ
です)
#@end

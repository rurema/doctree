= class WEBrick::HTTPVersion < Object
include Comparable

HTTP のバージョンのための小さなクラスです。
バージョン同士の比較のために使います。

== Class Methods
--- new(version)    -> WEBrick::HTTPVersion

HTTPVersion オブジェクトを生成します。version は文字列か HTTPVersion オブジェクトです。

@param version HTTP のバージョンを WEBrick::HTTPVersion オブジェクトか文字列で指定します。

--- convert(version)    -> WEBrick::HTTPVersion

指定された version を HTTPVersion オブジェクトに変換して返します。
version が HTTPVersion オブジェクトの場合はそのまま version を返します。

@param version HTTP のバージョンを WEBrick::HTTPVersion オブジェクトか文字列で指定します。

== Instance Methods

--- <=>(other)    -> -1 | 0 | 1 | nil

自身と指定された other のバージョンを比較します。
自身が other より新しいなら 1、同じなら 0、古いなら -1 を返します。
比較できない場合に nil を返します。

@param other HTTP のバージョンを表す WEBrick::HTTPVersion オブジェクトか文字列を指定します。

  require 'webrick'
  v = WEBrick::HTTPVersion.new('1.1')
  p v < '1.0'                          #=> false

--- major      -> Integer
--- major=(n)

HTTP バージョンのメジャーを整数で表すアクセサです。

@param n HTTP バージョンのメジャーを整数で指定します。

--- minor      -> Integer
--- minor=(n)

HTTP バージョンのマイナーを整数で表すアクセサです。

@param n HTTP バージョンのマイナーを整数で指定します。

--- to_s    -> String

自身を文字列に変換して返します。

  require 'webrick'
  v = WEBrick::HTTPVersion.new('1.1')
  p v.to_s                            #=> "1.1"


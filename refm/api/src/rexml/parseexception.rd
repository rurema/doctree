= class REXML::ParseException < RuntimeError
XML のパースに失敗したときに生じる例外です。

  require 'rexml/document'
  begin
    REXML::Document.new("<a>foo\n</b></a> ")
  rescue REXML::ParseException => ex
    ex.position # => 16
    ex.line # => 2
    ex.context # => [16, 2, 2]
  end
== Class Methods
#@# 
#@# --- new(message source = nil, parser = nil, exception = nil)
#@# #@todo
#@# 

== Instance Methods

#@# --- source 
#@# --- source=(value)
#@# #@todo
#@# 

#@# --- parser -> REXML::Parsers::BaseParser | nil
#@# 例外を発生させたパーサオブジェクトを返します。
#@# 
#@# そのようなオブジェクトが設定されていない場合は nil を返します。
#@# 
#@# この値は適切に設定されていない場合もあるので、
#@# 直接は利用しないでください。
#@# 
#@# --- parser=(value)
#@# 
#@# 

#@# このメソッドは使い物にならない
#@# --- continued_exception -> Exception|nil
#@# パーサ内部で実際に生じた例外を返します。
#@# 
#@# パーサ内の例外は [[c:REXML::ParseException]] と
#@# その子孫クラスの例外以外は ParseException に変換されます。
#@# このメソッドは内部で実際に生じた例外を返します。
#@# そのような例外が存在しない場合は nil を返します。
#@# 
#@# 通常はそのような事態は発生しないはずです(発生したならば
#@# なんらかのバグである可能性が高いです)。そのため
#@# このメソッドは通常 nil を返すはずです。
#@# --- continued_exception=(value)


--- to_s -> String
例外情報を文字列化して返します。

--- position -> Integer
パースエラーが起きた(XML上の)場所を先頭からのバイト数で返します。

--- line -> Integer
パースエラーが起きた(XML上の)場所を行数で返します。

--- context -> [Integer, Integer, Integer]
パースエラーが起きた(XML上の)場所を返します。

要素3個の配列で、
  [position, lineno, line]
という形で返します。
position, line は 
[[m:REXML::ParseException#position]]
[[m:REXML::ParseException#line]]
と同じ値です。
lineno は [[m:IO#lineno]] が返す意味での行数です。
通常は line と同じ値です。

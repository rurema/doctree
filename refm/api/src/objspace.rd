このライブラリは [[c:ObjectSpace]] を拡張してオブジェクトやメモリ管理についての
統計情報を取得するメソッドをいくつか追加します。

MRI の実装について詳しくない一般のユーザはこのライブラリを使ってはいけません。
このライブラリは、メモリプロファイラの開発者や MRI がどのようにメモリを使用するか
知りたい MRI 開発者が使用します。

= reopen ObjectSpace

== Module Functions

--- count_objects_size(result_hash = nil) -> Hash

型ごとのオブジェクトサイズをバイト単位で格納したハッシュを返します。

@param result_hash 戻り値のためのハッシュを指定します。省略した場合は新
                   しくハッシュを作成します。result_hash の内容は上書き
                   されます。プローブ効果を避けるために使用します。

戻り値の内容は完全ではない事に注意してください。この内容はあくまでもヒ
ントとして扱う必要があります。特に T_DATA の合計値は正しくないでしょう。

例:

  ObjectSpace.count_objects_size
  # => {:TOTAL=>1461154, :T_CLASS=>158280, :T_MODULE=>20672, :T_STRING=>527249, ...}

@raise TypeError result_hash にハッシュ以外を指定した時に発生します。

戻り値のハッシュは処理系に依存します。これは将来変更になるかもしれません。

本メソッドは C Ruby 以外では動作しません。

--- memsize_of(obj) -> Integer

obj が消費するメモリ使用量をバイト単位で返します。

@param obj 任意のオブジェクトを指定します。

戻り値の内容は完全ではない事に注意してください。この内容はあくまでもヒ
ントとして扱う必要があります。特に T_DATA の値は正しくないでしょう。
#@since 2.2.0
2.2 以降では RVALUE のサイズを含んだ結果を返します。
#@end

本メソッドは C Ruby 以外では動作しません。

#@since 1.9.3
--- memsize_of_all(klass = nil) -> Integer

すべての生存しているオブジェクトが消費しているメモリ使用量をバイト単位
で返します。

@param klass 指定したクラスのインスタンスのメモリ使用量を返します。省略
             した場合はすべてのクラスのインスタンスのメモリ使用量を返し
             ます。

本メソッドは以下のような Ruby のコードで定義できます。

  def memsize_of_all klass = false
    total = 0
    ObjectSpace.each_object{|e|
      total += ObjectSpace.memsize_of(e) if klass == false || e.kind_of?(klass)
    }
    total
  end

戻り値の内容は完全ではない事に注意してください。この内容はあくまでもヒ
ントとして扱う必要があります。特に T_DATA の値は正しくないでしょう。

また、同様に戻り値の内容は malloc されたメモリの合計でもない事に注意し
てください。

本メソッドは C Ruby 以外では動作しません。
#@end

--- count_nodes(result_hash = nil) -> Hash

ノードの種類ごとの数を格納したハッシュを返します。

@param result_hash 戻り値のためのハッシュを指定します。省略した場合は新
                   しくハッシュを作成します。result_hash の内容は上書き
                   されます。プローブ効果を避けるために使用します。

@raise TypeError result_hash にハッシュ以外を指定した時に発生します。

本メソッドは普通の Ruby プログラマ向けのメソッドではありません。パフォー
マンスやメモリ管理に興味のある C Ruby の開発者向けのものです。

例:

  ObjectSpace.count_nodes
  # => {:NODE_METHOD=>2027, :NODE_FBODY=>1927, :NODE_CFUNC=>1798, ...}

戻り値のハッシュは処理系に依存します。これは将来変更になるかもしれません。

本メソッドは C Ruby 以外では動作しません。

--- count_tdata_objects(result_hash = nil) -> Hash

T_DATA の種類ごとにオブジェクトの数を格納したハッシュを返します。

@param result_hash 戻り値のためのハッシュを指定します。省略した場合は新
                   しくハッシュを作成します。result_hash の内容は上書き
                   されます。プローブ効果を避けるために使用します。

@raise TypeError result_hash にハッシュ以外を指定した時に発生します。

本メソッドは普通の Ruby プログラマ向けのメソッドではありません。パフォー
マンスに興味のある C Ruby の開発者向けのものです。

例:

  ObjectSpace.count_tdata_objects
  # => {RubyVM::InstructionSequence=>504, :parser=>5, :barrier=>6,
        :mutex=>6, Proc=>60, RubyVM::Env=>57, Mutex=>1, Encoding=>99,
        ThreadGroup=>1, Binding=>1, Thread=>1, RubyVM=>1, :iseq=>1,
        Random=>1, ARGF.class=>1, Data=>1, :autoload=>3, Time=>2}

現在のバージョンでは、戻り値のキーはクラスオブジェクトかシンボルのオブ
ジェクトです。

普通の参照可能なオブジェクトの場合、キーはクラスオブジェクトです。それ
以外の内部的なオブジェクトの場合、キーはシンボルです。シンボルの値は
rb_data_type_struct に格納された名前が使用されます。

戻り値のハッシュは処理系に依存します。これは将来変更になるかもしれません。

本メソッドは C Ruby 以外では動作しません。

#@since 2.0.0
--- reachable_objects_from(obj) -> Array | nil

obj から到達可能なすべてのオブジェクトを返します。マーク不能なオブジェ
クトを指定した場合は nil を返します。本メソッドを使う事でメモリリークの
調査が行えます。

  # 配列クラス(Array)と 'a'、'b'、'c' に到達可能。
  ObjectSpace.reachable_objects_from(['a', 'b', 'c'])
  # => [Array, 'a', 'b', 'c']

obj が 2 つ以上の同じオブジェクト x への参照を持つ場合、戻り値に含まれ
るオブジェクト x は 1 つだけです。

  # 配列クラス(Array)と v に到達可能。
  ObjectSpace.reachable_objects_from([v = 'a', v, v])
  # => [Array, 'a']

  # 配列クラス(Array)と 3 つの異なる 'a' オブジェクトに到達可能。
  ObjectSpace.reachable_objects_from(['a', 'a', 'a'])
  # => [Array, 'a', 'a', 'a']

obj にマーク不能なオブジェクト(true、false、nil、[[c:Symbol]]、
[[c:Fixnum]]、Flonum(即値の [[c:Float]] オブジェクト))を指定した場合は
nil を返します。

  # 1 はマーク不能
  ObjectSpace.reachable_objects_from(1)
  # => nil

obj が内部でオブジェクトへの参照を持つ場合、
ObjectSpace::InternalObjectWrapper オブジェクトが戻り値に含まれます。こ
のオブジェクトは obj が内部で持っているオブジェクトを持ちます。内部のオ
ブジェクトの型を確認する場合は ObjectSpace::InternalObjectWrapper#type
を参照してください。:T_CLASS のような [[c:Symbol]] を返します。

obj が ObjectSpace::InternalObjectWrapper オブジェクトであった場合、そ
のオブジェクトから参照される全てのオブジェクトを返します。

本メソッドは C Ruby 以外では動作しません。

@see [[url:http://www.atdot.net/~ko1/diary/201212.html#d8]],
     [[url:http://www.atdot.net/~ko1/diary/201212.html#d9]]
#@end

#@since 2.1.0
--- trace_object_allocations_start -> nil

オブジェクト割り当てのトレースを開始します。

#@end

#@since 2.1.0
--- trace_object_allocations_stop -> nil

オブジェクト割り当てのトレースを終了します。

トレースを終了する為には、[[m:ObjectSpace.#trace_object_allocations_start]]を呼んだ回数分だけこのメソッドを呼ぶ必要があります。
#@end

#@since 2.1.0
--- allocation_sourcefile(object) -> String

objectの元となったソースファイル名を返します。

@param object 元となるソースファイル名を取得したいobjectを指定します。
@return objectの元となるソースファイル名を返します。存在しない場合はnilを返します。
#@end

#@samplecode 例:test.rbというファイルで下記のスクリプトを実行した場合
require 'objspace'

ObjectSpace::trace_object_allocations_start
obj = Object.new
puts "file:#{ObjectSpace::allocation_sourcefile(obj)}"   # => file:test.rb
ObjectSpace::trace_object_allocations_stop
#@end

#@since 2.1.0
--- allocation_sourceline(object) -> integer

objectの元となったソースファイルの行数を返します。

@param object 元となるソースファイルの行数を取得したいobjectを指定します。
@return objectの元となるソースファイルの行数を返します。存在しない場合はnilを返します。
#@end

#@samplecode 例
require 'objspace'

ObjectSpace::trace_object_allocations_start
obj = Object.new
puts "line:#{ObjectSpace::allocation_sourceline(obj)}"  # => line:4
ObjectSpace::trace_object_allocations_stop
#@end

#@since 2.1.0
--- trace_object_allocations { ... }

与えられたブロック内でオブジェクトのトレースを行います。　

#@samplecode 例
require 'objspace'

class C
  include ObjectSpace

  def foo
    trace_object_allocations do
      obj = Object.new
      p "#{allocation_sourcefile(obj)}:#{allocation_sourceline(obj)}"
    end
  end
end

C.new.foo #=> "objtrace.rb:8"
#@end
#@end

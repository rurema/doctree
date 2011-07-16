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
    ObjectSpace.each_objects{|e|
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

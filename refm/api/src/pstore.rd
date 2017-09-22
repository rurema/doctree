category Database

Rubyのオブジェクトを外部ファイルに格納するためのライブラリです。

= class PStore < Object

Rubyのオブジェクトを外部ファイルに格納するためのクラスです。
内部で [[c:Marshal]] を使っています。

=== 使い方

データベースにアクセスするためには、
transaction のブロック内である必要があります。
インターフェースは [[c:Hash]] に似ています。

  require 'pstore'
  db = PStore.new("/tmp/foo")
  db.transaction do
    p db.roots       # => []
    ary = db["root"] = [1,2,3,4]
    ary[0] = [1,1.5]
  end
  
  db.transaction do
    p db["root"]     # => [[1, 1.5], 2, 3, 4]
  end


== Class Methods

#@since 1.9.1
--- new(file, thread_safe = false) -> PStore
#@else
--- new(file) -> PStore
#@end

ファイル名 file に対してデータベースを読み書きします。

データベースを更新するときにバックアップファイルが作成されるため、
file のあるディレクトリは書き込み可能である必要があります。
#@since 1.8.2
データベースの更新が成功すると、バックアップファイルは削除されます。バックアップファイル名は
ファイル名に ".tmp" および ".new" を付けたものです。
#@else
バックアップファイルは削除されずに残ります。バックアップファイル名はファイル名の後に "~" を付けたものです。
#@end

@param file データベースファイル名。

#@since 2.3.0
@param thread_safe 真を指定すると [[c:Thread::Mutex]] を用いてスレッドセーフになります。
#@else
@param thread_safe 真を指定すると [[c:Mutex]] を用いてスレッドセーフになります。
#@end
                   デフォルトは偽です。

== Instance Methods

#@since 1.8.0
--- transaction(read_only = false) {|pstore| ... } -> object

トランザクションに入ります。
このブロックの中でのみデータベースの読み書きができます。

読み込み専用のトランザクションが使用可能です。

@param read_only 真を指定すると、読み込み専用のトランザクションになります。

@return ブロックで最後に評価した値を返します。

@raise PStore::Error read_only を真にしたときに、データベースを変更しようした場合に発生します。

例:

  require 'pstore'
  db = PStore.new("/tmp/foo")
  db.transaction do
    p db.roots       # => []
    ary = db["root"] = [1,2,3,4]
    ary[0] = [1,1.5]
  end
  
  db.transaction(true) do |pstore|
    pstore["root"] = 'aaa' # => ここで例外発生
  end


#@end

--- [](name) -> object

ルートnameに対応する値を得ます。

@param name 探索するルート。

@raise PStore::Error トランザクション外でこのメソッドが呼び出された場合に発生します。

@see [[m:Hash#[] ]]

--- []=(name, value)

ルート name に対応する値 value をセットします。

@param name ルート。

@param value 格納する値。

@raise PStore::Error トランザクション外でこのメソッドが呼び出された場合に発生します。

@see [[m:Hash#[]=]]

#@since 1.8.0
--- fetch(name, default = PStore::Error) -> object

ルートnameに対応する値を得ます。

該当するルートが登録されていない時には、
引数 default が与えられていればその値を返し、
与えられていなければ例外 [[c:PStore::Error]] が発生します。

@param name 探索するルート。

@param default name に対応するルートが登録されていない場合に返す値を指定する。

@raise PStore::Error name に対応するルートが登録されていないかつ、
                     default が与えられていない場合に発生します。
                     また、トランザクション外でこのメソッドが呼び出された場合に発生します。

例:

  require 'pstore'
  db = PStore.new("/tmp/foo")
  db.transaction do
    p db.roots       # => []
    ary = db["root"] = [1,2,3,4]
    ary[0] = [1,1.5]
  end
  
  db.transaction(true) do |pstore|
    pstore.fetch("root")        # => [[1, 1.5], 2, 3, 4]
    pstore.fetch("root", 'aaa') # => [[1, 1.5], 2, 3, 4]
    pstore.fetch("not_root")    # => 例外発生
  end

@see [[m:Hash#fetch]], [[m:PStore#[] ]]
#@end

--- delete(name) -> object

ルートnameに対応する値を削除します。

@param name 探索するルート。

@return 削除した値を返します。

@raise PStore::Error トランザクション外でこのメソッドが呼び出された場合に発生します。

例:

  require 'pstore'
  db = PStore.new("/tmp/foo")
  db.transaction do
    p db.roots       # => []
    ary = db["root"] = [1,2,3,4]
    ary[0] = [1,1.5]
  end
  
  db.transaction do |pstore|
    pstore.delete("root")       # => [[1, 1.5], 2, 3, 4]
    pstore.delete("root")       # => nil
  end

@see [[m:Hash#delete]]

--- roots -> Array

ルートの集合を配列で返します。

@raise PStore::Error トランザクション外でこのメソッドが呼び出された場合に発生します。

@see [[m:Hash#keys]]

--- root?(name) -> bool

ルート name がデータベースに格納されている場合に真を返します。

@param name 探索するルート。

@raise PStore::Error トランザクション外でこのメソッドが呼び出された場合に発生します。

@see [[m:Hash#key?]]

--- path -> String

データベースのファイル名を得ます。

--- commit -> ()

データベースの読み書きを終了します。

transaction ブロックから抜け、データベースの変更が反映されます。

@raise PStore::Error トランザクション外でこのメソッドが呼び出された場合に発生します。

例:

  require 'pstore'
  db = PStore.new("/tmp/foo")
  db.transaction do
    p db.roots       # => []
    ary = db["root"] = [1,2,3,4]
    db.commit
    ary[0] = [1,1.5] # => ここは実行されない。
  end
  
  db.transaction do |pstore|
    pstore["root"]       # => [[1, 2, 3, 4]
  end

--- abort -> ()

データベースの読み書きを終了します。

transaction ブロックから抜けますが、データベースの変更は反映されません。

@raise PStore::Error トランザクション外でこのメソッドが呼び出された場合に発生します。

例:

  require 'pstore'
  db = PStore.new("/tmp/foo")
  db.transaction do
    p db.roots       # => []
    ary = db["root"] = [1,2,3,4]
    db.abort
    ary[0] = [1,1.5] # => ここは実行されない。
  end
  
  db.transaction do |pstore|
    pstore["root"]       # => nil
  end

#@since 1.8.2
#@until 1.9.1
--- dump(table) -> String
#@# nodoc
単なる [[m:Marshal.#dump]] のラッパーメソッドです。

@param table ハッシュを指定します。

@see [[m:Marshal.#load]]

--- load(content) -> object
#@# nodoc 動かないっぽい。
単なる [[m:Marshal.#load]] のラッパーメソッドです。

@param content データを指定します。

@see [[m:Marshal.#load]]

--- load_file(file) -> object
#@# nodoc

単なる [[m:Marshal.#load]] のラッパーメソッドです。

@param file ファイル名か [[c:IO]] オブジェクトを指定します。

@see [[m:Marshal.#load]]
#@end
#@end

#@since 1.9.1
--- ultra_safe -> bool
真であれば、パフォーマンスと引き換えにファイル更新の衝突を避けることができます。
デフォルトは偽です。

このフラグの効果があるのは一部のプラットフォームだけです。
(e.g. all POSIX platforms: Linux, Mac OS X, FreeBSD, etc)

--- ultra_safe=(flag)
真をセットすると、パフォーマンスと引き換えにファイル更新の衝突を避けることができます。

このフラグの効果があるのは一部のプラットフォームだけです。
(e.g. all POSIX platforms: Linux, Mac OS X, FreeBSD, etc)

@param flag 真偽値を指定します。


#@end

== Private Instance Methods

--- in_transaction -> ()

トランザクションの中でなければ例外を発生させます。

== Constants
#@since 1.8.6
--- RDWR_ACCESS -> Integer
内部で利用する定数です。

--- RD_ACCESS -> Integer
内部で利用する定数です。

--- WR_ACCESS -> Integer
内部で利用する定数です。
#@end
#@since 1.9.1
--- EMPTY_MARSHAL_CHECKSUM -> String
内部で利用する定数です。

--- EMPTY_MARSHAL_DATA -> String
内部で利用する定数です。

--- EMPTY_STRING -> String
内部で利用する定数です。

#@end
= class PStore::Error < StandardError

[[c:PStore]] の中で発生する例外です。

#@since 1.9.1
= class PStore::DummyMutex < Object

ダミーのミューテックス。このクラスを使ってもスレッドセーフにはなりません。

== Instance Methods

--- synchronize{ ... } -> object

与えられたブロックを評価するだけで何もしません。

#@end

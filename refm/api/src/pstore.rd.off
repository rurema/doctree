require "fileutils"
require "digest/md5"

= class PStore < Object

Rubyのオブジェクトを外部ファイルに格納するためのクラス。
内部で [[c:Marshal]] を使っている。

=== 使い方

  db = PStore.new("/tmp/foo")
  db.transaction do
    p db.roots
    ary = db["root"] = [1,2,3,4]
    ary[0] = [1,1.5]
  end

  db.transaction do
    p db["root"]
  end

データベースにアクセスするためには、
transaction の((*ブロック内*))である必要がある。
インターフェースは Hash ライクである。

== Class Methods

--- new(file)

ファイル名 file に対してデータベースを読み書きする。
file のあるディレクトリは書き込み可能である必要がある。
データベースを更新するときにバックアップファイルが作成されるため。

#@if (version >= "1.8.2")
((<ruby 1.8.2 feature>))
データベースの更新が成功すると、バックアップファイルは削除される。バックアップファイル名は
ファイル名に ".tmp" および ".new" を付けたもの。
#@else
#@#ruby 1.8.1 まで: 
バックアップファイルは削除されずに残る。バックアップファイル名はファイル名の後に "~" を付けたもの。
#@end

== Instance Methods

#@if (version >= "1.7.0")
--- transaction {|pstore| ... }
--- transaction(read_only=false) {|pstore| ... }

((<ruby 1.7 feature>))


トランザクションに入る。
このブロックの中でしかデータベースの読み書きはできない。

((<ruby 1.7 feature>)): 1.7では読み込み専用のトランザクションが使用可能。
#@end

--- [](name)

ルートnameに対応する値を得る。
Hash#[]に相当。

--- []=(name, value)

ルートnameに対応する値valueをセットする。
Hash#[]=に相当。

#@if (version >= "1.8.0")
--- fetch(name[, default])

((<ruby 1.8 feature>))
ルートnameに対応する値を得る。
該当するルートが登録されていない時には、
引数 default が与えられていればその値を返し、
与えられていなければ例外 [[c:PStore::Error]] が発生します。
Hash#fetchに相当。
#@end

--- delete(name)

ルートnameに対応する値を削除する。
Hash#deleteに相当。

--- roots

ルートの集合を配列で返す。
Hash#keysに相当。

--- root?(name)

nameがルートであるかどうか。
Hash#key?に相当。

--- path

データベースのファイル名を得る。

--- commit

データベースの読み書きを終了する。
すなわち、transaction ブロックから抜ける。
データベースの変更が反映される。

--- abort

データベースの読み書きを終了する。
transaction ブロックから抜けるが、データベースの変更は反映されない。

== Private Instance Methods

--- in_transaction

トランザクションの中でなければ例外を発生させる。

= class PStore::Error < StandardError

[[c:PStore]] の中で発生する例外です。

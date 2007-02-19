= class PStore < Object

Rubyのオブジェクトを外部ファイルに格納するためのクラス。
内部で [[c:Marshal]] を使っている。

=== 使い方

  require 'pstore'
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
transaction のブロック内である必要がある。
インターフェースは Hash ライクである。

== Class Methods

--- new(file)
#@todo

ファイル名 file に対してデータベースを読み書きする。
file のあるディレクトリは書き込み可能である必要がある。
データベースを更新するときにバックアップファイルが作成されるため。

#@if (version >= "1.8.2")
データベースの更新が成功すると、バックアップファイルは削除される。バックアップファイル名は
ファイル名に ".tmp" および ".new" を付けたもの。
#@else
#@#ruby 1.8.1 まで: 
バックアップファイルは削除されずに残る。バックアップファイル名はファイル名の後に "~" を付けたもの。
#@end

== Instance Methods

#@if (version >= "1.8.0")
--- transaction {|pstore| ... }
--- transaction(read_only=false) {|pstore| ... }
#@todo

トランザクションに入る。
このブロックの中でしかデータベースの読み書きはできない。

1.8では読み込み専用のトランザクションが使用可能。
#@end

--- [](name)
#@todo

ルートnameに対応する値を得る。
[[m:Hash#[] ]]に相当。

--- []=(name, value)
#@todo

ルートnameに対応する値valueをセットする。
[[m:Hash#[]=]]に相当。

#@if (version >= "1.8.0")
--- fetch(name[, default])
#@todo

ルートnameに対応する値を得る。
該当するルートが登録されていない時には、
引数 default が与えられていればその値を返し、
与えられていなければ例外 [[c:PStore::Error]] が発生します。
Hash#fetchに相当。
#@end

--- delete(name)
#@todo

ルートnameに対応する値を削除する。
[[m:Hash#delete]]に相当。

--- roots
#@todo

ルートの集合を配列で返す。
[[m:Hash#keys]]に相当。

--- root?(name)
#@todo

nameがルートであるかどうか。
[[m:Hash#key?]]に相当。

--- path
#@todo

データベースのファイル名を得る。

--- commit
#@todo

データベースの読み書きを終了する。
すなわち、transaction ブロックから抜ける。
データベースの変更が反映される。

--- abort
#@todo

データベースの読み書きを終了する。
transaction ブロックから抜けるが、データベースの変更は反映されない。

== Private Instance Methods

--- in_transaction
#@todo

トランザクションの中でなければ例外を発生させる。

= class PStore::Error < StandardError

[[c:PStore]] の中で発生する例外です。

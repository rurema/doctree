= class GDBM < Object

include Enumerable

GDBM ファイルをアクセスするクラス。キー、データともに文字列でなければな
らないという制限と、データがファイルに保存されるという点を除いては
Hash クラスと全く同様に扱うことができます。

== Class Methods

--- new(dbname[, mode[, flags]])
--- open(dbname[, mode[, flags]])
--- open(dbname[, mode[, flags]]) {|db| ...}
#@todo

dbname で指定したデータベースをモードを
mode に設定してオープンします。mode の省
略値は 0666 です。mode として nil を指定
するとデータベースが存在しない時には新たなデータベースを作らず
nil を返します。

flags には、GDBM::FAST, GDBM::SYNC, GDBM::NOLOCK を
の論理和を指定します。デフォルト値は指定なし(つまり0)です。

#@if (version >= "1.8.2")
flags に
GDBM::READER, GDBM::WRITER, GDBM::WRCREAT, GDBM::NEWDB
のどれかを与えて読み書きのモードを指定できます。
これらをどれも指定しなかった場合には、
GDBM::WRCREAT, GDBM::WRITER, GDBM::READER の順で試します。
#@end

ブロックを指定した場合、オープンした GDBM オブジェクトを
引数にブロックを実行します。実行後 GDBM オブジェクトをクローズ
し、open メソッドはブロックの結果を返します。これはちょうど
以下と同じです。

  dbm = GDBM.open(file)
  begin
    yield dbm
  ensure
    dbm.close
  end

== Instance Methods

--- [](key)
#@todo

key をキーとする値を返します。

--- []=(key, value)
#@todo

key をキーとして、value を格納します。

--- cachesize=(size)
#@todo

内部のキャッシュのサイズを指定します。詳しくは [[man:gdbm]] の GDBM_CACHESIZE の項を参照ください。

--- clear
#@todo

DBM ファイルを空にします。

--- close
#@todo

DBM ファイルをクローズします。以後の操作は例外を発生させます。

#@since 1.8.3
--- closed?
#@todo
#@end

--- delete(key)
--- delete(key) {|key| ... }
#@todo

key をキーとする項目を削除します。

指定したキーが存在しなければ nil を返します、このとき
ブロックを指定していれば、ブロックを評価します。

--- delete_if { |key, value|  ...  }
--- reject! { |key, value|  ...  }
#@todo

ブロックを評価した値が真であれば該当する項目を削除します。

--- each {|key, value|  ...  }
--- each_pair {|key, value|  ...  }
#@todo

各要素に対するイテレータです。

--- each_key {|key|  ...  }
#@todo

全ての key に対して繰り返すイテレータです。

--- each_value {|value|  ...  }
#@todo

全ての value に対して繰り返すイテレータです。

--- empty?
#@todo

データベースが空の時、真を返します。

--- fastmode=(bool)
--- syncmode=(bool)
#@todo

オープンしている GDBM オブジェクトのモードを変更します。下記の定数
GDBM::FAST、GDBM::SYNC を参照してください。

--- fetch(key[,ifnone])
--- fetch(key) {|key| ... }
#@todo

[[m:Hash#fetch]] と同じです。

--- has_key?(key)
--- key?(key)
--- include?(key)
--- member?(key)
#@todo

key がデータベース中に存在する時、真を返します。

--- has_value?(key)
--- value?(value)
#@todo

value を値とする組がデータベース中に存在する時、真を返します。

--- index(val)
#@todo

[[m:Hash#index]] と同じです。

#@if (version < "1.9.0")
--- indexes(key_1, ... )
--- indices(key_1, ... )
#@todo

このメソッドはobsoleteです。

各引数の値をキーとする要素を含む配列を返します。
#@end

--- invert
#@todo

値からキーへのハッシュを返します。

--- keys
#@todo

データベース中に存在するキー全てを含む配列を返します。

--- length
--- size
#@todo

データベース中の要素の数を返します。(注意:現在の実現では要素数を数
えるためにデータベースを全部検索します)

--- reject {|key, value| ... }
#@todo

self.to_hash.reject と同じです。ハッシュを返します。

--- reorganize
#@todo

GDBM では、要素の削除を行っても DB ファイルのサイズは減少しません(削
除によって空いた領域は次の格納のために取っておかれます、)。このメ
ソッドを呼び出すことで DBM ファイルを新規に作り直し無駄な領域をなく
すことができます。

大量の削除を行ったときに、ディスクスペースの節約のために使用します。

--- replace(other)
#@todo

DBM の内容を other の内容で置き換えます。
other は each_pair メソッドを持つオブジェクトで
なければなりません。

--- select
#@todo

--- shift
#@todo

データベース中の要素を一つ取り出し、データベースから削除します。

--- store(key, val)
#@todo

self[key]=val と同じです。key に対して val を格納します。

--- sync
#@todo

要素の変更をファイルに反映します。FAST モード
(GDBM#open() の第3引数にGDBM::FAST を指定)のときだけ意味があります。

注) GNU gdbm version 1.8 以降より FAST モードがデフォルトになりました。

--- to_a
#@todo

DBM の各要素を格納した配列を返します。返される配列の1つの要素は
[key, val] です。(つまり配列の配列を返します)。

--- to_hash
#@todo

DBM の各要素を格納したハッシュを返します。

--- update(other)
#@todo

DBM と other の内容をマージします。重複するキーに対応する値は
other の内容で上書きされます。

other は each_pair メソッドを持つオブジェクトでなければなりま
せん。

--- values
#@todo

データベース中に存在する値全てを含む配列を返します。

== Constants

--- VERSION
#@todo

libgdbm のバージョン情報の文字列です。


--- FAST
#@todo

[[m:GDBM.open]] の第3引数に指定します。

書き込みの結果が、ディスク上のファイルにすぐに反映しなくなります。
このモードのときに結果を明示的にファイルに反映させるには GDBM#sync
メソッドを呼びます。libgdbm version 1.8.0 以降ではこのモードがデフォルト
です。

--- SYNC
#@todo

[[m:GDBM.open]] の第3引数に指定します。

書き込みの結果が、ディスク上のファイルにすぐに反映されます。
libgdbm version 1.8.0 以前のデフォルトモードです。

この定数は libgdbm version 1.8.0 以降より有効です。

--- NOLOCK
#@todo

[[m:GDBM.open]] の第3引数に指定します。

通常、他のプロセスが DB をオープンしている最中にオープンを行うと
Errno::EWOULDBLOCK(または Errno::EAGAIN) 例外が発生します。このフラグを
指定していれば、他のプロセスがオープンしている最中でも同時オープンする
ことができます。

この定数は libgdbm version 1.8.0 以降より有効です。

#@if (version >= "1.8.2")
--- READER
#@todo

[[m:GDBM.open]] の第3引数に指定します。
読み込みモードでオープンします。
#@end

#@if (version >= "1.8.2")
--- WRITER
#@todo

[[m:GDBM.open]] の第3引数に指定します。
書き込みモードでオープンします。
#@end

#@if (version >= "1.8.2")
--- WRCREAT
#@todo

[[m:GDBM.open]] の第3引数に指定します。
書き込みモードで、すでにファイルが存在しなかったら作ります。
#@end

#@if (version >= "1.8.2")
--- NEWDB
#@todo

[[m:GDBM.open]] の第3引数に指定します。
書き込みモードで、すでにファイルが存在したら削除してから作り直します。
#@end

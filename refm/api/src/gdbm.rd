= class GDBM < Object

include Enumerable

GDBM ファイルをアクセスするクラス。キー、データともに文字列でなければな
らないという制限と、データがファイルに保存されるという点を除いては
Hash クラスと全く同様に扱うことができます。

== Class Methods

--- new(dbname[, mode[, flags]])
--- open(dbname[, mode[, flags]])
--- open(dbname[, mode[, flags]]) {|db| ...}

dbname で指定したデータベースをモードを
mode に設定してオープンします。mode の省
略値は 0666 です。mode として nil を指定
するとデータベースが存在しない時には新たなデータベースを作らず
nil を返します。

flags には、GDBM::FAST, GDBM::SYNC, GDBM::NOLOCK を
の論理和を指定します。デフォルト値は指定なし(つまり0)です。

#@if (version >= "1.8.2")
((<ruby 1.8.2 feature>)):
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

key をキーとする値を返します。

--- []=(key, value)

key をキーとして、value を格納します。

--- cachesize=(size)

内部のキャッシュのサイズを指定します。詳しくは [[man:gdbm]] の GDBM_CACHESIZE の項を参照ください。

--- clear

DBM ファイルを空にします。

--- close

DBM ファイルをクローズします。以後の操作は例外を発生させます。

--- delete(key)
--- delete(key) {|key| ... }

key をキーとする項目を削除します。

指定したキーが存在しなければ nil を返します、このとき
ブロックを指定していれば、ブロックを評価します。

--- delete_if { |key, value|  ...  }
--- reject! { |key, value|  ...  }

ブロックを評価した値が真であれば該当する項目を削除します。

--- each {|key, value|  ...  }
--- each_pair {|key, value|  ...  }

各要素に対するイテレータです。

--- each_key {|key|  ...  }

全ての key に対して繰り返すイテレータです。

--- each_value {|value|  ...  }

全ての value に対して繰り返すイテレータです。

--- empty?

データベースが空の時、真を返します。

--- fastmode=(bool)
--- syncmode=(bool)

オープンしている GDBM オブジェクトのモードを変更します。下記の定数
GDBM::FAST、GDBM::SYNC を参照してください。

--- fetch(key[,ifnone])
--- fetch(key) {|key| ... }

[[m:Hash#fetch]] と同じです。

--- has_key?(key)
--- key?(key)
--- include?(key)
--- member?(key)

key がデータベース中に存在する時、真を返します。

--- has_value?(key)
--- value?(value)

value を値とする組がデータベース中に存在する時、真を返します。

--- index(val)

[[m:Hash#index]] と同じです。

--- indexes(key_1, ... )

((<obsolete>))

--- indices(key_1, ... )

((<obsolete>))

各引数の値をキーとする要素を含む配列を返します。

--- invert

値からキーへのハッシュを返します。

--- keys

データベース中に存在するキー全てを含む配列を返します。

--- length
--- size

データベース中の要素の数を返します。(注意:現在の実現では要素数を数
えるためにデータベースを全部検索します)

--- reject {|key, value| ... }

self.to_hash.reject と同じです。ハッシュを返します。

--- reorganize

GDBM では、要素の削除を行っても DB ファイルのサイズは減少しません(削
除によって空いた領域は次の格納のために取っておかれます、)。このメ
ソッドを呼び出すことで DBM ファイルを新規に作り直し無駄な領域をなく
すことができます。

大量の削除を行ったときに、ディスクスペースの節約のために使用します。

--- replace(other)

DBM の内容を other の内容で置き換えます。
other は each_pair メソッドを持つオブジェクトで
なければなりません。

--- shift

データベース中の要素を一つ取り出し、データベースから削除します。

--- store(key, val)

self[key]=val と同じです。key に対して val を格納します。

--- sync

要素の変更をファイルに反映します。FAST モード
(GDBM#open() の第3引数にGDBM::FAST を指定)のときだけ意味があります。

注) GNU gdbm version 1.8 以降より FAST モードがデフォルトになりました。

--- to_a

DBM の各要素を格納した配列を返します。返される配列の1つの要素は
[key, val] です。(つまり配列の配列を返します)。

--- to_hash

DBM の各要素を格納したハッシュを返します。

--- update(other)

DBM と other の内容をマージします。重複するキーに対応する値は
other の内容で上書きされます。

other は each_pair メソッドを持つオブジェクトでなければなりま
せん。

--- values

データベース中に存在する値全てを含む配列を返します。

== Constants

--- VERSION

libgdbm のバージョン情報の文字列です。


--- FAST

[[m:GDBM.open]] の第3引数に指定します。

書き込みの結果が、ディスク上のファイルにすぐに反映しなくなります。
このモードのときに結果を明示的にファイルに反映させるには GDBM#sync
メソッドを呼びます。libgdbm version 1.8.0 以降ではこのモードがデフォルト
です。

--- SYNC

[[m:GDBM.open]] の第3引数に指定します。

書き込みの結果が、ディスク上のファイルにすぐに反映されます。
libgdbm version 1.8.0 以前のデフォルトモードです。

この定数は libgdbm version 1.8.0 以降より有効です。

--- NOLOCK

[[m:GDBM.open]] の第3引数に指定します。

通常、他のプロセスが DB をオープンしている最中にオープンを行うと
Errno::EWOULDBLOCK(または Errno::EAGAIN) 例外が発生します。このフラグを
指定していれば、他のプロセスがオープンしている最中でも同時オープンする
ことができます。

この定数は libgdbm version 1.8.0 以降より有効です。

#@if (version >= "1.8.2")
--- READER

[[m:GDBM.open]] の第3引数に指定します。

((<ruby 1.8.2 feature>))

読み込みモードでオープンします。
#@end

#@if (version >= "1.8.2")
--- WRITER

[[m:GDBM.open]] の第3引数に指定します。

((<ruby 1.8.2 feature>))

書き込みモードでオープンします。
#@end

#@if (version >= "1.8.2")
--- WRCREAT

[[m:GDBM.open]] の第3引数に指定します。

((<ruby 1.8.2 feature>))

書き込みモードで、すでにファイルが存在しなかったら作ります。
#@end

#@if (version >= "1.8.2")
--- NEWDB

[[m:GDBM.open]] の第3引数に指定します。

((<ruby 1.8.2 feature>))

書き込みモードで、すでにファイルが存在したら削除してから作り直します。
#@end

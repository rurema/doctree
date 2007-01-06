[[lib:dbm]]と同じですが、外部のライブラリに依存しないのでどの環境でも実
行できるという利点があります。キーや値に使用できるサイズには制限があり
ます。(一つの要素に関してはキーのサイズ + 値 + 内部情報(16バイト)の合
計が1024 バイトまで) [[lib:dbm]] の場合は、リンクしているライブラリに
依存します。

= class SDBM < Object
include Enumerable

== Class Methods

--- open(dbname[, mode[, flags]])
--- open(dbname[, mode[, flags]]) {|db| ...}

dbname で指定したデータベースをモードを
mode に設定してオープンします。mode の省
略値は 0666 です。mode として nil を指定
するとデータベースが存在しない時には新たなデータベースを作らず
nil を返します。

== Instance Methods

--- [](key)

key をキーとする値を返します。

--- []=(key, value)

key をキーとして、value を格納します。
value として nil を指定すると、key に対
する項目を削除します。

--- clear

DBM ファイルを空にします。

--- close

DBM ファイルをクローズします。以後の操作は例外を発生させます。

#@since 1.8.3
--- closed?

#@todo

#@end

--- delete(key)

key をキーとする項目を削除します。

--- reject! { |key, value|  ...  }
--- delete_if { |key, value|  ...  }

ブロックを評価した値が真であれば該当する項目を削除します。

--- reject

#@todo

--- each {|key, value|  ...  }
--- each_pair {|key, value|  ...  }

各要素に対するイテレータ。

--- each_key {|key|  ...  }

全ての key に対して繰り返すイテレータ。

--- each_value {|value|  ...  }

全ての value に対して繰り返すイテレータ。

--- empty?()

データベースが空の時、真を返します。

--- has_key?(key)
--- key?(key)
--- include?(key)
--- member?(key)

key がデータベース中に存在する時、真を返します。

--- has_value?(value)
--- value?(value)

value を値とする組がデータベース中に存在する時、真を返します。

#@if (version < "1.9.0")
--- indexes(key_1, ... )
--- indices(key_1, ... )

このメソッドは obsolete です。

各引数の値をキーとする要素を含む配列を返します。

#@end

--- keys

データベース中に存在するキー全てを含む配列を返します。

--- length
--- size

データベース中の要素の数を返します。(注意:現在の実現では要素数を数
えるためにデータベースを全部検索します)

--- shift

データベース中の要素を一つ取り出し、データベースから削除します。

--- values

データベース中に存在する値全てを含む配列を返します。

--- replace(other)

#@todo

--- fetch

--- store

--- select

--- values_at

--- invert

--- update

--- to_a

--- to_hash

--- index 

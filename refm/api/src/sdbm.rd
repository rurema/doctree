[[lib:dbm]]と同じですが、外部のライブラリに依存しないのでどの環境でも実
行できるという利点があります。キーや値に使用できるサイズには制限があり
ます。(一つの要素に関してはキーのサイズ + 値 + 内部情報(16バイト)の合
計が1024 バイトまで) [[lib:dbm]] の場合は、リンクしているライブラリに
依存します。

= class SDBM < Object
include Enumerable

== Class Methods

--- open(dbname[, mode])
--- open(dbname[, mode]) {|db| ...}
#@todo

dbname で指定したデータベースをモードを
mode に設定してオープンします。mode の省
略値は 0666 です。mode として nil を指定
するとデータベースが存在しない時には新たなデータベースを作らず
nil を返します。

== Instance Methods

--- [](key)
#@todo

key をキーとする値を返します。

--- []=(key, value)
#@todo

key をキーとして、value を格納します。
value として nil を指定すると、key に対
する項目を削除します。

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
#@todo

key をキーとする項目を削除します。

--- reject! { |key, value|  ...  }
--- delete_if { |key, value|  ...  }
#@todo

ブロックを評価した値が真であれば該当する項目を削除します。

--- reject
#@todo


--- each {|key, value|  ...  }
--- each_pair {|key, value|  ...  }
#@todo

各要素に対するイテレータ。

--- each_key {|key|  ...  }
#@todo

全ての key に対して繰り返すイテレータ。

--- each_value {|value|  ...  }
#@todo

全ての value に対して繰り返すイテレータ。

--- empty?()
#@todo

データベースが空の時、真を返します。

--- has_key?(key)
--- key?(key)
--- include?(key)
--- member?(key)
#@todo

key がデータベース中に存在する時、真を返します。

--- has_value?(value)
--- value?(value)
#@todo

value を値とする組がデータベース中に存在する時、真を返します。

#@if (version < "1.9.0")
--- indexes(key_1, ... )
--- indices(key_1, ... )
#@todo

このメソッドは obsolete です。

各引数の値をキーとする要素を含む配列を返します。

#@end

--- keys
#@todo

データベース中に存在するキー全てを含む配列を返します。

--- length
--- size
#@todo

データベース中の要素の数を返します。(注意:現在の実現では要素数を数
えるためにデータベースを全部検索します)

--- shift
#@todo

データベース中の要素を一つ取り出し、データベースから削除します。

--- values
#@todo

データベース中に存在する値全てを含む配列を返します。

--- replace(other)
#@todo


--- fetch
#@todo

--- store
#@todo

--- select
#@todo

--- values_at
#@todo

--- invert
#@todo

--- update
#@todo

--- to_a
#@todo

--- to_hash
#@todo

--- index 
#@todo

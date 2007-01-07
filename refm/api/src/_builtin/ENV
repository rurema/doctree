= object ENV

extends Enumerable

環境変数を表すオブジェクト。[[c:Hash]] と同様のインターフェースを持ち
ます。ただし、Hash と異なり、ENV のキーと値には文字列しか
とることができません。

ENV で得られる文字列は ENV['PATH'] を除いて汚染されていま
す。(オブジェクトの汚染に関しては[[unknown:セキュリティモデル]]を参照のこと)
ENV['PATH'] はその要素が誰でも書き込み可能なディレクトリを含ん
でいる場合に限り汚染されます。

例:

  p ENV['TERM'].tainted?
  # => true
  p path = ENV['PATH']
  # => "/usr/local/bin:/usr/bin:/bin:/usr/X11/bin"
  p path.tainted?
  # => false

#@since 1.8.0
また、ENV で得られる文字列は [[m:Object#freeze]] されています。

例:

  p ENV['TERM'].frozen?
  # => true
#@end

--- [](key)

key に対応する環境変数の値を返します。該当する環境変数が存在
しない時には nil を返します。

--- []=(key, value)
--- store(key, value)

key に対応する環境変数の値を value にします。
value が nil の時、key に対応する環境変数を取り
除きます。

#@since 1.8.0
--- clear

環境変数をすべてクリアします。self を返します。
#@end

--- delete(key)
--- delete(key) {|key| ... }

key に対応する環境変数を取り除きます。取り除かれた環境変数の
値を返 しますが、key に対応する環境変数が存在しない時には
nil を返します。

ブロックが与えられた時には key にマッチするものがなかった時
に評価されます。

--- reject {|key, value| ... }

ブロックを評価した値が真である時、要素を削除します。
[[m:Enumerable#reject]] と異なり Hash を返
します。

--- delete_if {|key, value| ... }
--- reject! {|key, value| ... }

key と value を引数としてブロックを評価した値が真であ
る時、環境変数を削除します。

reject! は要素に変化がなければ nil を返します。

--- each {|key, value| ... }
--- each_pair {|key, value| ... }

key と value を引数としてブロックを評価します。

--- each_key {|key| ... }

key を引数としてブロックを評価します。

--- each_value {|value| ... }

value を引数としてブロックを評価します。

--- empty?

環境変数がひとつも定義されていない時真を返します。

--- fetch(key,[default])
--- fetch(key) {|key| ... }

key に関連づけられた値を返します。該当するキーが登録されてい
ない時には、引数 default が与えられていればその値を、ブロッ
クが与えられていればそのブロックを評価した値を返します。そのいずれ
でもなければ例外 [[c:IndexError]] が発生します。

--- has_key?(val)
--- include?(val)
--- key?(val)
--- member?(val)

val で指定される環境変数が存在する時真を返します。

--- has_value?(value)
--- value?(value)

value を値として持つ環境変数が存在する時真を返します。

--- index(val)
#@since 1.9.0
--- key(val)
#@end

val に対応するキーを返します。対応する要素が存在しない時には
nil を返します。

#@since 1.9.0
ENV.index は version 1.9 では、((<obsolete>)) です。
使用すると警告メッセージが表示されます。
#@end

--- indexes(key_1, ... , key_n)     ((<obsolete>))
--- indices(key_1, ... , key_n)     ((<obsolete>))

引数で指定された名前の環境変数の値の配列を返します。

#@since 1.8.0
このメソッドは version 1.8 では、((<obsolete>)) です。
使用すると警告メッセージが表示されます。
代わりに [[m:ENV#ENV.values_at]] を使用します。
#@end

--- inspect

#@since 1.8.0
--- invert

環境変数の値をキー、名前を値とした [[c:Hash]] を生成して返します。
#@end

--- keys

全環境変数の名前の配列を返します。

--- length
--- size

環境変数の数を返します。

--- rehash

何もしません。nilを返します。

#@since 1.8.0
--- replace(hash)

環境変数を hash に設定します。self を返します。
#@end

#@since 1.8.0
--- select
#@end

#@since 1.8.0
--- shift

環境変数を一つ取り除いて、それを名前と値の組の配列で返します。
環境変数が一つも設定されていなければ nil を返します。
#@end

--- to_a

環境変数から [key,value] なる 2 要素の配列の配列を生成します。

--- to_hash

環境変数の名前と値のハッシュを返します。

--- to_s

#@since 1.8.0
--- update(other)

ハッシュ other の内容を環境変数にマージします。重複するキー
に対応する値は other の内容で上書きされます。

self を返します。
#@end

--- values

環境変数の全値の配列を返します。

#@since 1.8.0
--- values_at(key_1, ..., key_n)

引数で指定されたキー(環境変数名)に対応する値の配列を返します。存在
しないキーに対しては nil が対応します。[[m:ENV#ENV.indexes]] と
[[m:ENV#ENV.indices]] と同じです。

例:

  ENV.update({'FOO','foo', 'BAR','bar'})
  p ENV.values_at(*%w(FOO BAR BAZ))   # => ["foo", "bar", nil]
#@end

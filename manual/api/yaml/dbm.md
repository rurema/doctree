---
type: library
require:
  - yaml
#%until 3.1
  - dbm
#%end
---
#%since 3.1
`DBM` の値に文字列以外も格納できるように拡張するためのサブライブラリです。

Ruby 3.1 で dbm が標準添付ライブラリから削除されたため、このライブラリを使用するには dbm gem のインストールが必要です(親クラスの `DBM` は dbm gem が提供します)。

`DBM` はキー、値のどちらも文字列である必要がありますが、
[c:YAML::DBM] は YAML 形式に変換できるオブジェクトであれば値として格納する事ができます。ただし、キーは文字列である必要があります。

使い方は `DBM` と同じです。`DBM` と [c:YAML] も併せて参照してください。
#%else
[c:DBM] の値に文字列以外も格納できるように拡張するためのサブライブラリです。

[c:DBM] はキー、値のどちらも文字列である必要がありますが、
[c:YAML::DBM] は YAML 形式に変換できるオブジェクトであれば値として格納する事ができます。ただし、キーは文字列である必要があります。

使い方は [c:DBM] と同じです。[c:DBM] と [c:YAML] も併せて参照してください。
#%end

#%since 3.1
# class YAML::DBM
#%else
# class YAML::DBM < DBM
#%end

#%since 3.1
`DBM` の値に文字列以外も格納できるように拡張したクラスです。

Ruby 3.1 で dbm が標準添付ライブラリから削除されたため、このページでは親クラスが Object と表示されていますが、実際の親クラスは dbm gem が提供する `::DBM` です。
#%else
[c:DBM] の値に文字列以外も格納できるように拡張したクラスです。
#%end

## Constants

### const VERSION -> String

[lib:yaml/dbm] のバージョンを文字列で返します。

## Instance Methods

### def [](key) -> object | nil

データベースからキーを探して対応する要素の値を返します。

#%since 3.1
対応する値が見つからなかった場合は nil を返します。`DBM#[]` とは異なり、[c:IndexError] は発生しません。
#%else
対応する値が見つからなかった場合は nil を返します。[m:DBM#\[\]] とは異なり、[c:IndexError] は発生しません。
#%end

- **param** `key` -- キーを文字列で指定します。

- **SEE** [m:YAML::DBM#fetch]

### def []=(key, value)
### def store(key, value) -> object

key に対して value を格納します。

val で指定したオブジェクトを返します。

- **param** `key` -- キーを文字列で指定します。

- **param** `value` -- 値を指定します。YAML 形式に変換できるオブジェクトが指定できます。

- **raise** `DBMError` -- 要素の格納に失敗した場合に発生します。

### def delete(key) -> object | nil

key をキーとする要素を削除します。

削除した要素を返します。key に対応する値が見つからなかった場合は nil を返します。

- **param** `key` -- キーを文字列で指定します。

- **raise** `DBMError` -- 要素の削除に失敗した場合に発生します。

### def delete_if {|key, val| ... } -> YAML::DBM

ブロックを評価した値が真であれば該当する要素を削除します。

自身を返します。このメソッドは self を破壊的に変更します。

- **raise** `DBMError` -- 要素の削除に失敗した場合に発生します。

### def each                        -> YAML::DBM
### def each_pair {|key, val| ... } -> YAML::DBM

自身のキーと値を引数としてブロックを評価します。

自身を返します。

### def each_value {|val| ... } -> YAML::DBM

値を引数としてブロックを評価します。

自身を返します。

### def fetch(key, ifnone = nil) -> object

データベースからキーを探して対応する要素の値を返します。

対応する値が見つからなかった場合は ifnone で指定した値を返します。

- **param** `key` -- キーを文字列で指定します。

- **SEE** [m:YAML::DBM#\[\]]

### def has_value?(value) -> bool

value を値とする組がデータベース中に存在する時、真を返します。

- **param** `value` -- 検索したい値を指定します。YAML 形式に変換できるオブジェクトが指定できます。

### def shift -> [String, object]

データベース中のキー、値を一つ取り出し、データベースから削除します。

[キー, 値]を返します。取得される要素の順番は保証されません。

### def index(value) -> String | nil

value を持つ要素のキーを返します。

対応するキーが見つからなかった場合は nil を返します。

- **param** `value` -- 検索したい値を指定します。YAML 形式に変換できるオブジェクトが指定できます。

[注意] 非推奨のメソッドです。代わりに #key を使用してください。

- **SEE** [m:YAML::DBM#key]

### def key(value) -> String | nil

value を持つ要素のキーを返します。

対応するキーが見つからなかった場合は nil を返します。

- **param** `value` -- 検索したい値を指定します。YAML 形式に変換できるオブジェクトが指定できます。

### def invert -> {object => String}

値からキーへのハッシュを返します。

異なるキーに対して等しい値が登録されている場合の結果は不定であることに注意してください、そのような場合にこのメソッドを利用することは意図されていません。

### def reject {|key, val| ... } -> {String => object}

ブロックを評価した値が真であれば該当する要素を削除します。

新しく [c:Hash] オブジェクトを作成して返します。

### def replace(other) -> YAML::DBM

self の内容を other の内容で置き換えます。

#%since 3.1
- **param** `other` -- [c:Hash]、`DBM` オブジェクトを指定します。
#%else
- **param** `other` -- [c:Hash]、[c:DBM] オブジェクトを指定します。
#%end

- **raise** `DBMError` -- 更新に失敗した場合に発生します。

自身を返します。

### def select(*keys) -> [object]
### def select { ... } -> [[String, object]]

ブロックを評価して真になった要素のみを [キー, 値] から構成される配列に格納して返します。ブロックが与えられなかった場合は、keys に対応する値を配列に格納して返します。

- **param** `keys` -- キーを文字列で指定します。複数指定できます。

ブロックを与えるかどうかで戻り値が異なる事に注意してください。

- **SEE** [m:YAML::DBM#values_at]

### def update(other) -> self

自身と other の内容をマージ(統合)します。

重複するキーに対応する値は other の内容で上書きされます。

#%since 3.1
- **param** `other` -- [c:Hash]、`DBM` オブジェクトを指定します。
#%else
- **param** `other` -- [c:Hash]、[c:DBM] オブジェクトを指定します。
#%end

- **raise** `DBMError` -- 更新に失敗した場合に発生します。

### def to_a -> [[String, object]]

キーと値のペアを配列に変換して返します。

### def to_hash -> Hash

自身のキー、値をハッシュにしたものを返します。

### def values -> object

データベース中に存在する値全てを含む配列を返します。

### def values_at(*keys) -> [object]

keys に対応する値を配列に格納して返します。

対応するキーが見つからなかった要素には nil が格納されます。

- **param** `keys` -- キーを文字列で指定します。複数指定できます。

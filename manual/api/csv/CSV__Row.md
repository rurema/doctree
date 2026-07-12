---
library: csv
include:
  - Enumerable
extend:
  - Forwardable
---
# class CSV::Row < Object

[c:CSV::Row] は配列やハッシュに似ています。

配列のようにフィールドの順序を保持していて、複製する事もできます。
また、ハッシュのように名前でフィールドにアクセスする事もできます。

ヘッダ行の処理が有効である場合は [c:CSV] から返される全ての行はこのクラスのインスタンスです。

以下のメソッドを [c:Array] に委譲します。

  - empty?()
  - length()
  - size()

## Singleton Methods

### def new(headers, fields, header_row = false) -> CSV::Row

自身を初期化します。

一方の配列が他方の配列よりも短い場合、不足しているところは nil になります。

- **param** `headers` -- ヘッダの配列を指定します。

- **param** `fields` -- フィールドの配列を指定します。

- **param** `header_row` -- ヘッダ行である場合は真を指定します。そうでない場合は偽を指定します。
                  デフォルトは偽です。

```ruby title="例 header_row = true のケース"
require "csv"

header = CSV::Row.new(["header1", "header2"], [], header_row: true)
table = CSV::Table.new([header])
p table.to_a # => [["header1", "header2"]]
```

```ruby title="例 header_row = false のケース"
require "csv"

row1 = CSV::Row.new(["header1", "header2"], ["row1_1", "row1_2"])
row2 = CSV::Row.new(["header1", "header2"], ["row2_1", "row2_2"])
table = CSV::Table.new([row1, row2])
p table.to_a # => [["header1", "header2"], ["row1_1", "row1_2"], ["row2_1", "row2_2"]]
```

- **SEE** [m:CSV::Row#header_row?], [m:CSV::Row#field_row?]

## Instance Methods

### def <<(arg) -> self

自身に与えられたデータを追加します。

- **param** `arg` -- 2 要素の配列か 1 要素のハッシュか任意のオブジェクトを指定します。
           2 要素の配列を与えた場合は、ヘッダとフィールドのペアを追加します。
           1 要素のハッシュを与えた場合は、キーをヘッダ、値をフィールドとして追加します。
           それ以外の場合は、ヘッダを nil 、フィールドを与えられた値として追加します。

- **return** -- メソッドチェーンのために自身を返します。

```ruby title="例 2要素の配列を指定"
require "csv"

row = CSV::Row.new([], [], true)

row << ["header1", "row1_1"]
row << ["header2", "row1_2"]
p row.to_a # => [["header1", "row1_1"], ["header2", "row1_2"]]
```

```ruby title="例 Hash を指定"
require "csv"

row = CSV::Row.new([], [], true)

row << { "header1" => "row1_1" }
row << { "header2" => "row1_2" }
p row.to_a # => [["header1", "row1_1"], ["header2", "row1_2"]]
```

### def ==(other) -> bool

自身が other と同じヘッダやフィールドを持つ場合に真を返します。
そうでない場合は偽を返します。

- **param** `other` -- 比較対象の [c:CSV::Row] のインスタンスを指定します。

```ruby title="例"
require "csv"

row1 = CSV::Row.new(["header1", "header2"], ["row1_1", "row1_2"])
row2 = CSV::Row.new(["header1", "header2"], ["row1_1", "row1_2"])

p row1 == row2 # => true
row2 << ["header3", "row1_3"]
p row1 == row2 # => false
```

### def field(header_or_index, minimum_index = 0) -> object | nil
### def [](header_or_index, minimum_index = 0) -> object | nil

ヘッダの名前かインデックスで値を取得します。フィールドが見つからなかった場合は nil を返します。

- **param** `header_or_index` -- ヘッダの名前かインデックスを指定します。

- **param** `minimum_index` -- このインデックスより後で、ヘッダの名前を探します。
                     重複しているヘッダがある場合に便利です。

```ruby title="例"
require "csv"

row = CSV::Row.new(["header1", "header2"], ["row1_1", "row1_2"])

p row.field("header1") # => "row1_1"
p row.field("header2") # => "row1_2"
p row["header1"]     # => "row1_1"
p row["header2"]     # => "row1_2"
```

### def []=(header_or_index, value)

ヘッダの名前かインデックスでフィールドを探し、値をセットします。

末尾より後ろのインデックスを指定すると、ヘッダの名前は nil になります。
存在しないヘッダを指定すると、新しい要素を末尾に追加します。

- **param** `header_or_index` -- ヘッダの名前かインデックスを指定します。

- **param** `value` -- 値を指定します。

```ruby title="例 ヘッダの名前で指定"
require "csv"

row = CSV::Row.new(["header1", "header2"], ["row1_1", "row1_2"])

p row["header1"]  # => "row1_1"
row["header1"] = "updated"
p row["header1"]  # => "updated"
```

```ruby title="例 ヘッダの index で指定"
require "csv"

row = CSV::Row.new(["header1", "header2"], ["row1_1", "row1_2"])

p row["header1"]  # => "row1_1"
row[0] = "updated"
p row["header1"]  # => "updated"
```

```ruby title="例 ヘッダの名前と offset で指定"
require "csv"

row = CSV::Row.new(["header1", "header2", "header1"], ["row1_1", "row1_2", "row1_3"])

p row  # => #<CSV::Row "header1":"row1_1" "header2":"row1_2" "header1":"row1_3">
row["header1", 1] = "updated"
p row  # => #<CSV::Row "header1":"row1_1" "header2":"row1_2" "header1":"updated">
```


- **SEE** [m:CSV::Row#field]

### def []=(header, offset, value)

ヘッダの名前でフィールドを探し、値をセットします。

- **param** `header` -- ヘッダの名前を指定します。

- **param** `offset` -- このインデックスより後で、ヘッダの名前を探します。
              重複しているヘッダがある場合に便利です。

- **param** `value` -- 値を指定します。

- **SEE** [m:CSV::Row#field]

### def delete(header_or_index, minimum_index = 0) -> [object, object] | nil

ヘッダの名前かインデックスで行からフィールドを削除するために使用します。

- **param** `header_or_index` -- ヘッダの名前かインデックスを指定します。

- **param** `minimum_index` -- このインデックスより後で、ヘッダの名前を探します。
                     重複しているヘッダがある場合に便利です。

- **return** -- 削除したヘッダとフィールドの組を返します。削除対象が見つからなかった場合は nil を返します。

```ruby title="例 ヘッダの名前で指定"
require "csv"

row = CSV::Row.new(["header1", "header2"], ["row1_1", "row1_2"])

p row # => #<CSV::Row "header1":"row1_1" "header2":"row1_2">
row.delete("header1")
p row # => #<CSV::Row "header2":"row1_2">
```

```ruby title="例 ヘッダの index で指定"
require "csv"

row = CSV::Row.new(["header1", "header2"], ["row1_1", "row1_2"])

p row # => #<CSV::Row "header1":"row1_1" "header2":"row1_2">
row.delete(0)
p row # => #<CSV::Row "header2":"row1_2">
```

```ruby title="例 ヘッダの名前と offset で指定"
require "csv"

row = CSV::Row.new(["header1", "header2", "header1"], ["row1_1", "row1_2", "row1_3"])

p row # => #<CSV::Row "header1":"row1_1" "header2":"row1_2" "header1":"row1_3">
row.delete("header1", 1)
p row # => #<CSV::Row "header1":"row1_1" "header2":"row1_2">
```

- **SEE** [m:CSV::Row#field]

### def delete_if{|header, field| ... } -> self

与えられたブロックにヘッダとフィールドのペアを渡して評価します。
評価した結果が真である場合に、その組を自身から削除します。

- **return** -- メソッドチェーンのために自身を返します。

```ruby title="例"
require "csv"

row = CSV::Row.new(["header1", "header2", "header3", "header4"], ["valid1", "valid2", "invalid", "valid4"])

p row # => #<CSV::Row "header1":"valid1" "header2":"valid2" "header3":"invalid" "header4":"valid4">
row.delete_if { |header, field| field == "invalid" }
p row # => #<CSV::Row "header1":"valid1" "header2":"valid2" "header4":"valid4">
```

### def each{|header, field| ... } -> self

与えられたブロックにヘッダとフィールドの組を渡して評価します。

- **return** -- メソッドチェーンのために自身を返します。

```ruby title="例"
require "csv"

row = CSV::Row.new(["header1", "header2", "header3", "header4"], [1, 2, 3, 4])
row.each { |header, field| puts "#{header} - #{field}" }

# => header1 - 1
# => header2 - 2
# => header3 - 3
# => header4 - 4
```

### def empty? -> bool

内部で保持している @row へ委譲します。

#@#noexample

### def field?(data) -> bool

自身に与えられた値が含まれている場合は真を返します。
そうでない場合は偽を返します。

- **param** `data` -- この行に含まれているかどうか調べたい値を指定します。

```ruby title="例"
require "csv"

row = CSV::Row.new(["header1", "header2", "header3", "header4"], [1, 2, 3, 4])
p row.field?(1) # => true
p row.field?(5) # => false
```

### def field_row? -> bool
フィールド行であれば真を返します。そうでなければ偽を返します。

```ruby title="例"
require "csv"

header_row = CSV::Row.new(["header1", "header2"], [], true)
row = CSV::Row.new(["header1", "header2"], [1, 2])
p header_row.field_row? # => false
p row.field_row?      # => true
```

### def fields(*headers_and_or_indices) -> Array
### def values_at(*headers_and_or_indices) -> Array

与えられた引数に対応する値の配列を返します。

要素の探索に [m:CSV::Row#field] を使用しています。

- **param** `headers_and_or_indices` -- ヘッダの名前かインデックスか [c:Range]
                              のインスタンスか第 1 要素がヘッダの名前で
                              第 2 要素がオフセットになっている 2 要素
                              の配列をいくつでも指定します。混在できます。

- **return** -- 引数を与えなかった場合は全ての要素を返します。

`````
require 'csv'
csv = CSV.new("a,b,c\n1,2,3", headers: true)
table = csv.read
row = table.first
row.values_at("a", 1, 2..3) # => ["1", "2", "3", nil]
`````

### def header?(name) -> bool
### def include?(name) -> bool
自身のヘッダに与えられた値が含まれている場合は真を返します。
そうでない場合は偽を返します。

- **param** `name` -- この行のヘッダに含まれているかどうか調べたい値を指定します。

```ruby title="例"
require "csv"

row = CSV::Row.new(["header1", "header2"], [1, 2])
p row.header?("header1") # => true
p row.header?("header3") # => false
```

### def header_row? -> bool
ヘッダ行であれば真を返します。そうでなければ偽を返します。

```ruby title="例"
require "csv"

header_row = CSV::Row.new(["header1", "header2"], [], true)
row = CSV::Row.new(["header1", "header2"], [1, 2])
p header_row.header_row? # => true
p row.header_row?      # => false
```

### def headers -> Array
この行のヘッダのリストを返します。

```ruby title="例"
require "csv"

row = CSV::Row.new(["header1", "header2"], [1, 2])
p row.headers # => ["header1", "header2"]
```

### def index(header, minimum_index = 0) -> Integer

与えられたヘッダの名前に対応するインデックスを返します。

- **param** `header` -- ヘッダの名前を指定します。

- **param** `minimum_index` -- このインデックスより後で、ヘッダの名前を探します。
                     重複しているヘッダがある場合に便利です。

```ruby title="例"
require "csv"

row = CSV::Row.new(["header1", "header2", "header1"], [1, 2, 3])
p row.index("header1")  # => 0
p row.index("header1", 1) # => 2
```

- **SEE** [m:CSV::Row#field]

### def inspect -> String
ASCII 互換であるエンコーディングの文字列で自身の情報を返します。

```ruby title="例"
require "csv"

row = CSV::Row.new(["header1", "header2", "header1"], [1, 2, 3])
p row.inspect # => "#<CSV::Row \"header1\":1 \"header2\":2 \"header1\":3>"
```

### def length -> Integer
### def size -> Integer

[m:Array#length], [m:Array#size] に委譲します。

#@#noexample Array#size の例を参照

- **SEE** [m:Array#size]

### def push(*args) -> self
複数のフィールドを追加するためのショートカットです。

以下とおなじです:
`````
args.each { |arg| csv_row << arg }
`````

- **return** -- メソッドチェーンのために自身を返します。

### def to_csv -> String
### def to_s -> String

自身を CSV な文字列として返します。ヘッダは使用しません。

```ruby title="例"
require "csv"

row = CSV::Row.new(["header1", "header2"], [1, 2])
p row.to_csv                                  # => "1,2\n"
p row.to_csv( {col_sep: "|", row_sep: "<br>"} ) # => "1|2<br>"
```

### def to_hash -> Hash

自身をシンプルなハッシュに変換します。

フィールドの順序は無視されます。
重複したフィールドは削除されます。

```ruby title="例"
require "csv"

row = CSV::Row.new(["header2", "header1", "header2"], [1, 2, 3])
p row.to_hash # => {"header2"=>3, "header1"=>2}
```

#@since 3.1
### def deconstruct -> [object]

パターンマッチに使用する行の値の配列を返します。

```ruby title="例"
require "csv"
row = CSV::Row.new(["header1", "header2", "header3"], [1, 2, 3])
case row
in [2.., 2.., 2..]
  puts "all 2 or more"
in [...2, 2.., 2..]
  puts "first column is less than 2, and rest columns are 2 or more"
end
#=> "first column is less than 2, and rest columns are 2 or more" が出力される
```

- **SEE** [ref:d:spec/pattern_matching#matching_non_primitive_objects]

### def deconstruct_keys(keys) -> Hash

パターンマッチに使用するヘッダの名前と値の [c:Hash] を返します。

このメソッドはヘッダ名の型をシンボルに変換しないため、ヘッダ名が文字列かつ Hash パターン でパターンマッチしたい場合はキーをシンボルに変換する必要があります。

- **param** `keys` -- パターンマッチに使用するヘッダの名前の配列を指定します。nil の場合は全てをパターンマッチに使用します。

```ruby title="例"
require "csv"

row = CSV::Row.new([:header1, :header2, :header3], [1, 2, 3])
case row
in { header1: 2.., header2: 2.., header3: 2.. }
  puts "all 2 or more"
in { header1: ...2, header2: 2.., header3: 2.. }
  puts "first column is less than 2, and rest columns are 2 or more"
end
#=> "first column is less than 2, and rest columns are 2 or more" が出力される
```

- **SEE** [ref:d:spec/pattern_matching#matching_non_primitive_objects]
#@end

## Protected Instance Methods

### def row -> Array

同値性を比較するために使用する内部的なデータです。

#@#noexample

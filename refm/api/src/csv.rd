#@since 1.8.0
CSV (Comma Separated Value) を扱うライブラリです。

= class CSV < Object

CSV (Comma Separated Value) を扱うクラスです。

メソッドの共通パラメタ

  mode
     'r', 'w', 'rb', 'wb' から指定可能です。

     - 'r' 読み込み
     - 'w' 書き込み
     - 'b' バイナリモード
  fs
     フィールドの区切り文字
     デフォルトは ','
  rs
     行区切り文字。nil (デフォルト) で CrLf / Lf。
     Cr で区切りたい場合は ?\r を渡します。

== Class Methods

--- open(path, mode[, fs = nil[, rs = nil]]) { ... }

読み込みモード時には path にあるファイルを開き各行を配列として
ブロックに渡します。

例:

  CSV.open("/temp/test.csv", 'r') do |row|
    puts row.join("<>")
  end

ブロックを渡さなかった場合 CSV::Reader を返します。

書き込みモード時には path にあるファイルを開き CSV::Writer をブロックに渡します。

例:

  CSV.open("/temp/test.csv", 'w') do |writer|
    writer << ["ruby", "perl", "python"]
    writer << ["java", "C", "C++"]
  end

ブロック未指定の場合 CSV::Writer を返します。

#@since 1.8.2

--- foreach(path[, rs = nil]) { ... }

読み込みモードでファイルを開き、各行を配列でブロックに渡します。

例:

  CSV.foreach('test.csv'){|row|
    puts row.join('<>')
  }

--- read(path[, length = nil[, offset = nil]])
--- readlines(path[, rs = nil])

path で指定された CSV ファイルを読み込み、配列の配列でデータを返します。

#@end

--- generate(path[, fs = nil[, rs = nil]]) { ... }

--- parse(str_or_readable[, fs = nil[, rs = nil]])

--- parse_line(src[, fs = nil[, rs = nil]])

--- generate_line(row[, fs = nil[, rs = nil]])

--- parse_row(src, index, out_dev[, fs = nil[, rs = nil]])

--- generate_row(src, cells, out_dev[, fs = nil[, rs = nil]])

#@include(csv/CSV__BasicWriter)
#@include(csv/CSV__Cell)
#@include(csv/CSV__IOBuf)
#@include(csv/CSV__IOReader)
#@include(csv/CSV__IllegalFormatError)
#@include(csv/CSV__Reader)
#@include(csv/CSV__Row)
#@include(csv/CSV__StreamBuf)
#@include(csv/CSV__StringReader)
#@include(csv/CSV__Writer)
#@end

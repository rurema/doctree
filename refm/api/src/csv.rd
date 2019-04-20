category FileFormat

CSV (Comma Separated Values) を扱うライブラリです。

#@# 説明を記述する
#@# 単なる翻訳ではないものを書く

このバージョンの CSV ライブラリは FasterCSV から始まりました。
FasterCSV は Ruby1.8 に標準添付されている CSV ライブラリの置き換えとして開発されました。
このライブラリはユーザの関心事を解決するためにデザインされています。
主なゴールが三つあります。

 (1) ピュア Ruby のままで元の CSV ライブラリよりもかなり速くすること
 (2) 小さくメンテナンスしやすいコードベースであること (FasterCSV はかなり大きく
     機能豊かになりました。構文解析部分のコードはかなり小さいままです)
 (3) CSV のインターフェイスを改善すること

明らかに最後のものは主観的です。変更するやむを得ない理由が無い限り、オリジナルの
インターフェイスに従うようにしたので、おそらく旧 CSV ライブラリとはあまり
大きな違いは無いでしょう。

=== 古い CSV ライブラリとの違い

大きな違いについて言及します。

==== CSV 構文解析

 * このパーサは m17n に対応しています。[[c:CSV]] も参照してください
 * このライブラリはより厳しいパーサを持っているので、問題のあるデータに対して [[c:CSV::MalformedCSVError]] を投げます
 * 旧 CSV ライブラリよりも行末に関しては寛容ではありません。あなたが :row_sep としてセットした値が法です。
   しかし、自動検出させることもできます
 * 旧ライブラリでは空行に対して [nil] を返しますが、このライブラリは空の配列を返します
 * このライブラリはかなり速いパーサを持っています

==== インターフェイス

 * オプションをセットするのにハッシュ形式の引数を使うようになりました
 * CSV#generate_row, CSV#parse_row はなくなりました
 * 古い CSV::Reader, CSV::Writer クラスはなくなりました
 * [[m:CSV.open]] はより Ruby らしくなりました
 * [[c:CSV]] オブジェクトは [[c:IO]] の多くのメソッドをサポートするようになりました
 * 文字列や IO のようなオブジェクトを読み書きするためにラップする [[m:CSV.new]] メソッドが追加されました
 * [[m:CSV.generate]] は古いものとは異なります
 * 部分読み出しはもうサポートしていません。読み込みは行単位で行います
 * パフォーマンスのため、インスタンスメソッドでセパレータを上書き出来なくなりました。
   [[m:CSV.new]] でセットするようにしてください。

=== CSV とは

CSV ライブラリは [[RFC:4180]] から直接とられたかなり厳しい定義を維持します。
一ヶ所だけ定義を緩和することでこのライブラリを使いやすくしています。[[c:CSV]] は
すべての有効な CSV ファイルをパースします。

不正な CSV データを与えたくない。あるフィールドが不正であることが確定す
るのはファイルを全て読み込んだ後です。これは多くの時間やメモリを消費し
ます。

Ruby の組込みメソッドはほとんど全ての点でより優れています。運が良ければ
不正な CSV データを与えても動きます。例えば、クオートされていないフィー
ルドだけを持つ CSV データは次のように簡単にパースできます。

  data.split(",")

= class CSV < Object
extend Forwardable
include Enumerable

#@# 説明を記述する

このクラスは CSV ファイルやデータに対する完全なインターフェイスを提供します。

=== 読み込み

#@samplecode
require 'csv'

# ファイルから一行ずつ
CSV.foreach("path/to/file.csv") do |row|
  # use row here...
end

# ファイルから一度に
arr_of_arrs = CSV.read("path/to/file.csv")

# 文字列から一行ずつ
CSV.parse("CSV,data,String") do |row|
  # use row here...
end

# 文字列から一行ずつ
arr_of_arrs = CSV.parse("CSV,data,String")
#@end

=== 書き込み

#@samplecode
require 'csv'

# ファイルへ書き込み
CSV.open("path/to/file.csv", "wb") do |csv|
  csv << ["row", "of", "CSV", "data"]
  csv << ["another", "row"]
  # ...
end

# 文字列へ書き込み
csv_string = CSV.generate do |csv|
  csv << ["row", "of", "CSV", "data"]
  csv << ["another", "row"]
  # ...
end
#@end

=== 一行変換

#@samplecode
require 'csv'

csv_string = ["CSV", "data"].to_csv   # => "CSV,data"
csv_array  = "CSV,String".parse_csv   # => ["CSV", "String"]
#@end

=== ショートカット

#@samplecode
require 'csv'

CSV             { |csv_out| csv_out << %w{my data here} }  # to $stdout
CSV(csv = "")   { |csv_str| csv_str << %w{my data here} }  # to a String
CSV($stderr)    { |csv_err| csv_err << %w{my data here} }  # to $stderr
#@end

=== CSV と文字エンコーディング (M17n or Multilingualization)

This new CSV parser is m17n savvy.  The parser works in the Encoding of the IO
or String object being read from or written to.  Your data is never transcoded
(unless you ask Ruby to transcode it for you) and will literally be parsed in
the Encoding it is in.  Thus CSV will return Arrays or Rows of Strings in the
Encoding of your data.  This is accomplished by transcoding the parser itself
into your Encoding.

Some transcoding must take place, of course, to accomplish this multiencoding
support.  For example, <tt>:col_sep</tt>, <tt>:row_sep</tt>, and
<tt>:quote_char</tt> must be transcoded to match your data.  Hopefully this
makes the entire process feel transparent, since CSV's defaults should just
magically work for you data.  However, you can set these values manually in
the target Encoding to avoid the translation.

It's also important to note that while all of CSV's core parser is now
Encoding agnostic, some features are not.  For example, the built-in
converters will try to transcode data to UTF-8 before making conversions.
Again, you can provide custom converters that are aware of your Encodings to
avoid this translation.  It's just too hard for me to support native
conversions in all of Ruby's Encodings.

Anyway, the practical side of this is simple:  make sure IO and String objects
passed into CSV have the proper Encoding set and everything should just work.
CSV methods that allow you to open IO objects (CSV::foreach(), CSV::open(),
CSV::read(), and CSV::readlines()) do allow you to specify the Encoding.

One minor exception comes when generating CSV into a String with an Encoding
that is not ASCII compatible.  There's no existing data for CSV to use to
prepare itself and thus you will probably need to manually specify the desired
Encoding for most of those cases.  It will try to guess using the fields in a
row of output though, when using CSV::generate_line() or Array#to_csv().

== Constants

--- DateMatcher -> Regexp

日付 (Date) 形式のデータを発見したり変換したりするための正規表現です。

--- DateTimeMatcher -> Regexp

日時 (DateTime) 形式のデータを発見したり変換したりするための正規表現です。

--- ConverterEncoding -> Encoding

すべての変換器で使用するエンコーディングです。

--- Converters -> Hash

このハッシュは名前でアクセスできる組み込みの変換器を保持しています。

[[m:CSV#convert]] で使用する変換器として使用できます。
また [[m:CSV.new]] のオプションとして使用することもできます。

: :integer
  [[m:Kernel.#Integer]] を使用してフィールドを変換します。
: :float
  [[m:Kernel.#Float]] を使用してフィールドを変換します。
: :numeric
  :integer と :float の組み合わせです。
: :date
  [[m:Date.parse]] を使用してフィールドを変換します。
: :date_time
  [[m:DateTime.parse]] を使用してフィールドを変換します。
: :all
  :date_time と :numeric の組み合わせです。

全ての組み込みの変換器は、実際に変換する前にフィールドのデータの
文字エンコーディングを UTF-8 に変換します。そのデータの文字エンコーディング
を UTF-8 に変換出来なかった場合は、変換には失敗しますが、データは変更されません。

このハッシュは [[m:Object#freeze]] されていないので、ユーザは自由に値を
追加することが出来ます。

複数の変換器を持つ要素を追加するときは、値に名前の配列を指定する必要が
あります。この要素の値には他の複数の変換器を持つ要素の名前を指定するこ
ともできます。

--- HeaderConverters -> Hash

このハッシュは名前でアクセスできる組み込みのヘッダ用変換器を保存しています。

[[m:CSV#header_convert]] で使用する変換器として使用できます。
また [[m:CSV.new]] のオプションとして使用することもできます。

: :downcase
  ヘッダの文字列に対して [[m:String#downcase]] を呼び出します。
: :symbol
  ヘッダの文字列を小文字に変換してから、空白文字列 (\s) をアンダースコアに
  置換し、非英数字 (\W) を削除します。最後に [[m:String#to_sym]] を呼び出します。

全ての組み込みのヘッダ用変換器は、実際に変換する前にヘッダのデータの
文字エンコーディングを UTF-8 に変換します。そのヘッダの文字エンコーディング
を UTF-8 に変換できなかった場合は、変換には失敗しますが、データは変更されません。

このハッシュは [[m:Object#freeze]] されていないので、ユーザは自由に値を
追加することが出来ます。

複数の変換器を持つ要素を追加するときは、値に名前の配列を指定する必要が
あります。この要素の値には他の複数の変換器を持つ要素の名前を指定するこ
ともできます。

--- DEFAULT_OPTIONS -> Hash

このオプションは呼び出し側で上書きしなかったときに使用するオプションです。

: :col_sep
  ","
: :row_sep
  :auto
: :quote_char
  '"'
: :field_size_limit
  nil
: :converters
  nil
: :unconverted_fields
  nil
: :headers
  false
: :return_headers
  false
: :header_converters
  nil
: :skip_blanks
  false
: :force_quotes
  false
: :skip_lines
  nil

--- VERSION -> String

ライブラリのバージョンを表す文字列です。

#@if (version == "1.9.1")
2.4.5
#@end
#@if (version == "1.9.2")
2.4.7
#@end

== Singleton Methods

--- new(data, options = Hash.new) -> CSV

このメソッドは CSV ファイルを読み込んだり、書き出したりするために
[[c:String]] か [[c:IO]] のインスタンスをラップします。

ラップされた文字列の先頭から読み込むことになります。
文字列に追記したい場合は [[m:CSV.generate]] を使用してください。
他の位置から処理したい場合はあらかじめそのように設定した [[c:StringIO]] を渡してください。

@param data [[c:String]] か [[c:IO]] のインスタンスを指定します。
            [[c:String]] のインスタンスを指定した場合、[[m:CSV#string]] を使用して
            後からデータを取り出すことが出来ます。

@param options CSV をパースするためのオプションをハッシュで指定します。
               パフォーマンス上の理由でインスタンスメソッドではオプションを上書きすることが
               出来ないので、上書きしたい場合は必ずここで上書きするようにしてください。

: :col_sep
  フィールドの区切り文字列を指定します。この文字列はパースする前にデータの
  エンコーディングに変換されます。
: :row_sep
  行区切りの文字列を指定します。:auto という特別な値をセットすることができます。
  :auto を指定した場合データから自動的に行区切りの文字列を見つけ出します。このとき
  データの先頭から次の "\r\n", "\n", "\r" の並びまでを読みます。
  A sequence will be selected even if it occurs in a quoted field, assuming that you
  would have the same line endings there.  If none of those sequences is
  found, +data+ is [[c:ARGF]], [[m:Object::STDIN]], [[m:Object::STDOUT]], or
  [[m:Object::STDERR]], or the stream is only  available for output, the default
  [[m:$INPUT_RECORD_SEPARATOR]]  ([[m:$/]]) is used.  Obviously,
  discovery takes a little time.  Set  manually if speed is important.  Also
  note that IO objects should be opened  in binary mode on Windows if this
  feature will be used as the  line-ending translation can cause
  problems with resetting the document  position to where it was before the
  read ahead. This String will be  transcoded into the data's Encoding  before parsing.
: :quote_char
  フィールドをクオートする文字を指定します。長さ 1 の文字列でなければなりません。
  正しいダブルクオートではなく間違ったシングルクオートを使用しているアプリケーション
  で便利です。
  CSV will always consider a double  sequence this character to be an
  escaped quote.
  この文字列はパースする前にデータのエンコーディングに変換されます。
: :field_size_limit
  This is a maximum size CSV will read  ahead looking for the closing quote
  for a field.  (In truth, it reads to  the first line ending beyond this
  size.)  If a quote cannot be found  within the limit CSV will raise a
  MalformedCSVError, assuming the data  is faulty.  You can use this limit to
  prevent what are effectively DoS  attacks on the parser.  However, this
  limit can cause a legitimate parse to  fail and thus is set to +nil+, or off,
  by default.
: :converters
  [[m:CSV::Converters]] から取り出した名前の配列です。変換器が一つだけ
  の場合は配列に格納する必要はありません。
  全ての組み込みの変換器は、値を変換する前に UTF-8 にエンコーディング変
  換を試みます。エンコーディング変換に失敗した場合はフィールドは変換さ
  れません。
: :unconverted_fields
  真をセットすると [[m:CSV::Row#unconverted_fields]] という変換前のフィー
  ルドを返すメソッドを全ての行に追加します。headers オプションによって
  追加したヘッダはフィールドではないので
  [[m:CSV::Row#unconverted_fields]] は空の配列を返します。
: :headers
  :first_row というシンボルか真を指定すると、CSV ファイルの一行目をヘッダとして扱います。
  配列を指定するとそれをヘッダとして扱います。文字列を指定すると [[m:CSV.parse_line]] を
  使用してパースした結果をヘッダとして扱います。このとき、:col_sep, :row_sep, :quote_char
  はこのインスタンスと同じものを使用します。この設定は [[m:CSV#shift]]
  の返り値を配列のかわりに [[c:CSV::Row]] のインスタンスに変更します。
  [[m:CSV#read]] の返り値を配列の配列のかわりに [[c:CSV::Table]] のイン
  スタンスに変更します。
: :return_headers
  偽を指定すると、ヘッダ行を無視します。真を指定すると、ヘッダ行を
  ヘッダと値が同一の [[c:CSV::Row]] のインスタンスとして返します。
: :write_headers
  真を指定して :headers にも値をセットすると、ヘッダを出力します。
: :header_converters
  :converters オプションに似ていますが、ヘッダ専用の変換器を定義します。
  全ての組み込みの変換器は、値を変換する前に UTF-8 にエンコーディング変
  換を試みます。エンコーディング変換に失敗した場合はヘッダは変換されま
  せん。
: :skip_blanks
  真を指定すると、空行を読み飛ばします。
: :force_quotes
  真を指定すると、全てのフィールドを作成時にクオートします。
: :skip_lines
  指定した正規表現にマッチしたそれぞれの行をコメントとして読み飛ばします。

@raise CSV::MalformedCSVError 不正な CSV をパースしようとしたときに発生します。

#@samplecode 例: ファイルの読み込み
require "csv"

users =<<-EOS
id,first name,last name,age
1,taro,tanaka,20
2,jiro,suzuki,18
3,ami,sato,19
4,yumi,adachi,21
EOS

File.write("test.csv", users)

File.open("test.csv", "r") do |f|
  csv = CSV.new(f, headers: true)
  csv.class # => CSV
  csv.first # => #<CSV::Row "id":"1" "first name":"taro" "last name":"tanaka" "age":"20">
end
#@end

#@samplecode 例 文字列の読み込み
require "csv"

users =<<-EOS
id|first name|last name|age
1|taro|tanaka|20
2|jiro|suzuki|18
3|ami|sato|19
4|yumi|adachi|21
EOS

csv = CSV.new(users, { headers: true, col_sep: "|" })
p csv.class # => CSV
p csv.first # => #<CSV::Row "id":"1" "first name":"taro" "last name":"tanaka" "age":"20">
#@end

@see [[m:CSV::DEFAULT_OPTIONS]], [[m:CSV.open]]

--- filter(options = Hash.new){|row| ... }
--- filter(input, options = Hash.new){|row| ... }
--- filter(input, output, options = Hash.new){|row| ... }
#@# -> discard

このメソッドは CSV データに対して Unix のツール群のようなフィルタを構築
するのに便利です。

与えられたブロックに一行ずつ渡されます。ブロックに渡された行は必要であ
れば変更することができます。ブロックの評価後に行を全て output に書き込
みます。

@param input [[c:String]] か [[c:IO]] のインスタンスを指定します。
             デフォルトは [[c:ARGF]] です。

@param output [[c:String]] か [[c:IO]] のインスタンスを指定します。
              デフォルトは [[m:$stdout]] です。

@param options ":in_", ":input_" で始まるキーは input にだけ適用されます。
               ":out_", ":output_" で始まるキーは output にだけ適用されます。
               それ以外のキーは両方に適用されます。
               ":output_row_sep" のデフォルト値は [[m:$/]] です。

@see [[m:CSV.new]]

--- foreach(path, options = Hash.new){|row| ... } -> nil

このメソッドは CSV ファイルを読むための主要なインターフェイスです。
各行が与えられたブロックに渡されます。

#@samplecode 例
require 'csv'

# UTF-32BE な CSV ファイルを読み込んで UTF-8 な row をブロックに渡します
CSV.foreach("a.csv", encoding: "UTF-32BE:UTF-8"){|row| p row }
#@end

@param path CSV ファイルのパスを指定します。

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。
               :encoding というキーを使用すると入出力のエンコーディングを指定することができます。
               [[m:Encoding.default_external]] と異なるエンコーディングを持つ入力を使用する場合は、
               必ずエンコーディングを指定してください。

@see [[m:CSV.new]], [[m:File.open]]

--- generate(str = "", options = Hash.new){|csv| ... } -> String

このメソッドは与えられた文字列をラップして [[c:CSV]] のオブジェクトとしてブロックに渡します。
ブロック内で [[c:CSV]] オブジェクトに行を追加することができます。
ブロックを評価した結果は文字列を返します。

このメソッドに与えられた文字列は変更されるので、新しい文字列オブジェクトが必要な
場合は [[m:Object#dup]] で複製してください。

@param str 文字列を指定します。デフォルトは空文字列です。
#@if( version >= "2.5.0" and version < "2.6.0" )
           2.5.0 では不具合により引数 str を与えた場合の動作に問題があ
           るため、指定したい場合は csv gem を 1.0.1 以上に更新する必
           要があります。
#@end

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。
               :encoding というキーを使用すると出力のエンコーディングを指定することができます。
               ASCII と互換性の無い文字エンコーディングを持つ文字列を出力する場合は、このヒントを
               指定する必要があります。

#@samplecode 例
require "csv"

text =<<-EOS
id,first name,last name,age
1,taro,tanaka,20
2,jiro,suzuki,18
3,ami,sato,19
4,yumi,adachi,21
EOS

csv = CSV.generate(text, headers: true) do |csv|
  csv.add_row(["5", "saburo", "kondo", "34"])
end

print csv
# => id,first name,last name,age
# 1,taro,tanaka,20
# 2,jiro,suzuki,18
# 3,ami,sato,19
# 4,yumi,adachi,21
# 5,saburo,kondo,34
#@end

@see [[m:CSV.new]]

--- generate_line(row, options = Hash.new) -> String

このメソッドは一つの [[c:Array]] オブジェクトを CSV 文字列に変換するためのショートカットです。

このメソッドは可能であれば row に含まれる最初の nil でない値を用いて出力の
エンコーディングを推測します。

@param row 文字列の配列を指定します。

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。
               :encoding というキーを使用すると出力のエンコーディングを指定することができます。
               :row_sep というキーの値には [[m:$/]] がセットされます。

#@samplecode 例
require "csv"

taro = ['1', 'taro', 'tanaka', '20']
CSV.generate_line(taro, col_sep: '|') # => "1|taro|tanaka|20\n"
#@end

@see [[m:CSV.new]]

--- instance(data = $stdout, options = Hash.new) -> CSV
--- instance(data = $stdout, options = Hash.new){|csv| ... } -> object

このメソッドは [[m:CSV.new]] のように [[c:CSV]] のインスタンスを返します。
しかし、返される値は [[m:Object#object_id]] と与えられたオプションを
キーとしてキャッシュされます。

ブロックが与えられた場合、生成されたインスタンスをブロックに渡して評価した
結果を返します。

@param data [[c:String]] か [[c:IO]] のインスタンスを指定します。

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。

@see [[m:CSV.new]]

--- open(filename, mode = "rb", options = Hash.new){|csv| ... } -> nil
--- open(filename, mode = "rb", options = Hash.new) -> CSV
--- open(filename, options = Hash.new){|csv| ... } -> nil
--- open(filename, options = Hash.new) -> CSV

このメソッドは [[c:IO]] オブジェクトをオープンして [[c:CSV]] でラップします。
これは CSV ファイルを書くための主要なインターフェイスとして使うことを意図しています。

このメソッドは [[m:IO.open]] と同じように動きます。ブロックが与えられた場合は
ブロックに [[c:CSV]] オブジェクトを渡し、ブロック終了時にそれをクローズします。
ブロックが与えられなかった場合は [[c:CSV]] オブジェクトを返します。

データが [[m:Encoding.default_external]] と異なる場合は、mode にエンコー
ディングを指定する文字列を埋め込まなければなりません。データをどのよう
に解析するか決定するために CSV ライブラリはユーザが mode に指定したエン
コーディングをチェックします。"rb:UTF-32BE:UTF-8" のように mode を指定
すると UTF-32BE のデータを読み込んでUTF-8 に変換してから解析します。

また "rb:BOM|UTF-8" のように mode を指定すると BOM を自動的に取り除きま
す。

CSV オブジェクトは多くのメソッドを [[c:IO]] や [[c:File]] に委譲します。

  * [[m:IO#binmode]]
  * [[m:IO#binmode?]]
  * [[m:IO#close]]
  * [[m:IO#close_read]]
  * [[m:IO#close_write]]
  * [[m:IO#closed?]]
  * [[m:IO#eof]]
  * [[m:IO#eof?]]
  * [[m:IO#external_encoding]]
  * [[m:IO#fcntl]]
  * [[m:IO#fileno]]
  * [[m:File#flock]]
  * [[m:IO#flush]]
  * [[m:IO#fsync]]
  * [[m:IO#internal_encoding]]
  * [[m:IO#ioctl]]
  * [[m:IO#isatty]]
  * [[m:File#path]]
  * [[m:IO#pid]]
  * [[m:IO#pos]]
  * [[m:IO#pos=]]
  * [[m:IO#reopen]]
  * [[m:IO#seek]]
  * [[m:IO#stat]]
  * [[m:StringIO#string]]
  * [[m:IO#sync]]
  * [[m:IO#sync=]]
  * [[m:IO#tell]]
  * [[m:IO#to_i]]
  * [[m:IO#to_io]]
  * [[m:File#truncate]]
  * [[m:IO#tty?]]

@param filename ファイル名を指定します。

@param mode [[m:IO.open]] に指定できるものと同じものを指定できます。

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。

#@samplecode 例 読み取り・ブロック指定なし
require "csv"

File.write("test.csv", <<CSV)
id,first name,last name,age
1,taro,tanaka,20
2,jiro,suzuki,18
3,ami,sato,19
4,yumi,adachi,21
CSV
csv = CSV.open("test.csv", headers: true)
csv.class # => CSV
csv.first # => #<CSV::Row "id":"1" "first name":"taro" "last name":"tanaka" "age":"20">
#@end

#@samplecode 例 読み取り・ブロック指定あり
require "csv"

users =<<-EOS
id,first name,last name,age
1,taro,tanaka,20
2,jiro,suzuki,18
3,ami,sato,19
4,yumi,adachi,21
EOS

File.write("test.csv", users)
CSV.open("test.csv", headers: true) do |csv|
  csv.class # => CSV
  csv.first # => #<CSV::Row "id":"1" "first name":"taro" "last name":"tanaka" "age":"20">
end
#@end

#@samplecode 例 書き込み・ブロック指定あり
require "csv"

CSV.open("test.csv", "w") do |csv|
  csv << ["id", "first name", "last name", "age"]
  csv << ["1", "taro", "tanaka", "20"]
  csv << ["2", "jiro", "suzuki", "18"]
  csv << ["3", "ami", "sato", "19"]
  csv << ["4", "yumi", "adachi", "21"]
end
print File.read("test.csv")

# => id,first name,last name,age
#    1,taro,tanaka,20
#    2,jiro,suzuki,18
#    3,ami,sato,19
#    4,yumi,adachi,21
#@end

@see [[m:CSV.new]], [[m:IO.open]]

--- parse(str, options = Hash.new){|row| ... } -> nil
--- parse(str, options = Hash.new) -> Array

このメソッドは文字列を簡単にパースすることができます。
ブロックを与えた場合は、ブロックにそれぞれの行を渡します。
ブロックを省略した場合は、配列の配列を返します。

@param str 文字列を指定します。

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。

#@samplecode 例
require 'csv'
require 'pp'

s = <<EOS
id,first name,last name,age
1,taro,tanaka,20
2,jiro,suzuki,18
EOS

pp CSV.parse(s)
# => [["id", "first name", "last name", "age"],
#     ["1", "taro", "tanaka", "20"],
#     ["2", "jiro", "suzuki", "18"]]

CSV.parse(s, headers: true).each do |row|
  p [row['first name'], row['age']]
end
# => ["taro", "20"]
#    ["jiro", "18"]
#@end

#@samplecode 例
require "csv"

csv = "id|first name|last name|age\n1|taro|tanaka|20\n2|jiro|suzuki|18"
CSV.parse(csv, col_sep: '|') do |row|
  p [row[1], row[2]]
end
# => ["first name", "last name"]
# => ["taro", "tanaka"]
# => ["jiro", "suzuki"]
#@end

--- parse_line(line, options = Hash.new) -> Array

このメソッドは一行の CSV 文字列を配列に変換するためのショートカットです。

@param line 文字列を指定します。複数行の文字列を指定した場合は、一行目以外は無視します。

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。

#@samplecode 例
require 'csv'

p CSV.parse_line("1,taro,tanaka,20")
# => ["1", "taro", "tanaka", "20"]

p CSV.parse_line("1|taro|tanaka|20", col_sep: '|')
# => ["1", "taro", "tanaka", "20"]

# 列をダブルクオートで囲むとその中にカンマや改行を含める事もできる。
# 他の仕様も含め詳しくはRFC4180を参照。
p CSV.parse_line("1,\"ta,ro\",\"tana\nka\", 20")
# => ["1", "ta,ro", "tana\nka", " 20"]
#@end

--- read(path, options = Hash.new) -> [Array] | CSV::Table
--- readlines(path, options = Hash.new) -> [Array] | CSV::Table

CSV ファイルを配列の配列にするために使います。
headers オプションに偽でない値を指定した場合は [[c:CSV::Table]] オブジェクトを返します。

@param path CSV ファイルのパスを指定します。

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。
               :encoding というキーを使用すると入力のエンコーディングを指定することができます。
               入力のエンコーディングか [[m:Encoding.default_external]] と異なる場合は
               必ず指定しなければなりません。

#@samplecode 例
require "csv"
require "pp"

File.write("test.csv", <<CSV)
id,first name,last name,age
1,taro,tanaka,20
2,jiro,suzuki,18
3,ami,sato,19
4,yumi,adachi,21
CSV

pp CSV.read("test.csv")

# => [["id", "first name", "last name", "age"],
#    ["1", "taro", "tanaka", "20"],
#    ["2", "jiro", "suzuki", "18"],
#    ["3", "ami", "sato", "19"],
#    ["4", "yumi", "adachi", "21"]]
#@end

#@samplecode 例
require "csv"

File.write("test.csv", <<CSV)
id,first name,last name,age
1,taro,tanaka,20
2,jiro,suzuki,18
3,ami,sato,19
4,yumi,adachi,21
CSV

table = CSV.read("test.csv", headers: true)
p table.class # => CSV::Table
p table[0]    # => #<CSV::Row "id":"1" "first name":"taro" "last name":"tanaka" "age":"20">
#@end

@see [[m:CSV.new]], [[m:CSV.table]]

--- table(path, options = Hash.new) -> CSV::Table | [Array]

以下と同等のことを行うメソッドです。
日本語の CSV ファイルを扱う場合はあまり使いません。

#@samplecode
CSV.read( path, { headers:           true,
                  converters:        :numeric,
                  header_converters: :symbol }.merge(options) )
#@end

@param path ファイル名を指定します。

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。

#@#noexample CSV.readを参照。

@see [[m:CSV.read]]

== Instance Methods

--- <<(row)      -> self
--- add_row(row) -> self
--- puts(row)    -> self

自身に row を追加します。

データソースは書き込み用にオープンされていなければなりません。

@param row 配列か [[c:CSV::Row]] のインスタンスを指定します。
           [[c:CSV::Row]] のインスタンスが指定された場合は、[[m:CSV::Row#fields]] の値
           のみが追加されます。

#@samplecode 例 配列を指定
require "csv"

File.write("test.csv", <<CSV)
id,first name,last name,age
1,taro,tanaka,20
2,jiro,suzuki,18
3,ami,sato,19
4,yumi,adachi,21
CSV
CSV.open("test.csv", "a") do |csv|
  csv.puts(["5", "saburo", "kondo", "34"])
end

print File.read("test.csv")
# => id,first name,last name,age
#    1,taro,tanaka,20
#    2,jiro,suzuki,18
#    3,ami,sato,19
#    4,yumi,adachi,21
#    5,saburo,kondo,34
#@end

#@samplecode 例 CSV::Row を指定
require "csv"

File.write("test.csv", <<CSV)
id,first name,last name,age
1,taro,tanaka,20
2,jiro,suzuki,18
3,ami,sato,19
4,yumi,adachi,21
CSV
CSV.open("test.csv", "a") do |csv|
  row = CSV::Row.new(["id", "first name", "last name", "age"], ["5", "saburo", "kondo", "34"])
  csv.add_row(row)
end

print File.read("test.csv")
# => "id", first name,last name,age
#    1,taro,tanaka,20
#    2,jiro,suzuki,18
#    3,ami,sato,19
#    4,yumi,adachi,21
#    5,saburo,kondo,34
#@end

--- binmode -> self

[[m:IO#binmode]] に委譲します。

#@#noexample IO#binmode の例を参照

@see [[m:IO#binmode]]

--- binmode? -> bool

[[m:IO#binmode?]] に委譲します。

#@#noexample IO#binmode? の例を参照

@see [[m:IO#binmode?]]

--- close -> nil

[[m:IO#close]] に委譲します。

#@#noexample IO#close の例を参照

@see [[m:IO#close]]

--- close_read -> nil

[[m:IO#close_read]] に委譲します。

#@#noexample IO#close_read の例を参照

@see [[m:IO#close_read]]

--- close_write -> nil

[[m:IO#close_write]] に委譲します。

#@#noexample IO#close_write の例を参照

@see [[m:IO#close_write]]

--- closed? -> bool

[[m:IO#closed?]] に委譲します。

#@#noexample IO#closed? の例を参照

@see [[m:IO#closed?]]

--- col_sep -> String

カラム区切り文字列として使用する文字列を返します。

#@samplecode 例
require "csv"

users =<<-EOS
id|first name|last name|age
1|taro|tanaka|20
2|jiro|suzuki|18
3|ami|sato|19
4|yumi|adachi|21
EOS

csv = CSV.new(users, headers: true, col_sep: "|")
csv.col_sep # => "|"
csv.first.to_a # => [["id", "1"], ["first name", "taro"], ["last name", "tanaka"], ["age", "20"]]

csv = CSV.new(users, headers: true)
csv.col_sep # => ","
csv.first.to_a # => [["id|first name|last name|age", "1|taro|tanaka|20"]]
#@end

@see [[m:CSV.new]]

--- convert(name)
--- convert{|field| ... }
--- convert{|field, field_info| ... }
#@# discard

引数 name で指定した変換器かブロックに各フィールドを渡して文字列から別
のオブジェクトへと変換します。

引数 name を指定した場合は、組み込みの [[m:CSV::Converters]] を変換器
として利用するために使います。また、独自の変換器を追加することもできま
す。

ブロックパラメータを一つ受け取るブロックを与えた場合は、そのブロックは
フィールドを受け取ります。ブロックパラメータを二つ受け取るブロックを与
えた場合は、そのブロックは、フィールドと [[c:CSV::FieldInfo]] のインス
タンスを受け取ります。ブロックは変換後の値かフィールドそのものを返さな
ければなりません。

@param name 変換器の名前を指定します。

#@samplecode 例 name で Converter を指定
require "csv"

csv = CSV.new("date1,date2\n2018-07-09,2018-07-10")
csv.convert(:date)
csv.read # => [["date1", "date2"], [#<Date: 2018-07-09 ((2458309j,0s,0n),+0s,2299161j)>, #<Date: 2018-07-10 ((2458310j,0s,0n),+0s,2299161j)>]]
#@end

#@samplecode 例 ブロックを指定
require "csv"

csv = CSV.new("date1,date2\n2018-07-09,2018-07-10", headers: true)
csv.convert do |field,field_info|
  p field
  p field_info
  Date.parse(field)
end
p csv.first

# => "2018-07-09"
# => <struct CSV::FieldInfo index=0, line=2, header="date1">
# => "2018-07-10"
# => #<struct CSV::FieldInfo index=1, line=2, header="date2">
# => #<CSV::Row "date1":#<Date: 2018-07-09 ((2458309j,0s,0n),+0s,2299161j)> "date2":#<Date: 2018-07-10 ((2458310j,0s,0n),+0s,2299161j)>>
#@end

@see [[m:CSV#converters]], [[m:CSV#header_convert]]

--- converters -> Array

現在の変換器のリストを返します。

#@samplecode 例
require "csv"

csv = CSV.new("header1,header2\nrow1_1,row1_2", { converters: CSV::Converters.keys })
csv.converters  # => [:integer, :float, :integer, :float, :date, :date_time, :date_time, :integer, :float]
#@end

@see [[m:CSV::Converters]]

--- each{|row| ... } -> nil

各行に対してブロックを評価します。

データソースは読み込み用にオープンされていなければなりません。

--- encoding -> Encoding

読み書きするときに使用するエンコーディングを返します。

#@samplecode 例
require "csv"

csv = CSV.new("header1,header2\nrow1_1,row1_2", headers: true)
csv.encoding # => #<Encoding:UTF-8>
#@end

--- eof -> bool
--- eof? -> bool

[[m:IO#eof]], [[m:IO#eof?]] に委譲します。

#@#noexample IO#eof, IO#eof? の例を参照

@see [[m:IO#eof]], [[m:IO#eof?]]

--- external_encoding -> Encoding | nil

[[m:IO#external_encoding]] に委譲します。

--- fcntl(cmd, arg = 0)    -> Integer

[[m:IO#fcntl]] に委譲します。

--- field_size_limit -> Integer

フィールドサイズの最大値を返します。

#@samplecode 例
require "csv"

csv = CSV.new(DATA)
csv.field_size_limit # => nil
p csv.read # => [["a", "b"], ["\n2\n2\n", ""]]

DATA.rewind
csv = CSV.new(DATA, field_size_limit: 4)
p csv.field_size_limit # => 4
csv.read # => #<CSV::MalformedCSVError: Field size exceeded on line 2.>

__END__
"a","b"
"
2
2
",""
#@end

@see [[m:CSV.new]]

--- fileno -> Integer
--- to_i   -> Integer

[[m:IO#fileno]], [[m:IO#to_i]] に委譲します。

--- flock(operation)    -> 0 | false

[[m:File#flock]] に委譲します。

--- flush    -> self

[[m:IO#flush]] に委譲します。

--- force_quotes? -> bool

出力される全てのフィールドがクオートされる場合は、真を返します。

#@samplecode 例
require "csv"

rows = [["header1", "header2"], ["row1_1,", "row1_2"]]
result = CSV.generate(force_quotes: false) do |csv|
  rows.each { |row| csv << row }
  csv.force_quotes? # => false
end
print result

# => header1,header2
#    "row1_1,",row1_2
#@end

#@samplecode 例
require "csv"

rows = [["header1", "header2"], ["row1_1,", "row1_2"]]
result = CSV.generate(force_quotes: true) do |csv|
  rows.each { |row| csv << row }
  csv.force_quotes? # => true
end
print result

# => true
# => "header1","header2"
#    "row1_1,","row1_2"
#@end

@see [[m:CSV.new]]

--- fsync -> 0 | nil

[[m:IO#fsync]] に委譲します。

--- header_convert(name)
--- header_convert{|field| ... }
--- header_convert{|field, field_info| ... }

[[m:CSV#convert]] に似ていますが、ヘッダ行用のメソッドです。

このメソッドはヘッダ行を読み込む前に呼び出さなければなりません。

@param name 変換器の名前を指定します。

#@samplecode 例 name を指定
require "csv"

csv = CSV.new("header1,header2\nrow1_1,row1_2", { headers: true })
csv.header_convert(:symbol)
csv.first.headers # => [:header1, :header2]
#@end

#@samplecode 例 ブロックを指定
require "csv"

csv = CSV.new("header1,header2\nrow1_1,row1_2", { headers: true })
csv.header_convert do |field|
  field.to_sym
end
csv.first.headers # => [:header1, :header2]
#@end

@see [[m:CSV#header_converters]], [[m:CSV#convert]]

--- header_converters -> Array

現在有効なヘッダ用変換器のリストを返します。

組込みの変換器は名前を返します。それ以外は、オブジェクトを返します。

#@samplecode 例
require "csv"

csv = CSV.new("HEADER1,HEADER2\nrow1_1,row1_2", headers: true, header_converters: CSV::HeaderConverters.keys)
csv.header_converters # => [:downcase, :symbol]
csv.read.to_a         # => [[:header1, :header2], ["row1_1", "row1_2"]]
#@end

@see [[m:CSV.new]]

--- header_row? -> bool

次に読み込まれる行が、ヘッダである場合に真を返します。
そうでない場合は、偽を返します。

#@samplecode 例
require "csv"

csv = CSV.new("header1,header2\nrow1_1,row1_2", headers: true)
csv.header_row? # => true
csv.readline
csv.header_row? # => false
#@end

--- headers -> Array | true | nil

nil を返した場合は、ヘッダは使用されません。
真を返した場合は、ヘッダを使用するが、まだ読み込まれていません。
配列を返した場合は、ヘッダは既に読み込まれています。

#@samplecode 例
require "csv"

csv = CSV.new("header1,header2\nrow1_1,row1_2")
csv.headers # => nil
csv = CSV.new("header1,header2\nrow1_1,row1_2", headers: true)
csv.headers # => true
csv.read
csv.headers # =>["header1", "header2"]
#@end

@see [[m:CSV.new]]

--- inspect -> String

ASCII 互換文字列で自身の情報を表したものを返します。

#@samplecode 例
require "csv"

csv = CSV.new("header1,header2\nrow1_1,row1_2")
csv.inspect # => "<#CSV io_type:StringIO encoding:UTF-8 lineno:0 col_sep:\",\" row_sep:\"\\n\" quote_char:\"\\\"\">"
#@end

--- internal_encoding   -> Encoding | nil

[[m:IO#internal_encoding]] に委譲します。

#@#noexample IO#internal_encoding の例を参照

@see [[m:IO#internal_encoding]]

--- ioctl(cmd, arg = 0)    -> Integer

[[m:IO#ioctl]] に委譲します。

#@#noexample IO#ioctl の例を参照

@see [[m:IO#ioctl]]

--- isatty    -> bool
--- tty?      -> bool

[[m:IO#isatty]], [[m:IO#tty?]] に委譲します。

#@#noexample IO#isatty, IO#tty? の例を参照

@see [[m:IO#isatty]], [[m:IO#tty?]]

--- lineno -> Integer

このファイルから読み込んだ最終行の行番号を返します。
フィールドに含まれる改行はこの値には影響しません。

#@samplecode 例
require "csv"

csv = CSV.new("header1,header2\nrow1_1,row1_2")
csv.lineno # => 0
csv.readline
csv.lineno # => 1
#@end

--- path    -> String

[[m:IO#path]] に委譲します。

#@#noexample IO#path の例を参照

@see [[m:IO#path]]

--- pid    -> Integer | nil

[[m:IO#pid]] に委譲します。

#@#noexample IO#pid の例を参照

@see [[m:IO#pid]]

--- pos    -> Integer
--- tell   -> Integer

[[m:IO#pos]], [[m:IO#tell]] に委譲します。

#@#noexample IO#pos, IO#tell  の例を参照

@see [[m:IO#pos]], [[m:IO#tell]]

--- pos=(n)

[[m:IO#pos=]] に委譲します。

#@#noexample IO#pos= の例を参照

@see [[m:IO#pos=]]

--- quote_char -> String

フィールドをクオートするのに使用する文字列を返します。

#@samplecode 例
require "csv"

csv = CSV.new("header1,header2\nrow1_1,row1_2", quote_char: "'")
csv.quote_char # => "'"
#@end

@see [[m:CSV.new]]

--- read -> [Array] | CSV::Table
--- readlines -> [Array] | CSV::Table

残りの行を読み込んで配列の配列を返します。
self の生成時に headers オプションに偽でない値が指定されていた場合は [[c:CSV::Table]] オブジェクトを返します。

データソースは読み込み用にオープンされている必要があります。

#@samplecode 例 headers: false
require "csv"

csv = CSV.new(DATA.read)
csv.read
# => [["header1", "header2"], ["row1_1", "row1_2"], ["row2_1", "row2_2"]]

__END__
header1,header2
row1_1,row1_2
row2_1,row2_2
#@end

#@samplecode 例 headers: true
require "csv"

csv = CSV.new(DATA.read, headers: true)
csv.read
# => #<CSV::Table mode:col_or_row row_count:3>

__END__
header1,header2
row1_1,row1_2
row2_1,row2_2
#@end

--- reopen(io) -> self

[[m:IO#reopen]] に委譲します。

#@#noexample IO#reopen の例を参照

@see [[m:IO#reopen]]

--- return_headers? -> bool

ヘッダを返す場合は、真を返します。
そうでない場合は、偽を返します。

#@samplecode 例
require "csv"

csv = CSV.new("header1,header2\nrow1_1,row1_2", headers: true, return_headers: false)
csv.return_headers? # => false
csv.shift # => #<CSV::Row "header1":"row1_1" "header2":"row1_2">

csv = CSV.new("header1,header2\nrow1_1,row1_2", headers: true, return_headers: true)
csv.return_headers? # => true
csv.shift # => #<CSV::Row "header1":"header1" "header2":"header2">
#@end

@see [[m:CSV.new]]

--- rewind -> 0

[[m:IO#rewind]] に似ています。[[m:CSV#lineno]] を 0 にします。

#@samplecode 例
require "csv"

csv = CSV.new("header1,header2\nrow1_1,row1_2")
csv.lineno # => 0
csv.readline
csv.lineno # => 1
csv.rewind
csv.lineno # => 0
#@end

@see [[m:IO#rewind]]

--- row_sep -> String

行区切り文字列として使用する文字列を返します。

#@samplecode 例
require "csv"

csv = CSV.new("header1,header2|row1_1,row1_2", row_sep: "|")
csv.row_sep # => "|"
csv.read    # => [["header1", "header2"], ["row1_1", "row1_2"]]
#@end

@see [[m:CSV.new]]

--- seek(offset, whence = IO::SEEK_SET)    -> 0

[[m:IO#seek]] に委譲します。

#@#noexample IO#seek の例を参照

@see [[m:IO#seek]]

--- shift    -> Array | CSV::Row
--- gets     -> Array | CSV::Row
--- readline -> Array | CSV::Row

[[c:String]] や [[c:IO]] をラップしたデータソースから一行だけ読み込んで
フィールドの配列か [[c:CSV::Row]] のインスタンスを返します。

データソースは読み込み用にオープンされている必要があります。

@return ヘッダを使用しない場合は配列を返します。
        ヘッダを使用する場合は [[c:CSV::Row]] を返します。

#@samplecode 例
require "csv"

csv = CSV.new(DATA.read)
csv.readline # => ["header1", "header2"]
csv.readline # => ["row1_1", "row1_2"]

__END__
header1,header2
row1_1,row1_2
#@end

--- skip_blanks? -> bool

真である場合は、空行を読み飛ばします。

#@samplecode 例
require "csv"

csv = CSV.new("header1,header2\n\nrow1_1,row1_2")
csv.skip_blanks? # => false
csv.read         # => [["header1", "header2"], [], ["row1_1", "row1_2"]]
csv = CSV.new("header1,header2\n\nrow1_1,row1_2", skip_blanks: true)
csv.skip_blanks? # => true
csv.read         # => [["header1", "header2"], ["row1_1", "row1_2"]]
#@end

@see [[m:CSV.new]]

--- stat    -> File::Stat

[[m:IO#stat]] に委譲します。

#@#noexample IO#stat の例を参照

@see [[m:IO#stat]]

--- string -> String

[[m:StringIO#string]] に委譲します。

#@#noexample StringIO#string の例を参照

@see [[m:StringIO#string]]

--- sync -> bool

[[m:IO#sync]] に委譲します。

#@#noexample IO#sync の例を参照

@see [[m:IO#sync]]

--- sync=(newstate)

[[m:IO#sync=]] に委譲します。

#@#noexample IO#sync= の例を参照

@see [[m:IO#sync=]]

--- to_io -> self

[[m:IO#to_io]] に委譲します。

#@#noexample IO#to_io の例を参照

@see [[m:IO#to_io]]

--- truncate(path, length)    -> 0

[[m:File#truncate]] に委譲します。

#@#noexample File#truncate の例を参照

@see [[m:File#truncate]]

--- unconverted_fields? -> bool

パースした結果が unconverted_fields というメソッドを持つ場合に真を返します。
そうでない場合は、偽を返します。

#@# Array, CSV::Row に動的に追加される

@see [[m:CSV.new]]

--- write_headers? -> bool

ヘッダを出力先に書き込む場合は真を返します。
そうでない場合は偽を返します。

#@samplecode 例
require "csv"

csv = CSV.new("date1,date2\n2018-07-09,2018-07-10")
csv.write_headers? # => nil

header = ["header1", "header2"]
row = ["row1_1", "row1_2"]
result = CSV.generate(headers: header, write_headers: false) do |csv|
  csv.write_headers? # => false
  csv << row
end
result # => "row1_1,row1_2\n"

result = CSV.generate(headers: header, write_headers: true) do |csv|
  csv.write_headers? # => true
  csv << row
end
result # => "header1,header2\nrow1_1,row1_2\n"
#@end

@see [[m:CSV.new]]


= class CSV::FieldInfo < Struct

行が読み込まれたデータソース内でのフィールドの位置の情報を格納するための
構造体です。

[[c:CSV]] クラスではこの構造体はいくつかのメソッドのブロックに渡されます。

== Instance Methods

--- index -> Integer

行内で何番目のフィールドかわかるゼロベースのインデックスを返します。

#@samplecode 例
require 'csv'

csv = CSV.new("date1,date2\n2018-07-09,2018-07-10", headers: true)
csv.convert do |field,field_info|
  p field_info.index
  Date.parse(field)
end
p csv.first

# => 0
# => 1
# => #<CSV::Row "date1":#<Date: 2018-07-09 ((2458309j,0s,0n),+0s,2299161j)> "date2":#<Date: 2018-07-10 ((2458310j,0s,0n),+0s,2299161j)>>
#@end

--- index=(val)

インデックスの値をセットします。

@param val インデックスの値を指定します。

#@#noexample

--- line -> Integer

行番号を返します。

#@samplecode 例
require 'csv'

csv = CSV.new("date1,date2,date3\n2018-07-09,2018-07-10\n2018-08-09,2018-08-10", headers: true)
csv.convert do |field,field_info|
  p field_info.line
  Date.parse(field)
end
p csv.to_a

# => 2
# => 2
# => 3
# => 3
# => [#<CSV::Row "date1":#<Date: 2018-07-09 ((2458309j,0s,0n),+0s,2299161j)> "date2":#<Date: 2018-07-10 ((2458310j,0s,0n),+0s,2299161j)> "date3":nil>, ...]
#@end

--- line=(val)

行番号をセットします。

@param val 行番号を指定します。

#@#noexample

--- header -> String | nil

利用可能な場合はヘッダを表す文字列を返します。

#@samplecode 例
require 'csv'

csv = CSV.new("date1,date2\n2018-07-09,2018-07-10", headers: true)
csv.convert do |field,field_info|
  p field_info.header
  Date.parse(field)
end
p csv.first

# => "date1"
# => "date2"
# => #<CSV::Row "date1":#<Date: 2018-07-09 ((2458309j,0s,0n),+0s,2299161j)> "date2":#<Date: 2018-07-10 ((2458310j,0s,0n),+0s,2299161j)>>
#@end

--- header=(val)

ヘッダを表す文字列をセットします。

@param val ヘッダを表す文字列を指定します。

#@#noexample

= class CSV::MalformedCSVError < RuntimeError

不正な CSV をパースしようとしたときに発生する例外です。

#@include(csv/CSV__Row)
#@include(csv/CSV__Table)

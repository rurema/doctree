category FileFormat

#@since 1.9.1
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

=== 書き込み

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

=== 一行変換

  csv_string = ["CSV", "data"].to_csv   # => "CSV,data"
  csv_array  = "CSV,String".parse_csv   # => ["CSV", "String"]

=== ショートカット

  CSV             { |csv_out| csv_out << %w{my data here} }  # to $stdout
  CSV(csv = "")   { |csv_str| csv_str << %w{my data here} }  # to a String
  CSV($stderr)    { |csv_err| csv_err << %w{my data here} }  # to $stderr

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
  found, +data+ is [[c:ARGF]], [[m:Kernel::STDIN]], [[m:Kernel::STDOUT]], or
  [[m:Kernel::STDERR]], or the stream is only  available for output, the default
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

@raise CSV::MalformedCSVError 不正な CSV をパースしようとしたときに発生します。

@see [[m:CSV::DEFAULT_OPTIONS]], [[m:CSV.open]]

--- dump(ary_of_objs, io = "", options = Hash.new) -> String | nil

このメソッドは Ruby オブジェクトの配列を文字列や CSV ファイルにシリアラ
イズすることができます。[[c:Marshal]] や [[lib:yaml]] よりは不便ですが、
スプレッドシートやデータベースとのやりとりには役に立つでしょう。

このメソッドは単純なオブジェクトや構造体を扱う場合はうまく動くことを意
図しています。[[m:Struct#members]] を使ってインスタンス変数をシリアライ
ズします。

もっと複雑なシリアライゼーションが必要な場合は、ダンプしたいクラスにメ
ソッドを追加すると制御することができます。

#@# ユーザが定義しないかぎり存在しないメソッドなのでリンクにはしない

Object.csv_meta を定義すると、ダンプするデータの一行目を変更することが
できます。この行は次の形式のハッシュのようなものです。

  key_1,value_1,key_2,value_2,...

[[m:CSV.load]] は "class" というキーと文字列化したクラス名を期待してい
ます。Object.csv_meta を定義しなければ [[m:CSV.dump]] はそれを生成しま
す。ary_of_objs の最初の要素の Object.csv_meta だけが呼ばれます。

次に Object#csv_headers を定義することができます。このメソッドはダンプ
するデータの二行目を出力します。二行目はそれぞれの列のヘッダを与えるた
めに使います。デフォルトでは、[[m:CSV.load]] はヘッダが "@" で始まって
いればインスタンス変数に値をセットし、そうでなければヘッダの名前をメソッ
ド名、フィールドの値を引数として [[m:Object#send]] を呼び出します。
ary_of_objs の最初の要素の Object#csv_headers だけが呼ばれます。

最後に、Object#csv_dump を定義することができます。Object#csv_dump の引
数はヘッダで返り値はフィールドの配列です。このメソッドは ary_of_objs の
全ての要素に対して一度ずつ呼ばれます。

@param ary_of_objs 任意の配列を指定します。

@param io データの出力先を指定します。デフォルトは文字列です。ファイル
          に出力することもできます。

@param options オプションを指定します。[[m:CSV.new]] と同じです。

@see [[m:CSV.new]]

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

例:

  # UTF-32BE な CSV ファイルを読み込んで UTF-8 な row をブロックに渡します
  CSV.foreach("a.csv", encoding: "UTF-32BE:UTF-8"){|row| p row }

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

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。
               :encoding というキーを使用すると出力のエンコーディングを指定することができます。
               ASCII と互換性の無い文字エンコーディングを持つ文字列を出力する場合は、このヒントを
               指定する必要があります。

@see [[m:CSV.new]]

--- generate_line(row, options = Hash.new) -> String

このメソッドは一つの [[c:Array]] オブジェクトを CSV 文字列に変換するためのショートカットです。

このメソッドは可能であれば row に含まれる最初の nil でない値を用いて出力の
エンコーディングを推測します。

@param row 文字列の配列を指定します。

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。
               :encoding というキーを使用すると出力のエンコーディングを指定することができます。
               :row_sep というキーの値には [[m:$/]] がセットされます。

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

--- load(io_or_str, options = Hash.new) -> Array

このメソッドは [[m:CSV.dump]] で出力されたデータを読み込みます。

csv_load という名前のクラスメソッドを追加すると、データを読み込む方法を
カスタマイズすることができます。csv_load メソッドはメタデータ、ヘッダ、行
の三つのパラメータを受けとります。そしてそれらを元にして復元したオブジェクトを
返します。

Remember that all fields will be Strings after this load.  If you need
something else, use +options+ to setup converters or provide a custom
csv_load() implementation.

#@# カスタマイズの例が必要

@param io_or_str [[c:IO]] か [[c:String]] のインスタンスを指定します。

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。

@see [[m:CSV.new]], [[m:CSV.dump]]

--- open(filename, mode = "rb", options = Hash.new){|csv| ... } -> nil
--- open(filename, mode = "rb", options = Hash.new) -> CSV
--- open(filename, options = Hash.new){|csv| ... } -> nil
--- open(filename, options = Hash.new) -> CSV

このメソッドは [[c:IO]] オブジェクトをオープンして [[c:CSV]] でラップします。
これは CSV ファイルを書くための主要なインターフェイスとして使うことを意図しています。

このメソッドは [[m:IO.open]] と同じように動きます。ブロックが与えられた場合は
ブロックに [[c:CSV]] オブジェクトを渡し、ブロック終了時にそれをクローズします。
ブロックが与えられなかった場合は [[c:CSV]] オブジェクトを返します。
この挙動は Ruby1.8 の CSV ライブラリとは違います。Ruby1.8 では行をブロックに渡します。
Ruby1.9 では [[m:CSV.foreach]] を使うとブロックに行を渡します。

データが [[m:Encoding.default_external]] と異なる場合は、mode にエンコー
ディングを指定する文字列を埋め込まなければなりません。データをどのよう
に解析するか決定するために CSV ライブラリはユーザが mode に指定したエン
コーディングをチェックします。"rb:UTF-32BE:UTF-8" のように mode を指定
すると UTF-32BE のデータを読み込んでUTF-8 に変換してから解析します。

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

@see [[m:CSV.new]], [[m:IO.open]]

--- parse(str, options = Hash.new){|row| ... } -> nil
--- parse(str, options = Hash.new) -> Array

このメソッドは文字列を簡単にパースすることができます。
ブロックを与えた場合は、ブロックにそれぞれの行を渡します。
ブロックを省略した場合は、配列の配列を返します。

@param str 文字列を指定します。

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。

--- parse_line(line, options = Hash.new) -> Array

このメソッドは一行の CSV 文字列を配列に変換するためのショートカットです。

@param line 文字列を指定します。複数行の文字列を指定した場合は、一行目以外は無視します。

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。

--- read(path, options = Hash.new) -> [Array] | CSV::Table
--- readlines(path, options = Hash.new) -> [Array] | CSV::Table

CSV ファイルを配列の配列にするために使います。
headers オプションに偽でない値を指定した場合は [[c:CSV::Table]] オブジェクトを返します。

#@# 例を追加する

@param path CSV ファイルのパスを指定します。

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。
               :encoding というキーを使用すると入力のエンコーディングを指定することができます。
               入力のエンコーディングか [[m:Encoding.default_external]] と異なる場合は
               必ず指定しなければなりません。

@see [[m:CSV.new]], [[m:CSV.table]]

--- table(path, options = Hash.new) -> CSV::Table | [Array]

以下の例と同等のことを行うメソッドです。
日本語の CSV ファイルを扱う場合はあまり使いません。

例:

  CSV.read( path, { headers:           true,
                    converters:        :numeric,
                    header_converters: :symbol }.merge(options) )

@param path ファイル名を指定します。

@param options [[m:CSV.new]] のオプションと同じオプションを指定できます。

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

--- binmode -> self

[[m:IO#binmode]] に委譲します。

--- binmode? -> bool

[[m:IO#binmode?]] に委譲します。

--- close -> nil

[[m:IO#close]] に委譲します。

--- close_read -> nil

[[m:IO#close_read]] に委譲します。

--- close_write -> nil

[[m:IO#close_write]] に委譲します。

--- closed? -> bool

[[m:IO#closed?]] に委譲します。

--- col_sep -> String

カラム区切り文字列として使用する文字列を返します。

@see [[m:CSV.new]]

--- convert(name)
--- convert{|field| ... }
--- convert{|field, field_info| ... }
#@# discard

組み込みの [[m:CSV::Converters]] を変換器として利用するために使います。
また、独自の変換器を追加することもできます。

ブロックパラメータを一つ受け取るブロックを与えた場合は、そのブロックは
フィールドを受け取ります。ブロックパラメータを二つ受け取るブロックを与
えた場合は、そのブロックは、フィールドと [[c:CSV::FieldInfo]] のインス
タンスを受け取ります。ブロックは変換後の値かフィールドそのものを返さな
ければなりません。

@param name 変換器の名前を指定します。

--- converters -> Array

現在の変換器のリストを返します。

@see [[m:CSV::Converters]]

--- each{|row| ... } -> nil

各行に対してブロックを評価します。

データソースは読み込み用にオープンされていなければなりません。

--- encoding -> Encoding

読み書きするときに使用するエンコーディングを返します。

--- eof -> bool
--- eof? -> bool

[[m:IO#eof]], [[m:IO#eof?]] に委譲します。

--- external_encoding -> Encoding | nil

[[m:IO#external_encoding]] に委譲します。

--- fcntl(cmd, arg = 0)    -> Integer

[[m:IO#fcntl]] に委譲します。

--- field_size_limit -> Fixnum

フィールドサイズの最大値を返します。

@see [[m:CSV.new]]

--- fileno -> Integer
--- to_i   -> Integer

[[m:IO#fileno]], [[m:IO#to_i]] に委譲します。

--- flock(operation)    -> 0 | false

[[m:File#flock]] に委譲します。

--- flush    -> self

[[m:IO#flush]] に委譲します。

--- force_quotes? -> bool

出力されるフィールドがクオートされる場合は、真を返します。

@see [[m:CSV.new]]

--- fsync -> 0 | nil

[[m:IO#fsync]] に委譲します。

--- header_convert(name)
--- header_convert{|field| ... }
--- header_convert{|field, field_info| ... }

[[m:CSV#convert]] に似ていますが、ヘッダ行用のメソッドです。

このメソッドはヘッダ行を読み込む前に呼び出さなければなりません。

@param name 変換器の名前を指定します。

@see [[m:CSV#convert]]

--- header_converters -> Array

現在有効なヘッダ用変換器のリストを返します。

組込みの変換器は名前を返します。それ以外は、オブジェクトを返します。

@see [[m:CSV.new]]

--- header_row? -> bool

次に読み込まれる行が、ヘッダである場合に真を返します。
そうでない場合は、偽を返します。

--- headers -> Array | true | nil

nil を返した場合は、ヘッダは使用されません。
真を返した場合は、ヘッダを使用するが、まだ読み込まれていません。
配列を返した場合は、ヘッダは既に読み込まれています。

@see [[m:CSV.new]]

--- inspect -> String

ASCII 互換文字列で自身の情報を表したものを返します。

--- internal_encoding   -> Encoding | nil

[[m:IO#internal_encoding]] に委譲します。

--- ioctl(cmd, arg = 0)    -> Integer

[[m:IO#ioctl]] に委譲します。

--- isatty    -> bool
--- tty?      -> bool

[[m:IO#isatty]], [[m:IO#tty?]] に委譲します。

--- lineno -> Fixnum

このファイルから読み込んだ最終行の行番号を返します。
フィールドに含まれる改行はこの値には影響しません。

--- path    -> String

[[m:IO#path]] に委譲します。

--- pid    -> Integer | nil

[[m:IO#pid]] に委譲します。

--- pos    -> Integer
--- tell   -> Integer

[[m:IO#pos]], [[m:IO#tell]] に委譲します。

--- pos=(n)

[[m:IO#pos=]] に委譲します。

--- quote_char -> String

フィールドをクオートするのに使用する文字列を返します。

@see [[m:CSV.new]]

--- read -> [Array] | CSV::Table
--- readlines -> [Array] | CSV::Table

残りの行を読み込んで配列の配列を返します。
self の生成時に headers オプションに偽でない値が指定されていた場合は [[c:CSV::Table]] オブジェクトを返します。

データソースは読み込み用にオープンされている必要があります。

--- reopen(io) -> self

[[m:IO#reopen]] に委譲します。

--- return_headers? -> bool

ヘッダを返す場合は、真を返します。
そうでない場合は、偽を返します。

@see [[m:CSV.new]]

--- rewind -> 0

[[m:IO#rewind]] に似ています。[[m:CSV#lineno]] を 0 にします。

@see [[m:IO#rewind]]

--- row_sep -> String

行区切り文字列として使用する文字列を返します。

@see [[m:CSV.new]]

--- seek(offset, whence = IO::SEEK_SET)    -> 0

[[m:IO#seek]] に委譲します。

--- shift    -> Array | CSV::Row
--- gets     -> Array | CSV::Row
--- readline -> Array | CSV::Row

[[c:String]] や [[c:IO]] をラップしたデータソースから一行だけ読み込んで
フィールドの配列か [[c:CSV::Row]] のインスタンスを返します。

データソースは読み込み用にオープンされている必要があります。

@return ヘッダを使用しない場合は配列を返します。
        ヘッダを使用する場合は [[c:CSV::Row]] を返します。

--- skip_blanks? -> bool

真である場合は、空行を読み飛ばします。

@see [[m:CSV.new]]

--- stat    -> File::Stat

[[m:IO#stat]] に委譲します。

--- string -> String

[[m:StringIO#string]] に委譲します。

--- sync -> bool

[[m:IO#sync]] に委譲します。

--- sync=(newstate)

[[m:IO#sync=]] に委譲します。

--- to_io -> self

[[m:IO#to_io]] に委譲します。

--- truncate(path, length)    -> 0

[[m:File#truncate]] に委譲します。

--- unconverted_fields? -> bool

パースした結果が unconverted_fields というメソッドを持つ場合に真を返します。
そうでない場合は、偽を返します。

#@# Array, CSV::Row に動的に追加される

@see [[m:CSV.new]]

--- write_headers? -> bool

ヘッダを出力先に書き込む場合は真を返します。
そうでない場合は偽を返します。

@see [[m:CSV.new]]


= class CSV::FieldInfo < Struct

行が読み込まれたデータソース内でのフィールドの位置の情報を格納するための
構造体です。

[[c:CSV]] クラスではこの構造体はいくつかのメソッドのブロックに渡されます。

== Instance Methods

--- index -> Fixnum

行内で何番目のフィールドかわかるゼロベースのインデックスを返します。

--- index=(val)

インデックスの値をセットします。

@param val インデックスの値を指定します。

--- line -> Fixnum

行番号を返します。

--- line=(val)

行番号をセットします。

@param val 行番号を指定します。

--- header -> Array

利用可能な場合はヘッダを表す配列を返します。


--- header=(val)

ヘッダを表す配列をセットします。

@param val ヘッダを表す配列を指定します。

= class CSV::MalformedCSVError < RuntimeError

不正な CSV をパースしようとしたときに発生する例外です。

#@include(csv/CSV__Row)
#@include(csv/CSV__Table)
#@else
CSV (Comma Separated Values) を扱うライブラリです。

= class CSV < Object

CSV (Comma Separated Values) を扱うクラスです。

各メソッドの共通パラメタ

  mode
     'r', 'w', 'rb', 'wb' から指定可能です。

     - 'r' 読み込み
     - 'w' 書き込み
     - 'b' バイナリモード
  fs
     フィールドの区切り文字(あるいは文字列)。
     数値(Integer#chr で変換可能な値のみ)を指定した場合は対応する文字が区切り文字になります。
     デフォルトは ','。
  rs
     行区切り文字。nil (デフォルト) で CrLf / Lf。
     Cr で区切りたい場合は ?\r を渡します。

== Class Methods

--- open(path, mode, fs = nil, rs = nil) {|row| ... } -> nil
--- open(path, mode, fs = nil, rs = nil) -> CSV::Reader | CSV::Writer

CSVファイルを読み込んでパースします。

読み込みモード時には path にあるファイルを開き各行を配列として
ブロックに渡します。

@param path パースするファイルのファイル名
@param mode 処理モードの指定
            'r', 'w', 'rb', 'wb' から指定可能です。
            - 'r' 読み込み
            - 'w' 書き込み
            - 'b' バイナリモード
@param fs フィールドセパレータの指定。
          nil (デフォルト) で ',' をセパレータとします。
@param rs 行区切り文字の指定。nil (デフォルト) で CRLF / LF。
          CR を行区切りとしたい場合は ?\r を渡します。

===== 注意

パース時に""(空文字)と値なし(nil)を区別します。
例えば、読み込みモード時にa, "", , b の行をパースした場合には ["a", "", nil, "b"] の配列を返します。

例:

  CSV.open("/temp/test.csv", 'r') do |row|
    puts row.join("<>")
  end

tsv(Tab Separated Values)ファイルなどのセパレータをカンマ以外で指定

  CSV.open("/temp/test.tsv", 'r', "\t") do |row|
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

--- foreach(path, rs = nil) {|row| ... } -> nil

読み込みモードでファイルを開き、各行を配列でブロックに渡します。

@param path パースするファイルのファイル名
@param rs 行区切り文字の指定。nil (デフォルト) で CrLf / Lf。
          Cr を行区切りとしたい場合は ?\r を渡します。

===== 注意

パース時に""(空文字)と値なしを区別します。
例えば、a, "", , b の行をパースした場合には ["a", "", nil, "b"] の配列を返します。

例:

  CSV.foreach('test.csv'){|row|
    puts row.join(':')
  }

--- read(path, length = nil, offset = nil) -> Array

path で指定された CSV ファイルを読み込み、配列の配列でデータを返します。

@param path パースするファイルのファイル名
@param length 対象ファイルの読み込みサイズ
@param offset 読み込み開始位置

===== 注意

パース時に""(空文字)と値なしを区別します。
例えば、a, "", , b の行をパースした場合には ["a", "", nil, "b"] の配列を返します。

--- readlines(path, rs = nil) -> Array

path で指定された CSV ファイルを読み込み、配列の配列でデータを返します。

@param path パースするファイルのファイル名
@param rs 行区切り文字の指定。nil (デフォルト) で CrLf / Lf。
          Cr を行区切りとしたい場合は ?\r を渡します。

===== 注意

パース時に""(空文字)と値なしを区別します。
例えば、a, "", , b の行をパースした場合には ["a", "", nil, "b"] の配列を返します。

#@end

--- generate(path, fs = nil, rs = nil) -> CSV::BasicWriter
--- generate(path, fs = nil, rs = nil) {|writer| ... } -> nil

path で指定されたファイルを書き込みモードで開き、ブロックに渡します。
ブロック未指定の場合は [[c:CSV::BasicWriter]] を返します。

@param path 書き込みモードでopenするファイルのファイル名
@param fs フィールドセパレータの指定。
          nil (デフォルト) で ',' をセパレータとします。
@param rs 行区切り文字の指定。nil (デフォルト) で CrLf / Lf。
          Cr を行区切りとしたい場合は ?\r を渡します。

===== 注意

ファイル書き込み時に""(空文字)と値なし(nil)を区別します。
例えば、["a", "", nil, "b"] の配列を渡した場合に a, "", , b という行をファイルに書き込みます。

例:
  a = ["1","ABC","abc"]
  b = ["2","DEF","def"]
  c = ["3","GHI","ghi"]
  x = [a, b, c]

  CSV.generate("test2.csv"){|writer|
    x.each{|row|
      writer << row
    }
  }

--- parse(str_or_readable, fs = nil, rs = nil) -> Array
--- parse(str_or_readable, fs = nil, rs = nil){|rows| ... } -> nil

str_or_readable で指定された文字列をパースし配列の配列に変換、ブロックに渡します。
ブロック未指定の場合は変換された配列の配列を返します。

@param str_or_readable パースする文字列
@param fs フィールドセパレータの指定。
          nil (デフォルト) で ',' をセパレータとします。
@param rs 行区切り文字の指定。nil (デフォルト) で CrLf / Lf。
          Cr を行区切りとしたい場合は ?\r を渡します。

例:
  CSV.parse("A,B,C\nd,e,f\nG,H,I"){|rows|
    p rows
  }

--- generate_line(row, fs = nil, rs = nil) -> String
--- generate_line(row, fs = nil, rs = nil){|s| ... } -> nil

row で指定された配列をパースし、fs で指定された文字をフィールドセパレータとして
1行分の文字列をブロックに渡します。
ブロック未指定の場合は変換された文字列を返します。

@param row パースする配列
@param fs フィールドセパレータの指定。
          nil (デフォルト) で ',' をセパレータとします。
@param rs 行区切り文字の指定。nil (デフォルト) で CrLf / Lf。
          Cr を行区切りとしたい場合は ?\r を渡します。

--- parse_line(src, fs = nil, rs = nil) -> Array
--- parse_line(src, fs = nil, rs = nil){|row| ... } -> nil

src で指定された文字列を1行分としてパースし配列に変換、ブロックに渡します。
ブロック未指定の場合は変換された配列を返します。

@param src パースする文字列
@param fs フィールドセパレータの指定。
          nil (デフォルト) で ',' をセパレータとします。
@param rs 行区切り文字の指定。nil (デフォルト) で CrLf / Lf。
          Cr を行区切りとしたい場合は ?\r を渡します。

#@until 1.9.1
--- generate_row(src, cells, out_dev, fs = nil, rs = nil) -> Fixnum

src で指定された配列をパースして csv形式の文字列として(行区切り文字も含めて) out_dev に出力します。
返り値として fs で区切ったフィールド(cell)の数を返します。

@param src パースする配列
@param cells パースするフィールド数。
@param out_dev csv形式の文字列の出力先。
@param fs フィールドセパレータの指定。
          nil (デフォルト) で ',' をセパレータとします。
@param rs 行区切り文字の指定。nil (デフォルト) で CrLf / Lf。
          Cr を行区切りとしたい場合は ?\r を渡します。

===== 注意

配列のパース時に""(空文字)と値なし(nil)を区別します。
例えば、["a", "", nil, "b"] の配列を渡した場合に a,"", , b という文字列を生成します。

例:
  row1 = ['a', 'b', 'c']
  row2 = ['1', '2', '3']
  row3 = ['A', 'B', 'C']
  src = [row1, row2, row3]
  buf = ''
  src.each do |row|
    parsed_cells = CSV.generate_row(row, 2, buf)
  end
  p buf #=>"a,b\n1,2\n,A,B\n"


--- parse_row(src, index, out_dev, fs = nil, rs = nil) -> Array

CSV形式の文字列をパースしてCSV1行(row)分のデータを配列に変換し out_dev に出力します。

@param src パースする文字列(CSV形式)
@param index パース開始位置
@param out_dev 変換したデータの出力先。
@param fs フィールドセパレータの指定。
          nil (デフォルト) で ',' をセパレータとします。
@param rs 行区切り文字の指定。nil (デフォルト) で CrLf / Lf。
          Cr を行区切りとしたい場合は ?\r を渡します。
@return  変換したArrayのサイズと変換をした文字列の位置をArrayとして返します。

===== 注意

パース時に""(空文字)と値なしを区別します。
例えば、a, "", , b の行をパースした場合には ["a", "", nil, "b"] の配列を返します。

例:
   src = "a,b,c\n1,2\nA,B,C,D"
   i = 0

   x = [] #結果を格納する配列
   begin
     parsed = []
     parsed_cells, i = CSV.parse_row(src, i, parsed)
     x.push(parsed)
   end while parsed_cells > 0

   x.each{ |row|
     p '-----'
     row.each{ |cell|
       p cell
     }
   }

実行結果:
  a
  b
  c
  -----
  1
  2
  -----
  A
  B
  C
  D

#@end

#@include(csv/CSV__Cell)
#@include(csv/CSV__Row)
#@include(csv/CSV__BasicWriter)
#@include(csv/CSV__IOBuf)
#@include(csv/CSV__IOReader)
#@include(csv/CSV__IllegalFormatError)
#@include(csv/CSV__Reader)
#@include(csv/CSV__StreamBuf)
#@include(csv/CSV__StringReader)
#@include(csv/CSV__Writer)
#@end


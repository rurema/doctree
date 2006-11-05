= class PrettyPrint < Object

このクラスは pretty printing アルゴリズムの実装です。
改行の位置を探し、きれいなインデントを施します。

デフォルトでは、このクラスは文字列を扱います。
また、文字1バイトが出力幅の中で1カラムを占めると仮定しています。
しかし、以下のメソッドに対して適切な引数を与えることで、
そうでない場合にも利用できます。
 * [[m:PrettyPrint.new]]: 空白の生成をするブロックや改行オブジェクトを設定できます。
 * [[m:PrettyPrint#text]]: 幅を設定できます。
 * [[m:PrettyPrint#breakable]] 
ですので、このクラスは以下のようなことにも応用が可能です。
 * proportional font を使ったテキストの整形
 * 出力幅とバイト数が異なるような多バイト文字
 * 文字以外の整形

=== References
Christian Lindig, Strictly Pretty, March 2000,
[[url:http://www.st.cs.uni-sb.de/~lindig/papers/pretty/strictly-pretty.html]]

Philip Wadler, A prettier printer, March 1998,
[[url:http://homepages.inf.ed.ac.uk/wadler/topics/language-design.html#prettier]]


== Class Methods
--- new(output = '', maxwidth = 79, newline = "\n") [{|width| ...}]

pretty printing のためのバッファを生成します。
output は出力先です。
もし指定されなければ '' が仮定されます。
output は << メソッドを持っていなければなりません。
<< メソッドには
 * [[m:PrettyPrint#text]] の第1引数 obj 
 * [[m:PrettyPrint#breakable]] の第1引数 sep 
 * [[m:PrettyPrint.new]] の第1引数 newline 
 * [[m:PrettyPrint.new]] に与えたブロックを評価した結果
のどれかひとつが引数として与えられます。

maxwidth は行の最大幅を指定します。
与えられない場合は 79 が仮定されます。
ただし、改行できないものが渡された場合は
実際の出力幅は maxwidth を越えることがあります。

newline は改行に使われます。
指定されない場合は "\n" が仮定されます。

ブロックは空白を生成します。
指定されない場合は {|width| ' ' * width} が使われます。

--- format([output[, maxwidth[, newline[, genspace]]]]) {|pp| ...}

以下と同じ働きをするもので簡便のために用意されています。

  begin
    pp = PrettyPrint.new(output, maxwidth, newline, &genspace)
    ...
    pp.flush
    output
  end

--- singleline_format([output[, maxwidth[, newline[, genspace]]]]) {|pp| ...}

[[m:PrettyPrint.format]] に似ていますが、改行しません。引数
maxwidth, newline と genspace は無視されます。ブロッ
ク中の breakable の実行は、改行せずに text の実行であるか
のように扱います。

== Instance Methods
--- text(obj[, width])

obj を width カラムのテキストとして追加します。

width が指定されなかった場合、obj.length が利用されます。

--- breakable([sep[, width]])

「必要ならここで改行出来る」ということを通知します。
もしその位置で改行されなければ、
widthカラムのテキスト sep がそこに挿入されます。

sep が指定されなければ " " が利用されます。

width が指定されなければ、sep.length が利用されます。
例えば sep が多バイト文字の際に指定する必要があるかも知れません。

--- nest(indent) {...}

ブロックの中で追加された改行の後の左マージンを indent ぶんだけ
増加させます。

--- group([indent[, open_obj[, close_obj[, open_width[, close_width]]]]]) {...}

ブロック内で追加された改行のヒントをグループ化します。

indent が指定された場合、このメソッド呼び出しは
nest(indent) { ... } でネストしているものとして扱われます。

open_obj が指定された場合、text open_obj, open_width が
最初に呼ばれます。
close_obj が指定された場合、text close_obj, close_width が
最後に呼ばれます。

--- flush

バッファされたデータを出力します。

--- first?

現在のグループで first? に対する最初の呼び出しかどうかを判定する
述語です。
これはカンマで区切られた値を整形するのに有用です。

  pp.group(1, '[', ']') {
    xxx.each {|yyy|
      unless pp.first?
        pp.text ','
        pp.breakable
      end
      ... pretty printing yyy ...
    }
  }

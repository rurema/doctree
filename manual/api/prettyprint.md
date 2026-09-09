---
type: library
---
pretty printing アルゴリズムのためのライブラリです。

### 使い方

pretty printing アルゴリズムは読みやすいインデントと改行を決定するためのアルゴリズムです。
インデントと改行はユーザによって与えられたツリー構造から決定されます。
つまりユーザは以下のように表示したい内容を保持したツリーを作成する必要があります。

- [m:PrettyPrint.new] でバッファを生成します。このとき、バッファの幅と改行文字を指定します。
- [m:PrettyPrint#text] を使って、文字列を適宜 挿入します。
- [m:PrettyPrint#group] を使って子ノードをつくります。同時に子ノードのインデントの深さも決めます。
- [m:PrettyPrint#breakable] を使って改行しても良い場所を指定します。

同じノード内で呼ばれた breakable は、改行するならば全て同時に改行します。

```ruby
require 'prettyprint'

p2 = PrettyPrint.new('', 10)
s = 'hello'
p2.text(s)
p2.group(p2.indent + s.size + 1) do
  p2.breakable
  p2.text('a')
  p2.breakable
  p2.text('b')
  p2.breakable
  p2.text('c')
end
p2.flush
puts p2.output
# =>
# hello
#       a
#       b
#       c
```

### References

Christian Lindig, Strictly Pretty, March 2000,
<http://www.st.cs.uni-sb.de/~lindig/papers/pretty/strictly-pretty.html>

Philip Wadler, A prettier printer, March 1998,
<https://homepages.inf.ed.ac.uk/wadler/topics/language-design.html#prettier>

# class PrettyPrint < Object

pretty printing アルゴリズムのためのクラスです。
改行の位置を探し、きれいなインデントを施します。

デフォルトでは、このクラスは文字列を扱います。
また、文字1バイトが出力幅の中で1カラムを占めると仮定しています。
しかし、以下のメソッドに対して適切な引数を与えることで、そうでない場合にも利用できます。
- [m:PrettyPrint.new]: 出力バッファ、空白の生成をするブロックや改行オブジェクトを設定できます。
- [m:PrettyPrint#text]: 幅を設定できます。
- [m:PrettyPrint#breakable]
ですので、このクラスは以下のようなことにも応用が可能です。
- proportional font を使ったテキストの整形
- 出力幅とバイト数が異なるような多バイト文字
- 文字以外の整形

## Class Methods
### def PrettyPrint.new(output = '', maxwidth = 79, newline = "\n")               -> PrettyPrint
### def PrettyPrint.new(output = '', maxwidth = 79, newline = "\n"){|width| ...}  -> PrettyPrint

pretty printing のためのバッファを生成します。
output は出力先です。output は << メソッドを持っていなければなりません。
<< メソッドには
- [m:PrettyPrint#text] の第1引数 obj
- [m:PrettyPrint#breakable] の第1引数 sep
- [m:PrettyPrint.new] の第3引数 newline
- [m:PrettyPrint.new] に与えたブロックを評価した結果
のどれかひとつが引数として与えられます。

ブロックが指定された場合は、空白を生成するために使われます。ブロックは、生成したい空白の幅を表す整数を引数として呼ばれます。ブロックが指定されない場合は、空白を生成するために {|width| ' ' * width} が使われます。

- **param** `output` -- 出力先を指定します。output は << メソッドを持っていなければなりません。

- **param** `maxwidth` -- 行の最大幅を指定します。ただし、改行できないものが渡された場合は、実際の出力幅は maxwidth を越えることがあります。

- **param** `newline` -- 改行に使われます。

### def PrettyPrint.format(output = '', maxwidth = 79, newline = "\n", genspace = lambda{|n| ' ' * n}) {|pp| ...}    -> object

PrettyPrint オブジェクトを生成し、それを引数としてブロックを実行します。
与えられた output を返します。

以下と同じ働きをするもので簡便のために用意されています。

```ruby
require 'prettyprint'

begin
  pp = PrettyPrint.new(output, maxwidth, newline, &genspace)
  ...
  pp.flush
  output
end
```

- **param** `output` -- 出力先を指定します。output は << メソッドを持っていなければなりません。

- **param** `maxwidth` -- 行の最大幅を指定します。ただし、改行できないものが渡された場合は、実際の出力幅は maxwidth を越えることがあります。

- **param** `newline` -- 改行に使われます。

- **param** `genspace` -- 空白の生成に使われる [c:Proc] オブジェクトを指定します。
                生成したい空白の幅を表す整数を引数として呼ばれます。

### def PrettyPrint.singleline_format(output = '', maxwidth = 79, newline = "\n", genspace = lambda{|n| ' ' * n}) {|pp| ...}    -> object

PrettyPrint オブジェクトを生成し、それを引数としてブロックを実行します。
[m:PrettyPrint.format] に似ていますが、改行しません。

引数 maxwidth, newline と genspace は無視されます。ブロック中の breakable の実行は、改行せずに text の実行であるかのように扱います。

- **param** `output` -- 出力先を指定します。output は << メソッドを持っていなければなりません。

- **param** `maxwidth` -- 無視されます。

- **param** `newline` -- 無視されます。

- **param** `genspace` -- 無視されます。

## Instance Methods
### def text(obj)           -> ()
### def text(obj, width = obj.length)    -> ()

obj を width カラムのテキストとして自身に追加します。

- **param** `obj` -- 自身に追加するテキストを文字列で指定します。

- **param** `width` -- obj のカラムを指定します。指定されなかった場合、obj.length が利用されます。

### def breakable(sep = ' ')     -> ()
### def breakable(sep, width = sep.length)    -> ()

「必要ならここで改行出来る」ということを自身に通知します。
もしその位置で改行されなければ、width カラムのテキスト sep が出力の際にそこに挿入されます。

- **param** `sep` -- 改行が起きなかった場合に挿入されるテキストを文字列で指定します。

- **param** `width` -- テキスト sep は width カラムであると仮定されます。指定されなければ、
             sep.length が利用されます。例えば sep が多バイト文字の際に指定する必要があるかも知れません。

### def nest(indent) {...}     -> ()

自身の現在のインデントを indent だけ増加させてから、ブロックを実行し、元に戻します。

- **param** `indent` -- インデントの増加分を整数で指定します。

### def group(indent = 0, open_obj = '', close_obj = '', open_width = open_obj.length, close_width = close_obj.length){...}      -> ()

与えられたブロックを実行します。
ブロック内で自身に追加される文字列やオブジェクトは、1行にまとめて表示してもよい同じグループに属すると仮定されます。

もう少し詳しく説明します。pretty printing アルゴリズムはインデントと改行を、ツリー構造を作ることによって決定します。そして、group メソッドは子ノードの作成と子ノードのインデントの深さの決定を担当します。

同じノード内で呼ばれた breakable は、改行するならば全て同時に改行します。

- **param** `indent` -- グループのインデントの深さを指定します。

- **param** `open_obj` -- 指定された場合、self.text(open_obj, open_width) がブロックが実行される前に呼ばれます。開き括弧などを出力するのに使用されます。

- **param** `close_obj` -- 指定された場合、self.text(close_obj, close_width) がブロックが実行された後に呼ばれます。閉じ括弧などを出力するのに使用されます。

- **param** `open_width` -- open_obj のカラムを指定します。

- **param** `close_width` -- close_obj のカラムを指定します。

### def flush     -> ()

バッファされたデータを出力します。

### def output    -> object

自身の output を返します。

### def maxwidth    -> Integer

自身の幅を返します。

### def newline    -> String

自身の改行文字を返します。

### def genspace    -> Proc

空白を生成する Proc を返します。

### def indent    -> Integer

現在のインデントの深さを返します。

### def fill_breakable(sep = ' ') -> ()
### def fill_breakable(sep, width = sep.length) -> ()

[m:PrettyPrint#breakable] と似ていますが、改行するかどうかがそれぞれ個別に決定される点が異なります。

同じグループの中で fill_breakable を2回呼んだ場合、(改行,改行)・(改行,非改行)・(非改行,改行)・(非改行,非改行) の4通りの結果になり得ます。これは [m:PrettyPrint#breakable] とは異なる点です。同じグループの中で breakable を2回呼んだ場合、改行するなら全て同時に改行するため、(改行,改行)・(非改行,非改行) の2通りにしかなりません。

もしその位置で改行されなければ、width カラムのテキスト sep が出力の際にそこに挿入されます。

- **param** `sep` -- 改行が起きなかった場合に挿入されるテキストを文字列で指定します。指定されなかった場合、' ' が利用されます。

- **param** `width` -- テキスト sep は width カラムであると仮定されます。指定されなければ、sep.length が利用されます。例えば sep が多バイト文字の際に指定する必要があるかも知れません。

```ruby
require 'prettyprint'

out = PrettyPrint.format(''.dup, 10) do |q|
  q.group {
    %w[aaaa bbbb cccc dddd].each_with_index do |w, i|
      q.fill_breakable if i > 0
      q.text w
    end
  }
end
puts out
# => aaaa bbbb
#    cccc dddd
```

- **SEE** [m:PrettyPrint#breakable]

### def break_outmost_groups -> ()

自身のバッファの中で、出力幅([m:PrettyPrint#maxwidth])を超えている外側のグループを、バッファの幅が maxwidth 以下になるまで改行して出力します。

[m:PrettyPrint#text] や [m:PrettyPrint#breakable] の内部で、バッファに追加を行うたびに呼ばれています。

```ruby
require 'prettyprint'

out = PrettyPrint.format(''.dup, 10) do |q|
  q.text 'aaaaa'
  q.group {
    q.text 'b' * 20
    q.breakable
    q.text 'c'
  }
  q.break_outmost_groups
  q.text 'd'
end
puts out
# => aaaaabbbbbbbbbbbbbbbbbbbb
#    cd
```

### def current_group -> PrettyPrint::Group

スタックに最後に積まれたグループ、つまり現在ブロックを実行中の最も内側の [m:PrettyPrint#group] に対応するグループを返します。

カスタムフォーマッタの実装で、現在のネストの深さなどを調べるために使用します。

```ruby
require 'prettyprint'

out = PrettyPrint.format(''.dup) do |q|
  q.group {
    q.text q.current_group.depth.to_s
    q.group {
      q.text q.current_group.depth.to_s
    }
  }
end
puts out
# => 12
```

- **SEE** [m:PrettyPrint#group]

### def group_queue -> PrettyPrint::GroupQueue

自身が持つ、プリティプリント待ちのグループのキュー(PrettyPrint::GroupQueue オブジェクト)を返します。

### def group_sub { ... } -> object

ブロックを実行しながら、現在のグループより1段階深いグループをキューに追加します。

[m:PrettyPrint#group] と異なり、開き括弧・閉じ括弧の出力([m:PrettyPrint#text])やインデントの増加([m:PrettyPrint#nest])は行いません。[m:PrettyPrint#group] は内部でこのメソッドを使って実装されています。

```ruby
require 'prettyprint'

out = PrettyPrint.format(''.dup, 5) do |q|
  q.group_sub {
    q.text 'hello'
    q.breakable
    q.text 'world'
  }
end
puts out
# => hello
#    world
```

- **SEE** [m:PrettyPrint#group]


オブジェクトなどを見やすく出力するためのライブラリです。

=== どちらが読みやすいでしょうか?

p による pretty-print されてない出力:
  #<PP:0x81a0d10 @stack=[], @genspace=#<Proc:0x81a0cc0>, @nest=[0], @newline="\n", @buf=#<PrettyPrint::Group:0x81a0c98 @group=0, @tail=0, @buf=[#<PrettyPrint::Group:0x81a0ba8 @group=1, @tail=0, @buf=[#<PrettyPrint::Text:0x81a0b30 @tail=2, @width=1, @text="[">, #<PrettyPrint::Group:0x81a0a68 @group=2, @tail=1, @buf=[#<PrettyPrint::Text:0x81a09f0 @tail=1, @width=1, @text="1">], @singleline_width=1>, #<PrettyPrint::Text:0x81a0a7c @tail=0, @width=1, @text=",">, #<PrettyPrint::Breakable:0x81a0a2c @group=2, @genspace=#<Proc:0x81a0cc0>, @newline="\n", @indent=1, @tail=2, @sep=" ", @width=1>, #<PrettyPrint::Group:0x81a09c8 @group=2, @tail=1, @buf=[#<PrettyPrint::Text:0x81a0950 @tail=1, @width=1, @text="2">], @singleline_width=1>, #<PrettyPrint::Text:0x81a0af4 @tail=0, @width=1, @text="]">], @singleline_width=6>], @singleline_width=6>, @sharing_detection=false>

pp による pretty-print された出力:
  #<PP:0x40d0688
   @buf=
    #<PrettyPrint::Group:0x40d064c
     @buf=
      [#<PrettyPrint::Group:0x40d05d4
        @buf=
         [#<PrettyPrint::Text:0x40d0598 @tail=2, @text="[", @width=1>,
          #<PrettyPrint::Group:0x40d0534
           @buf=[#<PrettyPrint::Text:0x40d04f8 @tail=1, @text="1", @width=1>],
           @group=2,
           @singleline_width=1,
           @tail=1>,
          #<PrettyPrint::Text:0x40d053e @tail=0, @text=",", @width=1>,
          #<PrettyPrint::Breakable:0x40d0516
           @genspace=#<Proc:0x40d0656>,
           @group=2,
           @indent=1,
           @newline="\n",
           @sep=" ",
           @tail=2,
           @width=1>,
          #<PrettyPrint::Group:0x40d04e4
           @buf=[#<PrettyPrint::Text:0x40d04a8 @tail=1, @text="2", @width=1>],
           @group=2,
           @singleline_width=1,
           @tail=1>,
          #<PrettyPrint::Text:0x40d057a @tail=0, @text="]", @width=1>],
        @group=1,
        @singleline_width=6,
        @tail=0>],
     @group=0,
     @singleline_width=6,
     @tail=0>,
   @genspace=#<Proc:0x40d0656>,
   @nest=[0],
   @newline="\n",
   @sharing_detection=false,
   @stack=[]>


=== 出力のカスタマイズ

あるクラスの pp の出力を変えたい場合は、
そのクラスで pretty_print メソッドを再定義します。
このメソッドは [[c:PP]] オブジェクトを引数として取ります。

Pretty Print アルゴリズムはインデントと改行を、ツリー構造を作ることによって決定します。そのため、
pretty_print メソッドにおいて、ユーザは以下のことをプログラムする必要があります。

 * [[m:PrettyPrint#group]] を使って子ノードをつくる。同時に子ノードのインデントの深さも決める。
 * [[m:PrettyPrint#breakable]] を使って改行しても良い場所を指定する。
 * [[m:PP#pp]] を使って出力したいインスタンス変数などを出力する。
 * [[m:PrettyPrint#text]] を使って、出力が見やすくなるように「,」などの修飾文字を適宜挿入する。

同じノード内で呼ばれた breakable は、改行するならば全て同時に改行します。

以下は Hash の Pretty Print のカスタマイズの例です。

  require 'pp'
  class Hash
    def pretty_print(q)
      q.group(2, "<hash>") do
        q.breakable
        first = true
        self.each{|k, v|
          unless first
            q.text(',')          
            q.breakable
          end        
          q.pp k
          q.text ' => '
          q.group(1) do          
            q.breakable ''
            if v.is_a?(String) and v.size > 10
              q.pp(v[0..9] + '...')
            else
              q.pp v
            end
          end
          first = false
        }
      end
      q.breakable
      q.text "</hash>"
    end
  
    def pretty_print_cycle(q)
      q.text(empty? ? '{}' : '{...}')
    end
  end
  
  h = {:a => 'a'*5, :b => 'b'*10, :c => 'c'*20, :d => 'd'*30}
  pp h
  
  #=> 
  <hash>
    :d => "dddddddddd...",
    :a => "aaaaa",
    :b => "bbbbbbbbbb",
    :c => "cccccccccc..."
  </hash>

= reopen Kernel
== Private Instance Methods
--- pp(obj)    -> nil
#@todo
obj を [[m:$>]] に pretty print で出力します。

#@since 1.8.5 
= reopen Object
== Instance Methods
--- pretty_inspect
#@todo

self を pp で表示したときの結果を文字列として返します。
#@end

= class PP < PrettyPrint
オブジェクトなどを見やすく出力するためのクラスです。

== Class Methods
--- pp(obj, out = $>, width = 79)    -> object
#@todo
obj を out に幅 width で pretty print します。

PP.pp は out を返します。

  str = PP.pp([[:a, :b], [:a, [[:a, [:a, [:a, :b]]], [:a, :b],]]], '', 20)
  puts str
  #=>
  [[:a, :b],
   [:a,
    [[:a,
      [:a, [:a, :b]]],
     [:a, :b]]]]

--- sharing_detection    -> boolean
#@todo

共有検出フラグを返します。デフォルトは false です。

--- sharing_detection=(boolean_value)
#@todo

共有検出フラグを設定します。

--- singleline_pp(obj, out=$>)    -> object
#@todo
Outputs +obj+ to +out+ like PP.pp but with no indent and
newline.

PP.singleline_pp returns +out+.

== Instance Methods
--- pp(obj)    -> ()
#@todo

Object#pretty_print や Object#pretty_print_cycle を使って、
obj を pretty print バッファに追加します。

obj がすでに出力されていたときには [[m:Object#pretty_print_cycle]]
が使われます。これはオブジェクトの参照の連鎖がループしていることを
意味します。

--- object_group(obj) { ... }    -> ()
#@todo

以下と等価な働きをするもので簡便のために用意されています。

  group(1, '#<' + obj.class.name, '>') { ... }

--- comma_breakable    -> ()
#@todo

以下と等価な働きをするもので簡便のために用意されています。

  text ','
  breakable

--- seplist(list, sep=nil, iter_method=:each)    -> ()
#@todo

Adds a separated list.
The list is separated by comma with breakable space, by default.

seplist iterates the +list+ using +iter_method+.
It yields each object to the block given for #seplist.
The procedure +separator_proc+ is called between each yields.

If the iteration is zero times, +separator_proc+ is not called at all.

If +separator_proc+ is nil or not given,
+lambda { comma_breakable }+ is used.
If +iter_method+ is not given, :each is used.

For example, following 3 code fragments has similar effect.

  q.seplist([1,2,3]) {|v| xxx v }

  q.seplist([1,2,3], lambda { comma_breakable }, :each) {|v| xxx v }

  xxx 1
  q.comma_breakable
  xxx 2
  q.comma_breakable
  xxx 3

= reopen Object
== Instance Methods

--- pretty_print(pp)    -> ()
#@todo

一般のオブジェクトのためのデフォルトの pretty print メソッドです。
このメソッドはインスタンス変数を列挙するために
pretty_print_instance_variables を呼びます。

カスタマイズ(再定義)された inspect を self が持つ場合、
self.inspect の結果が使われますが、これは改行のヒントを持ちません。

もっともよく使われるいくつかの組み込みクラスについて、
PP モジュールはあらかじめ定義された pretty_print() メソッドを
簡便のために提供しています。

--- pretty_print_cycle(pp)    -> ()
#@todo

一般のオブジェクトがサイクルの一部であることが検出されたときのための
デフォルトの pretty print メソッドです。

--- pretty_print_instance_variables    -> [String | Symbol]
#@todo

ソートされたインスタンス変数の名前の配列を返します。

このメソッドはインスタンス変数の名前をシンボルか文字列として要素に持つ
配列を返さなければなりません。
 
 [:@a, :@b]

--- pretty_print_inspect    -> ()
#@todo
Is #inspect implementation using #pretty_print.
If you implement #pretty_print, it can be used as follows.

  alias inspect pretty_print_inspect

However, doing this requires that every class that #inspect is called on
implement #pretty_print, or a RuntimeError will be raised.

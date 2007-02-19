require prettyprint

Pretty-printer

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

あなたのクラスの pritty print をカスタマイズしたい場合は、
そのクラスで pretty_print(pp) メソッドを再定義します。
このメソッドは引数をひとつ取ります。引数 pp は [[c:PP]] クラスのインスタンスです。
このメソッドは出力に際して [[m:PP#text]], [[m:PP#breakable]], [[m:PP#nest]], [[m:PP#group]] および [[m:PP#pp]] を使います。前の4メソッドに関してはPPの親クラスのPrettyPrintで定義されています。[[m:PrettyPrint#text]], [[m:PrettyPrint#breakable]], [[m:PrettyPrint#nest]], [[m:PrettyPrint#group]] を参照してください。

= reopen Kernel
== Private Instance Methods
--- pp(obj)
#@todo
obj を $> に pretty print で出力します。
nil を返します。

#@since 1.8.5 
= reopen Object
== Instance Methods
--- pretty_inspect
#@todo

self を pp で表示したときの結果を文字列として返します。
#@end

= class PP < PrettyPrint

== Class Methods
--- pp(obj[, out[, width]])
#@todo
obj を out に幅 width で pretty print します。

out を省略した場合は、$> が指定されたものとみなされます。
width を省略した場合は、79 が指定されたものとみなされます。

PP.pp は out を返します。

  str = PP.pp([[:a, :b], [:a, [[:a, [:a, [:a, :b]]], [:a, :b],]]], '', 20)
  puts str
  #=>
  [[:a, :b],
   [:a,
    [[:a,
      [:a, [:a, :b]]],
     [:a, :b]]]]

--- sharing_detection
#@todo

共有検出フラグを boolean すなわち true か false で返します。
デフォルトは false です。

--- sharing_detection=(boolean_value)
#@todo

共有検出フラグを設定します。

--- singleline_pp(obj, out=$>)
#@todo
Outputs +obj+ to +out+ like PP.pp but with no indent and
newline.

PP.singleline_pp returns +out+.

== Instance Methods
--- pp(obj)
#@todo

Object#pretty_print や Object#pretty_print_cycle を使って、
obj を pretty print バッファに追加します。

obj がすでに出力されていたときには Object#pretty_print_cycle
が使われます。これはオブジェクトの参照の連鎖がループしていることを
意味します。

--- object_group(obj) { ... }
#@todo

以下と等価な働きをするもので簡便のために用意されています。

  group(1, '#<' + obj.class.name, '>') { ... }

--- comma_breakable
#@todo

以下と等価な働きをするもので簡便のために用意されています。

  text ','
  breakable

= reopen Object
== Instance Methods

--- pretty_print(pp)
#@todo

一般のオブジェクトのためのデフォルトの pretty print メソッドです。
このメソッドはインスタンス変数を列挙するために
pretty_print_instance_variables を呼びます。

カスタマイズ(再定義)された inspect を self が持つ場合、
self.inspect の結果が使われますが、これは改行のヒントを持ちません。

もっともよく使われるいくつかの組み込みクラスについて、
PP モジュールはあらかじめ定義された pretty_print() メソッドを
簡便のために提供しています。

--- pretty_print_cycle(pp)
#@todo

一般のオブジェクトがサイクルの一部であることが検出されたときのための
デフォルトの pretty print メソッドです。

--- pretty_print_instance_variables
#@todo

ソートされたインスタンス変数の名前の配列を返します。

このメソッドはインスタンス変数の名前をシンボルか文字列として要素に持つ
配列を返さなければなりません。
 
 [:@a, :@b]


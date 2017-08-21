category Development

require prettyprint

オブジェクトなどを見やすく出力するためのライブラリです。

このライブラリを require すると [[m:Kernel.#pp]] が定義されます。
[[m:Kernel.#p]] のかわりに [[m:Kernel.#pp]] を使うことにより、
適切にインデントと改行された分かりやすい出力を得ることが出来ます。pp ライブラリは、
ユーザがあたらしく定義したクラスに対しても見やすい表示を
するように作られていますので、[[m:Kernel.#pp]] を使う上で余計な作業をする
必要はありません。

=== どちらが読みやすいでしょうか?

p による pretty-print されてない出力:
  #<PP:0x81a0d10 @stack=[], @genspace=#<Proc:0x81a0cc0>, @nest=[0], @newline="\n",
   @buf=#<PrettyPrint::Group:0x81a0c98 @group=0, @tail=0, @buf=[#<PrettyPrint::Gro
  up:0x81a0ba8 @group=1, @tail=0, @buf=[#<PrettyPrint::Text:0x81a0b30 @tail=2, @wi
  dth=1, @text="[">, #<PrettyPrint::Group:0x81a0a68 @group=2, @tail=1, @buf=[#<Pre
  ttyPrint::Text:0x81a09f0 @tail=1, @width=1, @text="1">], @singleline_width=1>, #
  <PrettyPrint::Text:0x81a0a7c @tail=0, @width=1, @text=",">, #<PrettyPrint::Break
  able:0x81a0a2c @group=2, @gensace=#<Proc:0x81a0cc0>, @newline="\n", @indent=1, @
  tail=2, @sep=" ", @width=1>, #<PrettyPrint::Group:0x81a09c8 @group=2, @tail=1, @
  buf=[#<PrettyPrint::Text:0x81a0950 @tail=1, @width=1, @text="2">], @singleline_w
  idth=1>, #<PrettyPrint::Text:0x81a0af4 @tail=0, @width=1, @text="]">], @singleli
  ne_width=6>], @singleline_width=6>, @sharing_detection=false>

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

あるクラスの pp の出力をカスタマイズしたい場合は、
そのクラスで pretty_print メソッドと pretty_print_cycle メソッドを再定義します。
このメソッドは [[c:PP]] オブジェクトを引数として pp 実行時に呼ばれます。
ユーザは表示したい内容を表すツリーを、
引数として与えられた [[c:PP]] オブジェクトを使って以下のように作成します。

  * [[m:PrettyPrint#group]] を使って子ノードをつくります。同時に子ノードのインデントの深さも決めます。
  * [[m:PrettyPrint#breakable]] を使って改行しても良い場所を指定します。
  * [[m:PP#pp]] を使って出力したいインスタンス変数などを出力します。
  * [[m:PrettyPrint#text]] を使って、出力が見やすくなるように「,」などの修飾文字を適宜挿入します。

[[c:PP]] は [[c:PrettyPrint]] のサブクラスですので、上で PrettyPrint のメソッドとされているものは
PP のメソッドでもあります。

以下は Hash の pretty printing のカスタマイズの例です。

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

= class PP < PrettyPrint
オブジェクトなどを見やすく出力するためのクラスです。

== Class Methods
--- pp(obj, out = $>, width = 79)    -> object

指定されたオブジェクト obj を出力先 out に幅 width で出力します。
出力先 out を返します。

@param obj 表示したいオブジェクトを指定します。

@param out 出力先を指定します。<< メソッドが定義されている必要があります。

@param width 出力先の幅を指定します。

  require 'pp'
  str = PP.pp([[:a, :b], [:a, [[:a, [:a, [:a, :b]]], [:a, :b],]]], '', 20)
  puts str
  #=>
  [[:a, :b],
   [:a,
    [[:a,
      [:a, [:a, :b]]],
     [:a, :b]]]]

@see [[m:$>]]

--- sharing_detection                 -> bool
--- sharing_detection=(boolean)

共有検出フラグを表すアクセサです。
デフォルトは false です。true である場合、
[[m:PP.pp]] は一度出力したオブジェクトを再び出力する時
[[m:Object#pretty_print_cycle]] を使います。

@param boolean 共有検出フラグを true か false で指定します。

例:

  require 'pp'
  b = [1, 2, 3]
  a = [b, b]
    
  pp a                        #=> [[1, 2, 3], [1, 2, 3]]
  
  PP.sharing_detection = true
  pp a                        #=> [[1, 2, 3], [...]]


--- singleline_pp(obj, out=$>)    -> object

指定されたオブジェクト obj を出力先 out に出力します。
ただし、インデントも改行もしません。
出力先 out を返します。

@param obj 表示したいオブジェクトを指定します。

@param out 出力先を指定します。<< メソッドが定義されている必要があります。

== Instance Methods
--- pp(obj)    -> ()

指定されたオブジェクト obj を [[m:Object#pretty_print]] を使って自身のバッファに追加します。

obj がすでに、現在のノードの親において出力されていた場合には、
参照のループが存在しているので、[[m:Object#pretty_print]] の代わりに
[[m:Object#pretty_print_cycle]] が使われます。

@param obj 表示したいオブジェクトを指定します。

--- object_group(obj) { ... }    -> ()

以下と等価な働きをするもので簡便のために用意されています。
  group(1, '#<' + obj.class.name, '>') { ... }

@param obj 表示したいオブジェクトを指定します。

@see [[m:PrettyPrint#group]]

--- comma_breakable    -> ()

以下と等価な働きをするもので簡便のために用意されています。
  text ','
  breakable

@see [[m:PrettyPrint#text]], [[m:PrettyPrint#breakable]]

--- seplist(list, sep = lambda { comma_breakable }, iter_method = :each){|e| ...}    -> ()

リストの各要素を何かで区切りつつ、自身に追加していくために使われます。

list を iter_method によってイテレートし、各要素を引数としてブロックを実行します。
また、それぞれのブロックの実行の合間に sep が呼ばれます。

つまり、以下のふたつは同値です。

  require 'pp'

  q.seplist([1,2,3]) {|v| q.pp v }

  q.pp 1
  q.comma_breakable
  q.pp 2
  q.comma_breakable
  q.pp 3

@param list 自身に追加したい配列を与えます。iter_method を適切に指定すれば、
            Enumerable でなくても構いません。

@param sep 区切りを自身に追加するブロックを与えます。list がイテレートされないなら、
           sep は決して呼ばれません。

@param iter_method list をイテレートするメソッドをシンボルで与えます。

@see [[m:PP#comma_breakable]]

= reopen Object
== Instance Methods

--- pretty_print(pp)    -> ()

[[m:PP.pp]] や [[m:Kernel.#pp]] がオブジェクトの内容を出力するときに
呼ばれるメソッドです。[[c:PP]] オブジェクト pp を引数として呼ばれます。

あるクラスの pp の出力をカスタマイズしたい場合は、このメソッドを再定義します。
そのとき pretty_print メソッドは指定された pp に対して表示したい自身の内容を追加して
いかなければいけません。いくつかの組み込みクラスについて、
[[lib:pp]] ライブラリはあらかじめ pretty_print メソッドを定義しています。

@param pp [[c:PP]] オブジェクトです。

例:
  
 require 'pp'
 class Array
   def pretty_print(q)
     q.group(1, '[', ']') {
       q.seplist(self) {|v|
         q.pp v
       }
     }
   end
 end

@see [[m:Object#pretty_print_cycle]], [[m:Object#inspect]], [[m:PrettyPrint#text]], [[m:PrettyPrint#group]], [[m:PrettyPrint#breakable]]

--- pretty_print_cycle(pp)    -> ()

プリティプリント時にオブジェクトの循環参照が検出された場合、
[[m:Object#pretty_print]] の代わりに呼ばれるメソッドです。

あるクラスの pp の出力をカスタマイズしたい場合は、
このメソッドも再定義する必要があります。

@param pp [[c:PP]] オブジェクトです。

例:
 
 class Array 
   def pretty_print_cycle(q)
     q.text(empty? ? '[]' : '[...]')
   end
 end

@see [[m:Object#pretty_print]]

--- pretty_print_instance_variables    -> [String | Symbol]

プリティプリント時に表示すべき自身のインスタンス変数名の配列をソートして返します。
返されたインスタンス変数はプリティプリント時に表示されます。

pp に表示したくないインスタンス変数がある場合にこのメソッドを再定義します。

--- pretty_print_inspect    -> String

[[m:Object#pretty_print]] を使って [[m:Object#inspect]] と同様に
オブジェクトを人間が読める形式に変換した文字列を返します。

出力する全てのオブジェクトに [[m:Object#pretty_print]] が定義されている必要があります。
そうでない場合には [[c:RuntimeError]] が発生します。

@raise RuntimeError 出力する全てのオブジェクトに [[m:Object#pretty_print]] が定義されて
                    いない場合に発生します。

= reopen Kernel
== Module Functions
#@since 1.9.2
--- pp(*obj)    -> object
#@else
--- pp(*obj)    -> nil
#@end

指定されたオブジェクト obj を標準出力に見やすい形式(プリティプリント)で出力します。
obj それぞれを引数として [[m:PP.pp]] を呼びことと同等です。

@param obj 表示したいオブジェクトを指定します。

例:
  require 'pp'

  b = [1, 2, 3] * 4
  a = [b, b]
  a << a    
  pp a

  #=> [[1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3],
       [1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3],
       [...]]

@see [[m:PP.pp]]

#@since 1.8.5 
= reopen Object
== Instance Methods
--- pretty_inspect    -> String

self を pp で表示したときの結果を文字列として返します。
#@end

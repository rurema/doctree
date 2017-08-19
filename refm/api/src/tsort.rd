category Math

tsort はトポロジカルソートと強連結成分に関するモジュールを提供します。

=== Example

  require 'tsort'

  class Hash
    include TSort
    alias tsort_each_node each_key
    def tsort_each_child(node, &block)
      fetch(node).each(&block)
    end
  end

  {1=>[2, 3], 2=>[3], 3=>[], 4=>[]}.tsort
  #=> [3, 2, 1, 4]

  {1=>[2], 2=>[3, 4], 3=>[2], 4=>[]}.strongly_connected_components
  #=> [[4], [2, 3], [1]]

=== より現実的な例

非常に単純な `make' に似たツールは以下のように実装できます。

  require 'tsort'

  class Make
    def initialize
      @dep = {}
      @dep.default = []
    end

    def rule(outputs, inputs=[], &block)
      triple = [outputs, inputs, block]
      outputs.each {|f| @dep[f] = [triple]}
      @dep[triple] = inputs
    end

    def build(target)
      each_strongly_connected_component_from(target) {|ns|
        if ns.length != 1
          fs = ns.delete_if {|n| Array === n}
          raise TSort::Cyclic.new("cyclic dependencies: #{fs.join ', '}")
        end
        n = ns.first
        if Array === n
          outputs, inputs, block = n
          inputs_time = inputs.map {|f| File.mtime f}.max
          begin
            outputs_time = outputs.map {|f| File.mtime f}.min
          rescue Errno::ENOENT
            outputs_time = nil
          end
          if outputs_time == nil ||
             inputs_time != nil && outputs_time <= inputs_time
            sleep 1 if inputs_time != nil && inputs_time.to_i == Time.now.to_i
            block.call
          end
        end
      }
    end

    def tsort_each_child(node, &block)
      @dep[node].each(&block)
    end
    include TSort
  end

  def command(arg)
    print arg, "\n"
    system arg
  end

  m = Make.new
  m.rule(%w[t1]) { command 'date > t1' }
  m.rule(%w[t2]) { command 'date > t2' }
  m.rule(%w[t3]) { command 'date > t3' }
  m.rule(%w[t4], %w[t1 t3]) { command 'cat t1 t3 > t4' }
  m.rule(%w[t5], %w[t4 t2]) { command 'cat t4 t2 > t5' }
  m.build('t5')

=== Bugs

tsort という名前は正確ではありません。なぜなら
このライブラリは Tarjan の強連結成分に関するアルゴリズムを使っているからです。
とはいえ strongly_connected_components という正確な名前は長過ぎます。

=== References
R. E. Tarjan,
Depth First Search and Linear Graph Algorithms,
SIAM Journal on Computing, Vol. 1, No. 2, pp. 146-160, June 1972.

#@#@Article{Tarjan:1972:DFS,
#@#  author =       "R. E. Tarjan",
#@#  key =          "Tarjan",
#@#  title =        "Depth First Search and Linear Graph Algorithms",
#@#  journal =      j-SIAM-J-COMPUT,
#@#  volume =       "1",
#@#  number =       "2",
#@#  pages =        "146--160",
#@#  month =        jun,
#@#  year =         "1972",
#@#  CODEN =        "SMJCAT",
#@#  ISSN =         "0097-5397 (print), 1095-7111 (electronic)",
#@#  bibdate =      "Thu Jan 23 09:56:44 1997",
#@#  bibsource =    "Parallel/Multi.bib, Misc/Reverse.eng.bib",
#@#}

= module TSort

TSort は強連結成分に関する Tarjan のアルゴリズムを用いた
トポロジカルソートの実装です。

TSort は任意のオブジェクトを有向グラフとして解釈できるように設計されています。
TSort がオブジェクトをグラフとして解釈するには2つのメソッドを要求します。
すなわち、tsort_each_node と tsort_each_child です。

 * tsort_each_node はグラフ上のすべての頂点を巡回するのに用いられます。
 * tsort_each_child は与えられた頂点の子を巡回するのに用いられます。

頂点同士の等価性は eql? と hash によって定義されます。
これは TSort が内部でハッシュを用いているからです。

== Class Methods
--- tsort(each_node, each_child) -> Array

頂点をトポロジカルソートして得られる配列を返します。
この配列は子から親に向かってソートされています。
すなわち、最初の要素は子を持たず、最後の要素は親を持ちません。

引数 each_node と each_child でグラフを表します。

@param each_node グラフ上の頂点をそれぞれ評価するcallメソッドを持つオブ
                 ジェクトを指定します。

@param each_child 引数で与えられた頂点の子をそれぞれ評価するcallメソッ
                  ドを持つオブジェクトを指定します。

@raise TSort::Cyclic 閉路が存在するとき、発生します。

使用例
  require 'tsort'

  g = {1=>[2, 3], 2=>[4], 3=>[2, 4], 4=>[]}
  each_node = lambda {|&b| g.each_key(&b) }
  each_child = lambda {|n, &b| g[n].each(&b) }
  p TSort.tsort(each_node, each_child) # => [4, 2, 3, 1]

  g = {1=>[2], 2=>[3, 4], 3=>[2], 4=>[]}
  each_node = lambda {|&b| g.each_key(&b) }
  each_child = lambda {|n, &b| g[n].each(&b) }
  p TSort.tsort(each_node, each_child) # raises TSort::Cyclic

@see [[m:TSort#tsort]]

--- tsort_each(each_node, each_child) {|node| ...} -> nil
#@since 2.2.0
--- tsort_each(each_node, each_child) -> Enumerator
#@end

[[m:TSort.tsort]] メソッドのイテレータ版です。

引数 each_node と each_child でグラフを表します。

@param each_node グラフ上の頂点をそれぞれ評価するcallメソッドを持つオブ
                 ジェクトを指定します。

@param each_child 引数で与えられた頂点の子をそれぞれ評価するcallメソッ
                  ドを持つオブジェクトを指定します。

@raise TSort::Cyclic 閉路が存在するとき、発生します.

使用例
  require 'tsort'

  g = {1=>[2, 3], 2=>[4], 3=>[2, 4], 4=>[]}
  each_node = lambda {|&b| g.each_key(&b) }
  each_child = lambda {|n, &b| g[n].each(&b) }
  TSort.tsort_each(each_node, each_child) {|n| p n }
  # => 4
  #    2
  #    3
  #    1

@see [[m:TSort#tsort_each]]

--- strongly_connected_components(each_node, each_child) -> Array

強連結成分の集まりを配列の配列として返します。
この配列は子から親に向かってソートされています。
各要素は強連結成分を表す配列です。

引数 each_node と each_child でグラフを表します。

@param each_node グラフ上の頂点をそれぞれ評価するcallメソッドを持つオブ
                 ジェクトを指定します。

@param each_child 引数で与えられた頂点の子をそれぞれ評価するcallメソッ
                  ドを持つオブジェクトを指定します。

使用例
  require 'tsort'

  g = {1=>[2, 3], 2=>[4], 3=>[2, 4], 4=>[]}
  each_node = lambda {|&b| g.each_key(&b) }
  each_child = lambda {|n, &b| g[n].each(&b) }
  p TSort.strongly_connected_components(each_node, each_child)
  # => [[4], [2], [3], [1]]

  g = {1=>[2], 2=>[3, 4], 3=>[2], 4=>[]}
  each_node = lambda {|&b| g.each_key(&b) }
  each_child = lambda {|n, &b| g[n].each(&b) }
  p TSort.strongly_connected_components(each_node, each_child)
  # => [[4], [2, 3], [1]]

@see [[m:TSort#strongly_connected_components]]

--- each_strongly_connected_component(each_node, each_child) {|nodes| ...} -> nil
#@since 2.2.0
--- each_strongly_connected_component(each_node, each_child) -> Enumerator
#@end

[[m:TSort.strongly_connected_components]] メソッドのイテレータ版です。

引数 each_node と each_child でグラフを表します。

@param each_node グラフ上の頂点をそれぞれ評価するcallメソッドを持つオブ
                 ジェクトを指定します。

@param each_child 引数で与えられた頂点の子をそれぞれ評価するcallメソッ
                  ドを持つオブジェクトを指定します。

使用例
  require 'tsort'

  g = {1=>[2, 3], 2=>[4], 3=>[2, 4], 4=>[]}
  each_node = lambda {|&b| g.each_key(&b) }
  each_child = lambda {|n, &b| g[n].each(&b) }
  TSort.each_strongly_connected_component(each_node, each_child) {|scc| p scc }

  # => [4]
  #    [2]
  #    [3]
  #    [1]

  g = {1=>[2], 2=>[3, 4], 3=>[2], 4=>[]}
  each_node = lambda {|&b| g.each_key(&b) }
  each_child = lambda {|n, &b| g[n].each(&b) }
  TSort.each_strongly_connected_component(each_node, each_child) {|scc| p scc }

  # => [4]
  #    [2, 3]
  #    [1]

@see [[m:TSort#each_strongly_connected_component]]

--- each_strongly_connected_component_from(node, each_child, id_map={}, stack=[]) {|nodes| ...} -> ()
#@since 2.2.0
--- each_strongly_connected_component_from(node, each_child, id_map={}, stack=[]) -> Enumerator
#@end

node から到達可能な強連結成分についてのイテレータです。

引数 node と each_child でグラフを表します。

返す値は規定されていません。

TSort.each_strongly_connected_component_fromは[[c:TSort]]をincludeして
グラフを表現する必要のないクラスメソッドです。

@param node ノードを指定します。

@param each_child 引数で与えられた頂点の子をそれぞれ評価するcallメソッ
                  ドを持つオブジェクトを指定します。

使用例
  require 'tsort'

  graph = {1=>[2], 2=>[3, 4], 3=>[2], 4=>[]}
  each_child = lambda {|n, &b| graph[n].each(&b) }
  TSort.each_strongly_connected_component_from(1, each_child) {|scc|
    p scc
  }
  # => [4]
  #    [2, 3]
  #    [1]

@see [[m:TSort#each_strongly_connected_component_from]]

== Instance Methods
--- tsort -> Array

頂点をトポロジカルソートして得られる配列を返します。
この配列は子から親に向かってソートされています。
すなわち、最初の要素は子を持たず、最後の要素は親を持ちません。

@raise TSort::Cyclic 閉路が存在するとき、発生します。

使用例
  require 'tsort'

  class Hash
    include TSort
    alias tsort_each_node each_key
    def tsort_each_child(node, &block)
      fetch(node).each(&block)
    end
  end

  sorted = {1=>[2, 3], 2=>[3], 3=>[], 4=>[]}.tsort
  p sorted #=> [3, 2, 1, 4]

@see [[m:TSort.tsort]]

--- tsort_each {|node| ...} -> nil
#@since 2.2.0
--- tsort_each -> Enumerator
#@end

[[m:TSort#tsort]] メソッドのイテレータ版です。
obj.tsort_each は obj.tsort.each と似ていますが、
ブロックの評価中に obj が変更された場合は予期しない結果になる
ことがあります。

tsort_each は nil を返します。
閉路が存在するとき、例外 [[c:TSort::Cyclic]] を起こします。

@raise TSort::Cyclic 閉路が存在するとき、発生します.

使用例
  require 'tsort'

  class Hash
    include TSort
    alias tsort_each_node each_key
    def tsort_each_child(node, &block)
      fetch(node).each(&block)
    end
  end

  non_sort = {1=>[2, 3], 2=>[3], 3=>[], 4=>[]}

  non_sort.tsort_each {|node|
    non_sort.tsort_each_child(node){|child|
      printf("%d -> %d\n", node, child)
    }
  }

  # 出力
  #=> 2 -> 3
  #=> 1 -> 2
  #=> 1 -> 3

@see [[m:TSort.tsort_each]]

--- strongly_connected_components -> Array

強連結成分の集まりを配列の配列として返します。
この配列は子から親に向かってソートされています。
各要素は強連結成分を表す配列です。

使用例
  require 'tsort'

  class Hash
    include TSort
    alias tsort_each_node each_key
    def tsort_each_child(node, &block)
      fetch(node).each(&block)
    end
  end

  non_sort = {1=>[2], 2=>[3, 4], 3=>[2], 4=>[]}

  p non_sort.strongly_connected_components
  #=> [[4], [2, 3], [1]]

@see [[m:TSort.strongly_connected_components]]

--- each_strongly_connected_component {|nodes| ...} -> nil
#@since 2.2.0
--- each_strongly_connected_component -> Enumerator
#@end

[[m:TSort#strongly_connected_components]] メソッドのイテレータ版です。
obj.each_strongly_connected_component は
obj.strongly_connected_components.each に似ていますが、
ブロックの評価中に obj が変更された場合は予期しない結果になる
ことがあります。

each_strongly_connected_component は nil を返します。

使用例
  require 'tsort'

  class Hash
    include TSort
    alias tsort_each_node each_key
    def tsort_each_child(node, &block)
      fetch(node).each(&block)
    end
  end

  non_sort = {1=>[2], 2=>[3, 4], 3=>[2], 4=>[]}

  non_sort.each_strongly_connected_component{|nodes|
    p nodes
  }

  #出力
  #=> [4]
  #=> [2, 3]
  #=> [1]

@see [[m:TSort.each_strongly_connected_component]]

--- each_strongly_connected_component_from(node, id_map={}, stack=[]) {|nodes| ...} -> ()
#@since 2.2.0
--- each_strongly_connected_component_from(node, id_map={}, stack=[]) -> Enumerator
#@end

node から到達可能な強連結成分についてのイテレータです。

返す値は規定されていません。

each_strongly_connected_component_from は
tsort_each_node を呼びません。

@param node ノードを指定します。

  #例 到達可能なノードを表示する
  require 'tsort'

  class Hash
    include TSort
    alias tsort_each_node each_key
    def tsort_each_child(node, &block)
      fetch(node).each(&block)
    end
  end

  non_sort = {1=>[2], 2=>[3, 4], 3=>[2], 4=>[]}

  non_sort.each_strongly_connected_component{|nodes|
    p nodes
    nodes.each {|node|
      non_sort.each_strongly_connected_component_from(node){|ns|
        printf("%s -> %s\n", node, ns.join(","))
      }
    }
  }

  #出力
  #=> [4]
  #=> 4 -> 4
  #=> [2, 3]
  #=> 2 -> 4
  #=> 2 -> 2,3
  #=> 3 -> 4
  #=> 3 -> 3,2
  #=> [1]
  #=> 1 -> 4
  #=> 1 -> 2,3
  #=> 1 -> 1

@see [[m:TSort.each_strongly_connected_component_from]]

--- tsort_each_node {|node| ...} -> ()

TSort で拡張されるクラスで定義されていなければならないメソッドです。

tsort_each_node is used to iterate for all nodes over a graph.

@raise NotImplementedError TSort で拡張されるクラスで定義されていない場合発生します。

--- tsort_each_child(node) {|child| ...} -> ()

TSort で拡張されるクラスで定義されていなければならないメソッドです。

tsort_each_child is used to iterate for child nodes of node.

@param node ノードを指定します。

@raise NotImplementedError TSort で拡張されるクラスで定義されていない場合発生します。

= class TSort::Cyclic < StandardError

閉路が存在する時、発生します。

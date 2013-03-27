= class REXML::Parent < REXML::Child
include Enumerable

あるノードの親ノードとなりうるノードを表すクラスです。

子ノードにアクセスするための各種メソッドを持っています。

== Class Methods

--- new(parent = nil) -> REXML::Parent
REXML::Parent オブジェクトを生成します。

子ノード列は空列に初期化されます。

parent で親ノードを指定します。
親ノードへの追加は行わないため、オブジェクト生成後に親に
適切に設定する必要があります。

通常、このメソッドは直接は使いません。継承先のクラスが適切に
このメソッド(initialize)を呼び出します。

@param parent 親ノード

== Instance Methods

--- add(object) -> ()
--- push(object) -> ()
--- <<(object) -> ()
object を子ノード列の最後に追加します。

object の親ノードには self が設定されます。

@param object 追加するノード

--- unshift(object) -> ()
object を子ノード列の最初に追加します。

object の親ノードには self が設定されます。

@param object 追加するノード

--- delete(object) -> REXML::Child | nil
object を子ノード列から削除します。

削除されたノードの親は nil に設定されます。

削除したノードを返します。削除されなかった場合は nil を返します。

@param object 削除するノード

--- each {|object| ... } -> ()
--- each_child {|object| ... } -> ()
#@since 1.9.1
--- each -> Enumerator
--- each_child -> Enumerator
#@end

各子ノードに対しブロックを呼び出します。

ブロックを省略した場合は、各子ノードに対し操作を
繰り返すような [[c:Enumerator]] オブジェクトを返します。

--- delete_if {|object| ... } -> ()
#@since 1.9.1
--- delete_if -> Enumerator
#@end

各子ノードに対しブロックを呼び出し、真を返したノードを削除します。

ブロックを省略した場合は、各子ノードに対し上の操作を
する [[c:Enumerator]] オブジェクトを返します。


--- delete_at(index) -> REXML::Child | nil

子ノード列上の index で指定された場所の要素を取り除きます。

取り除いだノードを返します。indexが範囲外である場合は何もせず
nil を返します。

--- each_index {|index| ... } -> ()
#@since 1.9.1
--- each_index -> Enumerator
#@end

各子ノードのインデックスに対しブロックを呼び出します。

ブロックが省略された場合は上のような繰り返しをする
[[c:Enumerator]] オブジェクトを返します。


--- [](index) -> REXML::Child | nil
子ノード列上の index で指定された場所のノードを返します。

範囲外を指定した場合は nil を返します。

--- []=(index, node)
--- []=(range, node)
--- []=(start, length, node)
子ノード列上の指定した場所を node で置き換えます。

[[m:Array#[]=]] と同じ指定が可能です。

@param index 変更場所の index ([[c:Integer]])
@param range 変更場所の範囲 ([[c:Range]])
@param start 変更範囲の最初の位置 ([[c:Integer]])
@param length 変更範囲の個数 ([[c:Integer]])
@param node 置き換えるノード

--- insert_before(child1, child2) -> self
child2 を child1 で指定したノードの前に挿入します。

child1 が REXML::Child のインスタンスであるならば、その
子ノードの前に挿入されます。
child1 が 文字列であるならば、XPath で場所を指定します。
具体的には [[m:REXML::XPath.first]](self, child1) で特定されるノードの
前に挿入されます。

挿入されるノード(child2)の親は self に変更されます。

@param child1 挿入場所の指定
@param child2 挿入されるノード

--- insert_after(child1, child2) -> self
child2 を child1 で指定したノードの後ろに挿入します。

child1 が REXML::Child のインスタンスであるならば、その
子ノードの後ろに挿入されます。
child1 が 文字列であるならば、XPath で場所を指定します。
具体的には [[m:REXML::XPath.first]](self, child1) で特定されるノードの
後ろに挿入されます。

挿入されるノード(child2)の親は self に変更されます。

@param child1 挿入場所の指定
@param child2 挿入されるノード


--- to_a -> [REXML::Child]
--- children -> [REXML::Child]
子ノード列の配列を返します。


--- index(child) -> Integer | nil
child の子ノード列上での位置を返します。

child が子ノードでない場合には nil を返します。

--- size -> Integer
#@since 1.8.5
--- length -> Integer
#@end

保持している子ノードの数を返します。

--- replace_child(to_replace, replacement) -> ()
子ノード列上の to_replace を replacement に置き換えます。

to_replace の parent は nil に、
replacement の parent は selfに変更されます。

@param to_replace 置き換え元のノード
@param replacement 置き換え先のノード

--- deep_clone -> REXML::Parent
ノードを複製し、複製されたノードを返します。

子ノードも複製されます。

--- parent? -> bool
true を返します。

@see [[m:REXML::Node#parent]]


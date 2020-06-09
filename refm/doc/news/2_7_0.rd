#@since 2.7.0
= NEWS for Ruby 2.7.0

このドキュメントは前回リリース以降のバグ修正を除くユーザーに影響のある機能の変更のリストです。

それぞれのエントリーは参照情報があるため短いです。
十分な情報と共に書かれた全ての変更のリストは ChangeLog ファイルか bugs.ruby-lang.org の issue を参照してください。

== 2.6.0 以降の変更

=== 言語仕様の変更

==== パターンマッチ

  * パターンマッチが実験的機能として導入されました。 [[feature:14912]]

#@samplecode
case [0, [1, 2, 3]]
in [a, [b, *c]]
  p a #=> 0
  p b #=> 1
  p c #=> [2, 3]
end

case {a: 0, b: 1}
in {a: 0, x: 1}
  :unreachable
in {a: 0, b: var}
  p var #=> 1
end

case -1
in 0 then :unreachable
in 1 then :unreachable
end #=> NoMatchingPatternError

json = <<END
{
  "name": "Alice",
  "age": 30,
  "children": [{ "name": "Bob", "age": 2 }]
}
END

JSON.parse(json, symbolize_names: true) in {name: "Alice", children: [{name: name, age: age}]}

p name #=> "Bob"
p age  #=> 2

JSON.parse(json, symbolize_names: true) in {name: "Alice", children: [{name: "Charlie", age: age}]}
#=> NoMatchingPatternError
#@end

  * 詳細は [[url:https://speakerdeck.com/k_tsj/pattern-matching-new-feature-in-ruby-2-dot-7]] のスライドを参照してください。
  * スライドは少し古い内容になっていることに注意してください。

  * パターンマッチに対する警告は「-W:no-experimental」オプションで抑制できます。

==== 3.0 に向けてのキーワード引数の仕様変更

  * キーワード引数と位置引数の自動変換は自動変換が非推奨となりました。
    この変換はRuby 3で除去される予定です。 [[feature:14183]]

  * メソッド呼び出しにおいて最後の引数としてハッシュオブジェクトを渡し、
    他にキーワード引数を渡さず、かつ、呼ばれたメソッドがキーワード引数を
    受け取るとき、警告が表示されます。キーワード引数として扱いたい場合は、
    明示的にdouble splat演算子（**）を足すことで警告を回避できます。
    このように書けばRuby 3でも同じ意味で動きます。

#@samplecode
def foo(key: 42); end; foo({key: 42})   # warned
def foo(**kw);    end; foo({key: 42})   # warned
def foo(key: 42); end; foo(**{key: 42}) # OK
def foo(**kw);    end; foo(**{key: 42}) # OK
#@end

  * キーワード引数を受け取るメソッドにキーワード引数を渡すが、必須引数
    が不足している場合に、キーワード引数は最後の必須引数として解釈され、
    警告が表示されます。警告を回避するには、キーワードではなく明示的に
    ハッシュとして渡してください。
    このように書けばRuby 3でも同じ意味で動きます。

#@samplecode
def foo(h, **kw); end; foo(key: 42)      # warned
def foo(h, key: 42); end; foo(key: 42)   # warned
def foo(h, **kw); end; foo({key: 42})    # OK
def foo(h, key: 42); end; foo({key: 42}) # OK
#@end

  * メソッドがキーワード引数を受け取るがdouble splat引数は受け取らず、
    かつ、メソッド呼び出しでSymbolと非Symbolの混ざったハッシュを渡す
    （もしくはハッシュをdouble splatでキーワードとして渡す）場合、
    ハッシュは分割され、警告が表示されます。Ruby 3でもハッシュの分割を
    続けたい場合は、呼び出し側で明示的に分けるようにしてください。

#@samplecode
def foo(h={}, key: 42); end; foo("key" => 43, key: 42)   # warned
def foo(h={}, key: 42); end; foo({"key" => 43, key: 42}) # warned
def foo(h={}, key: 42); end; foo({"key" => 43}, key: 42) # OK
#@end

  * メソッドがキーワード引数を受け取らず、呼び出し側でキーワード引数を
    渡した場合、ハッシュの引数としてみなされる挙動は変わらず、警告も
    表示されません。Ruby 3でもこのコードは動き続ける予定です。

#@samplecode
def foo(opt={});  end; foo( key: 42 )   # OK
#@end

  * メソッドが任意のキーワードを受け取る場合、非Symbolがキーワード引数のキー
    として許容されるようになります。 [[feature:14183]]

  * 2.6.0で非Symbolがキーワード引数のキーとして許容されなくなりましたが、
    再び許容されるようになりました。 [[bug:15658]]

#@samplecode
def foo(**kw); p kw; end; foo("str" => 1) #=> {"str"=>1}
#@end

  * メソッド定義で**nilと書くことで、このメソッドがキーワードを
    受け取らないことを明示できるようになりました。このようなメソッドを
    キーワード引数付きで呼び出すとArgumentErrorになります。 [[feature:14183]]

#@samplecode
def foo(h, **nil); end; foo(key: 1)       # ArgumentError
def foo(h, **nil); end; foo(**{key: 1})   # ArgumentError
def foo(h, **nil); end; foo("str" => 1)   # ArgumentError
def foo(h, **nil); end; foo({key: 1})     # OK
def foo(h, **nil); end; foo({"str" => 1}) # OK
#@end

  * キーワード引数を受け取らないメソッドに対して空のハッシュを
    double splatで渡すとき、空のハッシュが渡る挙動はなくなりました。
    ただし、必須引数が不足する場合は空のハッシュが渡され、警告が表示されます。
    ハッシュの引数として渡したい場合はdouble splatをつけないようにしてください。
    [[feature:14183]]

#@samplecode
h = {}; def foo(*a) a end; foo(**h) # []
h = {}; def foo(a) a end; foo(**h)  # {} and warning
h = {}; def foo(*a) a end; foo(h)   # [{}]
h = {}; def foo(a) a end; foo(h)    # {}
#@end

  * 非推奨に関する警告を止めたい場合は、コマンドライン引数に
    「-W:no-deprecated」を指定するか、コードの中で
    「Warning[:deprecated] = false」
    としてください。

==== 番号指定パラメータ

  * 番号指定パラメータ(Numbered parameters)がデフォルトのブロックの仮引数として
    導入されました。 [[feature:4475]]

#@samplecode
[1, 2, 10].map { _1.to_s(16) }    #=> ["1", "2", "a"]
[[1, 2], [3, 4]].map { _1 + _2 }  #=> [3, 7]
#@end

  * 「_1」などはまだローカル変数名として使えて、ローカル変数が優先されますが、
    警告が表示されます。

#@samplecode
_1 = 0            #=> warning: `_1' is reserved for numbered parameter; consider another name
[1].each { p _1 } # prints 0 instead of 1
#@end

==== ブロックなしの proc/lambda が deprecated

  * ブロック付きで呼び出されたメソッドの中で、ブロックなしで[[m:Proc.new]]や[[m:Kernel#proc]]を
    呼び出すと警告が表示されるようになりました。

#@samplecode
def foo
  proc
end
foo { puts "Hello" } #=> warning: Capturing the given block using Kernel#proc is deprecated; use `&block` instead
#@end

  * 非推奨に関する警告を止めたい場合は、コマンドライン引数に
    「-W:no-deprecated」を指定するか、コードの中で
    「Warning[:deprecated] = false」
    としてください。

  * ブロック付きで呼び出されたメソッドの中で、[[m:Kernel#lambda]]をブロックなしで呼び出すと
    例外が発生するようになりました。

#@samplecode
def bar
  lambda
end
bar { puts "Hello" } #=> tried to create Proc object without a block (ArgumentError)
#@end

==== その他の変更

  * 始端なしRangeが実験的に導入されました。
    caseや[[c:Comparable#clamp]]や定数やDSLなどで便利かもしれません。
    [[feature:14799]]

#@samplecode
ary[..3]  # identical to ary[0..3]

case RUBY_VERSION
when ..."2.4" then puts "EOL"
# ...
end

age.clamp(..100)

where(sales: ..100)
#@end

  * 「$;」にnil以外の値を設定すると警告が出るようになりました。 [[feature:14240]]
    nil以外の時は[[m:String#split]]で参照した時も警告が出ます。
    この警告は「-W:no-deprecated」オプションで止められます。

  * 「$,」にnil以外の値を設定すると警告が出るようになりました。 [[feature:14240]]
    nil以外の時は[[m:Array#join]]で参照した時も警告が出ます。
    この警告は「-W:no-deprecated」オプションで止められます。

  * ヒアドキュメントの識別子の引用符は同じ行で閉じる必要があります。

//emlist{
<<"EOS
" # This had been warned since 2.4; Now it raises a SyntaxError
EOS
//}

  * フリップフロップが非推奨になったのが元に戻されました。 [[feature:5400]]

  * 以下のような場所にコメントを書けるようになりました。

#@samplecode
foo
  # .bar
  .baz # => foo.baz
#@end

  * リテラルの「self」をレシーバーとしたプライベートメソッド呼び出しが
    できるようになりました。 [[feature:11297]] [[feature:16123]]

  * 多重代入でのrescue修飾子が単一の代入と同じ振る舞いになりました。 [[bug:8279]]

#@samplecode
a, b = raise rescue [1, 2]
# Previously parsed as: (a, b = raise) rescue [1, 2]
# Now parsed as:         a, b = (raise rescue [1, 2])
#@end

  * 特異クラス構文での yield は警告を表示するようになりました。
    これは deprecated です。 [[feature:15575]]
    この警告は「-W:no-deprecated」オプションで止められます。

#@samplecode
def foo
  class << Object.new
    yield #=> warning: `yield' in class syntax will not be supported from Ruby 3.0. [[feature:15575]]
  end
end
foo { p :ok }
#@end

  * 引数を転送する記法「(...)」が導入されました。 [[feature:16253]]
    * foo の全ての引数(キーワード引数やブロックを含む)を bar に転送します。
      注意点として括弧は必須です。「bar ...」は終端なし Range と解釈されます。

#@samplecode
def foo(...)
  bar(...)
end
#@end

  * 「$SAFE」の参照や代入は警告が表示されるようになりました。
    Ruby 3.0 で「$SAFE」は普通のグローバル変数になる予定です。 [[feature:16131]]

  * [[m:Object#taint]],[[m:Object#untaint]],[[m:Object#trust]],[[m:Object#untrust]]と関連する
    C の関数は何もしなくなりました。(全てのオブジェクトは untainted 扱いです。)
    verbose モードでは警告が表示されます。
    この警告は Ruby 3.0 では verbose モードでなくても表示され、Ruby 3.2 で削除される
    予定です。 [[feature:16131]]

  * [[m:Object#method]]と[[m:Module#instance_method]]がrefinementsを考慮するようになりました。 [[feature:15373]]

=== コマンドラインオプション

==== 警告オプション

カテゴリ化された警告を管理するために「-W」オプションが「:」を続けられるように
拡張されました。 [[feature:16345]] [[feature:16420]]

  * 非推奨警告を止める例:

//emlist{
$ ruby -e '$; = ""'
-e:1: warning: `$;' is deprecated

$ ruby -W:no-deprecated -e '$; = //'
//}

  * RUBYOPT環境変数での使用例:

//emlist{
$ RUBYOPT=-W:no-deprecated ruby -e '$; = //'
//}

  * 実験的機能の警告を止める例:

//emlist{
$ ruby -e '0 in a'
-e:1: warning: Pattern matching is experimental, and the behavior may change in future versions of Ruby!

$ ruby -W:no-experimental -e '0 in a'
//}

  * RUBYOPTで両方止めるにはスペース区切りで指定します:

//emlist{
$ RUBYOPT='-W:no-deprecated -W:no-experimental' ruby -e '($; = "") in a'
//}

組み込みクラスの更新のWarningも参照してください。

=== 組み込みクラスの更新 (注目すべきもののみ)

  * [[c:Array]]
    * 新規メソッド
      * [[m:Array#intersection]]が追加されました。 [[feature:16155]]
      * [[m:Array#minmax]]が[[m:Enumerable#minmax]]より高速な実装として追加されました。 [[bug:15929]]

  * [[c:Comparable]]
    * 変更されたメソッド
      * [[m:Comparable#clamp]]がRangeを引数として受け付けるようになりました。 [[feature:14784]]

#@samplecode
-1.clamp(0..2) #=> 0
 1.clamp(0..2) #=> 1
 3.clamp(0..2) #=> 2
# With beginless and endless ranges:
-1.clamp(0..)  #=> 0
 3.clamp(..2)  #=> 2
#@end

  * [[c:Complex]]
    * 新規メソッド
      * [[m:Complex#<=>]]が追加されました。
        その結果、「0 <=> 0i」が[[c:NoMethodError]]を発生しなくなりました。 [[bug:15857]]

  * [[c:Dir]]
    * 変更されたメソッド
      * [[m:Dir.glob]]と[[m:Dir.[] ]] がNUL文字区切りのグロブパターンを受け付けなくなりました。
        代わりにArrayを使ってください。 [[feature:14643]]

  * [[c:Encoding]]
    * 新規エンコーディング
      * CESU-8が追加されました。 [[feature:15931]]

  * [[c:Enumerable]]
    * 新規メソッド
      * [[m:Enumerable#filter_map]]が追加されました。 [[feature:15323]]
      * [[m:Enumerable#tally]]が追加されました。 [[feature:11076]]
#@samplecode Enumerable#filter_map
[1, 2, 3].filter_map {|x| x.odd? ? x.to_s : nil } #=> ["1", "3"]
#@end
#@samplecode Enumerable#tally
["A", "B", "C", "B", "A"].tally #=> {"A"=>2, "B"=>2, "C"=>1}
#@end

  * [[c:Enumerator]]
    * 新規メソッド
      * 任意のデータ変換から[[c:Enumerator]]を作成するための
        [[m:Enumerator.produce]]メソッドが追加されました。 [[feature:14781]]
      * lazy enumerator から lazy ではない enumerator を生成する
        [[m:Enumerator::Lazy#eager]]メソッドが追加されました。 [[feature:15901]]
      * [[m:Enumerator::Yielder#to_proc]]メソッドが追加され、Yielder オブジェクトを
        直接他のメソッドのブロック引数として渡せるようになりました。 [[feature:15618]]
#@samplecode Enumerator.produce
require "date"
dates = Enumerator.produce(Date.today, &:succ) #=> infinite sequence of dates
dates.detect(&:tuesday?) #=> next Tuesday
#@end
#@samplecode Enumerator::Lazy#eager
a = %w(foo bar baz)
e = a.lazy.map {|x| x.upcase }.map {|x| x + "!" }.eager
p e.class               #=> Enumerator
p e.map {|x| x + "?" }  #=> ["FOO!?", "BAR!?", "BAZ!?"]
#@end

  * [[c:Fiber]]
    * 新規メソッド
      * [[m:Fiber#raise]]メソッドが追加され、[[m:Fiber#resume]]のように
        resumeして、さらに例外を発生させます。 [[feature:10344]]

  * [[c:File]]
    * 変更されたメソッド
      * Windows以外のプラットフォームで[[m:File.extname]]が「.」で終わる文字列に対して
        「.」を返すようになりました。  [[bug:15267]]

#@samplecode
File.extname("foo.") #=> "."
#@end

  * [[c:FrozenError]]
    * 新規メソッド
      * 変更しようとしたfreezeされたオブジェクトを返す[[m:FrozenError#receiver]]メソッドが
        追加されました。[[c:FrozenError]]をRubyのコードで発生する時に設定できるように
        [[m:FrozenError.new]]メソッドが :receiver オプションを受け付けるように
        なりました。 [[feature:15751]]

  * [[c:GC]]
    * 新規メソッド
      * ヒープをコンパクションする[[m:GC.compact]]メソッドが追加されました。
        このメソッドはヒープの生きているオブジェクトをコンパクションして、
        ページ数を減らして、ヒープをCoW (copy-on-write)フレンドリーに
        しようとします。 [[feature:15626]]
     *  アルゴリズムの詳細と注意点は
        [[url:https://bugs.ruby-lang.org/issues/15626]]
        を参照してください。

  * [[c:IO]]
    * 新規メソッド
      * BOMをチェックして外部エンコーディングを設定する
        [[m:IO#set_encoding_by_bom]]メソッドが追加されました。 [[bug:15210]]

  * [[c:Integer]]
    * 変更されたメソッド
      * [[m:Integer#[] ]]がRangeを受け付けるようになりました。 [[feature:8842]]

#@samplecode
0b01001101[2, 4]  #=> 0b0011
0b01001100[2..5]  #=> 0b0011
0b01001100[2...6] #=> 0b0011
#   ^^^^
#@end

  * [[c:Method]]
    * 変更されたメソッド
      * [[m:Method#inspect]]で出てくる情報が増えました。 [[feature:14145]]

  * [[c:Module]]
    * 新規メソッド
      * 定数が定義された場所を取得する[[m:Module#const_source_location]]
        メソッドが追加されました。 [[feature:10771]]
      * 通常の引数分解でキーワード引数を渡すようにメソッドに印をつける
        [[m:Module#ruby2_keywords]]を追加しました。
        古いRubyと互換性のある方法で全ての引数を転送する時に使えます。 [[bug:16154]]
    * 変更されたメソッド
      * [[m:Module#const_defined?]]のように[[m:Module#autoload?]]が
        inheritオプショナル引数を受け付けるようになりました。 [[feature:15777]]
      * [[m:Module#name]]が常にfreezeされた文字列を返すようになりました。
        同じModuleは常に同じStringを返します。
        この変更は実験的です。 [[feature:16150]]

  * [[c:NilClass]] / [[c:TrueClass]] / [[c:FalseClass]]
    * 変更されたメソッド
      * [[m:NilClass#to_s]], [[m:TrueClass#to_s]], [[m:FalseClass#to_s]]が
        常にfreezeされたStringを返すようになりました。
        返り値のStringは常に同じインスタンスになります。
        この変更は実験的です。 [[feature:16150]]

  * [[c:ObjectSpace::WeakMap]]
    * 変更されたメソッド
      * [[m:ObjectSpace::WeakMap#[]=]]がキーや値として特殊なオブジェクト(true,false,
        nil,Symbolなど)を受け付けるようになりました。 [[feature:16035]]

  * [[c:Proc]]
    * 新規メソッド
      * 通常の引数分解でキーワード引数を渡すようにprocに印をつける
        [[m:Proc#ruby2_keywords]]を追加しました。
        古いRubyと互換性のある方法で全ての引数を転送する時に使えます。 [[feature:16404]]

  * [[c:Range]]
    * 新規メソッド
      * [[m:Range#minmax]]が[[m:Enumerable#minmax]]より高速な実装として追加されました。
        最大値に[[m:Range#max]]と同じ値を返すようになりました。 [[bug:15807]]

    * 変更されたメソッド
      * [[m:Range#===]]がString引数に対しても[[m:Range#cover?]]を使うようになりました。
        (Ruby 2.6ではString以外の全ての型で[[m:Range#include?]]から変更されていました。)
        [[bug:15449]]

  * [[c:RubyVM]]
    * 削除されたメソッド
      * RubyVM.resolve_feature_pathが$LOAD_PATH.resolve_feature_pathに移動しました。
        [[feature:15903]] [[feature:15230]]

  * [[c:String]]
    * Unicode
      * Unicodeのバージョンと絵文字のバージョンが11.0.0から12.0.0に更新されました。 [[feature:15321]]
      * Unicodeのバージョンが12.1.0に更新されて
        新元号「令和」を表す合字 U+32FF SQUARE ERA NAME REIWA
        のサポートが追加されました。 [[feature:15195]]
      * Unicode絵文字のバージョンが12.1に更新されました。 [[feature:16272]]

  * [[c:Symbol]]
    * 新規メソッド
      * [[m:Symbol#start_with?]]と[[m:Symbol#end_with?]]が追加されました。 [[feature:16348]]

  * [[c:Time]]
    * 新規メソッド
      * [[m:Time#ceil]]が追加されました。 [[feature:15772]]
      * [[m:Time#floor]]が追加されました。 [[feature:15653]]
    * 変更されたメソッド
      * [[m:Time#inspect]]が[[m:Time#to_s]]から分離されて、秒未満も
        含まれるようになりました。 [[feature:15958]]

  * [[c:UnboundMethod]]
    * 新規メソッド
      * [[m:UnboundMethod#bind_call]]が追加されました。 [[feature:15955]]
      * 「umethod.bind_call(obj, ...)」は「umethod.bind(obj).call(...)」と
        同じ意味です。
        このイディオムはいくつかのライブラリでオーバーライドされたメソッドを
        呼び出すのに使われています。
        追加されたメソッドでは、中間の[[c:Method]]オブジェクトを確保することなく
        同じことができます。

#@samplecode
class Foo
  def add_1(x)
    x + 1
  end
end
class Bar < Foo
  def add_1(x) # override
    x + 2
  end
end

obj = Bar.new
p obj.add_1(1) #=> 3
p Foo.instance_method(:add_1).bind(obj).call(1) #=> 2
p Foo.instance_method(:add_1).bind_call(obj, 1) #=> 2
#@end

  * [[c:Warning]]
    * 新規メソッド
      * [[m:Warning.[] ]]と[[m:Warning.[]=]]がいくつかのカテゴリ化された
        警告を出すか止めるかを管理するために追加されました。 [[feature:16345]] [[feature:16420]]

  * [[m:$LOAD_PATH]]
    * 新規メソッド
      * $LOAD_PATH.resolve_feature_pathが追加されました。 [[feature:15903]] [[feature:15230]]

=== 標準添付ライブラリの更新 (注目すべきもののみ)

  * [[c:Bundler]]
    * Bundler 2.1.2 に更新されました。
      [[url:https://github.com/bundler/bundler/releases/tag/v2.1.2]]

  * [[c:CGI]]
    * [[m:CGI.escapeHTML]]が少なくとも1個のエスケープされた文字があるときに2~5倍速くなりました。
      [[url:https://github.com/ruby/ruby/pull/2226]]

  * [[c:CSV]]
    * 3.1.2に更新されました。
      [[url:https://github.com/ruby/csv/blob/master/NEWS.md]]

  * [[c:Date]]
    * [[m:Date.jisx0301]], [[m:Date#jisx0301]], [[m:Date.parse]]が新しい日本の年号を
      サポートしました。 [[feature:15742]]

  * [[c:Delegator]]
    * [[m:Object#DelegateClass]]がブロックを受け付けるようになり、
      Class.newやStruct.newのように返り値のクラスのコンテキストで
      module_evalするようになりました。

  * [[c:ERB]]
    * ERBのインスタンスをMarshalできないようになりました。

  * [[c:IRB]]
    * Pry gem に着想を得て、[[m:Binding#irb]]のソース表示、REPLの入力、
      いくつかのコアクラスオブジェクトのinspect出力に
      シンタックスハイライトが導入されました。
    * Relineによって提供される複数行編集モードが導入されました。
    * 補完の操作でドキュメントが表示されるようになりました。
    * オートインデントと履歴の保存と読み込みがデフォルトで有効になりました。

  * [[c:JSON]]
    * 2.3.0に更新されました。

  * [[c:Net::FTP]]
    * 利用可能な拡張機能をチェックするための[[m:Net::FTP#features]]と
      有効/無効にするための[[m:Net::FTP#option]]が追加されました。 [[feature:15964]]

  * [[c:Net::HTTP]]
    * [[m:Net::HTTP#start]]にTCP/IP接続のアドレスを置き換えるための
      オプション引数ipaddrが追加されました。 [[feature:5180]]

  * [[c:Net::IMAP]]
    * Server Name Indication (SNI) のサポートが追加されました。 [[feature:15594]]

  * [[lib:open-uri]]
    * Kernelモジュールでopen-uriのopenメソッドを使うと警告されるようになりました。
      代わりに[[m:URI.open]]を使ってください。 [[misc:15893]]
    * メディアタイプ "text/*" のデフォルトの charset が ISO-8859-1 から UTF-8 に
      なりました。 [[bug:15933]]

  * [[c:OptionParser]]
    * 不明なオプションに対して "Did you mean?" が表示されるようになりました。 [[feature:16256]]

#@samplecode test.rb
require "optparse"
OptionParser.new do |opts|
  opts.on("-f", "--foo", "foo") {|v| }
  opts.on("-b", "--bar", "bar") {|v| }
  opts.on("-c", "--baz", "baz") {|v| }
end.parse!
#@end

//emlist{
$ ruby test.rb --baa
Traceback (most recent call last):
test.rb:7:in `<main>': invalid option: --baa (OptionParser::InvalidOption)
Did you mean?  baz
               bar
//}

  * [[c:Pathname]]
    * [[m:Pathname.glob]]がbaseキーワード引数を受け付けるために
      [[m:Dir.glob]]に3引数を委譲するようになりました。 [[feature:14405]]

  * [[c:Racc]]
    * 上流のレポジトリから1.4.15がマージされ、raccコマンドが追加されました。

  * [[c:Reline]]
    * readline標準ライブラリ互換でpure Ruby実装の新しい標準ライブラリです。
      複数行編集機能も提供しています。

  * [[c:REXML]]
    * 3.2.3に更新されました。
      [[url:https://github.com/ruby/rexml/blob/master/NEWS.md]]

  * [[c:RSS]]
    * RSS 0.2.8に更新されました。
      [[url:https://github.com/ruby/rss/blob/master/NEWS.md]]

  * [[c:RubyGems]]
    * RubyGems 3.1.2に更新されました。
      * [[url:https://github.com/rubygems/rubygems/releases/tag/v3.1.0]]
      * [[url:https://github.com/rubygems/rubygems/releases/tag/v3.1.1]]
      * [[url:https://github.com/rubygems/rubygems/releases/tag/v3.1.2]]

  * [[c:StringScanner]]
    * 1.0.3に更新されました。
      [[url:https://github.com/ruby/strscan/blob/master/NEWS.md]]

=== 互換性 (機能追加とバグ修正を除く)

  * 以下のライブラリはもう bundled gem には含まれません。これらの機能を使う場合は対応する gem をインストールしてください。
      * CMath (cmath gem)
      * Scanf (scanf gem)
      * Shell (shell gem)
      * Synchronizer (sync gem)
      * ThreadsWait (thwait gem)
      * E2MM (e2mmap gem)

  * [[c:Proc]]
    * [[m:Proc#to_s]]の形式が変更されました。 [[feature:16101]]

  * [[c:Range]]
    * [[m:Range#minmax]]が最大値を決めるためにRangeをイテレートしていました。
      今は[[m:Range#max]]と同じアルゴリズムを使います。稀なケース(例えば
      FloatやStringのRange)では違う結果になるかもしれません。 [[bug:15807]]

=== 標準添付ライブラリの互換性 (機能追加とバグ修正を除く)

  * 以下のライブラリが新たにdefault gemsになりました。
    * 以下のdefault gemがrubygems.orgで公開されました。
      * benchmark
      * cgi
      * delegate
      * getoptlong
      * net-pop
      * net-smtp
      * open3
      * pstore
      * readline
      * readline-ext
      * singleton
    * 以下のdefault gemはruby-coreでの変更のみで、まだrubygems.orgでは公開されていません。
      * monitor
      * observer
      * timeout
      * tracer
      * uri
      * yaml
  * did_you_mean gemはbundled gemからdefault gemになりました。

  * [[lib:pathname]]
    * [[m:Kernel#Pathname]]を[[c:Pathname]]を引数として呼んだとき、
      新しい[[c:Pathname]]を生成するのではなく、引数をそのまま返すようになりました。
      この変更で他の[[c:Kernel]]のメソッドに近づきます。しかし返り値を変更して
      引数を変更しないことを期待するコードが壊れるかもしれません。

  * profile.rb, Profiler__
    * 標準添付ライブラリから削除されました。
      Ruby 2.0.0からメンテナンスされていませんでした。

=== C API の更新

  * 渡された最後の引数をキーワード引数として扱うかどうかを設定するための
    多数の「*_kw」関数が追加されました。
    キーワード引数分離の警告を避けて、Ruby 3での正しい振る舞いを確実にするため、
    これらの関数に切り替える必要があるかもしれません。

  * rb_scan_argsの書式文字列の「:」はキーワード引数として扱われるようになりました。
    キーワード引数の代わりに位置引数のハッシュとして渡されるとdeprecated警告が
    出ます。

  * ANYARGSを使ったC API宣言はANYARGSを使わないように変更されました。
    See [[url:https://github.com/ruby/ruby/pull/2404]]

=== 実装の改善

  * [[c:Fiber]]
    * 以前のスタックキャッシュはファイバープールキャッシュに置き換えまれました。
      ファイバープールは単一のメモリ領域に多数のスタックを確保します。
      スタックアロケーションはO(log N)になり、ファイバー生成の償却計算量はO(1)です。
      マイクロベンチマークでは約10倍のパフォーマンス改善が計測されました。
      [[url:https://github.com/ruby/ruby/pull/2224]]
    * 以下のように「--with-coroutine=」で別のコルーチン実装を選べるようになりました。

//emlist{
$ ./configure --with-coroutine=ucontext
$ ./configure --with-coroutine=copy
//}

  * [[c:File]]
    * [[m:File.realpath]]は多くのプラットフォームでrealpath(3)を使います。
      これは大幅にパフォーマンスを改善します。 [[feature:15797]]

  * [[c:Hash]]
    * 小さいHashオブジェクトのデータ構造が変わりました。 [[feature:15602]]

  * [[c:Monitor]]
    * MonitorクラスがC拡張になりました。 [[feature:16255]]

  * [[c:Thread]]
    * VMスタックのメモリ確保はネイティブスレッドのスタックと同時になり、
      スレッドアロケーションのパフォーマンスが改善され、アロケーション関連の
      失敗が減少します。
      マイクロベンチマークでは約10倍のパフォーマンス改善が計測されました。

  * JIT
    * 最適化の仮定が無効になった時に、JITされたコードは最適化が少ないコードに
      再コンパイルされます。
    * メソッドをpureだとみなした時にメソッドのインライン化が実行されます。
      この最適化はまだ実験的で、多くのメソッドはまだpureだとみなされていません。
    * 「--jit-max-cache」のデフォルト値が1,000から100になりました。
    * 「--jit-min-calls」のデフォルト値が5から10,000になりました。

  * [[c:RubyVM]]
    * 1.9から存在するコールサイトごとのメソッドキャッシュが改善されました。
      キャッシュヒット率が89%から94%に上昇しました。
      詳細は[[url:https://github.com/ruby/ruby/pull/2583]]を
      参照してください。

  * [[c:RubyVM::InstructionSequence]]
    * [[m:RubyVM::InstructionSequence#to_binary]]メソッドは
      コンパイルされたバイナリを生成します。
      そのバイナリサイズが削減されました。 [[feature:16163]]

=== その他の変更

  * IA64アーキテクチャーサポートが削除されました。
    テスト用のハードウェアを見つけることが難しく、ネイティブファイバーコードを
    実装することが難しく、インタープリターに些細ではない複雑さをもたらして
    いました。 [[feature:15894]]

  * コンパイラーにC99対応を要求するようになりました。 [[misc:15347]]
    * 使用している機能の詳細は
      [[url:https://bugs.ruby-lang.org/projects/ruby-master/wiki/C99]]
      を参照してください。

  * Rubyの上流リポジトリはSubversionからGitに変わりました。
    * [[url:https://git.ruby-lang.org/ruby.git]]
    * RUBY_REVISIONのクラスはIntegerからStringに変わりました。
    * RUBY_DESCRIPTIONはSubversionのリビジョンの代わりにGitのリビジョンが
      入るようになりました。

  * 「__builtin_」構文を使ったRubyによる組み込みメソッドを
    サポートしました。 [[feature:16254]]

  * いくつかのメソッドは(trace_point.rbのように)「*.rb」で定義されています。
    例えば、キーワード引数を受け取るメソッドの定義が簡単になります。
#@end

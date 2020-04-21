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
    This includes the usage in String#split.
    この警告は「-W:no-deprecated」オプションで止められます。

  * 「$,」にnil以外の値を設定すると警告が出るようになりました。 [[feature:14240]]
    This includes the usage in Array#join.
    この警告は「-W:no-deprecated」オプションで止められます。

  * ヒアドキュメントの識別子の引用符は同じ行で閉じる必要があります。

//emlist{
<<"EOS
" # This had been warned since 2.4; Now it raises a SyntaxError
EOS
//}

  * フリップフロップが非推奨になったのが元に戻されました。 [[feature:5400]]

  * Comment lines can be placed between fluent dot now.

#@samplecode
foo
  # .bar
  .baz # => foo.baz
#@end

  * リテラルの「self」をレシーバーとしたプライベートメソッド呼び出しが
    できるようになりました。 [[feature:11297]] [[feature:16123]]

  * Modifier rescue now operates the same for multiple assignment as single
    assignment. [[bug:8279]]

#@samplecode
a, b = raise rescue [1, 2]
# Previously parsed as: (a, b = raise) rescue [1, 2]
# Now parsed as:         a, b = (raise rescue [1, 2])
#@end

  * +yield+ in singleton class syntax will now display a warning. This behavior
    will soon be deprecated. [[feature:15575]]
    この警告は「-W:no-deprecated」オプションで止められます。

#@samplecode
def foo
  class << Object.new
    yield #=> warning: `yield' in class syntax will not be supported from Ruby 3.0. [[feature:15575]]
  end
end
foo { p :ok }
#@end

  * Argument forwarding by <code>(...)</code> is introduced. [[feature:16253]]

#@samplecode
def foo(...)
  bar(...)
end
#@end

  * All arguments to +foo+ are forwarded to +bar+, including keyword and
    block arguments.
    Note that the parentheses are mandatory.  <code>bar ...</code> is parsed
    as an endless range.

  * Access and setting of <code>$SAFE</code> will now always display a warning.
    <code>$SAFE</code> will become a normal global variable in Ruby 3.0.
    [[feature:16131]]

  * <code>Object#{taint,untaint,trust,untrust}</code> and related functions in the C-API
    no longer have an effect (all objects are always considered untainted), and will now
    display a warning in verbose mode. This warning will be disabled even in non-verbose mode in
    Ruby 3.0, and the methods and C functions will be removed in Ruby 3.2. [[feature:16131]]

  * Refinements take place at Object#method and Module#instance_method. [[feature:15373]]

=== コマンドラインオプション

==== 警告オプション

カテゴリ化された警告を管理するために「-W」オプションが「:」を続けられるように
拡張されました。 [[feature:16345]] [[feature:16420]]

  * 非推奨警告を止める:

//emlist{
$ ruby -e '$; = ""'
-e:1: warning: `$;' is deprecated

$ ruby -W:no-deprecated -e '$; = //'
//}

  * RUBYOPT環境変数でも使えます:

//emlist{
$ RUBYOPT=-W:no-deprecated ruby -e '$; = //'
//}

  * 実験的機能の警告を止める:

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

=== 組み込みクラスの更新 (outstanding ones only)

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
      * [[m:Dir.glob]]と[[m:Dir.[] ]] がNUL区切りのグロブパターンを受け付けなくなりました。
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
      * Added [[m:Enumerator.produce]] to generate an Enumerator from any custom
        data transformation.  [[feature:14781]]
      * Added [[m:Enumerator::Lazy#eager]] that generates a non-lazy enumerator
        from a lazy enumerator.  [[feature:15901]]
      * Added [[m:Enumerator::Yielder#to_proc]] so that a Yielder object
        can be directly passed to another method as a block
        argument.  [[feature:15618]]
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
      * Added [[m:Fiber#raise]] that behaves like [[m:Fiber#resume]] but raises an
        exception on the resumed fiber.  [[feature:10344]]

  * [[c:File]]
    * 変更されたメソッド
      * File.extname now returns a dot string for names ending with a dot on
        non-Windows platforms.  [[bug:15267]]

#@samplecode
File.extname("foo.") #=> "."
#@end

  * [[c:FrozenError]]
    * 新規メソッド
      * Added [[m:FrozenError#receiver]] to return the frozen object on which
        modification was attempted.  To set this object when raising
        FrozenError in Ruby code, FrozenError.new accepts a +:receiver+
        option.  [[feature:15751]]

  * [[c:GC]]
    * 新規メソッド
      * Added [[m:GC.compact]] method for compacting the heap.
        This function compacts live objects in the heap so that fewer pages may
        be used, and the heap may be more CoW (copy-on-write) friendly. [[feature:15626]]
     *  Details on the algorithm and caveats can be found here:
        [[url:https://bugs.ruby-lang.org/issues/15626]]

  * [[c:IO]]
    * 新規メソッド
      * Added [[m:IO#set_encoding_by_bom]] to check the BOM and set the external
        encoding.  [[bug:15210]]

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
      * Added [[m:Module#const_source_location]] to retrieve the location where a
        constant is defined.  [[feature:10771]]
      * Added [[m:Module#ruby2_keywords]] for marking a method as passing keyword
        arguments through a regular argument splat, useful when delegating
        all arguments to another method in a way that can be backwards
        compatible with older Ruby versions.  [[bug:16154]]
    * 変更されたメソッド
      * [[m:Module#autoload?]] now takes an +inherit+ optional argument, like
        [[m:Module#const_defined?]].  [[feature:15777]]
      * [[m:Module#name]] now always returns a frozen String. The returned String is
        always the same for a given Module. This change is
        experimental. [[feature:16150]]

  * [[c:NilClass]] / [[c:TrueClass]] / [[c:FalseClass]]
    * 変更されたメソッド
      * [[m:NilClass#to_s]], [[m:TrueClass#to_s]], [[m:FalseClass#to_s]]が
        常にfreezeされたStringを返すようになりました。
        返り値のStringは常に同じインスタンスになります。
        この変更は実験的です。 [[feature:16150]]

  * [[c:ObjectSpace::WeakMap]]
    * 変更されたメソッド
      * [[m:ObjectSpace::WeakMap#[]=]] now accepts special objects as either key or
        values.  [[feature:16035]]

  * [[c:Proc]]
    * 新規メソッド
      * Added [[m:Proc#ruby2_keywords]] for marking the proc as passing keyword
        arguments through a regular argument splat, useful when delegating
        all arguments to another method or proc in a way that can be backwards
        compatible with older Ruby versions.  [[feature:16404]]

  * [[c:Range]]
    * 新規メソッド
      * [[m:Range#minmax]]が[[m:Enumerable#minmax]]より高速な実装として追加されました。
        It returns a maximum that now corresponds to Range#max. [[bug:15807]]

    * 変更されたメソッド
      * [[m:Range#===]]がString引数に対しても[[m:Range#cover?]]を使うようになりました。
        (Ruby 2.6ではString以外の全ての型で[[m:Range#include?]]から変更されていました。)
        [[bug:15449]]

  * [[c:RubyVM]]
    * 削除されたメソッド
      * RubyVM.resolve_feature_pathが
        $LOAD_PATH.resolve_feature_pathに移動しました。
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

=== 標準添付ライブラリの更新 (outstanding ones only)

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
    * Introduce syntax highlighting inspired by the Pry gem to Binding#irb
      source lines, REPL input, and inspect output of some core-class objects.
    * Introduce multiline editing mode provided by Reline.
    * Show documentation when completion.
    * Enable auto indent and save/load history by default.

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

  * Many <code>*_kw</code> functions have been added for setting whether
    the final argument being passed should be treated as keywords. You
    may need to switch to these functions to avoid keyword argument
    separation warnings, and to ensure correct behavior in Ruby 3.

  * The <code>:</code> character in rb_scan_args format string is now
    treated as keyword arguments. Passing a positional hash instead of
    keyword arguments will emit a deprecation warning.

  * C API declarations with +ANYARGS+ are changed not to use +ANYARGS+.
    See [[url:https://github.com/ruby/ruby/pull/2404]]

=== 実装の改善

  * [[c:Fiber]]
    * Replace previous stack cache with fiber pool cache. The fiber pool
      allocates many stacks in a single memory region. Stack allocation
      becomes O(log N) and fiber creation is amortized O(1). Around 10x
      performance improvement was measured in micro-benchmarks.
      [[url:https://github.com/ruby/ruby/pull/2224]]
    * Allow selecting different coroutine implementations by using
      +--with-coroutine=+, e.g.
//emlist{
$ ./configure --with-coroutine=ucontext
$ ./configure --with-coroutine=copy
//}

  * [[c:File]]
    * File.realpath now uses realpath(3) on many platforms, which can
      significantly improve performance. [[feature:15797]]

  * [[c:Hash]]
    * Change data structure of small Hash objects. [[feature:15602]]

  * [[c:Monitor]]
    * Monitor class is written in C-extension. [[feature:16255]]

  * [[c:Thread]]
    * VM stack memory allocation is now combined with native thread stack,
      improving thread allocation performance and reducing allocation related
      failures. Around 10x performance improvement was measured in micro-benchmarks.

  * JIT
    * JIT-ed code is recompiled to less-optimized code when an optimization assumption is invalidated.
    * Method inlining is performed when a method is considered as pure.
      This optimization is still experimental and many methods are NOT considered as pure yet.
    * The default value of +--jit-max-cache+ is changed from 1,000 to 100.
    * The default value of +--jit-min-calls+ is changed from 5 to 10,000.

  * [[c:RubyVM]]
    * Per-call-site method cache, which has been there since around 1.9, was
      improved: cache hit rate raised from 89% to 94%.
      See [[url:https://github.com/ruby/ruby/pull/2583]]

  * [[c:RubyVM::InstructionSequence]]
    * RubyVM::InstructionSequence#to_binary method generates compiled binary.
      The binary size is reduced. [[feature:16163]]

=== その他の変更

  * Support for IA64 architecture has been removed. Hardware for testing was
    difficult to find, native fiber code is difficult to implement, and it added
    non-trivial complexity to the interpreter. [[feature:15894]]

  * Require compilers to support C99. [[misc:15347]]
    * Details of our dialect: [[url:https://bugs.ruby-lang.org/projects/ruby-master/wiki/C99]]

  * Ruby's upstream repository is changed from Subversion to Git.
    * [[url:https://git.ruby-lang.org/ruby.git]]
    * RUBY_REVISION class is changed from Integer to String.
    * RUBY_DESCRIPTION includes Git revision instead of Subversion's one.

  * Support built-in methods in Ruby with the <code>_\_builtin_</code> syntax. [[feature:16254]]

  * Some methods are defined in *.rb (such as trace_point.rb).
    For example, it is easy to define a method which accepts keyword arguments.
#@end

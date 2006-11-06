= class Proc < Object

Proc はブロックをコンテキスト(ローカル変数のスコープやスタックフ
レーム)とともにオブジェクト化した手続きオブジェクトです。Proc は
ローカル変数のスコープを導入しないことを除いて名前のない関数のように使
えます([[unknown:Ruby用語集/ダイナミックローカル変数]]は Proc ローカル
の変数として使えます)。

Proc がローカル変数のスコープを保持していることは以下の例で
変数 var を参照できていることからわかります。

  var = 1
  $foo = Proc.new { var }
  var = 2

  def foo
    $foo.call
  end

  p foo       # => 2

Proc を生成したメソッドからリターンしてしまった後は Proc
からの [[unknown:制御構造/return]], [[unknown:制御構造/retry]] は例外
[[c:LocalJumpError]] を発生させます。

  def foo
    proc { return }
  end

  foo.call
  # => in `call': return from proc-closure (LocalJumpError)

  def foo
    proc { retry }
  end

  foo.call
  # => in `call': retry from proc-closure (LocalJumpError)

ブロック付きメソッドに対して Proc オブジェクトを `&' を指定して渡すと
呼び出しブロックのように動作しますが、厳密には以下の違いがあります
#@#((-2002-02-20: break に関しては現在 1.6、1.7 共にこの制限はありません
#@#が、まだ流動的なようです [[unknown:ruby-bugs-ja:PR#98]],
#@#2003-03-12: [[unknown:ruby-dev:19799]]-))。

  # 問題なし
  (1..5).each { break }

  # ruby 1.6.7, 1.8 で問題なし。1.6.8 では例外
  proc = Proc.new { break }
  (1..5).each(&proc)

  # ruby 1.6 では、LocalJumpError
  # ruby 1.8 では、each 再実行
  proc = Proc.new { retry }
  (1..5).each(&proc)
  #=> retry from proc-closure (LocalJumpError)

これは、Proc オブジェクトが呼び出しブロックとして振舞う際の制限です。

== Class Methods

--- new
--- new { ... }

ブロックをコンテキストとともにオブジェクト化して返します。

ブロックを指定しなければ、このメソッドを呼び出したメソッドがブロッ
クを伴うときに、それを Proc オブジェクトとして生成して返しま
す。

  def foo
         pr = Proc.new
         pr.call(1,2,3)
      end
  foo {|args| p args }
  # => [1, 2, 3]

これは以下と同じです(厳密には引数の解釈の仕方が異なります。
[[m:Proc#yield]] を参照してください)。

  def foo
    yield(1,2,3)
  end
  foo {|args| p args }
  # => [1, 2, 3]

呼び出し元のメソッドがブロックを伴わなければ、例外
[[c:ArgumentError]] が発生します。

  def foo
    Proc.new
  end
  foo
  # => -:2:in `new': tried to create Proc object without a block (ArgumentError)
          from -:2:in `foo'
          from -:4

Proc.new は、Proc#initialize が定義されていれば
オブジェクトの初期化のためにこれを呼び出します。このことを
除けば、[[m:Kernel#proc]] と同じです。

== Instance Methods

--- [](arg ...)
--- call(arg ... )

手続きオブジェクトを実行してその結果を返します。引数はブロックの引
数にそのまま(多重代入のルールに従い)代入されます。

--- arity

Procオブジェクトの引数の数を返します。self が引数の数
を可変長で受け取れる場合

  -(最低限必要な数+1)

を返します。

--- binding

Proc オブジェクトが保持するコンテキストを [[c:Binding]] オブ
ジェクトで返します。

--- to_proc

self を返します。

--- to_s

self の文字列表現を返します。可能なら self を生成した
ソースファイル名、行番号を含みます。

  p Proc.new {
     true
  }.to_s

  => "#<Proc:0x0x401a880c@-:3>"

#@since 1.8.0
--- yield(arg ... )

[[m:Proc#call]] と同じですが、引数の数のチェックを行いません。

  pr = Proc.new {|a,b,c| p [a,b,c]}
  pr.yield(1)        #=> [1, nil, nil]
  pr.yield(1,2,3,4)  #=> [1, 2, 3]
  pr.call(1)         #=> wrong # of arguments (4 for 3) (ArgumentError)

これは [[unknown:メソッド呼び出し/yield]] と同じ動作です。

  def foo
    yield(1)
  end
  foo {|a,b,c| p [a,b,c]}
#@end

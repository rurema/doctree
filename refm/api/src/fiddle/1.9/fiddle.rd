*.dllや*.soなど、ダイナミックリンクライブラリを扱うためのライブラリです。

[[lib:dl]] と同様の機能を持ちます。dl は環境によっては正しく
動作しないという問題を解決するために導入されました。
fiddle は libffi の wrapper です。
dl ライブラリの一部機能は上記の問題を解決するため fiddle で
実装されています。

Ruby 1.9.x ではこのライブラリは単体では利用できません。
DL を経由して利用してください。
#@# 2.0 以降では DL が obsolete となり fiddle 単体で利用できるようになる




= module Fiddle
fiddle ライブラリの名前空間をなすモジュール

== Singleton Methods
--- win32_last_error -> Integer
最後に [[m:Fiddle::Function#call]] で C の関数を呼び出した
結果設定された errno を返します。

このメソッドは Windows 環境でのみ定義されています。

この値はスレッドローカルです。

--- win32_last_error=(errno)
[[m:Fiddle.win32_last_error]] で返される値を設定します。

errno は fiddle が設定するのでユーザはこのメソッドを使わないでください。

このメソッドは Windows 環境でのみ定義されています。

@param errno 設定する errno

--- last_error -> Integer
最後に [[m:Fiddle::Function#call]] で C の関数を呼び出した
結果設定された errno を返します。

この値はスレッドローカルです。

--- last_error=(errno)
[[m:Fiddle.last_error]] で返される値を設定します。

errno は fiddle が設定するのでユーザはこのメソッドを使わないでください。

@param errno 設定する errno

== Constants
--- TYPE_VOID -> Integer
C の void 型を表します。

@see [[m:Fiddle::Function.new]]

--- TYPE_VOIDP -> Integer
C の void* 型を表します。

fiddle や dl 上では、すべてのポインタは void* であると
見なされます。

@see [[m:Fiddle::Function.new]]

--- TYPE_CHAR -> Integer
C の char 型を表します。

@see [[m:Fiddle::Function.new]]

--- TYPE_SHORT -> Integer
C の short 型を表します。

@see [[m:Fiddle::Function.new]]

--- TYPE_INT -> Integer
C の int 型を表します。

@see [[m:Fiddle::Function.new]]

--- TYPE_LONG -> Integer
C の long 型を表します。

@see [[m:Fiddle::Function.new]]

--- TYPE_LONG_LONG -> Integer
C の long long 型を表します。

@see [[m:Fiddle::Function.new]]

--- TYPE_FLOAT -> Integer
C の float 型を表します。

@see [[m:Fiddle::Function.new]]

--- TYPE_DOUBLE -> Integer
C の double 型を表します。

@see [[m:Fiddle::Function.new]]

--- WINDOWS -> bool
Windows 環境下では true、それ以外では false です。

--- Pointer -> Class
[[c:DL::CPtr]] の別名です。

= class Fiddle::Function < Object
C の関数を表すクラスです。

== Class Methods
--- new(ptr, args, ret_type, abi=Fiddle::Function::DEFAULT) -> Fiddle::Function
ptr (関数ポインタを表す整数)から Fiddle::Function オブジェクトを
生成します。

ptr には [[c:DL::Handle]] から [[m:DL::Handle#ptr]] で取りだした
関数ポインタ(を表す整数)を渡します。

args、ret_type で関数の引数と返り値の型を指定します。これには以下の
定数が利用できます。「-TYPE_INT」 のように符号を反転させると unsigned を
意味します。
  * [[m:Fiddle::TYPE_VOID]]
  * [[m:Fiddle::TYPE_VOIDP]]
  * [[m:Fiddle::TYPE_CHAR]]
  * [[m:Fiddle::TYPE_SHORT]]
  * [[m:Fiddle::TYPE_INT]]
  * [[m:Fiddle::TYPE_LONG]]
  * [[m:Fiddle::TYPE_LONG_LONG]]
  * [[m:Fiddle::TYPE_FLOAT]]
  * [[m:Fiddle::TYPE_DOUBLE]]

abi で呼出規約を指定します。
  * [[m:Fiddle::Function::DEFAULT]]
  * [[m:Fiddle::Function::STDCALL]]
のどちらかを指定します。

  require 'dl'
  require 'fiddle'
  
  include Fiddle
  
  libc = DL.dlopen("/lib/libc.so.6")
  f = Fiddle::Function.new(libc["strcpy"], [TYPE_VOIDP, TYPE_VOIDP], TYPE_VOIDP)


@param ptr C の関数を指す [[c:DL::Handle]] オブジェクト
@param args 引数の型を表す配列
@param ret_type 返り値の型
@param abi 呼出規約

== Instance Methods
--- call(*args) -> Integer|DL::CPtr|nil
関数を呼び出します。

[[m:Fiddle::Function.new]] で指定した引数と返り値の型に基いて
Ruby のオブジェクトを適切に C のデータに変換して C の関数を呼び出し、
その返り値を Ruby のオブジェクトに変換して返します。

引数の変換は以下の通りです。

: void* (つまり任意のポインタ型)
  nil ならば C の NULL に変換されます
  [[c:DL::CPtr]] は保持している C ポインタに変換されます。
  適当に変換してから、C のポインタに変換します。
  文字列であればその先頭ポインタになります。
  [[c:IO]] オブジェクトであれば FILE* が渡されます。
  整数であればそれがアドレスとみなされます。
  どれでもなければ to_ptr を呼び出し DL::CPtr オブジェクトに
  変換したのが用いられます。

: (unsigned) char/short/int/long/long long
  Ruby の整数を C の整数に変換します。

: double/float
  Ruby の整数 or 浮動小数点数を C の浮動小数点数に変換します
  
返り値の変換は以下の通りです。

: void
  nil を返します

: (unsigned) char/short/int/long/long long
  C の整数を Ruby の整数に変換します

: void*(つまり任意のポインタ型)
  C のポインタを保持した [[c:DL::CPtr]] を返します。

@param args 関数の引数
@see [[m:Fiddle::Function.new]]

--- abi -> Integer
呼出規約を返します。

@see [[m:Fiddle::Function.new]]

== Constants
--- DEFAULT -> Integer
デフォルトの呼出規約を表します。

@see [[m:Fiddle::Function.new]]

--- STDCALL -> Integer
Windows の stdcall 呼出規約を表します。

@see [[m:Fiddle::Function.new]]

= class Fiddle::Closure < Object
コールバック関数を表すクラスです。

Ruby のメソッド(call)を C の関数ポインタとして表現するためのクラスです。

FFI の closure の wrapper です。

利用法としては、このクラスのサブクラスを作って
そのサブクラスに call メソッドを定義し、
new でオブジェクトを生成することで利用します。
  
  require 'fiddle'
  include Fiddle
  
  class Compare < Fiddle::Closure
    # qsort の比較関数は 型が int(*)(void*, void*) であるため、
    # このメソッドには DL::CPtr オブジェクトが渡される。
    # そのポインタが指す先は比較している文字なので、
    # DL::CPtr#to_s で1文字の文字列に変換している
    def call(x, y)
      x.to_s(1) <=> y.to_s(1)
    end
  end
  
  libc = DL.dlopen("/lib/libc.so.6")
  qs = Fiddle::Function.new(libc["qsort"],
                            [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_VOIDP],
                            TYPE_VOID)
  s = "7x0cba(Uq)"
  qs.call(s, s.size, 1, Compare.new(TYPE_INT, [TYPE_VOIDP, TYPE_VOIDP]))
  p s # =>  "()07Uabcqx"

[[m:Class.new]] を使うことで、サブクラスを明示的に作ることなしに
コールバックオブジェクトを作ることができます。
  require 'fiddle'
  include Fiddle # TYPE_* を使うために include する
  compare = Class.new(Fiddle::Closure){
    def call(x, y)
      x.to_s(1) <=> y
    end
  }.new(TYPE_INT, [TYPE_VOIDP, TYPE_VOIDP])

単に Ruby のブロックを C の(コールバック)関数に変換したい場合は
[[c:Fiddle::BlockClosure]] を使うほうが簡単です。

== Class Methods
--- new(ret, args, abi=Fiddle::Function::DEFAULT) -> Fiddle::Closure

そのクラスの call メソッドを呼びだすような
Fiddle::Closure オブジェクトを返します。

args、ret で関数の引数と返り値の型を指定します。
指定は [[m:Fiddle::Function.new]] と同様なので、そちら
を参照してください。

@param ret 返り値の型
@param args 引数の型を表す配列
@param abi 呼出規約

== Instance Methods
--- to_i -> Integer

C の関数ポインタのアドレスを返します。

--- ctype -> Integer 
返り値の型を返します。

--- args -> [Integer]
引数の型を表す配列を返します。

= class Fiddle::Closure::BlockCaller < Fiddle::Closure
Ruby のブロックをラップしたコールバック関数を表すクラスです。

Ruby のブロックを C の関数ポインタとして表現するためのクラスです。

  require 'fiddle'
  include Fiddle

  libc = DL.dlopen("/lib/libc.so.6")
  qs = Fiddle::Function.new(libc["qsort"],
                            [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_VOIDP],
                            TYPE_VOID)
  compare = Fiddle::Closure::BlockCaller.new(TYPE_INT, [TYPE_VOIDP, TYPE_VOIDP]){|x, y|
    # qsort の比較関数は 型が int(*)(void*, void*) であるため、
    # このブロックには DL::CPtr オブジェクトが渡される。
    # そのポインタが指す先は比較している文字なので、
    # DL::CPtr#to_s で1文字の文字列に変換している
    x.to_s(1) <=> y.to_s(1)
  }
  s = "7x0cba(Uq)"
  qs.call(s, s.size, 1, Compare.new(TYPE_INT, [TYPE_VOIDP, TYPE_VOIDP]))
  p s # =>  "()07Uabcqx"

== Class Methods
--- new(ret, args, abi=Fiddle::Function::DEFAULT){ ... } -> Fiddle::BlockClosure

Ruby のブロックを呼び出す Fiddle::Closure オブジェクトを返します。


args、ret で関数の引数と返り値の型を指定します。
指定は [[m:Fiddle::Function.new]] と同様なので、そちら
を参照してください。

@param ret 返り値の型
@param args 引数の型を表す配列
@param abi 呼出規約

#@# --- call
#@# スーパークラスと同じ

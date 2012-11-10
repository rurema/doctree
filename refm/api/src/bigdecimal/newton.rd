#@since 1.8.2

require bigdecimal/jacobian
require bigdecimal/ludcmp

ニュートン法を用いて非線形方程式 f(x) = 0 の解 x を求める機能を提供しま
す。

本サブライブラリは [[c:BigDecimal]] に依存しません。

実行例:

  require "bigdecimal"
  require "bigdecimal/newton"
#@until 1.9.3
  include Newton
#@end

  ...

#@since 1.9.2
  n = Newton.nsolve(f, x)
#@else
  n = nsolve(f, x)
#@end

引数 f には関数を表すオブジェクトを指定します。以下のメソッドに応答でき
る必要があります。

: f.values(x)

  全ての x に対する f(x) の値を返します。

: f.zero

  0.0 を返します。

: f.one

  1.0 を返します。

: f.two

  2.0 を返します。

: f.ten

  10.0 を返します。

: f.eps

  収束の基準になる epsilon 値を返します。2 つの値が異なる値かどうかを比
  較するのに使用されます。|a - b| < f.eps となる 2 つの値は同じ値である
  とみなされます。

引数 x には探索を開始する点を数値の配列で指定します(※指定する値によっ
て、解の収束点が変化する場合や解が求まらずに RuntimeError が発生する場
合があります)。実行後は引数 x に指定したオブジェクトに解が代入されます。

戻り値 n は計算した回数を整数で返します。

実行例の詳細については、Ruby のソースコード中の以下のパスからサンプルス
クリプトを参照してください。

 * ext/bigdecimal/sample/nlsolve.rb

= module Newton

include LUSolve
include Jacobian

ニュートン法を用いて非線形方程式 f の解 x を求める機能を提供するモジュー
ルです。

#@since 1.9.2
== Module Functions
#@else
== Instance Methods
#@end

--- norm(fv, zero = 0.0) -> Float

ノルム関数です。ライブラリ内部で使用します。

--- nlsolve(f, x) -> Integer

ニュートン法を用いて非線形方程式 f(x) = 0 の解 x を求めます。

@param f 関数を表すオブジェクトを指定します。詳細は
         [[lib:bigdecimal/newton]] をご覧ください。

@param x 探索を開始する点を数値の配列で指定します。(※指定する値によっ
         て、解の収束点が変化する場合や解が求まらずに RuntimeError が発
         生する場合があります)
         実行後は解を表す値が代入されています。

@return 計算した回数を整数で返します。

@raise RuntimeError 解が収束しない場合に発生します。

#@end

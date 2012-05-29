require dl

dl ライブラリのための高レベルインターフェースを提供するライブラリです。

通常は dl ライブラリを使わずこの dl/import ライブラリを使います。

主な使い方は [[lib:dl]] も参照してください。

=== 高度な使用法

==== ○○の配列を関数に渡したい

例えば与えられた長さ len の double の配列の和を計算する関数
  double sum(double *arry, int len);
があったとします。これを呼び出したい場合は以下のように [[m:Array#pack]] を使用します。

 require 'dl/import'
 module M
   extend DL::Importer
   dlload './libsum.so'
   extern 'double sum(double*, int)'
 end
 p M.sum([2.0, 3.0, 4.0].pack('d*'), 3)   #=> 9.0

また与えられた文字列の配列 s (長さlen)の各要素の最初の文字を buf にコピーする関数
  void first_char(char **s, char *buf, int len)
があったとします。これを呼び出すにも以下のように [[m:Array#pack]] を使用します。

 require 'dl/import'
 module M
   extend DL::Importer
   dlload './libstrfirst.so'
   extern 'void first_char(char **, char *, int)'
 end
 buf = '111'
 M.first_char(['Abc', 'Def', 'Ghi'].pack('p*'), buf, 3) 
 p buf  #=> 'ADG'

==== Ruby のオブジェクトをコールバックに渡したい

任意のクラスの Ruby オブジェクトをコールバックへ渡したい場合は [[m:DL.#dlwrap]] を使って
ポインタ(整数)へ変換してから関数に渡し、コールバックの方で元に戻します。

例えば libc の qsort を使って Ruby の Time の配列をソートするには以下のようにします。

  require 'dl/import'
  module M 
    extend DL::Importer
    dlload "libc.so.6"
    QsortCallback = bind("void *qsort_callback(void*, void*)"){|a, b|
      a0 = DL.dlunwrap(a.ptr.to_i)
      b0 = DL.dlunwrap(b.ptr.to_i)
      a0 <=> b0
    }
    extern 'void qsort(void *, int, int, void *)'
  end

  buff =  [Time.at(1), Time.now, Time.at(100), Time.at(10)]
  a = buff.map{|t| DL.dlwrap(t)}.pack('l!*')
  M.qsort(a, buff.size, DL::SIZEOF_VOIDP, M::QsortCallback)
  p a.unpack('l!*').map{|t| DL.dlunwrap(t).to_i }             #=> [1, 10, 100, 1241603848]

==== 複雑な構造体を定義したい

構造体をメンバとして持つ構造体を [[m:DL::Importer#struct]] を使って定義することは残念ながらできません。
自力でメンバを展開してから [[m:DL::Importer#struct]] を使ってください。

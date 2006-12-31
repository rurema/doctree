improt dl

= class DL::Types < Object

型の定義を保持するオブジェクトのクラス。

=== 型を定義する

  ["alias name", "type name",
   encoding_method, decoding_method,   # for function prototypes
   encoding_method, decoding_method]   # for structures (not implemented)

という形式の配列を内部に持ちます。エイリアス名と実際の型、エンコーディング、
デコーディングの方法を定義します。DL::Types::TYPES はデフォルトで持って
いる定義です。

== Instance Methods

--- typealias(alias, type, enc, dec, struct_enc, struct_dec)

型定義の追加を行う。

インスタンス変数 @TYDEFS の先頭に

  [alias, type,
   enc, dec, struct_end, struct_dec]

の組を追加する。

--- encode_type(alias)

DL モジュールで用いる型定義と Ruby のオブジェクトを
DL モジュールで用いるデータへのエンコード用 Proc オブジェクトと、
DL モジュールのデータから Ruby オブジェクトへのデコード用の
Proc オブジェクトの組を次の通りの Array として返す。

  [ty,enc,dec,senc,sdec]
  ty : DLでの型指定子
  enc : エンコード用Proc
  dec : デコード用Proc
  senc : エンコード用Proc(dl/structで使用)
  sdec : デコード用Proc(dl/structで使用)

#@if (version >= "1.8.2")
--- encode_argument_type(alias_type)

--- encode_return_type(ty)

--- encode_struct_type(alias_type)

#@end

#@if (version <= "1.8.1")
--- encode_type(ty)

#@end

--- init_types

== Constants

--- TYPES

インスタンス変数 @TYDEFS の初期値。


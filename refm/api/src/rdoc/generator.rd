
[[c:RDoc]] が解析したソースコードを [[c:RDoc::CodeObject]] のツリーから
その他の形式に出力するためのサブライブラリです。

#@since 1.9.2
[[c:RDoc]] には HTML 向けのジェネレータの
[[c:RDoc::Generator::Darkfish]] と ri 向けのジェネレータの
[[c:RDoc::Generator::RI]] が付属しています。

=== ジェネレータの登録

[[m:RDoc::RDoc.add_generator]] を呼び出す事でジェネレータの登録が行えます。

  class My::Awesome::Generator
    RDoc::RDoc.add_generator self
  end
#@end

#@since 1.9.3
=== rdoc のオプションの追加

[[lib:rdoc]] ではオプションの処理の前に [[c:RDoc::Options]] は各ジェネ
レータの #setup_options メソッドを実行します。ジェネレータは 第一引数で
渡される [[m:RDoc::Options#option_parser]] に対して rdoc コマンドのオプ
ションを追加できます。[[ref:lib:rdoc/options#custom_options]] の例と
[[c:OptionParser]] も併せて参照してください。
#@end

#@since 2.0.0
=== ジェネレータのインストール

ソースコードを解析した後は [[c:RDoc:RDoc]] オブジェクトはジェネレータの
コンストラクタの引数に [[c:RDoc::Store]] オブジェクトと
[[c:RDoc::Options]] オブジェクトを渡して初期化します。

[[c:RDoc::Store]] オブジェクトは解析したソースコードに関する情報を保持
しています。[[c:RDoc]] 3 以前は [[c:RDoc::TopLevel]] オブジェクトがこの
情報を保持しています。ジェネレータを [[c:RDoc]] 3 以前のものから更新す
る際には、[[c:RDoc::TopLevel]] を使って記述された処理を置き換える必要が
あります。

[[c:RDoc]] は出力を行う際にジェネレータの generate メソッドを呼び出しま
す。[[c:RDoc::Store]] や [[c:RDoc::CodeObject]] のツリーのメソッドを使っ
て要求される形式のフォーマットを出力してください。
#@end

= module RDoc::Generator

[[c:RDoc]] が解析したソースコードを [[c:RDoc::CodeObject]] のツリーから
その他の形式に出力するためのクラスです。

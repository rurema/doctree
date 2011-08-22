RDoc 形式のドキュメントをエスケープシーケンスで太字やアンダーラインの効
果を持たせるように見せるサブライブラリです。

#@until 1.9.3
  require 'rdoc/markup/formatter'
#@end
  require 'rdoc/markup/to_bs'

  h = RDoc::Markup::ToBs.new
  puts h.convert(input_string)

変換した結果は文字列で取得できます。実際に効果を確認するためにはページャ
などで出力を確認します。

テキスト中の以下のマークアップ記法をエスケープシーケンスの \b と組み合
わせる事によって見た目を変更します。

 * イタリック体(_word_): word にアンダーラインを付けて表示する("w\b_o\b_r\b_d\b_" に変換されます)
 * ボールド体(*word*): word を太字で表示する("w\bwo\bor\brd\bd" に変換されます)

= class RDoc::Markup::ToBs < RDoc::Markup::ToRdoc

RDoc 形式のドキュメントをエスケープシーケンスで太字やアンダーラインの効
果を持たせるように見せるクラスです。

== Class Methods

#@since 1.9.3
--- new(markup = nil) -> RDoc::Markup::ToBs
#@else
--- new -> RDoc::Markup::ToBs
#@end

自身を初期化します。

#@since 1.9.3
@param markup [[c:RDoc::Markup]] オブジェクトを指定します。省略した場合
              は新しく作成します。
#@end

RDoc 形式のドキュメントをマークアップ記法を保持したまま出力させるための
サブライブラリです。

サブクラス([[c:RDoc::Markup::ToAnsi]] など)を作成して使います。

= class RDoc::Markup::ToRdoc < RDoc::Markup::Formatter

RDoc 形式のドキュメントをマークアップ記法を保持したまま出力させるための
クラスです。

== Class Methods

#@since 1.9.3
--- new(markup = nil) -> RDoc::Markup::ToRdoc
#@else
--- new -> RDoc::Markup::ToRdoc
#@end

自身を初期化します。

#@since 1.9.3
@param markup [[c:RDoc::Markup]] オブジェクトを指定します。省略した場合
              は新しく作成します。
#@end

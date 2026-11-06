---
type: library
---
RDoc 形式のドキュメントをマークアップ記法を保持したまま出力させるためのサブライブラリです。

サブクラス([c:RDoc::Markup::ToAnsi] など)を作成して使います。

# class RDoc::Markup::ToRdoc < RDoc::Markup::Formatter

RDoc 形式のドキュメントをマークアップ記法を保持したまま出力させるためのクラスです。

## Class Methods

#%since 4.1
### def RDoc::Markup::ToRdoc.new -> RDoc::Markup::ToRdoc
#%else
### def RDoc::Markup::ToRdoc.new(markup = nil) -> RDoc::Markup::ToRdoc
#%end

自身を初期化します。

#%until 4.1
- **param** `markup` -- [c:RDoc::Markup] オブジェクトを指定します。省略した場合は新しく作成します。
#%end

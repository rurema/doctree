---
type: library
require:
  - rdoc/markup/to_html
---
RDoc 形式のドキュメントを HTML に整形するためのサブライブラリです。

[c:RDoc::Markup::ToHtml] を拡張して、ドキュメント内のメソッド名やクラス名を自動的にリンクにします。

# class RDoc::Markup::ToHtmlCrossref < RDoc::Markup::ToHtml

RDoc 形式のドキュメントを HTML に整形するクラスです。

## Class Methods

#%since 4.1
### def RDoc::Markup::ToHtmlCrossref.new(from_path, context, pipe: false, output_decoration: true, hyperlink_all: false, show_hash: false, autolink_excluded_words: [], warn_missing_rdoc_ref: true) -> RDoc::Markup::ToHtmlCrossref
#%else
### def RDoc::Markup::ToHtmlCrossref.new(options, from_path, context, markup = nil) -> RDoc::Markup::ToHtmlCrossref
#%end

自身を初期化します。

#%until 4.1
- **param** `options` -- [c:RDoc::Options] オブジェクトを指定します。`hyperlink_all` と `show_hash` の設定をここから取得します。

#%end
- **param** `from_path` -- 生成するファイルのパスを文字列で指定します。

- **param** `context` -- [c:RDoc::Context] オブジェクトかそのサブクラスのオブジェクトを指定します。

#%since 4.1
- **param** `pipe` -- true を指定すると、コードブロックに構文の強調を付けず、見出しにリンクを付けない出力にします。`rdoc --pipe` が使います。

- **param** `output_decoration` -- false を指定すると、見出しに `id` 属性を付けません。

- **param** `hyperlink_all` -- true を指定すると、`#` や `::` で始まらないメソッド名もリンクにします。

- **param** `show_hash` -- true を指定した場合、メソッド名のリンクに # を表示します。false の場合は表示しません。

- **param** `autolink_excluded_words` -- 自動でリンクにしない語を文字列の配列で指定します。

- **param** `warn_missing_rdoc_ref` -- true を指定すると、`rdoc-ref:` のリンク先が見つからないときにメッセージを出力します。

#%else
- **param** `markup` -- [c:RDoc::Markup] オブジェクトを指定します。省略した場合は新しく作成します。

#%end
- **raise** `ArgumentError` -- `from_path` に nil を指定した場合に発生します。

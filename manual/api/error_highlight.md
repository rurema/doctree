---
type: library
since: "3.1"
category: Development
---
[c:NameError] などの実行時エラーが起きたときに、エラーメッセージにエラーの該当箇所のコード抜粋と下線を追加して表示するライブラリです。

```ruby
json = {}
json[:article][:title]
#%version 3.4...
# ~> undefined method '[]' for nil (NoMethodError)
#%end
#%version 3.3
# ~> undefined method `[]' for nil (NoMethodError)
#%end
#%version ...3.3
# ~> undefined method `[]' for nil:NilClass (NoMethodError)
#%end
#
#    json[:article][:title]
#                  ^^^^^^^^
```

デフォルトで有効になっており、無効にするにはコマンドラインオプションで
--disable-error_highlight を指定します。

プログラムからは、エラーの該当箇所の位置情報を取得する `ErrorHighlight.spot` や、
表示のカスタマイズのための `ErrorHighlight.formatter` / `ErrorHighlight.formatter=`
が利用できます。

このライブラリはdefault gemです。詳しい内容は下記のページを参照してください。

- rubygems.org: <https://rubygems.org/gems/error_highlight>
- プロジェクトページ: <https://github.com/ruby/error_highlight>
- リファレンス: <https://www.rubydoc.info/gems/error_highlight>

- **SEE** [lib:did_you_mean], [ref:d:glossary#default-gem]

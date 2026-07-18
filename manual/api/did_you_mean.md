---
type: library
category: Development
---
名前のタイポによって [c:NameError] や [c:NoMethodError] が起きたと
きに、自動的に他の似た名前を提案してくれるライブラリです。

```ruby
"Yuki".starts_with?("Y")
#@if("3.4" <= version)
# ~> NoMethodError: undefined method 'starts_with?' for an instance of String
#@end
#@if("3.3" <= version and version < "3.4")
# ~> NoMethodError: undefined method `starts_with?' for an instance of String
#@end
#@if(version < "3.3")
# ~> NoMethodError: undefined method `starts_with?' for "Yuki":String
#@end
#    Did you mean?  start_with?
```

デフォルトで有効になっており、無効にするにはコマンドラインオプションで
--disable=did_you_mean を指定します。

このライブラリはbundled gem(gemファイルのみを同梱)です。詳しい内容は下
記のページを参照してください。

 - rubygems.org: <https://rubygems.org/gems/did_you_mean>
 - プロジェクトページ: <https://github.com/ruby/did_you_mean>
 - リファレンス: <https://www.rubydoc.info/gems/did_you_mean/>

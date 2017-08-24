category Development

名前のタイポによって [[c:NameError]] や [[c:NoMethodError]] が起きたと
きに、自動的に他の似た名前を提案してくれるライブラリです。

  "Yuki".starts_with?("Y")
  # => NoMethodError: undefined method `starts_with?' for "Yuki":String
  #    Did you mean?  start_with?

デフォルトで有効になっており、無効にするにはコマンドラインオプションで
--disable=did_you_mean を指定します。

このライブラリはbundled gem(gemファイルのみを同梱)です。詳しい内容は下
記のページを参照してください。

 * rubygems.org: [[url:https://rubygems.org/gems/did_you_mean]]
 * プロジェクトページ: [[url:https://github.com/yuki24/did_you_mean]]
 * リファレンス: [[url:http://www.rubydoc.info/gems/did_you_mean/]]

---
type: library
category: Development
require:
#@until 2.2.0
  - test/unit/testcase
#@end
---
ユニットテストを行うためのライブラリです。

このライブラリは 2.2.0 からbundled gem(gemファイルのみを同梱)になりまし
た。詳しい内容は下記のプロジェクトページを参照してください。

  - Test::Unit - Ruby用単体テストフレームワーク: [url:https://test-unit.github.io/]

なお、2.2.0より前のtest/unit は当時バンドルしていた minitest/unit を使って再実装し
ていましたが、上記のtest/unitと完全な互換性がある訳ではありません。

Rubyのテスティングフレームワークの歴史については以下が詳しくまとまっています。

  - Rubyのテスティングフレームワークの歴史（2014年版） [url:https://www.clear-code.com/blog/2014/11/6.html]
  - RubyKaigi 2015：The history of testing framework in Ruby [url:https://www.clear-code.com/blog/2015/12/12.html]


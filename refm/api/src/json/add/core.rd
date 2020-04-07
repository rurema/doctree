require json/add/date
require json/add/date_time
require json/add/exception
require json/add/range
require json/add/regexp
require json/add/struct
require json/add/symbol
require json/add/time

Ruby のコアクラスに JSON 形式の文字列に変換するメソッドや
JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

json/add/core サブライブラリを require すると、例えば [[c:Range]] オブ
ジェクトを JSON 形式の文字列にしたり、[[c:Range]] オブジェクトに戻す事
ができます。

#@samplecode 例
require 'json/add/core'
(1..10).to_json            # => "{\"json_class\":\"Range\",\"a\":[1,10,false]}"
JSON.load((1..10).to_json) # => 1..10
#@end

---
library: uri
---
# module URI
URI を扱うためのモジュールです。

#@#== Class Variables

#@#--- @@schemes

#@#    モジュール関数 parse によって生成可能なクラスを値とするハッシュ。
#@#    キーはスキームを大文字だけで表した文字列。
#@#    URI::Genericを継承する場合にこのハッシュにエントリを追加すると
#@#    そのクラスが URI.parse によってサポートされます。

## Singleton Methods

### def split(url)    -> [String | nil]

URI を要素に分割した文字列の配列を返します。

各要素の種類と順番は以下のとおりです。

  - scheme
  - userinfo
  - host
  - port
  - registry
  - path
  - opaque
  - query
  - fragment

- **param** `url` -- パースしたい URI を文字列として与えます。

- **raise** `URI::InvalidURIError` -- パースに失敗した場合に発生します。

```ruby title="例"
require 'uri'
p URI.split("http://www.ruby-lang.org/")
#=> ["http", nil, "www.ruby-lang.org", nil, nil, "/", nil, nil, nil]
```

### def parse(uri_str)    -> object

与えられた URI から該当する [c:URI::Generic] のサブクラスのインスタンスを生成して
返します。scheme が指定されていない場合は、[c:URI::Generic] オブジェクトを返します。

- **param** `uri_str` -- パースしたい URI を文字列として与えます。

- **raise** `URI::InvalidComponentError` -- 各要素が適合しない場合に発生します。

- **raise** `URI::InvalidURIError` -- パースに失敗した場合に発生します。

```ruby title="例"
require 'uri'
p uri = URI.parse("http://www.ruby-lang.org/")

# => #<URI::HTTP:0x201002a6 URL:http://www.ruby-lang.org/>
p uri.scheme    # => "http"
p uri.host      # => "www.ruby-lang.org"
p uri.port      # => 80
p uri.path      # => "/"
```

### def join(uri_str, *path)    -> object

文字列 uri_str と path ... を URI として連結して得られる
URI オブジェクトを返します。

[rfc:2396] の Section 5.2 の
仕様に従って連結します。
以下と等価です

```text
require 'uri'
URI.parse(uri_str) + path + ...
```

- **param** `uri_str` -- URI 文字列

- **param** `path` -- 後ろに連結する文字列

- **raise** `URI::InvalidComponentError` -- 各要素が適合しない場合に発生します。

- **raise** `URI::InvalidURIError` -- パースに失敗した場合に発生します。

```text title="例"
require 'uri'
p URI.join('http://www.ruby-lang.org/', '/ja/man-1.6/')
=> #<URI::HTTP:0x2010017a URL:http://www.ruby-lang.org/ja/man-1.6/>
```

### def extract(str)                               -> [String]
### def extract(str, schemes)                      -> [String]
### def extract(str) {|uri_str| ... }              -> nil
### def extract(str, schemes) {|uri_str| ... }     -> nil

文字列 str に対して正規表現によるマッチを試み、
絶対URIにマッチした部分文字列からなる配列として返します。
抽出する URI がなければ空の配列を返します。

第2引数に文字列の配列 schemes が与えられた場合は
そのスキームだけを検索します。

ブロックが与えられた場合は [m:String#scan] と同様で、
マッチした部分がみつかるたびに uri_str に
その部分を代入してブロックを評価します。
このときは nil を返します。

このメソッドは Ruby 2.2 から obsolete です。

- **param** `str` -- 文字列を与えます。

- **param** `schemes` -- 検索の対象としたいスキームを、文字列の配列として与えます。

```text title="例"
require 'uri'
str = "
        http://www.ruby-lang.org/
        http://www.ruby-lang.org/man-1.6/
"
p URI.extract(str, ["http"])
=> ["http://www.ruby-lang.org/", "http://www.ruby-lang.org/man-1.6/"]
```

### def regexp             -> Regexp
### def regexp(schemes)    -> Regexp

URIにマッチする正規表現を返します。

schemes を与えた場合は、そのスキームの URI にのみマッチする
正規表現を返します。

いずれの場合も返り値の正規表現は不定数の正規表現グループ
(括弧) を含みます。この括弧の数はバージョンによって変動
する可能性があるので、それに依存したコードを書くべきでは
ありません。

また、有効なURIではない文字列(たとえば"http://") にも
マッチするため、有効なURIかどうかは必要に応じて別途
検査してください。

このメソッドは Ruby 2.2 から obsolete です。

- **param** `schemes` -- マッチさせたいスキームを、文字列の配列として与えます。

```ruby title="例"
require 'uri'
p URI.regexp =~ "http://www.ruby-lang.org/"  #=> 0
```


### def decode_www_form(str, enc=Encoding::UTF_8) -> [[String, String]]

文字列から URL-encoded form data をデコードします。

application/x-www-form-urlencoded 形式のデータをデコードし、
[key, value] という形の配列の配列を返します。

enc で指定したエンコーディングの文字列が URL エンコードされたものと
みなし、エンコーディングを付加します。

このメソッドは
<https://url.spec.whatwg.org/#concept-urlencoded-parser>
にもとづいて実装されています。
そのため「&」区切りのみに対応していて、「;」区切りには対応していません。

```ruby
require 'uri'
ary = URI.decode_www_form("a=1&a=2&b=3")
p ary                 #=> [['a', '1'], ['a', '2'], ['b', '3']]
p ary.assoc('a').last #=> '1'
p ary.assoc('b').last #=> '3'
p Hash[ary]           #=> {"a"=>"2", "b"=>"3"}
```

- **param** `str` -- デコード対象の文字列
- **param** `enc` -- エンコーディング
- **raise** `ArgumentError` -- str のフォーマットが不正である場合に発生します
- **SEE** [m:URI.decode_www_form_component], [m:URI.encode_www_form]

### def decode_www_form_component(str, enc=Encoding::UTF_8) -> String
URL-encoded form data の文字列の各コンポーネント
をデコードした文字列を返します。

通常は [m:URI.decode_www_form] を使うほうがよいでしょう。

"+" という文字は空白文字にデコードします。

enc で指定したエンコーディングの文字列が URL エンコードされたものと
みなし、エンコーディングを付加します。

このメソッドは
<https://www.w3.org/TR/html5/sec-forms.html#urlencoded-form-data>
にもとづいて実装されています。

#@# コンポーネントとは "X=Y&U=V&P=Q" という URL エンコード文字列における
#@# X, Y, U, V, P, Q のこと

```ruby
require 'uri'
enc = URI.encode_www_form_component('Ruby リファレンスマニュアル')
# => "Ruby+%E3%83%AA%E3%83%95%E3%82%A1%E3%83%AC%E3%83%B3%E3%82%B9%E3%83%9E%E3%83%8B%E3%83%A5%E3%82%A2%E3%83%AB"
p URI.decode_www_form_component(enc)
# => "Ruby リファレンスマニュアル"
```

- **param** `str` -- デコード対象の文字列
- **param** `enc` -- エンコーディング
- **raise** `ArgumentError` -- str のフォーマットが不正である場合に発生します
- **SEE** [m:URI.encode_www_form_component], [m:URI.decode_www_form]

### def encode_www_form(enum, enc=nil) -> String
enum から URL-encoded form data を生成します。

HTML5 で定義されている application/x-www-form-urlencoded 形式の
文字列を生成します。

enum には通常 [key, value] という形の配列の配列を渡します。
以下の例を見てください。

```ruby
require 'uri'
URI.encode_www_form([["a", "1"], ["b", "2"], ["c", "x yz"]])
# => "a=1&b=2&c=x+yz"
```

実際には、each のブロック呼び出しで [key, value] の形のデータを渡すものであれば
何でも渡すことができます(例えば [c:Hash] など)。

```ruby
require 'uri'
URI.encode_www_form({"a"=>"1", "b"=>"2", "c"=>"x yz"})
# => "a=1&b=2&c=x+yz"
```

このメソッドは引数のエンコーディングを変換しません。そのため
送るデータのエンコーディングを変換したい場合はあらかじめ
変換しておいてください(例えば ASCII incompatible なものを
UTF-8 に変換する場合など)。
各要素のエンコーディングがばらばらの場合もあらかじめエンコーディングを
揃えてからこのメソッドを使うべきです。

このメソッドはファイルを入力にすることはできません。
ファイルを送りたい場合は multipart/form-data をつかうべきで
このメソッドを使うべきではありません。

このメソッドは内部的に
[m:URI.encode_www_form_component]
を使っています。

このメソッドは
<https://url.spec.whatwg.org/#concept-urlencoded-serializer>
にもとづいて実装されています。

- **param** `enum` -- エンコードするデータ列([key, value] という形のデータの列)
- **param** `enc` -- 指定された場合、パーセントエンコーディングする前に、このエンコーディングに変換
- **SEE** [m:URI.encode_www_form_component], [m:URI.decode_www_form]

### def encode_www_form_component(str, enc=nil) -> String
文字列を URL-encoded form data の1コンポーネント
としてエンコードした文字列を返します。

通常は [m:URI.encode_www_form] を使うほうがよいでしょう。

このメソッドでは *, -, ., 0-9, A-Z, _, a-z, は変換せず、
空白は + に変換し、その他は %XX に、変換します。

このメソッドは
<https://www.w3.org/TR/2013/CR-html5-20130806/forms.html#url-encoded-form-data>
にもとづいて実装されています。

```ruby
require 'uri'
p URI.encode_www_form_component('Ruby リファレンスマニュアル')
# => "Ruby+%E3%83%AA%E3%83%95%E3%82%A1%E3%83%AC%E3%83%B3%E3%82%B9%E3%83%9E%E3%83%8B%E3%83%A5%E3%82%A2%E3%83%AB"
```

- **param** `str` -- エンコードする文字列
- **param** `enc` -- 指定された場合、パーセントエンコーディングする前に、strをこのエンコーディングに変換
- **SEE** [m:URI.decode_www_form_component], [m:URI.encode_www_form]
## Constants

### const UNSAFE -> Regexp
URIとして指定できない文字にマッチする正規表現
```text
/[^-_.!~*'()a-zA-Z\d;\/?:@&=+$,\[\]]/n
```
です。

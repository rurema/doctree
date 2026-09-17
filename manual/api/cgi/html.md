---
type: library
until: "4.0"
---
HTML を生成するためのメソッドを提供するモジュールを定義したライブラリです。

様々な DTD に対応しています。

#%since 4.0
Ruby 4.0 から cgi ライブラリは default gems から削除されたため、このライブラリを利用するには cgi gem をインストールしてください。
詳細は [lib:cgi] を参照してください。
#%end

# module CGI::TagMaker

HTML の要素を生成するメソッドの実装を提供するモジュールです。

[c:CGI::Html3]・[c:CGI::Html4]・[c:CGI::Html4Tr]・[c:CGI::Html4Fr]・[c:CGI::Html5] の各モジュールが include し、要素名と同名のメソッド(`html`・`p`・`br` など)の実体として利用しています。通常はこのモジュールのメソッドを直接呼び出す必要はありません。

## Instance Methods

### def nn_element(element, attributes = {}) -> String
### def nn_element(element, attributes = {}) { ... } -> String
{: since="2.1.0"}

開始タグと終了タグの両方が必要な要素を生成して返します。

- **param** `element` -- 要素名を指定します。タグ名は大文字に変換されます。
- **param** `attributes` -- 属性名をキー・属性値を値とする [c:Hash] を指定します。値が `true` の属性は属性名だけを出力し、値が偽の属性は出力しません。属性名の文字列を指定すると、その属性名だけを出力します。
- **return** -- ブロックを与えた場合はその返り値を内容として開始タグと終了タグで囲んだ文字列を、与えなかった場合は開始タグと終了タグだけの文字列を返します。

```ruby title="例"
require "cgi"

cgi = CGI.new("html4")
p cgi.nn_element("div", "class" => "note") { "text" } # => "<DIV class=\"note\">text</DIV>"
p cgi.nn_element("div")                               # => "<DIV></DIV>"
```

### def nOE_element(element, attributes = {}) -> String
{: since="2.1.0"}

空要素(終了タグを持たない要素)の開始タグを生成して返します。

- **param** `element` -- 要素名を指定します。タグ名は大文字に変換されます。
- **param** `attributes` -- 属性名をキー・属性値を値とする [c:Hash] を指定します。値が `true` の属性は属性名だけを出力し、値が偽の属性は出力しません。属性名の文字列を指定すると、その属性名だけを出力します。

```ruby title="例"
require "cgi"

cgi = CGI.new("html4")
p cgi.nOE_element("input", "type" => "checkbox", "checked" => true) # => "<INPUT type=\"checkbox\" checked>"
p cgi.nOE_element("br")                                             # => "<BR>"
```

### def nO_element(element, attributes = {}) -> String
### def nO_element(element, attributes = {}) { ... } -> String
{: since="2.1.0"}

終了タグを省略できる要素を生成して返します。

- **param** `element` -- 要素名を指定します。タグ名は大文字に変換されます。
- **param** `attributes` -- 属性名をキー・属性値を値とする [c:Hash] を指定します。値が `true` の属性は属性名だけを出力し、値が偽の属性は出力しません。属性名の文字列を指定すると、その属性名だけを出力します。
- **return** -- ブロックを与えた場合はその返り値を内容として開始タグと終了タグで囲んだ文字列を、与えなかった場合は開始タグだけの文字列を返します。

```ruby title="例"
require "cgi"

cgi = CGI.new("html4")
p cgi.nO_element("p") { "text" } # => "<P>text</P>"
p cgi.nO_element("p")            # => "<P>"
```

### def nn_element_def(attributes = {}) -> String
### def nn_element_def(attributes = {}) { ... } -> String
### def nOE_element_def(attributes = {}) -> String
### def nO_element_def(attributes = {}) -> String
### def nO_element_def(attributes = {}) { ... } -> String

要素名と同名のメソッド(`html`・`br`・`p` など)の実体です。呼び出されたメソッド名を要素名として、それぞれ [m:CGI::TagMaker#nn_element]・[m:CGI::TagMaker#nOE_element]・[m:CGI::TagMaker#nO_element] を呼び出します。

- **param** `attributes` -- 属性名をキー・属性値を値とする [c:Hash] または属性名の文字列を指定します。

# module CGI::HtmlExtension

HTML を生成するためのメソッドを提供するモジュールです。

```ruby title="例"
p cgi.a("http://www.example.com") { "Example" }
  # => "<A HREF=\"http://www.example.com\">Example</A>"
```

## Instance Methods

### def a(href = "") -> String
### def a(href = ""){ ... } -> String

a 要素を生成します。

ブロックを与えると、ブロックを評価した結果が内容になります。

- **param** `href` -- 文字列を指定します。属性をハッシュで指定することもできます。
       
  ```ruby title="例"
  a("http://www.example.com") { "Example" }
    # => "<A HREF=\"http://www.example.com\">Example</A>"

  a("HREF" => "http://www.example.com", "TARGET" => "_top") { "Example" }
    # => "<A HREF=\"http://www.example.com\" TARGET=\"_top\">Example</A>"
  ```

### def base(href = "") -> String

base 要素を生成します。

- **param** `href` -- 文字列を指定します。属性をハッシュで指定することもできます。

```ruby title="例"
p base("http://www.example.com/cgi")
  # => "<BASE HREF=\"http://www.example.com/cgi\">"
```

### def blockquote(cite = nil) -> String
### def blockquote(cite = nil){ ... } -> String

blockquote 要素を生成します。

ブロックを与えると、ブロックを評価した結果が内容になります。

- **param** `cite` -- 引用元を指定します。属性をハッシュで指定することもできます。
       
  ```ruby title="例"
  blockquote("http://www.example.com/quotes/foo.html") { "Foo!" }
    # => "<BLOCKQUOTE CITE=\"http://www.example.com/quotes/foo.html\">Foo!</BLOCKQUOTE>
  ```

### def caption(align = nil) -> String
### def caption(align = nil){ ... } -> String

caption 要素を生成します。

ブロックを与えると、ブロックを評価した結果が内容になります。

- **param** `align` -- 配置を文字列で指定します。(top, bottom, left right が指定可能です)
             属性をハッシュで指定することもできます。
       
  ```ruby title="例"
  caption("left") { "Capital Cities" }
    # => <CAPTION ALIGN=\"left\">Capital Cities</CAPTION>
  ```

### def checkbox(name = "", value = nil, checked = nil) -> String

タイプが checkbox である input 要素を生成します。

- **param** `name` -- name 属性の値を指定します。

- **param** `value` -- value 属性の値を指定します。

- **param** `checked` -- checked 属性の値を指定します。

```ruby title="例"
p checkbox("name", "value", true)
# => "<INPUT CHECKED NAME=\"name\" TYPE=\"checkbox\" VALUE=\"value\">"
```

### def checkbox(attributes) -> String

タイプが checkbox である input 要素を生成します。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby title="例"
p checkbox("name" => "name", "value" => "value", "checked" => true)
# => "<INPUT checked name=\"name\" TYPE=\"checkbox\" value=\"value\">"
```

### def checkbox_group(name = "", *values) -> String

タイプが checkbox である input 要素のグループを生成します。

生成される input 要素の name 属性はすべて同じになり、それぞれの input 要素の後ろにはラベルが続きます。

- **param** `name` -- name 属性の値を指定します。

- **param** `values` -- value 属性のリストを指定します。
              それぞれの引数が、単純な文字列の場合、value 属性の値とラベルに同じものが使用されます。
              それぞれの引数が、二要素または三要素の配列の場合、最終要素が true であれば、
              checked 属性をセットします。先頭の要素は value 属性の値になります。

```ruby title="例"
checkbox_group("name", "foo", "bar", "baz")
  # <INPUT TYPE="checkbox" NAME="name" VALUE="foo">foo
  # <INPUT TYPE="checkbox" NAME="name" VALUE="bar">bar
  # <INPUT TYPE="checkbox" NAME="name" VALUE="baz">baz

checkbox_group("name", ["foo"], ["bar", true], "baz")
  # <INPUT TYPE="checkbox" NAME="name" VALUE="foo">foo
  # <INPUT TYPE="checkbox" CHECKED NAME="name" VALUE="bar">bar
  # <INPUT TYPE="checkbox" NAME="name" VALUE="baz">baz

checkbox_group("name", ["1", "Foo"], ["2", "Bar", true], "Baz")
  # <INPUT TYPE="checkbox" NAME="name" VALUE="1">Foo
  # <INPUT TYPE="checkbox" SELECTED NAME="name" VALUE="2">Bar
  # <INPUT TYPE="checkbox" NAME="name" VALUE="Baz">Baz
```

### def checkbox_group(attributes) -> String

タイプが checkbox である input 要素のグループを生成します。

生成される input 要素の name 属性はすべて同じになり、それぞれの input 要素の後ろにはラベルが続きます。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby title="例"
checkbox_group({ "NAME" => "name",
                 "VALUES" => ["foo", "bar", "baz"] })

checkbox_group({ "NAME" => "name",
                 "VALUES" => [["foo"], ["bar", true], "baz"] })

checkbox_group({ "NAME" => "name",
                 "VALUES" => [["1", "Foo"], ["2", "Bar", true], "Baz"] })
```

### def file_field(name = "", size = 20, maxlength = nil) -> String

タイプが file である input 要素を生成します。

- **param** `name` -- name 属性の値を指定します。

- **param** `size` -- size 属性の値を指定します。

- **param** `maxlength` -- maxlength 属性の値を指定します。

```ruby title="例"
file_field("name")
  # <INPUT TYPE="file" NAME="name" SIZE="20">

file_field("name", 40)
  # <INPUT TYPE="file" NAME="name" SIZE="40">

file_field("name", 40, 100)
  # <INPUT TYPE="file" NAME="name" SIZE="40" MAXLENGTH="100">
```

### def file_field(attributes) -> String

タイプが file である input 要素を生成します。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby title="例"
file_field({ "NAME" => "name", "SIZE" => 40 })
  # <INPUT TYPE="file" NAME="name" SIZE="40">
```

### def form(method = "post", action = nil, enctype = "application/x-www-form-urlencoded") -> String
### def form(method = "post", action = nil, enctype = "application/x-www-form-urlencoded"){ ... } -> String

form 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

- **param** `method` -- method 属性の値として "get" か "post" を指定します。

- **param** `action` -- action 属性の値を指定します。デフォルトは現在の CGI スクリプト名です。

- **param** `enctype` -- enctype 属性の値を指定します。デフォルトは "application/x-www-form-urlencoded" です。

```ruby title="例"
form{ "string" }
  # <FORM METHOD="post" ENCTYPE="application/x-www-form-urlencoded">string</FORM>

form("get"){ "string" }
  # <FORM METHOD="get" ENCTYPE="application/x-www-form-urlencoded">string</FORM>

form("get", "url"){ "string" }
  # <FORM METHOD="get" ACTION="url" ENCTYPE="application/x-www-form-urlencoded">string</FORM>
```

### def form(attributes) -> String
### def form(attributes){ ... } -> String

form 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby title="例"
form({"METHOD" => "post", ENCTYPE => "enctype"}){ "string" }
  # <FORM METHOD="post" ENCTYPE="enctype">string</FORM>
```

- **SEE** [m:CGI::HtmlExtension#multipart_form]

### def hidden(name = "", value = nil) -> String

タイプが hidden である input 要素を生成します。

- **param** `name` -- name 属性の値を指定します。

- **param** `value` -- value 属性の値を指定します。

```ruby title="例"
hidden("name")
  # <INPUT TYPE="hidden" NAME="name">

hidden("name", "value")
  # <INPUT TYPE="hidden" NAME="name" VALUE="value">
```

### def hidden(attributes) -> String

タイプが hidden である input 要素を生成します。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby title="例"
hidden({ "NAME" => "name", "VALUE" => "reset", "ID" => "foo" })
  # <INPUT TYPE="hidden" NAME="name" VALUE="value" ID="foo">
```

### def html(attributes = {}) -> String
### def html(attributes = {}){ ... } -> String

トップレベルの html 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

- **param** `attributes` -- 属性をハッシュで指定します。
                  擬似属性の "PRETTY" に文字列を与えるとその文字列でインデントした HTML を生成します。
                  擬似属性の "DOCTYPE" には DOCTYPE 宣言として使用する文字列を与えることができます。

```ruby title="例"
html{ "string" }
  # <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN"><HTML>string</HTML>

html({ "LANG" => "ja" }){ "string" }
  # <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN"><HTML LANG="ja">string</HTML>

html({ "DOCTYPE" => false }){ "string" }
  # <HTML>string</HTML>

html({ "DOCTYPE" => '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">' }){ "string" }
  # <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN"><HTML>string</HTML>

html({ "PRETTY" => "  " }){ "<BODY></BODY>" }
  # <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
  # <HTML>
  #   <BODY>
  #   </BODY>
  # </HTML>

html({ "PRETTY" => "\t" }){ "<BODY></BODY>" }
  # <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
  # <HTML>
  #         <BODY>
  #         </BODY>
  # </HTML>

html("PRETTY"){ "<BODY></BODY>" }
  # = html({ "PRETTY" => "  " }){ "<BODY></BODY>" }

html(if $VERBOSE then "PRETTY" end){ "HTML string" }
```

### def image_button(src = "", name = nil, alt = nil) -> String

タイプが image の input 要素を生成します。

- **param** `src` -- src 属性の値を指定します。

- **param** `name` -- name 属性の値を指定します。

- **param** `alt` -- alt 属性の値を指定します。

```ruby title="例"
image_button("url")
  # <INPUT TYPE="image" SRC="url">

image_button("url", "name", "string")
  # <INPUT TYPE="image" SRC="url" NAME="name" ALT="string">
```

### def image_button(attributes) -> String

タイプが image の input 要素を生成します。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby title="例"
image_button({ "SRC" => "url", "ALT" => "string" })
  # <INPUT TYPE="image" SRC="url" ALT="string">
```

### def img(src = "", alt = "", width = nil, height = nil) -> String

img 要素を生成します。

- **param** `src` -- src 属性の値を指定します。

- **param** `alt` -- alt 属性の値を指定します。

- **param** `width` -- width 属性の値を指定します。

- **param** `height` -- height 属性の値を指定します。

```ruby title="例"
img("src", "alt", 100, 50)
  # <IMG SRC="src" ALT="alt" WIDTH="100" HEIGHT="50">
```

### def img(attributes) -> String

img 要素を生成します。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby title="例"
img({ "SRC" => "src", "ALT" => "alt", "WIDTH" => 100, "HEIGHT" => 50 })
  # <IMG SRC="src" ALT="alt" WIDTH="100" HEIGHT="50">
```

### def multipart_form(action = nil, enctype = "multipart/form-data") -> String
### def multipart_form(action = nil, enctype = "multipart/form-data"){ ... } -> String

enctype 属性に "multipart/form-data" をセットした form 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

- **param** `action` -- action 属性の値を指定します。

- **param** `enctype` -- enctype 属性の値を指定します。

```ruby title="例"
multipart_form{ "string" }
  # <FORM METHOD="post" ENCTYPE="multipart/form-data">string</FORM>
```

### def multipart_form(attributes) -> String
### def multipart_form(attributes){ ... } -> String

enctype 属性に "multipart/form-data" をセットした form 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby title="例"
multipart_form("url"){ "string" }
  # <FORM METHOD="post" ACTION="url" ENCTYPE="multipart/form-data">string</FORM>
```

### def password_field(name = "", value = nil, size = 40, maxlength = nil) -> String

タイプが password である input 要素を生成します。

- **param** `name` -- name 属性の値を指定します。

- **param** `value` -- 属性の値を指定します。

- **param** `size` -- size 属性の値を指定します。

- **param** `maxlength` -- maxlength 属性の値を指定します。

```ruby title="例"
password_field("name")
  # <INPUT TYPE="password" NAME="name" SIZE="40">

password_field("name", "value")
  # <INPUT TYPE="password" NAME="name" VALUE="value" SIZE="40">

password_field("password", "value", 80, 200)
  # <INPUT TYPE="password" NAME="name" VALUE="value" SIZE="80" MAXLENGTH="200">
```

### def password_field(attributes) -> String

タイプが password である input 要素を生成します。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby title="例"
password_field({ "NAME" => "name", "VALUE" => "value" })
  # <INPUT TYPE="password" NAME="name" VALUE="value">
```

### def popup_menu(name = "", *values) -> String
### def scrolling_list(name = "", *values) -> String

select 要素を生成します。

- **param** `name` -- name 属性の値を指定します。

- **param** `values` -- option 要素を生成するための情報を一つ以上指定します。
              それぞれ、文字列、一要素、二要素、三要素の配列を指定できます。
              文字列か一要素の配列である場合は、value 属性の値と option 要素の内容になります。
              三要素の配列である場合は、順に value 属性の値、option 要素の内容、その option 要素が選択状態かどうかを表す真偽値となります。
       
        例：
        popup_menu("name", "foo", "bar", "baz")
          # <SELECT NAME="name">
          #   <OPTION VALUE="foo">foo</OPTION>
          #   <OPTION VALUE="bar">bar</OPTION>
          #   <OPTION VALUE="baz">baz</OPTION>
          # </SELECT>

```ruby
popup_menu("name", ["foo"], ["bar", true], "baz")
  # <SELECT NAME="name">
  #   <OPTION VALUE="foo">foo</OPTION>
  #   <OPTION VALUE="bar" SELECTED>bar</OPTION>
  #   <OPTION VALUE="baz">baz</OPTION>
  # </SELECT>

popup_menu("name", ["1", "Foo"], ["2", "Bar", true], "Baz")
  # <SELECT NAME="name">
  #   <OPTION VALUE="1">Foo</OPTION>
  #   <OPTION SELECTED VALUE="2">Bar</OPTION>
  #   <OPTION VALUE="Baz">Baz</OPTION>
  # </SELECT>
```

### def popup_menu(attributes) -> String
### def scrolling_list(attributes) -> String

select 要素を生成します。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby title="例"
popup_menu({"NAME" => "name", "SIZE" => 2, "MULTIPLE" => true,
            "VALUES" => [["1", "Foo"], ["2", "Bar", true], "Baz"] })
  # <SELECT NAME="name" MULTIPLE SIZE="2">
  #   <OPTION VALUE="1">Foo</OPTION>
  #   <OPTION SELECTED VALUE="2">Bar</OPTION>
  #   <OPTION VALUE="Baz">Baz</OPTION>
  # </SELECT>
```

### def radio_button(name = "", value = nil, checked = nil) -> String

タイプが radio である input 要素を生成します。

- **param** `name` -- name 属性の値を指定します。

- **param** `value` -- value 属性の値を指定します。

- **param** `checked` -- 真ならば checked 属性を設定します。

```ruby title="例"
radio_button("name", "value")
  # <INPUT TYPE="radio" NAME="name" VALUE="value">
 
radio_button("name", "value", true)
  # <INPUT TYPE="radio" NAME="name" VALUE="value" CHECKED>
```

### def radio_button(attributes) -> String

タイプが radio である input 要素を生成します。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby title="例"
radio_button({ "NAME" => "name", "VALUE" => "value", "ID" => "foo" })
  # <INPUT TYPE="radio" NAME="name" VALUE="value" ID="foo">
```

### def radio_group(name = "", *values) -> String

タイプが radio である input 要素のリストを生成します。

生成される input 要素の name 属性はすべて同じになり、それぞれの input 要素の後ろにはラベルが続きます。

- **param** `name` -- name 属性の値を指定します。

- **param** `values` -- value 属性のリストを指定します。
              それぞれの引数が、単純な文字列の場合、value 属性の値とラベルに同じものが使用されます。
              それぞれの引数が、二要素または三要素の配列の場合、最終要素が true であれば、
              checked 属性をセットします。先頭の要素は value 属性の値になります。

```ruby title="例"
radio_group("name", "foo", "bar", "baz")
  # <INPUT TYPE="radio" NAME="name" VALUE="foo">foo
  # <INPUT TYPE="radio" NAME="name" VALUE="bar">bar
  # <INPUT TYPE="radio" NAME="name" VALUE="baz">baz
  
radio_group("name", ["foo"], ["bar", true], "baz")
  # <INPUT TYPE="radio" NAME="name" VALUE="foo">foo
  # <INPUT TYPE="radio" CHECKED NAME="name" VALUE="bar">bar
  # <INPUT TYPE="radio" NAME="name" VALUE="baz">baz
  
radio_group("name", ["1", "Foo"], ["2", "Bar", true], "Baz")
  # <INPUT TYPE="radio" NAME="name" VALUE="1">Foo
  # <INPUT TYPE="radio" CHECKED NAME="name" VALUE="2">Bar
  # <INPUT TYPE="radio" NAME="name" VALUE="Baz">Baz
```
  
### def radio_group(attributes) -> String

タイプが radio である input 要素のリストを生成します。

生成される input 要素の name 属性はすべて同じになり、それぞれの input 要素の後ろにはラベルが続きます。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby title="例"
radio_group({ "NAME" => "name",
              "VALUES" => ["foo", "bar", "baz"] })
  
radio_group({ "NAME" => "name",
              "VALUES" => [["foo"], ["bar", true], "baz"] })
  
radio_group({ "NAME" => "name",
              "VALUES" => [["1", "Foo"], ["2", "Bar", true], "Baz"] })
```

### def reset(value = nil, name = nil) -> String

タイプが reset である input 要素を生成します。

- **param** `value` -- value 属性の値を指定します。

- **param** `name` -- name 属性の値を指定します。

```ruby title="例"
reset
  # <INPUT TYPE="reset">
  
reset("reset")
  # <INPUT TYPE="reset" VALUE="reset">
```
  
### def reset(attributes) -> String

タイプが reset である input 要素を生成します。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby
reset({ "VALUE" => "reset", "ID" => "foo" })
  # <INPUT TYPE="reset" VALUE="reset" ID="foo">
```

### def submit(value = nil, name = nil) -> String

タイプが submit である input 要素を生成します。

- **param** `value` -- value 属性の値を指定します。

- **param** `name` -- name 属性の値を指定します。

```ruby title="例"
submit
  # <INPUT TYPE="submit">
  
submit("ok")
  # <INPUT TYPE="submit" VALUE="ok">
  
submit("ok", "button1")
  # <INPUT TYPE="submit" VALUE="ok" NAME="button1">
```
  
### def submit(attributes) -> String

タイプが submit である input 要素を生成します。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby title="例"
submit({ "VALUE" => "ok", "NAME" => "button1", "ID" => "foo" })
  # <INPUT TYPE="submit" VALUE="ok" NAME="button1" ID="foo">
```

### def text_field(name = "", value = nil, size = 40, maxlength = nil) -> String

タイプが text である input 要素を生成します。

- **param** `name` -- name 属性の値を指定します。

- **param** `value` -- 属性の値を指定します。

- **param** `size` -- size 属性の値を指定します。

- **param** `maxlength` -- maxlength 属性の値を指定します。

```ruby title="例"
text_field("name")
  # <INPUT TYPE="text" NAME="name" SIZE="40">
  
text_field("name", "value")
  # <INPUT TYPE="text" NAME="name" VALUE="value" SIZE="40">
  
text_field("name", "value", 80)
  # <INPUT TYPE="text" NAME="name" VALUE="value" SIZE="80">
  
text_field("name", "value", 80, 200)
  # <INPUT TYPE="text" NAME="name" VALUE="value" SIZE="80" MAXLENGTH="200">
```
  
### def text_field(attributes) -> String

タイプが text である input 要素を生成します。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby
text_field({ "NAME" => "name", "VALUE" => "value" })
  # <INPUT TYPE="text" NAME="name" VALUE="value">
```

### def textarea(name = "", cols = 70, rows = 10) -> String

textarea 要素を生成します。

- **param** `name` -- name 属性の値を指定します。

- **param** `cols` -- cols 属性の値を指定します。

- **param** `rows` -- rows 属性の値を指定します。

```ruby title="例"
textarea("name")
  # = textarea({ "NAME" => "name", "COLS" => 70, "ROWS" => 10 })
```

### def textarea(attributes) -> String

textarea 要素を生成します。

- **param** `attributes` -- 属性をハッシュで指定します。

```ruby title="例"
textarea("name", 40, 5)
  # = textarea({ "NAME" => "name", "COLS" => 40, "ROWS" => 5 })
```

# module CGI::Html3

HTML 3.2 の要素を生成するメソッドを提供するモジュールです。

[c:CGI::TagMaker] を include し、以下の要素名を小文字にした名前のメソッド(`html`・`head`・`body`・`p` など)を定義しています。
要素ごとのメソッドはすべて同じ形で、属性を [c:Hash](属性名をキー・属性値を値とするハッシュ)または属性名の文字列で受け取り、ブロックを与えるとその返り値を要素の内容として開始タグと終了タグで囲みます。要素ごとの個別のエントリはこのリファレンスでは扱いません。

| 種類 | 要素名(メソッド名) |
|------|---------------------|
| 開始タグと終了タグの両方が必要な要素(`nn_element`) | `a`・`tt`・`i`・`b`・`u`・`strike`・`big`・`small`・`sub`・`sup`・`em`・`strong`・`dfn`・`code`・`samp`・`kbd`・`var`・`cite`・`font`・`address`・`div`・`center`・`map`・`applet`・`pre`・`xmp`・`listing`・`dl`・`ol`・`ul`・`dir`・`menu`・`select`・`table`・`title`・`style`・`script`・`h1`・`h2`・`h3`・`h4`・`h5`・`h6`・`textarea`・`form`・`blockquote`・`caption` |
| 空要素(終了タグを持たない要素)(`nOE_element`) | `img`・`base`・`basefont`・`br`・`area`・`link`・`param`・`hr`・`input`・`isindex`・`meta` |
| 終了タグを省略できる要素(`nO_element`) | `html`・`head`・`body`・`p`・`plaintext`・`dt`・`dd`・`li`・`option`・`tr`・`th`・`td` |

```ruby title="例"
require "cgi"

cgi = CGI.new("html3")
p cgi.p("class" => "note") { "text" } # => "<P class=\"note\">text</P>"
p cgi.br                             # => "<BR>"
```

## Instance Methods

### def doctype -> String

HTML 3.2 の DOCTYPE 宣言を返します。

```ruby title="例"
require "cgi"

cgi = CGI.new("html3")
p cgi.doctype
# => "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2 Final//EN\">"
```

# module CGI::Html4

HTML 4.01 Strict の要素を生成するメソッドを提供するモジュールです。

[c:CGI::TagMaker] を include し、以下の要素名を小文字にした名前のメソッド(`html`・`head`・`body`・`p` など)を定義しています。
要素ごとのメソッドはすべて同じ形で、属性を [c:Hash](属性名をキー・属性値を値とするハッシュ)または属性名の文字列で受け取り、ブロックを与えるとその返り値を要素の内容として開始タグと終了タグで囲みます。要素ごとの個別のエントリはこのリファレンスでは扱いません。

| 種類 | 要素名(メソッド名) |
|------|---------------------|
| 開始タグと終了タグの両方が必要な要素(`nn_element`) | `tt`・`i`・`b`・`big`・`small`・`em`・`strong`・`dfn`・`code`・`samp`・`kbd`・`var`・`cite`・`abbr`・`acronym`・`sub`・`sup`・`span`・`bdo`・`address`・`div`・`map`・`object`・`h1`・`h2`・`h3`・`h4`・`h5`・`h6`・`pre`・`q`・`ins`・`del`・`dl`・`ol`・`ul`・`label`・`select`・`optgroup`・`fieldset`・`legend`・`button`・`table`・`title`・`style`・`script`・`noscript`・`textarea`・`form`・`a`・`blockquote`・`caption` |
| 空要素(終了タグを持たない要素)(`nOE_element`) | `img`・`base`・`br`・`area`・`link`・`param`・`hr`・`input`・`col`・`meta` |
| 終了タグを省略できる要素(`nO_element`) | `html`・`body`・`p`・`dt`・`dd`・`li`・`option`・`thead`・`tfoot`・`tbody`・`colgroup`・`tr`・`th`・`td`・`head` |

```ruby title="例"
require "cgi"

cgi = CGI.new("html4")
p cgi.p("class" => "note") { "text" } # => "<P class=\"note\">text</P>"
p cgi.br                             # => "<BR>"
```

## Instance Methods

### def doctype -> String

HTML 4.01 Strict の DOCTYPE 宣言を返します。

```ruby title="例"
require "cgi"

cgi = CGI.new("html4")
p cgi.doctype
# => "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">"
```

# module CGI::Html4Tr

HTML 4.01 Transitional の要素を生成するメソッドを提供するモジュールです。

[c:CGI::TagMaker] を include し、以下の要素名を小文字にした名前のメソッド(`html`・`head`・`body`・`p` など)を定義しています。
要素ごとのメソッドはすべて同じ形で、属性を [c:Hash](属性名をキー・属性値を値とするハッシュ)または属性名の文字列で受け取り、ブロックを与えるとその返り値を要素の内容として開始タグと終了タグで囲みます。要素ごとの個別のエントリはこのリファレンスでは扱いません。

| 種類 | 要素名(メソッド名) |
|------|---------------------|
| 開始タグと終了タグの両方が必要な要素(`nn_element`) | `tt`・`i`・`b`・`u`・`s`・`strike`・`big`・`small`・`em`・`strong`・`dfn`・`code`・`samp`・`kbd`・`var`・`cite`・`abbr`・`acronym`・`font`・`sub`・`sup`・`span`・`bdo`・`address`・`div`・`center`・`map`・`object`・`applet`・`h1`・`h2`・`h3`・`h4`・`h5`・`h6`・`pre`・`q`・`ins`・`del`・`dl`・`ol`・`ul`・`dir`・`menu`・`label`・`select`・`optgroup`・`fieldset`・`legend`・`button`・`table`・`iframe`・`noframes`・`title`・`style`・`script`・`noscript`・`textarea`・`form`・`a`・`blockquote`・`caption` |
| 空要素(終了タグを持たない要素)(`nOE_element`) | `img`・`base`・`basefont`・`br`・`area`・`link`・`param`・`hr`・`input`・`col`・`isindex`・`meta` |
| 終了タグを省略できる要素(`nO_element`) | `html`・`body`・`p`・`dt`・`dd`・`li`・`option`・`thead`・`tfoot`・`tbody`・`colgroup`・`tr`・`th`・`td`・`head` |

```ruby title="例"
require "cgi"

cgi = CGI.new("html4Tr")
p cgi.p("class" => "note") { "text" } # => "<P class=\"note\">text</P>"
p cgi.br                             # => "<BR>"
```

## Instance Methods

### def doctype -> String

HTML 4.01 Transitional の DOCTYPE 宣言を返します。

```ruby title="例"
require "cgi"

cgi = CGI.new("html4Tr")
p cgi.doctype
# => "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">"
```

# module CGI::Html4Fr

HTML 4.01 Frameset の要素を生成するメソッドを提供するモジュールです。

[c:CGI::TagMaker] を include し、以下の要素名を小文字にした名前のメソッド(`frameset`・`frame`)を定義しています。フレームセット以外の要素は [c:CGI::Html4Tr] と組み合わせて使います(`CGI.new("html4Fr")` で得られるオブジェクトは両方を include しています)。
要素ごとのメソッドはすべて同じ形で、属性を [c:Hash](属性名をキー・属性値を値とするハッシュ)または属性名の文字列で受け取り、ブロックを与えるとその返り値を要素の内容として開始タグと終了タグで囲みます。要素ごとの個別のエントリはこのリファレンスでは扱いません。

| 種類 | 要素名(メソッド名) |
|------|---------------------|
| 開始タグと終了タグの両方が必要な要素(`nn_element`) | `frameset` |
| 空要素(終了タグを持たない要素)(`nOE_element`) | `frame` |

```ruby title="例"
require "cgi"

cgi = CGI.new("html4Fr")
p cgi.frameset("cols" => "50%,50%") { cgi.frame("src" => "a.html") + cgi.frame("src" => "b.html") }
# => "<FRAMESET cols=\"50%,50%\"><FRAME src=\"a.html\"><FRAME src=\"b.html\"></FRAMESET>"
```

## Instance Methods

### def doctype -> String

HTML 4.01 Frameset の DOCTYPE 宣言を返します。

```ruby title="例"
require "cgi"

cgi = CGI.new("html4Fr")
p cgi.doctype
# => "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Frameset//EN\" \"http://www.w3.org/TR/html4/frameset.dtd\">"
```

# module CGI::Html5

HTML5 の要素を生成するメソッドを提供するモジュールです。

[c:CGI::TagMaker] を include し、以下の要素名を小文字にした名前のメソッド(`html`・`head`・`body`・`p` など)を定義しています。
要素ごとのメソッドはすべて同じ形で、属性を [c:Hash](属性名をキー・属性値を値とするハッシュ)または属性名の文字列で受け取り、ブロックを与えるとその返り値を要素の内容として開始タグと終了タグで囲みます。要素ごとの個別のエントリはこのリファレンスでは扱いません。

| 種類 | 要素名(メソッド名) |
|------|---------------------|
| 開始タグと終了タグの両方が必要な要素(`nn_element`) | `section`・`nav`・`article`・`aside`・`hgroup`・`header`・`footer`・`figure`・`figcaption`・`s`・`time`・`u`・`mark`・`ruby`・`bdi`・`iframe`・`video`・`audio`・`canvas`・`datalist`・`output`・`progress`・`meter`・`details`・`summary`・`menu`・`dialog`・`i`・`b`・`small`・`em`・`strong`・`dfn`・`code`・`samp`・`kbd`・`var`・`cite`・`abbr`・`sub`・`sup`・`span`・`bdo`・`address`・`div`・`map`・`object`・`h1`・`h2`・`h3`・`h4`・`h5`・`h6`・`pre`・`q`・`ins`・`del`・`dl`・`ol`・`ul`・`label`・`select`・`fieldset`・`legend`・`button`・`table`・`title`・`style`・`script`・`noscript`・`textarea`・`form`・`a`・`blockquote`・`caption` |
| 空要素(終了タグを持たない要素)(`nOE_element`) | `img`・`base`・`br`・`area`・`link`・`param`・`hr`・`input`・`col`・`meta`・`command`・`embed`・`keygen`・`source`・`track`・`wbr` |
| 終了タグを省略できる要素(`nO_element`) | `html`・`head`・`body`・`p`・`dt`・`dd`・`li`・`option`・`thead`・`tfoot`・`tbody`・`optgroup`・`colgroup`・`rt`・`rp`・`tr`・`th`・`td` |

```ruby title="例"
require "cgi"

cgi = CGI.new("html5")
p cgi.p("class" => "note") { "text" } # => "<P class=\"note\">text</P>"
p cgi.br                             # => "<BR>"
```

## Instance Methods

### def doctype -> String
{: since="2.0.0"}

HTML5 の DOCTYPE 宣言を返します。

```ruby title="例"
require "cgi"

cgi = CGI.new("html5")
p cgi.doctype
# => "<!DOCTYPE HTML>"
```

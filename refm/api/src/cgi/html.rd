#@since 1.9.1
HTML を生成するためのメソッドを提供するモジュールを定義したライブラリです。

様々な DTD に対応しています。
#@end
= module CGI::TagMaker
#@#nodoc

== Instance Methods

--- nn_element_def(element)
#@todo

--- nOE_element_def(element, append = nil)
#@todo

--- nO_element_def(element)
#@todo

= module CGI::HtmlExtension

HTML を生成するためのメソッドを提供するモジュールです。

例:
   cgi.a("http://www.example.com") { "Example" }
     # => "<A HREF=\"http://www.example.com\">Example</A>"

== Instance Methods

--- a(href = "") -> String
--- a(href = ""){ ... } -> String

a 要素を生成します。

ブロックを与えると、ブロックを評価した結果が内容になります。

@param href 文字列を指定します。属性をハッシュで指定することもできます。
       
例:
  a("http://www.example.com") { "Example" }
    # => "<A HREF=\"http://www.example.com\">Example</A>"

  a("HREF" => "http://www.example.com", "TARGET" => "_top") { "Example" }
    # => "<A HREF=\"http://www.example.com\" TARGET=\"_top\">Example</A>"

--- base(href = "") -> String

base 要素を生成します。

@param href 文字列を指定します。属性をハッシュで指定することもできます。

例:
  base("http://www.example.com/cgi")
    # => "<BASE HREF=\"http://www.example.com/cgi\">"

--- blockquote(cite = nil) -> String
--- blockquote(cite = nil){ ... } -> String

blockquote 要素を生成します。

ブロックを与えると、ブロックを評価した結果が内容になります。

@param cite 引用元を指定します。属性をハッシュで指定することもできます。
       
例:
  blockquote("http://www.example.com/quotes/foo.html") { "Foo!" }
    #=> "<BLOCKQUOTE CITE=\"http://www.example.com/quotes/foo.html\">Foo!</BLOCKQUOTE>

--- caption(align = nil) -> String
--- caption(align = nil){ ... } -> String

caption 要素を生成します。

ブロックを与えると、ブロックを評価した結果が内容になります。

@param align 配置を文字列で指定します。(top, bottom, left right が指定可能です)
             属性をハッシュで指定することもできます。
       
例:
  caption("left") { "Capital Cities" }
    # => <CAPTION ALIGN=\"left\">Capital Cities</CAPTION>

--- checkbox(name = "", value = nil, checked = nil) -> String

タイプが checkbox である input 要素を生成します。

@param name name 属性の値を指定します。

@param value value 属性の値を指定します。

@param checked checked 属性の値を指定します。

例:
  checkbox("name", "value", true)
  # => "<INPUT CHECKED NAME=\"name\" TYPE=\"checkbox\" VALUE=\"value\">"

--- checkbox(attributes) -> String

タイプが checkbox である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
  checkbox("name" => "name", "value" => "value", "checked" => true)
  # => "<INPUT checked name=\"name\" TYPE=\"checkbox\" value=\"value\">"

--- checkbox_group(name = "", *values) -> String

タイプが checkbox である input 要素のグループを生成します。

生成される input 要素の name 属性はすべて同じになり、
それぞれの input 要素の後ろにはラベルが続きます。

@param name name 属性の値を指定します。

@param values value 属性のリストを指定します。
              それぞれの引数が、単純な文字列の場合、value 属性の値とラベルに同じものが使用されます。
              それぞれの引数が、二要素または三要素の配列の場合、最終要素が true であれば、
              checked 属性をセットします。先頭の要素は value 属性の値になります。

例:
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

--- checkbox_group(attributes) -> String

タイプが checkbox である input 要素のグループを生成します。

生成される input 要素の name 属性はすべて同じになり、
それぞれの input 要素の後ろにはラベルが続きます。

@param attributes 属性をハッシュで指定します。

例:
  checkbox_group({ "NAME" => "name",
                   "VALUES" => ["foo", "bar", "baz"] })

  checkbox_group({ "NAME" => "name",
                   "VALUES" => [["foo"], ["bar", true], "baz"] })

  checkbox_group({ "NAME" => "name",
                   "VALUES" => [["1", "Foo"], ["2", "Bar", true], "Baz"] })

--- file_field(name = "", size = 20, maxlength = nil) -> String

タイプが file である input 要素を生成します。

@param name name 属性の値を指定します。

@param size size 属性の値を指定します。

@param maxlength maxlength 属性の値を指定します。

例:
   file_field("name")
     # <INPUT TYPE="file" NAME="name" SIZE="20">

   file_field("name", 40)
     # <INPUT TYPE="file" NAME="name" SIZE="40">

   file_field("name", 40, 100)
     # <INPUT TYPE="file" NAME="name" SIZE="40" MAXLENGTH="100">

--- file_field(attributes) -> String

タイプが file である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
   file_field({ "NAME" => "name", "SIZE" => 40 })
     # <INPUT TYPE="file" NAME="name" SIZE="40">


--- form(method = "post", action = nil, enctype = "application/x-www-form-urlencoded") -> String
--- form(method = "post", action = nil, enctype = "application/x-www-form-urlencoded"){ ... } -> String

form 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

@param method method 属性の値として "get" か "post" を指定します。

@param action action 属性の値を指定します。デフォルトは現在の CGI スクリプト名です。

@param enctype enctype 属性の値を指定します。デフォルトは "application/x-www-form-urlencoded" です。

例:
  form{ "string" }
    # <FORM METHOD="post" ENCTYPE="application/x-www-form-urlencoded">string</FORM>

  form("get"){ "string" }
    # <FORM METHOD="get" ENCTYPE="application/x-www-form-urlencoded">string</FORM>

  form("get", "url"){ "string" }
    # <FORM METHOD="get" ACTION="url" ENCTYPE="application/x-www-form-urlencoded">string</FORM>


--- form(attributes) -> String
--- form(attributes){ ... } -> String

form 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

@param attributes 属性をハッシュで指定します。

例:
  form({"METHOD" => "post", ENCTYPE => "enctype"}){ "string" }
    # <FORM METHOD="post" ENCTYPE="enctype">string</FORM>

@see [[m:CGI::HtmlExtension#multipart_form]]

--- hidden(name = "", value = nil) -> String
タイプが hidden である input 要素を生成します。

@param name name 属性の値を指定します。

@param value value 属性の値を指定します。

例:
  hidden("name")
    # <INPUT TYPE="hidden" NAME="name">

  hidden("name", "value")
    # <INPUT TYPE="hidden" NAME="name" VALUE="value">

--- hidden(attributes) -> String
タイプが hidden である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
  hidden({ "NAME" => "name", "VALUE" => "reset", "ID" => "foo" })
    # <INPUT TYPE="hidden" NAME="name" VALUE="value" ID="foo">

--- html(attributes = {}) -> String
--- html(attributes = {}){ ... } -> String
トップレベルの html 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

@param attributes 属性をハッシュで指定します。
                  擬似属性の "PRETTY" に文字列を与えるとその文字列でインデントした HTML を生成します。
                  擬似属性の "DOCTYPE" には DOCTYPE 宣言として使用する文字列を与えることができます。

例:

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

--- image_button(src = "", name = nil, alt = nil) -> String
タイプが image の input 要素を生成します。

@param src src 属性の値を指定します。

@param name name 属性の値を指定します。

@param alt alt 属性の値を指定します。

例:
  image_button("url")
    # <INPUT TYPE="image" SRC="url">

  image_button("url", "name", "string")
    # <INPUT TYPE="image" SRC="url" NAME="name" ALT="string">

--- image_button(attributes) -> String
タイプが image の input 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
  image_button({ "SRC" => "url", "ALT" => "string" })
    # <INPUT TYPE="image" SRC="url" ALT="string">

--- img(src = "", alt = "", width = nil, height = nil) -> String
img 要素を生成します。

@param src src 属性の値を指定します。

@param alt alt 属性の値を指定します。

@param width width 属性の値を指定します。

@param height height 属性の値を指定します。

例:
  img("src", "alt", 100, 50)
    # <IMG SRC="src" ALT="alt" WIDTH="100" HEIGHT="50">

--- img(attributes) -> String
img 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
  img({ "SRC" => "src", "ALT" => "alt", "WIDTH" => 100, "HEIGHT" => 50 })
    # <IMG SRC="src" ALT="alt" WIDTH="100" HEIGHT="50">

--- multipart_form(action = nil, enctype = "multipart/form-data") -> String
--- multipart_form(action = nil, enctype = "multipart/form-data"){ ... } -> String

enctype 属性に "multipart/form-data" をセットした form 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

@param action action 属性の値を指定します。

@param enctype enctype 属性の値を指定します。

例:
  multipart_form{ "string" }
    # <FORM METHOD="post" ENCTYPE="multipart/form-data">string</FORM>

--- multipart_form(attributes) -> String
--- multipart_form(attributes){ ... } -> String

enctype 属性に "multipart/form-data" をセットした form 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

@param attributes 属性をハッシュで指定します。

例:
  multipart_form("url"){ "string" }
    # <FORM METHOD="post" ACTION="url" ENCTYPE="multipart/form-data">string</FORM>

--- password_field(name = "", value = nil, size = 40, maxlength = nil) -> String
タイプが password である input 要素を生成します。

@param name name 属性の値を指定します。

@param value 属性の値を指定します。

@param size size 属性の値を指定します。

@param maxlength maxlength 属性の値を指定します。

例:
  password_field("name")
    # <INPUT TYPE="password" NAME="name" SIZE="40">

  password_field("name", "value")
    # <INPUT TYPE="password" NAME="name" VALUE="value" SIZE="40">

  password_field("password", "value", 80, 200)
    # <INPUT TYPE="password" NAME="name" VALUE="value" SIZE="80" MAXLENGTH="200">

--- password_field(attributes) -> String
タイプが password である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
  password_field({ "NAME" => "name", "VALUE" => "value" })
    # <INPUT TYPE="password" NAME="name" VALUE="value">

--- popup_menu(name = "", *values) -> String
--- scrolling_list(name = "", *values) -> String

select 要素を生成します。

@param name name 属性の値を指定します。

@param values option 要素を生成するための情報を一つ以上指定します。
              それぞれ、文字列、一要素、二要素、三要素の配列を指定することができます。
              文字列か一要素の配列である場合は、value 属性の値と option 要素の内容になります。
              三要素の配列である場合は、順に value 属性の値、option 要素の内容、その option 要素が
              選択状態かどうかを表す真偽値となります。
       
        例：
        popup_menu("name", "foo", "bar", "baz")
          # <SELECT NAME="name">
          #   <OPTION VALUE="foo">foo</OPTION>
          #   <OPTION VALUE="bar">bar</OPTION>
          #   <OPTION VALUE="baz">baz</OPTION>
          # </SELECT>

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

--- popup_menu(attributes) -> String
--- scrolling_list(attributes) -> String

select 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
        popup_menu({"NAME" => "name", "SIZE" => 2, "MULTIPLE" => true,
                    "VALUES" => [["1", "Foo"], ["2", "Bar", true], "Baz"] })
          # <SELECT NAME="name" MULTIPLE SIZE="2">
          #   <OPTION VALUE="1">Foo</OPTION>
          #   <OPTION SELECTED VALUE="2">Bar</OPTION>
          #   <OPTION VALUE="Baz">Baz</OPTION>
          # </SELECT>

--- radio_button(name = "", value = nil, checked = nil) -> String

タイプが radio である input 要素を生成します。

@param name name 属性の値を指定します。

@param value value 属性の値を指定します。

@param checked 真ならば checked 属性を設定します。

例:
  radio_button("name", "value")
    # <INPUT TYPE="radio" NAME="name" VALUE="value">
 
  radio_button("name", "value", true)
    # <INPUT TYPE="radio" NAME="name" VALUE="value" CHECKED>

--- radio_button(attributes) -> String

タイプが radio である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
  radio_button({ "NAME" => "name", "VALUE" => "value", "ID" => "foo" })
    # <INPUT TYPE="radio" NAME="name" VALUE="value" ID="foo">

--- radio_group(name = "", *values) -> String
タイプが radio である input 要素のリストを生成します。

生成される input 要素の name 属性はすべて同じになり、
それぞれの input 要素の後ろにはラベルが続きます。

@param name name 属性の値を指定します。

@param values value 属性のリストを指定します。
              それぞれの引数が、単純な文字列の場合、value 属性の値とラベルに同じものが使用されます。
              それぞれの引数が、二要素または三要素の配列の場合、最終要素が true であれば、
              checked 属性をセットします。先頭の要素は value 属性の値になります。

例:
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
  
--- radio_group(attributes) -> String
タイプが radio である input 要素のリストを生成します。

生成される input 要素の name 属性はすべて同じになり、
それぞれの input 要素の後ろにはラベルが続きます。

@param attributes 属性をハッシュで指定します。

例:
  radio_group({ "NAME" => "name",
                "VALUES" => ["foo", "bar", "baz"] })
  
  radio_group({ "NAME" => "name",
                "VALUES" => [["foo"], ["bar", true], "baz"] })
  
  radio_group({ "NAME" => "name",
                "VALUES" => [["1", "Foo"], ["2", "Bar", true], "Baz"] })

--- reset(value = nil, name = nil) -> String
タイプが reset である input 要素を生成します。

@param value value 属性の値を指定します。

@param name name 属性の値を指定します。

例:
  reset
    # <INPUT TYPE="reset">
  
  reset("reset")
    # <INPUT TYPE="reset" VALUE="reset">
  
--- reset(attributes) -> String
タイプが reset である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

  reset({ "VALUE" => "reset", "ID" => "foo" })
    # <INPUT TYPE="reset" VALUE="reset" ID="foo">

--- submit(value = nil, name = nil) -> String
タイプが submit である input 要素を生成します。

@param value value 属性の値を指定します。

@param name name 属性の値を指定します。

例:
  submit
    # <INPUT TYPE="submit">
  
  submit("ok")
    # <INPUT TYPE="submit" VALUE="ok">
  
  submit("ok", "button1")
    # <INPUT TYPE="submit" VALUE="ok" NAME="button1">
  
--- submit(attributes) -> String
タイプが submit である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
  submit({ "VALUE" => "ok", "NAME" => "button1", "ID" => "foo" })
    # <INPUT TYPE="submit" VALUE="ok" NAME="button1" ID="foo">

--- text_field(name = "", value = nil, size = 40, maxlength = nil) -> String
タイプが text である input 要素を生成します。

@param name name 属性の値を指定します。

@param value 属性の値を指定します。

@param size size 属性の値を指定します。

@param maxlength maxlength 属性の値を指定します。

例:
  text_field("name")
    # <INPUT TYPE="text" NAME="name" SIZE="40">
  
  text_field("name", "value")
    # <INPUT TYPE="text" NAME="name" VALUE="value" SIZE="40">
  
  text_field("name", "value", 80)
    # <INPUT TYPE="text" NAME="name" VALUE="value" SIZE="80">
  
  text_field("name", "value", 80, 200)
    # <INPUT TYPE="text" NAME="name" VALUE="value" SIZE="80" MAXLENGTH="200">
  
--- text_field(attributes) -> String
タイプが text である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

  text_field({ "NAME" => "name", "VALUE" => "value" })
    # <INPUT TYPE="text" NAME="name" VALUE="value">

--- textarea(name = "", cols = 70, rows = 10) -> String
textarea 要素を生成します。

@param name name 属性の値を指定します。

@param cols cols 属性の値を指定します。

@param rows rows 属性の値を指定します。

例:
   textarea("name")
     # = textarea({ "NAME" => "name", "COLS" => 70, "ROWS" => 10 })

--- textarea(attributes) -> String
textarea 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
   textarea("name", 40, 5)
     # = textarea({ "NAME" => "name", "COLS" => 40, "ROWS" => 5 })

= module CGI::Html3
#@# nodoc

== Instance Methods

--- doctype
#@todo

--- element_init
#@todo

= module CGI::Html4
#@# nodoc

== Instance Methods

--- doctype
#@todo

--- element_init
#@todo

= module CGI::Html4Fr
#@# nodoc

== Instance Methods

--- doctype
#@todo

--- element_init
#@todo

= module CGI::Html4Tr
#@# nodoc

== Instance Methods

--- doctype
#@todo

--- element_init
#@todo

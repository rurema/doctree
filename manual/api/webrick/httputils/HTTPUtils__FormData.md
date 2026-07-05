---
library: webrick/httputils
---
# class WEBrick::HTTPUtils::FormData < String

クライアントがフォームへ入力した値を表すクラスです。multipart/form-data なデータを表すのにも
使われます。

[m:WEBrick::HTTPRequest#query] はリクエストのクエリーあるいは
クライアントがフォームへ入力した値を保持した Hash を返しますが、
その Hash のキーと値のうち値は FormData クラスのインスタンスになります。
同じ名前のフィールドが複数ある場合、[m:WEBrick::HTTPUtils::FormData#list] や
[m:WEBrick::HTTPUtils::FormData#each_data] によりそれぞれの値を取り出すことができます。

通常のフォームデータ(application/x-www-form-urlencoded)は unescape されています。
ただし multipart/form-data なフォームデータはユーザが content-transfer-encoding 
ヘッダを見て適切に処理する必要があります。

### リンク

 - [rfc:1867] Form-based File Upload in HTML.
 - [rfc:2388] multipart/form-data の説明。

## Class Methods

### def new(*args)   -> WEBrick::HTTPUtils::FormData

WEBrick::HTTPUtils の内部で使われます。ユーザがこのメソッドを直接呼ぶことはありません。

## Instance Methods

### def name          -> String | nil
### def name=(value)

フォームデータの name 属性を文字列で表すアクセサです。

- **param** `value` -- フォームデータの name 属性を文字列で指定します。

例:

````
require "webrick/cgi"
class MyCGI < WEBrick::CGI
  def do_GET(req, res)
    p req.query['q'].name   #=> "q"
  end
end
MyCGI.new.start()
````

### def filename         -> String | nil
### def filename=(value)

フォームデータの filename 属性を文字列で表すアクセサです。

- **param** `value` -- フォームデータの filename 属性を文字列で指定します。

例:

````
require "webrick/cgi"
class MyCGI < WEBrick::CGI
  def do_GET(req, res)
    p req.query['q'].filename   #=> "my_file.txt"
  end
end
MyCGI.new.start()
````

### def [](header)    -> String | nil

自身が multipart/form-data なデータの場合に、header で指定された 
ヘッダの値を文字列で返します。無ければ nil を返します。

- **param** `header` -- ヘッダ名を文字列で指定します。大文字と小文字を区別しません。

例:

````
require "webrick/cgi"
class MyCGI < WEBrick::CGI
  def do_GET(req, res)
    p req.query['q']['content-type']   #=> "plain/text"
  end
end
MyCGI.new.start()
````

### def <<(str)    -> self

WEBrick::HTTPUtils の内部で使われます。ユーザがこのメソッドを直接呼ぶことはありません。

### def append_data(data)   -> self

WEBrick::HTTPUtils の内部で使われます。ユーザがこのメソッドを直接呼ぶことはありません。

### def each_data{|s| ... }

自身が表す各フォームデータを引数として、与えられたブロックを実行します。

例:

````
require "webrick/cgi"
class MyCGI < WEBrick::CGI
  def do_GET(req, res)
    req.query['q'].each_data{|s|
      p s
    }
    #=> "val1"
        "val2"
        "val3"
  end
end
MyCGI.new.start()
````
  
### def list      -> Array
### def to_ary    -> Array

自身が表す各フォームデータを収納した配列を生成して返します。

例:

````
require "webrick/cgi"
class MyCGI < WEBrick::CGI
  def do_GET(req, res)
    p req.query['q'].list    #=> ["val1", "val2", "val3"]
  end
end
MyCGI.new.start()
````

### def to_s      -> String

自身が表すフォームデータのうちのひとつを文字列として返します。

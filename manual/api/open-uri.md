---
type: library
category: Network
---
#@# = open-uri

http/ftp に簡単にアクセスするためのクラスです。

### 使用例

http/ftp の URL を、普通のファイルのように開けます。

```ruby
require 'open-uri'
URI.open("http://www.ruby-lang.org/") {|f|
  f.each_line {|line| p line}
}
```

開いたファイルオブジェクトは [c:StringIO] もしくは [c:Tempfile] で
すが [c:OpenURI::Meta] モジュールで拡張されていて、メタ情報を獲得する
メソッドが使えます。

```ruby
require 'open-uri'
URI.open("http://www.ruby-lang.org/en") {|f|
  f.each_line {|line| p line}
  p f.base_uri         # <URI::HTTP:0x40e6ef2 URL:http://www.ruby-lang.org/en/>
  p f.content_type     # "text/html"
  p f.charset          # "iso-8859-1"
  p f.content_encoding # []
  p f.last_modified    # Thu Dec 05 02:45:02 UTC 2002
}
```

ハッシュ引数で、追加のヘッダフィールドを指定できます。

```ruby
require 'open-uri'
URI.open("http://www.ruby-lang.org/en/",
  "User-Agent" => "Ruby/#{RUBY_VERSION}",
  "From" => "foo@bar.invalid",
  "Referer" => "http://www.ruby-lang.org/") {|f|
  # ...
}
```

http_proxy, ftp_proxy, no_proxy などの環境変数は、デフォルトで有効になっています。
プロキシを無効にするには :proxy => nil とします。

```ruby
require 'open-uri'
URI.open("http://www.ruby-lang.org/en/",
  :proxy => nil) {|f|
  # ...
}
```

また、open-uri を読み込むと [c:URI::HTTP] と [c:URI::FTP] が
[c:OpenURI::OpenRead] モジュールをインクルードします。ですので、
URI オブジェクトも似たような方法で開けます。

```ruby
require 'open-uri'
uri = URI.parse("http://www.ruby-lang.org/en/")
uri.open {|f|
  # ...
}
```

URI オブジェクトは直接読み込むことができます。
戻り値の文字列は、[c:OpenURI::Meta] で拡張されています。

```ruby
str = uri.read
p str.base_uri
```


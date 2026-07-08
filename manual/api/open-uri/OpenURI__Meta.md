---
library: open-uri
---
# module OpenURI::Meta
サーバから取得したデータの属性を扱うために使われるモジュールです。
データを表す文字列や [c:StringIO] が extend します。

## Instance Methods

### def last_modified    -> Time | nil

対象となる URI の最終更新時刻を [c:Time] オブジェクトで返します。
Last-Modified ヘッダがない場合は nil を返します。

例:
```ruby title="例"
#@since 2.7.0
require 'open-uri'
URI.open('http://www.rubyist.net/') {|f|
  p f.last_modified
  #=> Thu Feb 26 16:54:58 +0900 2004
}
#@else
require 'open-uri'
open('http://www.rubyist.net/') {|f|
  p f.last_modified
  #=> Thu Feb 26 16:54:58 +0900 2004
}
#@end
```

### def content_type    -> String

対象となるリソースの Content-Type を文字列で返します。Content-Type ヘッダの情報が使われます。
Content-Type ヘッダがない場合は、"application/octet-stream" を返します。

```ruby title="例"
#@since 2.7.0
require 'open-uri'
URI.open('http://www.ruby-lang.org/') {|f|
  p f.content_type  #=> "text/html"
}
#@else
require 'open-uri'
open('http://www.ruby-lang.org/') {|f|
  p f.content_type  #=> "text/html"
}
#@end
```

### def charset       -> String | nil
### def charset{ ... }  -> String

対象となるリソースの文字コードを文字列で返します。Content-Type ヘッダの文字コード情報が使われます。
文字列は小文字へと変換されています。

Content-Type ヘッダがない場合は、nil を返します。ただし、ブロックが与えられている場合は、
その結果を返します。また対象となる URI のスキームが HTTP であり、自身のタイプが text である場合は、
[RFC:2616] 3.7.1 で定められているとおり、文字列 "iso-8859-1" を返します。

```ruby title="例"
#@since 2.7.0
require 'open-uri'
URI.open("http://www.ruby-lang.org/en") {|f|
  p f.content_type  # => "text/html"
  p f.charset       # => "iso-8859-1"
}
#@else
require 'open-uri'
open("http://www.ruby-lang.org/en") {|f|
  p f.content_type  # => "text/html"
  p f.charset       # => "iso-8859-1"
}
#@end
```

### def content_encoding    -> [String]

対象となるリソースの Content-Encoding を文字列の配列として返します。
Content-Encoding ヘッダがない場合は、空の配列を返します。

例:

```ruby title="例"
#@since 2.7.0
require 'open-uri'
URI.open('http://example.com/f.tar.gz') {|f|
  p f.content_encoding  #=> ["x-gzip"]
}
#@else
require 'open-uri'
open('http://example.com/f.tar.gz') {|f|
  p f.content_encoding  #=> ["x-gzip"]
}
#@end
```

### def status    -> [String]

対象となるリソースのステータスコードと reason phrase を文字列の配列として返します。

```ruby title="例"
#@since 2.7.0
require 'open-uri'
URI.open('http://example.com/') {|f|
  p f.status  #=> ["200", "OK"]
}
#@else
require 'open-uri'
open('http://example.com/') {|f|
  p f.status  #=> ["200", "OK"]
}
#@end
```

### def base_uri    -> URI

リソースの実際の URI を URI オブジェクトとして返します。
リダイレクトされた場合は、リダイレクトされた後のデータが存在する URI を返します。

```ruby title="例"
#@since 2.7.0
require 'open-uri'
URI.open('http://www.ruby-lang.org/') {|f|
  p f.base_uri
  #=> #<URI::HTTP:0xb7043aa0 URL:http://www.ruby-lang.org/en/>
}
#@else
require 'open-uri'
open('http://www.ruby-lang.org/') {|f|
  p f.base_uri
  #=> #<URI::HTTP:0xb7043aa0 URL:http://www.ruby-lang.org/en/>
}
#@end
```

### def meta    -> Hash

ヘッダを収録したハッシュを返します。

```ruby title="例"
#@since 2.7.0
require 'open-uri'
URI.open('http://example.com/') {|f|
  p f.meta
  #=> {"date"=>"Sun, 04 May 2008 11:26:40 GMT",
  #    "content-type"=>"text/html;charset=utf-8",
  #    "server"=>"Apache/2.0.54 (Debian GNU/Linux) mod_ssl/2.0.54 OpenSSL/0.9.7e",
  #    "transfer-encoding"=>"chunked"}
}
#@else
require 'open-uri'
open('http://example.com/') {|f|
  p f.meta
  #=> {"date"=>"Sun, 04 May 2008 11:26:40 GMT",
  #    "content-type"=>"text/html;charset=utf-8",
  #    "server"=>"Apache/2.0.54 (Debian GNU/Linux) mod_ssl/2.0.54 OpenSSL/0.9.7e",
  #    "transfer-encoding"=>"chunked"}
}
#@end
```


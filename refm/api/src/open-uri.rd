#@# = open-uri

http/ftp に簡単にアクセスするためのクラスです。
Kernel のモジュール関数(組み込み関数) open を再定義します。

=== 使用例

http/ftp の URL を、普通のファイルのように開けます。

  require 'open-uri'
  open("http://www.ruby-lang.org/") {|f|
    f.each_line {|line| p line}
  }

開いたファイルオブジェクトは StringIO もしくは Tempfile ですが [[c:OpenURI::Meta]] モジュールで拡張されていて、
メタ情報を獲得するメソッドが使えます。
  open("http://www.ruby-lang.org/en") {|f|
    f.each_line {|line| p line}
    p f.base_uri         # <URI::HTTP:0x40e6ef2 URL:http://www.ruby-lang.org/en/>
    p f.content_type     # "text/html"
    p f.charset          # "iso-8859-1"
    p f.content_encoding # []
    p f.last_modified    # Thu Dec 05 02:45:02 UTC 2002
  }
ハッシュ引数で、追加のヘッダフィールドを指定できます。
  open("http://www.ruby-lang.org/en/",
    "User-Agent" => "Ruby/#{RUBY_VERSION}",
    "From" => "foo@bar.invalid",
    "Referer" => "http://www.ruby-lang.org/") {|f|
    ...
  }
http_proxy や ftp_proxy などの環境変数は、デフォルトで有効になっています。
プロキシを無効にするには :proxy => nil とします。
  open("http://www.ruby-lang.org/en/raa.html",
    :proxy => nil) {|f|
    ...
  }

また、open-uri を読み込むと [[c:URI::HTTP]] と [[c:URI::FTP]] が
[[c:OpenURI::OpenRead]] モジュールをインクルードします。ですので、
URI オブジェクトも似たような方法で開けます。
  uri = URI.parse("http://www.ruby-lang.org/en/")
  uri.open {|f|
    ...
  }
URI オブジェクトは直接読み込むことができます。
戻り値の文字列は、[[c:OpenURI::Meta]] で拡張されています。
  str = uri.read
  p str.base_uri

= redefine Kernel

== Module Functions

--- open(name, *rest)
--- open(name, *rest) {|ouri| ...}

'open-uri' を require すると、Kernel.open が再定義されます。

name が http:// や ftp:// で始まっている文字列なら URI のリソースを
取得した上で [[c:StringIO]] オブジェクトとして返します。この [[c:StringIO]]
オブジェクトは [[c:OpenURI::Meta]] モジュールで拡張されています。
*rest で受け付けるオプションに関しては、
[[m:OpenURI.open_uri]] を参照して下さい。

name に open メソッドが定義されている場合は、*rest を引数として渡し
name.open(*rest, &block) のように name の open メソッドが呼ばれます。
これ以外の場合は、name はファイル名として扱われ、従来の
[[m:Kernel#open]] が呼ばれます。

  require 'open-uri'
  sio = open('http://www.example.com')
  p sio.is_a?(OpenURI::Meta) # => true
  p sio.content_type
  puts sio.read

ブロックを与えた場合は上の場合と同様、name が http:// や ftp:// で
始まっている文字列なら URI のリソースを取得した上で [[c:StringIO]] オブジェクトを
引数としてブロックを評価します。後は同様です。

= reopen URI::HTTP

#@# [[c:OpenURI::OpenRead]] モジュール をインクルードします。

= reopen URI::FTP

#@# [[c:OpenURI::OpenRead]] モジュール をインクルードします。

= module OpenURI

== Singleton Methods

--- open_uri(name [, mode [, perm]] [, options])
--- open_uri(name [, mode [, perm]] [, options]) {|sio| ... }

URI である文字列 name のリソースを取得して [[c:StringIO]] オブジェクト
として返します。 与えられた mode が書き込みモードであった場合は、例外
ArgumentError を投げます。 perm は与えても無視されます。

  require 'open-uri'
  sio = OpenURI.open_uri('http://www.example.com')
  puts sio.read
  
  OpenURI.open_uri('http://www.example.com'){|sio| sio.read }

ブロックを与えた場合は [[c:StringIO]] オブジェクトを引数としてブロックを
評価します。

options には [[c:Hash]] を与えます。解釈するハッシュの
キーは :proxy, :progress_proc, :content_length_proc です。HTTP でのみ意味があります。

キー :proxy の値には以下のいずれかを与えます。

  * 文字列  => "http://proxy.foo.com:8000/" のようなプロクシの URI。
  * URI オブジェクト => URI.parse("http://proxy.foo.com:8000/") のような
    プロクシの URI オブジェクト。
  * true => Proxy を環境変数などから見つけようとする。
  * false => Proxy を用いない。
  * nil => Proxy を用いない。

  require 'open-uri'
  sio = OpenURI.open_uri('http://www.example.com',
                         { :proxy => 'http://proxy.example.com:8000/' })

キー :content_length_proc の値にはブロックを与えます。ブロックは対象となる URI の
Content-Length を引数として実際の転送が始まる前に評価されます。返り値は特に
利用されません。

キー :progress_proc の値にはブロックを与えます。ブロックは対象となる URI からデータの
断片が転送されるたびに、その断片のサイズを引数として評価されます。返り値は特に
利用されません。

上の2つ :content_length_proc と :progress_proc はプログレスバーのために
利用されることを想定しています。

== Constants

--- Options

[[c:Hash]] オブジェクト。open_uri が解釈するオプションのデフォルトです。

= module OpenURI::OpenRead 

== Instance Methods

--- open(*rest, &block)

OpenURI.open_uri(self, *rest, &block) と同じです。

--- read(options={})

self.open(options={}).read と同じです。
このメソッドによって返される文字列は [[c:OpenURI::Meta]]
によって拡張されています。

  require 'open-uri'
  uri = URI.parse('http://www.example.com/')
  str = uri.read
  p str.is_a?(OpenURI::Meta) # => true
  p str.content_type

= module OpenURI::Meta

== Instance Methods

--- last_modified

対象となる URI の最終更新時刻を [[c:Time]] オブジェクトで返します。

--- content_type

対象となる URI の Content-Type を文字列で返します。

--- charset

対象となる URI の文字コードを Content-Type の文字コード情報を文字列で返します。

  open("http://www.ruby-lang.org/en") {|f|
    p f.content_type  # => "text/html"
    p f.charset       # => "iso-8859-1"
  }

--- content_encoding

対象となる URI の Content-Encoding を文字列の配列として返します。

--- status

対象となる URI のステータスコードと reason phrase を文字列の配列として返します。

--- base_uri

リダイレクトされた後のデータが存在する URI を URI オブジェクトとして返します。

--- meta

ヘッダを収録したハッシュを返します。


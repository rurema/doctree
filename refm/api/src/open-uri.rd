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

--- open(name, *rest)                -> StringIO | File
--- open(name, *rest) {|ouri| ...}   -> nil
#@todo

name が http:// や ftp:// で始まっている文字列なら URI のリソースを
取得した上で [[c:StringIO]] オブジェクトとして返します。

name に open メソッドが定義されている場合は、*rest を引数として渡し
name.open(*rest, &block) のように name の open メソッドが呼ばれます。

これ以外の場合は、name はファイル名として扱われ、従来の
[[m:Kernel#open]](name, *rest) が呼ばれます。

  require 'open-uri'
  sio = open('http://www.example.com')
  p sio.is_a?(OpenURI::Meta) # => true
  p sio.content_type
  puts sio.read

ブロックを与えた場合は上の場合と同様、name が http:// や ftp:// で
始まっている文字列なら URI のリソースを取得した上で [[c:StringIO]] オブジェクトを
引数としてブロックを評価します。後は同様です。

@param name オープンしたいリソースを文字列で与えます。

@param rest [[m:OpenURI.open_uri]] を参照して下さい。

@return 返り値である StringIO オブジェクトは [[c:OpenURI::Meta]] モジュールで extend されています。

@raise OpenURI::HTTPError 対象となる URI のスキームが http であり、かつリソースの取得に失敗した時に発生します。

@raise Net::FTPError 対象となる URI のスキームが ftp であり、かつリソースの取得に失敗した時に [[c:Net::FTPError]] のサブクラスが発生します。詳しくは [[lib:net/ftp]] を参照して下さい。

= reopen URI::HTTP
include OpenURI::OpenRead

= reopen URI::FTP
include OpenURI::OpenRead

= module OpenURI
http/ftp に簡単にアクセスするためのモジュールです。

== Singleton Methods

--- open_uri(name, mode = 'r', perm = nil, options = {})                  -> StringIO
--- open_uri(name, mode = 'r', perm = nil, options = {}) {|sio| ... }     -> nil
#@todo

URI である文字列 name のリソースを取得して [[c:StringIO]] オブジェクト
として返します。

ブロックを与えた場合は [[c:StringIO]] オブジェクトを引数としてブロックを
評価します。ブロックの終了時に StringIO は close されます。nil を返します。

  require 'open-uri'
  sio = OpenURI.open_uri('http://www.example.com')
  p sio.last_modified 
  puts sio.read
  
  OpenURI.open_uri('http://www.example.com'){|sio| sio.read }

options には [[c:Hash]] を与えます。理解するハッシュの
キーは以下の4つのシンボル、
 * :proxy
 * :progress_proc
 * :content_length_proc
 * :http_basic_authentication 
です。HTTP でのみ意味があります。
「:content_length_proc」と「:progress_proc」はプログレスバーに
利用されることを想定しています。

  require 'open-uri'
  sio = OpenURI.open_uri('http://www.example.com',
                         { :proxy => 'http://proxy.example.com:8000/',
                           :http_basic_authentication => [usrname, password] })

: :proxy
 値には以下のいずれかを与えます。
//emlist{
   * 文字列  => "http://proxy.foo.com:8000/" のようなプロクシの URI。
   * URI オブジェクト => URI.parse("http://proxy.foo.com:8000/") のような
     プロクシの URI オブジェクト。
   * true => Proxy を環境変数などから見つけようとする。
   * false => Proxy を用いない。
   * nil => Proxy を用いない。
//}

: :http_basic_authentication


: :content_length_proc
 値にはブロックを与えます。ブロックは対象となる URI の
 Content-Length ヘッダの値を引数として、実際の転送が始まる前に評価されます。Redirect された場合は、
 実際に転送されるリソースの HTTP ヘッダを利用します。Content-Length ヘッダがない場合は、nil を
 引数としてブロックを評価します。ブロックの返り値は特に利用されません。
 
: :progress_proc
 値にはブロックを与えます。ブロックは対象となる URI からデータの
 断片が転送されるたびに、その断片のサイズを引数として評価されます。ブロックの返り値は特に
 利用されません。

@param name オープンしたいリソースを文字列で与えます。

@param mode モードを文字列で与えます。

@param perm 無視されます。

@return 返り値である StringIO オブジェクトは [[c:OpenURI::Meta]] モジュールで extend されています。

@raise OpenURI::HTTPError 対象となる URI のスキームが http であり、かつリソースの取得に失敗した時に発生します。

@raise Net::FTPError 対象となる URI のスキームが ftp であり、かつリソースの取得に失敗した時に [[c:Net::FTPError]] のサブクラスが発生します。詳しくは [[lib:net/ftp]] を参照して下さい。

@raise ArgumentError 与えられた mode が読み込みモードでなかった場合に発生します。

= module OpenURI::OpenRead 
[[c:URI::HTTP]] と [[c:URI::FTP]] を拡張するために用意されたモジュールです。

== Instance Methods

--- open(*rest)                 -> StringIO
--- open(*rest){|sio| ... }     -> nil
#@todo

[[m:OpenURI.open_uri]](self, *rest, &block) と同じです。

@return 返り値である StringIO オブジェクトは [[c:OpenURI::Meta]] モジュールで extend されています。

@raise OpenURI::HTTPError 対象となる URI のスキームが http であり、かつリソースの取得に失敗した時に発生します。

@raise Net::FTPError 対象となる URI のスキームが ftp であり、かつリソースの取得に失敗した時に [[c:Net::FTPError]] のサブクラスが発生します。詳しくは [[lib:net/ftp]] を参照して下さい。

--- read(options={})     -> String
#@todo

self.open(options={}).read と同じです。
このメソッドによって返される文字列は [[c:OpenURI::Meta]]
によって extend されています。

  require 'open-uri'
  uri = URI.parse('http://www.example.com/')
  str = uri.read
  p str.is_a?(OpenURI::Meta) # => true
  p str.content_type

= module OpenURI::Meta
サーバから取得したデータの属性を扱うために使われるモジュールです。
データを表す文字列や [[c:StringIO]] が extend します。

== Instance Methods

--- last_modified    -> Time | nil
#@todo

対象となる URI の最終更新時刻を [[c:Time]] オブジェクトで返します。
Last-Modified ヘッダがない場合は nil を返します。

--- content_type    -> String
#@todo

対象となるリソースの Content-Type を文字列の配列で返します。Content-Type ヘッダの情報が使われます。
Content-Type ヘッダがない場合は、"application/octet-stream" を返します。

--- charset       -> String | nil
--- charset{...}  -> String
#@todo

対象となるリソースの文字コードを文字列で返します。Content-Type ヘッダの文字コード情報が使われます。
文字列は小文字へと変換されています。

Content-Type ヘッダがない場合は、nil を返します。ただし、ブロックが与えられている場合は、
その結果を返します。また対象となる URI のスキームが HTTP であり、自身のタイプが text である場合は、
RFC2616 3.7.1 で定められているとおり、文字列 "iso-8859-1" を返します。

  open("http://www.ruby-lang.org/en") {|f|
    p f.content_type  # => "text/html"
    p f.charset       # => "iso-8859-1"
  }

--- content_encoding    -> [String]
#@todo

対象となるリソースの Content-Encoding を文字列の配列として返します。
Content-Encoding ヘッダがない場合は、空の配列を返します。

--- status    -> [String]
#@todo

対象となるリソースのステータスコードと reason phrase を文字列の配列として返します。

--- base_uri    -> URI
#@todo

リソースの実際の URI を URI オブジェクトとして返します。
リダイレクトされた場合は、リダイレクトされた後のデータが存在する URI を返します。

--- meta    -> Hash
#@todo

ヘッダを収録したハッシュを返します。

= class OpenURI::HTTPError < StandardError

リソースの取得に失敗した時に投げられます。

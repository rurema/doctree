---
library: uri
include:
  - URI
---
# class URI::Generic

すべての URI クラスの基底クラスです。

hash と eql? が再定義されているため、[c:Hash] のキーとして
利用できます。

## Class Methods

### def default_port    -> Integer | nil

スキームに対応するデフォルトのポート番号を整数で返します。

```ruby
require 'uri'
p URI::Generic.default_port   # => nil
p URI::FTP.default_port       # => 21
p URI::HTTP.default_port      # => 80
p URI::HTTPS.default_port     # => 443
p URI::LDAP.default_port      # => 389
p URI::LDAPS.default_port     # => 636
p URI::MailTo.default_port    # => nil
```

### def component     -> [Symbol]

URI の構成要素を表すシンボルの配列を返します。

```ruby
require 'uri'
p URI::Generic.component
p URI::MailTo.component
  
# => [:scheme, :userinfo, :host, :port, :registry, :path, :opaque, :query, :fragment]
# => [:scheme, :to, :headers]
```

### def use_registry    -> bool

構成要素 registry を受け付けるなら true を返します。
URI::Generic クラスでは false です。

### def build2(ary)     -> URI::Generic
### def build2(hash)    -> URI::Generic

URI::Generic.build と同じですが、例外 URI::InvalidComponentError
が発生した場合に、引数の各要素を URI.escape して再度 build を試み
ます。

- **param** `ary` -- 構成要素を表す文字列の配列を与えます。要素は以下の順です。
  ```text
        [scheme, userinfo, host, port, registry, path, opaque, query, fragment]
  ```

- **param** `hash` --  構成要素を表すハッシュを与えます。ハッシュのキーはシンボルは以下
            のいずれかです。 ハッシュの値は文字列で与えます。
  ```text
        :scheme, :userinfo, :host, :port, :registry, :path, :opaque, :query, :fragment 
  ```

### def build(ary)     -> URI::Generic
### def build(hash)    -> URI::Generic

引数で与えられた URI 構成要素から URI::Generic オブジェクトを生成します。

- **param** `ary` -- 構成要素を表す配列を与えます。要素は以下の順です。
  ```text
        [scheme, userinfo, host, port, registry, path, opaque, query, fragment]
  ```

- **param** `hash` --  構成要素を表すハッシュを与えます。ハッシュのキーはシンボルは以下のいずれかです。
             ハッシュの値は文字列で与えます。
  ```text
        :scheme ,:userinfo, :host, :port, :registry, :path, :opaque, :query, :fragment 
  ```

- **raise** `URI::InvalidComponentError` -- 各要素が適合しない場合に発生します。

### def new(scheme, userinfo, host, port, registry, path, opaque, query, fragment, parser = URI::DEFAULT_PARSER, arg_check = false)    -> URI::Generic

各引数を成分とする URI::Generic オブジェクトを生成して返します。

- **param** `scheme` -- 構成要素 scheme を表す文字列を与えます。

- **param** `userinfo` -- 構成要素を表す文字列を与えます。

- **param** `host` -- 構成要素を表す文字列を与えます。

- **param** `port` -- 構成要素を表す文字列を与えます。

- **param** `registry` -- 構成要素を表す文字列を与えます。

- **param** `path` -- 構成要素を表す文字列を与えます。

- **param** `opaque` -- 構成要素を表す文字列を与えます。

- **param** `query` -- 構成要素を表す文字列を与えます。

- **param** `fragment` -- 構成要素を表す文字列を与えます。

- **param** `arg_check` -- 真が与えられた場合は、各引数が字句規則に適合しているか否かを検査します。適合しない場合は例外 URI::InvalidComponentError が起ります。

- **raise** `URI::InvalidURIError` -- use_registry が偽のとき、registry が与えられると発生します。

## Instance Methods

### def default_port     -> Integer | nil

self.class.default_port を返します。

- **SEE** [m:URI::Generic.default_port]

### def component     -> [Symbol]

self.class.component を返します。

- **SEE** [m:URI::Generic.component]

### def scheme    -> String | nil

自身の scheme を文字列で返します。設定されていない場合は nil を返します。

### def scheme=(s)

自身の scheme を設定します。

- **param** `s` -- 自身の scheme を表す文字列を指定します。

- **raise** `URI::InvalidComponentError` -- 不正な引数 s に対して発生します。

### def userinfo    -> String | nil

自身の userinfo を "username:password" という形式の文字列で返します。
設定されていない場合は nil を返します。

### def userinfo=(s)

自身の userinfo を設定します。

- **param** `s` -- 自身の userinfo を "username" か "username:password" という形式の文字列、あるいは
         [username, password] という形式の文字列の配列で指定します。

- **raise** `URI::InvalidComponentError` -- 不正な引数 s に対して発生します。

- **raise** `URI::InvalidURIError` -- userinfo と registry を同時に設定した場合に発生します。

```ruby title="例"
require 'uri'
u = URI.parse('http://example.com/')
u.userinfo = 'hoge-san:jfae82kj'
p u.to_s                             #=> "http://hoge-san:jfae82kj@example.com/"
  
u.userinfo = 'oreore'
p u.to_s                             #=> "http://oreore:jfae82kj@example.com/"

u.userinfo = ['you', 'akakfd']
p u.to_s                             #=> "http://you:akakfd@example.com/"
```

### def user    -> String | nil

自身の userinfo を文字列で返します。

userinfo が「username:password」の形式である場合は、username 部を返します。
設定されていない場合は nil を返します。

### def user=(s)

自身の user を設定します。

- **param** `s` -- 自身の user を表す文字列を指定します。

- **raise** `URI::InvalidComponentError` -- 不正な引数 s に対して発生します。

- **raise** `URI::InvalidURIError` -- user と registry を同時に設定した場合に発生します。

### def password    -> String | nil

自身の password を文字列で返します。設定されていない場合は nil を返します。

### def password=(s)

自身の password を設定します。

自身に user が設定されていない場合には例外が発生します。

- **param** `s` -- 自身の password を表す文字列を指定します。

- **raise** `URI::InvalidComponentError` -- 不正な引数 s に対して発生します。

- **raise** `URI::InvalidURIError` -- userinfo と registry を同時に設定した場合に発生します。

### def host    -> String | nil

自身の host を文字列で返します。設定されていない場合は nil を返します。

- **SEE** [m:URI::Generic#hostname]

### def host=(s)

自身の host を設定します。

- **param** `s` -- 自身の host を表す文字列を指定します。

- **raise** `URI::InvalidComponentError` -- 不正な引数 s に対して発生します。

- **raise** `URI::InvalidURIError` -- host と registry を同時に設定した場合に発生します。

- **SEE** [m:URI::Generic#hostname=]

### def port     -> String | nil

自身の port を文字列で返します。設定されていない場合は nil を返します。

### def port=(s)

自身の port を設定します。

- **param** `s` -- 自身の port を表す文字列か整数を指定します。

- **raise** `URI::InvalidComponentError` -- 不正な引数 s に対して発生します。

- **raise** `URI::InvalidURIError` -- port と registry を同時に設定した場合に発生します。

### def hostname -> String | nil

自身の hostname を文字列で返します。また、[m:URI::Generic#host] が設
定されていない場合は nil を返します。

このメソッドは [m:URI::Generic#host] に IPv6 アドレスが設定されていた
場合はブラケットを削除した文字列を返しますがそれ以外は同じ文字列を返し
ます。

```ruby
require 'uri'
u = URI("http://[::1]/bar")
p u.hostname      # => "::1"
p u.host          # => "[::1]"
```

### def hostname=(s)

自身の hostname を設定します。

このメソッドは引数に IPv6 アドレスを設定した場合は
[m:URI::Generic#host] にブラケットを追加した文字列を設定しますがそれ
以外は同じ処理を行います。

```ruby
require 'uri'
u = URI("http://foo/bar")
p u.to_s                  # => "http://foo/bar"
u.hostname = "::1"
p u.to_s                  # => "http://[::1]/bar"
```

- **param** `s` -- 自身の hostname を表す文字列を指定します。

- **raise** `URI::InvalidComponentError` -- 不正な引数 s に対して発生します。

- **raise** `URI::InvalidURIError` -- host と registry を同時に設定した場合に発生します。

### def registry    -> String | nil

自身の registry を文字列で返します。設定されていない場合は nil を返します。

### def registry=(s)

自身の registry を設定します。

- **param** `s` -- 自身の registry を表す文字列を指定します。

- **raise** `URI::InvalidComponentError` -- 不正な引数 s に対して発生します。

- **raise** `URI::InvalidURIError` -- server 部と registry を同時に設定した場合に発生します。

### def path     -> String | nil

自身の path を文字列で返します。設定されていない場合は nil を返します。

```ruby
require 'uri'
p URI.parse('http://example.com/hoge').path       #=> "/hoge"
p URI.parse('http://example.com').path            #=> ""
p URI.parse('mailto:nospam@localhost').path       #=> nil
p URI('ftp://example.com/foo').path    #=> 'foo'
p URI('ftp://example.com/%2Ffoo').path #=> '/foo'
```

### def path=(s)

自身の path を設定します。

- **param** `s` -- 自身の path を表す文字列を指定します。

- **raise** `URI::InvalidComponentError` -- 不正な引数 s に対して発生します。

- **raise** `URI::InvalidURIError` -- opaque と path を同時に設定した場合に発生します。

### def query     -> String | nil

自身の query を文字列で返します。設定されていない場合は nil を返します。

```ruby title="例"
require 'uri'
p URI.parse('http://example.com/?hoge').query   #=> "hoge"
```

### def query=(s)

自身の query を設定します。

- **param** `s` -- 自身の query を表す文字列を指定します。

- **raise** `URI::InvalidComponentError` -- 不正な引数 s に対して発生します。

- **raise** `URI::InvalidURIError` -- opaque と query を同時に設定した場合に発生します。

### def opaque     -> String | nil

自身の opaque を文字列で返します。設定されていない場合は nil を返します。

```ruby title="例"
require 'uri'
p URI.parse('http://example.com/').opaque       #=> nil
p URI.parse('mailto:nospam@localhost').opaque   #=> "nospam@localhost"
p URI.parse('urn:ietf:rfc:1149').opaque         #=> "ietf:rfc:1149"
```

### def opaque=(s)

自身の opaque を設定します。

- **param** `s` -- 自身の opaque を表す文字列を指定します。

- **raise** `URI::InvalidComponentError` -- 不正な引数 s に対して発生します。

- **raise** `URI::InvalidURIError` --  opaque とヒエラルキーパートを同時に設定した場合に発生します。

### def fragment     -> String | nil

自身の fragment を文字列で返します。設定されていない場合は nil を返します。

```ruby title="例"
require 'uri'
u = URI.parse('http://example.com/#frgmt')
p u.fragment                                #=> "frgmt"
```

### def fragment=(s)

自身の fragment を設定します。

- **param** `s` -- 自身の fragment を表す文字列を指定します。

- **raise** `URI::InvalidComponentError` -- 不正な引数 s に対して発生します。

### def hierarchical?    -> bool

自身に path が設定されているなら true を返します。そうでない場合は false を返します。

### def absolute     -> bool
### def absolute?    -> bool

自身に scheme が設定されているなら true を返します。そうでない場合は false を返します。

```ruby title="例"
require 'uri'
p URI.parse('http://example.com/').absolute?    #=> true
p URI.parse('./').absolute?                     #=> false
```

### def relative?    -> bool

自身に scheme が設定されていないなら true を返します。そうでない場合は false を返します。

```ruby title="例"
require 'uri'
p URI.parse('http://example.com/').relative?    #=> false
p URI.parse('./').relative?                     #=> true
```

### def merge!(rel)    -> self

与えられたパス rel を自身へ連結します。

[rfc:2396] の Section 5.2 の仕様に従います。
rel が文字列の場合は URI.parse(rel) によって、URI に変換してから連結します。

- **param** `rel` -- 連結したいパスを文字列か URI オブジェクトで与えます。

```ruby title="例"
require 'uri'
u = URI.parse('http://example.com/')
u.merge!('/foo/bar.html')
p u.to_s                                   #=> http://example.com/foo/bar.html
```

### def merge(rel)     -> URI::Generic
### def +(rel)         -> URI::Generic

自身と与えられたパス rel を連結した新しい URI オブジェクトを生成して返します。

[RFC:3986] の Section 5.2 の仕様に従います。
rel が文字列の場合は URI.parse(rel) によって、URI に変換してから連結します。

- **param** `rel` -- 連結したいパスを文字列か URI オブジェクトで与えます。

```ruby title="例"
require 'uri'
p URI.parse('http://example.com/') + '/foo/bar.html'
#=> #<URI::HTTP:0x201001c0 URL:http://example.com/foo/bar.html>
p URI('http://a/b/c/d;p?q').merge('?y')             #=> #<URI::HTTP:0xb7ca2e2c URL:http://a/b/c/d;p?y>
p URI('http://a/b/c/d;p?q').merge('/./g')           #=> #<URI::HTTP:0xb7ca2738 URL:http://a/g>
p URI('http://a/b/c/d;p?q').merge('/../g')          #=> #<URI::HTTP:0xb7ca2008 URL:http://a/g>
p URI('http://a/b/c/d;p?q').merge('../../../g')     #=> #<URI::HTTP:0xb7ca1888 URL:http://a/g>
p URI('http://a/b/c/d;p?q').merge('../../../../g')  #=> #<URI::HTTP:0xb7ca10a4 URL:http://a/g>
```

### def route_from(src)    -> URI::Generic
### def -(src)             -> URI::Generic

与えられた URI を表す src からの相対パスを返します。

- **param** `src` -- 自身の相対パスを算出するための、ルートとなる Absolute URI を与えます。

```ruby title="例"
require 'uri'
p URI.parse('http://example.com/foo/bar.html') - 'http://example.com/'
#=> #<URI::Generic:0x20100256 URL:foo/bar.html>
```

### def route_to(dst)     -> URI::Generic

自身から dst への相対パスを返します。

- **param** `dst` -- URI を文字列かURIオブジェクトで与えます。

```ruby title="例"
require 'uri'
p URI.parse('http://example.com/').route_to('http://example.com/foo/bar.html')
  
#=> #<URI::Generic:0x20100198 URL:foo/bar.html>
```

### def normalize     -> URI::Generic
### def normalize!    -> String | nil

URI オブジェクトを正規化して返します。ホスト名を小文字にし、パスと
構成要素がなければ '/' をセットします。

```ruby title="例"
require 'uri'
u = URI.parse('http://Example.Com')
p u.to_s                            #=> "http://Example.Com"
p u.normalize.to_s                  #=> "http://example.com/"
```

### def to_s      -> String

自身が表す URI を文字列として返します。

```ruby title="例"
require 'uri'
p URI.parse('http://example.com/').to_s #=> "http://example.com/"
```

### def ==(uri)    -> bool

引数に指定した URI (文字列またはURIオブジェクト)との一致判定を行い
ます。URI は正規化して比較されます。

- **param** `uri` -- 比較したい URI を URI オブジェクトで指定します。

```ruby title="例"
require 'uri'
u1 = URI.parse('http://example.com/?hoge')
u2 = URI.parse('http://Example.Com/?hoge')
p u1 == u2                                  #=> true
```

### def select(*components)    -> [String]

指定された components に対応する構成要素を文字列の配列として返します。

- **param** `components` -- 構成要素名をシンボルで指定します。

```ruby title="例"
require 'uri'
  
uri = URI.parse('http://myuser:mypass@my.example.com/test.rbx')
p uri.select(:userinfo, :host, :path)
# => ["myuser:mypass", "my.example.com", "/test.rbx"]
```

### def coerce(oth) -> [URI, URI]

引数 oth をパースして [パース後の oth, self] の配列を返します。

- **param** `oth` -- [c:URI] オブジェクトか文字列を指定します。

```ruby title="例"
require 'uri'

uri = URI.parse("http://my.example.com")
p uri.coerce("http://foo.com")
# => [#<URI::HTTP:0x00000000bcb028 URL:http://foo.com/>, #<URI::HTTP:0x00000000d92178 URL:http://my.example.com>]
```

### def parser -> URI::Parser

selfのパーサを返します。未定義であった場合は URI::DEFAULT_PARSER を返します。

### def find_proxy(env = ENV) -> URI | nil

プロキシ URI を返します。

プロキシ URI は http_proxy, ftp_proxy, no_proxy などの環境変数から取得
します。適切なプロキシが見つからない場合は nil を返します。

環境変数は大文字にしたもの(HTTP_PROXY, FTP_PROXY, NO_PROXYなど)も調べら
れる事に注意してください。

ただし、CGI環境下では http_proxy と HTTP_PROXY は特別扱いされます。
HTTP_PROXY はヘッダ Proxy: に設定されうるためです。そのため、
HTTP_PROXY(環境変数が大文字小文字を区別しない場合は http_proxy も) は使
われません。代わりに CGI_HTTP_PROXY が使われます。

- **param** `env` -- 環境変数 [c:ENV] の代わりに参照するオブジェクトを指定します。

- **raise** `BadURIError` -- selfが相対URIであった場合に発生します。

- **SEE** [c:ENV]

## Constants

### const COMPONENT -> [Symbol]

[c:URI::Generic] で利用可能なコンポーネントの一覧です。

### const DEFAULT_PORT -> nil

[c:URI::Generic] のデフォルトポート(nil)です。

#@# --- USE_REGISTRY -> false
#@#
#@# 2.2.0からnodoc

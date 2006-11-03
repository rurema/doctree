URI (Uniform Resource Identifier) サポートライブラリ

=== 関連 RFC

    * [[RFC:1738]] Uniform Resource Locators (URL)
    * [[RFC:1808]] Relative Uniform Resource Locators
    * [[RFC:2255]] The LDAP URL Format
    * [[RFC:2368]] The mailto URL scheme
    * [[RFC:2373]] IP Version 6 Addressing Architecture
    * [[RFC:2396]] Uniform Resource Identifiers (URI): Generic Syntax
    * [[RFC:2732]] Format for Literal IPv6 Addresses in URL's

= module URI

#@#== Class Variables

#@#--- @@schemes

#@#    モジュール関数 parse によって生成可能なクラスを値とするハッシュ。
#@#    キーはスキームを大文字だけで表した文字列。
#@#    URI::Genericを継承する場合にこのハッシュにエントリを追加すると
#@#    そのクラスが URI.parse によってサポートされます。

== Singleton Methods

--- split(url)

URI を以下の要素に分割した配列を返します。

      * scheme
      * userinfo
      * host
      * port
      * registry
      * path
      * opaque
      * query
      * fragment

例:
        require 'uri'
        p URI.split("http://www.ruby-lang.org/")
        # => ["http", nil, "www.ruby-lang.org", nil, nil, "/", nil, nil, nil]

--- parse(uri_str)

与えられた URI から該当する URI サブクラスのインスタンスを生成して
返します。

        require 'uri'
        p uri = URI.parse("http://www.ruby-lang.org/")

        # => #<URI::HTTP:0x201002a6 URL:http://www.ruby-lang.org/>
        p uri.scheme    # => "http"
        p uri.host      # => "www.ruby-lang.org"
        p uri.port      # => 80
        p uri.path      # => "/"

--- join(uri_str[, str, ...])

文字列 uri_str と str ... をURIとして連結して得られる
URIオブジェクトを返します。

以下と等価です

        URI.parse(uri_str) + str + ....
#@#    URI と相対パスをつなげます。((-あらい 2002-09-24: いい表現じゃないんだろうな・・・-))

例

        require 'uri'
        p URI.join('http://www.ruby-lang.org/', '/ja/man-1.6/')
        => #<URI::HTTP:0x2010017a URL:http://www.ruby-lang.org/ja/man-1.6/>

--- extract(str[, schemes])
--- extract(str[, schemes]) {|uri_str| ... }

文字列 str に対してパターンマッチングを試み、
絶対URIにマッチした部分文字列からなる配列として返します。
抽出する URI がなければ空の配列を返します。

第2引数に文字列の配列 schemes が与えられた場合は
そのスキームだけを検索します。

ブロックが与えられた場合は String#scan と同様で、
マッチした部分がみつかるたびに uri_str に
その部分を代入してブロックを評価します。
このときの値は nil です。

        # つまらんサンプルだ・・・
        require 'uri'
        str = "
                http://www.ruby-lang.org/
                http://www.ruby-lang.org/man-1.6/
        "
        p URI.extract(str, %w(http))
        => ["http://www.ruby-lang.org/", "http://www.ruby-lang.org/man-1.6/"]

#@since 1.8.1
--- regexp([match_schemes])

URIにマッチする正規表現を返します。

引数に文字列の配列 match_schemes を与えた場合は、
その文字列で指定されるスキームの URI のみにマッチする
正規表現を返します。

いずれの場合も返り値の正規表現は不定数の正規表現グループ
(括弧) を含みます。この括弧の数はバージョンによって変動
する可能性があるので、それに依存したコードを書くべきでは
ありません。
#@end

--- escape(str[, unsafe])
--- encode(str[, unsafe])

URI 文字列をエンコードした文字列を返します。unsafe には、URI
として指定できない文字を正規表現か文字列で指定します(デフォルトは、
定数 URI::UNSAFE
        /[^-_.!~*'()a-zA-Z\d;\/?:@&=+$,\[\]]/n
です)。

        require 'uri'
        $KCODE = 'EUC'
        p URI.escape('http://www.ruby-lang.org/ja/man-1.6/?cmd=view;name=Rubyリファレンスマニュアル')

        => "http://www.ruby-lang.org/ja/man-1.6/?cmd=view;name=Ruby%A5%EA%A5%D5%A5%A1%A5%EC%A5%F3%A5%B9%A5%DE%A5%CB%A5%E5%A5%A2%A5%EB"

--- unescape(str)
--- decode(str)

URI 文字列をデコードした文字列を返します。

        require 'uri'
        $KCODE = 'EUC'
        p URI.unescape('http://www.ruby-lang.org/ja/man-1.6/?cmd=view;name=Ruby%A5%EA%A5%D5%A5%A1%A5%EC%A5%F3%A5%B9%A5%DE%A5%CB%A5%E5%A5%A2%A5%EB')

        => "http://www.ruby-lang.org/ja/man-1.6/?cmd=view;name=Rubyリファレンスマニュアル"


= class URI::Generic
include URI

すべての URI クラスの基底クラスです。

== Class Methods

--- default_port

スキームに対応するデフォルトのポート番号を返します。

        require 'uri'
        p URI::Generic.default_port     # => nil
        p URI::HTTP.default_port        # => 80

--- component

URI の構成要素の配列を返します。

        require 'uri'
        p URI::Generic.component
        p URI::MailTo.component

        # => [:scheme, :userinfo, :host, :port, :registry, :path, :opaque, :query, :fragment]
        # => [:scheme, :to, :headers]

--- use_registry

#@#    構成要素 registry を受け付けるなら true を返します。(URI::Generic 
#@#    クラスでは false)
registry 部を利用するか否かを表す真偽値。
この値が偽のとき、new に偽でない registry 部が与えられると
例外 URI::InvalidURIError が起こります。

--- build2(ary)
--- build2(hash)

URI::Generic.build と同じですが、例外 URI::InvalidComponentError
が発生した場合に、引数の各要素を URI.escape して再度 build を試み
ます。

--- build(ary)
--- build(hash)

引数で与えられた URI 構成要素から URI::Generic オブジェクトを生成します。
構成要素は、
      [scheme, userinfo, host, port, registry, path, opaque, query, fragment]
を配列かハッシュで与えます。

--- new(scheme, userinfo, host, port, registry, path, opaque, query, fragment[, arg_check])

#@#    汎用的な構成要素から URI::Generic オブジェクトを生成します。build 
#@#    と異なり、引数の正当性を検査しません。
各引数を成分とする汎用URIオブジェクトを生成して返します。

use_registry が偽のとき、new に偽でない registry
部が与えられると例外 URI::InvalidURIError が起こります。

第10引数arg_checkとして真が与えられた場合は、
値を返す前に各引数が字句規則に適合しているか否かを検査し、
適合しない場合は例外 URI::InvalidComponentError が起ります。

== Instance Methods

--- default_port

self.class.default_port です。

--- component

self.class.component です。

--- scheme
--- scheme=()
--- userinfo
--- userinfo=()
--- user
--- user=()
--- password
--- password=()
--- host
--- host=()
--- port
--- port=()
--- registry
--- registry=()
--- path
--- path=()
--- query
--- query=()
--- opaque
--- opaque=()
--- fragment
--- fragment=()

各構成要素の属性メソッドです。属性設定では、引数の正当性をチェック
し不正な引数に対して例外 URI::InvalidComponentError を発生させます。
((-あらい 2002-09-24: InvalidURIError を起こすものもあるのはわざと？-))

--- hierarchical?

path が真なら真です。

--- absolute?

scheme が真なら真です。

--- relative?

scheme が偽なら真です。

--- merge(rel)
--- +(rel)

rel を連結する。
rel が文字列の場合は URI.parse(rel) によって、
URI に変換してから連結する。

        require 'uri'
        p URI.parse('http://www.ruby-lang.org/') + '/en/raa.html'
        => #<URI::HTTP:0x201001c0 URL:http://www.ruby-lang.org/en/raa.html>

--- route_from(src)
--- -(src)

srcからの相対パスを返します。

        require 'uri'
        p URI.parse('http://www.ruby-lang.org/en/raa.html') - 'http://www.ruby-lang.org/'
        => #<URI::Generic:0x20100256 URL:en/raa.html>

--- route_to(dst)

dstへの相対パスを返します。

        require 'uri'
        p URI.parse('http://www.ruby-lang.org/').route_to('http://www.ruby-lang.org/en/raa.html')

        => #<URI::Generic:0x20100198 URL:en/raa.html>

--- normalize
--- normalize!

URI オブジェクトを正規化して返します。ホスト名を小文字にし、path
構成要素がなければ '/' をセットします。

--- to_s
--- to_str

URI を返します。

--- ==(uri)

引数に指定した URI (文字列またはURIオブジェクト)との一致判定を行い
ます。URI は正規化して比較されます。

--- to_a
--- to_ary

URI オブジェクトの構成要素の配列を返します。

= class URI::FTP < URI::Generic

== Class Methods

--- build(ary)
--- build(hash)

引数で与えられた URI 構成要素から URI::FTP オブジェクトを生成します。
構成要素は、
      [userinfo, host, port, path, typecode]
を配列かハッシュで与えます。typecode は、"a"、"i" あるいは "d" です。
"a" はテキスト、"i" はバイナリ、"d" はディレクトリを表します。
"a" がテキストで、"i" がバイナリなのは、それぞれのデータタイプが
FTPのプロトコルで ASCII と IMAGE と呼ばれていたためです。

--- new(scheme, userinfo, host, port, registry, path, opaque, query, fragment[, arg_check])

汎用的な構成要素から URI::FTP オブジェクトを生成します。build
と異なり、引数の正当性を検査しません。

      require 'uri'
      p ftp = URI.parse("ftp://ftp.ruby-lang.org/pub/ruby/;type=d")
      p ftp.typecode
      => #<URI::FTP:0x2010029c URL:ftp://ftp.ruby-lang.org/pub/ruby/;type=d>
         "d"


#@# bc-rdoc: detected missing name: new2
--- new2(user, password, host, port, path, typecode = nil, arg_check = true)

== Instance Methods

--- typecode
--- typecode=()

各構成要素の属性メソッドです。属性設定では、引数の正当性をチェック
し不正な引数に対して例外 URI::InvalidComponentError を発生させます。

= class URI::HTTP < URI::Generic

== Class Methods

--- build(ary)
--- build(hash)

引数で与えられた URI 構成要素から URI::HTTP オブジェクトを生成します。
構成要素は、
      [userinfo, host, port, path, query, fragment]
を配列かハッシュで与えます。

--- new(scheme, userinfo, host, port, registry, path, opaque, query, fragment[, arg_check])

汎用的な構成要素から URI::HTTP オブジェクトを生成します。build
と異なり、引数の正当性を検査しません。

== Instance Methods

--- request_uri

path + '?' + query を返します。

= class URI::HTTPS < URI::HTTP

= class URI::LDAP < URI::Generic

LDAP URI SCHEMA (described in [[RFC:2255]])

  ldap://<host>/<dn>[?<attrs>[?<scope>[?<filter>[?<extensions>]]]]

== Class Methods

--- build(ary)
--- build(hash)

--- new(scheme, userinfo, host, port, registry, path, opaque, query, fragment[, arg_check])

== Instance Methods

--- dn

--- dn=()

--- attributes

--- attributes=()

--- scope

--- scope=()

--- filter

--- filter=()

--- extensions

--- extensions=()

= class URI::MailTo < URI::Generic

[[RFC:2368]], The mailto URL scheme

== Class Methods

--- build(ary)
--- build(hash)

引数で与えられた URI 構成要素から URI::MailTo オブジェクトを生成します。
構成要素は、
      [to, headers]
を配列かハッシュで与えます。headers は、以下のような文字列か配列で
与えます。

      "subject=subscribe&cc=addr"

      [["subject", "subscribe"], ["cc", "addr"]]

--- new(scheme, userinfo, host, port, registry, path, opaque, query, fragment[, arg_check])

汎用的な構成要素から URI::MailTo オブジェクトを生成します。build
と異なり、引数の正当性を検査しません。

== Instance Methods

--- to
--- to=()
--- headers
--- headers=()

各構成要素の属性メソッドです。属性設定では、引数の正当性をチェック
し不正な引数に対して例外 URI::InvalidComponentError を発生させます。

--- to_mailtext
--- to_rfc822text

URI オブジェクトからメールテキスト文字列を生成します。

      require 'uri'
      p mailto = URI.parse("mailto:ruby-list@ruby-lang.org?subject=subscribe&cc=myaddr")
      print mailto.to_mailtext

      => #<URI::MailTo:0x20104a0e URL:mailto:ruby-list@ruby-lang.org?subject=subscribe&cc=myaddr>
         To: ruby-list@ruby-lang.org
         Subject: subscribe
         Cc: myaddr

#@since 1.8.2
= reopen Kernel

== Private Instance Methods

--- URI(uri_str)

[[m:URI.parse]]と同じです。
#@end

= class URI::Error < StandardError

すべての URI 例外クラスの基底クラスです。

= class URI::InvalidURIError < URI::Error

不正な URI を指定したときに発生します。

= class URI::InvalidComponentError < URI::Error

不正な構成要素を指定したときに発生します。

= class URI::BadURIError < URI::Error

URI として正しいが、使い方が悪いときに発生します。

#@#require time
require webrick/httputils

= class WEBrick::Cookie < Object

=== 備考

[[c:WEBrick::Cookie]]クラスは設定された値が正しいものかどうかを厳密に確認しない。

[[c:WEBrick::Cookie]]クラスはRFC2109の実装である。
RFC2109はRFC2965により破棄されたが、
[[c:WEBrick::Cookie]]クラスはRFC2965の全てに対応していない。

=== 参考

 *[[url:http://www.mars.dti.ne.jp/~torao/rfc/rfc2109-ja.txt]]
  RFC2109の日本語訳。
 *[[url:http://www.studyinghttp.net/translations#RFC2965]]
  RFC2965の日本語訳。
 *[[url:http://www.studyinghttp.net/cookies]]
  クッキーの使い方。
 *[[url:http://shogo.homelinux.org/~ysantoso/webrickguide/html/Cookie.html]]
  WEBrick::Cookieの解説(英語)。

== Class Methods

--- new(name, value)
#@todo
新しい[[c:WEBrick::Cookie]]オブジェクトを生成する。
nameにクッキーの名前を、valueにクッキーで保持する値を与える。

--- parse(str)
#@todo
与えられた文字列strを解釈、新しく[[c:WEBrick::Cookie]]オブジェクトを生成し、配列として返す。

#@since 1.8.4
--- parse_set_cookie(str)
#@todo
#@end

== Instance Methods

--- comment
#@todo
コメントを返す。

--- comment=(value)
#@todo
コメントを設定する。
valueは文字列。

--- domain
#@todo
ドメイン名を返す。

--- domain=(value)
#@todo
ドメイン名を設定する。
valueは文字列。

--- expires
#@todo
有効期限を[[c:Time]]オブジェクトで返す。

--- expires=(value)
#@todo
有効期限を設定する。
valueは[[c:Time]]オブジェクトまたは文字列。

--- max_age
#@todo
クッキーの寿命を返す。

--- max_age=(value)
#@todo
クッキーの寿命を秒単位で設定する。
valueは正の整数。0は直ちに破棄される事を意味する。

--- name
#@todo
名前を返す。

--- path
#@todo
パス名を返す。

--- path=(value)
#@todo
パス名を設定する。
valueは文字列。

--- secure
#@todo
クッキーのSecure属性を返す。

--- secure=(value)
#@todo
クッキーのSecure属性を設定する。
valueは真偽値。

--- to_s
#@todo
クッキーを文字列化する。

--- value
#@todo
クッキーが保持する値を返す。

--- value=(str)
#@todo
クッキーが保持する値を設定する。
strは文字列。

--- version
#@todo
バージョン番号を返す。

--- version=(value)
#@todo
バージョン番号を設定する。
valueは整数。

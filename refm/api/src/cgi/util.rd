#@since 1.9.1
CGI で利用するユーティリティメソッドを定義したライブラリです。

= reopen CGI

== Class Methods
#@end
--- escape(string) -> String

与えられた文字列を URL エンコードした文字列を新しく作成し返します。

@param string URL エンコードしたい文字列を指定します。

例:
        require "cgi"

        p CGI.escape('@##')   #=> "%40%23%23"

        url = "http://www.example.com/register?url=" + 
          CGI.escape('http://www.example.com/index.rss')
        p url
        #=> "http://www.example.com/register?url=http%3A%2F%2Fwww.example.com%2Findex.rss"

--- unescape(string) -> String

与えられた文字列を URL デコードした文字列を新しく作成し返します。

@param string URL エンコードされている文字列を指定します。

        require "cgi"

        p CGI.unescape('%40%23%23')   #=> "@##"

        p CGI.unescape("http%3A%2F%2Fwww.example.com%2Findex.rss")
        #=> "http://www.example.com/index.rss"

--- escapeHTML(string) -> String
#@since 1.9.1
--- escape_html(string) -> String
#@end

与えられた文字列中の &"<> を実体参照に置換した文字列を新しく作成し返します。

@param string 文字列を指定します。

        require "cgi"

        p CGI.escapeHTML("3 > 1")   #=> "3 &gt; 1"

        print('<script type="text/javascript">alert("警告")</script>')

        p CGI.escapeHTML('<script type="text/javascript">alert("警告")</script>')
        #=> "&lt;script type=&quot;text/javascript&quot;&gt;alert(&quot;警告&quot;)&lt;/script&gt;"

--- unescapeHTML(string) -> String
#@since 1.9.1
--- unescape_html(string) -> String
#@end
与えられた文字列中の実体参照のうち、&amp; &gt; &lt; &quot;
と数値指定がされているもの (&#0ffff など) を元の文字列に置換します。

@param string 文字列を指定します。

        require "cgi"

        p CGI.unescapeHTML("3 &gt; 1")   #=> "3 > 1"

--- escapeElement(string, *elements) -> String
#@since 1.9.1
--- escape_element(string, *elements) -> String
#@end
第二引数以降に指定したエレメントのタグだけを実体参照に置換します。

@param string 文字列を指定します。

@param elements HTML タグの名前を一つ以上指定します。文字列の配列で指定することも出来ます。

例：
        require "cgi"

        p CGI.escapeElement('<BR><A HREF="url"></A>', "A", "IMG")
             # => "<BR>&lt;A HREF="url"&gt;&lt;/A&gt"

        p CGI.escapeElement('<BR><A HREF="url"></A>', ["A", "IMG"])
             # => "<BR>&lt;A HREF="url"&gt;&lt;/A&gt"

--- unescapeElement(string, *elements) -> String
#@since 1.9.1
--- unescape_element(string, *elements) -> String
#@end

特定の要素だけをHTMLエスケープから戻す。

@param string 文字列を指定します。

@param elements HTML タグの名前を一つ以上指定します。文字列の配列で指定することも出来ます。

例：
        require "cgi"

        print CGI.unescapeElement('&lt;BR&gt;&lt;A HREF="url"&gt;&lt;/A&gt;', "A", "IMG")
          # => "&lt;BR&gt;<A HREF="url"></A>"

        print CGI.unescapeElement('&lt;BR&gt;&lt;A HREF="url"&gt;&lt;/A&gt;', %w(A IMG))
          # => "&lt;BR&gt;<A HREF="url"></A>"

--- rfc1123_date(time) -> String

与えられた時刻を [[RFC:1123]] フォーマットに準拠した文字列に変換します。

@param time [[c:Time]] のインスタンスを指定します。

例：
        require "cgi"

        CGI.rfc1123_date(Time.now)
          # => Sat, 1 Jan 2000 00:00:00 GMT

--- pretty(string, shift = "  ") -> String

HTML を人間に見やすく整形した文字列を返します。

@param string HTML を指定します。

@param shift インデントに使用する文字列を指定します。デフォルトは半角空白二つです。

例：
        require "cgi"

        print CGI.pretty("<HTML><BODY></BODY></HTML>")
          # <HTML>
          #   <BODY>
          #   </BODY>
          # </HTML>

        print CGI.pretty("<HTML><BODY></BODY></HTML>", "\t")
          # <HTML>
          #         <BODY>
          #         </BODY>
          # </HTML>

#@since 1.9.1
== Constants

--- TABLE_FOR_ESCAPE_HTML__ -> Hash

HTML 上でエスケープする文字列の変換テーブルを返します。

    '&' => '&amp;',
    '"' => '&quot;',
    '<' => '&lt;',
    '>' => '&gt;',

--- RFC822_DAYS -> [String]

[[rfc:822]] で定義されている曜日の略称を返します。

@see [[rfc:822]]

--- RFC822_MONTHS -> [String]

[[rfc:822]] で定義されている月名の略称を返します。

@see [[rfc:822]]


#@end

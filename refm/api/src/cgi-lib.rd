このライブラリは obsolete です。
[[lib:cgi]] ライブラリを使ってください。

= class CGI_cgi_lib

== Singleton Methods

--- new(input = $stdin)

--- rfc1123_date(time)

--- escape(str)

--- unescape(str)

--- escapeHTML(str)

--- tag(element, attributes = {})

--- cookie(options)

--- header(*options)

--- print(*options)

--- message(message, title = "", header = ["Content-Type: text/html"])

--- error

== Instance Methods

--- read_from_cmdline

--- inputs

--- cookie


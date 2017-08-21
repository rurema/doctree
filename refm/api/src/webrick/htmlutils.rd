HTML のためのユーティリティ関数を提供します。

= module WEBrick::HTMLUtils

HTML のためのユーティリティ関数を提供します。

== Module Functions

--- escape(string)    -> String

指定された文字列に含まれる ", &, <, > を文字実体参照に変換した文字列を
生成して返します。

@param string エスケープしたい文字列を指定します。

  require 'webrick'
  p WEBrick::HTMLUtils.escape('/?q=foo&hl=<ja>')    #=> "/?q=foo&amp;hl=&lt;ja&gt;"

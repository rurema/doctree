category Windows

require win32/registry

win32/resolv は Win32 プラットフォームで名前解決に関する情報を取得する
ためのライブラリです。

= class Win32::Resolv

名前解決に関する情報を取得するためのクラスです。

== module functions
--- get_hosts_path -> String | nil

hosts ファイルのパスを返します。ファイルが存在しない場合は nil を返します。

例:

  require "win32/resolv"
  p Win32::Resolv.get_hosts_path #=> "C:\Windows\System32\drivers\etc\hosts"

--- get_resolv_info -> [[String], [String]]

ドメイン名とネームサーバを配列の配列で返します。

例:

  require "win32/resolv"
  p Win32::Resolv.get_resolv_info #=> [["my.example.com"], ["192.168.1.1"]]

設定されていない情報は nil になります。

  # ドメイン名が設定されていない場合。
  require "win32/resolv"
  p Win32::Resolv.get_resolv_info #=> [nil, ["192.168.1.1"]]


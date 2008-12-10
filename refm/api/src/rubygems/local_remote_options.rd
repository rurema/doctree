require rubygems

[[c:Gem::Command]] で使用する --local, --remote オプションのためのモジュールを
定義したライブラリです。

= module Gem::LocalRemoteOptions

[[c:Gem::Command]] で使用する --local, --remote オプションのためのモジュールです。

== Public Instance Methods

--- accept_uri_http
#@todo

HTTP の URI を扱えるようにするためのメソッドです。

--- add_bulk_threshold_option
#@todo

オプション --bulk-threshold を追加します。

--- add_local_remote_options
#@todo

オプション --local, --remote, --both を追加します。

--- add_proxy_option
#@todo

オプション --http-proxy を追加します。

--- add_source_option
#@todo

オプション --source を追加します。

--- add_update_sources_option
#@todo

オプション --update-source を追加します。

--- both? -> bool
#@todo

ローカルとリモートの情報を両方とも取得する場合は真を返します。
そうでない場合は偽を返します。

--- local? -> bool
#@todo

ローカルの情報を取得する場合は真を返します。
そうでない場合は偽を返します。

--- remote? -> bool
#@todo

リモートの情報を取得する場合は真を返します。
そうでない場合は偽を返します。


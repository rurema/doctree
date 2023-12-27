category Development

Ruby インタプリタが作成された環境における、データ型のサイズなどに関する情報を格納したライブラリです。

= reopen RbConfig

== Constants

--- SIZEOF -> Hash

Ruby インタプリタが作成された環境における、C の型のサイズ情報を保持します。

下の例では、実行している Ruby インタプリタは int が 4 バイトである環境で作成されたことを表しています。

#@samplecode
require 'rbconfig/sizeof'
RbConfig::SIZEOF['int'] # => 4
#@end

--- LIMITS -> Hash

Ruby インタプリタが作成された環境における、さまざまな型の値の範囲に関する情報を保持します。

下の例では、実行している Ruby インタプリタは INT_MAX が 2147483647 である環境で作成されたことを表しています。

#@samplecode
require 'rbconfig/sizeof'
RbConfig::LIMITS['INT_MAX'] # => 2147483647
#@end

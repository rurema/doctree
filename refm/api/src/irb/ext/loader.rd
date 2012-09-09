load または require 時の irb のファイル読み込み機能(irb_load、
irb_require)を定義するサブライブラリです。

このライブラリで定義されているメソッドはユーザが直接使用するものではあ
りません。[[lib:irb/cmd/load]] や [[lib:irb/ext/use-loader]] から呼び出
されます。

= class IRB::LoadAbort < Exception

irb 中で require などを中断した場合に発生する例外です。

= module IRB::IrbLoader

load または require 時の irb のファイル読み込み機能(irb_load、
irb_require)を定義するモジュールです。

ユーザが直接使用するものではありません。

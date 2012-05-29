require irb/cmd/load
require irb/ext/loader

load または require 時に irb のファイル読み込み機能(irb_load、
irb_require)を使うように設定する機能を提供するサブライブラリです。

このライブラリで定義されているメソッドはユーザが直接使用するものではありません。

= reopen IRB::ExtendCommandBundle

== Instance Methods

--- irb_load(*opts, &b) -> nil

現在の irb に関する [[c:IRB::Context]] に対して irb_load コマンドを実行
します。

@see [[m:IRB::ExtendCommand::Load#execute]]

--- irb_require(*opts, &b) -> bool

現在の irb に関する [[c:IRB::Context]] に対して irb_require コマンドを
実行します。

@see [[m:IRB::ExtendCommand::Require#execute]]

= reopen IRB::Context

== Instance Methods

--- use_loader  -> bool
--- use_loader? -> bool

load または require 時に irb のファイル読み込み機能(irb_load、
irb_require)を使うかどうかを返します。

#@# 以下、どれもそうなので省略。サブ irb までは反映されなかった。
#@# use_loader の値は irb 全体に反映されます。

@see [[m:IRB::Context#use_loader=]]

--- use_loader=(opt)

load または require 時に irb のファイル読み込み機能(irb_load、
irb_require)を使うかどうかを設定します。

.irbrc ファイル中で IRB.conf[:USE_LOADER] を設定する事でも同様の事が行
えます。

#@# use_loader の値は irb 全体に反映されます。

デフォルト値は false です。

@see [[m:IRB::Context#use_loader?]]

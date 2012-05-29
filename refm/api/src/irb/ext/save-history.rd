require readline

[[c:IRB::Context]] にヒストリの読み込み、保存の機能を提供するサブライブ
ラリです。

conf.save_history か IRB.conf[:SAVE_HISTORY] にヒストリの保存件数を設定
する事で使用できます。

ただし、[[lib:readline]] が利用できない環境ではヒストリの読み込み、保存
は行えません。

このライブラリで定義されているメソッドはユーザが直接使用するものではあ
りません。

= reopen IRB::Context

== Instance Methods

--- init_save_history -> ()

自身の持つ [[c:IRB::InputMethod]] オブジェクトが irb のヒストリを扱える
ようにします。

@see [[m:IRB::HistorySavingAbility.extended]]

--- save_history -> Integer | nil

履歴の最大保存件数を [[c:Integer]] か nil で返します。

@return 履歴の最大保存件数を [[c:Integer]] か nil で返します。0 以下や
        nil を返した場合は追加の保存は行いません。

@see [[ref:lib:irb#history]]

--- save_history=(val)

履歴の最大保存件数を val に設定します。

.irbrc ファイル中で IRB.conf[:SAVE_HISTORY] を設定する事でも同様の事が
行えます。

@param val 履歴の最大保存件数を [[c:Integer]] で指定します。0 以下や
           nil を返した場合は追加の保存は行いません。現在の件数より小さ
           い値を設定した場合は、最新の履歴から指定した件数分のみが保存
           されます。

@see [[ref:lib:irb#history]]

--- history_file -> String | nil

履歴ファイルのパスを返します。

@return 履歴ファイルのパスを [[c:String]] か nil で返します。nil を返し
        た場合は、~/.irb_history に履歴が保存されます。

@see [[ref:lib:irb#history]]

--- history_file=(hist)

履歴ファイルのパスを val に設定します。

.irbrc ファイル中で IRB.conf[:HISTORY_FILE] を設定する事でも同様の事が
行えます。

@param hist 履歴ファイルのパスを文字列で指定します。

@see [[ref:lib:irb#history]]

= module IRB::HistorySavingAbility

include Readline

[[c:IRB::HistorySavingAbility]] を extend したオブジェクトに irb のヒス
トリの読み込み、保存の機能を提供するモジュールです。

== Class Methods

--- extended(obj) -> object

obj に irb のヒストリの読み込み、保存の機能を提供します。

obj を返します。

@param obj [[c:IRB::HistorySavingAbility]] を extend したオブジェクトです。

== Instance Methods

--- load_history -> ()

irb のヒストリを履歴ファイルから読み込みます。

@see [[ref:lib:irb#history]]

--- save_history -> ()

irb のヒストリを履歴ファイルに保存します。

@see [[ref:lib:irb#history]]

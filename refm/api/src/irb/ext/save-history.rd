require readline

[[m:IRB::Context]] にヒストリの読み込み、保存の機能を提供するサブライブ
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

IRB.conf[:SAVE_HISTORY] に設定された履歴の最大保存件数を返します。

@see [[ref:lib:irb#history]]

--- save_history=(val)

IRB.conf[:SAVE_HISTORY] に val を設定します。

@param val 履歴の最大保存件数を [[c:Integer]] で指定します。

@see [[ref:lib:irb#history]]

--- history_file -> String | nil

IRB.conf[:HISTORY_FILE] に設定されたファイル名を返します。

@see [[ref:lib:irb#history]]

--- history_file=(hist)

IRB.conf[:HISTORY_FILE] に val を設定します。

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

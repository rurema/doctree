require irb/cmd/nop
require irb/ext/loader

irb 中の irb_load、irb_require、irb_source コマンドのための拡張を定義し
たサブライブラリです。

このライブラリで定義されているメソッドはユーザが直接使用するものではあ
りません。

= class IRB::ExtendCommand::Load < IRB::ExtendCommand::Nop

include IRB::IrbLoader

irb 中の irb_load コマンドのための拡張を定義したクラスです。

== Instance Methods

--- execute(file_name, priv = nil) -> nil

ファイル path を Ruby スクリプトとみなし、現在の irb インタプリタ上で実
行します。

[[m:Kernel.#load]] と異なり、path の内容を irb で一行ずつタイプしたかの
ように、irb 上で一行ずつ評価されます。

@param file_name ファイル名を文字列で指定します。

@param priv 真を指定した場合は実行は内部的に生成される無名モジュール上
            で行われ、グローバルな名前空間を汚染しません。

@raise LoadError 読み込みに失敗した場合に発生します。

= class IRB::ExtendCommand::Require < IRB::ExtendCommand::Nop

include IRB::IrbLoader

irb 中の irb_require コマンドのための拡張を定義したクラスです。

== Instance Methods

--- execute(file_name) -> bool

ファイル file_name を現在の irb インタプリタ上で実行します。

file_name に Ruby スクリプトを指定した場合は、[[m:Kernel.#kernel]] と異
なり、file_name の内容を irb で一行ずつタイプしたかのように、irb 上で一
行ずつ評価されます。require に成功した場合は true を、そうでない場合は
false を返します。

拡張ライブラリ(*.so,*.o,*.dll など)を指定した場合は単純に require され
ます。

@param file_name ファイル名を文字列で指定します。

= class IRB::ExtendCommand::Source < IRB::ExtendCommand::Nop

include IRB::IrbLoader

irb 中の irb_source コマンドのための拡張を定義したクラスです。

== Instance Methods

--- execute(file_name) -> nil

現在の irb インタプリタ上で、 Ruby スクリプト path を評価します。

path の内容を irb で一行ずつタイプしたかのように、irb 上で一行ずつ評価
されます。[[m:$"]] は更新されず、何度でも実行し直す事ができます。

@param file_name ファイル名を文字列で指定します。

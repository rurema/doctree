
irb 中でコマンドを拡張する各ライブラリのベースになるクラスを扱うサブラ
イブラリです。

このライブラリで定義されているメソッドはユーザが直接使用するものではあ
りません。

= class IRB::ExtendCommand::Nop

irb 中でコマンドを拡張するクラスのベースになるクラスです。サブクラスを
定義してコマンドを拡張します。

== Class Methods

--- execute(conf, *opts) -> ()

コマンドを実行します。ユーザが直接使用するものではありません。

@param conf [[c:IRB::Context]] オブジェクトを指定します。

@param opts irb 中でコマンドに渡す引数を指定します。

--- new(conf) -> IRB::ExtendCommand::Nop

自身を初期化します。ユーザが直接使用するものではありません。

@param conf [[c:IRB::Context]] オブジェクトを指定します。

== Instance Methods

--- irb_context -> IRB::Context

irb の現在の設定([[c:IRB::Context]])を返します。

#@# 使用されていないようなので省略しました。
#@# --- irb -> IRB::Irb

--- execute(*opts) -> ()

何もしません。サブクラスでオーバーライドして使用します。

@param opts irb 中でコマンドに渡す引数を指定します。

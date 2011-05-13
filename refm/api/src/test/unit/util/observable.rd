
イベントに対して通知を行うメソッドを提供するためのライブラリです。

= module Test::Unit::Util::Observable

イベントに対して通知を行うメソッドを提供するモジュールです。

== Instance Methods

--- add_listener(channel_name, listener_key = NOTHING, &listener) -> String

channel_name で指定したチャンネルに listener を登録します。

listener_key を省略した場合は listener 自身を listener を削除する時のキー
として登録します。

@param channel_name チャンネルの名前を文字列で指定します。

@param listener_key listener を削除する時のキーを文字列で指定します。

@return listener_key を返します。

--- remove_listener(channel_name, listener_key) -> Proc | nil

listener_key で指定したキーで登録された listener を channel_name で指定
したチャンネルから削除します。

@param channel_name チャンネルの名前を文字列で指定します。

@param listener_key listener を削除する時のキーを指定します。

@return 削除に成功した場合は登録されていた [[c:Proc]] オブジェクトを返します。
        そうでない場合は nil を返します。

--- notify_listeners(channel_name, *arguments) -> Integer

channel_name で指定したチャンネルにある全ての [[c:Proc]] を実行します。

arguments が指定されていた場合は [[c:Proc]] を call する時の引数に arguments
を渡します。

@param channel_name チャンネルの名前を文字列で指定します。

@param arguments [[c:Proc]] に渡す引数を指定します。

@return [[c:Proc]] を実行した数を返します。

[[lib:stringio]] ライブラリが使用できない環境を補助するためのサブライブ
ラリです。

ライブラリ内部で使用する [[c:StringIO]] と同名のクラスを定義します。

#@since 1.9.2
= reopen Syck
#@else
= reopen YAML
#@end

== Class Methods

--- make_stream(io) -> StringIO | IO

引数を元にストリームオブジェクトを作成します。

@param io [[c:IO]]、[[c:String]] オブジェクトかそのサブクラスを指定します。

@raise YAML::Error 引数が [[c:IO]]、[[c:String]] オブジェクトのサブクラ
                   スではなかった場合に発生します。

[注意] [[lib:stringio]] を require した時に LoadError になる環境でしか
使用できない事に注意してください。

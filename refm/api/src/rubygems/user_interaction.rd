
ユーザとのやりとりを行うライブラリです。

= module Gem::DefaultUserInteraction

このモジュールはデフォルトの [[c:Gem::UserInteraction]] を定義しています。

== Singleton Methods

--- ui -> Gem::ConsoleUI

デフォルトの UI を返します。

--- ui=(new_ui)

デフォルトの UI を新しくセットします。

デフォルトの UI を明確にセットしたことがなければ、シンプルなコンソールベースの
[[c:Gem::UserInteraction]] を自動的に使用します。

@param new_ui 新しい UI を指定します。

--- use_ui(new_ui){ ... }
#@# -> discard

与えられたブロックを評価している間だけ UI として new_ui を使用します。

@param new_ui 新しい UI を指定します。

== Public Instance Methods

--- ui -> Gem::ConsoleUI

デフォルトの UI を返します。

@see [[m:Gem::DefaultUserInteraction.ui]]

--- ui=(new_ui)

デフォルトの UI を新しくセットします。

@param new_ui 新しい UI を指定します。

@see [[m:Gem::DefaultUserInteraction.ui=]]

--- use_ui(new_ui){ ... }
#@# -> discard

与えられたブロックを評価している間だけ UI として new_ui を使用します。

@param new_ui 新しい UI を指定します。

@see [[m:Gem::DefaultUserInteraction.use_ui]]

= module Gem::UserInteraction
include Gem::DefaultUserInteraction

デフォルト UI にアクセスしやすくするためのモジュールです。

このモジュール経由で呼び出されたメソッドは全て UI の実装クラスへ処理を委譲します。

#@# ただのラッパー？インターフェイス？

== Public Instance Methods

--- alert(*args) -> ()

INFO レベルのアラートを出力します。

@param args 委譲先のメソッドに与える引数です。

--- alert_error(*args) -> ()

ERROR レベルのアラートを出力します。

@param args 委譲先のメソッドに与える引数です。

--- alert_warning(*args) -> ()

WARNING レベルのアラートを出力します。

@param args 委譲先のメソッドに与える引数です。

--- ask(*args) -> String

質問をして、ユーザの入力を待ち受けて回答を返します。

@param args 委譲先のメソッドに与える引数です。

--- ask_yes_no(*args) -> bool

イエス、ノーで答える質問をします。

@param args 委譲先のメソッドに与える引数です。

@return ユーザの回答がイエスの場合は真を、ノーの場合は偽を返します。

--- choose_from_list(*args) -> Array

リストから回答を選択する質問をします。

@param args 委譲先のメソッドに与える引数です。

@return 選択肢の名称と選択肢のインデックスを要素とする配列を返します。

--- say(*args) -> ()

与えられた文字列を表示します。

@param args 委譲先のメソッドに与える引数です。

--- terminate_interaction(*args) -> ()

アプリケーションを終了します。

@param args 委譲先のメソッドに与える引数です。

= class Gem::StreamUI

シンプルなストリームを実装したユーザインターフェイスです。

== Singleton Methods

--- new(in_stream, out_stream, err_stream = STDERR)

このクラスを初期化します。

@param in_stream 入力元のストリームを指定します。

@param out_stream 出力先のストリームを指定します。

@param err_stream エラー出力を指定します。

== Public Instance Methods

--- alert(statement, question  = nil) -> String | nil

INFO レベルのアラートを表示します。

@param statement 表示する文字列を指定します。

@param question 必要であれば質問を指定します。

@return question を指定した場合は、それに対する回答を返します。
        question を指定しない場合は nil を返します。

@see [[m:Gem::StreamUI#ask]]

--- alert_error(statement, question  = nil) -> String | nil

ERROR レベルのアラートを表示します。

@param statement 表示する文字列を指定します。

@param question 必要であれば質問を指定します。

@return question を指定した場合は、それに対する回答を返します。
        question を指定しない場合は nil を返します。

@see [[m:Gem::StreamUI#ask]]

--- alert_warning(statement, question  = nil) -> String | nil

WARNING レベルのアラートを表示します。

@param statement 表示する文字列を指定します。

@param question 必要であれば質問を指定します。

@return question を指定した場合は、それに対する回答を返します。
        question を指定しない場合は nil を返します。

@see [[m:Gem::StreamUI#ask]]

--- ask(question) -> String | nil

質問をします。

@param question 質問を指定します。

@return 入力ストリームが TTY に接続されている場合は回答を返します。
        そうでない場合は nil を返します。

--- ask_yes_no(question) -> bool

イエス、ノーで答える質問をします。

@param question 質問を指定します。

@return ユーザの回答がイエスの場合は真を、ノーの場合は偽を返します。

--- choose_from_list(question, list) -> Array

リストから回答を選択する質問をします。

リストは質問の上に表示されます。

@param question 質問を指定します。

@param list 回答の選択肢を文字列の配列で指定します。

@return 選択肢の名称と選択肢のインデックスを要素とする配列を返します。

--- errs -> IO

この UI にセットされているエラー出力ストリームを返します。

--- ins -> IO

この UI にセットされている入力ストリームを返します。

--- outs -> IO

この UI にセットされてきる出力ストリームを返します。

--- progress_reporter(*args) -> SilentProgressReporter | SimpleProgressReporter | VerboseProgressReporter

処理の進捗を報告するためのオブジェクトを返します。

返されるオブジェクトの種類は現在の設定によります。

@param args 返値となるオブジェクトを初期化するための引数です。

@see [[c:Gem::StreamUI::SilentProgressReporter]], [[c:Gem::StreamUI::SimpleProgressReporter]], [[c:Gem::StreamUI::VerboseProgressReporter]]

--- say(statement = '') -> ()

与えられた文字列を表示します。

@param statement 表示する文字列を指定します。

--- terminate_interaction(status = 0) -> ()

アプリケーションを終了します。

@param status 終了ステータスを指定します。デフォルトは 0 (成功) です。

@raise Gem::SystemExitException このメソッドを呼び出すと必ず発生する例外です。

= class Gem::StreamUI::SilentProgressReporter

何もしない進捗報告のクラスです。

== Singleton Methods

--- new(out_stream, size, initial_message, terminal_message = nil)

何もしません。

@param out_stream 指定しても意味がありません。

@param size 指定しても意味がありません。

@param initial_message 指定しても意味がありません。

@param terminal_message 指定しても意味がありません。

== Public Instance Methods

--- count -> nil

何もしません。

--- done -> nil

何もしません。

--- updated(message) -> nil

何もしません。

@param message 指定しても意味がありません。

= class Gem::StreamUI::SimpleProgressReporter

シンプルな表示を行う進捗報告のクラスです。

== Singleton Methods

--- new(out_stream, size, initial_message, terminal_message = nil)

このクラスを初期化します。

@param out_stream 出力ストリームを指定します。

@param size 処理する全体の数です。

@param initial_message 初期化が終わったときに表示するメッセージを指定します。

@param terminal_message 終了時に表示するメッセージです。

== Public Instance Methods

--- count -> Integer

[[m:Gem::StreamUI::SimpleProgressReporter#updated]] が呼び出された回数を返します。

--- done -> nil

終了メッセージを表示します。

--- updated(message) -> nil

ドットを表示します。

@param message 指定しても意味がありません。

= class Gem::StreamUI::VerboseProgressReporter

現在の進捗に関するメッセージを表示する進捗報告のクラスです。

== Singleton Methods

--- new(out_stream, size, initial_message, terminal_message = nil)

このクラスを初期化します。

@param out_stream 出力ストリームを指定します。

@param size 処理する全体の数を指定します。

@param initial_message 初期化がおわったときに表示するメッセージを指定します。

@param terminal_message 終了時に表示するメッセージです。

== Public Instance Methods

--- count -> Integer

[[m:Gem::StreamUI::VerboseProgressReporter#updated]] が呼び出された回数を返します。

--- done -> nil

終了メッセージを表示します。

--- updated(message) -> nil

現在の [[m:Gem::StreamUI::VerboseProgressReporter#count]] と全体の数とメッセージを表示します。

@param message 表示するメッセージを指定します。

= class Gem::ConsoleUI < Gem::StreamUI

[[c:Gem::StreamUI]] を標準入力、標準出力、標準エラー出力を使用して初期化します。

@see [[m:Object::STDIN]], [[m:Object::STDOUT]], [[m:Object::STDERR]]

= class Gem::SilentUI

完全に何もしない UI です。

---
library: rubygems/user_interaction
include:
  - Gem::DefaultUserInteraction
---
# module Gem::UserInteraction

デフォルト UI にアクセスしやすくするためのモジュールです。

このモジュール経由で呼び出されたメソッドは全て UI の実装クラスへ処理を委譲します。

#@# ただのラッパー？インターフェイス？

## Public Instance Methods

### def alert(*args) -> ()

INFO レベルのアラートを出力します。

- **param** `args` -- 委譲先のメソッドに与える引数です。

### def alert_error(*args) -> ()

ERROR レベルのアラートを出力します。

- **param** `args` -- 委譲先のメソッドに与える引数です。

### def alert_warning(*args) -> ()

WARNING レベルのアラートを出力します。

- **param** `args` -- 委譲先のメソッドに与える引数です。

### def ask(*args) -> String

質問をして、ユーザの入力を待ち受けて回答を返します。

- **param** `args` -- 委譲先のメソッドに与える引数です。

### def ask_yes_no(*args) -> bool

イエス、ノーで答える質問をします。

- **param** `args` -- 委譲先のメソッドに与える引数です。

- **return** -- ユーザの回答がイエスの場合は真を、ノーの場合は偽を返します。

### def choose_from_list(*args) -> Array

リストから回答を選択する質問をします。

- **param** `args` -- 委譲先のメソッドに与える引数です。

- **return** -- 選択肢の名称と選択肢のインデックスを要素とする配列を返します。

### def say(*args) -> ()

与えられた文字列を表示します。

- **param** `args` -- 委譲先のメソッドに与える引数です。

### def terminate_interaction(*args) -> ()

アプリケーションを終了します。

- **param** `args` -- 委譲先のメソッドに与える引数です。


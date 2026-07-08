---
library: rake
---
# class Rake::Task

タスクは Rakefile における基本単位です。

タスクは一つ以上の関連するアクションと事前タスクを持ちます。
タスクを実行すると、まず始めに全ての事前タスクを一度だけ実行してから
自身のアクションを実行します。

タスクは通常 [m:Kernel#task], [m:Kernel#file] という便利なメソッドを使用して定義します。

## Public Instance Methods

### def actions -> Array

自身に関連するアクションのリストを返します。

### def add_description(description)

自身に詳細説明を追加します。

### def application -> Rake::Application

自身を所有している [c:Rake::Application] のインスタンスを返します。

### def application=(app)

自身を所有している [c:Rake::Application] のインスタンスをセットします。

- **param** `app` -- 自身を所有しているアプリケーションを指定します。

### def arg_description

### def arg_names -> Array

自身のパラメータ名のリストを返します。

### def clear -> self

自身に登録されているアクションと事前タスクをクリアします。

### def clear_actions -> self

自身に登録されているアクションをクリアします。

### def clear_prerequisites -> self

自身に登録されている事前タスクをクリアします。

### def comment -> String

自身の短いコメントを返します。

### def comment=(comment)

自身のコメントをセットします。

与えられた文字列が 50 文字を越える場合や複数行である場合は文字列を切り詰めます。

- **param** `comment` -- コメントをあらわす文字列を指定します。

### def enhance(deps = nil){ ... }  -> self

自身に事前タスクとアクションを追加します。

### def execute(args = nil)

自身に関連付けられているアクションを実行します。

### def full_comment -> String

自身のコメントを全て返します。

### def inspect -> String

自身の情報を人間に読める形式で返します。

### def investigation -> String

自身の詳しい内部状態を文字列化して返します。

このメソッドはデバッグに便利です。

### def invoke(*args)

必要であれば自身を実行します。最初に事前タスクを実行します。

### def name -> String

ネームスペースを含むタスクの名前を返します。

### def needed? -> true

このタスクが必要ならば真を返します。

### def prerequisites -> Array

事前タスクのリストを返します。

### def reenable -> false

自身をもう一度実行出来るようにします。

### def scope

### def set_arg_names(args)

自身のパラメータの名前のリストをセットします。

- **param** `args` -- シンボルのリストを指定します。

### def source -> String

[m:Rake::Task#sources] の最初の要素を返します。

### def sources -> Array

自身が依存するファイルのリストを返します。

### def sources=(sources)

自身が依存するファイルのリストをセットします。

- **param** `sources` -- 自身が依存するファイルのリストを指定します。

### def timestamp -> Time

自身のタイムスタンプを返します。

基本的なタスクは現在時刻を返しますが、高度なタスクはタイムスタンプを
計算して返します。

### def to_s -> String

自身の名前を返します。

## Singleton Methods

### def new(task_name, app)

与えられたタスク名とアプリケーションで自身を初期化します。

このメソッドで作成したタスクは、アクションや事前タスクを持っていません。
それらを追加する場合は [m:Rake::Task#enhance] を使用してください。

- **SEE** [m:Rake::Task#enhance]

### def [](task_name) -> Rake::Task

与えられた名前のタスクを返します。

与えられた名前のタスクが存在しない場合は、ルールからタスク名を合成しようとします。
ルールからタスク名を合成出来なかったが、与えられたタスク名にマッチするファイルが存在する
場合は、ファイルタスクがアクションや事前タスク無しで存在していると仮定します。

- **param** `task_name` -- タスクの名前を指定します。

### def clear

タスクリストをクリアします。

このメソッドはユニットテスト用です。

### def create_rule(*args){ ... } -> Rake::Task

タスクを合成するためのルールを作成します。

### def define_task(*args){ ... } -> Rake::Task

与えられたパラメータと省略可能なブロックを用いてタスクを定義します。

同名のタスクが存在する場合は、事前タスクとアクションを既に存在するタスクに追加します。

- **param** `args` -- パラメータを指定します。

### def scope_name(scope, task_name) -> String

与えられたスコープとタスク名をコロンで連結して返します。

### def task_defined?(task_name) -> bool

与えられたタスク名が既に定義されている場合は真を返します。
そうでない場合は偽を返します。

- **param** `task_name` -- タスク名を指定します。

### def tasks -> Array

定義されているタスクのリストを返します。

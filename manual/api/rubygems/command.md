---
type: library
include:
  - Gem::UserInteraction
require:
  - rubygems/user_interaction
---
gem コマンドを扱うためのライブラリです。

# class Gem::Command

全ての gem コマンドのスーパークラスです。

## Public Instance Methods

### def add_extra_args(args) -> Array

$HOME/.gemrc から読み込んだ引数を追加します。

- **param** `args` -- 追加する引数を配列で指定します。

### def add_option(*opts){|value, options| ... }
#@# -> discard

コマンドに対するコマンドラインオプションとハンドラを追加します。

ブロックには、コマンドライン引数の値とそのオプションが渡されます。
オプションはハッシュになっています。

- **param** `opts` -- オプションを指定します。

- **SEE** [m:OptionParser#make_switch]

### def arguments -> String

このメソッドはサブクラスで再定義されます。
コマンドが取る引数の説明を表示するために使用します。

サブクラスで実装する場合は、一つの引数につき一行で、左揃えの文字列を返すようにしてください。

### def begins?(long, short) -> bool

long が short で始まる文字列である場合真を返します。そうでない場合は偽を返します。

- **param** `long` -- 長いコマンドラインオプションを指定します。

- **param** `short` -- 短いコマンドラインオプションを指定します。

### def command -> String

コマンドの名前を返します。

### def defaults -> Hash

デフォルトのオプションを返します。

### def defaults=(hash)

コマンドで使用するデフォルトのオプションをセットします。

- **param** `hash` -- オプションをハッシュで指定します。

### def defaults_str -> String

このメソッドはサブクラスで再定義されます。
コマンドのオプションで使用するデフォルト値を表示するために使用する文字列を返します。

- **SEE** [m:Gem::Command#arguments]

### def description -> String

このメソッドはサブクラスで再定義されます。
コマンドが実行することを説明する文字列を返します。

### def execute -> ()

このメソッドはサブクラスで再定義されます。
コマンドを実行します。

- **raise** `RuntimeError` -- このメソッドがサブクラスで再定義されていない場合に発生します。

### def get_all_gem_names -> Array

コマンドラインで与えられた Gem の名前を全て取得して返します。

- **raise** `Gem::CommandLineError` -- コマンドライン引数から Gem の名前を取得できない場合に発生します。

### def get_one_gem_name -> String

コマンドラインで与えられた Gem の名前を一つ取得して返します。

- **raise** `Gem::CommandLineError` -- コマンドライン引数から Gem の名前を一つだけ取得できない場合に発生します。

### def get_one_optional_argument -> String

コマンドラインからオプショナルな引数を取得して返します。

- **return** -- 一つ以上、指定した場合は最初の値を返します。一つも指定していない場合は nil を返します。

### def handle_options(args)
#@# -> discard
与えられた引数のリストをパースして結果を記録します。

- **param** `args` -- 引数のリストを指定します。

### def handles?(args) -> bool

与えられた引数リストを処理することが出来れば真を返します。処理できない場合は偽を返します。

- **param** `args` -- 引数リストを指定子明日。

### def invoke(*args)
#@# -> discard
与えられた引数を使用してコマンドを呼び出します。

- **param** `args` -- 引数のリストです。

### def merge_options(new_options) -> Hash

与えられたオプションとデフォルトのオプションをマージします。
しかし、新しいオプションに同一のキーがあってもデフォルトのオプションは変更されません。

- **param** `new_options` -- 新しいコマンドオプションをハッシュで指定します。

### def options -> Hash

コマンドで使用するオプションを返します。

### def program_name -> String

コマンドラインで実行するときに使用するプログラム名を返します。

### def program_name=(name)

コマンドラインで実行するときに使用するプログラム名をセットします。

- **param** `name` -- プログラム名を指定します。

### def remove_option(name)

与えられた名前に一致するコマンドラインオプションを削除します。

- **param** `name` -- 削除したいコマンドラインオプションの名前を指定します。

### def show_help -> ()

コマンドの使用方法を表示します。

### def summary -> String

コマンドの短い説明を返します。

### def summary=(description)

コマンドの短い説明をセットします。

- **param** `description` -- コマンドの短い説明を指定します。

### def usage -> String

このメソッドはサブクラスで再定義されます。
個々の gem コマンドの使用方法を返します。

### def when_invoked{ ... } -> Proc

コマンドが実行されたときに評価するブロックを登録します。

通常のコマンド呼び出しは、そのコマンドクラスの execute メソッドを実行するだけです。
このメソッドでブロックを登録すると、通常の呼び出しを上書きできます。
これはテストメソッドで正しくコマンドの呼び出しが実行されたことを確認するのに使用することが出来ます。

### def show_lookup_failure(gem_name, version, errors = nil) -> ()

Gem が見つからなかった場合、メッセージを表示するために使用するメソッドです。

- **param** `gem_name` -- Gem の名前を指定します。

- **param** `version` -- Gem のバージョンを指定します。

- **param** `errors` -- Gem が見つからなかった理由を表すオブジェクトを格納した配列を指定します。


## Singleton Methods

### def add_common_option(*args){|value, options| ... }
#@# -> discard

全てのコマンドに共通するオプションを登録するためのメソッドです。

- **param** `args` -- 追加するオプションの情報を指定します。

### def add_specific_extra_args(cmd, args)
#@# -> discard

与えられたコマンドに対応する追加の引数を追加します。

- **param** `cmd` -- コマンド名を指定します。

- **param** `args` -- 追加の引数を配列か、空白で区切った文字列で指定します。

### def build_args -> Array

Gem をビルドするときに使用するパラメータを返します。

### def build_args=(value)

Gem をビルドするときに使用するパラメータをセットします。

- **param** `value` -- Gem をビルドするときに使用するパラメータを指定します。


### def common_options -> Array

共通の引数を返します。

### def extra_args -> Array

追加の引数を返します。

### def extra_args=(value)

追加の引数をセットします。

- **param** `value` -- 配列を指定します。

### def specific_extra_args(cmd) -> Array

与えられたコマンドに対応する追加の引数を返します。

特別な追加引数はプログラムの開始時に Gem の設定ファイルから読み込まれます。

- **param** `cmd` -- コマンド名を指定します。

### def specific_extra_args_hash -> Hash

特別な追加引数へのアクセスを提供します。

## Constants

### const HELP -> String

ヘルプメッセージを表す文字列です。


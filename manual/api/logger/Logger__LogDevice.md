---
library: logger
---
# class Logger::LogDevice < Object

[c:Logger] の内部で使用するログの出力先を表すクラスです。

## Class Methods

### def new(log = nil, opt = {}) -> Logger::LogDevice

ログの出力先を初期化します。

- **param** `log` -- ログの出力先。IO オブジェクトを指定します。
           省略すると nil が使用されますが、実行中に例外が発生します。

- **param** `opt` -- オプションをハッシュで指定します。
           ハッシュのキーには :shift_age, :shift_size を指定します。
           省略すると、それぞれ 7, 1048756 (1 MByte) が使用されます。

#@#noexample 内部利用向けのクラスのため

- **SEE** [m:Logger.new]

## Instance Methods

### def close -> nil

出力先の IO オブジェクトを閉じます。

このメソッドは同期されます。

#@#noexample 内部利用向けのクラスのため

- **SEE** [m:IO#close]

### def dev -> IO

出力先の IO オブジェクトを取得します。

#@#noexample 内部利用向けのクラスのため

### def filename -> String | nil

出力先のファイル名を取得します。

出力先がファイルではない場合は nil を返します。

#@#noexample 内部利用向けのクラスのため

### def write(message) -> Integer

出力先の IO オブジェクトにメッセージを書き込みます。

このメソッドは同期されます。

#@#noexample 内部利用向けのクラスのため

- **SEE** [m:IO#write]


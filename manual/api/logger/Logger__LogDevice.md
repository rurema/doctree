---
library: logger
---
# class Logger::LogDevice < Object

[c:Logger] の内部で使用するログの出力先を表すクラスです。

## Class Methods

#%since 4.0
### def Logger::LogDevice.new(log = nil, shift_age: nil, shift_size: nil, shift_period_suffix: nil, binmode: false, reraise_write_errors: [], skip_header: false) -> Logger::LogDevice
#%end
#%version 3.4...4.0
### def Logger::LogDevice.new(log = nil, shift_age: nil, shift_size: nil, shift_period_suffix: nil, binmode: false, reraise_write_errors: []) -> Logger::LogDevice
#%end
#%until 3.4
### def Logger::LogDevice.new(log = nil, shift_age: nil, shift_size: nil, shift_period_suffix: nil, binmode: false) -> Logger::LogDevice
#%end

ログの出力先を初期化します。

- **param** `log` -- ログの出力先。ログを書き込むファイル名か、[c:IO] オブジェクトを指定します。
           省略すると nil が使用されますが、実行中に例外が発生します。

- **param** `shift_age` -- ログファイルを保持する数か、ログファイルを切り替える頻度を指定します。
                 頻度には daily, weekly, monthly を文字列で指定できます。
                 `log` にファイル名を指定した場合のみ有効です。省略した場合は 7 です。

- **param** `shift_size` -- `shift_age` を整数で指定した場合のみ有効です。
                  このサイズ(バイト数)でログファイルを切り替えます。省略した場合は 1048576 (1 MByte) です。

- **param** `shift_period_suffix` -- daily、weekly、monthly でログファイルの切り替えを行う時のログファイルの名の末尾に追加する文字列のフォーマットを指定します。
                           省略した場合は '%Y%m%d' です。

- **param** `binmode` -- ログファイルをバイナリモードで書き込むかどうかを指定します。
               省略した場合は false です。

#%since 3.4
- **param** `reraise_write_errors` -- ログの書き込みやログファイルの切り替えで発生した例外のうち、再度 raise する例外クラスの配列を指定します。
                            それ以外の例外は警告を出して無視します。省略した場合は空配列です。
#%end

#%since 4.0
- **param** `skip_header` -- true を指定すると、ログファイルを新規作成するときに先頭のヘッダー行(`# Logfile created on ...`)を書き込みません。
                   省略した場合は false です。
#%end

#%#noexample 内部利用向けのクラスのため

- **SEE** [m:Logger.new]

## Instance Methods

### def close -> nil

出力先の IO オブジェクトを閉じます。

このメソッドは同期されます。

#%#noexample 内部利用向けのクラスのため

- **SEE** [m:IO#close]

### def dev -> IO

出力先の IO オブジェクトを取得します。

#%#noexample 内部利用向けのクラスのため

### def filename -> String | nil

出力先のファイル名を取得します。

出力先がファイルではない場合は nil を返します。

#%#noexample 内部利用向けのクラスのため

### def write(message) -> Integer

出力先の IO オブジェクトにメッセージを書き込みます。

このメソッドは同期されます。

#%#noexample 内部利用向けのクラスのため

- **SEE** [m:IO#write]


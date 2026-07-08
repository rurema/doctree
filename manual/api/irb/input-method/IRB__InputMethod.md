---
library: irb/input-method
---
# class IRB::InputMethod < Object

抽象的な入力を表すクラスです。ライブラリ内部で使用します。

## Class Methods

### def new(file = STDIN_FILE_NAME) -> IRB::InputMethod

自身を初期化します。

## Instance Methods

### def file_name -> String

ファイル名を文字列で返します。

#@# 使用されていないようなので省略。
#@# --- prompt -> String
#@# --- prompt=(val)

### def gets

[c:NotImplementedError] が発生します。

- **raise** `NotImplementedError` -- 必ず発生します。

### def readable_atfer_eof? -> false

入力が EOF(End Of File)に達した後も読み込みが行えるかどうかを返します。


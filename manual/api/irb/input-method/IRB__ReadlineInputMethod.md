---
library: irb/input-method
include:
#%until 4.0
  - Readline
#%end
---
# class IRB::ReadlineInputMethod < IRB::InputMethod

readline を用いた標準入力からの入力を表すクラスです。ライブラリ内部で使用します。
#%until 4.0
[lib:readline] の require に失敗した場合は定義されません。
#%else
[lib:readline] の require に失敗した場合は、[c:Reline] が代わりに使われます。
#%end

## Class Methods

### def IRB::ReadlineInputMethod.new -> IRB::ReadlineInputMethod

自身を初期化します。

## Instance Methods

### def gets -> String

標準入力から文字列を 1 行読み込みます。

### def eof? -> bool

入力が EOF(End Of File)に達したかどうかを返します。

### def readable_atfer_eof? -> false

入力が EOF(End Of File)に達した後も読み込みが行えるかどうかを返します。

### def line(line_no) -> String

引数 line_no で指定した過去の入力を行単位で返します。

- **param** `line_no` -- 取得する行番号を整数で指定します。

### def encoding -> Encoding

自身の文字エンコーディングを返します。

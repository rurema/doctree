---
library: irb/input-method
include:
  - Readline
---
# class IRB::ReadlineInputMethod < IRB::InputMethod

readline を用いた標準入力からの入力を表すクラスです。ライブラリ内部で使
用します。[lib:readline] の require に失敗した場合は定義されません。

## Class Methods

### def new -> IRB::ReadlineInputMethod

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

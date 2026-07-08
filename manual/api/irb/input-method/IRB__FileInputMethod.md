---
library: irb/input-method
---
# class IRB::FileInputMethod < IRB::InputMethod

ファイルからの入力を表すクラスです。ライブラリ内部で使用します。

## Class Methods

### def new(path) -> IRB::FileInputMethod

自身を初期化します。

- **param** `path` -- パスを文字列で指定します。

## Instance Methods

### def gets -> String

読み込んだファイルから文字列を 1 行読み込みます。

#@# また、呼び出す度に irb のプロンプトを標準出力に表示します。

### def encoding -> Encoding

読み込んだファイルの文字エンコーディングを返します。


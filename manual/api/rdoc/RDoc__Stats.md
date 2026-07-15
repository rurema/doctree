---
library:
  - rdoc/stats
---
# class RDoc::Stats

RDoc のステータスを管理するクラスです。

## Class Methods

### def new -> RDoc::Stats

自身を初期化します。

## Instance Methods

### def print -> ()

自身の持つ情報を標準出力に表示します。

### def num_files -> Integer

解析したファイルの数を返します。

### def num_files=(val)

解析したファイルの数を指定します。

- **param** `val` -- 数値を指定します。

### def num_classes -> Integer

解析したクラスの数を返します。

### def num_classes=(val)

解析したクラスの数を指定します。

- **param** `val` -- 数値を指定します。

### def num_modules -> Integer

解析したモジュールの数を返します。

### def num_modules=(val)

解析したモジュールの数を指定します。

- **param** `val` -- 数値を指定します。

### def num_methods -> Integer

解析したメソッドの数を返します。

### def num_methods=(val)

解析したメソッドの数を指定します。

- **param** `val` -- 数値を指定します。

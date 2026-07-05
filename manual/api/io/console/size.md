---
type: library
---
端末のサイズを取得するための [lib:io/console] のサブライブラリです。

# reopen IO

## Singleton Methods

### def default_console_size -> [Integer, Integer]

デフォルトの端末のサイズを [rows, columns] で返します。

### def console_size -> [Integer, Integer]

端末のサイズを [rows, columns] で返します。

[lib:io/console] が利用できない場合は、[m:IO.default_console_size]
の値を返します。

- **SEE** [m:IO.default_console_size]

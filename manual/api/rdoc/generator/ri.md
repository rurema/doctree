---
type: library
---
ri のためのファイルを生成するためのサブライブラリです。

# class RDoc::Generator::RI

ri のためのファイルを生成するためのクラスです。

## Constants

### const DESCRIPTION -> String

このジェネレータの説明を表す文字列です。

## Instance Methods

#@# :not-new 指定のため new ではなく、initialize で定義。
#@since 2.0.0
### def initialize(store, options) -> RDoc::Generator::RI
#@else
### def initialize(options)        -> RDoc::Generator::RI
#@end

[c:RDoc::Generator::RI] オブジェクトを初期化します。

#@since 2.0.0
- **param** `store` -- [c:RDoc::Store] オブジェクトを指定します。
#@end

- **param** `options` -- [c:RDoc::Options] オブジェクトを指定します。

### def generate -> ()

解析した情報を ri コマンドから読めるようにファイルに出力します。

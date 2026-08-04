---
library: irb/input-method
since: "3.2"
---
#%until 3.3
# class IRB::RelineInputMethod < IRB::InputMethod
#%else
# class IRB::RelineInputMethod < IRB::StdioInputMethod
#%end

[lib:reline] を用いた標準入力からの入力を表すクラスです。ライブラリ内部で使用します。

対話的な端末では、irb は通常この入力方式を使用します。Ruby 3.1 までは
`IRB::ReidlineInputMethod` という名前でした。

## Class Methods

#%until 3.3
### def IRB::RelineInputMethod.new -> IRB::RelineInputMethod
#%else
### def IRB::RelineInputMethod.new(completor) -> IRB::RelineInputMethod
#%end

自身を初期化します。

#%since 3.3
- **param** `completor` -- 入力補完に使用するオブジェクトを指定します。
#%end

## Instance Methods

### def gets -> String

標準入力から文字列を 1 行読み込みます。

### def eof? -> bool

入力が EOF(End Of File)に達したかどうかを返します。

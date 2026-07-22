---
library: rexml/parsers/pullparser
---
# class REXML::Parsers::PullEvent < Object

[c:REXML::Parsers::PullParser] で使われるパース結果を表すイベントクラス。

[m:REXML::Parsers::PullParser#pull] および
[m:REXML::Parsers::PullParser#peek] がこのクラスのオブジェクトを返します。

## Class Methods

#@# Called by PullParser, Users should not use this method
#@# --- new(arg)
#@# #@todo

## Instance Methods

### def [](nth) -> object
#@# --- [](range) -> [object]
### def [](start, len) -> [object]

イベントのパラメータを取り出します。

[m:Array#\[\]] と同様の引数を取ります。

- **param** `nth` -- nth番目のイベントパラメータを取り出します
#@# @param range
- **param** `start` -- start番目から len 個のイベントを取り出します
- **param** `len` -- start番目から len 個のイベントを取り出します

### def event_type -> Symbol

イベントの種類をシンボルで返します。

詳しくは [ref:c:REXML::Parsers::PullParser#event_type] を参照してください。

### def start_element? -> bool

XML要素の開始タグなら真を返します。

### def end_element? -> bool

XML要素の終了タグなら真を返します。

### def text? -> bool

テキストノードなら真を返します。

### def instruction? -> bool

XML処理命令なら真を返します。

### def comment? -> bool

コメントノードなら真を返します。

### def doctype? -> bool

DTD 開始なら真を返します。

### def attlistdecl? -> bool

DTDの属性リスト宣言なら真を返します。

### def elementdecl? -> bool

DTDの要素宣言なら真を返します。

### def entitydecl? -> bool

DTDの実体宣言なら真を返します。

### def notationdecl? -> bool

DTDの記法宣言なら真を返します。

#@# --- entity? -> bool
#@# deprecated, always returns false
#@# #@todo

### def cdata? -> bool

cdata セクションなら真を返します。

### def xmldecl? -> bool

XML宣言なら真を返します。

#@# --- error? -> false
#@# deprecated, always returns false

#@# --- inspect

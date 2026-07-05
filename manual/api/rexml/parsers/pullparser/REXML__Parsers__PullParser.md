---
library: rexml/parsers/pullparser
include:
  - REXML::XMLTokens
extend:
  - Forwardable
---
# class REXML::Parsers::PullParser < Object

プル方式の XML パーサクラス。

## Class Methods

### def new(stream) -> REXML::Parsers::PullParser
新たな PullParser オブジェクトを生成して返します。

- **param** `source` -- 入力(文字列、IO、IO互換オブジェクト(StringIOなど))

## Instance Methods

### def has_next? -> bool
未処理のイベントが残っている場合に真を返します。

- **SEE** [m:REXML::Parsers::PullParser#empty?]

#@# --- entity
#@# #@todo

### def empty? -> bool
未処理のイベントが残っていない場合に真を返します。

- **SEE** [m:REXML::Parsers::PullParser#has_next?]

#@# --- source
#@# #@todo

#@# 使い道がない
#@# --- add_listener(listener)
#@# #@todo


### def each {|event| ... } -> ()

XMLをパースし、得られたイベント列を引数として順にブロックを呼び出します。

- **raise** `REXML::ParseException` -- XML文書のパースに失敗した場合に発生します
- **raise** `REXML::UndefinedNamespaceException` -- XML文書のパース中に、定義されていない名前空間
       が現れた場合に発生します

### def peek(depth = 0) -> REXML::Parsers::PullEvent | nil
イベントキューの先頭から depth 番目のイベントを取り出します。

一番先頭のイベントは 0 で表します。

このメソッドでは列そのものの状態は変化しません。

先頭から depth 番目のイベントが存在しない(XML文書の末尾の
さらに先を見ようとした場合)は nil を返します。

- **param** `depth` -- 先頭から depth 番目のイベントを取り出します

- **raise** `REXML::ParseException` -- XML文書のパースに失敗した場合に発生します
- **raise** `REXML::UndefinedNamespaceException` -- XML文書のパース中に、定義されていない名前空間
       が現れた場合に発生します

### def pull -> REXML::Parsers::PullEvent
イベントキューの先頭のイベントを取り出し、キューからそれを取り除きます。

- **raise** `REXML::ParseException` -- XML文書のパースに失敗した場合に発生します
- **raise** `REXML::UndefinedNamespaceException` -- XML文書のパース中に、定義されていない名前空間
       が現れた場合に発生します

### def unshift(token) -> ()
イベントキューの先頭に token を追加します。

- **param** `token` -- 先頭に追加するイベント([c:REXML::Parsers::PullEvent] オブジェクト)



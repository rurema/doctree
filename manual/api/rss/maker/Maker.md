---
library: rss
---
# module RSS::Maker

## Singleton Methods
### def make(version, &block)
#@todo
versionには"1.0"または"0.9"または
"0.91"または"2.0"を指定します．"0.9"
と"0.91"は同じであることに注意してください．

blockを実行したあとのmakerオブジェクトから
RSSオブジェクトを生成して返します．

# class RSS::Maker::RSSBase

RSSのルート要素を生成するオブジェクトです．

maker.channelを適切に設定しなければRSSは生成されません．

## Instance Methods

### def version
#@todo
作成するXMLのバージョンを返します．

### def version=()
#@todo
作成するXMLのバージョンを設定します．

### def encoding
#@todo
作成するXMLのエンコーディングを返します．デフォルトは
UTF-8です．

### def encoding=()
#@todo
作成するXMLのエンコーディングを設定します．maker
に設定する際のエンコーディングはここで指定したものにす
る必要があります．

### def standalone
#@todo
作成するXMLのstandaloneを返します．

### def standalone=()
#@todo
作成するXMLのstandaloneを設定します．

### def rss_version
#@todo
作成するRSSのバージョンを返します．

### def xml_stylesheets
#@todo
xml_stylesheetを管理するオブジェクトを返します．

### def channel
#@todo
channel要素を生成するオブジェクトを返します．

### def image
#@todo
image要素を生成するオブジェクトを返します．

### def items
#@todo
item要素を生成するオブジェクトを管理するオブジェクトを
返します．

### def textinput
#@todo
textinput要素を生成するオブジェクトを返します．

# class RSS::Maker::RSS10 < RSS::Maker::RSSBase

# class RSS::Maker::RSS20 < RSS::Maker::RSSBase

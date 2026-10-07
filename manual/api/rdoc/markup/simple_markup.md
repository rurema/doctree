RDoc 形式に整形されたプレインテキストを変換するためのサブライブラリです。

[c:RDoc::Markup] は RDoc 形式のドキュメント、Wiki エントリ、Web上の
FAQ などを想定したプレインテキストから様々なフォーマットへの変換を行うツール群の基礎として作られています。[c:RDoc::Markup] 自身は何の出力も行いません。
それらは [ref:output_format] で後述するクラス群に委ねられています。

### Markup

基本的には、[ref:lib:rdoc#markup] と同じです。ただし、rdoc コマンドとは異なり、Ruby のソースコードのコメント部分ではなく、プレインテキストが変換対象になります。そのため、以下のみがフォーマットされます。

- [ref:lib:rdoc#list]
- [ref:lib:rdoc#labeled_list]
- [ref:lib:rdoc#headline]
- [ref:lib:rdoc#ruled_line]
- [ref:lib:rdoc#italic_bold_typewriter]
- [ref:lib:rdoc#escape]

#%# TODO: 1.9.3 では =begin rdoc ... なども使用できる事を追記する。

### 出力可能な形式 {#output_format}

変換する形式として以下のいずれかを選択できます。

- HTML 形式: [c:RDoc::Markup::ToHtml]
- HTML 形式: [c:RDoc::Markup::ToHtmlCrossref]

# class RDoc::Markup

RDoc 形式のドキュメントを目的の形式に変換するためのクラスです。

例:

```ruby
require 'rdoc'
require 'rdoc/markup/to_html'

#%until 4.1
h = RDoc::Markup::ToHtml.new(RDoc::Options.new)
#%else
h = RDoc::Markup::ToHtml.new
#%end
p h.convert("*bold*")
# => "\n<p><strong>bold</strong></p>\n"
```

独自のフォーマットを行うようにパーサを拡張する事もできます。

#%until 4.1

```ruby title="例"
require 'rdoc'
require 'rdoc/markup/to_html'

class WikiHtml < RDoc::Markup::ToHtml
  # WikiWord のフォントを赤く表示。
  def handle_regexp_WIKIWORD(target)
    "<font color=red>" + target.text + "</font>"
  end
end

m = RDoc::Markup.new
# { 〜 } までを :MARK でフォーマットする。
m.add_word_pair("{", "}", :MARK)
# <no> 〜 </no> までを :MARK でフォーマットする。
m.add_html("no", :MARK)

# WikiWord を追加。
m.add_regexp_handling(/\b([A-Z][a-z]+[A-Z]\w+)/, :WIKIWORD)

wh = WikiHtml.new(RDoc::Options.new, m)
# :MARK のフォーマットを <mark> 〜 </mark> に指定。
wh.add_tag(:MARK, "<mark>", "</mark>")

p wh.convert("WikiWord {del} <no>x</no>")
# => "\n<p><font color=red>WikiWord</font> <mark>del</mark> <mark>x</mark></p>\n"
```

#%else

```ruby title="例"
require 'rdoc'
require 'rdoc/markup/to_html'

class WikiHtml < RDoc::Markup::ToHtml
  def initialize(...)
    super
    # WikiWord を追加。
    @markup.add_regexp_handling(/\b([A-Z][a-z]+[A-Z]\w+)/, :WIKIWORD)
  end

  # WikiWord のフォントを赤く表示。
  def handle_regexp_WIKIWORD(text)
    "<font color=red>" + text + "</font>"
  end
end

p WikiHtml.new.convert("see WikiWord here")
# => "\n<p>see <font color=red>WikiWord</font> here</p>\n"
```

#%end

変換する形式を変更する場合、フォーマッタ(例. [c:RDoc::Markup::ToHtml])
を変更、拡張する必要があります。

## Constants

### const SPACE -> ?\s

空白文字です。?\s を返します。ライブラリの内部で使用します。

### const SIMPLE_LIST_RE -> Regexp

リストにマッチする正規表現です。ライブラリの内部で使用します。

ラベルの有無を問わずマッチします。

### const LABEL_LIST_RE -> Regexp

ラベル付きリストにマッチする正規表現です。ライブラリの内部で使用します。

## Class Methods

#%until 4.1
### def RDoc::Markup.new(attribute_manager = nil) -> RDoc::Markup

自身を初期化します。

- **param** `attribute_manager` -- `RDoc::Markup::AttributeManager` オブジェクトを指定します。
#%else
### def RDoc::Markup.new -> RDoc::Markup

自身を初期化します。
#%end

## Instance Methods

#%until 4.1
### def add_word_pair(start, stop, name) -> ()

start と stop ではさまれる文字列(例. *bold*)をフォーマットの対象にします。

- **param** `start` -- 開始となる文字列を指定します。

- **param** `stop` -- 終了となる文字列を指定します。start と同じ文字列にする事も可能です。

- **param** `name` -- [c:RDoc::Markup::ToHtml] などのフォーマッタに識別させる時の名前を
            [c:Symbol] で指定します。

- **raise** `ArgumentError` -- start に "<" で始まる文字列を指定した場合に発生します。

```ruby title="例"
require 'rdoc'
require 'rdoc/markup/to_html'

m = RDoc::Markup.new
m.add_word_pair("{", "}", :MARK)

h = RDoc::Markup::ToHtml.new(RDoc::Options.new, m)
h.add_tag(:MARK, "<mark>", "</mark>")
p h.convert("a {b} c")
# => "\n<p>a <mark>b</mark> c</p>\n"
```

変換時に実際にフォーマットを行うには [m:RDoc::Markup::Formatter#add_tag] のように、フォーマッタ側でも操作を行う必要があります。

### def add_html(tag, name) -> ()

tag で指定したタグをフォーマットの対象にします。

- **param** `tag` -- 追加するタグ名を文字列で指定します。大文字、小文字のどちらを指定しても同一のものとして扱われます。

- **param** `name` -- [c:RDoc::Markup::ToHtml] などのフォーマッタに識別させる時の名前を
            [c:Symbol] で指定します。

```ruby title="例"
require 'rdoc'
require 'rdoc/markup/to_html'

m = RDoc::Markup.new
m.add_html("no", :MARK)

h = RDoc::Markup::ToHtml.new(RDoc::Options.new, m)
h.add_tag(:MARK, "<mark>", "</mark>")
p h.convert("a <no>b</no> c")
# => "\n<p>a <mark>b</mark> c</p>\n"
```

変換時に実際にフォーマットを行うには [m:RDoc::Markup::Formatter#add_tag] のように、フォーマッタ側でも操作を行う必要があります。
#%end

### def add_regexp_handling(pattern, name) -> ()

pattern で指定した正規表現にマッチする文字列をフォーマットの対象にします。

#%until 4.1
例えば WikiWord のような、[m:RDoc::Markup#add_word_pair]、
[m:RDoc::Markup#add_html] でフォーマットできないものに対して使用します。
#%else
例えば WikiWord のような、単純な開始・終了の記号ではさめない文字列に対して使用します。
#%end

- **param** `pattern` -- 正規表現を指定します。

- **param** `name` -- [c:RDoc::Markup::ToHtml] などのフォーマッタに識別させる時の名前を
            [c:Symbol] で指定します。

#%until 4.1

```ruby title="例"
require 'rdoc'
require 'rdoc/markup/to_html'

class WikiHtml < RDoc::Markup::ToHtml
  def handle_regexp_WIKIWORD(target)
    "<font color=red>" + target.text + "</font>"
  end
end

m = RDoc::Markup.new
m.add_regexp_handling(/\b([A-Z][a-z]+[A-Z]\w+)/, :WIKIWORD)

h = WikiHtml.new(RDoc::Options.new, m)
p h.convert("see WikiWord here")
# => "\n<p>see <font color=red>WikiWord</font> here</p>\n"
```

変換時に実際にフォーマットを行うには、フォーマッタ側で `handle_regexp_<name で指定した名前>(target)` を定義します。
`target` は `RDoc::Markup::RegexpHandling` オブジェクトで、`target.text` でマッチした文字列(正規表現にグループがある場合は最初のグループ)を取得できます。
また、フォーマッタの生成時に、この [c:RDoc::Markup] オブジェクトを渡す必要があります。
#%else
フォーマッタ(例. [c:RDoc::Markup::ToHtml])は自身が持つ [c:RDoc::Markup] オブジェクトに登録された正規表現を使うため、
独自のフォーマットを追加するには、フォーマッタのサブクラスで登録を行います。

```ruby title="例"
require 'rdoc'
require 'rdoc/markup/to_html'

class WikiHtml < RDoc::Markup::ToHtml
  def initialize(...)
    super
    @markup.add_regexp_handling(/\b([A-Z][a-z]+[A-Z]\w+)/, :WIKIWORD)
  end

  def handle_regexp_WIKIWORD(text)
    "<font color=red>" + text + "</font>"
  end
end

p WikiHtml.new.convert("see WikiWord here")
# => "\n<p>see <font color=red>WikiWord</font> here</p>\n"
```

変換時に実際にフォーマットを行うには、フォーマッタ側で `handle_regexp_<name で指定した名前>(text)` を定義します。
`text` にはマッチした文字列(正規表現にグループがある場合は最初のグループ)が渡されます。
#%end

### def convert(str, formatter) -> object | ""

str で指定された文字列を formatter に変換させます。

- **param** `str` -- 変換する文字列を指定します。

- **param** `formatter` -- [c:RDoc::Markup::ToHtml]、`RDoc::Markup::ToLaTeX` などのインスタンスを指定します。

変換結果は formatter によって文字列や配列を返します。

#%until 4.1
### def attribute_manager -> RDoc::Markup::AttributeManager

自身の `RDoc::Markup::AttributeManager` オブジェクトを返します。
#%end

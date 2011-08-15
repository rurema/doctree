SimpleMarkup parses plain text documents and attempts to decompose
them into their constituent parts. Some of these parts are high-level:
paragraphs, chunks of verbatim text, list entries and the like. Other
parts happen at the character level: a piece of bold text, a word in
code font. This markup is similar in spirit to that used on WikiWiki
webs, where folks create web pages using a simple set of formatting
rules.

SimpleMarkup itself does no output formatting: this is left to a
different set of classes.

SimpleMarkup is extendable at runtime: you can add new markup
elements to be recognised in the documents that SimpleMarkup parses.

SimpleMarkup is intended to be the basis for a family of tools which
share the common requirement that simple, plain-text should be
rendered in a variety of different output formats and media. It is
envisaged that SimpleMarkup could be the basis for formating RDoc
style comment blocks, Wiki entries, and online FAQs.

=== Basic Formatting

#@todo: 整形を考える。
//emlist{
 * SimpleMarkup looks for a document's natural left margin. This
   isused as the initial margin for the document.

 * Consecutive lines starting at this margin are considered to be a
   paragraph.

 * If a paragraph starts with a "*", "-", or with "<digit>.", then it is
   taken to be the start of a list. The margin in increased to be the
   first non-space following the list start flag. Subsequent lines
   should be indented to this new margin until the list ends. For
   example:

     * this is a list with three paragraphs in
       the first item. This is the first paragraph.

       And this is the second paragraph.

       1. This is an indented, numbered list.
       2. This is the second item in that list

       This is the third conventional paragraph in the
       first list item.

     * This is the second item in the original list

 * You can also construct labeled lists, sometimes called description
   or definition lists. Do this by putting the label in square brackets
   and indenting the list body:

      [cat]  a small furry mammal
             that seems to sleep a lot

      [ant]  a little insect that is known
             to enjoy picnics

   A minor variation on labeled lists uses two colons to separate the
   label from the list body:

      cat::  a small furry mammal
             that seems to sleep a lot

      ant::  a little insect that is known
             to enjoy picnics

   This latter style guarantees that the list bodies' left margins are
   aligned: think of them as a two column table.

 * Any line that starts to the right of the current margin is treated
   as verbatim text. This is useful for code listings. The example of a
   list above is also verbatim text.

 * A line starting with an equals sign (=) is treated as a
   heading. Level one headings have one equals sign, level two headings
   have two,and so on.

 * A line starting with three or more hyphens (at the current indent)
   generates a horizontal rule. THe more hyphens, the thicker the rule
   (within reason, and if supported by the output device)

 * You can use markup within text (except verbatim) to change the
   appearance of parts of that text. Out of the box, SimpleMarkup
   supports word-based and general markup.

   Word-based markup uses flag characters around individual words:

    [\*word*]  displays word in a *bold* font
    [\_word_]  displays word in an _emphasized_ font
    [\+word+]  displays word in a +code+ font

   General markup affects text between a start delimiter and and end
   delimiter. Not surprisingly, these delimiters look like HTML markup.

    [\<b>text...</b>]    displays word in a *bold* font
    [\<em>text...</em>]  displays word in an _emphasized_ font
    [\<i>text...</i>]    displays word in an _emphasized_ font
    [\<tt>text...</tt>]  displays word in a +code+ font

   Unlike conventional Wiki markup, general markup can cross line
   boundaries. You can turn off the interpretation of markup by
   preceding the first character with a backslash, so \\\<b>bold
   text</b> and \\\*bold* produce \<b>bold text</b> and \*bold
   respectively.
//}

= class SM::SimpleMarkup

rdoc 形式のドキュメントを目的の形式に変換するためのクラスです。

例:

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_html'

  m = SM::SimpleMarkup.new
  h = SM::ToHtml.new

  puts m.convert(input_string, h)

独自のフォーマットを行うようにパーサを拡張する事もできます。

例:

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_html'

  class WikiHtml < SM::ToHtml
    # WikiWord のフォントを赤く表示。
    def handle_special_WIKIWORD(special)
      "<font color=red>" + special.text + "</font>"
    end
  end

  m = SM::SimpleMarkup.new
  # { 〜 } までを :STRIKE でフォーマットする。
  m.add_word_pair("{", "}", :STRIKE)
  # <no> 〜 </no> までを :STRIKE でフォーマットする。
  m.add_html("no", :STRIKE)

  # WikiWord を追加。
  m.add_special(/\b([A-Z][a-z]+[A-Z]\w+)/, :WIKIWORD)

  h = WikiHtml.new
  # :STRIKE のフォーマットを <strike> 〜 </strike> に指定。
  h.add_tag(:STRIKE, "<strike>", "</strike>")

  puts "<body>" + p.convert(ARGF.read, h) + "</body>"

変換する形式を変更する場合、フォーマッタ(例. [[c:SM::ToHtml]]) を変更、
拡張する必要があります。

=== 出力可能な形式

変換する形式として以下のいずれかを選択できます。

 * HTML 形式: [[c:SM::ToHtml]]
 * LaTex 形式: [[c:SM::ToLatex]]

また、それ以外にコマンドライン表示などで特別なフォーマットにしたい場合
に、以下のサブライブラリを使用できます。(ri コマンドで使われています)

 * [[c:SM::ToFlow]]

== Constants

--- SPACE -> ?\s

空白文字です。?\s を返します。ライブラリの内部で使用します。

--- SIMPLE_LIST_RE -> Regexp

リストにマッチする正規表現です。ライブラリの内部で使用します。

ラベルの有無を問わずマッチします。

--- LABEL_LIST_RE -> Regexp

ラベル付きリストにマッチする正規表現です。ライブラリの内部で使用します。

== Class Methods

--- new -> SM:SimpleMarkup

自身を初期化します。

== Instance Methods

--- add_word_pair(start, stop, name) -> ()

start と stop ではさまれる文字列(例. *bold*)をフォーマットの対象にしま
す。

@param start 開始となる文字列を指定します。

@param stop 終了となる文字列を指定します。start と同じ文字列にする事も
            可能です。

@param name [[c:SM::ToHtml]] などのフォーマッタに識別させる時の名前を
            [[c:Symbol]] で指定します。

@raise RuntimeError start に "<" で始まる文字列を指定した場合に発生します。

例:

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_html'
  m = SM::SimpleMarkup.new
  m.add_word_pair("{", "}", :STRIKE)

  h = SM::ToHtml.new
  h.add_tag(:STRIKE, "<strike>", "</strike>")
  puts m.convert(input_string, h)

変換時に実際にフォーマットを行うには [[m:SM::ToHtml#add_tag]] のように、
フォーマッタ側でも操作を行う必要があります。

--- add_html(tag, name) -> ()

tag で指定したタグをフォーマットの対象にします。

@param tag 追加するタグ名を文字列で指定します。大文字、小文字のど
           ちらを指定しても同一のものとして扱われます。

@param name [[c:SM::ToHtml]] などのフォーマッタに識別させる時の名前を
            [[c:Symbol]] で指定します。

例:

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_html'
  m = SM::SimpleMarkup.new
  m.add_html("no", :STRIKE)

  h = SM::ToHtml.new
  h.add_tag(:STRIKE, "<strike>", "</strike>")
  puts m.convert(input_string, h)

変換時に実際にフォーマットを行うには [[m:SM::ToHtml#add_tag]] のように、
フォーマッタ側でも操作を行う必要があります。

--- add_special(pattern, name) -> ()

pattern で指定した正規表現にマッチする文字列をフォーマットの対象にしま
す。

例えば WikiWord のような、[[m:SM::SimpleMarkup#add_word_pair]]、
[[m:SM::SimpleMarkup#add_html]] でフォーマットできないものに対して使用
します。

@param pattern 正規表現を指定します。

@param name [[c:SM::ToHtml]] などのフォーマッタに識別させる時の名前を
            [[c:Symbol]] で指定します。

例:

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_html'

  class WikiHtml < SM::ToHtml
    def handle_special_WIKIWORD(special)
      "<font color=red>" + special.text + "</font>"
    end
  end

  m = SM::SimpleMarkup.new
  m.add_special(/\b([A-Z][a-z]+[A-Z]\w+)/, :WIKIWORD)

  h = WikiHtml.new
  puts m.convert(input_string, h)

変換時に実際にフォーマットを行うには SM::ToHtml#accept_special_<name で指定した名前>
のように、フォーマッタ側でも操作を行う必要があります。

--- convert(str, formatter) -> object | ""

str で指定された文字列を formatter に変換させます。

@param str 変換する文字列を指定します。

@param formatter [[c:SM::ToHtml]]、[[c:SM::ToLaTeX]] などのインスタンス
                 を指定します。

変換結果は formatter によって文字列や配列を返します。

--- content -> String

変換する文字列を返します。

rdoc ライブラリのデバッグ用途に使用します。
[[m:SM::SimpleMarkup#convert]] の後に実行します。

変換のために加工したオブジェクトを改行で連結したものを返すため、変換前
の文字列と結果が異なる事があります。

@see [[m:SM::SimpleMarkup#convert]]

--- get_line_types -> [Symbol]

変換する文字列の各行のタイプを [[c:Symbol]] の配列で返します。

rdoc ライブラリのデバッグ用途に使用します。
[[m:SM::SimpleMarkup#convert]] の後に実行します。

@see [[m:SM::SimpleMarkup#convert]]

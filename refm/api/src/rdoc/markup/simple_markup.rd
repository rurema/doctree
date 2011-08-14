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

=== SimpleMarkup の利用

テキスト部をHTMLに変換する部分をライブラリとして使いたければ、
[[c:SM::SimpleMarkup]] を参照してください。

= class SM::SimpleMarkup

This code converts <tt>input_string</tt>, which is in the format
described in markup/simple_markup.rb, to HTML. The conversion
takes place in the +convert+ method, so you can use the same
SimpleMarkup object to convert multiple input strings.

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_html'

  m = SM::SimpleMarkup.new
  h = SM::ToHtml.new

  puts m.convert(input_string, h)

You can extend the SimpleMarkup parser to recognise new markup
sequences, and to add special processing for text that matches a
regular epxression. Here we make WikiWords significant to the parser,
and also make the sequences {word} and \<no>text...</no> signify
strike-through text. When then subclass the HTML output class to deal
with these:

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_html'

  class WikiHtml < SM::ToHtml
    def handle_special_WIKIWORD(special)
      "<font color=red>" + special.text + "</font>"
    end
  end

  p = SM::SimpleMarkup.new
  p.add_word_pair("{", "}", :STRIKE)
  p.add_html("no", :STRIKE)

  p.add_special(/\b([A-Z][a-z]+[A-Z]\w+)/, :WIKIWORD)

  h = WikiHtml.new
  h.add_tag(:STRIKE, "<strike>", "</strike>")

  puts "<body>" + p.convert(ARGF.read, h) + "</body>"

=== Output Formatters

_missing_

== Constants

--- SPACE -> ?\s

#@todo

--- SIMPLE_LIST_RE -> Regexp

List entries look like:

  *       text
  1.      text
  [label] text
  label:: text

Flag it as a list entry, and
work out the indent for subsequent lines

--- LABEL_LIST_RE -> Regexp

#@todo

== Class Methods

--- new -> SM:SimpleMarkup

take a block of text and use various heuristics to determine
it's structure (paragraphs, lists, and so on). Invoke an
event handler as we identify significant chunks.

== Instance Methods

--- add_word_pair(start, stop, name) -> ()

Add to the sequences used to add formatting to an individual word
(such as *bold*). Matching entries will generate attibutes
that the output formatters can recognize by their +name+

--- add_html(tag, name)

Add to the sequences recognized as general markup

--- add_special(pattern, name)

Add to other inline sequences. For example, we could add
WikiWords using something like:

   parser.add_special(/\b([A-Z][a-z]+[A-Z]\w+)/, :WIKIWORD)

Each wiki word will be presented to the output formatter
via the accept_special method

--- convert(str, formatter) -> object | ""

str で指定された文字列を formatter に変換させます。

@param str 変換する文字列を指定します。

@param formatter [[c:SM::ToHtml]]、[[c:SM::ToLaTeX]] などのインスタンス
                 を指定します。

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

RDoc 形式に整形されたプレインテキストを変換するためのサブライブラリです。

#@since 1.9.1
[[c:RDoc::Markup]] は RDoc 形式のドキュメント、Wiki エントリ、Web上の
FAQ などを想定したプレインテキストから様々なフォーマットへの変換を行う
ツール群の基礎として作られています。[[c:RDoc::Markup]] 自身は何の出力も
行いません。
#@else
[[c:SM::SimpleMarkup]] は RDoc 形式のドキュメント、Wiki エントリ、Web
上の FAQ などを想定したプレインテキストから様々なフォーマットへの変換を
行うツール群の基礎として作られています。[[c:SM::SimpleMarkup]] 自身は何
の出力も行いません。
#@end
それらは [[ref:output_format]] で後述するクラス群に委ねられています。

=== Markup

基本的には、[[ref:lib:rdoc#markup]] と同じです。ただし、rdoc コマンドと
は異なり、Ruby のソースコードのコメント部分ではなく、プレインテキストが
変換対象になります。そのため、以下のみがフォーマットされます。

 * [[ref:lib:rdoc#list]]
 * [[ref:lib:rdoc#labeled_list]]
 * [[ref:lib:rdoc#headline]]
 * [[ref:lib:rdoc#ruled_line]]
 * [[ref:lib:rdoc#italic_bold_typewriter]]
 * [[ref:lib:rdoc#escape]]

#@# TODO: 1.9.3 では =begin rdoc ... なども使用できる事を追記する。

===[a:output_format] 出力可能な形式

変換する形式として以下のいずれかを選択できます。

#@since 1.9.1
 * HTML 形式: [[c:RDoc::Markup::ToHtml]]
 * HTML 形式: [[c:RDoc::Markup::ToHtmlCrossref]]
#@until 1.9.2
 * LaTex 形式: [[c:RDoc::Markup::ToLaTeX]]
 * TexInfo 形式: [[c:RDoc::Markup::ToTexInfo]]

また、それ以外にコマンドライン表示などで特別なフォーマットにしたい場合
に、[[c:RDoc::Markup::ToFlow]] を使用できます。(ri コマンドで使われてい
ます)
#@end
#@else
 * HTML 形式: [[c:SM::ToHtml]]
 * LaTex 形式: [[c:SM::ToLaTeX]]

また、それ以外にコマンドライン表示などで特別なフォーマットにしたい場合
に、[[c:SM::ToFlow]] を使用できます。(ri コマンドで使われています)
#@end

#@since 1.9.1
= class RDoc::Markup
#@else
= class SM::SimpleMarkup
#@end

RDoc 形式のドキュメントを目的の形式に変換するためのクラスです。

#@since 1.9.1
例:

  require 'rdoc/markup/to_html'

  h = RDoc::Markup::ToHtml.new
  puts h.convert(input_string)

独自のフォーマットを行うようにパーサを拡張する事もできます。

#@until 1.9.3
[注意] 1.9.3 以前の 1.9 系の rdoc では [[c:RDoc::Markup::Formatter]] に
バグがあるため、下記の例のような拡張が行えません。1.9.3 以下でこのよう
な拡張を行いたい場合は rdoc 3.7 以降を RubyGems でインストールしてくだ
さい。
#@end

例:

  require 'rdoc/markup'
  require 'rdoc/markup/to_html'

  class WikiHtml < RDoc::Markup::ToHtml
    # WikiWord のフォントを赤く表示。
    def handle_special_WIKIWORD(special)
      "<font color=red>" + special.text + "</font>"
    end
  end

  m = RDoc::Markup.new
  # { 〜 } までを :STRIKE でフォーマットする。
  m.add_word_pair("{", "}", :STRIKE)
  # <no> 〜 </no> までを :STRIKE でフォーマットする。
  m.add_html("no", :STRIKE)

  # WikiWord を追加。
  m.add_special(/\b([A-Z][a-z]+[A-Z]\w+)/, :WIKIWORD)

  wh = WikiHtml.new(m)
  # :STRIKE のフォーマットを <strike> 〜 </strike> に指定。
  wh.add_tag(:STRIKE, "<strike>", "</strike>")

  puts "<body>#{wh.convert ARGF.read}</body>"

変換する形式を変更する場合、フォーマッタ(例. [[c:RDoc::Markup::ToHtml]])
を変更、拡張する必要があります。
#@else
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

  puts "<body>" + m.convert(ARGF.read, h) + "</body>"

変換する形式を変更する場合、フォーマッタ(例. [[c:SM::ToHtml]]) を変更、
拡張する必要があります。
#@end

== Constants

--- SPACE -> ?\s

空白文字です。?\s を返します。ライブラリの内部で使用します。

--- SIMPLE_LIST_RE -> Regexp

リストにマッチする正規表現です。ライブラリの内部で使用します。

ラベルの有無を問わずマッチします。

--- LABEL_LIST_RE -> Regexp

ラベル付きリストにマッチする正規表現です。ライブラリの内部で使用します。

== Class Methods

#@since 1.9.1
#@since 1.9.3
--- new(attribute_manager = nil) -> RDoc::Markup
#@else
--- new -> RDoc::Markup
#@end
#@else
--- new -> SM:SimpleMarkup
#@end

自身を初期化します。

#@since 1.9.3
@param attribute_manager [[c:Rdoc::AttributeManager]] オブジェクトを指
                         定します。
#@end

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

#@since 1.9.3
--- attribute_manager -> RDoc::AttributeManager

自身の [[c:RDoc::AttributeManager]] オブジェクトを返します。
#@end

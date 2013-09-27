require json

他のジェネレータが生成する HTML で検索が行えるように、JSON の検索インデッ
クスを生成するサブライブラリです。

This generator is derived from sdoc by Vladimir Kolesnikov and
contains verbatim code written by him.

このジェネレータは HTML ジェネレータと一緒に使うために設計されています。:

  class RDoc::Generator::Darkfish
    def initialize options
      # ...
      @base_dir = Pathname.pwd.expand_path

      @json_index = RDoc::Generator::JsonIndex.new self, options
    end

    def generate
      # ...
      @json_index.generate
    end
  end

=== インデックスフォーマット

検索用のインデックスは JSON ファイルに出力されます。search_data という
グローバル変数に以下のような内容で出力されます。

  var search_data = {
    "index": {
      "searchIndex":
        ["a", "b", ...],
      "longSearchIndex":
        ["a", "a::b", ...],
      "info": [
        ["A", "A", "A.html", "", ""],
        ["B", "A::B", "A::B.html", "", ""],
        ...
      ]
    }
  }

searchIndex、longSearchIndex、info 中の情報は同じ位置にあるものは同じ要
素に関する情報が格納されています。searchIndex フィールドには省略した名
前が格納されています。longSearchIndex フィールドには(適切に記載されてい
れば)完全な名前が格納されています。info フィールドには [名前、完全な名
前、パス、パラメータ, 要素に記載されたコメントの断片] が格納されていま
す。

=== ライセンス

  Copyright (c) 2009 Vladimir Kolesnikov

  Permission is hereby granted, free of charge, to any person obtaining
  a copy of this software and associated documentation files (the
  "Software"), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

= class RDoc::Generator::JsonIndex

include RDoc::Text

他のジェネレータが生成する HTML で検索が行えるように、JSON の検索インデッ
クスを生成するクラスです。

== Class Methods

--- new(parent_generator, options) -> RDoc::Generator::JsonIndex

[[c:RDoc::Generator::JsonIndex]] オブジェクトを初期化します。

@param parent_generator 親となるジェネレータオブジェクトを指定します。
                        RDoc::Generator::JsonIndex#class_dir や
                        #file_dir を決めるのに使用します。
                        他のジェネレータとは異なり、[[c:RDoc::Store]]
                        オブジェクトではない点に注意してください。

@param options [[c:RDoc::Options]] オブジェクトを指定します。
               parent_generator に渡されたものと同じものを指定します。

== Instance Methods

--- generate -> ()

解析した情報を [[m:RDoc::Generator::JsonIndex::SEARCH_INDEX_FILE]] に出
力します。

#@# --- build_index
#@#
#@# Builds the JSON index as a Hash.
#@#
#@# --- debug_msg(*msg)
#@#
#@# Output progress information if debugging is enabled
#@#
#@# --- index_classes
#@#
#@# Adds classes and modules to the index
#@#
#@# --- index_methods
#@#
#@# Adds methods to the index
#@#
#@# --- index_pages
#@#
#@# Adds pages to the index
#@#
#@# --- class_dir
#@#
#@# The directory classes are written to
#@#
#@# --- file_dir
#@#
#@# The directory files are written to
#@#
#@# --- search_string(string)
#@#
#@# Removes whitespace and downcases +string+

== Constants

--- SEARCH_INDEX_FILE -> String

検索インデックスのパスを表す文字列です。

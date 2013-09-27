#@since 1.9.1
require rdoc
require rdoc/code_objects
#@# require rdoc/markup/preprocess
require rdoc/stats
require rdoc/parser/simple
#@else
require rdoc/parsers/parse_simple
#@end
#@since 2.0.0
require rdoc/parser/c
require rdoc/parser/changelog
require rdoc/parser/markdown
require rdoc/parser/rd
require rdoc/parser/ruby
#@end

rdoc で解析できるファイルの種類を追加するためのサブライブラリです。

以下のメソッドを定義したクラスを作成する事で、新しいパーサクラスを作成
する事ができます。

 * #initialize(top_level, file_name, body, options, stats)
 * #scan

initialize メソッドは以下の引数を受け取ります。

 * top_level [[c:RDoc::TopLevel]] オブジェクトを指定します。
 * file_name: file_name ファイル名を文字列で指定します。
 * body: ソースコードの内容を文字列で指定します。
#@since 1.9.1
 * options: [[c:RDoc::Options]] オブジェクトを指定します。
#@else
 * options: [[c:Options]] オブジェクトを指定します。
#@end
 * stats: [[c:RDoc::Stats]] オブジェクトを指定します。

scan メソッドは引数を受け取りません。処理の後は必ず
[[c:RDoc::TopLevel]] オブジェクトを返す必要があります。

#@since 1.9.1
また、[[c:RDoc::Parser]] はファイル名からパーサクラスを取得するのにも使
われます。このために、新しく作成するパーサクラスでは [[c:RDoc::Parser]]
を継承し、parse_files_matching メソッドで自身が解析できるファイル名のパ
ターンを登録しておく必要があります。

例:

  require "rdoc/parser"
  
  class RDoc::Parser::Xyz < RDoc::Parser
    parse_files_matching /\.xyz$/
  
    def initialize(file_name, body, options)
      ...
    end
  
    def scan
      ...
    end
  end

#@else
また、[[c:RDoc::ParserFactory]] はファイル名からパーサクラスを取得する
のにも使われます。このために、新しく作成するパーサクラスでは
[[c:RDoc::ParserFactory]] を extend し、parse_files_matching メソッドで
自身が解析できるファイル名のパターンを登録しておく必要があります。

例:

   require "rdoc/parsers/parserfactory"
   
   module RDoc

     class XyzParser
       extend ParserFactory
       parse_files_matching /\.xyz$/

       def initialize(top_level, file_name, body, options, stats)
         ...
       end

       def scan
         ...
       end
     end
   end

#@end

#@since 1.9.1
= class RDoc::Parser

ソースコードを解析するパーサを生成するための基本クラスです。

新しいパーサを作成する場合には継承して使用します。
#@else
= module RDoc::ParserFactory

ソースコードを解析するパーサを生成するためのファクトリクラスです。

新しいパーサを作成する場合には extend して使用します。

[注意] 1.9 系では、require 先やクラス名が以下のように変更になりました。

 * require 先: rdoc/parser
 * クラス名: RDoc::Parser
#@end

== class Methods

#@since 1.9.1
--- can_parse(file_name) -> RDoc::Parser | nil
#@else
--- can_parse(file_name) -> RDoc::C_Parser | RDoc::RubyParser | RDoc::Fortran95parser | nil
#@end

file_name を解析できるパーサクラスを返します。見つからなかった場合は
nil を返します。

@param file_name 解析するファイルの名前を指定します。

--- alias_extension(old_ext, new_ext) -> bool

old_ext に登録されたパーサを new_ext でも解析できるようにエイリアスを登
録します。

@param old_ext 拡張子を文字列で指定します。

@param new_ext 拡張子を文字列で指定します。

@return エイリアスが登録された場合は true を返します。old_ext にパーサ
        が登録されていない場合、エイリアスが登録されずに false を返しま
        す。

#@since 1.9.1
--- parser_for(top_level, file_name, body, options, stats) -> RDoc::Parser
#@else
--- parser_for(top_level, file_name, body, options, stats) -> RDoc::C_Parser | RDoc::RubyParser | RDoc::Fortran95parser | RDoc::SimpleParser
#@end

file_name を解析できるパーサのインスタンスを返します。
#@since 1.9.1
見つからなかった場合は [[c:RDoc::Parser::Simple]] のインスタンスを返します。
#@else
見つからなかった場合は [[c:RDoc::SimpleParser]] のインスタンスを返します。
#@end

@param top_level [[c:RDoc::TopLevel]] オブジェクトを指定します。

@param file_name ファイル名を文字列で指定します。

@param body ソースコードの内容を文字列で指定します。

#@since 1.9.1
@param options [[c:RDoc::Options]] オブジェクトを指定します。
#@else
@param options [[c:Options]] オブジェクトを指定します。
#@end

@param stats [[c:RDoc::Stats]] オブジェクトを指定します。

#@since 1.9.1
--- parsers -> [[Regexp, RDoc::Parser]]

[[m:RDoc::Parser#parse_files_matching]] で登録した正規表現とパーサクラ
スの配列の配列を返します。
#@end

== Instance Methods

--- parse_files_matching(regexp) -> ()

regexp で指定した正規表現にマッチするファイルを解析できるパーサとして、
自身を登録します。

@param regexp 正規表現を指定します。

新しいパーサを作成する時に使用します。

例:

#@since 1.9.1
  class RDoc::Parser::Xyz < RDoc::Parser
    parse_files_matching /\.xyz$/
    ...
  end
#@else
  class XyzParser
    extend ParserFactory
    parse_files_matching /\.xyz$/
    ...
  end
#@end

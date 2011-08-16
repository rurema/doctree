require rdoc/parsers/parse_simple

rdoc で解析できるファイルの種類を追加するためのサブライブラリです。

以下のメソッドを定義したクラスを作成する事で、新しいパーサクラスを作成
する事ができます。

 * #initialize(top_level, file_name, body, options, stats)
 * #scan

initialize メソッドは以下の引数を受け取ります。

 * top_level [[c:RDoc::TopLevel]] オブジェクトを指定します。
 * file_name: file_name ファイル名を文字列で指定します。
 * body: ソースコードの内容を文字列で指定します。
 * options: [[c:Options]] オブジェクトを指定します。
 * stats: [[c:RDoc::Stats]] オブジェクトを指定します。

scan メソッドは引数を受け取りません。処理の後は必ず
[[c:RDoc::TopLevel]] オブジェクトを返す必要があります。

また、[[c:RDoc::ParserFactory]] はファイル名からパーサクラスを取得する
のにも使われます。このために、新しく作成するパーサクラスでは
[[c:RDoc::ParserFactory]] を extend し、parse_files_matching メソッドで
自身が解析できるファイル名のパターンを登録しておく必要があります。

例:

   require "rdoc/parsers/parsefactory"
   
   module RDoc

     class XyzParser
       extend ParserFactory                 <<<<
       parse_files_matching /\.xyz$/        <<<<

       def initialize(file_name, body, options, stats)
         ...
       end

       def scan
         ...
       end
     end
   end

= module RDoc::ParserFactory

ソースコードを解析するパーサを生成するためのファクトリクラスです。

新しいパーサを作成する場合にも extend する事で使用します。

== class Methods

--- can_parse(file_name) -> RDoc::C_Parser | RDoc::RubyParser | RDoc::Fortran95parser | nil

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

--- parser_for(top_level, file_name, body, options, stats) -> RDoc::C_Parser | RDoc::RubyParser | RDoc::Fortran95parser | RDoc::SimpleParser

file_name を解析できるパーサのインスタンスを返します。見つからなかった
場合は [[c:RDoc::SimpleParser]] のインスタンスを返します。

@param top_level [[c:RDoc::TopLevel]] オブジェクトを指定します。

@param file_name ファイル名を文字列で指定します。

@param body ソースコードの内容を文字列で指定します。

@param options [[c:Options]] オブジェクトを指定します。

@param stats [[c:RDoc::Stats]] オブジェクトを指定します。

== Instance Methods

--- parse_files_matching(regexp) -> ()

regexp で指定した正規表現にマッチするファイルを解析できるパーサとして、
自身を登録します。

@param regexp 正規表現を指定します。

新しいパーサを作成する時に使用します。

例:

  class XyzParser
    extend ParserFactory
    parse_files_matching /\.xyz$/
    ...
  end

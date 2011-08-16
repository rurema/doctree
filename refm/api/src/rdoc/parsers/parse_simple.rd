Parse a non-source file. We basically take the whole thing
as one big comment. If the first character in the file
is '#', we strip leading pound signs.

= class RDoc::SimpleParser

== Class Methods

--- new(top_level, file_name, body, options, stats) -> RDoc::SimpleParser

自身を初期化します。

@param top_level [[c:RDoc::TopLevel]] オブジェクトを指定します。

@param file_name ファイル名を文字列で指定します。

@param body 内容を文字列で指定します。

@param options [[c:RDoc::Options]] オブジェクトを指定します。

@param stats [[c:RDoc::Stats]] オブジェクトを指定します。

== Instance Methods

--- scan -> RDoc::TopLevel

Extract the file contents and attach them to the toplevel as a
comment

@return RDoc::TopLevel オブジェクトを返します。

--- remove_private_comments(comment) -> ()

#@todo

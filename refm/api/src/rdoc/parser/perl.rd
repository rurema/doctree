require rdoc/parser

Perl のソースコードを解析するためのサブライブラリです。Perl のソースコー
ド中に記述された POD (Plain old Documentation) 形式のコメントを解析する
事ができます。

拡張子が .pl、.pm のファイルを解析する事ができます。

[注意] rdoc 3.0.1 から rdoc-perl_pod に分かれたため、1.9.3 から
[[lib:rdoc/parser/perl]] は標準添付ライブラリに含まれなくなりました。
1.9.3 以降でも使用したい場合は rdoc-perl_pod を RubyGems でインストール
してください。

= class RDoc::Parser::PerlPOD < RDoc::Parser

Perl のソースコードを解析するためのクラスです。

== Class Methods

--- new(top_level, file_name, body, options, stats) -> RDoc::Parser::PerlPOD

自身を初期化します。

@param top_level [[c:RDoc::TopLevel]] オブジェクトを指定します。

@param file_name ファイル名を文字列で指定します。

@param body ソースコードの内容を文字列で指定します。

@param options [[c:Options]] オブジェクトを指定します。

@param stats [[c:RDoc::Stats]] オブジェクトを指定します。

== Instance Methods

--- scan -> RDoc::TopLevel

Perl ソースコード中に記述された POD (Plain old Documentation) 形式のコ
メントを解析します。

@return [[c:RDoc::TopLevel]] オブジェクトを返します。

--- filter(comment) -> String

Perl のコメントの各行のマークアップを rdoc 向けのものに変換した文字列を
返します。

現在は基本的な部分のみを処理できます。まだ C<<...>> などを適切に処理す
る事ができません。

@param comment ソースコードの内容を文字列で指定します。

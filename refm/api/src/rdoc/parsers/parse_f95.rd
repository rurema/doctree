#@since 1.9.1
require rdoc/parser
#@else
require rdoc/code_objects
#@end

Fortran95 のソースコードを解析するためのサブライブラリです。

拡張子が .f90、.F90、.f95、.F95 のファイルを解析する事ができます。解析
のためには、Fortran95 の仕様に適合している必要があります。

[注意] rdoc 2.4.0 から rdoc-f95 に分かれたため、1.9.2 から
#@since 1.9.1
[[lib:rdoc/parser/f95]] は標準添付ライブラリに含まれなくなりました。
#@else
[[lib:rdoc/parsers/parse_f95]] は標準添付ライブラリに含まれなくなりました。
#@end
1.9.2 以降でも使用したい場合は rdoc-f95 を RubyGems でインストールして
ください。

=== Fortran95 プログラムとの対応

#@since 1.9.1
[[lib:rdoc/parser/f95]] は以下を解析する事ができます。
#@else
[[lib:rdoc/parsers/parse_f95]] は以下を解析する事ができます。
#@end

 * main プログラム
 * module
 * subroutine
 * function
 * 派生型
 * public 変数
 * public 定数
 * ユーザ定義単項演算子
 * ユーザー定義代入

Ruby と比べてみると以下のようになります。

: ファイル

  ファイル(Ruby と同じ)

: クラス

  module

: メソッド

  subroutine, function, 変数, 定数, 派生型, ユーザ定義単項演算子, ユーザー定義代入

: require されたファイル

  use 文で読み込まれた module, external 宣言された subroutine、function

: include されたモジュール

  use 文で読み込まれた module

: 属性

  派生型や use 文で読み込まれた module

=== 解析可能な情報

以下の情報は自動的に解析されます。

 * 引数の型
 * 変数、定数の型
 * 派生型の型や初期値
 * NAMELIST 中の変数の型や初期値

interface 文の中で定義した alias は上記の「メソッド」と同様に処理されます。

=== コメントのフォーマット

基本的な規則は Ruby のソースコード中にドキュメントを記述する場合と同じ
です。ただし、Fortran95 では、コメントを記述するためには「#」ではなく、
「!」を行頭に記述しなければなりません。コメントは文の後(もしくは下)に記
述します。

字下げは任意の位置に行う事ができます。

     ! (Top of file)
     !
     ! このファイルに対するコメントを記述します。
     !
     !--
     ! "!--" から "!++" で囲まれたコメントは無視されます。
     !++
     !
     module hogehoge
       !
       ! この module(もしくは、program) に対するコメントを記述します。
       !

       private

       logical            :: a     ! private 変数
       real, public       :: b     ! public 変数
       integer, parameter :: c = 0 ! public 定数

       public :: c
       public :: MULTI_ARRAY
       public :: hoge, foo

       type MULTI_ARRAY
         !
         ! 派生型に対するコメントを記述します。
         !
         real, pointer :: var(:) =>null() ! 変数に対するコメント
         integer       :: num = 0
       end type MULTI_ARRAY

     contains

       subroutine hoge( in,   &   ! 継続する行に対するコメントは無視されます。
           &            out )
         !
         ! subroutine や function に対するコメントを記述します。
         !
         character(*),intent(in):: in ! 引数に対するコメントを記述します。
         character(*),intent(out),allocatable,target  :: in

         character(32) :: file ! 下記の NAMELIST 中の変数に対するコメントとして処理されます。
         integer       :: id

         namelist /varinfo_nml/ file, id
                 !
                 ! NAMELIST に対するコメントを記述します。
                 ! 上記の変数に対するコメントを記述できます。
                 !

       ....

       end subroutine hoge

       integer function foo( in )
         !
         ! この行は処理されますが、

         ! この行のような、空行の下に記述したコメントは無視されます。
         !
         integer, intent(in):: inA ! この行は処理されますが、

                                   ! この行は無視されます。

       end function foo

       subroutine hide( in,   &
         &              out )      !:nodoc:
         !
         ! 上記のように subroutine の最後の行に "!:nodoc:" を記述した場
         ! 合は処理されません。

       ....

       end subroutine hide

     end module hogehoge

#@since 1.9.1
= class RDoc::Parser::F95 < RDoc::Parser
#@else
= class RDoc::Fortran95parser

extend RDoc::ParserFactory
#@end

Fortran95 のソースコードを解析するためのクラスです。

== Constants

--- COMMENTS_ARE_UPPER -> false

ライブラリの内部で使用します。

--- INTERNAL_ALIAS_MES -> "Alias for"

ライブラリの内部で使用します。

--- EXTERNAL_ALIAS_MES -> "The entity is"

ライブラリの内部で使用します。

#@until 1.9.1
== Class Methods

--- new(top_level, file_name, body, options, stats) -> RDoc::Fortran95parser

自身を初期化します。

@param top_level [[c:RDoc::TopLevel]] オブジェクトを指定します。

@param file_name ファイル名を文字列で指定します。

@param body ソースコードの内容を文字列で指定します。

@param options [[c:Options]] オブジェクトを指定します。

@param stats [[c:RDoc::Stats]] オブジェクトを指定します。
#@end

== Instance Methods

--- scan -> RDoc::TopLevel

ソースコード中のドキュメントを解析します。

@return [[c:RDoc::TopLevel]] オブジェクトを返します。

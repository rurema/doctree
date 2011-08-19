#@since 1.9.1
require rdoc/parser
#@else
#@# require rdoc/code_objects
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

 * main program
 * module
 * subroutine
 * function
 * 派生型
 * public 変数
 * public 定数
 * defined operators
 * defined assignments

These components are described in items of RDoc documentation, as follows.

Files :: Files (same as Ruby)
Classes :: Modules
Methods :: Subroutines, functions, variables, constants, derived-types, defined operators, defined assignments
Required files :: Files in which imported modules, external subroutines and external functions are defined.
Included Modules :: List of imported modules
Attributes :: List of derived-types, List of imported modules all of whose components are published again

Components listed in 'Methods' (subroutines, functions, ...)
defined in modules are described in the item of 'Classes'.
On the other hand, components defined in main programs or
as external procedures are described in the item of 'Files'.

=== Components parsed by default

By default, documentation on public components (subroutines, functions,
variables, constants, derived-types, defined operators,
defined assignments) are generated.
With "--all" option, documentation on all components
are generated (almost same as the Ruby parser).

=== Information parsed automatically

The following information is automatically parsed.

 * Types of arguments
 * Types of variables and constants
 * Types of variables in the derived types, and initial values
 * NAMELISTs and types of variables in them, and initial values

Aliases by interface statement are described in the item of 'Methods'.

Components which are imported from other modules and published again
are described in the item of 'Methods'.

=== コメントのフォーマット

基本的な規則は Ruby のソースコード中にドキュメントを記述する場合と同じ
です。ただし、Fortran95 では、コメントを記述するためには「#」ではなく、
「!」を行頭に記述しなければなりません。

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

       logical            :: a     ! a private variable
       real, public       :: b     ! a public variable
       integer, parameter :: c = 0 ! a public constant

       public :: c
       public :: MULTI_ARRAY
       public :: hoge, foo

       type MULTI_ARRAY
         !
         ! 派生型に対するコメントを記述します。
         !
         real, pointer :: var(:) =>null() ! Comments block for the variables.
         integer       :: num = 0
       end type MULTI_ARRAY

     contains

       subroutine hoge( in,   &   ! Comment blocks between continuation lines are ignored.
           &            out )
         !
         ! Comment blocks for the subroutines or functions
         !
         character(*),intent(in):: in ! Comment blocks for the arguments.
         character(*),intent(out),allocatable,target  :: in
                                      ! Comment blocks can be
                                      ! written under Fortran statements.

         character(32) :: file ! This comment parsed as a variable in below NAMELIST.
         integer       :: id

         namelist /varinfo_nml/ file, id
                 !
                 ! Comment blocks for the NAMELISTs.
                 ! Information about variables are described above.
                 !

       ....

       end subroutine hoge

       integer function foo( in )
         !
         ! This part is considered as comment block.

         ! Comment blocks under blank lines are ignored.
         !
         integer, intent(in):: inA ! This part is considered as comment block.

                                   ! This part is ignored.

       end function foo

       subroutine hide( in,   &
         &              out )      !:nodoc:
         !
         ! If "!:nodoc:" is described at end-of-line in subroutine
         ! statement as above, the subroutine is ignored.
         ! This assignment can be used to modules, subroutines,
         ! functions, variables, constants, derived-types,
         ! defined operators, defined assignments,
         ! list of imported modules ("use" statement).
         !

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

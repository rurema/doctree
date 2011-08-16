Fortran95 のソースコードを解析するためのサブライブラリです。

拡張子が f90、F90、f95、F95 のファイルを解析する事ができます。解析のた
めには、Fortran95 の仕様に適合している必要があります。

=== Rules

Fundamental rules are same as that of the Ruby parser.
But comment markers are '!' not '#'.

==== Correspondence between RDoc documentation and Fortran95 programs

"parse_f95.rb" parses main programs, modules, subroutines, functions,
derived-types, public variables, public constants,
defined operators and defined assignments.
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

==== Information parsed automatically

The following information is automatically parsed.

 * Types of arguments
 * Types of variables and constants
 * Types of variables in the derived types, and initial values
 * NAMELISTs and types of variables in them, and initial values

Aliases by interface statement are described in the item of 'Methods'.

Components which are imported from other modules and published again
are described in the item of 'Methods'.

==== Format of comment blocks

Comment blocks should be written as follows.
Comment blocks are considered to be ended when the line without '!'
appears.
The indentation is not necessary.

     ! (Top of file)
     !
     ! Comment blocks for the files.
     !
     !--
     ! The comment described in the part enclosed by
     ! "!--" and "!++" is ignored.
     !++
     !
     module hogehoge
       !
       ! Comment blocks for the modules (or the programs).
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
         ! Comment blocks for the derived-types.
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

= class RDoc::Fortran95parser

extend RDoc::ParserFactory

== Constants

--- COMMENTS_ARE_UPPER -> false

ライブラリの内部で使用します。

--- INTERNAL_ALIAS_MES -> "Alias for"

ライブラリの内部で使用します。

--- EXTERNAL_ALIAS_MES -> "The entity is"

ライブラリの内部で使用します。

== Class Methods

--- new(top_level, file_name, body, options, stats) -> RDoc::Fortran95parser

自身を初期化します。

@param top_level [[c:RDoc::TopLevel]] オブジェクトを指定します。

@param file_name ファイル名を文字列で指定します。

@param body ソースコードの内容を文字列で指定します。

@param options [[c:RDoc::Options]] オブジェクトを指定します。

@param stats [[c:RDoc::Stats]] オブジェクトを指定します。

== Instance Methods

--- scan -> RDoc::TopLevel

define code constructs

@return RDoc::TopLevel オブジェクトを返します。

= Ruby/Tk と Tcl/Tk, Perl/Tk, Python Tkinterなどとの違い

== Ruby/Tk と Tcl/Tk との違いはどこですか？

: 依存関係のある widget の生成方法
  ScrollBar と ListBox, Text, Canvas

: TkVariable

: スコープ

: 評価タイミング


== Ruby/Tk と Tcl/Tk との違い一覧は？

    what              Tcl/Tk                 Ruby/Tk
    variable          set a 123              a = 123 or a = '123'
     initialization
    re-assignment     set b $a               b = a.dup

    lists/arrays      set a {1 2 fred 7.8}   a = [1, 2, 'fred', 7.8]
    re-assignment     set b $a               b = a.dup

    associative       set a(Jan) 456.02      a = {'Jan' => 456.02, 'Feb' => 534.96}
    arrays            set a(Feb) 534.96
                      or
                      array set a {Jan 456.02 Feb 534.96}
    re-assignment     foreach i \            b = a.dup
                       [array names a] {
                       set b($i) = $a($i) }
                      or
                      array set b [array get a]

    expressions       set a [expr $b+$c]     a = b + c

    increment         incr i                 i += 1

    declare           proc plus {a b} {      def plus(a, b)
     subroutines       expr $a + $b }            return a + b
                                             end

    variable scope    local default          local default
                       override w/ "global"   

    call              plus 1 2               plus(1,2)
     subroutines                             

    statement sep     newline or at ";"      newline or at ";"

    statement         "\" - newline          none required
     continuation

    verbatim strings  {}                     ''
     e.g.             {a \ lot@ of $stuff}   'a \ lot@ of $stuff'

    escaped strings   ""                     ""
     e.g.             "Who\nWhat\nIdunno"    "Who\nWhat\nIdunno"

    STDOUT            puts "Hello World!"    print "Hello!\n"
                      puts stdout "Hello!"   STDOUT.print "Hello World!\n"


== Ruby/Tk と Perl/Tk との違いはどこですか？

* Ruby/Tk では一部のメソッドが同じ名前でスーパークラスで定義されてしまっており、別名のメソッド名となっている。((-変-))
  type
* Ruby/Tk では変数のやり取りに TkVariable クラスを使用する
* Tcl/Tk でコマンドを2つ以上使っているメソッド名の違い
* Perl/Tk は Perl5 の機能を知らないと使うのがつらい
* Perl/Tk は Tcl/Tk とは独立したプログラムとなっていて一部 Tix の機能が使える
* Perl/Tk は本が出版されている

== Ruby/Tk と Perl/Tk との違い一覧は？

    what              Perl/Tk                     Ruby/Tk
    variable          $a = 123; or $a = '123';    a = 123 or a = '123'
     initialization
    re-assignment     $b = $a;                    b = a.dup

    lists/arrays      @a = (1,2,'fred',7.8);      a = [1, 2, 'fred', 7.8]
    re-assignment     @b = @a;                    b = a.dup

    associative       %a = ('Jan',456.02,         a = {'Jan' => 456.02, 'Feb' => 534.96}
     arrays            'Feb',534.96);
    re-assignment     %b = %a;                    b = a.dup
                  
    expressions       $a = $b+$c;                 a = b + c

    increment         $i++; or ++$i;              i += 1

    declare           sub plus { my($a,$b) = @_;  def plus(a, b)
     subroutines       $a+$b; }                    return a + b
                                                  end

    variable scope    global default              local default
                       override w/ "my" (or "local")

    call              &plus(1,2); #or             plus(1,2)
     subroutines       plus(1,2);  #OK after sub plus

    statement sep     ";" required                newline or at ";"

    statement         none required               none required
     continuation

    verbatim strings  ''                          ''
     e.g.             'a \ lot@ of $stuff'        'a \ lot@ of $stuff'

    escaped strings   ""                          ""
     e.g.             "Who\nWhat\nIdunno"         "Who\nWhat\nIdunno"

    STDOUT            print "Hello World!\n"      print "Hello World!\n"
                      STDOUT "Hello!\n"           STDOUT.print "Hello World!\n"

== Ruby/Tk と Python Tkinter との違いはどこですか？

* Python Tkinter は定数定義 Tkconstants.py があるが、Ruby/Tk にはない
* Python Tkinter は PMW (Python Mega Widgets) などが整備されている
* Python Tkinter は本が出版されている(英語)

== Ruby/Tk と Python Tkinter との違い一覧は？

= 環境変数

Rubyインタプリタは以下の環境変数を参照します。

: RUBYOPT
 Rubyインタプリタにデフォルトで渡すオプションを指定します。

 指定できないオプションを指定した場合、例外が発生します。

#@since 1.9.1
//emlist{
$ RUBYOPT=-y ruby -e ""
ruby: invalid switch in RUBYOPT: -y (RuntimeError)
//}
#@else
//emlist{
$ RUBYOPT=-y ruby e ""
ruby: illegal switch in RUBYOPT: -y (RuntimeError)
//}
#@end

 sh系

//emlist{
      RUBYOPT='-Ke -rkconv'
      export RUBYOPT
//}

 csh系

//emlist{
      setenv RUBYOPT '-Ke -rkconv'
//}

 MS-DOS系

//emlist{
      set RUBYOPT=-Ke -rkconv
//}

: RUBYPATH

  -S オプション指定時に、環境変数 PATH による
  Ruby スクリプトの探索に加えて、この環境変数で指定したディレクトリも
  探索対象になります。(PATH の値よりも優先します)。
  起動オプションの詳細に関しては[[d:spec/rubycmd]] を参照してください。

  sh系

//emlist{
      RUBYPATH=$HOME/ruby:/opt/ruby
      export RUBYPATH
//}

  csh系

//emlist{
      setenv RUBYPATH $HOME/ruby:/opt/ruby
//}

  MS-DOS系

//emlist{
      set RUBYPATH=%HOMEDRIVE%%HOMEPATH%\ruby;\opt\ruby
//}

: RUBYLIB

  Rubyライブラリの探索パス[[m:$:]]のデフォル
  ト値の前にこの環境変数の値を付け足します。

  sh系

//emlist{
      RUBYLIB=$HOME/ruby/lib:/opt/ruby/lib
      export RUBYLIB
//}

  csh系

//emlist{
      setenv RUBYLIB $HOME/ruby/lib:/opt/ruby/lib
//}

  MS-DOS系

//emlist{
      set RUBYLIB=%HOMEDRIVE%%HOMEPATH%\ruby\lib;\opt\ruby\lib
//}

: RUBYLIB_PREFIX

#@since 1.9.1
  この環境変数は [[d:platform/Cygwin]]版、[[d:platform/mswin32]]版、
  [[d:platform/mingw32]]版のrubyでのみ有効です。
#@else
  この環境変数は [[d:platform/DJGPP]]版、[[d:platform/Cygwin]]版、[[d:platform/mswin32]]版、
  [[d:platform/mingw32]]版のrubyでのみ有効です。
#@end

  この環境変数の値は、path1;path2 あるいは path1 path2 という形式で、
  Rubyライブラリの探索パス[[m:$:]]の先頭部分
  がpath1にマッチした場合に、これをpath2に置き換えます。
  現在の実装ではライブラリのパスの prefix を ruby.exe や ruby.dll のあ
  る位置から相対的に求めるのでこの環境変数の必要性はなくなっています。

  MS-DOS系

//emlist{
      set RUBYLIB_PREFIX=/usr/local/lib/ruby;d:/ruby
//}

: RUBYSHELL

#@since 1.9.1
  この環境変数は [[d:platform/mswin32]]版、[[d:platform/mingw32]]版のrubyで
  のみ有効です。
#@else
  この環境変数は [[d:platform/OS2]]版、[[d:platform/mswin32]]版、[[d:platform/mingw32]]版のrubyで
  のみ有効です。
#@end

  [[m:Kernel.#system]] でコマンドを実行するときに使用するシェル
  を指定します。この環境変数が省略されていればCOMSPECの値を
  使用します。

: PATH

  [[m:Kernel.#system]]などでコマンドを実行するときに検索するパスです。
  設定されていないとき(nilのとき)は
  "/usr/local/bin:/usr/ucb:/usr/bin:/bin:."
  で検索されます。

###nonref

= 環境変数

Rubyインタプリタは以下の環境変数を参照します。


: (({RUBYOPT}))

  Rubyインタプリタにデフォルトで渡すオプションを指定します。

  * (({sh系}))

      RUBYOPT='-Ke -rkconv'
      export RUBYOPT

  * (({csh系}))

      setenv RUBYOPT '-Ke -rkconv'

  * (({MS-DOS系}))

      set RUBYOPT=-Ke -rkconv

: (({RUBYPATH}))

  ((<Rubyの起動/-S>)) オプション指定時に、環境変数 (({PATH})) による 
  Ruby スクリプトの探索に加えて、この環境変数で指定したディレクトリも
  探索対象になります。((({PATH})) の値よりも優先します)。

  * (({sh系}))

      RUBYPATH=$HOME/ruby:/opt/ruby
      export RUBYPATH

  * (({csh系}))

      setenv RUBYPATH $HOME/ruby:/opt/ruby

  * (({MS-DOS系}))

      set RUBYPATH=%HOME%\ruby:\opt\ruby

: (({RUBYLIB}))

  Rubyライブラリの探索パス((<組み込み変数/$:>))のデフォル
  ト値の前にこの環境変数の値を付け足します。

  * (({sh系}))

      RUBYLIB=$HOME/ruby/lib:/opt/ruby/lib
      export RUBYLIB

  * (({csh系}))

      setenv RUBYLIB $HOME/ruby/lib:/opt/ruby/lib

  * (({MS-DOS系}))

      set RUBYLIB=%HOME%\ruby\lib:\opt\ruby\lib

: (({RUBYLIB_PREFIX}))

  この環境変数は ((<DJGPP>))版、((<Cygwin>))版、((<mswin32>))版、
  ((<mingw32>))版のrubyでのみ有効です。

  この環境変数の値は、path1;path2 あるいは path1 path2 という形式で、
  Rubyライブラリの探索パス((<組み込み変数/$:>))の先頭部分
  がpath1にマッチした場合に、これをpath2に置き換えます。
  ((-現在の実装ではライブラリのパスの prefix を ruby.exe や ruby.dll のある位置から
  相対的に求めるのでこの環境変数の必要性はなくなっています-))

  * (({MS-DOS系}))

      set RUBYLIB_PREFIX=/usr/local/lib/ruby;d:/ruby

: (({RUBYSHELL}))

  この環境変数は ((<OS2>))版、((<mswin32>))版、((<mingw32>))版のrubyで
  のみ有効です。

  ((<組み込み関数/system>)) でコマンドを実行するときに使用するシェル
  を指定します。この環境変数が省略されていれば(({COMSPEC}))の値を
  使用します。

: (({PATH}))

  ((<組み込み関数/system>))などでコマンドを実行するときに検索するパスです。
  設定されていないとき(nilのとき)は
  (({"/usr/local/bin:/usr/ucb:/usr/bin:/bin:."}))
  で検索されます。

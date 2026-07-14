# 環境変数

Rubyインタプリタは以下の環境変数を参照します。

- **`RUBYOPT`**:
 Rubyインタプリタにデフォルトで渡すオプションを指定します。

 指定できないオプションを指定した場合、例外が発生します。

```console
$ RUBYOPT=-y ruby -e ""
ruby: invalid switch in RUBYOPT: -y (RuntimeError)
```

 sh系

```console
      RUBYOPT='-Ke -rkconv'
      export RUBYOPT
```

 csh系

```console
      setenv RUBYOPT '-Ke -rkconv'
```

 MS-DOS系

```console
      set RUBYOPT=-Ke -rkconv
```

- **`RUBYPATH`**:

  -S オプション指定時に、環境変数 PATH による
  Ruby スクリプトの探索に加えて、この環境変数で指定したディレクトリも
  探索対象になります。(PATH の値よりも優先します)。
  起動オプションの詳細に関しては[d:spec/rubycmd] を参照してください。

  sh系

```console
      RUBYPATH=$HOME/ruby:/opt/ruby
      export RUBYPATH
```

  csh系

```console
      setenv RUBYPATH $HOME/ruby:/opt/ruby
```

  MS-DOS系

```console
      set RUBYPATH=%HOMEDRIVE%%HOMEPATH%\ruby;\opt\ruby
```

- **`RUBYLIB`**:

  Rubyライブラリの探索パス[m:$:]のデフォル
  ト値の前にこの環境変数の値を付け足します。

  sh系

```console
      RUBYLIB=$HOME/ruby/lib:/opt/ruby/lib
      export RUBYLIB
```

  csh系

```console
      setenv RUBYLIB $HOME/ruby/lib:/opt/ruby/lib
```

  MS-DOS系

```console
      set RUBYLIB=%HOMEDRIVE%%HOMEPATH%\ruby\lib;\opt\ruby\lib
```

- **`RUBYSHELL`**:

  この環境変数は [d:platform/mswin32]版、[d:platform/mingw32]版のrubyで
  のみ有効です。

  [m:Kernel?.system] でコマンドを実行するときに使用するシェル
  を指定します。この環境変数が省略されていればCOMSPECの値を
  使用します。

- **`PATH`**:

  [m:Kernel?.system]などでコマンドを実行するときに検索するパスです。
  設定されていないとき(nilのとき)は
  "/usr/local/bin:/usr/ucb:/usr/bin:/bin:."
  で検索されます。

- **`RUBY_GC_*`**:

  [ref:c:GC#tuning_gc] を参照。

- **`RUBY_THREAD_VM_STACK_SIZE`**:

  スレッド生成時に使用される VM スタックのサイズをバイト数で指定します。

- **`RUBY_THREAD_MACHINE_STACK_SIZE`**:

  スレッド生成時に使用されるマシンスタックのサイズをバイト数で指定します。

- **`RUBY_FIBER_VM_STACK_SIZE`**:

  Fiber 生成時に使用される VM スタックのサイズをバイト数で指定します。

- **`RUBY_FIBER_MACHINE_STACK_SIZE`**:

  Fiber 生成時に使用されるマシンスタックのサイズをバイト数で指定します。

  これらのスタックサイズ関連の環境変数は実装依存であり、Ruby のバージョンによって
  変更される可能性があります。値を小さくすることでより多くの Fiber や Thread を
  同時に実行できるようになる場合がありますが、[c:SystemStackError] やセグメンテー
  ション違反が発生しやすくなります。

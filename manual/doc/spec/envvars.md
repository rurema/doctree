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
  探索対象になります(PATH の値よりも優先します)。
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

#%since 3.3
- **`RUBY_MN_THREADS`**:

#%end
#%version 3.3...4.1
  `1` を設定すると main [c:Ractor] で M:N スレッドスケジューラが有効になります。デフォルトは未設定です。

#%end
#%since 4.1
  M:N スレッドスケジューラの動作を、以下の値で指定します。デフォルトは未設定(`0` と同じ)です。

  `-1` を設定すると、すべてのスレッドが 1:1 で動作します(main 以外の [c:Ractor] のスレッドも M:N になりません)。

  `0` または未設定では、main 以外の [c:Ractor] のスレッドだけが M:N で動作します。メインスレッドと main [c:Ractor] の他のスレッドは 1:1 です。

  `1` を設定すると、メインスレッド以外のすべてのスレッド(main [c:Ractor] の他のスレッドと、main 以外の [c:Ractor] のスレッド)が M:N で動作します。

  `2` を設定すると、メインスレッドを含むすべてのスレッドが M:N で動作します。

  `-1` と `2` は Ruby 4.1 で追加されました。

  `2` を指定すると、メインスレッドも他の M:N スレッドと同様に再開されるため、メインスレッドが処理を駆動するプログラムで効果があります。ただしメインスレッドが 1 つの OS スレッドに固定されなくなるので、OS スレッドごとに状態を持つ C 拡張は `rb_thread_lock_native_thread()` を呼ぶ必要があります。また、プロセスの最初のスレッドで動かす必要があるもの(macOS の AppKit や CFRunLoop、Ruby を組み込んで自前のメインループに戻るホストなど)は動作しません。

  Ruby 4.1 から、M:N スレッドでは OS スレッド名を Ruby のスレッドから設定しません。

#%end
#%since 3.3
- **`RUBY_MAX_CPU`**:

  M:N スレッドスケジューラが使うネイティブスレッドの最大数を指定します。デフォルトはオンラインの CPU 数です。main 以外の [c:Ractor] は M:N スレッドスケジューラを使うので、main 以外の [c:Ractor] が使うネイティブスレッドの最大数にもなります。

- **`RUBY_FREE_AT_EXIT`**:

  設定すると、終了時に動的に確保したメモリをすべて解放しようとします。デフォルトは未設定です。

#%end
#%since 3.4
- **`RUBY_THREAD_TIMESLICE`**:

  スレッドのタイムスライス(quantum)のデフォルトをミリ秒で指定します。デフォルトは 100 ミリ秒です。

#%end
#%since 3.0
- **`RUBY_PAGER`**:

  `--help` の出力に使うページャコマンドを指定します。デフォルトは環境変数 `PAGER` の値です。起動オプションの詳細に関しては [d:spec/rubycmd] を参照してください。

#%end
#%since 4.0
- **`RUBY_BOX`**:

  `1` を設定すると [c:Ruby::Box] が有効になり、[m:Ruby::Box.new] が使えるようになります。実験的な機能です。

#%end
#%since 3.1
- **`RUBY_IO_BUFFER_DEFAULT_SIZE`**:

  [c:IO::Buffer] のデフォルトのバッファサイズを指定します。

#%end
#%since 3.3
- **`RUBY_CRASH_REPORT`**:

  クラッシュレポートを保存するパス名のテンプレートを指定します。デフォルトは指定なしです。起動オプション `--crash-report=template` と同じ意味です([d:spec/rubycmd] を参照)。[feature:19790]

  テンプレートには以下の指定子を使えます。
  ```text
      %%    % そのもの
      %e    実行ファイルの basename
      %E    実行ファイルのパス名(/ は ! に置換されます)
      %f    プログラム名 $0 の basename
      %F    プログラム名 $0 のパス名(/ は ! に置換されます)
      %p    プロセス ID
      %t    ダンプした時刻(エポックからの秒数)
      %NNN  8 進数の文字コード
  ```

  末尾の単独の `%` と、上記以外の文字が続く `%` は捨てられます。`/` はディレクトリの区切りとして解釈されます。

  テンプレートの先頭が `|` の場合は、その後ろをコマンドラインとして実行し、レポートをパイプで渡します(テンプレートの展開前に空白で引数に分割されます)。

#%end
#%since 3.1
- **`RUBY_YJIT_ENABLE`**:

  設定すると、YJIT を有効にして起動します。YJIT を組み込まずにビルドした Ruby では効果がありません。[c:RubyVM::YJIT] も参照してください。

#%end
#%since 4.0
- **`RUBY_ZJIT_ENABLE`**:

  設定すると、ZJIT を有効にして起動します。[c:RubyVM::ZJIT] も参照してください。

#%end
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

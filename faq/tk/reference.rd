= Ruby/Tk インストール

== Ruby/Tk をソースからインストールするにはどうしたら良いですか？

まず、Tcl/Tk をシステムにインストールしてください。このとき、
コンパイルに必要なヘッダやライブラリもインストールするように
してください(使用するバイナリパッケージによってはヘッダ等は
開発パッケージとして別にインストールする必要があるかも知れま
せん)

注意として、現在の Ruby/Tk では、もはや Tcl/Tk のバージョン 
8.0 より以前のものはメンテの対象になっていないことに注意して
ください(動くかもしれませんけど)

ruby を build するときの configure のオプションに以下を含め
てください(これらの指定はある程度自動検出されますが、Tcl/Tk 
のバージョンやインストール形態は様々なので、すべてに対応でき
ていません)

    ./configure --with-tcllib=tcl8.3 \
                --with-tklib=tk8.3 \
                --with-tcl-include=/usr/include/tcl8.3
                --with-X11-include=/usr/X11R6/include

--with-tcllib=XXX にはシステムに存在する libtclXXX.so や 
libtclXXX.a の tclXXX の部分を、

--with-tklib=XXX にはシステムに存在する libtkXXX.so や 
libtkXXX.a の tkXXX の部分を指定します。XXX の部分にはよく
Tcl/Tk のバージョンを示す番号が付加されています。

--with-tcl-include=XXX には、tcl のヘッダファイルのあるパス
を指定します。標準の /usr/include 等に置かれている場合には必
要ありません。もし、tk のヘッダファイルがこれとは別の場所に
あるなら --with-tk-include=XXX も合わせて指定する必要があり
ます。

tk のヘッダは X Window System のヘッダファイルを(たとえ、MS
Windows 環境であっても)読もうとします。このヘッダが見つから
ない場合は、--with-X11-include=XXX の XXX 部分に X のヘッダ
ファイルのあるディレクトリを指定します。
(このため、Cygwin 環境で Ruby/Tk をコンパイルするには、XFree86 もイン
ストールする必要があります。ただ、後述する bitWalk の Tcl/Tk 
パッケージには X のヘッダファイルが含まれているのでこの必要
はありません)

Tcl/Tk が Stub 機能を持つ場合(Tcl/Tk 8.1 以降)上記の代わりに
以下のように指定することを推奨します。

    ./configure --enable-tcltk_stubs \
                --with-tcl-include=/usr/include/tcl8.3 \
                --with-tcllib=tclstub83 \
                --with-tklib=tkstub83 \
                --with-X11-include=/usr/X11R6/include

--enable-tcltk_stubs により、Stub を使うことを明示します。

--with-tcllib=XXX にはシステムに存在する libtclstubXXX.so や 
libtcstublXXX.a の tclstubXXX の部分を、

--with-tklib=XXX にはシステムに存在する libtkstubXXX.so や 
libtkstubXXX.a の tkstubXXX の部分を指定します。

後は、いつものように
  make
  make test
  make install
してください。

=== Cygwin 版の場合

cygwin のデフォルトで入っているかもしれない tcl8.0 では Stub が使えず、
また日本語化がなされていません。

これを動作させるには、TCL_LIBRARY 環境変数を適切に設定する必要がありま
す。((*この環境変数は Windows 形式のパスを指定する必要があります*))

    $ export TCL_LIBRARY=`cygpath -w /usr/share/tcl8.0`
    $ ruby -Ks -rtk -e 'TkButton.new(nil, "text"=>"てすと") {
                command { puts "てすと" }
        }.pack' -e Tk.mainloop    

以上のことから、Tcl/Tk 8.1 以降(国際化対応されています)のバイナリパッケージを別途
インストールすることを推奨します。

bitWalkの Tcl/Tkを使用する ruby を cygwin 環境で作成するには
以下のようにします。(上で説明してる「Ruby/Tk をソースからインストールするには...」
も参照してください)

    (bitWalk の Tcl/Tk パッケージを d:\Tcl にインストールしたとする)

    $ cd ruby/ext/tcltklib
    $ ruby extconf.rb --with-{tcl,tk}-dir=/cygdrive/d/tcl \
                      --enable-tcltk_stubs \
                      --with-tcllib=tclstub83 \
                      --with-tklib=tkstub83
    (configure 時に上記オプションを追加で指定しても良い)

    $ PATH=/cygdrive/d/Tcl/bin:$PATH
    (または)
      $ export RUBY_TCL_DLL=`cygpath -w /cygdrive/d/Tcl/bin/tcl83.dll`
      $ export RUBY_TK_DLL=`cygpath -w /cygdrive/d/Tcl/bin/tk83.dll`

    $ ruby -Ks -rtk -e 'TkButton.new(nil, "text"=>"てすと") {
                command { puts "てすと" }
        }.pack' -e Tk.mainloop    

== Ruby/Tk のバイナリはありますか？

=== UNIX 系 OS の場合

((<Ruby インストールガイド|URL:http://www.ruby-lang.org/ja/install.html>))を参考にして下さい。

=== Windows の場合

例えば、以下の組合せの場合
* ((<URL:http://www.ruby-lang.org/~eban/ruby/binaries/cygwin/>))
* ((<URL:http://members10.tsukaeru.net/bitwalk/download_win.html>))

以下のようにすれば動作します

Cygwin 環境の ruby からのみ Tcl を使用する場合(必要なライブラリ、DLLをコピー)

* c:/Program Files/Tcl/lib 内のファイルやディレクトリを c:/usr/local/lib にコピー
* c:/Program Files/Tcl/bin の tcl83.dll, tk83.dll を c:/windows/system にコピー
* 後は、インストールした Tcl/Tk をアンインストールしてもよい

普通に Tcl/Tk も使いたい場合

* c:/Program Files/Tcl/bin をPATHに含める

あるいは、

* 環境変数 RUBY_TCL_DLL, RUBY_TK_DLL を tcl83.dll, tk83.dll のあるパス
  に設定する(Windows 形式のパスで設定すること)

  Windows から(autoexec.bat に設定するなど)

    set RUBY_TCL_DLL=c:\Program Files\Tcl\bin\tcl83.dll
    set RUBY_TK_DLL=c:\Program Files\Tcl\bin\tk83.dll

  Cygwin から(~/.bashrc に設定するなど)

    export RUBY_TCL_DLL=`cygpath -w /cygdrive/c/Program\ Files/Tcl/bin/tcl83.dll`
    export RUBY_TK_DLL=`cygpath -w /cygdrive/c/Program\ Files/Tcl/bin/tk83.dll`


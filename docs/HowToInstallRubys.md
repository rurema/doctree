手元の環境に複数のバージョンのrubyをインストールしておくと、どのメソッドがどのバージョンから
利用可能になったかなどの調査に役立ちます。
以下では複数のバージョンのrubyをインストールして共存させる方法を解説します。

## Windows

### バイナリ
1.8系のリリース版については、mswin32版のバイナリパッケージを利用するのが最も簡単です。

* http://www.garbagecollect.jp/ruby/mswin32/ja/download/release.html (2013-08-29現在はRuby2.0等に対応していない)

上記のページから入手可能です。

あとは、それぞれのアーカイブを別のディレクトリに展開すれば共存可能です。

* http://rubyinstaller.org/

こちらでも zip で入手可能です。MinGWでビルドされています。

### ビルド

ソースコードからのビルド方法については [[HowToInstallRubysWindows]] を参照してください。

## Unix系

### rbenv を使う方法

長いので別ページ [[HowToInstallRubysUnixRbenv]] を用意しました。

### RVM を使う方法
[RVM: Ruby Version Manager - RVM Ruby Version Manager - Documentation](http://rvm.beginrescueend.com/) を使う方法を説明します。

[wayneeseguin's rvm at master - GitHub](http://github.com/wayneeseguin/rvm) から最新版をインストールしてください。
Gem コマンドでインストールすることもできますが rvm-install が動かないことがあるので以下の方法でインストールしてください。

```
$ git clone git://github.com/wayneeseguin/rvm.git
$ cd rvm
$ ./install
```

これで ~/.rvm 以下に RVM がインストールできました。
~/.zshrc か ~/.bashrc に以下を追記してください。

```
if [[ -s $HOME/.rvm/scripts/rvm ]] ; then source $HOME/.rvm/scripts/rvm ; fi
```

追記したらシェルを再起動してください。
また、ドキュメントをインストールしないために以下の設定を ~/.rvm/config/user に追加しておくとビルドにかかる時間が短かくなるのでおすすめです。
rvm install -C オプションを使うと同じようなことができますが、毎回オプションを指定するのは面倒です。

```
ruby_configure_flags=--enable-shared --disable-install-doc
```

以下のコマンドで複数の Ruby をインストールすることができます。

```
$ rvm install 1.9.2
$ rvm install 1.9.1
$ rvm install 1.8.7
$ rvm install 1.8.6
```

複数の Ruby をインストールしたら以下のコマンドで RVM でインストールした全ての Ruby に対してスクリプトを実行できます。

```
$ rvm hoge.rb
$ rvm ruby hoge.rb
$ rvm ruby -v hoge.rb
$ rvm ruby -v -e 'puts :hello'
```

3,4 番目の方法で行うと Ruby のバージョンが表示されるので便利です。

### prefix ごと分ける方法

prefix ごと分ける方法を説明します。
ここでは仮に /usr/local/pkg/ruby-1.8.x 以下にインストールするとしましょう。

```
~/src/ruby-1.8.0 $ ./configure --prefix=/usr/local/pkg/ruby-1.8.0
~/src/ruby-1.8.0 $ make
~/src/ruby-1.8.0 $ sudo make install
~/src/ruby-1.8.0 $ sudo ln -s ../pkg/ruby-1.8.0/bin/ruby /usr/local/bin/ruby-1.8.0
```

最後の ln -s がポイントです。
いちいち PATH を通すのは面倒なので、
ruby だけ /usr/local/bin に集めてしまいます。

あとは 1.8.x すべてで同じことをすれば終わりです。
以下のようなシェルスクリプトを書いてサクッと終わらせることもできます。

```
for rev in 0 1 2 3 4 5
do
   cd $HOME/src/ruby-1.8.$rev
   ./configure --prefix=/usr/local/pkg/ruby-1.8.$rev
   make
   sudo make install
   sudo ln -s ../pkg/ruby-1.8.$rev/bin/ruby /usr/local/bin/ruby-1.8.$rev
done
```

### configure.in を書き換える方法

Ruby 1.8.x がインストールされる場所は、

```
/usr/local/bin
/usr/local/lib/ruby/1.8/
```

の2箇所です。
なので戦略としては、「/usr/local/bin」にインストールされるものには「-1.8.x」というsuffixを付けます。
そしてライブラリのインストール先を「/usr/local/lib/ruby/1.8/」から「/usr/local/lib/ruby/1.8.x/」
に変えます。これで、複数のバージョンのrubyを共存させることが出来ます。

ruby 1.8.2 以降では、configure.inとmkconfig.rbを変更するだけです。
configure.in では以下のように2箇所変更します。行番号はバージョンにより異なるかも知れません。

```
# diff
--- configure.in~
+++ configure.in
@@ -1443,3 +1443,3 @@
 esac
-RUBY_LIB_PATH="${RUBY_LIB_PREFIX}/${MAJOR}.${MINOR}"
+RUBY_LIB_PATH="${RUBY_LIB_PREFIX}/${MAJOR}.${MINOR}.${TEENY}"

@@ -1457,3 +1457,3 @@
 esac
-RUBY_SITE_LIB_PATH2="${RUBY_SITE_LIB_PATH}/${MAJOR}.${MINOR}"
+RUBY_SITE_LIB_PATH2="${RUBY_SITE_LIB_PATH}/${MAJOR}.${MINOR}.${TEENY}"
```

mkconfig.rbは1箇所のみです。

```
# diff
--- mkconfig.rb~
+++ mkconfig.rb
@@ -108,3 +108,3 @@
 print <<EOS
-  CONFIG["ruby_version"] = "$(MAJOR).$(MINOR)"
+  CONFIG["ruby_version"] = "$(MAJOR).$(MINOR).$(TEENY)"
   CONFIG["rubylibdir"] = "$(libdir)/ruby/$(ruby_version)"
```

後は、autoconfを実行してconfigureファイルを作成し

```
$ autoconf
$ ./configure --program-suffix=-1.8.x
```

configureに上のようなオプションを付けて実行します。
そして、

```
$ make
$ make test
$ (su)
# make install-nodoc
```

です。rdocはこの方法では同じディレクトリにインストールしてしまうので、
install-nodocでインストールして下さい。

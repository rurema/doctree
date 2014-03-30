rbenv + ruby-build
===================

この記事に載っているソフトウェアのバージョンは随時変わる可能性があるので定期的に更新が必要です。

## はじめに

本記事の流れ

1. git のインストール
2. 最新版rbenv のインストール
3. ruby-buildのインストール
4. いろいろなバージョンのrubyのインストール
5. rbenvの使い方
6. るりま執筆用に便利なpluginの紹介
7. rbenv + ruby-buildのアンインストール

各ソフトウェアをLinuxのディストリビューションが提供している場合はパッケージ管理システム((-apt-get,yum等-))を用いる事によりrbenvとruby-buildがインストールできます。

ここでは、Ubuntu 12.04 LTS、bash環境を使用し、執筆時点での最新版のrbenvとruby-buildをインストールします。

## git をインストール
rbenvはgitを使ってインストールするのが簡単なのでgitをインストールします。

### 簡単な方法

```
$ sudo apt-get install git
or
$ sudo yum install git
```

### ソースファイルからインストール
ここでは解説しませんが、例えば、「git install」をキーワードにして検索すると上位に有用な記事がたくさんあります。

## 最新版rbenvのインストール

[sstephenson/rbenv](https://github.com/sstephenson/rbenv)が配布元のサイトであり、インストールについて参考になります。

本記事では適当なディレクトリに"wk_rurema" ディレクトリをつくりその中にファイルを作成します。
インストール先を"~/.rbenv"等に変更する場合は該当する部分を変更してください。
また環境変数は~/.bashrcに設定していますが、
お使いのシステム環境に応じて~/.bash_profile, ~/.profileであったりします。

```
$ git clone git://github.com/sstephenson/rbenv.git ~/wk_rurema/rbenv
Cloning into '/home/kouya/wk_rurema/rbenv'...
remote: Counting objects: 1631, done.
remote: Compressing objects: 100% (662/662), done.
remote: Total 1631 (delta 1050), reused 1460 (delta 937)
Receiving objects: 100% (1631/1631), 235.72 KiB | 139 KiB/s, done.
Resolving deltas: 100% (1050/1050), done.
```

### rbenv の環境変数の設定

rbenvのディレクトリにあるREADME.mdの指示を参考にして
環境変数PATH 及び rbenvの初期化について設定します。
また、rbenvのディレクトリの位置を示すRBENV_ROOTの設定も行います。

```
$ echo 'export PATH="~/wk_rurema/rbenv/bin/:$PATH"' >> ~/.bashrc
$ echo 'export RBENV_ROOT=~/wk_rurema/rbenv' >> ~/.bashrc
$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
$ source ~/.bashrc
```

本記事を執筆した時点では、バージョン 0.4.0をインストールできました。
この時点ではrbenvのサブコマンドにまだ "install" が無いことに注意してください。

```
$ rbenv
rbenv 0.4.0-48-g5130b41
Usage: rbenv <command> [<args>]

Some useful rbenv commands are:
commands List all available rbenv commands
local Set or show the local application-specific Ruby version
global Set or show the global Ruby version
shell Set or show the shell-specific Ruby version
rehash Rehash rbenv shims (run this after installing executables)
version Show the current Ruby version and its origin
versions List all Ruby versions available to rbenv
which Display the full path to an executable
whence List all Ruby versions that contain the given executable
```

## ruby-buildのインストール

git経由でruby-buildを入手します。

```
$ git clone https://github.com/sstephenson/ruby-build.git ~/wk_rurema/rbenv/plugins/ruby-build
```

rbenvのサブコマンド群の中に"install"が追加されているならばruby-buildのインストールは成功です。

```
$ rbenv
rbenv 0.4.0-48-g5130b41
Usage: rbenv <command> [<args>]

(略)
install Install a Ruby version using the ruby-build plugin
uninstall Uninstall a specific Ruby version
(略)

See `rbenv help <command>' for information on a specific command.
For full documentation, see: https://github.com/sstephenson/rbenv#readme
```

## いろいろなバージョンのrubyのインストール

下記コマンドでruby-buildでインストールできる2.0.0の種類を知ることができます。

```
$ rbenv install 2.0.0
(中略)

The following versions contain `2.0.0' in the name:
2.0.0-dev
2.0.0-p0
2.0.0-p195
2.0.0-preview1
2.0.0-preview2
2.0.0-rc1
2.0.0-rc2
maglev-2.0.0-dev
rbx-2.0.0-dev
rbx-2.0.0-rc1

(後略)
```

ここでは執筆時点で最新のパッチレベルである2.0.0-p195をインストールしてみましょう。

```
$ rbenv install 2.0.0-p195
Downloading ruby-2.0.0-p195.tar.gz...
-> http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p195.tar.gz
Installing ruby-2.0.0-p195...
Installed ruby-2.0.0-p195 to /home/kouya/wk_rurema/rbenv/versions/2.0.0-p195
```

ここでOpenssl ライブラリが無い場合はエラーがでるかもしれません。
その場合は例えば下記コマンドでインストールしましょう。

```
$ sudo apt-get install libssl-dev
```

なお、以下のコマンドでインストール可能なRubyのバージョンを確認することができます。

```
$ rbenv install --list
(略)
```

### 環境変数の設定
ruby-build のデフォルトの設定では、共有ライブラリがビルドできなかったり、ドキュメントが毎回インストールされたりして少し不便です。
以下の環境変数を設定すると、それらの不便を解消することができます。

```
$ echo export RUBY_CONFIGURE_OPTS=\"--enable-shared --disable-install-doc\" >> ~/.bashrc
```

### インストール後の設定
ruby 2.0.0 インストール後のおまじない。おまじないを自動的に実行できるようにする方法は後述します。

```
$ rbenv rehash
```

rbenv で扱うことができるrubyの種類を表示

```
$ rbenv versions
* system
2.0.0-p195
```

2.0.0-p195へ切り替えテスト

```
$ rbenv shell 2.0.0-p195
$ ruby -v
ruby 2.0.0p195 (2013-05-14 revision 40734) [i686-linux]
```

ruby の切り替えがうまくいかない場合は

1. source ~/.bashrc
2. いったんログアウトしてみる

これらをするとうまくいくかもしれません。

うまくいったら、その他のバージョン、例えば1.8.7, 1.9.3 もインストールしてみましょう。

## rbenv の使い方
rbenv はRuby バージョンの切り替えに下記のようなコマンドを準備しています。

```
$ rbenv
Usage: rbenv <command> [<args>]

(略)
Some useful rbenv commands are:
local Set or show the local application-specific Ruby version
global Set or show the global Ruby version
shell Set or show the shell-specific Ruby version
(略)
```

### global
"global"ではすべてのシェルのRuby バージョンを指定できます。

```
~/wk_rurema/temp$ rbenv versions
system
1.8.7-p371
1.9.3-p429
* 2.0.0-p195 (set by RBENV_VERSION environment variable)
# 2.0.0 が指定されている。
~/wk_rurema/temp$ rbenv global 1.9.3-p429
~/wk_rurema/temp$ rbenv versions
system
1.8.7-p371
* 1.9.3-p429 (set by /home/kouya/wk_rurema/rbenv/version)
2.0.0-p195
kouya@ubuntu:~/wk_rurema/temp$ ruby -v
ruby 1.9.3p429 (2013-05-15 revision 40747) [i686-linux]
```

### local
"local"では実行したディレクトリに".ruby-version"というファイルを作り
"global"のバージョン指定を上書きすることができます。
例えば、~/wk_rurema/tempディレクトリで2.0.0-p195を使うように設定する場合は下記のようになります。

```
~/wk_rurema/temp$ rbenv local 2.0.0-p195
~/wk_rurema/temp$ ruby -v
ruby 2.0.0p195 (2013-05-14 revision 40734) [i686-linux]
# 試しに１つ上のディレクトリに移動してからRubyのバージョンを確認する。
~/wk_rurema/temp$ cd .. && ruby -v
ruby 1.9.3p429 (2013-05-15 revision 40747) [i686-linux]
```

local versionは下記の方法でやめることができます。

```
~/wk_rurema/temp$ rbenv local --unset
```

### shell
"shell"では現在のシェルでのRuby バージョンを指定できます。
例えば設定した後にいったんログアウトするとその設定は無くなることになります。

```
$ rbenv shell 1.8.7-p371
$ ruby -v
ruby 1.8.7 (2012-10-12 patchlevel 371) [i686-linux]
```

例えば、いったんログアウトする。

```
$ ruby -v
ruby 1.9.3p429 (2013-05-15 revision 40747) [i686-linux]
```

## るりま執筆用に便利なpluginの紹介

### rbenv-gem-rehash
gem install のあとに rbenv rehash を実行するプラグインです。
なおrehash しないと gem で入れたコマンドを使用することはできません。

#### インストール方法

```
$ git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/wk_rurema/rbenv/plugins/rbenv-gem-rehash
```

### rbenv-default-gems
新しいRubyをインストールした時に自動的にインストールするgemを指定することができます。
本記事では、"default-gems"というファイルを作成し、そこに"bundler", "bcat"と記述することによりこれらのインストールの手間を省いています。

#### インストール方法

```
$ git clone https://github.com/sstephenson/rbenv-default-gems.git ~/wk_rurema/rbenv/plugins/rbenv-default-gems
```

#### 実行例

default-gemsの設定例

```
$ cat ~/wk_rurema/rbenv/default-gems
bundler
bcat ~>0.6

$ rbenv install 1.9.3-p429
(略)
Downloading ruby-1.9.3-p429.tar.gz...
-> http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p429.tar.gz
Installing ruby-1.9.3-p429...
Installed ruby-1.9.3-p429 to /home/kouya/wk_rurema/rbenv/versions/1.9.3-p429

Fetching: bundler-1.3.5.gem (100%)
Successfully installed bundler-1.3.5
1 gem installed
Installing ri documentation for bundler-1.3.5...
Installing RDoc documentation for bundler-1.3.5...
Fetching: rack-1.5.2.gem (100%)
Fetching: bcat-0.6.2.gem (100%)
Successfully installed rack-1.5.2
Successfully installed bcat-0.6.2
2 gems installed
(略)
```

### rbenv-each
rbenv install で入れた全ての Ruby を使って実行する。

#### インストール方法

```
$ git clone https://github.com/chriseppstein/rbenv-each.git ~/wk_rurema/rbenv/plugins/rbenv-each
```

#### 実行例

例えば、このようなサンプルスクリプトを用意し実行権限を与えるとインストールしたバージョンすべてについてスクリプトを実行できます。

```
#!/usr/bin/env ruby
# 実行しているRubyのバージョンとパッチレベルを表示するサンプルスクリプト
puts "#{RUBY_VERSION} - #{RUBY_PATCHLEVEL}"

$ rbenv each -v ./test.rb
[1.8.7-p371]: ./test.rb
******************************************************************
1.8.7 - 371

[1.9.3-p429]: ./test.rb
******************************************************************
1.9.3 - 429

[2.0.0-p195]: ./test.rb
******************************************************************
2.0.0 - 195
```

## rbenv と ruby-buildのアンインストール

この記事の場合は以下の手順を実行してください。

1. wk_ruremaディレクトリを削除
2. .bashrc から設定した環境変数を消す

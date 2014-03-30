Windows でソースコードからビルドする方法を説明します。

## ビルド
最新版で動作を確認したい場合は、バイナリパッケージがないので自前でコンパイルしなければなりません。最新版のRubyのソースを取得するには

* [SubversionやGitから取得する](http://www.ruby-lang.org/ja/documentation/repository-guide)
* [スナップショットを利用する](http://www.ruby-lang.org/ja/downloads/)

という2つの方法がありますが、SubversionやGitを利用する方が追従が簡単なのでより良いでしょう。

MS Windows での ruby のビルドには

* VisualStudio
* Cygwin
* MinGW + Cygwin
* MinGW + MSYS
* bcc32

などいろいろな手段が存在します。作ったrubyのバイナリを Cygwinから利用したいならCygwinで、
cmd.exeから利用したいならMinGWでビルドするのが良いでしょう(VisualStudioをお持ちならVCでも構いません)。

実際のコンパイル作業については

 * http://i.loveruby.net/ja/rhg/cd/build.html
 * [Rubyist Magazine - build Ruby on Windows 【第 1 回】](http://magazine.rubyist.net/?0004-BuildRubyWin>)
 * [Ruby環境構築講座 Windows編 - 達人出版会](http://tatsu-zine.com/books/winrubybuild)

等が参考になります。MinGW + Cygwin か MinGW + MSYS を選べば、下で述べる Linux の場合と同じ方法で
複数のバージョンの ruby をインストールすることができます。
ちなみに、MinGW とは Windows 用の GNU 開発環境です。Minimalist GNU for Windows という名前が表すとおり
開発環境としては最低限のものしか提供されないので、bison, autoconf, make などは Cygwin か MSYS のものを利用
する必要があります。

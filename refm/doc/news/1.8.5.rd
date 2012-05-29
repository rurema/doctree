= ruby 1.8.5 feature

ruby 1.8.4 から ruby 1.8.5 までの変更点です。

掲載方針

*バグ修正の影響も含めて動作が変わるものを収録する。
*単にバグを直しただけのものは収録しない。
*ライブラリへの単なる定数の追加は収録しない。

以下は各変更点に付けるべきタグです。

記号について(特に重要なものは大文字(主観))

* カテゴリ
  * [ruby]: ruby インタプリタの変更
  * [api]: 拡張ライブラリ API
  * [lib]: ライブラリ
* レベル
  * [bug]: バグ修正
  * [new]: 追加されたクラス／メソッドなど
  * [compat]: 変更されたクラス／メソッドなど
    * 互換性のある変更
    * only backward-compatibility
    * 影響の範囲が小さいと思われる変更もこちら
  * [change]: 変更されたクラス／メソッドなど(互換性のない変更)
  * [obsolete]: 廃止された(される予定の)機能
  * [platform]: 対応プラットフォームの追加

== 1.8.4 (2005-12-24) -> ((<stable-snapshot|URL:ftp://ftp.ruby-lang.org/pub/ruby/stable-snapshot.tar.gz>))

=== 2006-06-18

: BasicSocket#recv_nonblock [new]
: UDPSocket#recvfrom_nonblock [new]

  追加

=== 2006-06-17

: Pathname(path) [new]

  pathname で追加

: Kernel#pretty_inspect [new]

  pp で追加

: RSS::TaxonomyTopicModel [new]
: RSS::TaxonomyTopicsModel [new]
: RSS::Maker::TaxonomyTopicModel [new]
: RSS::Maker::TaxonomyTopicsModel [new]

   RSS Parser/RSS MakerがTaxonomyモジュールをサポートしました。

: RSS::Maker xxx.new_yyy(&block) [compat]

   maker.items.new_itemなどがブロックをとれるようになりました。((<ruby-talk:197284>))

   今まで

     item = maker.items.new_item
     item.xxx = yyy
     ...

   と書いていたものが

     maker.items.new_item |item|
       item.xxx = yyy
       ...
     end

   と書けるようになりました。

: RSS::RootElementMixin#to_xml [new]

  こんな風にすると、RSS 1.0からRSS 2.0に変換できます。

    rss10 = RSS::Parser.parse(File.read("1.0.rdf"))
    File.open("2.0.rss", "w") {|f| f.print(rss10.to_xml("2.0"))}

  ((<ruby-talk:197284>))

: RSS::VERSION

   "0.1.5"から"0.1.6"になりました。

=== 2006-06-14

: Process.getrlimit(resource) [new]
: Process.setrlimit(resource, limit) [new]
: Process.setrlimit(resource, cur_limit, max_limit) [new]
: Process::RLIM_INFINITY
: Process::RLIM_SAVED_MAX
: Process::RLIM_SAVED_CUR
: Process::RLIMIT_CORE
: Process::RLIMIT_CPU
: Process::RLIMIT_DATA
: Process::RLIMIT_FSIZE
: Process::RLIMIT_NOFILE
: Process::RLIMIT_STACK
: Process::RLIMIT_AS
: Process::RLIMIT_MEMLOCK
: Process::RLIMIT_NPROC
: Process::RLIMIT_RSS
: Process::RLIMIT_SBSIZE

  追加 ((<ruby-dev:28729>))

=== 2006-06-11

: OptionParser#getopts [new]

: tempfile の生成するテンポラリファイルの名前が <basename><pid>.<count> から <basename>.<pid>.<count> になりました ((<ruby-talk:196272>))

=== 2006-06-07

: configure --with-winsock2 [new]

  mswin32版およびmingw32版で、従来のwinsock1に代わってwinsock2を利用する
  configureオプションが追加されました。

=== 2006-06-02

#: IPSocket#recvfrom_nonblock [new]
#: UNIXSocket#recvfrom_nonblock [new]
: TCPServer#accept_nonblock [new]
: UNIXServer#accept_nonblock [new]

  ((<ruby-core:7925>))

=== 2006-05-22

: IO#read_nonblock [new]
: IO#write_nonblock [new]
: Socket#connect_nonblock [new]
: Socket#accept_nonblock [new]
: Socket#recvfrom_nonblock [new]

  ((<ruby-core:7917>))

=== 2006-02-21
: File#link [bug]

  mswin32版・mingw32版でFile#linkが動かなくなっていた不具合が修正されました。

=== 2006-02-20

: RbConfig [new]

  ((<rbconfig>)) が Config に加えて RbConfig を定義するようになりました。

=== 2006-02-06

: File#flock [bug]

  cygwin版でRubyのスレッドが複数ある状態で、ロックせずにflock(File::LOCK_UN)すると
  止まってしまっていたのが修正されました。

=== 2006-02-04

: File#flock [bug]

  mswin32版でRubyのスレッドが複数ある状態で、ロックせずにflock(File::LOCK_UN)すると
  止まってしまっていたのが修正されました。

=== 2005-12-29

: Thread [compat]

  他から操作されない限り動き出さないにもかかわらず他から参照されていない thread は abort されるようになりました
  ((<ruby-dev:28154>))

== 参考

* ((<Changes in Ruby 1.8.5|URL:http://eigenclass.org/hiki.rb?ruby+1.8.5+changelog>))


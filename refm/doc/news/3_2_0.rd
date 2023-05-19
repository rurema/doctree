#@since 3.2
= NEWS for Ruby 3.2.0

このドキュメントは前回リリース以降のバグ修正を除くユーザーに影響のある機能の変更のリストです。

それぞれのエントリーは参照情報があるため短いです。
十分な情報と共に書かれた全ての変更のリストはリンク先を参照してください。

== 言語仕様の変更

  * 匿名の可変長引数と可変長キーワード引数はメソッドパラメータとしてだけではなく、引数としても使えるようになりました。 [[feature:18351]]

//emlist{
def foo(*)
  bar(*)
end
def baz(**)
  quux(**)
end
//}

  * 1つの引数と残りをキーワードとして受け取る proc は引数を自動で展開されなくなりました。 [[bug:18633]]

//emlist{
proc{|a, **k| a}.call([1, 2])
# Ruby 3.1 and before
# => 1
# Ruby 3.2 and after
# => [1, 2]
//}

  * 定数代入時の評価順序が単一の代入時と同じ評価順序となり一貫性を持つようになりました。 以下のようなコードの場合、

//emlist{
foo::BAR = baz
//}

  * foo は baz よりも先に評価されます。同様に複数の定数代入についても、左から右へ順に評価されます。以下のようなコードの場合、

//emlist{
foo1::BAR1, foo2::BAR2 = baz1, baz2
//}

  * 以下のように評価されます。

//emlist{
  1. `foo1`
  2. `foo2`
  3. `baz1`
  4. `baz2`
//}

  * [[bug:15928]]

  * Find patternが実験的な機能ではなくなりました。 [[feature:18585]]

  * 可変長パラメータ (*args など) を受け取るメソッドで、 foo(*args) を通してキーワード引数を委譲したい場合は、 ruby2_keywords でマークしなければならなくなりました。言い換えれば, *args などを用いてキーワードを引数を例外を起こさずに委譲したい全てのメソッドは ruby2_keywords によってマークする必要があると言うことです。これによって Ruby 3 以降のバージョンへ委譲を用いている処理を有するライブラリを簡単に対応できるようになります。以前はメソッドが *args を受け取る場合、ruby2_keywords フラグが保持されていました。しかし、これには一貫性がないと言う不具合がありました。今まではキーワード引数を複数のメソッドにまたがって委譲する時に、 ruby2_keywords を正しく使っているかを確認するために、全てに対して puts nil, caller, nil を追加していましたが、この変更によりテストを実行するときに ruby2_keywords が必要であるにもかかわらず使われていないものを見つける良い手段となります。 [[bug:18625]] [[bug:16466]]

#@samplecode
def target(**kw)
end

# Accidentally worked without ruby2_keywords in Ruby 2.7-3.1, ruby2_keywords
# needed in 3.2+. Just like (*args, **kwargs) or (...) would be needed on
# both #foo and #bar when migrating away from ruby2_keywords.
ruby2_keywords def bar(*args)
  target(*args)
end

ruby2_keywords def foo(*args)
  bar(*args)
end

foo(k: 1)
#@end

== 組み込みクラスの更新(注目すべきもののみ)

  * Fiber
    * 新規メソッド
      * 継承可能なFiber storageとして、 Fiber.[] と Fiber.[]= が導入されました。現在のストレージの取得とリセットを行うために、 Fiber#storage と Fiber#storage= (実験的な機能)が導入されました。Fiberの作成時にストレージを設定するための Fiber.new(storage:) が導入されました。 [[feature:19078]]
      * 既存の Thread と Fiber のローカル変数は、使い方が難しい場合があります。スレッドローカル変数はすべてのFiber間で共有されるため分離が難しく、Fiberローカル変数は共有が難しい場合があります。実行単位（ "実行コンテキスト" ）を定義して、そのコンテキストで作成されたすべての Fiber と Thread の間で何らかの状態が共有されるようにすることが望ましいことがよくあります。これはFiber storageが提供するものです。

#@samplecode
def log(message)
  puts "#{Fiber[:request_id]}: #{message}"
end

def handle_requests
  while request = read_request
    Fiber.schedule do
      Fiber[:request_id] = SecureRandom.uuid

      request.messages.each do |message|
        Fiber.schedule do
          log("Handling #{message}") # Log includes inherited request_id.
        end
      end
    end
  end
end
#@end

  * 例えば、接続プール、リクエストID、ロガーレベル、環境変数、設定など、与えられたコンテキストで作成されたすべての Fiber と Thread の間で暗黙のうちに共有されたい状態については、一般的に Fiber storage を考慮する必要があります。

  * Fiber::Scheduler
    * 新規メソッド
      * ノンブロッキングな IO.select のために Fiber::Scheduler#io_select が導入されました。 [[feature:19060]]

  * IO
    * 新規メソッド
      * ブロッキング処理で指定された timeout を超えた場合、IO::TimeoutError を発生させることができる IO#timeout= と IO#timeout が導入されました。 [[feature:18630]]

#@samplecode IO#timeout=
STDIN.timeout = 1
STDIN.read # => Blocking operation timed out! (IO::TimeoutError)
#@end

    * 変更されたメソッド
      * IO.new(..., path:) を導入し、 File#path が IO#path に昇格されました。 [[feature:19036]]

  * Class
    * 新規メソッド
      * Class#attached_object はレシーバが特異クラスであるオブジェクトを返します。レシーバが特異クラスでない場合は TypeError を発生させます。 [[feature:12084]]

#@samplecode Class#attached_object
class Foo; end

Foo.singleton_class.attached_object        #=> Foo
Foo.new.singleton_class.attached_object    #=> #<Foo:0x000000010491a370>
Foo.attached_object                        #=> TypeError: `Foo' is not a singleton class
nil.singleton_class.attached_object        #=> TypeError: `NilClass' is not a singleton class
#@end

  * Data
    * 新規クラス
      * 単純かつ不変な値オブジェクトを表現するための新たなコアクラス Data が追加されました。 Data は Struct によく似ており、部分的に実装を共有しています。しかし、より限定的かつ少ないAPIとなっています。 [feature:16122]

#@samplecode Data
Measure = Data.define(:amount, :unit)
distance = Measure.new(100, 'km')            #=> #<data Measure amount=100, unit="km">
weight = Measure.new(amount: 50, unit: 'kg') #=> #<data Measure amount=50, unit="kg">
weight.with(amount: 40)                      #=> #<data Measure amount=40, unit="kg">
weight.amount                                #=> 50
weight.amount = 40                           #=> NoMethodError: undefined method `amount='
#@end

  * Encoding
    * 変更されたメソッド
      * Encoding#replicate は非推奨になり、Ruby 3.3で削除される予定です。 [[feature:18949]]
      * ダミーエンコーディングの Encoding::UTF_16 と Encoding::UTF_32 は、BOM(byte order mark)に基づいてエンディアンを動的に推測しなくなりました。代わりに Encoding::UTF_16BE/UTF_16LE と Encoding::UTF_32BE/UTF_32LE を使用してください。この変更により、 String のエンコーディングの取得が高速化されます。 [[feature:18949]]
      * Encodingテーブルの最大サイズが256に制限されました。最大サイズを超える場合は EncodingError が発生します。 [[feature:18949]]

  * Enumerator
    * 新規メソッド
      * Enumerator.product が追加されました。 Enumerator::Product が実装です。 [[feature:18685]]

  * Exception
    * 新規メソッド
      * Exception#detailed_message が追加されました。デフォルトのエラープリンタは、#messageの代わりにExceptionオブジェクトに対してこのメソッドを呼び出します。 [[feature:18564]]

  * Hash
    * 変更されたメソッド
      * Hash#shift はハッシュが空の時には、デフォルト値やデフォルトのprocを呼ぶ代わりに常にnilを返します。 [[bug:16908]]

  * Integer
    * 新規メソッド
      * Integer#ceildiv が追加されました。 [[feature:18809]]

  * Kernel
    * 変更されたメソッド
      * Kernel#bindingは、Ruby以外のフレーム（Cで定義されたメソッドなど）から呼び出されるとRuntimeErrorを発生するようになりました。 [[bug:18487]]

  * MatchData
    * 新規メソッド
      * MatchData#byteoffset が追加されました。 [[feature:13110]]
      * MatchData#deconstruct が追加されました。 [[feature:18821]]
      * MatchData#deconstruct_keys が追加されました。 [[feature:18821]]

  * Module
    * 新規メソッド
      * Module.used_refinements が追加されました。 [[feature:14332]]
      * Module#refinements が追加されました。 [[feature:12737]]
      * Module#const_added が追加されました。 [[feature:17881]]
      * Module#undefined_instance_methods が追加されました。 [[feature:12655]]

  * Proc
    * 変更されたメソッド
      * Proc#dup がサブクラスのインスタンスを返すようになりました。 [[bug:17545]]
      * Proc#parameters が lambda キーワードを受け取ることができるようになりました。 [[feature:15357]]

  * Process
    * 新規定数
      * FreeBSD プラットフォームに RLIMIT_NPTS 定数が追加されました。

  * Regexp
    * キャッシュベースの最適化が導入されました。Regexpマッチングの多く（全てではない）が線形時間になり、正規表現サービス拒否（ReDoS）脆弱性を防ぐことができるようになりました。 [[feature:19104]]
    * 新規メソッド
      * Regexp.linear_time? が導入されました。 [[feature:19194]]
      * Regexp.timeout= が追加されました。他にも Regexp.new に time キーワード引数が新しくサポートされました。 [[feature:17837]]
    * 変更されたメソッド
      * Regexp.newでは、正規表現フラグを整数値だけでなく、文字列として渡すことができるようになりました。 未知のフラグは ArgumentError を発生させます。それ以外の場合、true, false, nil, Integer 以外のものは警告されます。 [[feature:18788]]

  * Refinement
    * 新規メソッド
      * Refinement#refined_class が追加されました。 [[feature:12737]]

  * RubyVM::AbstractSyntaxTree
    * 変更されたメソッド
      * parse, parse_file, of へ error_tolerant オプションが追加されました。 [[feature:19013]]
        * 1. SyntaxError が発生しなくなります。
        * 2. 文法上正しくない入力に対しても抽象構文木を返します。
        * 3. 入力を最後まで読んだときに end が不足していた場合、 end を補って構文解析を行います。
        * 4. インデントをもとに end をキーワードとして扱います。

#@samplecode RubyVM::AbstractSyntaxTree.parse
# Without error_tolerant option
root = RubyVM::AbstractSyntaxTree.parse(<<~RUBY)
def m
  a = 10
  if
end
RUBY
# => <internal:ast>:33:in `parse': syntax error, unexpected `end' (SyntaxError)

# With error_tolerant option
root = RubyVM::AbstractSyntaxTree.parse(<<~RUBY, error_tolerant: true)
def m
  a = 10
  if
end
RUBY
p root # => #<RubyVM::AbstractSyntaxTree::Node:SCOPE@1:0-4:3>

# `end` is treated as keyword based on indent
root = RubyVM::AbstractSyntaxTree.parse(<<~RUBY, error_tolerant: true)
module Z
  class Foo
    foo.
  end

  def bar
  end
end
RUBY
p root.children[-1].children[-1].children[-1].children[-2..-1]
# => [#<RubyVM::AbstractSyntaxTree::Node:CLASS@2:2-4:5>, #<RubyVM::AbstractSyntaxTree::Node:DEFN@6:2-7:5>]
#@end

    * 変更されたメソッド
      * parse, parse_file, of へ keep_tokensオプションが追加されました。 RubyVM::AbstractSyntaxTree::Node に #tokens と #all_tokens が追加されました。 [[feature:19070]]

#@samplecode RubyVM::AbstractSyntaxTree.parse
root = RubyVM::AbstractSyntaxTree.parse("x = 1 + 2", keep_tokens: true)
root.tokens # => [[0, :tIDENTIFIER, "x", [1, 0, 1, 1]], [1, :tSP, " ", [1, 1, 1, 2]], ...]
root.tokens.map{_1[2]}.join # => "x = 1 + 2"
#@end

  * Set
    * 変更されたメソッド
      * Set は require "set" を実行しなくても使用できる組み込みのクラスとなりました。 [[feature:16989]]
        * この機能は Set を参照した時、または Enumerable#to_set を呼んだ時に有効となります。

  * String
    * 新規メソッド
      * String#byteindex と String#byterindex が追加されました。 [[feature:13110]]
      * String#bytesplice が追加されました。 [[feature:18598]]
      * String#dedup の別名として String#-@ が追加されました。 [[feature:18595]]
    * 変更されたメソッド
      * Unicodeと絵文字のバージョンが15.0.0に更新されました。 [[feature:18639]]
        * (この変更は正規表現にも反映されます)

  * Struct
    * 変更されたメソッド
      * Structクラスは Struct.new の実行時に keyword_init: true をつけなくてもキーワード引数によって初期化できるようになりました。 [[feature:16806]]

#@samplecode Struct.new
Post = Struct.new(:id, :name)
Post.new(1, "hello") #=> #<struct Post id=1, name="hello">
# Ruby 3.2から以下のコードも keyword_init :true をつけなくても動作する
Post.new(id: 1, name: "hello") #=> #<struct Post id=1, name="hello">
#@end

  * Thread
    * 新規メソッド
      * Thread.each_caller_location が追加されました。 [[feature:16663]]

  * Thread::Queue
    * 新規メソッド
      * Thread::Queue#pop(timeout: sec) が追加されました。 [[feature:18774]]

  * Thread::SizedQueue
    * 新規メソッド
      * Thread::SizedQueue#pop(timeout: sec) が追加されました。 [[feature:18774]]
      * Thread::SizedQueue#push(timeout: sec) が追加されました。 [[feature:18944]]

  * Time
    * 新規メソッド
      * Time#deconstruct_keys が追加され、Timeインスタンスでパターンマッチが使用できるようになりました。 [[feature:19071]]
    * 変更されたメソッド
      * Time.newは、Time#inspectが生成するような文字列を解析し、与えられた引数に基づいたTimeインスタンスを返すことができるようになりました。 [[feature:18033]]

  * SyntaxError
    * 新規メソッド
      * SyntaxError#path が追加されました。 [[feature:19138]]

  * TracePoint
    * 変更されたメソッド
      * TracePoint#binding が c_call/c_return の TracePoints に対して nil を返すようになりました。 [[bug:18487]]
      * TracePoint#enable の target_thread キーワード引数で、ブロックが与えられ、 target と target_line キーワード引数が渡されない場合、現在のスレッドをデフォルトとするようになりました。 [[bug:16889]]

  * UnboundMethod
    * 変更されたメソッド
      * UnboundMethod#== は、実際のメソッドが同じであれば true を返します。例えば、 String.instance_method(:object_id) == Array.instance_method(:object_id) は true を返します。 [[feature:18798]]
      * UnboundMethod#inspect は instance_method のレシーバを表示しません。例えば、 String.instance_method(:object_id).inspect は "#<UnboundMethod： Kernel#object_id()>" (これが "#<UnboundMethod： String(Kernel)#object_id()>") でした。

  * GC
    * 変更されたメソッド
      * GC.latest_gc_info を介して need_major_gc を公開しました。 [[url:https://github.com/ruby/ruby/pull/6791]]

  * ObjectSpace
    * 変更されたメソッド
      * ObjectSpace.dump_all は形状もダンプするようになりました。 [[url:https://github.com/ruby/ruby/pull/6868]]

== 標準添付ライブラリの更新(機能追加とバグ修正を除く)

  * Bundler
    * Bundler は性能改善のために利用する依存解決ライブラリを Molinillo([[url:https://github.com/CocoaPods/Molinillo]]) から PubGrub([[url:https://github.com/jhawthorn/pub_grub]]) に変更しました。
    * gem を Rust で書くための雛形作成コマンドとして bundle gem --ext=rust をサポートしました。 [[url:https://github.com/rubygems/rubygems/pull/6149]]
    * git clone をより速く実行できるように改善しました。 [[url:https://github.com/rubygems/rubygems/pull/4475]]

  * RubyGems
    * cargo builder を mswin 環境でサポートしました。 [[url:https://github.com/rubygems/rubygems/pull/6167]]

  * CGI
    * CGI.escapeURIComponent と CGI.unescapeURIComponent が追加されました。 [[feature:18822]]

  * Coverage
    * Coverage.setup が eval: true を受け付けるようになりました。これにより、evalと関連するメソッドでコードカバレッジを生成することができるようになりました。 [[feature:19008]]
    * Coverage.supported?(mode) は、どのようなカバレッジモードがサポートされているかを検出することができます。 [[feature:19026]]

  * Date
    * Date#deconstruct_keys と DateTime#deconstruct_keys が追加されました。 [[feature:19071]]

  * ERB
    * ERB::Util.html_escape が CGI.escapeHTML よりも高速化されました。
      * エスケープが必要な文字列がない場合、String オブジェクトを確保しません。
      * 引数が String の場合、#to_s を呼ばずにスキップします。
      * ERB::Escape.html_escape が ERB::Util.html_escape のエイリアスになりました。そのため、 Rails にモンキーパッチする必要がなくなります。
    * ERB::Util.url_encode が CGI.escapeURIComponent よりも高速化されました。
    * erbコマンドから -S オプションが削除されました。

  * FileUtils
    * FileUtils.ln_sr メソッドが追加され、 FileUtils.ln_s に relative: オプションが追加されました。 [[feature:18925]]

  * IRB
    * debug.gem と統合したコマンドが複数追加されました: debug, break, catch, next, delete, step, continue, finish, backtrace, info
      * これらは Gemfile に gem "debug" と記述しなくても動かすことができます。
      * 詳細は What's new in Ruby 3.2's IRB?([[url:https://st0012.dev/whats-new-in-ruby-3-2-irb]]) を参照してください。
    * Pry のようなコマンドや機能が複数追加されました。
      * edit と show_cmds (Pry の help コマンド相当) が追加されました。
      * ls コマンドに出力をフィルタするための -g または -G オプションが追加されました。
      * show_source のエイリアスとして $ が追加されました、また引数をクオートする必要がなくなりました。
      * whereami のエイリアスとして @ が追加されました。

  * Net::Protocol
    * Net::BufferedIO が性能改善されました。 [[url:https://github.com/ruby/net-protocol/pull/14]]

  * Pathname
    * Pathname#lutime が追加されました。 [[url:https://github.com/ruby/pathname/pull/20]]

  * Socket
    * サポートされたプラットフォームに以下の定数が追加されました。
      * SO_INCOMING_CPU
      * SO_INCOMING_NAPI_ID
      * SO_RTABLE
      * SO_SETFIB
      * SO_USER_COOKIE
      * TCP_KEEPALIVE
      * TCP_CONNECTION_INFO

  * SyntaxSuggest
    * syntax_suggest の機能であった dead_end がRubyに統合されました。 [[feature:18159]]

  * UNIXSocket
    * Windows の UNIXSocket のサポートが追加されました。匿名ソケットをエミュレートします。 File.socket? と File::Stat#socket? のサポートを可能な限り追加されました。 [[feature:19135]]

* 以下の default gems のバージョンがアップデートされました。
  * RubyGems 3.4.1
  * abbrev 0.1.1
  * benchmark 0.2.1
  * bigdecimal 3.1.3
  * bundler 2.4.1
  * cgi 0.3.6
  * csv 3.2.6
  * date 3.3.3
  * delegate 0.3.0
  * did_you_mean 1.6.3
  * digest 3.1.1
  * drb 2.1.1
  * english 0.7.2
  * erb 4.0.2
  * error_highlight 0.5.1
  * etc 1.4.2
  * fcntl 1.0.2
  * fiddle 1.1.1
  * fileutils 1.7.0
  * forwardable 1.3.3
  * getoptlong 0.2.0
  * io-console 0.6.0
  * io-nonblock 0.2.0
  * io-wait 0.3.0
  * ipaddr 1.2.5
  * irb 1.6.2
  * json 2.6.3
  * logger 1.5.3
  * mutex_m 0.1.2
  * net-http 0.3.2
  * net-protocol 0.2.1
  * nkf 0.1.2
  * open-uri 0.3.0
  * open3 0.1.2
  * openssl 3.1.0
  * optparse 0.3.1
  * ostruct 0.5.5
  * pathname 0.2.1
  * pp 0.4.0
  * pstore 0.1.2
  * psych 5.0.1
  * racc 1.6.2
  * rdoc 6.5.0
  * readline-ext 0.1.5
  * reline 0.3.2
  * resolv 0.2.2
  * resolv-replace 0.1.1
  * securerandom 0.2.2
  * set 1.0.3
  * stringio 3.0.4
  * strscan 3.0.5
  * syntax_suggest 1.0.2
  * syslog 0.1.1
  * tempfile 0.1.3
  * time 0.2.1
  * timeout 0.3.1
  * tmpdir 0.1.3
  * tsort 0.1.1
  * un 0.2.1
  * uri 0.12.0
  * weakref 0.1.2
  * win32ole 1.8.9
  * yaml 0.2.1
  * zlib 3.0.0

* 以下の bundled gems のバージョンがアップデートされました。
  * minitest 5.16.3
  * power_assert 2.0.3
  * test-unit 3.5.7
  * net-ftp 0.2.0
  * net-imap 0.3.4
  * net-pop 0.1.2
  * net-smtp 0.3.3
  * rbs 2.8.2
  * typeprof 0.21.3
  * debug 1.7.1

default gems と bundled gems の詳細については GitHub Releases of Logger([[url:https://github.com/ruby/logger/releases]]) または changelog ファイルを参照してください。

== サポートプラットフォームの追加

  * WebAssembly/WASI が追加されました。 詳細は wasm/README.md([[url:https://github.com/ruby/ruby/blob/master/wasm/README.md]]) と ruby.wasm([[url:https://github.com/ruby/ruby.wasm]]) を参照してください。 [[feature:18462]]

== 互換性に関する変更

  * 現在、 [[m:String#to_c]] では、アンダースコアの連続をComplex文字列の末尾として扱っていました。 [[bug:19087]]
  * [[m:ENV.dup]] と同様に [[m:ENV.clone]] も TypeError を発生するようになりました。 [[bug:17767]]

=== 定数の削除

以下の非推奨の定数は削除されました。

  * Fixnum と Bignum [[feature:12005]]
  * Random::DEFAULT [[feature:17351]]
  * Struct::Group
  * Struct::Passwd

=== メソッドの削除

以下の非推奨のメソッドは削除されました。

  * Dir.exists? [[feature:17391]]
  * File.exists? [[feature:17391]]
  * Kernel#=~ [[feature:15231]]
  * Kernel#taint, Kernel#untaint, Kernel#tainted? [[feature:16131]]
  * Kernel#trust, Kernel#untrust, Kernel#untrusted? [[feature:16131]]
  * Method#public?, Method#private?, Method#protected?, UnboundMethod#public?, UnboundMethod#private?, UnboundMethod#protected? [[bug:18729]] [[bug:18751]] [[bug:18435]]

=== 拡張ライブラリのソースコードの非互換

  * RandomのサブクラスであるPRNGを提供する拡張ライブラリは、更新が必要です。詳細は PRNG update([[url:]]) を参照してください。 [[bug:19100]]

=== エラー表示

  * Rubyはエラーメッセージ中の制御文字やバックスラッシュをエスケープしなくなりました。 [[feature:18367]]

=== クラス/モジュールの定義時の定数探索

  * オブジェクトクラスの直下にclass/module文でクラス/モジュールを定義する際、 [[m:Module#include]] で定義された同名のクラス/モジュールが既にある場合、Ruby 3.1以前ではオープンクラスとして処理されていました。Ruby 3.2以降では、代わりに新しいクラスが定義されます。 [[feature:18832]]

== 標準添付ライブラリの互換性

  * [[c:Psych]] に同梱していた libyaml のソースコードは削除されました。また、Fiddleもlibffiのソースをバンドルしなくなりました。ユーザーは、apt、yum、brew などのパッケージマネージャを使って、自分で libyaml/libffi ライブラリをインストールする必要があります。

  * [[c:Psych]] と fiddle には特定バージョンの libyaml や libffi のソースコードを静的リンクするための機能が追加されました。libyaml-0.2.5 をリンクしてビルドする場合は以下のように実行します。

//emlist{
$ ./configure --with-libyaml-source-dir=/path/to/libyaml-0.2.5
//}

  * 同様に、libffi-3.4.4 を fiddle にリンクする場合は以下のように実行します。

//emlist{
$ ./configure --with-libffi-source-dir=/path/to/libffi-3.4.4
//}

  * [[feature:18571]]

  * CGI::Cookie の Cookie name/path/domain 文字をチェックします。 [[CVE-2021-33621]]

  * URI.parse が host に nil の代わりに空の文字列を返します。 [[sec-156615]]

== C API の変更

=== C API の更新

以下の API が更新されました。

  * PRNG の更新
    * rb_random_interface_t が更新され、新しいバージョンとなりました。 古いバージョンを用いている拡張ライブラリは新しいインターフェイスを使う必要があります。また init_int32 関数を定義する必要があります。

=== C API の追加

  * VALUE rb_hash_new_capa(long capa) が追加され、希望の容量を持つハッシュが作成されました。
  * スレッドのスケジューリングに rb_internal_thread_add_event_hook と rb_internal_thread_add_event_hook が追加されました。
  * 以下のイベントが追加されました。
    * RUBY_INTERNAL_THREAD_EVENT_STARTED
    * RUBY_INTERNAL_THREAD_EVENT_READY
    * RUBY_INTERNAL_THREAD_EVENT_RESUMED
    * RUBY_INTERNAL_THREAD_EVENT_SUSPENDED
    * RUBY_INTERNAL_THREAD_EVENT_EXITED
  * デバッガ用に rb_debug_inspector_current_depth と rb_debug_inspector_frame_depth が追加されました。

=== C API の削除

以下の非推奨の API は削除されました。

  * rb_cData変数
  * "taintedness" と "trustedness" 関数 [[feature:16131]]

== 実装の改善

  * Kernel#autoload のいくつかのレースコンディションを修正しました。 [[bug:18782]]
  * 定数を参照する式に対するキャッシュの無効化がより細かくなりました。 RubyVM.stat(:global_constant_state) は、定数を設定するとシステム内のすべてのキャッシュが無効になるという、以前のキャッシュ方式と密接に結びついていたため削除されました。新しいキーである :constant_cache_invalidations と :constant_cache_misses は、 :global_constant_state の使用例を支援するために導入されました。 [[feature:18589]]
  * Regexpマッチングにおけるキャッシュベースの最適化について導入されました。 [[feature:19104]]
  * Variable Width Allocation([[url:https://shopify.engineering/ruby-variable-width-allocation]]) がデフォルトで有効になりました。 [[feature:18239]]
  * オブジェクトシェイプと呼ばれる新しいインスタンス変数のキャッシュ機構が追加され、ほとんどのオブジェクトのインラインキャッシュヒットが改善され、非常に効率的なJITコードを生成することができるようになりました。インスタンス変数が一貫した順序で定義されているオブジェクトは、最もパフォーマンスの恩恵を受けることができます。 [[feature:18776]]
  * "markable" なオブジェクトを見つけるためにビットマップを使用することで、マーク命令シーケンスを高速化します。この変更により、メジャーコレクションが高速化されます。 [[feature:18875]]

== JIT

=== YJIT

  * YJIT は実験段階ではなくなりました。
    * 1年以上にわたって本番環境でテストされ、安定して稼働する実績があります。
  * YJIT は x86-64 と arm64/aarch64 の CPU アーキテクチャと Linux, MacOS, BSD とその他の UNIX プラットフォームをサポートしました。
    * このリリースでは Mac の M1/M2, AWS Graviton と Raspberry Pi 4 の ARM64 プロセッサに対応してます。
  * YJIT をビルドするためには Rust 1.58.0 以降が必要となります。 [[feature:18481]]
    * CRuby を YJIT を有効としてビルドするためには、rustc >= 1.58.0 をインストールした上で ./configure を実行する必要があります。
    * もし、実行時に何かしらの問題に遭遇した場合は YJIT チームに連絡してください。
  * JIT のための物理メモリは遅延して確保するようになりました。Ruby 3.1 と異なり --yjit-exec-mem-size に よって確保された仮想メモリのページは物理メモリのページにJITによって実際に使われるまで 割り当てられなくなったため Ruby プロセスのRSS はより小さくなりました。
  * JIT によるメモリ消費が --yjit-exec-mem-size に達したときに、全てのコードページを解放するコードGCを導入しました。
    * RubyVM::YJIT.runtime_stats は、既存の inline_code_size と outlined_code_size キーに加えて、 code_gc_count, live_page_count, freed_page_count と freed_code_size を コードGC のメトリクスとして表示します。
  * リリースビルドから RubyVM::YJIT.runtime_stats によって統計の大部分を得られるようになりました。
    * ruby コマンドに --yjit-stats を付与することで単純に表示することができます (ただしランタイムのオーバーヘッドは生じます)
  * YJIT へ object shapes による最適化が行われました。 [[feature:18776]]
    * 定数を無効化する粒度を細かくすることで、新しい定数を定義する際に無効化するコードの量を少なくしました。 [[feature:18589]]
  * --yjit-exec-mem-size のデフォルト値は 64 (MiB) と変更されました。
  * --yjit-call-threshold のデフォルト値は 30 と変更されました。

=== MJIT

  * MJIT コンパイラが ruby_vm/mjit/compiler として Ruby で再実装されました。
  * MJIT コンパイラは MJIT ワーカーによって呼ばれた native スレッドの代わりに fork されたプロセスによって実行されるようになりました。 [[feature:18968]]
    * そのため、Microsoft Visual Studio (MSWIN) はサポート対象外となりました。
  * MinGW はサポート対象外となりました。[[feature:18824]]
  * --mjit-min-calls は --mjit-call-threshold` にリネームされました。
  * --mjit-max-cache のデフォルト値は 10000 から 100 に戻されました。

#@end

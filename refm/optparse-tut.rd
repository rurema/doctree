= optparse::チュートリアル

((<OptionParser>))

optparse を使う場合、基本的には

(1) OptionParser オブジェクト opt を生成する。
(2) オプションを取り扱うブロックを opt に登録する。
(3) opt.parse(ARGV) でコマンドラインを実際に parse する。

というような流れになります。

* ((<optparse::チュートリアル/オプションの定義>))
* ((<optparse::チュートリアル/別の書き方>))
* ((<optparse::チュートリアル/ARGV の機能>))
* ((<optparse::チュートリアル/オプションの引数>))
* ((<optparse::チュートリアル/ロングオプション>))
* ((<optparse::チュートリアル/ヘルプ>))
* ((<optparse::チュートリアル/サブコマンド>))
* ((<optparse::チュートリアル/'-'で始まるファイル名>))

== オプションの定義

* 以下はオプション -a, -b を受け付けるコマンドを作成する例です。

        require 'optparse'
        opt = OptionParser.new

        opt.on('-a') {|v| p v }
        opt.on('-b') {|v| p v }

        opt.parse!(ARGV)
        p ARGV

        ruby sample.rb -a foo bar -b baz
        # => true
             true
             ["foo", "bar", "baz"]

  on() メソッドの引数でオプションを定義し、引数が指定された時の処理を
  ブロックで記述します。ブロックの引数にはオプションが指定されたことを
  示す true が渡されます(((<optparse::チュートリアル/オプションの引数>))も参照)。

  Enumerable#each などと違い、on() メソッドが呼ばれた時点ではブロックは実行されません。
  あくまで登録されるだけです。
  parse が呼ばれた時に、コマンドラインにオプションが指定されていれば実行されます。

* オプションの指定はコマンドの直後である必要はありません(上の例で、-b はオプションと
  して認識されている)。ただし、環境変数 POSIXLY_CORRECT が定義してあると
  この挙動は変更されます。

        env POSIXLY_CORRECT=1 ruby ./sample.rb -a foo bar -b baz
        # => true                               # -a はオプションと解釈
             ["foo", "bar", "-b", "baz"]        # -b は非オプションと解釈

* parse!() により、コマンドライン(ARGV)の解析を行います。
  parse!() では、ARGV からオプションが取り除かれます。
  これを避けるには parse() を使います。

        require 'optparse'
        opt = OptionParser.new

        opt.on('-a') {|v| p v }
        opt.on('-b') {|v| p v }

        # parse() の場合、ARGVは変更されない。
        # オプションを取り除いた結果は argv に設定される。
        argv = opt.parse(ARGV)

        p argv

* 定義していないオプションを指定すると例外 OptionParser::InvalidOption が
  発生する。

        ruby ./sample.rb -c
        /usr/local/lib/ruby/1.9/optparse.rb:1428:in `complete': invalid option: -c (OptionParser::InvalidOption)
                from /usr/local/lib/ruby/1.9/optparse.rb:1426:in `catch'
                from /usr/local/lib/ruby/1.9/optparse.rb:1426:in `complete'
                from /usr/local/lib/ruby/1.9/optparse.rb:1287:in `order!'
                from /usr/local/lib/ruby/1.9/optparse.rb:1256:in `catch'
                from /usr/local/lib/ruby/1.9/optparse.rb:1256:in `order!'
                from /usr/local/lib/ruby/1.9/optparse.rb:1336:in `permute!'
                from /usr/local/lib/ruby/1.9/optparse.rb:1363:in `parse!'
                from /usr/local/lib/ruby/1.9/optparse.rb:1356:in `parse'
                from ./sample.rb:9

* OptionParser 自体は、どのオプションが指定されたかを記憶しない。
  後の処理の方で、オプションによる条件判断を加えるには、
  他のコンテナに格納する。

        require 'optparse'
        opt = OptionParser.new

        OPTS = {}

        opt.on('-a') {|v| OPTS[:a] = v }
        opt.on('-b') {|v| OPTS[:b] = v }

        opt.parse!(ARGV)
        p ARGV
        p OPTS

        ruby sample.rb -a foo bar -b baz
        # => ["foo", "bar", "baz"]
             {:a=>true, :b=>true}


== 別の書き方

OprionParser.new はブロックを受け付ける。ブロックの引数は生成した
インスタンスなので、以下の書き方ができる。

        require 'optparse'
        OptionParser.new {|opt|

          opt.on('-a') {|v| p v }
          opt.on('-b') {|v| p v }

          opt.parse!(ARGV)
        }
        p ARGV

この書き方の利点は、
* OptionParser に関する記述をブロックの範囲で明示する(見やすくなる?)。
* 変数 opt をブロックローカルにする。
ぐらいか？

== ARGV の機能

optparse.rb を require すると、ARGV に OptionParser::Arguable の機能
が加わる。このことにより、以下の書き方ができるようになる。

        require 'optparse'
        ARGV.options {|opt|

            opt.on('-a') {|v| p v }
            opt.on('-b') {|v| p v }

            opt.parse!
        }
        p ARGV

        ruby sample.rb -a foo bar -b baz
        # => true
             true
             ["foo", "bar", "baz"]

((<optparse::チュートリアル/別の書き方>))で示した例に比べて、
* ARGV.options メソッドのブロックでオプション定義を記述する
* opt.parse! の引数が ARGV 固定になる。
といった違いがある。

特に利点があるわけではないが、optparse 添付のサンプルはこの書
き方になっている。

== オプションの引数

* on() メソッドのオプション定義で末尾に何かを書くと、そのオプション
  は引数を受け付けることの指定となる。

        require 'optparse'
        opt = OptionParser.new

        opt.on('-a VAL') {|v| p v }         # <- " VAL" を追加
        opt.on('-b') {|v| p v }

        opt.parse!(ARGV)
        p ARGV

        ruby sample.rb -a foo bar -b baz

        # => "foo"
             true
             ["bar", "baz"]

  オプションの末尾の書き方の基準は、「((<optparse::チュートリアル/ヘルプ>))
  の見栄えが良くなるように書く」である。

* オプションの引数を省略すると例外 OptionParser::MissingArgument が発生する。

        ruby ./sample.rb -a
        /usr/local/lib/ruby/1.9/optparse.rb:455:in `parse': missing argument: -a (OptionParser::MissingArgument)
                from /usr/local/lib/ruby/1.9/optparse.rb:1295:in `order!'
                from /usr/local/lib/ruby/1.9/optparse.rb:1256:in `catch'
                from /usr/local/lib/ruby/1.9/optparse.rb:1256:in `order!'
                from /usr/local/lib/ruby/1.9/optparse.rb:1336:in `permute!'
                from /usr/local/lib/ruby/1.9/optparse.rb:1363:in `parse!'
                from ./sample.rb:7

* オプションの引数が必須でないことを示すには、" [" を付ける

        require 'optparse'
        opt = OptionParser.new

        opt.on('-a [VAL]') {|v| p v }          # <- [VAL] を追加
        opt.on('-b') {|v| p v }

        opt.parse!(ARGV)
        p ARGV

        ruby sample.rb -a

        # => nil
             []

  同様に、ヘルプの見栄えが良いように "VAL]" を付加している。

* ショートオプションの引数指定は使いにくいので、このような場合はロング
  オプションの方が使う方もわかりやすい。例えば、上記の場合、-ab を
  指定すると -a b と解釈される。-a が引数を持たない最初の例なら -a -b と
  解釈される。

== ロングオプション

* ロングオプションは、on() の引数に '--'で始まるオプションを指定する。

        require 'optparse'
        opt = OptionParser.new

        opt.on('-a', '--foo') {|v| p v }
        opt.on('--bar') {|v| p v }

        opt.parse!(ARGV)
        p ARGV

        ruby sample.rb -a foo bar --bar baz
        # => true
             true
             ["foo", "bar", "baz"]

* --[no-]...などとすることで、否定型のオプションを指定することができる。

        require 'optparse'
        opt = OptionParser.new

        opt.on('-a', '--foo') {|v| p v }
        opt.on('--[no-]bar') {|v| p v }

        opt.parse!(ARGV)
        p ARGV

        ruby sample.rb -a foo bar --bar baz --no-bar
        # => true
             true
             false                              # <- --no-bar の指定による。
             ["foo", "bar", "baz"]

* オプションに対する引数も指定できる。ショートオプションと同じだが、
  GNUの慣習にあわせて

        opt.on('-a', '--foo=VAL') {|v| p v }
        opt.on('--[no-]bar[=VAL]') {|v| p v }

  と "=" を使うのが良いと思われる。

* オプションを指定する時は、どのオプションか一意に決まる長さまで指定す
  れば良い。

        require 'optparse'
        opt = OptionParser.new

        opt.on('-a', '--foo') {|v| p v }
        opt.on('--[no-]bar') {|v| p v }

        opt.parse!(ARGV)
        p ARGV

        ruby sample.rb --fo

  この例では、--fo は、--foo を指定したのと同じになる。この例なら --f 
  まで省略できる。

== ヘルプ

* デフォルトで、--help と --version オプションを認識する。

        ruby ./sample.rb --help
        # => Usage: sample [options]

        ruby ./sample.rb --version
        # => *出力なし*

* --version は、トップレベルに Version 定数が定義されていると出力される。
  (優先度は低いが VERSION 定数も参照する。Ruby のバージョンを示す VERSION
  定数が ruby 1.8 までは定義されているので注意)

        require 'optparse'
        opt = OptionParser.new
        Version = "1.2.3"       # opt.version = "1.2.3"
        opt.parse!(ARGV)

        ruby ./sample.rb --version
        # => sample 1.2.3

* on の引数にそのオプションの説明を加えると --help の出力に反映される。

        require 'optparse'
        opt = OptionParser.new

        opt.on('-a', 'description of -a') {|v| p v }
        opt.on('-b', 'description of -b') {|v| p v }

        opt.parse!(ARGV)
        p ARGV
        
        ruby ./sample.rb --help
        # => Usage: sample [options]        
                -a                               description of -a
                -b                               description of -b

  が、1.8.2より前のバージョンではこれだけだとダメらしい。  
        ruby ./sample.rb --help
        # => Usage: sample [options]
  になる。
        opt.on('--help', 'show this message') { puts opt; exit }
  をオプション定義に追加するか、((<ARGVを使った書き方|optparse::チュートリアル/ARGV の機能>))
  にする(以下)。

        require 'optparse'
        ARGV.options {|opt|

          opt.on('-a', 'description of -a') {|v| p v }
          opt.on('-b', 'description of -b') {|v| p v }

          opt.parse!
        }
        p ARGV

        ruby ./sample.rb --help
        # => Usage: sample [options]
               -a                               description of -a
               -b                               description of -b

== サブコマンド
以下は cvs や svn のようにサブコマンドを解釈する例である。
  
    #! /usr/bin/ruby
    # contributed by Minero Aoki.
    
    require 'optparse'
    
    parser = OptionParser.new
    parser.on('-i') { puts "-i" }
    parser.on('-o') { puts '-o' }
    
    subparsers = Hash.new {|h,k|
      $stderr.puts "no such subcommand: #{k}"
      exit 1
    }
    subparsers['add'] = OptionParser.new.on('-i') { puts "add -i" }
    subparsers['del'] = OptionParser.new.on('-i') { puts "del -i" }
    subparsers['list'] = OptionParser.new.on('-i') { puts "list -i" }
    
    parser.order!(ARGV)
    subparsers[ARGV.shift].parse!(ARGV) unless ARGV.empty?

実行すると以下のようになる。

    $ ruby subcom.rb -i add -i
    -i
    add -i
    
    $ ruby subcom.rb list -i
    list -i

((<OptionParser#order!|OptionParser/order>)) がオプションではない
コマンドの引数に出会うとそこでパースを中断することを利用している。

== '-'で始まるファイル名

'-'で始まるファイル名をコマンドに渡したい場合は以下のように間に"--"を挟む。

      $ ruby sample.rb -- -a 

"-a" がオプションではない引数として解釈される。
これは POSIX.2 の getopt(3) に由来する。"--" 以降はすべてオプションではない引数として解釈される。

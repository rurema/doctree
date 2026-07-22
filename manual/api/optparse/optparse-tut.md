### チュートリアル

optparse を使う場合、基本的には

1. OptionParser オブジェクト opt を生成する。
2. オプションを取り扱うブロックを opt に登録する。
3. opt.parse(ARGV) でコマンドラインを実際に parse する。

というような流れになります。

- [ref:optiondef]
- [ref:optionarg]
- [ref:longoption]
- [ref:help]
- [ref:subcmd]
- [ref:argv]
- [ref:hyphen_start_file]

#### オプションの定義 {#optiondef}

以下はオプション -a, -b を受け付けるコマンドを作成する例です。

```ruby title="sample.rb"
require 'optparse'
opt = OptionParser.new

opt.on('-a') {|v| p v }
opt.on('-b') {|v| p v }

opt.parse!(ARGV)
p ARGV
```

↓

```console
ruby sample.rb -a foo bar -b baz
# => true
     true
     ["foo", "bar", "baz"]
```

[m:OptionParser#on] メソッドの引数でオプションを定義し、引数が指定さ
れた時の処理をブロックで記述します。ブロックの引数にはオプションが指定
されたことを示す true が渡されます([ref:optionarg]の項も参照)。

[m:Enumerator#each] などと違い、[m:OptionParser#on]
メソッドが呼ばれた時点ではブロックは実行されません。あくまで登録される
だけです。[m:OptionParser#parse] が呼ばれた時に、コマンドラインにオプ
ションが指定されていれば実行されます。

オプションの指定はコマンドの直後である必要はありません(上の例で、-b はオプションと
して認識されている)。ただし、環境変数 POSIXLY_CORRECT が定義してあると
この挙動は変更されます。

```console
env POSIXLY_CORRECT=1 ruby ./sample.rb -a foo bar -b baz
# => true                               # -a はオプションと解釈
     ["foo", "bar", "-b", "baz"]        # -b は非オプションと解釈
```

[m:OptionParser#parse!] により、コマンドライン(ARGV)の解析を行います。
[m:OptionParser#parse!] では、ARGV からオプションが取り除かれます。
これを避けるには [m:OptionParser#parse] を使います。

```ruby title="sample.rb"
require 'optparse'
opt = OptionParser.new

opt.on('-a') {|v| p v }
opt.on('-b') {|v| p v }

# parse() の場合、ARGVは変更されない。
# オプションを取り除いた結果は argv に設定される。
argv = opt.parse(ARGV)

p argv
```

定義していないオプションを指定すると例外
[c:OptionParser::InvalidOption] が発生します。

```console
ruby ./sample.rb -c
#@since 3.4
./sample.rb:7:in '<main>': invalid option: -c (OptionParser::InvalidOption)
./sample.rb:7:in '<main>': invalid option: c (OptionParser::InvalidOption)
#@else
./sample.rb:7:in `<main>': invalid option: -c (OptionParser::InvalidOption)
./sample.rb:7:in `<main>': invalid option: c (OptionParser::InvalidOption)
#@end
```

[c:OptionParser] 自体は、どのオプションが指定されたかを記憶しません。
後の処理の方で、オプションによる条件判断を加えるには、
他のコンテナに格納します。

```ruby title="sample.rb"
require 'optparse'
opt = OptionParser.new

params = {}

opt.on('-a') {|v| params[:a] = v }
opt.on('-b') {|v| params[:b] = v }

opt.parse!(ARGV)
p ARGV
p params
```

↓

```console
ruby sample.rb -a foo bar -b baz
# => ["foo", "bar", "baz"]
     {:a=>true, :b=>true}
```

明示的にコンテナへ格納する以外に、parse（及びparse!）メソッドの引数に
:into オプションを指定することでハッシュへ自動的に値を格納できます。
この時ハッシュのキーとして利用される名前はロングオプションが定義されていれば
ロングオプションの値を、ショートオプションのみの場合はショートオプションの値から、
先頭の "-" を除いてシンボル化した値が使用されます。

```ruby title="sample.rb"
require 'optparse'
opt = OptionParser.new

params = {}

opt.on('-a') {|v| v }
opt.on('-b', '--bbb') {|v| v }

opt.parse!(ARGV, into: params) # intoオプションにハッシュを渡す
p ARGV
p params
```

↓

```console
ruby sample.rb -a foo bar -b baz
# => ["foo", "bar", "baz"]
     {:a=>true, :bbb=>true}
```

#### オプションの引数 {#optionarg}

[m:OptionParser#on] メソッドのオプション定義で末尾に何かを書くと、そ
のオプションは引数を受け付けることの指定となります。

```ruby title="sample.rb"
require 'optparse'
opt = OptionParser.new

opt.on('-a VAL') {|v| p v }         # <- " VAL" を追加
opt.on('-b') {|v| p v }

opt.parse!(ARGV)
p ARGV
```

```console
ruby sample.rb -a foo bar -b baz

# => "foo"
     true
     ["bar", "baz"]
```

オプションの末尾の書き方の基準は、「ヘルプの見栄えが良くなるように書く」です。
オプションの引数を省略すると例外 [c:OptionParser::MissingArgument] が発生します。

```console
ruby ./sample.rb -a
#@since 3.4
./sample.rb:7:in '<main>': missing argument: -a (OptionParser::MissingArgument)
#@else
./sample.rb:7:in `<main>': missing argument: -a (OptionParser::MissingArgument)
#@end
```

オプションの引数が必須でないことを示すには、" [" を付けます。

```ruby title="sample.rb"
require 'optparse'
opt = OptionParser.new

opt.on('-a [VAL]') {|v| p v }          # <- [VAL] を追加
opt.on('-b') {|v| p v }

opt.parse!(ARGV)
p ARGV
```

↓

```console
ruby sample.rb -a

# => nil
     []
```

同様に、ヘルプの見栄えが良いように "VAL]" を付加しています。

ショートオプションの引数指定は使いにくいので、このような場合はロング
オプションの方が使う方もわかりやすいです。例えば、上記の場合、-ab を
指定すると -a b と解釈されます。-a が引数を持たない最初の例なら -a -b と
解釈されます。

#### ロングオプション {#longoption}

ロングオプションは [m:OptionParser#on] の引数に '--'で始まるオプションを指定します。

```ruby title="sample.rb"
require 'optparse'
opt = OptionParser.new

opt.on('-a', '--foo') {|v| p v }
opt.on('--bar') {|v| p v }

opt.parse!(ARGV)
p ARGV
```

↓

```console
ruby sample.rb -a foo bar --bar baz
# => true
     true
     ["foo", "bar", "baz"]
```

--[no-]...などとすることで、否定型のオプションを指定できます。

```ruby title="sample.rb"
require 'optparse'
opt = OptionParser.new

opt.on('-a', '--foo') {|v| p v }
opt.on('--[no-]bar') {|v| p v }

opt.parse!(ARGV)
p ARGV
```

↓

```console
ruby sample.rb -a foo bar --bar baz --no-bar
# => true
     true
     false                              # <- --no-bar の指定による。
     ["foo", "bar", "baz"]
```

オプションに対する引数も指定できます。ショートオプションと同じだが、
GNUの慣習にあわせて

```ruby
opt.on('-a', '--foo=VAL') {|v| p v }
opt.on('--[no-]bar[=VAL]') {|v| p v }
```

と "=" を使うのが良いと思われます。

オプションを指定する時は、どのオプションか一意に決まる長さまで指定す
れば良いです。

```ruby
require 'optparse'
opt = OptionParser.new

opt.on('-a', '--foo') {|v| p v }
opt.on('--[no-]bar') {|v| p v }

opt.parse!(ARGV)
p ARGV
```

↓

```console
ruby sample.rb --fo
```

この例では、--fo は、--foo を指定したのと同じになります。この例なら --f
まで省略できます。

#### ヘルプ {#help}

デフォルトで --help と --version オプションを認識します。

```console
ruby ./sample.rb --help
# => Usage: sample [options]

ruby ./sample.rb --version
# => *出力なし*
```

--version は、トップレベルに Version 定数が定義されていると出力されます。
(優先度は低いが VERSION 定数も参照します。Ruby のバージョンを示す VERSION
定数が ruby 1.8 までは定義されているので注意)

```ruby
require 'optparse'
opt = OptionParser.new
Version = "1.2.3"       # opt.version = "1.2.3"
opt.parse!(ARGV)
```

↓

```console
ruby ./sample.rb --version
# => sample 1.2.3
```

[m:OptionParser#on] の引数にそのオプションの説明を加えると --help の
出力に反映されます。

```ruby
require 'optparse'
opt = OptionParser.new

opt.on('-a', 'description of -a') {|v| p v }
opt.on('-b', 'description of -b') {|v| p v }

opt.parse!(ARGV)
p ARGV
```

↓

```console
ruby ./sample.rb --help
# => Usage: sample [options]
        -a                               description of -a
        -b                               description of -b
```

#### サブコマンド {#subcmd}

以下は cvs や svn のようにサブコマンドを解釈する例です。

```ruby title="subcom.rb"
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
```

実行すると以下のようになります。

```console
$ ruby subcom.rb -i add -i
-i
add -i

$ ruby subcom.rb list -i
list -i
```

[m:OptionParser#order!] がオプションではない
コマンドの引数に出会うとそこでパースを中断することを利用しています。

#### ARGV の機能 {#argv}

optparse を require すると ARGV に [c:OptionParser::Arguable] の機能
が加わります。以下の書き方ができるようになります。
[m:OptionParser::Arguable#getopts] はオプションを保持した Hash を返します。

```ruby title="sample.rb"
require 'optparse'
params = ARGV.getopts("a:b:", "foo", "bar:")
p params
```

この sample.rb を実行すると

```console
$ ruby sample.rb -a 1 --foo --bar xxx
{"a"=>"1", "b"=>nil, "foo"=>true, "bar"=>"xxx"}
```

のようになります。

#### '-'で始まるファイル名 {#hyphen_start_file}

'-'で始まるファイル名をコマンドに渡したい場合は以下のように間に"--"を挟みます。

```console
$ ruby sample.rb -- -file
```

"-file" がオプションではない引数として解釈されます。
これは POSIX.2 の [man:getopt(3)] に由来します。"--" 以降はすべてオプ
ションではない引数として解釈されます。

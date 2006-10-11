#@# Author: <jammy@shljapan.co.jp>

require getopts

オプションを解析し，$OPT_xxx に値を設定します．
更に指定したオプションが条件にあっていない場合，USAGE を表示します．

Note: This library is obsolete after Ruby 1.8.1.

=== オプション解析

[[lib:getopts]] のオプション解析と同じです．

=== USAGEの設定

$USAGE に "usage" (名前は何でもよい) をセットします．

  def usage
    puts "Usage: #{File.basename($0)} <file>..."
    puts "Options:"
          :
          :
  end

  $USAGE = 'usage'

=== 参照

  * ruby-src:sample/getopts.test
  * ruby-src:sample/biorhythm.rb



= reopen Object

== Instance Methods

--- parseArgs(min_argc，check_opts，single_opts，*opts)

: 第一引数
    `-'や`--'を伴って指定するオプション以外のオプションの
    最低必要数を指定します．存在しない場合は 0 を指定します．
: 第二引数
    どのオプションが必要条件かを指定します．第三，第四引数で指定する
    オプションのうち必要なものを'('，')'，'|'，'&' を使って並べ，全
    体をダブルクォテーションで括ります． Rubyスクリプト実行時に全て
    のオプションが省略可能ならば `nil'を指定して下さい．
: 第三，第四引数:
    [[m:Kernel#getopts]] の第一，第二引数と同じです．

以下の例では，"-d" と最低でも "-x"，"-y"，"--geometry" の
どれか一つが実行時に必要なオプションとなります．

  parseArgs(0，"d&(x|y|geometry)"，"fd"，"x:"，"y:"，"geometry:"，"version")


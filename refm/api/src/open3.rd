= class Open3

プログラムを実行し、そのプロセスの標準入力・標準出力・
標準エラー出力にパイプをつなぎます。

#@# == 使用例

nroff を実行してその標準入力に man ページを送り込み処理させる。
nroff プロセスの標準出力から処理結果を受け取る。

  require "open3"

  stdin, stdout, stderr = *Open3.popen3('nroff -man')
  # こちらから書く
  Thread.fork {
    File.foreach('/usr/man/man1/ruby.1') do |line|
      stdin.print line
    end
    stdin.close    # または close_write
  }
  # こちらから読む
  stdout.each do |line|
    print line
  end

== Module Functions

--- popen3(cmd)

外部プログラム cmd を実行し、そのプロセスの標準入力、
標準出力、標準エラー出力に接続されたパイプを 3 要素の配列で返す。
cmd は組み込み関数 [[m:Kernel.exec]] と同じ規則で解釈される。

        stdin, stdout, stderr = *Open3.popen3("/usr/bin/nroff -man")

ブロックを指定するとパイプの配列を引数にブロックを実行し、最後に
パイプを close する。この場合はブロックの最後の式の結果を返す。

        require 'open3'

        Open3.popen3("read stdin; echo stdout; echo stderr >&2") {|stdin, stdout, stderr|
          stdin.puts "stdin"
          stdin.close     # または close_write
          p stdout.read
          p stderr.read
        }
        #=> "stdout\n"
            "stderr\n"

stdin への入力が終わったらできる限り早く close か close_write
で閉じるべきです。

[UNIX系OS固有の注意] Open3 で作成した子プロセスは
[[man:wait(2)]] しなくてもゾンビになりません。

コマンドは実際には孫プロセスとして動作するため、組み込み変数 [[m:$?]] でコマンドの終了ステータスを得ることはできません。

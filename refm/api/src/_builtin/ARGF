= object ARGF

extend Enumerable

スクリプトに指定した引数
([[m:Kernel::ARGV]] を参照) をファイル名とみなして、
それらのファイルを連結した 1 つの仮想ファイルを表すオブジェクトです。
ARGV が空なら標準入力を対象とします。
ARGV を変更すればこのオブジェクトの動作に影響します。

    while line = ARGF.gets
      ....
    end

は、

    while argv = ARGV.shift
      File.open(argv) {|file|
        while line = file.gets
          ....
        end
      }
    end

のように動作します。

ARGF を処理するごとに ARGV の要素は一つずつ取り除かれます。
最後まで ARGF を読み込んだ後、再度 ARGF から内容を読むと
(ARGV が空なので)標準入力からの読み込みとなります。

    ARGV.replace %w(/tmp/foo /tmp/bar)
    ARGF.each {|line|
        # 処理中の ARGV の内容を表示
        p [ARGF.filename, ARGV]
        ARGF.skip
    }
        # => ["/tmp/foo", ["/tmp/bar"]]
        #    ["/tmp/bar", []]
    # 最後まで読んだ後 (ARGV が空) の動作
    p ARGF.gets      # => nil
    p ARGF.filename  # => "-"

[[m:Kernel#gets]] など一部の[[unknown:組み込み関数]]は
ARGF.gets などこのオブジェクトをレシーバとしたメソッドの省略形です。

#@if (version >= "1.8.0")
--- filename
--- path

処理対象のファイル名を返します。
標準入力に対しては - を返します。
組み込み変数 [[m:$FILENAME]] と同じです。

--- to_s

常に文字列 "ARGF" を返します。
#@else

--- filename
--- to_s

処理対象のファイル名を返します。
標準入力に対しては - を返します。
組み込み変数 [[m:$FILENAME]] と同じです。
#@end

--- file

処理対象の [[c:File]] オブジェクト(または [[c:IO]] オブジェクト)を
返します。

--- lineno
--- lineno=

全引数ファイルを一つのファイルとみなしたときの現在の行番号を返します。
個々の引数ファイル毎の行番号を得るには ARGF.file.lineno とします。

--- skip

処理対象のファイルをクローズします。
次回の読み込みは次の引数が処理対象になります。

self を返します。

--- binmode

--- close

--- closed?

--- dup

--- each

--- each_byte

--- each_line

--- eof
--- eof?

--- fileno

--- getc

--- gets

--- pos
--- pos=

--- read

--- readchar

--- readline

--- readlines

--- rewind

--- seek

--- tell

--- to_a

--- to_i

--- to_io


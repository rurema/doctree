category File

ディレクトリ配下のファイルを探索するためのモジュールです。

=== 使い方

  require "find"
  
  Find.find('/foo','/bar') {|f| ...}

または

  require "find"
  
  include Find
  find('/foo','/bar') {|f| ...}

以下は、ruby のアーカイブに含まれるサンプルスクリプト
([[url:https://github.com/ruby/ruby/blob/trunk/sample/trojan.rb]]) をこのモジュールで書き換えたものです。

  #! /usr/bin/env ruby
  require "find"
  # 他人が書き込み可能な危険なコマンドを探す
  
  for dir in ENV['PATH'].split(File::PATH_SEPARATOR)
    Find.find(dir) do |fpath|
      if File.file?(fpath) and (File.stat(fpath).mode & 022) != 0
        printf("file %s is writable from other users\n", fpath)
      end
    end
  end

= module Find

ディレクトリ配下のファイルを探索するためのモジュールです。

== Module Functions

#@since 2.2.0
--- find(*dirs, ignore_error: true)              -> Enumerator
--- find(*dirs, ignore_error: true){|file| ... } -> nil
#@else
#@since 1.9.1
--- find(*dirs)              -> Enumerator
#@end
--- find(*dirs){|file| ... } -> nil
#@end

[[man:find(1)]] のように dir 配下のすべてのファイルや
ディレクトリを一つずつ引数 file に渡してブロックを実行します。

ディレクトリのシンボリックリンクは辿りません。
また file に渡される順序は不定です。

#@since 1.9.1
ブロックを省略した場合は、上記の処理を行うような [[c:Enumerator]] を返
します。
#@end

@param dirs 探索するディレクトリを一つ以上指定します。

#@since 2.2.0
@param ignore_error 探索中に発生した例外を無視するかどうかを指定します。
#@end

例:

  require 'find'
  
  Find.find('/tmp') {|f|
    Find.prune if f == "/tmp/bar"
    ...
  }

あるディレクトリ配下の探索を省略したい場合は上記のように、
[[m:Find.#prune]] を使用します。この例では "/tmp/bar"
配下のファイルやディレクトリを探索しません。prune の代わりに
[[ref:d:spec/control#next]] を使用した場合、"/tmp/bar" 自体をスキップする
だけで、その配下の探索は続行されます。

@see [[man:find(1)]], [[m:Find.#prune]]

--- prune -> ()

[[m:Find.#find]] メソッドのブロックにディレクトリが渡されたときにこ
のメソッドを実行すると、そのディレクトリ配下の探索を無視します。

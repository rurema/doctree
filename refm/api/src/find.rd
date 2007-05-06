ディレクトリ配下のファイルを探索するためのモジュールです。

=== 使い方

  require "find"
  
  Find.find('/foo','/bar') {|f| ...}

または

  require "find"
  
  include Find
  find('/foo','/bar') {|f| ...}

以下は、ruby のアーカイブに含まれるサンプルスクリプト
[[unknown:"ruby-src:sample/trojan.rb"]] をこのモジュールで書き換えたものです。

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


=== 履歴
  * version 1.4 (ruby version 1.6.1)
    ディレクトリのシンボリックリンクを辿らなくなりました。

= module Find

== Module Functions

--- find(dir[, ...]) {|file| }
#@todo

[[man:find(1)]] のように dir 配下のすべてのファイルや
ディレクトリを一つずつ引数 file に渡してブロックを実行します。
file に渡される順序は不定です。

あるディレクトリ配下の探索を省略したい場合

  require 'find'
  
  Find.find('/tmp') {|f|
    Find.prune if f == "/tmp/bar"
    ...
  }

のように、[[m:Find.#prune]] を使用します。この例では "/tmp/bar"
配下のファイルやディレクトリを探索しません。prune の代わりに
[[unknown:制御構造/next]] を使用した場合、"/tmp/bar" 自体をスキップする
だけで、その配下の探索は続行されます。

--- prune
#@todo

[[m:Find.#find]] メソッドのブロックにディレクトリが渡されたときにこ
のメソッドを実行すると、そのディレクトリ配下の探索を無視します。

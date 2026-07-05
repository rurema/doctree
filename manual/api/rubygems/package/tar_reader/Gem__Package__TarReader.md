---
library: rubygems/package/tar_reader
include:
  - Gem::Package
---
# class Gem::Package::TarReader

gem-format な tar ファイルを読むためのクラスです。

## Public Instance Methods

### def close -> nil

自身を close します。

### def each{|entry| ... }
### def each_entry{|entry| ... }

ブロックに一つずつエントリを渡して評価します。

### def rewind -> Integer

自身に関連付けられた IO のファイルポインタを先頭に移動します。または、
[m:Gem::Package::TarReader.new] したときの [m:IO#pos] にファイルポ
インタを先頭に移動します。

[m:Gem::Package::TarReader#each] の実行中に呼ばないようにしてください。

- **return** -- 戻った位置を返します。

- **raise** `Gem::Package::NonSeekableIO` -- 自身に関連付けられた IO がシーク可能
                                   でない場合に発生します。

## Singleton Methods

### def new(io) -> Gem::Package::TarReader

io に関連付けて [c:Gem::Package::TarReader] を初期化します。

- **param** `io` -- pos, eof?, read, getc, pos= というインスタンスメソッドを持つ
          オブジェクトを指定します。


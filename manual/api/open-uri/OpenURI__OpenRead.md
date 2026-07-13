---
library: open-uri
---
# module OpenURI::OpenRead
[c:URI::HTTP] と [c:URI::FTP] を拡張するために用意されたモジュールです。

## Instance Methods

### def open(mode = 'r', perm = nil, options = {})                 -> StringIO
### def open(mode = 'r', perm = nil, options = {}){|sio| ... }     -> nil

自身が表すリソースを取得して [c:StringIO] オブジェクトとして返します。
[m:OpenURI.open_uri](self, *rest, &block) と同じです。

ブロックを与えた場合は [c:StringIO] オブジェクトを引数としてブロックを
評価します。ブロックの終了時に StringIO は close されます。nil を返します。

返り値である StringIO オブジェクトは [c:OpenURI::Meta] モジュールで extend されています。

- **param** `mode` -- モードを文字列で与えます。[m:Kernel?.open] と同じです。

- **param** `perm` -- 無視されます。

- **param** `options` -- ハッシュを与えます。

- **raise** `OpenURI::HTTPError` -- 対象となる URI のスキームが http であり、かつリソースの取得に
                          失敗した時に発生します。

- **raise** `Net::FTPError` -- 対象となる URI のスキームが ftp であり、かつリソースの取得に失敗した時に
                     [c:Net::FTPError] のサブクラスが発生します。詳しくは [lib:net/ftp]
                     を参照して下さい。

- **SEE** [m:OpenURI.open_uri]

### def read(options = {})     -> String

自身が表す内容を読み込んで文字列として返します。
self.open(options={}) {|io| io.read } と同じです。
このメソッドによって返される文字列は [c:OpenURI::Meta]
によって extend されています。

- **param** `options` -- ハッシュを与えます。

```ruby
require 'open-uri'
uri = URI.parse('http://www.example.com/')
str = uri.read
p str.is_a?(OpenURI::Meta) # => true
p str.content_type
```


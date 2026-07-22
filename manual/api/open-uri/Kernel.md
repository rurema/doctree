---
library: open-uri
until: "3.0.0"
---
# redefine Kernel

## Module Functions

### module_function def open(name, mode = 'r', perm = nil, options = {})                -> StringIO | Tempfile | IO
### module_function def open(name, mode = 'r', perm = nil, options = {}) {|ouri| ...}   -> object

name が http:// や ftp:// で始まっている文字列なら URI のリソースを
取得した上で [c:StringIO] オブジェクトまたは [c:Tempfile] オブジェクトとして返します。
返されるオブジェクトは [c:OpenURI::Meta] モジュールで extend されています。

name に open メソッドが定義されている場合は、*rest を引数として渡し
name.open(*rest, &block) のように name の open メソッドが呼ばれます。

これ以外の場合は、name はファイル名として扱われ、従来の
[m:Kernel?.open](name, *rest) が呼ばれます。

ブロックを与えた場合は上の場合と同様、name が http:// や ftp:// で
始まっている文字列なら URI のリソースを取得した上で [c:StringIO] オブジェクト
または [c:Tempfile] オブジェクトを引数としてブロックを評価します。後は同様です。
引数のオブジェクトは [c:OpenURI::Meta] モジュールで extend されています。

Ruby2.7以降、open-uriにより拡張されたKernel.openでURLを開くときにwarningが表示されるようになりました。

```ruby
require 'open-uri'
open("http://www.ruby-lang.org/") {|f|
  # ...
}
#=> warning: calling URI.open via Kernel#open is deprecated, call URI.open directly or use URI#open
```

- **param** `name` -- オープンしたいリソースを文字列で与えます。

- **param** `mode` -- モードを文字列で与えます。[m:Kernel?.open] と同じです。

- **param** `perm` -- [man:open(2)] の第 3 引数のように、ファイルを生成する場合のファイルのパーミッションを
            整数で指定します。[m:Kernel?.open] と同じです

- **param** `options` -- ハッシュを与えます。詳しくは [m:OpenURI.open_uri] を参照してください。

- **raise** `OpenURI::HTTPError` -- 対象となる URI のスキームが http であり、
                          かつリソースの取得に失敗した時に発生します。

- **raise** `Net::FTPError` -- 対象となる URI のスキームが ftp であり、かつリソースの取得に失敗した時に
                     [c:Net::FTPError] のサブクラスが発生します。詳しくは [lib:net/ftp]
                     を参照して下さい。

```ruby title="例"
require 'open-uri'
sio = open('http://www.example.com') { |sio|
  p sio.is_a?(OpenURI::Meta) # => true
  p sio.content_type
  puts sio.read
}
```

- **SEE** [m:OpenURI.open_uri], [m:URI.open]


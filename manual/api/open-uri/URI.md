---
library: open-uri
since: "2.5.0"
---
# reopen URI

## Class Methods

### def open(name, mode = 'r', perm = nil, options = {})                -> StringIO | Tempfile | IO
### def open(name, mode = 'r', perm = nil, options = {}) {|ouri| ...}   -> object

name が http:// や https://、ftp:// で始まっている文字列なら URI のリソースを
取得した上で [c:StringIO] オブジェクトまたは [c:Tempfile] オブジェクトとして返します。
返されるオブジェクトは [c:OpenURI::Meta] モジュールで extend されています。

name に open メソッドが定義されている場合は、*rest を引数として渡し
name.open(*rest, &block) のように name の open メソッドが呼ばれます。

これ以外の場合は、name はファイル名として扱われ、従来の
[m:Kernel?.open](name, *rest) が呼ばれます。

ブロックを与えた場合は上の場合と同様、name が http:// や https://、ftp:// で
始まっている文字列なら URI のリソースを取得した上で [c:StringIO] オブジェクト
または [c:Tempfile] オブジェクトを引数としてブロックを評価します。後は同様です。
引数のオブジェクトは [c:OpenURI::Meta] モジュールで extend されています。

- **param** `name` -- オープンしたいリソースを文字列で与えます。

- **param** `mode` -- モードを文字列で与えます。[m:Kernel?.open] の mode_enc とおおむね同じですが、
             外部エンコーディングの指定(ext_enc)は有効な一方、内部エンコーディングの指定
             (ext_enc:int_enc の int_enc)は無視されます。内部エンコーディングへの変換が
             必要な場合は、読み込んだ文字列を [m:String#encode] で変換してください
             (返り値のオブジェクトはレスポンスの大きさによって [c:StringIO] にも
             [c:Tempfile] ベースの IO にもなり、[m:IO#set_encoding] による内部
             エンコーディングへの変換は [c:StringIO] では行われないためです)。

```ruby title="例"
require 'open-uri'

# 外部エンコーディングとして cp932 を指定し、
# 読み込んだ文字列を String#encode で UTF-8 に変換する
URI.open('http://example.com/', 'r:cp932') do |f|
  f.read.encode('UTF-8', invalid: :replace, undef: :replace)
end
```

- **param** `perm` -- [man:open(2)] の第 3 引数のように、ファイルを生成する場合のファイルのパーミッションを
            整数で指定します。[m:Kernel?.open] と同じです

- **param** `options` -- ハッシュを与えます。詳しくは [m:OpenURI.open_uri] を参照してください。

- **raise** `OpenURI::HTTPError` -- 対象となる URI のスキームが http または https であり、
                          かつリソースの取得に失敗したときに発生します。

- **raise** `Net::FTPError` -- 対象となる URI のスキームが ftp であり、かつリソースの取得に失敗した時に
                     [c:Net::FTPError] のサブクラスが発生します。詳しくは [lib:net/ftp]
                     を参照して下さい。

- **SEE** [m:Kernel?.open], [m:OpenURI.open_uri]

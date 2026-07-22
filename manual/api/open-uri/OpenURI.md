---
library: open-uri
---
# module OpenURI
http/ftp に簡単にアクセスするためのモジュールです。

## Singleton Methods

### def open_uri(name, mode = 'r', perm = nil, options = {})                  -> StringIO
### def open_uri(name, mode = 'r', perm = nil, options = {}){|sio| ... }     -> nil

URI である文字列 name のリソースを取得して [c:StringIO] オブジェクト
として返します。

ブロックを与えた場合は [c:StringIO] オブジェクトを引数としてブロックを
評価します。ブロックの終了時に StringIO は close されます。nil を返します。

```ruby
require 'open-uri'
sio = OpenURI.open_uri('http://www.example.com')
p sio.last_modified
puts sio.read

OpenURI.open_uri('http://www.example.com'){|sio| sio.read }
```

options には [c:Hash] を与えます。理解するハッシュの
キーは以下のシンボル、
- :proxy
- :progress_proc
- :content_length_proc
- :http_basic_authentication
- :proxy_http_basic_authentication
- :read_timeout
- :ssl_ca_cert
- :ssl_verify_mode
- :ftp_active_mode
- :redirect
- :encoding
です。
「:content_length_proc」と「:progress_proc」はプログレスバーに
利用されることを想定しています。

```ruby
require 'open-uri'
sio = OpenURI.open_uri('http://www.example.com',
                       { :proxy => 'http://proxy.example.com:8000/',
                         :http_basic_authentication => [username, password] })
```

- **`:proxy`**:
  プロクシの設定をします。
  値には以下のいずれかを与えます。
  ```text
     文字列:           "http://proxy.example.com:8000/" のようなプロクシの URI。
     URI オブジェクト: URI.parse("http://proxy.example.com:8000/") のようなプロクシの URI オブジェクト。
     true:             Proxy を環境変数などから見つけようとする。使う環境変数は schema に応じて
                       http_proxy, https_proxy, ftp_proxy, no_proxy が使われる。
     false:            Proxy を用いない。
     nil:              Proxy を用いない。
  ```

- **`:http_basic_authentication`**:
  HTTP の Basic 認証のためのユーザ名とパスワードを、文字列の配列 ["user", "password"] として与えます。

- **`:content_length_proc`**:
  値にはブロックを与えます。ブロックは対象となる URI の
  Content-Length ヘッダの値を引数として、実際の転送が始まる前に評価されます。Redirect された場合は、
  実際に転送されるリソースの HTTP ヘッダを利用します。Content-Length ヘッダがない場合は、nil を
  引数としてブロックを評価します。ブロックの返り値は特に利用されません。

- **`:progress_proc`**:
  値にはブロックを与えます。ブロックは対象となる URI からデータの
  断片が転送されるたびに、その断片のサイズを引数として評価されます。ブロックの返り値は特に
  利用されません。

- **`:proxy_http_basic_authentication`**:
  パスワード付きプロクシの設定を与えます。
  設定には3要素の配列を渡します。
  最初の要素はプロクシのURIで、文字列かURIオブジェクトを指定します。
  2番目にはプロクシのユーザ名、3番目にはプロクシのパスワードを指定します。

  :proxy と :proxy_http_basic_authentication を同時に指定すると
  [c:ArgumentError] が発生します。

  ```text title="使い方"
     :proxy_http_basic_authentication =>
       ["http://proxy.example.com:8000/", "proxy-user", "proxy-password"]
     :proxy_http_basic_authentication =>
       [URI.parse("http://proxy.example.com:8000/"), "proxy-user", "proxy-password"]
  ```

- **`:read_timeout`**:
  http コネクションのタイムアウト秒数を指定します。nil でタイムアウトなしを
  指定できます。

- **`:ssl_ca_cert`**:
  SSL の CA 証明書を指定します。これを指定した場合は OpenSSL がデフォルトで使う
  CA 証明書は使われません。

  証明書のファイル名、証明書のディレクトリ名を指定できます。
  詳しくは
  [m:OpenSSL::X509::Store#add_file]、
  [m:OpenSSL::X509::Store#add_path]
  を参照してください。デフォルトの証明書については
  [m:OpenSSL::X509::Store#set_default_paths]
  を参照してください。

- **`:ssl_verify_mode`**:
  SSL の証明書の検証のモードを指定します。
  詳しくは [m:OpenSSL::SSL::SSLContext#verify_mode=] を参照してください。

- **`:ftp_active_mode`**:
  ftp を active mode で使うかどうかを指定します。
  デフォルトは false (passive mode) です。

- **`:redirect`**:
  HTTP でサーバがリダイレクトを指示してきたとき、
  対応するかどうかを指定します。
  デフォルトは true (リダイレクトする) です。

  HTTP と FTP の間のリダイレクトもこれで指定します。

- **`:encoding`**:
  取得した内容の外部エンコーディングを指定します。
  "euc-jp" のような文字列か [c:Encoding] オブジェクトを与えます。
  指定すると、返り値の StringIO オブジェクトの外部エンコーディングが
  その値に設定されます。指定しなかった場合は Content-Type ヘッダの
  charset に基づいて設定されます。いずれの場合も内容の変換(transcode)は
  行われず、エンコーディングが設定されるだけです。

  同じ指定を mode 引数の文字列("r:euc-jp" のように)で行うこともできますが、
  mode と :encoding の両方でエンコーディングを指定すると
  [c:ArgumentError] が発生します。

- **param** `name` -- オープンしたいリソースを文字列で与えます。

- **param** `mode` -- モードを文字列で与えます。[m:Kernel?.open] と同じです。

- **param** `perm` -- 無視されます。

- **param** `options` -- ハッシュを与えます。

- **return** -- 返り値である StringIO オブジェクトは [c:OpenURI::Meta] モジュールで extend されています。

- **raise** `OpenURI::HTTPError` -- 対象となる URI のスキームが http であり、
                          かつリソースの取得に失敗した時に発生します。

- **raise** `Net::FTPError` -- 対象となる URI のスキームが ftp であり、かつリソースの取得に失敗した時に
                     [c:Net::FTPError] のサブクラスが発生します。詳しくは [lib:net/ftp]
                     を参照して下さい。

- **raise** `ArgumentError` -- 与えられた mode が読み込みモードでなかった場合に発生します。


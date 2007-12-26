= 添付ライブラリ

Ruby は、ライブラリによるクラスやモジュール、メソッドの追加などの拡張
を行うことができます。以下は、標準で添付・配布されているライブラリの一
覧です。ライブラリの読み込みには ((<組み込み関数/require>)) を使用します。

== 添付ライブラリ一覧

((<添付ライブラリ/テキスト>))
/ ((<添付ライブラリ/ファイルフォーマット>))
/ ((<添付ライブラリ/ファイル>))
/ ((<添付ライブラリ/ネットワーク>))
/ ((<添付ライブラリ/入出力>))
/ ((<添付ライブラリ/文字コード>))
/ ((<添付ライブラリ/数学>))
/ ((<添付ライブラリ/データベース>))
/ ((<添付ライブラリ/画面制御・CUI>))
/ ((<添付ライブラリ/GUI>))
/ ((<添付ライブラリ/日付・時間>))
/ ((<添付ライブラリ/マルチスレッド・同期>))
/ ((<添付ライブラリ/Unix>))
/ ((<添付ライブラリ/MS Windows>))
/ ((<添付ライブラリ/GC>))
/ ((<添付ライブラリ/デザインパターン>))
/ ((<添付ライブラリ/開発ツール>))
/ ((<添付ライブラリ/コマンドライン>))
/ ((<添付ライブラリ/その他>))

=== テキスト

* ((<stringio|StringIO>))       文字列を IO にみせかける ((<ruby 1.7 feature>))
* ((<digest>))                  メッセージダイジェストライブラリ (MD5, RMD160, SHA1, SHA256, SHA384, SHA512) ((<ruby 1.6 feature>))
* ((<erb>))                     埋め込み Ruby (ERB) ((<ruby 1.8 feature>))
* ((<shellwords>))              シェルに似たトークン分割をするライブラリ
* ((<strscan>))                 高速スキャナ ((<ruby 1.7 feature>))
* ((<ripper>))                  Ruby プログラムのパーサ ((<ruby 1.9 feature>))

=== ファイルフォーマット

* ((<yaml|YAML>))               YAML (YAML Ain't Markup Language) ((<ruby 1.8 feature>))
* ((<rexml>))                   XML (The Extensible Markup Language) ((<ruby 1.8 feature>))
* ((<rss>))                     RSS ((<ruby 1.8.2 feature>))
* ((<zlib>))                    gzip, deflate 圧縮・伸張 ((<ruby 1.8 feature>))
* ((<mailread>))                Unix mbox なメールから情報を得る
* ((<csv>))                     CSV (Comma Separated Values) ((<ruby 1.8 feature>))

=== ファイル

* ((<fileutils>))               ファイル操作ユーティリティ ((<ruby 1.7 feature>))
* ((<find>))                    ファイル探索モジュール
* ((<pathname>))                パス名クラス ((<ruby 1.8 feature>))
* ((<tempfile>))                テンポラリファイル生成
* ((<tmpdir>))                  テンポラリディレクトリを返す ((<ruby 1.8 feature>))
* ((<un>))                      Unixコマンド like なファイル操作ユーティリティ ((<ruby 1.8 feature>))

=== ネットワーク

* ((<open-uri>))                open() の URI サポート拡張 ((<ruby 1.8 feature>))
* ((<socket>))                  ソケット拡張ライブラリ
* ((<uri|URI>))                 URI ライブラリ ((<ruby 1.6 feature>))
* ((<cgi>))                     CGI作成支援
* ((<"cgi/session">))           CGIセッション管理
* ((<webrick>))                 WEB server toolkit ((<ruby 1.8 feature>))
* ((<drb>))                     分散 Ruby (dRuby) ((<ruby 1.8 feature>))
* ((<rinda|Rinda>))             A Ruby implementation of the Linda distributed computing paradigm ((<ruby 1.8 feature>))
* ((<"net/ftp">))               FTP クライアントライブラリ
* ((<"net/ftptls">))            SSL/TLS 拡張 FTP クライアントライブラリ ((<ruby 1.8 feature>))
* ((<"net/http">))              HTTP クライアントライブラリ
* ((<"net/https">))             SSL/TLS 拡張 HTTP クライアントライブラリ ((<ruby 1.8 feature>))
* ((<"net/imap">))              IMAP クライアントライブラリ ((<ruby 1.6 feature>))
* ((<"net/pop">))               POP クライアントライブラリ
* ((<"net/smtp">))              SMTP クライアントライブラリ
* ((<"net/telnet">))            TELNET クライアントライブラリ
* ((<"net/telnets">))           SSL/TLS 拡張 TELNET クライアントライブラリ ((<ruby 1.8 feature>))
* ((<openssl>))                 Ruby/OpenSSL  ((<ruby 1.8 feature>))
* ((<resolv-replace>))          名前解決に resolv を使用する ((<ruby 1.6 feature>))
* ((<resolv>))                  Ruby版 リゾルバ ((<ruby 1.6 feature>))
* ((<xmlrpc|XMLRPC>))           XML-RPC (remote procedure calls over HTTP using XML) ((<ruby 1.8 feature>))
* ((<gserver>))                 Ruby Generic Server ((<ruby 1.8 feature>))
* ((<soap>))                    SOAP4R ((<ruby 1.8 feature>))
* ((<wsdl>))                    WSDL4R ((<ruby 1.8 feature>))
* ((<ping>))                    ホストに対するパケット到達の検証
* ((<ipaddr>))                  IPアドレスクラス(IPAddr) ((<ruby 1.8 feature>))

=== 入出力

* ((<fcntl>))                   ((<fcntl(2)|manual page>)) で使用する定数を集めたモジュール
* ((<open3>))                   外部プログラムと標準入力・標準出力・標準エラー出力で通信するライブラリ
* ((<readbytes>))               IO に指定した長さを確実に読むメソッドを追加するライブラリ
* ((<scanf>))                   C の scanf のようなライブラリ ((<ruby 1.8 feature>))
* ((<"io/nonblock">))           IO クラスの拡張 (nonblockモードに関するメソッドの追加) ((<ruby 1.8 feature>))
* ((<"io/wait">))               IO クラスの拡張 (IO の入力待ちを行うメソッドの追加) ((<ruby 1.8 feature>))

=== 文字コード

* ((<iconv>))                   文字列エンコーディング変換ライブラリ ((<ruby 1.7 feature>))
* ((<jcode>))                   Stringクラスを日本語対応に変更する
* ((<kconv>))                   漢字コード変換
* ((<nkf>))                     日本語文字コードエンコーディング変換

=== 数学

* ((<complex>))                 複素数クラス
* ((<rational>))                有理数クラス
* ((<matrix>))                  行列・ベクトルクラス
* ((<mathn>))                   数値演算メソッドを数学的に正しく変更するライブラリ
* ((<set>))                     有限集合 ((<ruby 1.7 feature>))
* ((<tsort>))                   トポロジカルソートと強連結成分 ((<ruby 1.7 feature>))
* ((<bigdecimal>))              可変長浮動小数点演算 ((<ruby 1.8 feature>))

=== データベース

* ((<dbm>))                     ndbm をハッシュのように使うためのライブラリ
* ((<gdbm>))                    gdbm (GNU dbm) をハッシュのように使うためのライブラリ
* ((<sdbm>))                    sdbm ハッシュライブラリ
* ((<pstore|PStore>))           オブジェクト永続化

=== 画面制御・CUI

* ((<curses>))                  端末操作ライブラリ curses のインターフェイス
* ((<expect>))                  対話プログラムをスクリプトから制御する
* ((<pty>))                     疑似端末(Pseudo tTY)を扱うモジュール
* ((<readline>))                GNU Readline インタフェース
* ((<shell>))                   シェルに似たインターフェースを提供するライブラリ

=== GUI

* ((<tk>))                      Tcl/Tk ライブラリ

=== 日付・時間

* ((<date>))                    日付クラス
* ((<time>))                    文字列とTimeオブジェクトの変換 ((<ruby 1.6 feature>))

=== マルチスレッド・同期

* ((<thread>))                  Mutex, Queue などのスレッド関連ユーティリティ
* ((<timeout>))                 タイムアウトを行うメソッド timeout
* ((<monitor>))                 モニタライブラリ (並行処理プリミティブ)
* ((<mutex_m>))                 Mutexのモジュール版
* ((<sync>))                    Mix-inにより再入可能なreader/writerロック機能を提供するライブラリ
* ((<thwait|ThreadsWait>))      thread synchronization class

=== Unix

* ((<etc>))                     (({/etc/passwd})) などの情報を取得するライブラリ
* ((<syslog|Syslog>))           UNIXのsyslogのラッパーモジュール ((<ruby 1.6 feature>))

=== MS Windows

* ((<Win32API>))                Win32 API をコールするクラス (win32 専用) 将来 dl/win32 で置き換えられる予定
* ((<WIN32OLE>))                Win32OLE 拡張モジュール ((<ruby 1.7 feature>))
* ((<"win32/registry">))        Win32 レジストリ I/F ((<ruby 1.7 feature>))

=== GC

* ((<weakref>))                 GC される「弱い」リファレンスを作成する
* ((<finalize>))                オブジェクトがGCされる時にある依存オブジェクトに対してメッセージを送るライブラリ

=== デザインパターン

* ((<delegate>))                委譲を支援するクラス
* ((<forwardable>))             クラスに対してメソッドの委譲機能を定義するライブラリ
* ((<observable>))              Observer パターンの Ruby 実装
* ((<singleton>))               Singleton パターンの Ruby 実装

=== 開発ツール

* ((<"test/unit"|Test::Unit>))  ユニットテストライブラリ ((<ruby 1.8 feature>))
* ((<pp>))                      Pretty-printer ((<ruby 1.7 feature>))
* ((<benchmark>))               ベンチマークライブラリ ((<ruby 1.7 feature>))
* ((<debug>))                   Ruby デバッガ
* ((<tracer>))                  Ruby のトレーサ
* ((<profiler>))                プロファイラライブラリ ((<ruby 1.7 feature>))
* ((<profile>))                 require するだけで使えるプロファイラ
* ((<mkmf>))                    拡張ライブラリ作成用ツール
* ((<rbconfig>))                Ruby インタプリタの設定情報
* ((<rubyunit>))                RubyUnit互換ライブラリ ((<ruby 1.8 feature>))

=== コマンドライン

* ((<optparse|OptionParser>))   コマンドラインオプションの解析 ((<ruby 1.7 feature>))
* ((<getoptlong>))              コマンドラインオプションの解析

=== その他

* ((<dl>))                      ダイナミックリンカへのインタフェース ((<ruby 1.7 feature>))
* ((<enumerator>))              each 以外のメソッドも enumerate できるようにするライブラリ ((<ruby 1.8 feature>))
* ((<generator>))               内部イテレータから外部イテレータへ変換するライブラリ ((<ruby 1.8 feature>))
* ((<abbrev>))                  Calculate the set of unique abbreviations for a given set of strings ((<ruby 1.8 feature>))
* ((<prettyprint>))             PrettyPrint ((<ruby 1.7 feature>))
* ((<ostruct>))                 Python 風の「attr on write」Struct
* ((<e2mmap>))                  例外クラスとメッセージのマッピング
* ((<English>))                 特殊変数 $! などに英語名の別名($ERROR_INFO など)をつける
* ((<logger>))                  a simple but sophisticated logging utility ((<ruby 1.8 feature>))
* ((<eregex>))                  正規表現の `|', `&' 演算子による結合を可能にする
* ((<racc runtime|racc>))       ((<Racc|URL:http://www.ruby-lang.org/en/raa-list.rhtml?name=Racc>)) ランタイムライブラリ ((<ruby 1.7 feature>))

=== obsolete
* ((<Env>))                     ((*このライブラリはobsoleteです*))
* ((<importenv>))               環境変数をグローバル変数で操作
* ((<cgi-lib>))                 ((*このライブラリはobsoleteです*))(((<cgi>))を使ってください)
* ((<date2>))                   ((*このライブラリはobsoleteです*))(((<date>))を使ってください)
* ((<getopts>))                 コマンドラインオプションの解析
* ((<parsearg>))                コマンドラインオプションの解析(((<getopts>))も参照)
* ((<parsedate>))               ((*このライブラリはobsoleteです*))
* ((<md5>))                     ((*このライブラリはobsoleteです*))(((<digest/"digest/md5">))を使ってください)
* ((<sha1>))                    ((*このライブラリはobsoleteです*))(((<digest/"digest/sha1">))を使ってください)
* ((<ftools>))                  1.8 以降では、ftools の利用は推奨しません。((<fileutils>))を使ってください。
* ((<base64>))                  Base64 エンコーディングを扱う操作を集めたモジュール (((<String#unpack|String/unpack>))、((<Array#pack|Array/pack>))で同等の処理ができます。((<packテンプレート文字列>))の'm'、'M'を参照してください)
* ((<final>))                   ((*このライブラリはobsoleteです*))(本体組み込みになりました。1.8 ではこのライブラリはなくなりました)
* ftplib                        ((*このライブラリはobsoleteです*))(代わりに ((<"net/ftp">)) を使用します。1.8 ではこのライブラリはなくなりました)
* telnet                        ((*このライブラリはobsoleteです*))(((<"net/telnet">))を使ってください。1.8 ではこのライブラリはなくなりました)


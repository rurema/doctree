= manual page

foo(1)という記述はマニュアルページの参照を示します(Unixでの話)。

  $ man 1 foo

などとして参照します。

数字はセクション番号を示します。例えば
* 1 コマンド
* 2 システムコール
* 3 ライブラリ関数
などと分類わけされています。各セクションの意味は intro(1) などに
説明がありますのでそちらも参照してください。

環境によってはシステムコールがライブラリ関数として実装されている
場合もあるので socket(2) が

  $ man 2 socket

でなく

  $ man 3 socket

の場合もあります。大抵セクションは省略して
  $ man socket
として参照すれば良いでしょう。

詳細は [[man:man(1)]] を参照してください。

UNIX 環境を触れない人は
* [[unknown:The Single UNIX(R) Specification V2|URL:http://www.unix-systems.org/single_unix_specification_v2/]]
* [[unknown:JM Project|URL:http://www.linux.or.jp/JM/]]
* [[unknown:jpman プロジェクト|URL:http://www.jp.freebsd.org/man-jp/]]
* [[unknown:X Japanese Documentation Project|URL:http://xjman.dsl.gr.jp/]]
* [[unknown:FreeBSD Hypertext Man Pages|URL:http://www.freebsd.org/cgi/man.cgi]]
* [[unknown:The Open Group Base Specifications Issue 6 IEEE Std 1003.1-2001|URL:http://www.opengroup.org/onlinepubs/007904975/idx/index.html]]
などを参照してください(この他にも情報があれば教えてください)。

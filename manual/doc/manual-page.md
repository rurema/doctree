# manual page

foo(1)という記述はマニュアルページの参照を示します(Unixでの話)。

```console
$ man 1 foo
```

などとして参照します。

数字はセクション番号を示します。例えば
 - 1 コマンド
 - 2 システムコール
 - 3 ライブラリ関数
などと分類わけされています。各セクションの意味は intro(1) などに
説明がありますのでそちらも参照してください。

環境によってはシステムコールがライブラリ関数として実装されている
場合もあるので socket(2) が

```console
$ man 2 socket
```

でなく

```console
$ man 3 socket
```

の場合もあります。大抵セクションは省略して
```console
$ man socket
```
として参照すれば良いでしょう。

詳細は [man:man(1)] を参照してください。

UNIX 環境を触れない人は
 - The Single UNIX Specification: <http://www.unix.org/what_is_unix/single_unix_specification.html>
 - JM Project: <https://linuxjm.osdn.jp/>
 - jpman プロジェクト: <http://www.jp.freebsd.org/man-jp/>
 - X Japanese Documentation Project: <http://xjman.dsl.gr.jp/>
 - FreeBSD Hypertext Man Pages: <https://www.freebsd.org/cgi/man.cgi>
 - The Open Group Base Specifications Issue 6 IEEE Std 1003.1, 2004 Edition: <https://pubs.opengroup.org/onlinepubs/007904975/idx/index.html>
などを参照してください(この他にも情報があれば教えてください)。

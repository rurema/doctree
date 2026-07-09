リリースパッケージの使いかたを解説します。

## これは何？
Rubyリファレンスマニュアルを使うためのパッケージです。

以下のものが含まれています。

* WEBrickを利用した簡易Webサーバシステム
* コマンドラインからリファレンスを検索するためのツール、refe2

## Webサーバの使い方

1. パッケージを展開

2. サーバを起動

* Windows : server.exe を実行
* それ以外 : ruby server.rb を実行

3. Webブラウザから、http://localhost:10080/ にアクセス

### オプション

* --port=NUM : HTTPサーバを動かすポートを指定します (デフォルトは10080)

## refe2の使い方

パッケージを展開すると、1.8.7 用、1.9.2 用のコマンドが使用できます。

例:

```
$ ./refe-1_8_7 Array.new
Array.new
--- new(size = 0, val = nil)    -> Array

長さ size の配列を生成し、各要素を val で初期化して返します。
...
```

1.9.2の場合はrefe-1_9_2を実行してください。

### 実行例

```
$ ./refe-1_8_7 String          Stringクラスの説明を表示
$ ./refe-1_8_7 String#         String のメソッド一覧を表示
$ ./refe-1_8_7 each_with_index Enumerable#each_with_index の説明を表示
$ ./refe-1_8_7 String#index    String#index の説明を表示
$ ./refe-1_8_7 inde            Array#index String#index など、一致する候補を表示
$ ./refe-1_8_7 st ind          String#index の説明を表示
```

### オプション

<dl>
<dt>-d, --database=PATH</dt>
<dd>リファレンスのデータベースのパス名を指定します。パッケージにはruby 1.8.7用とruby 1.9.2用の2種類のデータベースが同梱されています。</dd>
<dt>-a, --all</dt>
<dd>検索語に適合したエントリを全て表示します。</dd>
<dt>-l, --line</dt>
<dd>各行に検索語に適合するクラス、モジュール、メソッドのエントリだけを表示します</dd>
<dt>-e, --encoding=ENC</dt>
<dd>出力の文字エンコーディングを指定します。sjis, euc-jp, utf-8等。なお環境変数(LC_ALL, LC_MESSAGE, LANG)でロケールが指定されている場合は自動的に設定されます。</dd>
<dt>--class</dt>
<dd>クラスやモジュールを検索します。</dd>
<dt>--version</dt>
<dd>バージョンを表示してプログラムを終了します。</dd>
<dt>--help</dt>
<dd>ヘルプを表示してプログラムを終了します。</dd>
</dl>

### Tips

<dl>
<dt>Windows</dt>
<dd>
以下のような内容のrefe.batというファイルを作り、PATHの通ったところに置くと良いでしょう。

<pre>
@ruby -Ke -I c:/rubyrefm/bitclust/lib c:/rubyrefm/bitclust/bin/refe.rb -d c:/rubyrefm/db-1_8_7 -e sjis %*
</pre>
</dd>
<dt>vimユーザ</dt>
<dd><a href="http://blog.deadbeaf.org/2008/06/15/refe2-vim/">refe2.vim</a> というvimのプラグインが公開されています。</dd>
</dl>

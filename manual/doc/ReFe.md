# ReFe

ReFe は Ruby リファレンスマニュアルをコマンドラインから検索するツールです。
gem 名は refe2、コマンド名は `refe` で、現在は BitClust の一部として
[rurema/bitclust](https://github.com/rurema/bitclust) で開発されています。

### インストール

gem でインストールします。

```console
$ gem install refe2
```

次に、検索用データベースを構築します。

```console
$ bitclust setup
```

`bitclust setup` はリファレンスマニュアルのソース
([rurema/doctree](https://github.com/rurema/doctree)) を
`~/.bitclust/rubydoc` に取得し、`~/.bitclust` 配下に
バージョンごとのデータベースを構築します。
対象バージョンは `--versions` オプションで変更できます。
バージョンはリファレンスマニュアルの版と同じく `3.4` のように
teeny を省いた形式で指定します。

```console
$ bitclust setup --versions=3.4,4.0
```

マニュアルの更新を取り込むときは、もう一度 `bitclust setup` を実行します。

### 使い方

メソッド名やクラス名を指定すると、マッチしたエントリを表示します。

```console
$ refe Array#clear
Array#clear
### def clear    -> self

配列の要素をすべて削除して空にします。
(以下略)
```

クラス名とメソッド名を空白で区切って `refe Array clear` のように
指定することもできます。名前は前方一致で検索され、大文字小文字の
違いは無視されるので、うろ覚えでも引けます。

マッチしたエントリが複数あるときは名前の一覧が表示されます。

```console
$ refe map
Array#map Enumerable#map Enumerator::Lazy#map IO::Buffer.map
Matrix#map Vector#map
```

主なオプション:

- `-a`, `--all` -- マッチした全エントリの説明を表示します
- `-l`, `--line` -- 1 エントリを 1 行で表示します
- `--class` -- クラス名・モジュール名だけを検索します
- `-d PATH`, `--database=PATH` -- データベースの場所を指定します

既定以外の場所のデータベースを常用する場合は、環境変数 `REFE2_DATADIR`
でも指定できます。

詳細は BitClust の
[doc/usage.md](https://github.com/rurema/bitclust/blob/master/doc/usage.md)
を参照してください。

### 初代 ReFe について

初代の ReFe(1.x 系)は青木峰郎さん作の別実装のツールで、Ruby 1.8 時代の
リファレンスマニュアルを検索するものでした。現在の refe2 はこれを置き換えた
BitClust ベースの別実装です。初代 ReFe については
<http://i.loveruby.net/ja/prog/refe.html> を参照してください。

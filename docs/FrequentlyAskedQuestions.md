マニュアル執筆上でのありがちな疑問とその答え。

回答中の記法は 2026年7月の Markdown 移行後のものに更新してあります。
出典としてリンクしているメーリングリストの議論は旧記法（RRD）時代のものです。

## クラスリファレンスマニュアル関連

### obsolete や deprecated であるメソッドもエントリーに含めるのですか?

はい。正式な API である、または API であったメソッドはすべて
含めてください。ひらたく言うと、public メソッドとモジュール
関数、定数はすべて書くということです。[[ruby-reference-manual:174](http://www.fdiary.net/ml/ruby-reference-manual/msg/174)]

### 関数風メソッドのリファレンスでの書き方は?

[[ruby-reference-manual:109](http://www.fdiary.net/ml/ruby-reference-manual/msg/109)]

標準添付ライブラリで関数風メソッド (例えば parseArgs) を
追加しているときは、以下のように記述してください。

```markdown
# reopen Kernel

## Private Instance Methods

### def parseArgs(....) -> ()
```

最初の「# reopen Kernel」を抜かしたり、Private を抜かしたりする
ケースが散見されました。

### ライブラリのコードで autoload が使用されている場合、リファレンスに require を書くべきでしょうか。

ソースコードの、autoload が書いてある場所に require が書いてあるものと
考えてください。[[ruby-reference-manual:253](http://www.fdiary.net/ml/ruby-reference-manual/msg/253)]

### 「.#」や「?」ってなに?

[[ruby-reference-manual:143](http://www.fdiary.net/ml/ruby-reference-manual/msg/143)]

モジュール関数（クラスメソッドとしてもインスタンスメソッドとしても呼べるメソッド）を
表す記号です。旧記法（RRD）では「.#」を使って「CLASSNAME.#METHODNAME」と表記して
いましたが、Markdown 記法では RBS の `self?` に由来する「?」を使って
`CLASSNAME?.METHODNAME` と表記します。
また、BitClust だとモジュール関数は c.singleton_methods と
c.instance_methods の両方に出てくるので、ri との diff を取ると
BitClust のほうがエントリがすげー多く見えたりします。

### モジュール関数へのリンクは「.」？「#」？

[[ruby-reference-manual:409](http://www.fdiary.net/ml/ruby-reference-manual/msg/409)]

どちらでもなく「?」を使って下さい。

例:

```
[m:Math?.sin]
```

### reopen と redefine のすぐ後に説明の文章を書くとパースエラーになるのですが。

こういうものです。再定義の説明はライブラリのドキュメントに書いてください。
reopen/redefine の後に文章が書けたとしても結局は「追加する」ライブラリ
のドキュメントに表示するべきだと思うので、最初から表示されるところに書く
ということです。[[ruby-reference-manual:183](http://www.fdiary.net/ml/ruby-reference-manual/msg/183)]

### プラットフォーム依存の定数などは全部書くのですか?

プラットフォーム依存のものも含めて、全部載せてください。[[ruby-reference-manual:192](http://www.fdiary.net/ml/ruby-reference-manual/msg/192)]

### Rubyのバージョンによってクラス自体が存在しない場合はどんな風に書くの?

[[ruby-reference-manual:153](http://www.fdiary.net/ml/ruby-reference-manual/msg/153)]

そのクラスのファイルの front matter に `since:` / `until:` を書いてください
（[ClassReferenceManualFormat](ClassReferenceManualFormat.md) 参照）。

```yaml
---
library: _builtin
since: "3.2"
---
# class Data < Object
```

メソッド単位・本文単位の版分岐は従来どおり `#@since` / `#@until` で囲みます。

### Rubyのバージョンによってライブラリ自体が存在しない場合はどんな風に書くの?

[[ruby-reference-manual:169](http://www.fdiary.net/ml/ruby-reference-manual/msg/169)]

ライブラリ概要ファイル（`type: library`）の front matter に
`since:` / `until:` を書いてください（旧世界の src/LIBRARIES は廃止されました）。

### 「1.7.0 feature」など開発版のタグは残すのですか?

[[ruby-reference-manual:129](http://www.fdiary.net/ml/ruby-reference-manual/msg/129)]

開発版のタグは保存しなくて構いません。例えば #@since 1.7.0 は
#@since 1.8.0 にしてしまってください。

ついでに言えば、1.6.x のタグも必要ありません。

### default gem と bundled gemはどう書く？

default gemは組み込みクラスや標準ライブラリ同様内容まで記述してください。

bundled gemは最低限以下を記述してください。詳細な内容については要望等によって記述するか決めます。

* 概要
* rubygems.org のページへのリンク
    * https://rubygems.org/gems/<gem\>
* github.com のプロジェクトページ(あれば)へのリンク
    * https://github.com/<user\>/<gem\>
* rubydoc.info のページへのリンク
    * http://www.rubydoc.info/gems/<gem\>
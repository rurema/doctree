マニュアル執筆上でのありがちな疑問とその答え。このページは るりまメンバー向けです。ユーザー向けは [[PublicComments]] です。

## クラスリファレンスマニュアル関連

### obsolete や deprecated であるメソッドもエントリーに含めるのですか?

はい。正式な API である、または API であったメソッドはすべて
含めてください。ひらたく言うと、public メソッドとモジュール
関数、定数はすべて書くということです。[[ruby-reference-manual:174](http://www.fdiary.net/ml/ruby-reference-manual/msg/174)]

### 関数風メソッドのリファレンスでの書き方は?

[[ruby-reference-manual:109](http://www.fdiary.net/ml/ruby-reference-manual/msg/109)]

標準添付ライブラリで関数風メソッド (例えば parseArgs) を
追加しているときは、以下のように記述してください。

```
= reopen Kernel
== Private Instance Methods
--- parseArgs(....)
```

最初の「= reopen Kernel」を抜かしたり、Private を抜かしたりする
ケースが散見されました。

### ライブラリのコードで autoload が使用されている場合、リファレンスに require を書くべきでしょうか。

ソースコードの、autoload が書いてある場所に require が書いてあるものと
考えてください。[[ruby-reference-manual:253](http://www.fdiary.net/ml/ruby-reference-manual/msg/253)]

### 「.#」ってなに?

[[ruby-reference-manual:143](http://www.fdiary.net/ml/ruby-reference-manual/msg/143)]

BitClust ではモジュール関数
を表すとき、「.#」を使って「CLASSNAME.#METHODNAME」と表記します。
また、BitClust だとモジュール関数は c.singleton_methods と
c.instance_methods の両方に出てくるので、ri との diff を取ると
BitClust のほうがエントリがすげー多く見えたりします。

### モジュール関数へのリンクは「.」？「#」？それとも「.#」？

[[ruby-reference-manual:409](http://www.fdiary.net/ml/ruby-reference-manual/msg/409)]

「.#」を使って下さい。

例:

```
[[m:Math.#sin]]
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

クラス全体を #@if や #@since で囲んでください。

### Rubyのバージョンによってライブラリ自体が存在しない場合はどんな風に書くの?

[[ruby-reference-manual:169](http://www.fdiary.net/ml/ruby-reference-manual/msg/169)]

src/LIBRARIES ファイルに記載されているリストの該当部分を #@if や #@since で囲んで下さい。

### 「1.7.0 feature」など開発版のタグは残すのですか?

[[ruby-reference-manual:129](http://www.fdiary.net/ml/ruby-reference-manual/msg/129)]

trunk HEAD (いまなら 1.9.0) 以外の開発版のタグは保存しなくて
構いません。例えば #@since 1.7.0 は #@since 1.8.0 にして
しまってください。

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
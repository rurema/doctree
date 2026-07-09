# リファレンスマニュアルの書式まとめ

リファレンスマニュアルの書式のまとめです。
2026年7月に、RD ベースの独自記法（RRD）から **GitHub Flavored Markdown（GFM）ベースの記法**に移行しました。
ソースは doctree の `manual/` 配下の `.md` ファイルです。

より詳しくは、以下を参照してください。

* [MARKUP_SPEC.md](https://github.com/rurema/bitclust/blob/master/doc/markdown-samples/MARKUP_SPEC.md) — 記法の正式仕様（この文書はその要約です）
* [ClassReferenceManualFormat](ClassReferenceManualFormat.md) — ファイル全体の構造
* [HowToWriteMethodEntry](HowToWriteMethodEntry.md) — メソッドエントリの書き方
* [FrequentlyAskedQuestions](FrequentlyAskedQuestions.md)

## 文章の書き方

GitHub Flavored Markdown がベースです。段落は空行で区切り、段落内の改行は取り除かれます。

GFM に対する独自拡張は次の3つだけです。

1. クロスリファレンス: `[m:Array#each]` のようなリンク記法
2. メソッドシグネチャ: `### def method(args) -> Type` の `def`/`const`/`gvar` キーワード
3. プリプロセッサ指令: `#@since` / `#@until` など（旧記法から変更なし）

### サンプルコード

Ruby のサンプルコードは fenced code block で書きます。

````markdown
```ruby
puts "Hello, World!"
```
````

ラベルを付けたいときは `title="..."` を使います（旧 `#@samplecode ラベル` に相当）。

````markdown
```ruby title="例"
puts "Hello, World!"
```
````

サンプルコードの書き方の方針は [SampleCodeGuideline](SampleCodeGuideline.md) を参照してください。

### 整形済みテキスト（Ruby コード以外）

言語を指定しない fenced code block を使います。
他言語のコードは `` ```c `` のように言語を指定します（旧 `//emlist[ラベル][lang]{` に相当し、
`title="..."` でラベルも付けられます）。

### 箇条書き

```markdown
- 説明
  - ネストした説明
```

### 番号付きリスト

```markdown
1. 説明1
2. 説明2
```

### 定義リスト

GFM には定義リストがないため、ボールド + コロンのリスト形式で書きます。

```markdown
- **`type`**: Content-Type ヘッダです。デフォルトは "text/html" です。
- **`charset`**: ボディのキャラクタセットを Content-Type ヘッダに追加します。
```

コード的な用語はコードスパン付き `` **`term`** ``、日本語の用語はプレーンな `**用語**` にします。

### リンク（クロスリファレンス）

Ruby のクラスやメソッドなどへは以下のようにリンクを書きます
（旧記法 `[[c:String]]` から角括弧が1段減りました）。

|名前|説明(例)|
|-----|-----|
|クラス|`[c:String]`、`[c:File::Stat]` など|
|クラスメソッド|`[m:String.new]`|
|モジュール関数|`[m:Kernel?.open]`（旧記法の「`.#`」は「`?.`」に変わりました）|
|インスタンスメソッド|`[m:String#dump]` など|
|`[]` を含むメソッド|`[m:String#\[\]]`（バックスラッシュでエスケープ）|
|定数|`[m:File::SEPARATOR]` など|
|グローバル変数|`[m:$~]` など|

上記以外のものには以下のようにリンクを書きます。

|名前|説明(例)|
|-----|-----|
|ライブラリ|`[lib:json]` など|
|ドキュメント|`[d:spec/m17n]`、アンカー付きは `[d:spec/m17n#anchor]`|
|C 関数|`[f:rb_str_new]` など|
|ruby-list|`[ruby-list:12345]` など|
|feature|`[feature:12345]` など。https://bugs.ruby-lang.org/issues/12345 へのリンクになる|
|bug|`[bug:12345]` など。同上|
|man|`[man:tr(1)]` など|
|RFC|`[RFC:2822]` など|
|URL|通常の Markdown リンク（`<https://example.com>` や `[表示名](https://example.com)`）|

ページ内のアンカーへは標準 Markdown のフラグメントリンク `[テキスト](#anchor)` を使います
（アンカーは見出しに `{#anchor}` を付けて宣言します）。

## メソッド

メソッドのドキュメントは以下の順序で書きます。「★」が付いているものは必ず書かなければいけません。

1. ★シグネチャ（メソッド名、引数、返り値の型）
2. ★メソッドの要約。メソッドの概要を一段落で書く。これは各クラスのメソッド一覧にも載る
3. メソッドの詳しい説明
4. ★`- **param**` 引数の情報
5. `- **return**` 返り値の情報
6. `- **raise**` 発生する例外
7. その他の注意事項
8. 使用例
9. `- **SEE**` 他に参照すべきメソッドなど

````markdown
### def index(pattern, pos = 0)    -> Integer | nil

文字列のうちインデックス pos 以降の部分から
パターン pattern を検索し、そのインデックスを返します。
pattern が見付からなかったときは nil を返します。

必要ならここに詳しい説明。必要ならここに詳しい説明。

- **param** `pattern` -- 検索するパターンです。
           正規表現、文字列、文字コードを示す 0 から 255 の整数のいずれかを指定します。
- **param** `pos` -- 検索を始めるインデックスです。整数で指定します。
           負の数を指定したときは文字列の末尾から数えたインデックスとみなします。
- **return** -- 見付かった場合は要素のインデックスを、見付からなかったときは nil を返します。
- **raise** `ArgumentError` -- 上記以外の引数を渡し、かつそのオブジェクトが
           to_s メソッドを持たないときに発生します。

```ruby title="例"
p "strstrstr".index(/str/)       # => 0
p "strstrstr".index("str")       # => 0

p "strstrstr".index(/xxx/)       # => nil
p "strstrstr".index(/str/, 1)    # => 3
p "strstrstr".index(/str/, -3)   # => 6
```

- **SEE** [m:String#rindex]
````

### 引数の書き方

シグネチャは `### def` に続けて、Ruby のメソッド定義（def）と同じ書式で書きます。

旧リファレンスマニュアルでは「self + other」や「self[key] = value」のような書きかたも
許容されていましたが、必ず def と同じ書き方にしてください
（`### def +(other) -> String`、`### def []=(key, value)`）。

省略可能な引数は「pos = 0」のようにデフォルト値を明記してください。

それぞれの引数について `- **param**` で意味と制約条件（値の範囲や型）を必ず書きます。
2行目以降はインデントする必要があるのに注意してください。

詳しい規則（返り値の型の書き方を含む）は
[HowToWriteMethodEntry](HowToWriteMethodEntry.md) を参照してください。

### 特殊なメソッド

* 既存のクラスにメソッドを追加している場合は、reopen ブロックを使います。
  * 例えば、関数風メソッドなど Kernel にメソッドを追加する場合は以下のように書きます。

```markdown
# reopen Kernel

## Private Instance Methods

### def parseArgs(....) -> ()
```

* 既存のメソッドを再定義している場合は、redefine ブロックを使います。
* ENV や ARGV など特殊なオブジェクトについては、object ブロックが使われます。

## クラス、モジュール

クラスやモジュールは、front matter（メタデータ）と H1（宣言）で書き始めます。

```markdown
---
library: _builtin
include:
  - Enumerable
---
# class Array < Object

配列クラスです。

## Class Methods

### def new(size = 0, val = nil) -> Array
...
```

* クラス名・モジュール名は必ずトップレベルから書いてください（○ `Net::SMTP`、× `SMTP`）
* 所属ライブラリ（`library:`）と mixin（`include:` / `extend:`）、別名（`alias:`）は
  本文ではなく front matter に書きます
* 詳しくは [ClassReferenceManualFormat](ClassReferenceManualFormat.md) を参照してください

## 特殊な記法（プリプロセッサ指令）

BitClust への命令のために、「#@」から始まるいくつかの記法が定義されています。
これらは Markdown 移行後も**変更ありません**（`#@` は Markdown の見出しと解釈が
衝突しないため、安全に共存できます）。

### #@#

「#@#」の行はコメントです。

### #@include

「#@include(ファイルの相対パス名)」で共有断片ファイルをその位置に読み込みます
（`pack-template` など複数箇所で再利用される断片用。拡張子は省略できます）。

```
#@include(_builtin/pack-template)
```

### #@since

Ruby の特定のバージョン以降にあてはまる文章を書くのに使います。

```
#@since 3.1
Ruby 3.1 以降では 〜〜
#@end
```

* 3.1 からとしたい場合は `#@since 3.1.0` ではなく `#@since 3.1` と書いてください。
  2.7 以前では `#@since 2.7.0` のように `.0` をつけても構いませんが、
  3.0 以降では teeny の `.0` をつけません。
* 1.9 系からとしたい場合は、`#@since 1.9.0` ではなく `#@since 1.9.1` と書いてください。

### #@until

Ruby の特定バージョンより前にあてはまる文章を書くのに使います。

```
#@until 3.2
Ruby 3.2 にはこの機能が含まれません 〜〜〜
#@end
```

### #@if

Ruby の特定のバージョンにあてはまる文章を書くのに使います。条件には比較式のみ書けます。

```
#@if (version >= "3.1")
Ruby 3.1 以降では 〜〜
#@end
```

### #@todo

そのドキュメントが書きかけであるときに使います。

### クラスやライブラリ自体の版分岐

クラス・ライブラリ自体があるバージョンで追加・削除された場合は、本文の `#@since` ではなく
front matter の `since:` / `until:` を使います。
[ClassReferenceManualFormat](ClassReferenceManualFormat.md) を参照してください。

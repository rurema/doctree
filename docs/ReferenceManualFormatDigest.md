
リファレンスマニュアルの書式のまとめです。より詳しくは、

* [[ClassReferenceManualFormat]]
* [[HowToWriteMethodEntry]]
* [[FrequentlyAskedQuestions]]

を参照してください。

## 文章の書き方
基本的にはRDベースです。段落は空行で区切り、段落内の改行は取り除かれます。

### ソースコード

以下のようにプリプロセッサマクロを使用してください。

メソッドのサンプルコードは以下のように書きます。

```
#@samplecode 例
puts "Hello, World!"
#@end
```

例をより詳しく説明したラベルを付けたいときは以下のように書いてください。

```
#@samplecode 例の説明
puts "説明が必要な例"
#@end
```

地の文で説明が書かれているときなど、ラベルが不要なときはラベルを省略することができます。

```
#@samplecode
puts "No label"
#@end
```

より詳しい例は、[Stringのソース](https://github.com/rurema/doctree/blob/master/refm/api/src/_builtin/String)を見てください。

### 整形済みテキスト

行頭に空白を入れる。

ただし特殊な事情で空白を入れられない場合は以下のように書く。

```
//emlist{
リスト
//}
```

### 箇条書き
インデント＋「*」

```
[例]
  * 説明
    * ネストした説明
```

### 番号付きリスト
インデント＋「(1)」「(2)」…

```
[例]
  (1) 説明1
  (2) 説明2
```

### 定義リスト

```
[例]
  : 項目 1
    項目 1 の説明。
  : 項目 2
    項目 2 の説明。
  : 項目 3
    項目 3 の説明。
```

### リンク

Rubyのクラスやメソッドなどには以下のようにしてリンクを記述します。
[[ClassReferenceManualFormat]] のハイパーリンクの項により完全なリストが有ります。

|名前|説明(例)|
|-----|-----|
|クラス|`[[c:String]]`、`[[c:File::Stat]]` など|
|クラスメソッド|`[[m:String.new]]`|
|モジュール関数|`[[m:Math.#sin]]` (「.#」なのに注意)|
|インスタンスメソッド|`[[m:String#dump]]`、`[[m:String#[] ]]`など ([]の場合のみ空白必須なのに注意)|
|定数|`[[m:File::SEPARATOR]]` など|
|グローバル変数|`[[m:$~]]` など|

上記以外のものには以下のようにしてリンクを記述します。

|名前|説明(例)|
|-----|-----|
|ライブラリ|`[[lib:jcode]]` など|
|ruby-list|`[[ruby-list:12345]]` など|
|feature|`[[feature:12345]]`など。https://bugs.ruby-lang.org/issues/12345 へのリンクになる|
|bug|`[[bug:12345]]`など。https://bugs.ruby-lang.org/issues/12345 へのリンクになる|
|man|`[[man:tr(1)]]` など|
|RFC|`[[RFC:2822]]` など|
|URL|`[[url:http://i.loveruby.net]]` など|

## メソッド
メソッドのドキュメントは以下の順序で書きます。「★」が付いているものは必ず書かなければいけません。

1. ★シグネチャ(メソッド名、引数、返り値の型)
1. ★メソッドの要約。メソッドの概要を一段落で書く。これは各クラスのメソッド一覧にも載る
1. メソッドの詳しい説明
1. ★@param 引数の情報
1. @return 返り値の情報
1. @raise 発生する例外
1. その他の注意事項
1. 使用例
1. @see 他に参照すべきメソッドなど

```
[例]
--- index(pattern, pos = 0)    -> Integer | nil

文字列のうちインデックス pos 以降の部分から
パターン pattern を検索し、そのインデックスを返します。
pattern が見付からなかったときは nil を返します。

必要ならここに詳しい説明。必要ならここに詳しい説明。必要ならここに詳しい説明。
必要ならここに詳しい説明。必要ならここに詳しい説明。必要ならここに詳しい説明。

@param pattern   検索するパターンです。
                 正規表現、文字列、文字コードを示す 0 から 255 の整数のいずれかを指定します。
@param pos       検索を始めるインデックスです。整数で指定します。
                 負の数を指定したときは文字列の末尾から数えたインデックスとみなします。
@return          見付かった場合は要素のインデックスを、見付からなかったときは nil を返します。
@raise ArgumentError
                 上記以外の引数を渡し、かつそのオブジェクトが
                 to_s メソッドを持たないときに発生します。

#@samplecode 例
p "strstrstr".index(/str/)       # => 0      ← 引数 pattern の例
p "strstrstr".index("str")       # => 0
p "strstrstr".index(?s)          # => 0

p "strstrstr".index(/xxx/)       # => nil   ← 検索が失敗したときの例
p "strstrstr".index("xxx")       # => nil
p "strstrstr".index(?x)          # => nil

p "strstrstr".index(/str/, 0)    # => 0    ← pos 引数の例
p "strstrstr".index(/str/, 1)    # => 3
p "strstrstr".index(/str/, 3)    # => 3
p "strstrstr".index(/str/, 4)    # => 6

p "strstrstr".index(/str/, -1)   # => nil    ← 負の pos 引数の例
p "strstrstr".index(/str/, -2)   # => nil
p "strstrstr".index(/str/, -3)   # => 6
#@end

@see \[\[m:String#rindex]]
```

### 引数の書き方
引数はRubyのメソッド定義(def)と同じ書式で書きます。

旧リファレンスマニュアルでは「self + other」や「self[key] = value」のような書きかたも許容されていましたが、新マニュアルでは必ずdefと同じ書き方に直してください。

省略可能な引数を記述する際は、下記の「pos = 0」のように、デフォルト値を明記してください。

```
[例]
--- index(pattern, pos = 0)    -> Integer | nil
```

なお、デフォルト値が場合によって変わる場合等で書き方に困った時は、
メーリングリスト等で相談するとよいでしょう。

また、それぞれの引数について、@param で引数の意味と制約条件(値の範囲や型)を必ず書きます。
2行目以降はインデントする必要があるのに注意してください。

```
@param pattern   検索するパターンです。
                 正規表現、文字列、文字コードを示す 0 から 255 の整数のいずれかを指定します。
```

### 返り値の書き方
返り値の型は以下のように書きます。

|名前|説明(例)|
|-----|-----|
|(代入式の場合)|省略する。|
|特定の型|-> String|
|特定の型か、nil|-> String | nil (必ずnilを後に書く)|
|特定の型の配列|-> \[String\]|
|インデックスによって型が違う配列|-> \[Integer, String, String\]|
|ハッシュ|-> {Integer => String}|
|真偽値(trueまたはfalse)|-> bool (「boolean」ではないので注意)|
|true, false, nil|-> true, -> false, -> nil|
|self|-> self|
|どんな型でも返る可能性がある場合|-> object|
|返り値が決められていない場合|-> () (例：Thread.exit等)|
|複数の可能性がある場合|複数のシグネチャに分ける(それで上手くいかない場合は、-> String | \[String\] のように「|」を使って記述)|

### 特殊なメソッド
* 既存のクラスにメソッドを追加している場合は、reopenブロックを使います。
  * 例えば、関数風メソッドなどKernelにメソッドを追加する場合は以下のように書きます。

```
= reopen Kernel
== Private Instance Methods
--- parseArgs(....)
```

* 既存のメソッドを再定義している場合は、redefineブロックを使います。
* ENVやARGVなど特殊なオブジェクトについては、objectブロックが使われます。

### サンプルコードガイドライン
使用例のサンプルコードを記載する際のガイドラインは以下になります。  
[[SampleCodeGuideline]] 参照

## クラス、モジュール
クラスやモジュールの説明は以下のように書きます。

クラス名・モジュール名は必ずトップレベルから書いてください(○Net::SMTP、×SMTP)。

```
= class クラス名 < スーパークラス名  #モジュールの場合は module モジュール名
alias クラス名                       #別名(あれば)
     ：

extend モジュール名                  #extendしているモジュール(あれば)
     ：                              #  必ずextendの方を先に書く
include モジュール名                 #includeしているモジュール(あれば)
     ：

<クラスの説明>                       #省略可能
<クラスの説明>                       #章を作りたい場合は必ずレベル3(===)以上を使う

== Class Methods                     #または Singleton Methods
<クラスメソッドの説明>

== Private Singleton Methods         #(あれば)
== Protected Singleton Methods       #(あれば)

== Instance Methods
<インスタンスメソッドの説明>

== Private Instance Methods          #(あれば)
== Protected Instance Methods        #(あれば)

== Module Functions
<モジュール関数の説明>               #(public singleton method + private instance method)

== Constants
<定数の説明>

== Special Variables
<特殊定数の説明 (Kernelのみ) >
```

## ファイル全体
新リファレンスではライブラリごとにファイルが分割されています。各ファイルは以下のような構造をしています。

```
require ライブラリ名(クオートなし) #クオートは付けない(○require time、×require "time")
     ：
<ライブラリの説明>                 #省略可能

<クラス・モジュールの説明>
<クラス・モジュールの説明>
     ：
```

requireには、「このライブラリを require したとき、同時に使えると期待していいライブラリ」を記述します。詳しくは [[HowToWriteRequire]] を参照。

## 特殊な記法
BitClustへの命令のために、「#@」から始まるいくつかの記法が定義されています。

### #@#
「#@#」の行はコメントです。

### #@include
「#@include(ファイルの相対パス名)」で他のファイルをその位置に読み込みます。

```
#@include(HTTP)
#@include(HTTPHeader)
#@include(HTTPRequest)
#@include(HTTPResponse)
```

### #@since
Rubyの特定のバージョン以降にあてはまる文章を書くのに使います。

```
#@since 3.1
Ruby 3.1 以降では 〜〜
#@end
#@since 1.8.0
Ruby 1.8 以降では 〜〜
#@end
```

3.1からとしたい場合は `#@since 3.1.0` ではなく `#@since 3.1` と書いてください。

2.7以前では `#@since 2.7.0` のように `.0` をつけても構いませんが、3.0 以降では teeny の `.0` をつけません。

1.9系からとしたい場合は，`#@since 1.9.0` ではなく `#@since 1.9.1` と書いてください。

### #@until
Ruby の特定バージョンより前にあてはまる文章を書くのに使います。

```
#@until 3.2
Ruby 3.2 にはこの機能が含まれません 〜〜〜
#@end
#@until 1.9.1
Ruby 1.9.1 にはこの機能が含まれません 〜〜〜
#@end
```

### #@if
Rubyの特定のバージョンにあてはまる文章を書くのに使います。条件には比較式のみ書けます。

```
#@if (version >= "1.8.0")
Ruby 1.8 以降では 〜〜
#@end

#@if (version < "1.9.0")
このメソッドは将来削除されるので 〜〜
#@end
```

### #@samplecode

サンプルコードをシンタックスハイライトしたいときに使用します。

```
#@samplecode 例
puts "Hello, world!"
#@end

#@samplecode 例:例の説明
puts "Hello, world!"
#@end

#@samplecode
puts "ラベルは省略可能"
#@end
```

### #@todo
そのドキュメントが書きかけであるときに使います。

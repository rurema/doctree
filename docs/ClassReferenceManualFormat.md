クラスリファレンスのフォーマットは RD ベースです。
ただし、厳密にパースできるように制限を増やしてあります。

## ファイルの構造

新リファレンスではライブラリごとにファイルを分割します。
各ファイル (== ライブラリの記述) は以下のような構造をしています。

    require ライブラリ名
    require ライブラリ名
         ：
         ：

    <ライブラリのドキュメント>

    <レベル1ブロック>
    <レベル1ブロック>
         ：
         ：

ファイル冒頭では、「このライブラリを require したとき、同時に
使えると期待していいライブラリ」を記述します。文法は
「require ライブラリ名」です。詳しくは [[HowToWriteRequire]] を参照。
sublibrary については [[ruby-reference-manual:587](http://www.fdiary.net/ml/ruby-reference-manual/msg/587)] を参照。

    正: require time
    誤: require 'time'
    誤: require "time"

この require 行はいくつ書いても
構いません (ゼロ個でも構いません)。


続いてライブラリ自体のドキュメントを書きます。これは省略可能です。

最後に、以下に述べる「レベル 1 ブロック」を任意の回数記述します。
「レベル 1 ブロック」はクラスやモジュールの記述です。


## レベル 1 ブロック

レベル 1 ブロックはクラスやモジュールを記述します。
以下の種類があります。

<dl>
<dt>class</dt>
<dd>クラス</dd>
<dt>module</dt>
<dd>モジュール</dd>
<dt>reopen</dt>
<dd>既存クラスへのメソッドの追加 (time ライブラリなど)</dd>
<dt>redefine</dt>
<dd>既存メソッドの再定義 (jcode ライブラリ、mathn ライブラリなど)</dd>
<dt>object</dt>
<dd>オブジェクト (ほぼ ARGF と ENV 専用)</dd>
</dl>

レベル 1 ブロックは種類ごとに記述方法が違うので、
それぞれ個別に説明します。


## class ブロックと module ブロック

class ブロックは以下のような構造をしています。

    = class クラス名 < スーパークラス名
    alias クラス名
         ：

    extend モジュール名
    extend モジュール名
         ：
         ：
    include モジュール名
    include モジュール名
         ：
         ：

    <クラスのドキュメント>

    <レベル2ブロック>
    <レベル2ブロック>
         ：
         ：

module ブロックは以下のような構造をしています。

    = module モジュール名
    alias クラス名
         ：

    extend モジュール名
    extend モジュール名
         ：
         ：
    include モジュール名
    include モジュール名
         ：
         ：

    <モジュールのドキュメント>

    <レベル2ブロック>
    <レベル2ブロック>
         ：
         ：

レベル 1 ヘッダの直後には、そのクラスの別名を記述します。
例えば Net::SMTP には Net::SMTPSession という別名があるので、
次のように記述します。

    = class Net::SMTP
    alias Net::SMTPSession

そのあとに、そのクラスやモジュールが extend しているモジュール、
include しているモジュールを記述します。
extend, include はいくつ書いても構いません。
また、extend と include が両方ある場合は必ず extend を先に書かなければいけません。

続いてクラス・モジュール自身のドキュメントを書きます。省略可能です。
クラス・モジュールのドキュメントでヘッドラインを使いたいときは
レベル 3 (===) 以上を使ってください。

最後に「レベル 2 ブロック」を任意の回数だけ書きます。
「レベル 2 ブロック」は特定の種類と可視性をもったメソッドのグループです。

なお、すべての場合において、「クラス名」や「モジュール名」には絶対パスを使ってください。
例えば Net::SMTP を SMTP と書いてはいけません。


## reopen ブロックと redefine ブロック

reopen ブロックは、メソッドの追加を記述する場合に用います。
redefine ブロックは、メソッドの再定義を記述する場合に用います。

このとき「追加」とは、もともと存在しないメソッドを動的に定義することを言います
(例： time ライブラリは Time.parse を「追加」する)。

「再定義」とは、すでに定義されているメソッドを
(remove_method で) 消してから定義しなおすことを言います
(例： jcode ライブラリは String#tr を再定義する)。

reopen/redefine ブロックは以下のような構造をしています。

    = reopen クラス名

    extend モジュール名
    extend モジュール名
         ：
         ：
    include モジュール名
    include モジュール名
         ：
         ：

    <レベル2ブロック>
    <レベル2ブロック>
         ：
         ：

ヘッダの直後には、
そのクラスやモジュールが動的に extend しているモジュール、
include しているモジュールを記述します。
extend, include はいくつ書いても構いません。
また、extend と include が両方ある場合は必ず extend を先に書かなければいけません。

reopen/redefine ブロックにはドキュメントは記述できません。

最後に「レベル 2 ブロック」を任意の回数だけ書きます。
「レベル 2 ブロック」は特定の種類と可視性をもったメソッドのグループです。

なお、すべての場合において、「クラス名」や「モジュール名」には絶対パスを使ってください。
例えば Net::SMTP を SMTP と書いてはいけません。


## object ブロック

object ブロックは ENV や ARGF のように特異メソッドを定義された
オブジェクトを記述するために用います。

object ブロックは以下のような構造をしています。

    = object オブジェクト名 < クラス名

    extend モジュール名
    extend モジュール名
         ：
         ：

    <オブジェクトのドキュメント>

    <メソッドエントリ>
    <メソッドエントリ>
         ：
         ：

object ヘッダには、そのオブジェクト名 (「ENV」など) とクラス名を記述します。
クラス名は省略可能で、省略すると Object になります。

object ヘッダの直後には、
そのクラスやモジュールが extend しているモジュールを記述します。
extend はいくつ書いても構いません。
なお、object ブロックには include は記述できません。

続いてオブジェクト自身のドキュメントを書きます。
省略可能です。
オブジェクトのドキュメントでヘッドラインを使いたいときは
レベル 3 (===) 以上にしてください。

最後に「メソッドエントリ」を任意の回数だけ書きます。
object ブロックではメソッドの種類が Public Singleton Method に固定されるので、
「Singleton Method」などのレベル 2 ヘッダは記述できません。


## レベル 2 ブロック

レベル 2 ブロックは特定の種類と可視性をもったメソッドのグループを表現します。
レベル 2 ブロックは以下のような構造をしています。

    == Singleton Methods
    <メソッドエントリ>
    <メソッドエントリ>
          ：
          ：

レベル 2 ヘッダ (「==」) には以下の種類があります。

<dl>
<dt>Singleton Methods または Class Methods</dt>
<dd>public な特異メソッド</dd>
<dt>Private Singleton Methods</dt>
<dd>private な特異メソッド</dd>
<dt>Protected Singleton Methods</dt>
<dd>protected な特異メソッド</dd>
<dt>Instance Methods</dt>
<dd>public なインスタンスメソッド</dd>
<dt>Private Instance Methods</dt>
<dd>private なインスタンスメソッド</dd>
<dt>Protected Instance Methods</dt>
<dd>protected なインスタンスメソッド</dd>
<dt>Module Functions</dt>
<dd>モジュール関数 (public singleton method + private instance method)</dd>
<dt>Constants</dt>
<dd>定数</dd>
<dt>Special Variables</dt>
<dd>特殊定数 (Kernel 限定)</dd>
</dl>

## メソッドの記述方法

[[HowToWriteMethodEntry]] を参照して下さい。

## 通常のテキストの文法

ライブラリのドキュメント、クラスのドキュメント、
メソッドのドキュメントでは以下に述べる共通の文法を使います。

### 段落

通常の段落はインデントなしで書きます。

### リスト

インデントするとリストになります。

[例]

    テキスト〜

        p Object.new

特殊な事情があってインデントが使えない場合は
以下の記法を使ってください。

    //emlist{
    リスト
    //}

    ※ 「//emlist{」と「//}」はインデントしない

### 箇条書き

箇条書きは「インデント + '*'」です。インデントなしは不可です。

[例]

    テキスト〜

        * 項目 1
        * 項目 2
        * 項目 3

* 項目 1
* 項目 2
* 項目 3

### 番号付きの箇条書き

番号付きの箇条書きは「インデント + (1), (2), ...」です。
インデントなしは不可です。

[例]

    テキスト〜

        (1) 項目 1
        (2) 項目 2
        (3) 項目 3

1. 項目 1
2. 項目 2
3. 項目 3

### 定義リスト

定義リストは「 : + インデント + ...」で定義項目、「インデント + ...」で
定義の説明です。

[例]
    テキスト〜

    : 項目 1
      項目 1 の説明。
    : 項目 2
      項目 2 の説明。
    : 項目 3
      項目 3 の説明。

<dl>
<dt>項目 1</dt>
<dd>項目 1 の説明。</dd>
<dt>項目 2</dt>
<dd>項目 2 の説明。</dd>
<dt>項目 3</dt>
<dd>項目 3 の説明。</dd>
</dl>

### ハイパーリンク

以下のようなハイパーリンク記法が使えます。

<dl>
<dt>[<!-- -->[c:String]]</dt>
<dd>クラス String にリンク</dd>
<dt>[<!-- -->[c:File::Stat]]</dt>
<dd>クラス File::Stat にリンク</dd>
<dt>[<!-- -->[m:String.new]]</dt>
<dd>メソッド String.new にリンク</dd>
<dt>[<!-- -->[m:String#dump]]</dt>
<dd>メソッド String#dump にリンク</dd>
<dt>[<!-- -->[m:String#[] ]]</dt>
<dd>メソッド String#[] にリンク ([]の場合のみ空白は必須)</dd>
<dt>[<!-- -->[m:Math.#sin]]</dt>
<dd>モジュール関数 Math.#sin にリンク (「.#」なのに注意)</dd>
<dt>[<!-- -->[m:File::SEPARATOR]]</dt>
<dd>定数 File::SEPARATOR にリンク</dd>
<dt>[<!-- -->[m:$~]]</dt>
<dd>特殊変数 $~ にリンク</dd>
<dt>[<!-- -->[lib:jcode]]</dt>
<dd>ライブラリ jcode にリンク</dd>
<dt>[<!-- -->[d:spec/intro]]</dt>
<dd>ドキュメント spec/intro.rd にリンク</dd>
<dt>[<!-- -->[ref:class]]</dt>
<dd>
同一ページ内の class にリンク
(同一ページ内に「===[a:class] クラス定義」のようなレベル3以上のブロックが必要)
</dd>
<dt>[<!-- -->[ref:d:spec/def#class]]</dt>
<dd>
ドキュメント spec/def.rd 内の class にリンク
(spec/def.rd 内に「===[a:class] クラス定義」のようなレベル3以上のブロックが必要)
</dd>
<dt>[<!-- -->[ref:lib:socket#pack_string]]</dt>
<dd>
ライブラリ socket 内の pack_string にリンク
(ライブラリ socket 内に「===[a:pack_string] ソケットアドレス構造体を pack した文字列」のようなレベル3以上のブロックが必要)
</dd>
<dt>[<!-- -->[ref:c:FileUtils#options]]</dt>
<dd>
クラス FileUtils 内の options にリンク
(FileUtils のクラスの説明の中に「===[a:options] オプションの説明」のようなレベル3以上のブロックが必要。ただし、メソッドの説明中にはリンクできない)
</dd>
<dt>[<!-- -->[ref:<!-- -->m:String#scanf#format]]</dt>
<dd>
メソッド String#scanf 内の format にリンク
(String#scanf のメソッドの説明の中に「===[a:format] scanfフォーマット文字列」のようなレベル3以上のブロックが必要。ただし、クラスの説明中にはリンクできない)
</dd>
<dt>[<!-- -->[ruby-list:12345]]</dt>
<dd>ruby-list 12345 番にリンク</dd>
<dt>[<!-- -->[ruby-dev:12345]]</dt>
<dd>ruby-dev 12345 番にリンク</dd>
<dt>[<!-- -->[ruby-ext:12345]]</dt>
<dd>ruby-ext 12345 番にリンク</dd>
<dt>[<!-- -->[ruby-talk:12345]]</dt>
<dd>ruby-talk 12345 番にリンク</dd>
<dt>[<!-- -->[ruby-core:12345]]</dt>
<dd>ruby-core 12345 番にリンク</dd>
<dt>[<!-- -->[man:tr(1)]]</dt>
<dd>man ページ tr(1) にリンク</dd>
<dt>[<!-- -->[RFC:2822]]</dt>
<dd>RFC2822 にリンク</dd>
<dt>[<!-- -->[url:http://i.loveruby.net]]</dt>
<dd>URL「http://i.loveruby.net」にリンク</dd>
</dl>

### 既存リファレンスから削除された機能

RD の (('(({...}))')) や (('((|...|))')) はサポートしません。
bc-convert.rb を使うと自動的にすべて削除されます。

脚注とコメントも廃止されました。コメントを書きたい場合は
プリプロセッサコメント「#@# ...」を使ってください。


## プリプロセッサ

各ファイルは事前に専用プリプロセッサで処理されます。プリプロセッサ
の命令はすべて行単位で、すべて「#@」で始まります。

### #@#

「#@#」の行はコメントです。

### #@include

「#@include(ファイル名)」で他のファイルをテキスト的に結合できます。
「ファイル名」は #@include の書かれているファイルからの相対パスを
探します。

[例]

    #@include(HTTP)
    #@include(HTTPHeader)
    #@include(HTTPRequest)
    #@include(HTTPResponse)

### #@since

「#@since バージョン 〜 #@end」でバージョン依存コンパイルができます。
例えば Ruby 1.8.0 以降にのみ適用される文章は以下のように記述します。

[例]

    #@since 1.8.0
    Ruby 1.8 以降では 〜〜
    #@end

1.9系からとしたい場合は，#@since 1.9.0 ではなく #@since 1.9.1 と書いてください。

3.1からとしたい場合は `#@since 3.1.0` ではなく `#@since 3.1` と書いてください。

「#@since」命令は #@if 命令の特殊形です。

### #@if

「#@if(条件) 〜 #@else 〜 #@end 」でバージョン依存コンパイルが
できます。例えば Ruby 1.8.0 以降にのみ適用される文章は以下
のように記述します。

[例]

    #@if (version >= "1.8.0")
    Ruby 1.8 以降では 〜〜
    #@end

    #@if (version < "1.9.0")
    このメソッドは将来削除されるので 〜〜
    #@end

いまのところ条件式の評価はテキトーなので、比較式 (>= とか == とか)
しか使えません。他の式が使いたいときは ML で相談してください。

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

「#@todo」は、そのドキュメントが書きかけであることを示します。
コンパイル時は単に無視されます。


## 関連

* [[FrequentlyAskedQuestions]]

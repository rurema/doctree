# コメント

  - [ref:line_comment]
  - [ref:embedded_document]
  - [ref:magic_comment]
  - [ref:encoding]
  - [ref:frozen_string_literal]
  - [ref:warn_indent]
#@since 3.0
  - [ref:shareable_constant_value]
#@end

Ruby のコメントには、`#` から行末までを対象とする行コメントと、
`=begin` から `=end` までの行を対象とする埋め込みドキュメントの
2 種類があります(字句規則については [ref:d:spec/lexical#comment] も参照してください)。

また、ソースファイルの先頭に書かれた特定の形式のコメントは「マジックコメント」
と呼ばれ、通常のコメントとは違い、Ruby の処理系に対してエンコーディングの
指定や文字列リテラルの扱いなどを伝える働きを持ちます。

### 行コメント {#line_comment}

```ruby title="例"
# これは行コメントです。
p 1 + 1  # 式の後ろに書いたコメントです。
```

`#` から行末まではコメントとみなされ、Ruby インタプリタからは無視されます。
ただし文字列リテラルの中の `#` や、`?#` という文字リテラルの `#` は
コメントの開始とはみなされません。

### 埋め込みドキュメント(`=begin` 〜 `=end`) {#embedded_document}

```ruby title="例"
=begin
ここから =end のある行までは
複数行にわたるコメント(埋め込みドキュメント)になります。
=end
puts "hello"
```

行頭(桁 0、インデントなし)から始まる `=begin` の行から、同じく行頭から
始まる `=end` の行までの間はまとめてコメントとして扱われ、Ruby インタプリ
タからは無視されます。`=begin` と `=end` はどちらもインデントすると
埋め込みドキュメントとして認識されず、構文エラーになります。

```text title="インデントすると構文エラーになる例"
x = 1
  =begin
  この =begin はインデントされているため
  埋め込みドキュメントの開始として認識されません。
  =end
```

`=begin`・`=end` の行には、続けて自由な文字列を書くこともできます
(その部分も無視されます)。

```ruby title="例"
=begin タイトルなど自由に書けます
本文
=end 任意の文字列
puts "hello"
```

Ruby インタプリタは埋め込みドキュメントの中身の書式を規定しませんが、
慣習として RD 形式で書かれることが期待されています。

### マジックコメントとは {#magic_comment}

マジックコメントとは、ソースファイルの先頭部分に書かれた特定の形式の
コメントのことで、Ruby の処理系に対してそのファイルの解釈方法に関する
指示を伝えるものです。通常のコメントと違い、書ける位置と書き方の形式が
決まっています。

  - マジックコメントが効果を持つのは、それが書かれたファイル自身に
    対してだけです。`require`/`load` で読み込む他のファイルや、
    `eval` で評価する文字列には影響しません。
  - ソースコード(実際に実行されるコード)より前に書かれている必要が
    あります。一度でも実行コードが出現した後に書いても無視されます。
  - ファイルの 1 行目が `#!` から始まる shebang 行
    ([ref:d:spec/rubycmd#shebang]) である場合、マジックコメントは
    2 行目以降から探されます。

現在 Ruby が認識するマジックコメントには以下のものがあります。

  - エンコーディングの指定([ref:encoding])
  - 文字列リテラルの凍結([ref:frozen_string_literal])
  - インデント不整合の警告([ref:warn_indent])
#@since 3.0
  - 定数の Ractor 共有可能化([ref:shareable_constant_value])
#@end

このうち、エンコーディングの指定だけは特別扱いされていて、ファイルの
1 行目(shebang がある場合は 2 行目)に厳密に書かれている必要があります。
空行や他のコメント行を挟んだ位置に書いても認識されません。

#@since 3.0
それ以外のマジックコメント(frozen_string_literal, warn_indent,
shareable_constant_value)は、実行コードより前であれば、複数のコメント行
や空行、`=begin`〜`=end` を挟んだ後に書いても認識されます。
#@else
それ以外のマジックコメント(frozen_string_literal, warn_indent)は、実行
コードより前であれば、複数のコメント行や空行、`=begin`〜`=end` を挟んだ
後に書いても認識されます。
#@end

```ruby title="例(frozen_string_literalは複数のコメント行の後でも認識される)"
# ファイルの説明などの通常のコメント
# 続きのコメント

# frozen_string_literal: true
p "abc".frozen?  #=> true
```

複数のマジックコメントを、emacs のモードライン形式でまとめて 1 行に
書くこともできます。

```ruby title="例"
# -*- coding: utf-8; frozen_string_literal: true -*-
p __ENCODING__     #=> #<Encoding:UTF-8>
p "abc".frozen?    #=> true
```

### エンコーディングの指定 {#encoding}

```ruby title="例"
# coding: euc-jp
p __ENCODING__  #=> #<Encoding:EUC-JP>
```

ソースファイルのエンコーディング(スクリプトエンコーディング)を指定
します。以下のいずれの書き方でも認識されます。

```text
# encoding: euc-jp
# coding: euc-jp
# -*- coding: euc-jp -*-
```

Ruby 2.0 以降、マジックコメントが無い場合のデフォルトのスクリプト
エンコーディングは UTF-8 です(Ruby 1.9 では US-ASCII でした)。

マジックコメントが指定されなかった場合の決定規則(コマンドライン引数
や shebang との優先順位など)や、shebang 行がある場合の書き方など、
より詳しい内容については [ref:d:spec/m17n#magic_comment] を参照して
ください。[c:Encoding] クラス、[m:Encoding.default_external] も
参照してください。

### 文字列リテラルの凍結(`frozen_string_literal`) {#frozen_string_literal}

```ruby title="例"
# frozen_string_literal: true

s = "abc"
p s.frozen?  #=> true

begin
  s << "d"
rescue => e
  p e.class  #=> FrozenError
end
```

`true` を指定すると、そのファイル内の文字列リテラルから生成される
[c:String] オブジェクトが、生成された時点であらかじめ freeze された
状態になります。`false`(指定しなかった場合のデフォルト)では、この
機能は無効です。

この設定はファイル単位で有効になります。`require`/`load` で読み込んだ
他のファイルの文字列リテラルや、`eval` で評価した文字列リテラルには
影響しません。

```ruby title="例(require先やevalには伝播しない)"
# frozen_string_literal: true
eval('p "abc".frozen?')  #=> false
```

freeze されていないコピーが必要な場合は [m:Object#dup] や単項演算子
`+`([m:String#+@])が、明示的に freeze したコピーが必要な場合は
単項演算子 `-`([m:String#-@])が使えます。

### インデント不整合の警告(`warn_indent`) {#warn_indent}

```ruby title="例"
# warn_indent: true

def foo
  if true
    puts "x"
    end  # if に対して end のインデントの深さが揃っていない
end
```

```console
$ ruby -w indent.rb
indent.rb:6: warning: mismatched indentations at 'end' with 'if' at 4
```

`end` と、それに対応するキーワード(`if` など)とでインデントの深さが
異なる場合に警告を出すかどうかを指定します。この警告自体はデフォルトで
有効になっていますが、実際に表示されるのは `-w` オプションや `-W2`
を指定して実行した場合(`$VERBOSE` が true の場合)に限られます。

`# warn_indent: false` と指定すると、`-w`/`-W2` を指定して実行した
場合でもこの警告を抑制できます。意図的に特殊なインデントを使うコード
(DSL やコード生成物など)で警告を消したい場合に使われます。

#@since 3.0
### 定数の Ractor 共有可能化(`shareable_constant_value`) {#shareable_constant_value}

```ruby title="例"
# shareable_constant_value: literal

FOO = {a: 1, b: [1, 2, 3]}
p Ractor.shareable?(FOO)  #=> true
p FOO.frozen?             #=> true
```

このマジックコメントより後にある定数への代入について、その値をどこまで
自動的に [c:Ractor] で共有可能([m:Ractor.shareable?])にするかを指定します。
以下のいずれかを指定します。

  - **`none`**(デフォルト): 何もしません。通常通りの代入を行います。
  - **`literal`**: 代入される値がリテラルであり、かつその中身も再帰的に
    共有可能な値だけからなる場合に、freeze して共有可能にします。
  - **`experimental_everything`**: 代入される値がリテラルであるかに
    関わらず、[m:Ractor.make_shareable] を使って共有可能にします
    (実験的機能)。
  - **`experimental_copy`**: `experimental_everything` と同様ですが、
    共有可能でない値の場合、元のオブジェクトを直接 freeze するのでは
    なく、コピーしてから freeze して共有可能にします([m:Ractor.make_shareable]
    の `copy: true` に相当、実験的機能)。

```ruby title="例(experimental_copyは代入前にコピーを作る)"
# shareable_constant_value: experimental_copy

obj = Object.new
FOO = obj
p Ractor.shareable?(FOO)  #=> true
p FOO.equal?(obj)         #=> false (コピーされている)
```
#@end

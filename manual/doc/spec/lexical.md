# 字句構造

  - [ref:identifier]
  - [ref:comment]
  - [ref:embed]
  - [ref:reserved]

Rubyのソースコードのエンコーディング(スクリプトエンコーディング)は、
マジックコメントを指定しない場合 UTF-8 です。マジックコメントを
使うことで UTF-8 以外のエンコーディングも指定できます(詳細は
[d:spec/comment]、[d:spec/m17n] を参照してください)。アル
ファベットの大文字と小文字は区別されます。識別子と一部のリテ
ラルの途中を除いては任意の場所に空白文字やコメントを置くこと
ができます。空白文字とはスペース、タブ、垂直タブ、バックスペー
ス、キャリッジリターン、ラインフィード、改ページです。改行は行が明らかに次の
行に継続する時だけ、空白文字として、それ以外では文の区切りと
して解釈されます。行が演算子などで終わっていて明らかに継続する場合の他、
次の行が `.` または `&.` から始まる場合も前の行の継続とみなされます。

```ruby title="行頭ドットによる行継続の例"
"abc"
  .upcase   # => "ABC"（前の行に継続するので1つの式になる）
```

改行と認識されるのは、キャリッジリターン+ラインフィードかラインフィードです。

### 識別子 {#identifier}

```text title="例"
foobar
ruby_is_simple
ねこ
_x1
```

Rubyの識別子は英字またはアンダースコア('_')から始まり、英字、
アンダースコア('_')または数字からなります。識別子の長さに制限
はありません。

ソースコードのエンコーディングが ASCII 以外の場合は、英字に加
えて日本語などの ASCII の範囲外の文字も識別子に使えます(ソー
スコードのエンコーディングについては [d:spec/m17n] を参照して
ください)。アルファベット大文字([A-Z])で始まる識別子、および
(ソースコードのエンコーディングが Unicode の場合)Unicode の大
文字またはタイトルケース文字で始まる識別子は定数と解釈されま
す(詳細は [ref:d:spec/variables#const] を参照してください)。

メソッド名にはこの識別子の他に、識別子の末尾に `?` や `!` を
付けたものや、`==` や `+` のような再定義可能な演算子も使えます
([d:spec/call]、[ref:d:spec/def#method] を参照してください)。

### コメント {#comment}

```text title="例"
# this is a comment line
```

スクリプト言語の習慣にならい、文字列中や文字リテラル `?#` 以外の
\#から行末までをコメントと見なします。

コメントの詳細やマジックコメント(ファイル先頭の特別な形式のコメント)
については [d:spec/comment] を参照してください。

### 埋め込みドキュメント {#embed}

```text title="例"
=begin
the everything between a line beginning with `=begin' and
that with `=end' will be skipped by the interpreter.
=end
```

Rubyのソースコードにドキュメントを埋め込む事ができます。文が
始まる部分の行頭の=beginから、=endで始まる行までが
埋め込みドキュメントです。Ruby インタプリタとしては内容に縛りは
かけませんが、通常は RD 形式でドキュメントを埋め込むことを
期待しています(詳細は [d:spec/comment] を参照してください)。

### 予約語 {#reserved}

予約語は以下のものです。

```text
BEGIN    class    ensure   nil      self     when
END      def      false    not      super    while
alias    defined? for      or       then     yield
and      do       if       redo     true     __LINE__
begin    else     in       rescue   undef    __FILE__
break    elsif    module   retry    unless   __ENCODING__
case     end      next     return   until
```

予約語はクラス名、変数名などに用いることはできません。ただし
接頭辞$, @、@@が先頭についたものは予約語
とは見なされません。また、def のあとやメソッド呼び出しの
ピリオドのあとなどメソッド名であるとはっきり分かる場所では
メソッド名として用いることができます。

また、番号指定パラメータは変数名、def で定義するメソッド名に用いることはできません。

```text
_1 _2 _3 _4 _5 _6 _7 _8 _9
```

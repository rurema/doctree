---
library: prism
since: "3.4"
---
# class Prism::Result < Object

[m:Prism?.parse]・[m:Prism?.lex]・[m:Prism?.parse_lex] などの解析系メソッドの戻り値([c:Prism::ParseResult]・[c:Prism::LexResult]・
[c:Prism::ParseLexResult])の共通基底クラスです。解析結果本体
(`value`)以外の付随情報(コメント・マジックコメント・エラー・警告・ソースコード)を保持します。

Ruby 3.3 の prism にはこのクラスはなく、[c:Prism::ParseResult] がこれらのメソッドを直接持っていました。

- **SEE** [c:Prism::ParseResult], [c:Prism::LexResult], [c:Prism::ParseLexResult]

## Instance Methods

### def comments -> Array

解析中に見つかったコメント([c:Prism::Comment] のサブクラスのインスタンス)の配列を返します。

- **SEE** [m:Prism::ParseResult#comments]

### def magic_comments -> Array

解析中に見つかったマジックコメント([c:Prism::MagicComment] のインスタンス)の配列を返します。

- **SEE** [m:Prism::ParseResult#magic_comments]

### def data_loc -> Prism::Location | nil

ソースコード中に `__END__` 行が存在する場合、その行からファイル末尾までの範囲を表す [c:Prism::Location] を返します。存在しない場合は
nil を返します。

- **SEE** [m:Prism::ParseResult#data_loc]

### def errors -> Array

解析中に発生したエラー([c:Prism::ParseError] のインスタンス)の配列を返します。

- **SEE** [m:Prism::ParseResult#errors]

### def warnings -> Array

解析中に発生した警告([c:Prism::ParseWarning] のインスタンス)の配列を返します。

- **SEE** [m:Prism::ParseResult#warnings]

### def source -> Prism::Source

解析したソースコードそのものを表す [c:Prism::Source] のインスタンスを返します。

- **SEE** [m:Prism::ParseResult#source]

### def encoding -> Encoding

解析したソースコードのエンコーディングを返します。
`source.encoding` と同じです。

### def success? -> bool

解析にエラーがなかった場合に true を返します。

- **SEE** [m:Prism::ParseResult#success?]

### def failure? -> bool

[m:Prism::Result#success?] の否定です。

### def code_units_cache(encoding) -> Proc

バイトオフセットを指定エンコーディングのコード単位のオフセットへ変換する処理をキャッシュ付きで行う Proc を返します。
[c:Prism::Location] の `code_units` 系メソッドを多数の位置に対して繰り返し使う場合の高速化用です。

- **param** `encoding` -- コード単位の基準となるエンコーディング

#%since 3.4
### def deconstruct_keys(keys) -> Hash

パターンマッチのハッシュパターンで使われます。`comments`・`magic_comments`・`data_loc`・`errors`・`warnings` をキーに持つハッシュを返します。

- **param** `keys` -- 取り出したいキーの配列を指定します。すべて取り出す場合は nil を指定します。

- **SEE** [m:Prism::ParseResult#deconstruct_keys]

#%end

#%since 4.1
### def continuable? -> bool

解析したソースコードが、追加の入力によって正しい構文になりうる不完全な式であった場合に true を返します。

IRB のような REPL で、ユーザーが複数行にわたる式を 1 行ずつ入力している途中に、追加の入力を待つべきか、それまでに入力された内容を評価すべきかを判断するために使うことを想定しています。具体的には、発生したすべてのエラーが文字列・配列・ブロックなどが閉じられないまま入力が終了したことによるものであれば true を、`end` や `]`、`)` が対応する開始位置なしに単独で現れるなど、後続の入力によらず構文として不正であることが確定しているエラーが 1 つでもあれば false を返します。

- **SEE** [m:Prism::Result#success?], [m:Prism::Result#failure?]

#%end


---
require:
  - e2mmap
  - irb/slex
  - rdoc/code_objects
  - rdoc/parser
  - rdoc/token_stream
---
Ruby のソースコードを解析するためのサブライブラリです。

拡張子が .rb、.rbw のファイルを解析する事ができます。

### メタプログラミングされたメソッド

動的に定義されたメソッドをドキュメントに含めたい場合、## でコメントを開始します。

```ruby
##
# This is a meta-programmed method!

add_my_method :meta_method, :arg1, :arg2
```

[c:RDoc::Parser::Ruby] は上記の :meta_method ようにメソッドの定義を行
うような識別子の後に続くトークンをメソッド名として解釈します。メソッド
名が見つからなかった場合、警告が表示されます。また、この場合はメソッド
名は 'unknown' になります。

:method: 命令を使う事でメソッド名を指定する事もできます。

```text
##
# :method: woo_hoo!
```

デフォルトでは動的に定義されたメソッドはインスタンスメソッドとして解析
されます。特異メソッドとしたい場合は、:singleton-method: 命令を指定しま
す。

```text
##
# :singleton-method:
```

以下のようにメソッド名を指定する事もできます。

```text
##
# :singleton-method: woo_hoo!
```

また、属性についても同様に :attr:、 :attr_reader:、 :attr_writer:、
:attr_accessor: を指定する事ができます。属性の名前は省略できます。

```text
##
# :attr_reader: my_attr_name
```

### 隠しメソッド、属性

:method:、 :singleton-method: や :attr: 命令を使う事で実際には定義され
ていないメソッドもドキュメントに含める事ができます。

```ruby
##
# :attr_writer: ghost_writer
# There is an attribute here, but you can't see it!

##
# :method: ghost_method
# There is a method here, but you can't see it!

##
# this is a comment for a regular method

def regular_method() end
```

# module RDoc::RubyToken

ライブラリの内部で使用します。

# class RDoc::RubyLex

ライブラリの内部で使用します。


# class RDoc::Parser::Ruby < RDoc::Parser
include RDoc::RubyToken
include RDoc::TokenStream
include RDoc::Parser::RubyTools

Ruby のソースコードを解析するためのクラスです。

## Constants

### const NORMAL -> "::"

RDoc::NormalClass type

### const SINGLE -> "<<"

RDoc::SingleClass type


## Class Methods

### def new(top_level, file_name, body, options, stats) -> RDoc::Parser::Ruby

自身を初期化します。

- **param** `top_level` -- [c:RDoc::TopLevel] オブジェクトを指定します。

- **param** `file_name` -- ファイル名を文字列で指定します。

- **param** `body` -- ソースコードの内容を文字列で指定します。

- **param** `options` -- [c:RDoc::Options] オブジェクトを指定します。

- **param** `stats` -- [c:RDoc::Stats] オブジェクトを指定します。

## Instance Methods

### def scan -> RDoc::TopLevel

Ruby のソースコードからクラス/モジュールのドキュメントを解析します。

- **return** -- [c:RDoc::TopLevel] オブジェクトを返します。

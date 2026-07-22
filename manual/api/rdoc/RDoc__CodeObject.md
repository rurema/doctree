---
library:
  - rdoc/code_object
include:
  - RDoc::Text
---
# class RDoc::CodeObject

RDoc のコードツリーを表現するクラスの基本クラスです。

以下は [c:RDoc::CodeObject] のサブクラスのツリーです。

```text
 * RDoc::Context
   * RDoc::TopLevel
   * RDoc::ClassModule
     * RDoc::AnonClass
     * RDoc::NormalClass
     * RDoc::NormalModule
     * RDoc::SingleClass
 * RDoc::AnyMethod
   * RDoc::GhostMethod
   * RDoc::MetaMethod
 * RDoc::Alias
 * RDoc::Attr
 * RDoc::Constant
 * RDoc::Require
 * RDoc::Include
```

## Class Methods

### def new -> RDoc::CodeObject

自身を初期化します。

## Instance Methods

### def comment -> String

自身のコメントを返します。

### def comment=(comment)

自身のコメントを comment に設定します。

ただし、comment が空文字列だった場合は何もしません。

- **param** `comment` -- コメントを文字列で指定します。

### def document_children -> bool

自身に含まれるメソッド、エイリアス、定数や属性をドキュメントに含めるか
どうかを返します。

- **SEE** [m:RDoc::CodeObject#document_self]

### def document_children=(val)

自身に含まれるメソッド、エイリアス、定数や属性をドキュメントに含めるか
どうかを設定します。

:nodoc:、:stopdoc: を指定した時に false が設定されます。

- **param** `val` -- true を指定した場合、上記をドキュメントに含めます。

- **SEE** [m:RDoc::CodeObject#document_self=],
     [m:RDoc::CodeObject#remove_classes_and_modules]

### def document_self -> bool

自身をドキュメントに含めるかどうかを返します。

- **SEE** [m:RDoc::CodeObject#document_children]

### def document_self=(val)

自身をドキュメントに含めるかどうかを設定します。

:doc: を指定した時に true が設定されます。
:nodoc:、:stopdoc: を指定した時に false が設定されます。

- **param** `val` -- true を指定した場合、自身をドキュメントに含めます。

- **SEE** [m:RDoc::CodeObject#document_children=],
     [m:RDoc::CodeObject#remove_methods_etc]

### def remove_classes_and_modules -> ()

何もしません。[m:RDoc::CodeObject#document_children=] に false を指定
した時のコールバックとして呼び出されます。オーバーライドして使用します。

### def remove_methods_etc -> ()

何もしません。[m:RDoc::CodeObject#document_self=] に false を指定した
時のコールバックとして呼び出されます。オーバーライドして使用します。

### def start_doc -> ()

以降に解析したコメントを [m:RDoc::CodeObject#stop_doc] を呼び出すまで
の間、ドキュメントに含めます。

:startdoc: を見つけた時に呼び出されます。
[m:RDoc::CodeObject#document_self] と
[m:RDoc::CodeObject#document_children] を true に設定します。

- **SEE** [m:RDoc::CodeObject#end_doc]

### def stop_doc -> ()

以降に解析したコメントを [m:RDoc::CodeObject#start_doc] を呼び出すま
での間、ドキュメントに含めません。

:stopdoc: を見つけた時に呼び出されます。
[m:RDoc::CodeObject#document_self] と
[m:RDoc::CodeObject#document_children] を false に設定します。

- **SEE** [m:RDoc::CodeObject#start_doc]

### def parent -> RDoc::CodeObject

自身を所有する(変数や定数などの形で保持する)オブジェクトを返します。

### def parent=(val)

自身を所有する(変数や定数などの形で保持する)オブジェクトを設定します。

- **param** `val` -- [c:RDoc::CodeObject] のサブクラスのオブジェクトを指定しま
           す。

### def section -> RDoc::Context::Section

所属している section を返します。

### def section=(val)

所属する section を設定します。

- **param** `val` -- [c:RDoc::Context::Section] オブジェクトを指定します。

### def parent_file_name -> String

self.parent のファイル名を返します。

- **SEE** [m:RDoc::CodeObject#parent]

### def parent_name -> String

self.parent の名前を返します。

- **SEE** [m:RDoc::CodeObject#parent]

### def documented? -> bool

出力すべきドキュメントがあるかどうかを返します。

### def metadata -> Hash

自身が持つメタデータ(他から任意の値を設定してもよい)を返します。

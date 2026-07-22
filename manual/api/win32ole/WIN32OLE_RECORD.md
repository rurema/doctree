---
library: win32ole
---
# class WIN32OLE_RECORD < Object

WIN32OLE_RECORDオブジェクトは、OLEオートメーションのVT_RECORD型の値
(構造体)を表します。OLEメソッドの呼び出し結果がVT_RECORD型の場合、
WIN32OLEはWIN32OLE_RECORDオブジェクトを返します。

Ruby 3.2 から、このクラスは WIN32OLE の名前空間下に移動し、`WIN32OLE::Record`
として定義されるようになりました。トップレベル定数 `WIN32OLE_RECORD` は後方
互換のためのエイリアスとして残っていますが、Ruby 3.4 以降は非推奨
(deprecated)です(`Warning[:deprecated]` が有効なら参照時に警告が表示されます)。

### サンプルコード

たとえば、VB.NETで作成したComServerプロジェクトのCOMサーバが、以下のよ
うにtitle（文字列）とcost（整数）の2つのフィールドを持つBook構造体を返
すgetBookメソッドを持っているとします。

```text
Imports System.Runtime.InteropServices
Public Class ComClass
    Public Structure Book
        <MarshalAs(UnmanagedType.BStr)> _
        Public title As String
        Public cost As Integer
    End Structure
    Public Function getBook() As Book
        Dim book As New Book
        book.title = "The Ruby Book"
        book.cost = 20
        Return book
    End Function
End Class
```

このとき、Rubyから次のようにしてgetBookの戻り値を取得できます。

```ruby title="例"
require 'win32ole'
obj = WIN32OLE.new('ComServer.ComClass')
book = obj.getBook
book.class # => WIN32OLE::Record
book.title # => "The Ruby Book"
book.cost  # => 20
```

なお、`book.class`は常に`WIN32OLE::Record`を返します。トップレベル定数
`WIN32OLE_RECORD`は同じクラスオブジェクトへのエイリアスですが、クラス
自体の名前（`WIN32OLE::Record.name`）は変わりません。

## Class Methods

### def new(typename, obj) -> WIN32OLE_RECORD

WIN32OLE_RECORDオブジェクトを生成します。

- **param** `typename` -- 構造体名を文字列またはシンボルで指定します。
- **param** `obj` -- [c:WIN32OLE]オブジェクトまたは[c:WIN32OLE_TYPELIB]オブジェ
           クトを指定します。typenameで指定した構造体の型情報を取得する
           ために利用します。
- **return** -- 生成したWIN32OLE_RECORDオブジェクトを返します。

- **raise** `ArgumentError` -- typenameがStringまたはSymbolではありません。あるいは
                obj がWIN32OLEオブジェクトまたはWIN32OLE_TYPELIBオブジェク
                トのいずれでもありません。

- **raise** `WIN32OLERuntimeError` -- objからITypeLibインタフェースの取得に失
                            敗しました。あるいはtypenameに対応する
                            IRecordInfoインタフェースの取得に失敗し
                            ました。

VB.NETのComServerプロジェクトで、以下のBook構造体を持つCOMサーバがある
とします。

```text
Imports System.Runtime.InteropServices
Public Class ComClass
    Public Structure Book
        <MarshalAs(UnmanagedType.BStr)> _
        Public title As String
        Public cost As Integer
    End Structure
End Class
```

このとき、次のようにしてWIN32OLE_RECORDオブジェクトを生成できます。

```ruby title="例"
require 'win32ole'
obj = WIN32OLE.new('ComServer.ComClass')
book1 = WIN32OLE_RECORD.new('Book', obj) # => WIN32OLE_RECORDオブジェクト
tlib = obj.ole_typelib
book2 = WIN32OLE_RECORD.new('Book', tlib) # => WIN32OLE_RECORDオブジェクト
```

## Instance Methods

### def to_h -> Hash

selfが表すVT_RECORD値をRubyのHashオブジェクトに変換して返します。

Hashのキーは、VT_RECORD OLE変数のメンバ名、値はその値です。

- **return** -- VT_RECORD値の各メンバ名と値からなるHashオブジェクトを返します。

VB.NETのComServerプロジェクトで作成したCOMサーバの以下のgetBookメソッ
ドの戻り値に対して、

```text
Imports System.Runtime.InteropServices
Public Class ComClass
    Public Structure Book
        <MarshalAs(UnmanagedType.BStr)> _
        Public title As String
        Public cost As Integer
    End Structure
    Public Function getBook() As Book
        Dim book As New Book
        book.title = "The Ruby Book"
        book.cost = 20
        Return book
    End Function
End Class
```

WIN32OLE_RECORD#to_hを呼び出すと、以下のようになります。

```ruby title="例"
require 'win32ole'
obj = WIN32OLE.new('ComServer.ComClass')
book = obj.getBook
book.to_h # => {"title"=>"The Ruby Book", "cost"=>20}
```

### def typename -> String

selfが表すVT_RECORD OLE変数の型名（構造体名）を返します。

- **return** -- VT_RECORD OLE変数の型名を文字列で返します。

```ruby title="例"
require 'win32ole'
obj = WIN32OLE.new('ComServer.ComClass')
book = obj.getBook
book.typename # => "Book"
```

### def method_missing(name, *args) -> object

VT_RECORD OLE変数のメンバ名に対応する値を取得、または設定します。

引数がnameだけの場合（`book.title`のようにgetterとして未定義メソッドが
呼び出された場合）はメンバの値を取得します。引数がname、valの2つの場合
（`book.title = "..."`のようにsetterとして未定義メソッドが呼び出された
場合）は、nameの末尾の「=」を取り除いたメンバ名にvalを設定します。指定
したメンバ名が存在しない場合は[c:KeyError]が発生します。

- **param** `name` -- アクセスするメンバ名に対応するメソッド名（シンボル）です。
           setterの場合は末尾に「=」が付きます。
- **param** `args` -- setterとして呼び出された場合、設定する値を1つ指定します。
           getterとして呼び出された場合は空です。
- **return** -- getterとして呼び出された場合はメンバの値、setterとして呼び出さ
           れた場合は設定した値を返します。

- **raise** `KeyError` -- 指定したメンバ名がselfに存在しません。

VB.NETのComServerプロジェクトで作成したCOMサーバの以下のBook構造体に対
して、

```text
Imports System.Runtime.InteropServices
Public Class ComClass
    Public Structure Book
        <MarshalAs(UnmanagedType.BStr)> _
        Public title As String
        Public cost As Integer
    End Structure
End Class
```

値の取得・設定は次のようにメンバ名をメソッドとして呼び出すことで行いま
す（実際には、method_missingが呼び出されます）。

```ruby title="例"
obj = WIN32OLE.new('ComServer.ComClass')
book = WIN32OLE_RECORD.new('Book', obj)
book.title # => nil ( book.method_missing(:title) が呼び出される )
book.title = "Ruby" # ( book.method_missing(:title=, "Ruby") が呼び出される )
```

- **SEE** [m:WIN32OLE_RECORD#ole_instance_variable_get], [m:WIN32OLE_RECORD#ole_instance_variable_set]

### def ole_instance_variable_get(name) -> object

VT_RECORD OLE変数のメンバ名に対応する値を取得します。メンバ名が正しく
ない場合は[c:KeyError]が発生します。

Rubyの[c:Object]が持つメソッドと同名のメンバを持つなど、メンバに
[m:WIN32OLE_RECORD#method_missing]経由で直接アクセスできない場合に利
用します。

- **param** `name` -- 取得するメンバ名を文字列またはシンボルで指定します。
- **return** -- 指定したメンバの値を返します。

- **raise** `TypeError` -- nameがStringまたはSymbolではありません。
- **raise** `KeyError` -- 指定したメンバ名がselfに存在しません。

VB.NETのComServerプロジェクトで作成したCOMサーバの以下のComObject構造
体（[m:Object#object_id]と同名のメンバを持つ）に対して、

```text
Imports System.Runtime.InteropServices
Public Class ComClass
    Public Structure ComObject
        Public object_id As Integer
    End Structure
End Class
```

以下のようにすると、`obj.object_id`はRubyの[m:Object#object_id]を返し
てしまうため、代わりにole_instance_variable_getを利用します。

```ruby title="例"
server = WIN32OLE.new('ComServer.ComClass')
obj = WIN32OLE_RECORD.new('ComObject', server)
# obj.object_id はRubyのObject#object_idを返してしまう
obj.ole_instance_variable_get(:object_id) # => nil
```

- **SEE** [m:WIN32OLE_RECORD#method_missing], [m:WIN32OLE_RECORD#ole_instance_variable_set]

### def ole_instance_variable_set(name, val) -> object

VT_RECORD OLE変数のメンバ名に対応する値を設定します。メンバ名が正しく
ない場合は[c:KeyError]が発生します。

[m:WIN32OLE_RECORD#method_missing]経由でメンバの値を直接設定できない場
合に利用します。

- **param** `name` -- 設定するメンバ名を文字列またはシンボルで指定します。
- **param** `val` -- 設定する値を指定します。
- **return** -- 設定した値を返します。

- **raise** `TypeError` -- nameがStringまたはSymbolではありません。
- **raise** `KeyError` -- 指定したメンバ名がselfに存在しません。

VB.NETのComServerプロジェクトで作成したCOMサーバの以下のBook構造体の
titleメンバに値を設定するには、次のようにします。

```text
Imports System.Runtime.InteropServices
Public Class ComClass
    <MarshalAs(UnmanagedType.BStr)> _
    Public title As String
    Public cost As Integer
End Class
```

```ruby title="例"
server = WIN32OLE.new('ComServer.ComClass')
obj = WIN32OLE_RECORD.new('Book', server)
obj.ole_instance_variable_set(:title, "The Ruby Book")
```

- **SEE** [m:WIN32OLE_RECORD#method_missing], [m:WIN32OLE_RECORD#ole_instance_variable_get]

### def inspect -> String

selfが表すOLEの構造体名と各メンバ名、その値を含む文字列を返します。

なお、返す文字列中のクラス名部分は、selfをトップレベル定数
`WIN32OLE_RECORD`経由で生成した場合であっても、常に`WIN32OLE::Record`
と表示されます。

VB.NETのComServerプロジェクトで作成したCOMサーバの以下のBook構造体に対
して、

```text
Imports System.Runtime.InteropServices
Public Class ComClass
    <MarshalAs(UnmanagedType.BStr)> _
    Public title As String
    Public cost As Integer
End Class
```

```ruby title="例"
server = WIN32OLE.new('ComServer.ComClass')
obj = WIN32OLE_RECORD.new('Book', server)
obj.inspect # => "#<WIN32OLE::Record(ComClass) {\"title\" => nil, \"cost\" => nil}>"
```

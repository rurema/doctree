---
library: zlib
---
# class Zlib::GzipFile < Object

gzip 形式の圧縮ファイルを扱う抽象クラス。
具体的な読み込み/書き込み操作は、それぞれサブクラスの
[c:Zlib::GzipReader], [c:Zlib::GzipWriter] で定義されています。

IO クラスのインスタンス (又は IO クラスのインスタンスと同じメソッドを
持つオブジェクト) と関連付けて使用します。

## Class Methods

### def new(*args) -> ()

直接使用しません。
通常、具体的な読み書きをおこなうためには、
[m:Zlib::GzipReader.new] もしくは、 [m:Zlib::GzipWriter.new] を使用します。

- **SEE** [m:Zlib::GzipReader.new], [m:Zlib::GzipWriter.new] 

### def wrap(*args) {|gz| ... } -> ()

直接使用しません。
通常、具体的な読み書きをおこなうためには、
[m:Zlib::GzipReader.wrap] もしくは、[m:Zlib::GzipWriter.wrap] を使用します。

- **SEE** [m:Zlib::GzipReader.wrap],[m:Zlib::GzipWriter.wrap]

### def open(*args) {|gz| ... } -> ()

直接使用しません。
通常、具体的な読み書きをおこなうためには、
[m:Zlib::GzipReader.open] もしくは、[m:Zlib::GzipWriter.open] を使用します。

- **SEE** [m:Zlib::GzipReader.open], [m:Zlib::GzipWriter.open]

## Instance Methods

### def closed? -> bool
### def to_io -> IO

IO クラスの同名メソッドと同じ。

- **SEE** [m:IO#to_io], [m:IO#closed?]

### def close -> IO

GzipFile オブジェクトをクローズします。このメソッドは
関連付けられている IO オブジェクトの close メソッドを呼び出します。
関連付けられている IO オブジェクトを返します。

### def finish -> IO

GzipFile オブジェクトをクローズします。[m:Zlib::GzipFile#close]と違い、
このメソッドは関連付けられている IO オブジェクトの close メソッドを
呼び出しません。関連付けられている IO オブジェクトを返します。

### def crc -> Integer

圧縮されていないデータの CRC 値を返します。

### def level -> Integer

圧縮レベルを返します。

### def mtime -> Time

gzip ファイルのヘッダーに記録されている最終更新時間を返します。

### def os_code -> Integer

gzip ファイルのヘッダーに記録されている OS コード番号を返します。

### def orig_name -> String | nil

gzip ファイルのヘッダーに記録されている元ファイル名を返します。
ファイル名が記録されていない場合は nil を返します。

### def comment -> String | nil

gzip ファイルのヘッダーに記録されているコメントを返します。
コメントが存在しない場合は nil を返します。

### def sync -> bool
### def sync=(flag) 

IO クラスと同じ。flag が真の時、関連付けられている
IO オブジェクトが flush メソッドを持っていなければなりません。
また、true にすると圧縮率が著しく低下します。

- **SEE** [m:IO#sync], [m:IO#sync]

#@since 1.9.2
### def path -> String

関連付けられている IO オブジェクトのパスを返します。
このメソッドは IO オブジェクトが path というメソッドを持つ場合のみ定義されます。

#@end

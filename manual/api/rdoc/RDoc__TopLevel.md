---
library:
#%since 3.4
  - rdoc/code_object/top_level
#%end
#%until 3.4
  - rdoc/top_level
#%end
---
# class RDoc::TopLevel < RDoc::Context

最上位のコンテキスト(ソースファイル)を表現するクラスです。

## Class Methods

### def RDoc::TopLevel.new(file_name) -> RDoc::TopLevel

自身を初期化します。

- **param** `file_name` -- ファイル名を文字列で指定します。

## Instance Methods

### def add_class_or_module(collection, class_type, name, superclass) -> RDoc::NormalClass | RDoc::SingleClass | RDoc::NormalModule

collection に name で指定したクラス、モジュールを追加します。

- **param** `collection` -- クラス、モジュールを追加する先を [c:Hash] オブジェクトで指定します。

- **param** `class_type` -- 追加するクラス、モジュールを [c:RDoc::NormalClass]、
                  [c:RDoc::SingleClass]、[c:RDoc::NormalModule] オブジェクトのいずれかで指定します。

- **param** `name` -- クラス名を文字列で指定します。

- **param** `superclass` -- 追加するクラスの親クラスを [c:RDoc::NormalClass] オブジェクトで指定します。

既に登録済みであった場合は、引数で指定した情報で内容を更新します。ただし、`RDoc::CodeObject#done_documenting` が true を返す場合、何も行われません。

### def find_local_symbol(name) -> RDoc::NormalClass | RDoc::SingleClass | RDoc::NormalModule | RDoc::AnyMethod | RDoc::Alias | RDoc::Attr | RDoc::Constant

クラス、モジュール、メソッド、定数、属性、alias、ファイルから name で指定したものを返します。見つからなかった場合は nil を返します。

### def find_module_named(name) -> RDoc::NormalModule

RDoc が収集したクラスの内、name で指定した名前のモジュールを返します。
見つからなかった場合は nil を返します。

- **param** `name` -- モジュール名を文字列で指定します。

### def full_name -> String

自身が管理するファイルの名前を返します。

### def file_stat -> File::Stat

自身が管理するファイルに関する [c:File::Stat] オブジェクトを返します。

### def file_stat=(val)

自身が管理するファイルに関する [c:File::Stat] オブジェクトを設定します。

- **param** `val` -- [c:File::Stat] オブジェクトを指定します。


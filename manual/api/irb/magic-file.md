---
type: library
until: "3.3"
---
irb が扱う入力やファイル中のマジックコメントを正しく扱うためのサブライブラリです。

ユーザが直接使用するものではありません。

# object IRB::MagicFile

irb が扱う入力やファイル中のマジックコメントを正しく扱うためのクラスです。

### def IRB::MagicFile.ENCODING_SPEC_RE -> %r"coding\s*[=:]\s*([[:alnum:]\-_]+)"

マジックコメントにマッチする正規表現を返します。

### def IRB::MagicFile.open(path) -> File
### def IRB::MagicFile.open(path) { |io| ... } -> object

引数 path で指定したファイルを開いて、ファイル中のマジックコメントをエンコーディングに設定します。

ブロックを指定した場合はブロックの実行結果を返します。ブロックを指定しなかった場合はエンコーディングが設定された [c:File] オブジェクトを返します。

- **param** `path` -- パスを文字列で指定します。

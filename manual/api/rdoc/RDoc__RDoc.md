---
library: rdoc/rdoc
---
# class RDoc::RDoc

rdoc ドキュメントの作成を行うクラスです。

以下のようにして、rdoc コマンドを実行するのと同様に実行します。

```ruby
require 'rdoc/rdoc'
rdoc = RDoc::RDoc.new
rdoc.document(args)
```

args には rdoc コマンドに渡すのと同様の引数を文字列の配列で指定します。

rdoc コマンドと同様に変換結果はファイルに出力されるため、テキストを
HTML に変換する部分をライブラリとして使用したい場合、
[lib:rdoc/markup] を参照してください。

## Instance Methods

### def document(argv) -> nil

argv で与えられた引数を元にドキュメントをフォーマットして指定されたディ
レクトリに出力します。

- **param** `argv` -- コマンドラインで rdoc コマンドに指定するのと同じ引数を文字
            列の配列で指定します。

- **raise** `RDoc::Error` -- ドキュメントの処理中にエラーがあった場合に発生します。

指定できるオプションについては、[ref:lib:rdoc#usage] を参照してくださ
い。出力ディレクトリが指定されなかった場合はカレントディレクトリ の
doc 以下に出力します。

## Class Methods

### def add_generator(klass) -> klass

引数 klass で指定したクラスをジェネレータとして登録します。

- **param** `klass` -- 登録するクラスを指定します。

- **SEE** [ref:c:RDoc::Options#custom_options]

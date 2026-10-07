---
library:
  - rdoc/stats
---
# class RDoc::Stats

RDoc のステータスを管理するクラスです。

```ruby title="例"
require 'rdoc'
require 'tmpdir'

Dir.mktmpdir do |dir|
  path = File.join(dir, "foo.rb")
  File.write(path, <<~RUBY)
    class Foo
      # documented
      def a(x); end
      def b(y); end
    end
  RUBY

  rdoc = RDoc::RDoc.new
  rdoc.document(['--quiet', '-o', File.join(dir, 'out'), path])
  stats = rdoc.stats

  p stats.num_files
  # => 1
  p stats.files_so_far
  # => 1
  stats.summary
  p stats.fully_documented?
  # => false
end
```

## Class Methods

### def RDoc::Stats.new(store, num_files, verbosity = 1) -> RDoc::Stats

自身を初期化します。

- **param** `store` -- 解析結果を保持する `RDoc::Store` オブジェクトを指定します。

- **param** `num_files` -- 解析するファイルの数を整数で指定します。

- **param** `verbosity` -- 解析中に表示する進捗の詳しさを整数で指定します。0 は何も表示せず、1 は簡易な表示、2 以上は詳細な表示になります。

## Instance Methods

### def num_files -> Integer

解析するファイルの数を返します。

### def files_so_far -> Integer

これまでに解析したファイルの数を返します。

### def coverage_level -> Integer

カバレッジレポートのレベルを返します。

-1 はカバレッジレポートを行わないことを、0 はクラス、モジュール、定数、属性、メソッドを対象にすることを、1 は 0 に加えてメソッドの引数も対象にすることを表します。

### def coverage_level=(level)

カバレッジレポートのレベルを設定します。

- **param** `level` -- -1 以上の整数を指定します。false か nil を指定すると -1 になります。

### def fully_documented? -> bool

全ての項目がドキュメント化されているかどうかを返します。

[m:RDoc::Stats#summary] で統計を計算した後の値が返されます。計算前は false を返します。

#%until 4.1
### def summary -> RDoc::Markup::Document

統計の要約を `RDoc::Markup::Document` オブジェクトで返します。
#%else
### def summary -> String

統計の要約を文字列で返します。
#%end

クラス、モジュール、定数、属性、メソッドの数とそのうちドキュメントが無いものの数、ドキュメント化されている割合などを含みます。

#%until 4.1
### def report -> RDoc::Markup::Document

ドキュメントが無い項目の報告を `RDoc::Markup::Document` オブジェクトで返します。
#%else
### def report -> String

ドキュメントが無い項目の報告を文字列で返します。
#%end

[m:RDoc::Stats#coverage_level] が 0 以上で、全ての項目にドキュメントがある場合は、そのことを伝えるメッセージを返します。


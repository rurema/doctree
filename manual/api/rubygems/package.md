---
type: library
require:
  - rubygems/digest/md5
  - rubygems/security
  - rubygems/specification
  - rubygems/package/f_sync_dir
  - rubygems/package/tar_header
  - rubygems/package/tar_input
  - rubygems/package/tar_output
  - rubygems/package/tar_reader
  - rubygems/package/tar_reader/entry
  - rubygems/package/tar_writer
---
Gem パッケージ(`.gem` ファイル)を読み書きするためのライブラリです。

# class Gem::Package

`.gem` ファイルを読み書きするクラスです。

`.gem` ファイルは、gemspec を gzip 圧縮した `metadata.gz`、ファイル本体の tar を gzip 圧縮した `data.tar.gz`、チェックサムの `checksums.yaml.gz` を含む tar アーカイブです。
[c:Gem::Specification] から `.gem` ファイルを作ることも、既存の `.gem` ファイルを検証して展開することもできます。

以下の例は、`lib/example.rb` があるディレクトリで実行することを前提にしています。

```ruby title="例: gem を作って読む"
require 'rubygems/package'

spec = Gem::Specification.new do |s|
  s.name = 'example'
  s.version = '1.0'
  s.summary = 'An example gem'
  s.authors = ['Example Author']
  s.license = 'MIT'
  s.homepage = 'https://example.com/example'
  s.required_ruby_version = '>= 3.0'
  s.files = ['lib/example.rb']
end
Gem::Package.build(spec) # => "example-1.0.gem"

package = Gem::Package.new('example-1.0.gem')
package.spec.name  # => "example"
package.contents   # => ["lib/example.rb"]
package.files      # => ["metadata.gz", "data.tar.gz", "checksums.yaml.gz"]
package.extract_files('out') # out/lib/example.rb に展開します
```

## Singleton Methods

### def Gem::Package.new(gem, security_policy = nil) -> Gem::Package
{: since="2.0.0"}

`.gem` ファイルを扱う [c:Gem::Package] オブジェクトを返します。

古い形式の `.gem` ファイルの場合は、`Gem::Package::Old` のインスタンスを返します。
仕様や中身は、[m:Gem::Package#spec] や [m:Gem::Package#verify] などを呼んだときに読み込みます。

- **param** `gem` -- `.gem` ファイルのパスを文字列で指定するか、`read` を持つ [c:IO] オブジェクトを指定します。

- **param** `security_policy` -- 署名の検証に使う [c:Gem::Security::Policy] を指定します。nil の場合は署名を検証しません。

- **SEE** [m:Gem::Package#verify]

### def Gem::Package.build(spec, skip_validation = false, strict_validation = false, file_name = nil) -> String
{: since="2.0.0"}

`spec` から `.gem` ファイルを作り、作ったファイルの名前を返します。

ファイルはカレントディレクトリに作られ、`Successfully built RubyGem` から始まるメッセージを出力します。
ファイル名は `file_name` を指定した場合はそれに、そうでない場合は [m:Gem::Specification#file_name] になります。

- **param** `spec` -- `.gem` ファイルに書き込む [c:Gem::Specification] を指定します。

- **param** `skip_validation` -- 真を指定すると [m:Gem::Specification#validate] を実行しません。

- **param** `strict_validation` -- 真を指定すると、警告も検証エラーとして扱います。

- **param** `file_name` -- 作る `.gem` ファイルの名前を指定します。

- **raise** `ArgumentError` -- `skip_validation` と `strict_validation` がともに真の場合に発生します。

- **SEE** [m:Gem::Package#build]

### def Gem::Package.raw_spec(path, security_policy = nil) -> [Gem::Specification, String]
{: since="2.7.0"}

`path` の `.gem` ファイルから [c:Gem::Specification] と、`metadata.gz` を展開した YAML 文字列の 2 要素の配列を返します。

YAML 文字列は `--- !ruby/object:Gem::Specification` で始まります。

- **param** `path` -- `.gem` ファイルのパスを指定します。

- **param** `security_policy` -- 署名の検証に使う [c:Gem::Security::Policy] を指定します。nil の場合は署名を検証しません。

## Public Instance Methods

### def build(skip_validation = false, strict_validation = false) -> ()
{: since="2.0.0"}

[m:Gem::Package#spec=] で設定した仕様から `.gem` ファイルを書き出します。

引数の意味は [m:Gem::Package.build] と同じです。`Successfully built RubyGem` から始まるメッセージを出力します。

- **param** `skip_validation` -- 真を指定すると [m:Gem::Specification#validate] を実行しません。

- **param** `strict_validation` -- 真を指定すると、警告も検証エラーとして扱います。

- **raise** `ArgumentError` -- `skip_validation` と `strict_validation` がともに真の場合に発生します。

- **SEE** [m:Gem::Package.build]

### def checksums -> {String => {String => String}}
{: since="2.0.0"}

`checksums.yaml.gz` から読み込んだチェックサムを返します。

外側のキーはダイジェストのアルゴリズム名(`"SHA256"`・`"SHA512"`)、内側のキーはファイル名(`"metadata.gz"`・`"data.tar.gz"`)で、値は 16 進表記のダイジェストです。
[m:Gem::Package#verify] を呼ぶまでは空のハッシュを返します。

- **SEE** [m:Gem::Package#verify]

### def contents -> [String]
{: since="2.0.0"}

`data.tar.gz` に含まれるファイル名(gem に入っているファイル)の配列を返します。

未検証の場合は、先に [m:Gem::Package#verify] を呼びます。

- **raise** `Gem::Package::FormatError` -- `.gem` ファイルの形式が不正な場合に発生します。

- **SEE** [m:Gem::Package#files]

### def copy_to(path) -> ()
{: since="2.3.0"}

`.gem` ファイルを `path` にコピーします。

`path` が既にある場合は何もしません。

- **param** `path` -- コピー先のパスを指定します。

### def data_mode -> Integer | nil
{: since="2.6.0"}

[m:Gem::Package#extract_files] で展開する通常ファイルのパーミッションを返します。

8 進表記の整数で表します。nil の場合は、アーカイブに記録された値になります。

- **SEE** [m:Gem::Package#data_mode=]

### def data_mode=(mode)
{: since="2.6.0"}

[m:Gem::Package#extract_files] で展開する通常ファイルのパーミッションを設定します。

- **param** `mode` -- パーミッションを整数で指定します。

- **SEE** [m:Gem::Package#data_mode]

### def dir_mode -> Integer | nil
{: since="2.6.0"}

[m:Gem::Package#extract_files] で展開するディレクトリのパーミッションを返します。

nil の場合は、アーカイブに記録された値になります。

- **SEE** [m:Gem::Package#dir_mode=]

### def dir_mode=(mode)
{: since="2.6.0"}

[m:Gem::Package#extract_files] で展開するディレクトリのパーミッションを設定します。

- **param** `mode` -- パーミッションを整数で指定します。

- **SEE** [m:Gem::Package#dir_mode]

### def extract_files(destination_dir, pattern = "*") -> ()
{: since="2.0.0"}

`data.tar.gz` の中身を `destination_dir` に展開します。

未検証の場合は、先に [m:Gem::Package#verify] を呼びます。

- **param** `destination_dir` -- 展開先のディレクトリを指定します。

- **param** `pattern` -- 展開するファイルを絞り込む glob を指定します。

- **raise** `Gem::Package::FormatError` -- `.gem` ファイルの形式が不正な場合に発生します。

- **raise** `Gem::Package::PathError` -- `destination_dir` の外に出るパスを含む場合に発生します。

- **raise** `Gem::Package::SymlinkError` -- `destination_dir` の外を指すシンボリックリンクを含む場合に発生します。

- **SEE** [m:Gem::Package#verify]

### def files -> [String] | nil
{: since="2.0.0"}

`.gem` アーカイブ直下のエントリ名の配列を返します。

`["metadata.gz", "data.tar.gz", "checksums.yaml.gz"]` のような配列です。gem の中身のファイルの一覧ではありません(それは [m:Gem::Package#contents] です)。
[m:Gem::Package#verify] を呼ぶまでは nil を返します。

- **SEE** [m:Gem::Package#contents]

### def prog_mode -> Integer | nil
{: since="2.6.0"}

[m:Gem::Package#extract_files] で展開する実行ファイルのパーミッションを返します。

nil の場合は、アーカイブに記録された値になります。

- **SEE** [m:Gem::Package#prog_mode=]

### def prog_mode=(mode)
{: since="2.6.0"}

[m:Gem::Package#extract_files] で展開する実行ファイルのパーミッションを設定します。

- **param** `mode` -- パーミッションを整数で指定します。

- **SEE** [m:Gem::Package#prog_mode]

### def security_policy -> Gem::Security::Policy | nil
{: since="2.0.0"}

署名の検証に使うセキュリティポリシーを返します。

nil の場合は署名を検証しません。

- **SEE** [m:Gem::Package#security_policy=]

### def security_policy=(policy)
{: since="2.0.0"}

署名の検証に使うセキュリティポリシーを設定します。

- **param** `policy` -- [c:Gem::Security::Policy] を指定します。nil の場合は署名を検証しません。

- **SEE** [m:Gem::Package#security_policy]

### def spec -> Gem::Specification
{: since="2.0.0"}

この gem の [c:Gem::Specification] を返します。

既存の `.gem` ファイルを読む場合は `metadata.gz` から読み込んだもの(未検証の場合は先に [m:Gem::Package#verify] を呼びます)、`.gem` ファイルを作る場合は [m:Gem::Package#spec=] で設定したものです。

- **SEE** [m:Gem::Package#spec=]

### def spec=(spec)
{: since="2.0.0"}

[m:Gem::Package#build] で使う仕様を設定します。

- **param** `spec` -- [c:Gem::Specification] を指定します。

- **SEE** [m:Gem::Package#spec]

### def verify -> true
{: since="2.0.0"}

`.gem` ファイルを検証します。

正しい仕様書を含むこと、`data.tar.gz` を含むこと、チェックサムが一致すること、(セキュリティポリシーがある場合は)署名が正しいことを検証します。
成功すると true を返し、以降は [m:Gem::Package#spec]・[m:Gem::Package#files]・[m:Gem::Package#checksums] が使えるようになります。

- **raise** `Gem::Package::FormatError` -- ファイルが無い場合、gem の形式でない場合、チェックサムが一致しない場合などに発生します。

- **raise** `Gem::Security::Exception` -- 署名の検証に失敗した場合に発生します。

- **SEE** [m:Gem::Package#spec], [m:Gem::Package#files], [m:Gem::Package#checksums]

# class Gem::Package::Error < Gem::Exception

[c:Gem::Package] での基本的な例外です。

# class Gem::Package::NonSeekableIO < Gem::Package::Error

シークできない IO に対してシーク使用とした場合に発生する例外です。

# class Gem::Package::TooLongFileName < Gem::Package::Error

ファイル名が長すぎる場合に発生する例外です。

# class Gem::Package::FormatError < Gem::Package::Error

フォーマットに関する例外です。

# class Gem::Package::PathError < Gem::Package::Error

展開先ディレクトリの外に出るパスをアーカイブが含んでいたときに発生する例外です。

# class Gem::Package::SymlinkError < Gem::Package::Error

展開先ディレクトリの外を指すシンボリックリンクをアーカイブが含んでいたときに発生する例外です。

# class Gem::Package::TarInvalidError < Gem::Package::Error

tar アーカイブの形式が不正なときに発生する例外です。

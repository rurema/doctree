---
type: library
require:
  - rubygems/digest/md5
  - rubygems/format
  - rubygems/installer
---
様々な Gem ファイルや Gem データベースを検証するためのライブラリです。

# class Gem::Validator < Object

様々な Gem ファイルや Gem データベースを検証するためのクラスです。

## Public Instance Methods

### def alien -> [Gem::Validator.ErrorData]

Gem ディレクトリ内に存在するかもしれない以下のような問題を検証します。

- Gem パッケージのチェックサムが正しいこと
- それぞれの Gem に含まれるそれぞれのファイルがインストールされたバージョンであることの一貫性
- Gem ディレクトリに関係の無いファイルが存在しないこと
- キャッシュ、スペック、ディレクトリがそれぞれ一つずつ存在すること

このメソッドは検証に失敗しても例外を発生させません。

## Constants

### const ErrorData
#%todo

エラー情報を記録するための構造体です。
以下の属性を持っています。

- path
- problem

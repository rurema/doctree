---
library: rexml/validation/relaxng
---
# module REXML::Validation::Validator

#%# REXML::Validation::Event は内部用なのでここでは省略

バリデータに共通の機能を提供するモジュールです。

[c:REXML::Validation::RelaxNG] がこのモジュールを include しています。

## Instance Methods

### def validate(event) -> ()
{: since=""}

パーサのイベント `event` が、スキーマから見て次に来てよいものであるかを検証します。

通常は [m:REXML::Validation::RelaxNG#receive] を通じて呼ばれます。

- **param** `event` -- パーサのイベント
- **raise** `REXML::Validation::ValidationException` -- 文書がスキーマに合わないときに発生します

### def reset -> self
{: since=""}

検証の状態を最初に戻します。

同じバリデータで別の文書を検証するときは、検証を始める前にこのメソッドを呼んでください。

### def dump -> nil
{: since=""}

スキーマから作られた内部の状態を標準出力に出力します。

デバッグ用のメソッドです。

## Constants

### const NILEVENT -> Array
{: since=""}

内部用なのでユーザは使わないでください。

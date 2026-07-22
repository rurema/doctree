---
library: rexml/document
---
# class REXML::Declaration < REXML::Child

DTD に含まれる各種宣言ノードを表すクラスです。

このクラス自体は直接はインスタンスを作りません。
各サブクラスのインスタンスが使われます。

## Instance Methods

### def to_s -> String

ノードを文字列化します。

### def write(output, indent) -> ()

output にノードを出力します。

このメソッドは deprecated です。[c:REXML::Formatter] で
出力してください。

- **param** `output` -- 出力先の IO オブジェクト
- **param** `indent` -- インデントの大きさ。無視されます。


---
library: uri
---
# class URI::LDAP < URI::Generic

LDAP URI を表すクラスです。[RFC:2255] (Obsoleted by [RFC:4510], [RFC:4516])。

`````
ldap://<host>/<dn>[?<attrs>[?<scope>[?<filter>[?<extensions>]]]]
`````

## Class Methods

### def build(ary)   -> URI::LDAP
### def build(hash)  -> URI::LDAP

引数で与えられた URI 構成要素から URI::LDAP オブジェクトを生成します。
引数の正当性を検査します。

- **param** `ary` -- 構成要素を表す配列を与えます。要素は次の順です。
```
      [:host, :port, :dn, :attributes, :scope, :filter, :extensions]
```
- **param** `hash` -- 構成要素を表すハッシュを与えます。ハッシュのキーは 
```
            :host, :port, :dn, :attributes, :scope, :filter, :extensions 
```
            のいずれかです。

- **raise** `URI::InvalidComponentError` -- 各要素が適合しない場合に発生します。

例:
`````
require 'uri'
p URI::LDAP.build(["example.com", "1", "/a", "b", "c", "d", "e=f"]).to_s   
#=> "ldap://example.com:1/a?b?c?d?e=f"
`````

### def new(scheme, userinfo, host, port, registry, path, opaque, query, fragment, arg_check = false)   -> URI::LDAP

汎用的な構成要素から URI::LDAP オブジェクトを生成します。
build と異なり、デフォルトでは引数の正当性を検査しません。

- **param** `scheme` -- 構成要素を表す文字列を与えます。

- **param** `userinfo` -- 構成要素を表す文字列を与えます。

- **param** `host` -- 構成要素を表す文字列を与えます。

- **param** `port` -- 構成要素を表す文字列を与えます。

- **param** `registry` -- nil を与えます。

- **param** `path` -- 構成要素を表す文字列を与えます。

- **param** `opaque` -- 構成要素を表す文字列を与えます。

- **param** `query` -- 構成要素を表す文字列を与えます。

- **param** `fragment` -- 構成要素を表す文字列を与えます。

- **param** `arg_check` -- 真が与えられた場合は、各引数が字句規則に適合しているか否かを検査します。適合しない場合は例外 URI::InvalidComponentError が起ります。

- **raise** `URI::InvalidURIError` -- use_registry が偽のとき、registry が与えられると発生します。

- **raise** `URI::InvalidComponentError` -- 各要素が適合しない場合に発生します。

## Instance Methods

### def dn    -> String

自身の Distinguished Name を文字列で返します。

### def dn=(s)

自身の Distinguished Name を文字列で設定します。

- **param** `s` -- 自身の Distinguished Name を文字列で指定します。

### def attributes    -> String

自身の Attribute を文字列で返します。

### def attributes=(s)

自身の Attribute を文字列で設定します。

- **param** `s` -- 自身の Attribute を文字列で設定します。

### def scope    -> String

自身の Scope を文字列で返します。

### def scope=(s)

自身の Scope を文字列で設定します。

- **param** `s` -- 自身の Scope を文字列で設定します。

### def filter    -> String

自身の filter を文字列で返します。

### def filter=(s)

自身の filter を文字列で設定します。

- **param** `s` -- 自身の filter を文字列で設定します。

### def extensions    -> String

自身の extensions を文字列で返します。

### def extensions=(s)

自身の extensions を文字列で設定します。

- **param** `s` -- 自身の extensions を文字列で設定します。

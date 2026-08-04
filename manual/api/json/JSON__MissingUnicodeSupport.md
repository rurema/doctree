---
library: json
until: "4.0"
---
# class JSON::MissingUnicodeSupport < JSON::JSONError

要求されたユニコードサポートがシステムにインストールされていない場合に発生する例外です。
通常、これは `iconv` がインストールされていないことを意味します。

このクラスは json gem 内で「outdated」として扱われており、
json 2.11.0 (2025-04-24 リリース) で削除されました。Ruby 4.0 系に標準添付される json はこの 2.11.0 以降のバージョンであるため、本クラス自体が存在しません。


---
type: library
---
Apache で証認に使用するユーザグループの一覧が格納されているテキストファイルを
読み書きする機能を提供するライブラリです。

 - [url:http://httpd.apache.org/docs/2.2/mod/mod_authz_groupfile.html#authgroupfile]

# class WEBrick::HTTPAuth::Htgroup < Object

Apache で証認に使用するユーザグループの一覧が格納されているテキストファイルを読み書きするためのクラスです。

## Class Methods

### def new(path) -> WEBrick::HTTPAuth::Htgroup

自身を初期化します。

- **param** `path` -- ファイル名を指定します。

## Instance Methods

### def reload
#@# -> discard
ファイルから再度読み込みます。

### def flush(path = nil) -> ()

ファイルに書き込みます。

- **param** `path` -- ファイル名を指定します。

### def members(group) -> [String]

[m:WEBrick::HTTPAuth::Htgroup#reload] を呼んでから与えられたグループに所属するメンバのリストを返します。

- **param** `group` -- グループ名を指定します。

### def add(group, members)
#@# -> discard

与えられたグループにメンバを追加します。

- **param** `group` -- メンバを追加するグループを指定します。

- **param** `members` -- 追加するメンバを配列で指定します。


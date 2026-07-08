---
library: etc
alias:
#@until 3.2
  - Struct::Passwd
#@end
---
# class Etc::Passwd < Struct
[m:Etc?.getpwent] で得られる構造体。

この構造体の値を変更してもシステムには反映されません。

全てのシステムで提供されているメンバ。
  - name
  - passwd
  - uid
  - gid
  - gecos
  - dir
  - shell

以降のメンバはシステムによっては提供されません。
  - change
  - quota
  - age
  - class
  - comment
  - expire

## Class Methods

### def each {|entry| ... } -> Etc::Passwd
### def each                -> Enumerator

/etc/passwd に含まれるエントリを一つずつブロックに渡して評価します。
ブロックを省略した場合は [c:Enumerator] を返します。

- **SEE** [m:Etc?.getpwent]

## Instance Methods

### def dir -> String

このユーザのホームディレクトリを表すパスを返します。

### def dir=(dir)

このユーザのホームディレクトリを表すパスを設定します。

### def gecos -> String

このユーザのフルネーム等の詳細情報を返します。

様々な構造化された情報を返す Unix システムも存在しますが、それはシステム依存です。

### def gecos=()

このユーザのフルネーム等の詳細情報を設定します。

### def gid -> Integer

このユーザの gid を返します。

### def gid=(gid)

このユーザの gid を設定します。

### def name -> String

このユーザのログイン名を返します。

### def name=(name)

このユーザのログイン名を設定します。

### def passwd -> String

このユーザの暗号化されたパスワードを返します。

シャドウパスワードが使用されている場合は、 'x' を返します。
このユーザがログインできない場合は '*' を返します。

### def passwd=(passwd)

このユーザの暗号化されたパスワードを設定します。

### def shell -> String

このユーザのログインシェルを返します。

### def shell=(shell)

このユーザのログインシェルを設定します。

### def uid -> Integer

このユーザの uid を返します。

### def uid=(uid)

このユーザの uid を設定します。

### def change -> Integer

パスワード変更時間(整数)を返します。このメンバはシステム依存です。

### def change=(change)

パスワード変更時間(整数)を設定します。このメンバはシステム依存です。

### def quota -> Integer

クォータ(整数)を返します。このメンバはシステム依存です。

### def quota=(quota)

クォータ(整数)を設定します。このメンバはシステム依存です。

### def age -> Integer

エージ(整数)を返します。このメンバはシステム依存です。

### def age=(age)

エージ(整数)を設定します。このメンバはシステム依存です。

### def uclass -> String

ユーザアクセスクラス(文字列)を返します。このメンバはシステム依存です。

### def uclass=(class)

ユーザアクセスクラス(文字列)を設定します。このメンバはシステム依存です。

### def comment -> String

コメント(文字列)を返します。このメンバはシステム依存です。

### def comment=(comment)

コメント(文字列)を設定します。このメンバはシステム依存です。

### def expire -> Integer

アカウント有効期限(整数)を返します。このメンバはシステム依存です。

### def expire=(expire)

アカウント有効期限(整数)を設定します。このメンバはシステム依存です。


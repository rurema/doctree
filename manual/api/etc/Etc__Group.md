---
library: etc
alias:
#@until 3.2
  - Struct::Group
#@end
---
# class Etc::Group < Struct

[m:Etc?.getgrent] で得られる構造体。

この構造体の値を変更してもシステムには反映されません。

## Class Methods

### def each {|entry| ... } -> Etc::Group
### def each                -> Enumerator

/etc/group に含まれるエントリを一つずつブロックに渡して評価します。
ブロックを省略した場合は [c:Enumerator] を返します。

- **SEE** [m:Etc?.getpwent]

## Instance Methods

### def gid -> Integer

グループ ID を返します。

### def gid=(gid)

グループ ID を設定します。

### def mem -> [String]

このグループに所属するメンバーのログイン名を配列で返します。

### def mem=(mem)

このグループに所属するメンバーのログイン名を設定します。

### def name -> String

グループ名を返します。

### def name=(name)

グループ名を設定します。

### def passwd -> String

暗号化されたパスワードを返します。

このグループのパスワードへのアクセスが無効である場合は 'x' を返します。
このグループの一員になるのにパスワードが不要である場合は、空文字列を返します。

### def passwd=(passwd)

このグループのパスワードを設定します。


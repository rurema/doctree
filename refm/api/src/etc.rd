category Unix

/etc に存在するデータベースから情報を得るためのモジュールです。
クラスにインクルードして使うこともできます。

=== 使い方

  require 'etc'
  p Etc.getlogin

= module Etc

/etc に存在するデータベースから情報を得るためのモジュールです。
クラスにインクルードして使うこともできます。

== Module Functions

#@since 1.8.1
--- getgrent -> Struct::Group | nil

/etc/group ファイルから読み込んだエントリを一つ返します。

最初の呼び出しでは、先頭のエントリを返します。それ以降の呼び出しでは、
呼び出す度に次のエントリを順に返します。ファイルの終端に達すると nil を返します。

処理が終了したときは [[m:Etc.#endgrent]] を呼び出すようにしてください。

@see [[man:getgrent(3)]], [[c:Struct::Group]]

--- endgrent -> nil

[[m:Etc.#getgrent]] によって開始された /etc/group ファイルを読む
プロセスを終了させファイルを閉じます。

@see [[man:getgrent(3)]]

--- setgrent -> nil

/etc/group の先頭に戻ります。

このメソッドを呼び出した後 [[m:Etc.#getgrent]] を呼び出すと先頭のエントリを返します。

@see [[man:getgrent(3)]]

--- getpwent -> Struct::Passwd | nil

/etc/passwd から読み込んだエントリを一つ返します。

最初の呼び出しでは、先頭のエントリを返します。それ以降の呼び出しでは、
呼び出す度に次のエントリを順に返します。ファイルの終端に達すると nil を返します。

処理が終了したときは [[m:Etc.#endpwent]] を呼び出すようにしてください。

@see [[man:getpwent(3)]]

--- endpwent -> nil

[[m:Etc.#getpwent]] によって開始された /etc/passwdファイルを読む
プロセスを終了させファイルを閉じます。

@see [[man:getpwent(3)]]

--- setpwent -> nil

/etc/passwd の先頭に戻ります。

このメソッドを呼び出した後 [[m:Etc.#getpwent]] を呼び出すと先頭のエントリを返します。

@see [[man:getpwent(3)]]

#@end

--- getlogin -> String | nil

自分の login 名を返します。得られなかった場合は nil を返します。

getlogin は [[man:su(1)]] などでログイン時のユーザとは異なるユーザになっている場合、
現在ではなくログイン時のユーザを返します。

このメソッドが失敗した場合は [[m:Etc.#getpwuid]] に
フォールバックするとよいでしょう。

たとえば、環境変数 USER などもあわせて、以下のようにフォールバックできます。

  login_user = ENV['USER'] || ENV['LOGNAME'] || Etc.getlogin || Etc.getpwuid.name


--- getpwnam(name) -> Struct::Passwd

passwd データベースを検索し、
名前が name である passwd エントリを返します。

@param name 検索するユーザ名。

@raise ArgumentError エントリが見つからなかった場合に発生します。

@see [[man:getpwnam(3)]], [[c:Struct::Passwd]]

--- getpwuid(uid = getuid) -> Struct::Passwd

passwd データベースを検索し、
ユーザ ID が uid である passwd エントリを返します。

@param uid 検索する uid 。引数を省略した場合には [[man:getuid(2)]] の値を用います。

@raise ArgumentError エントリが見つからなかった場合に発生します。

@see [[man:getpwuid(3)]], [[c:Struct::Passwd]]

--- getgrgid(gid) -> Struct::Group

group データベースを検索し、グループ ID が gid
であるグループエントリを返します。

@param gid 検索する gid

@raise ArgumentError エントリが見つからなかった場合に発生します。

@see [[man:getgrgid(3)]], [[c:Struct::Group]]

--- getgrnam(name) -> Struct::Group

name という名前のグループエントリを返します。

@param name 検索するグループ名。

@raise ArgumentError エントリが見つからなかった場合に発生します。

@see [[man:getgrnam(3)]], [[c:Struct::Group]]

--- group -> Struct::Group | nil

/etc/group ファイルから読み込んだエントリを一つ返します。

最初の呼び出しでは、先頭のエントリを返します。それ以降の呼び出しでは、
呼び出す度に次のエントリを順に返します。ファイルの終端に達すると nil を返します。

@raise RuntimeError /etc/group ファイルがロックされている場合に発生します。

#@since 1.8.1
@see [[m:Etc.#getgrent]], [[man:getgrent(3)]]
#@else
@see [[man:getgrent(3)]]
#@end

--- group {|gr| ... } -> ()

全てのグループエントリを順にアクセスするためのイテレータです。

--- passwd -> Struct::Passwd | nil

/etc/passwd から読み込んだエントリを一つ返します。

最初の呼び出しでは、先頭のエントリを返します。それ以降の呼び出しでは、
呼び出す度に次のエントリを順に返します。ファイルの終端に達すると nil を返します。

@raise RuntimeError /etc/passwd ファイルがロックされている場合に発生します。

#@since 1.8.1
@see [[m:Etc.#getpwent]], [[man:getpwent(3)]]
#@else
@see [[man:getpwent(3)]]
#@end

--- passwd {|pw| ... } -> ()

全ての passwd エントリを順にアクセスするためのイテレータです。


= class Struct::Group < Struct
#@since 1.9.1
alias Etc::Group
#@end
[[m:Etc.#getgrent]] で得られる構造体。

この構造体の値を変更してもシステムには反映されません。

#@since 1.9.2

== Class Methods

--- each {|entry| ... } -> Struct::Group
--- each                -> Enumerator

/etc/group に含まれるエントリを一つずつブロックに渡して評価します。
ブロックを省略した場合は [[c:Enumerator]] のインスタンスを返します。

@see [[m:Etc.#getpwent]]

#@end

== Instance Methods

--- gid -> Integer

グループ ID を返します。

--- gid=(gid)

グループ ID を設定します。

--- mem -> [String]

このグループに所属するメンバーのログイン名を配列で返します。

--- mem=(mem)

このグループに所属するメンバーのログイン名を設定します。

--- name -> String

グループ名を設定します。


--- name=(name)

グループ名を返します。

--- passwd -> String

暗号化されたパスワードを返します。

このグループのパスワードへのアクセスが無効である場合は 'x' を返します。
このグループの一員になるのにパスワードが不要である場合は、空文字列を返します。


--- passwd=(passwd)

このグループのパスワードを設定します。

= class Struct::Passwd < Struct
#@since 1.9.1
alias Etc::Passwd
#@end
[[m:Etc.#getpwent]] で得られる構造体。

この構造体の値を変更してもシステムには反映されません。

全てのシステムで提供されているメンバ。
  * name
  * passwd
  * uid
  * gid
  * gecos
  * dir
  * shell

以降のメンバはシステムによっては提供されません。
  * change
  * quota
  * age
  * class
  * comment
  * expire

#@since 1.9.2

== Class Methods

--- each {|entry| ... } -> Struct::Passwd
--- each                -> Enumerator

/etc/passwd に含まれるエントリを一つずつブロックに渡して評価します。
ブロックを省略した場合は [[c:Enumerator]] のインスタンスを返します。

@see [[m:Etc.#getpwent]]

#@end

== Instance Methods

--- dir -> String

このユーザのホームディレクトリを表すパスを返します。

--- dir=(dir)

このユーザのホームディレクトリを表すパスを設定します。

--- gecos -> String

このユーザのフルネーム等の詳細情報を返します。

様々な構造化された情報を返す Unix システムも存在しますが、それはシステム依存です。

--- gecos=()

このユーザのフルネーム等の詳細情報を設定します。

--- gid -> Integer

このユーザの gid を返します。

--- gid=(gid)

このユーザの gid を設定します。

--- name -> String

このユーザのログイン名を返します。

--- name=(name)

このユーザのログイン名を設定します。

--- passwd -> String

このユーザの暗号化されたパスワードを返します。

シャドウパスワードが使用されている場合は、 'x' を返します。
このユーザがログインできない場合は '*' を返します。

--- passwd=(passwd)

このユーザの暗号化されたパスワードを設定します。

--- shell -> String

このユーザのログインシェルを返します。

--- shell=(shell)

このユーザのログインシェルを設定します。

--- uid -> Integer

このユーザの uid を返します。

--- uid=(uid)

このユーザの uid を設定します。

--- change -> Integer

パスワード変更時間(整数)を返します。このメンバはシステム依存です。

--- change=(change)

パスワード変更時間(整数)を設定します。このメンバはシステム依存です。

--- quota -> Integer

クォータ(整数)を返します。このメンバはシステム依存です。

--- quota=(quota)

クォータ(整数)を設定します。このメンバはシステム依存です。

--- age -> Integer

エージ(整数)を返します。このメンバはシステム依存です。

--- age=(age)

エージ(整数)を設定します。このメンバはシステム依存です。

--- uclass -> String

ユーザアクセスクラス(文字列)を返します。このメンバはシステム依存です。

--- uclass=(class)

ユーザアクセスクラス(文字列)を設定します。このメンバはシステム依存です。

--- comment -> String

コメント(文字列)を返します。このメンバはシステム依存です。

--- comment=(comment)

コメント(文字列)を設定します。このメンバはシステム依存です。

--- expire -> Integer

アカウント有効期限(整数)を返します。このメンバはシステム依存です。

--- expire=(expire)

アカウント有効期限(整数)を設定します。このメンバはシステム依存です。

/etc に存在するデータベースから情報を得るためのモジュールです。
クラスにインクルードして使うこともできます。

=== 使い方

  require 'etc'
  p Etc.getlogin

= module Etc

== Module Functions

#@if (version >= "1.8.1")
--- endgrent

#@end

#@if (version >= "1.8.1")
--- endpwent

#@end

#@if (version >= "1.8.1")
--- getgrent

#@end

#@if (version >= "1.8.1")
--- getpwent

#@end

#@if (version >= "1.8.1")
--- setgrent

#@end

#@if (version >= "1.8.1")
--- setpwent

#@end

--- getlogin

自分の login 名を返します。得られなかった場合は nil を返します。

getlogin は su などでログイン時のユーザとは異なるユーザになっている場合、
現在ではなくログイン時のユーザを返します。

このメソッドが失敗した場合は [[m:Etc.getpwuid]] に
フォールバックするとよいでしょう。

たとえば、環境変数 USER などもあわせて、以下のようにフォールバックできます。

  login_user = ENV['USER'] || ENV['LOGNAME'] || Etc.getlogin || Etc.getpwuid.name


--- getpwnam(name)

passwd データベースを検索し、
名前が name である passwd エントリを返します。
戻り値は passwd 構造体で、以下のメンバを持ちます。

  struct passwd
    name        # ユーザ名(文字列)
    passwd      # パスワード(文字列)
    uid         # ユーザID(整数)
    gid         # グループID(整数)
    gecos       # gecosフィールド(文字列)
    dir         # ホームディレクトリ(文字列)
    shell       # ログインシェル(文字列)
    # 以降のメンバはシステムによっては提供されない
    change      # パスワード変更時間(整数)
    quota       # クォータ(整数)
    age         # エージ(整数)
    class       # ユーザアクセスクラス(文字列)
    comment     # コメント(文字列)
    expire      # アカウント有効期限(整数)
  end

名前が name である passwd エントリがなかった場合、
ArgumentError が発生します。

詳細は [[man:getpwnam(3)]] を参照してください。

--- getpwuid([uid])

passwd データベースを検索し、
ユーザ ID が uid である passwd エントリを返します。
戻り値は [[m:etc#Etc.getpwnam]] と同様です。
引数を省略した場合には [[man:getuid(2)]] の値を用います。

詳細は [[man:getpwuid(3)]] を参照してください。

--- getgrgid(gid)

group データベースを検索し、グループ ID が gid
であるグループエントリを返します。
戻り値は group 構造体で、以下のメンバを持ちます。

  struct group
    name        # グループ名(文字列)
    passwd      # グループのパスワード(文字列)
    gid         # グループID(整数)
    mem         # グループメンバ名の配列
  end

詳細は [[man:getgrgid(3)]] を参照してください。

--- getgrnam(name)

name という名前のグループエントリを返します。
戻り値は [[m:Etc.getgrgid]] と同様です。

詳細は[[man:getgrnam(3)]] を参照してください。

--- group
--- group {|group| ... }

全てのグループエントリを順にアクセスするためのイテレータです。

--- passwd
--- passwd {|passwd| ... }

全ての passwd エントリを順にアクセスするためのイテレータです。

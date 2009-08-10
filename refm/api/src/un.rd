Unix の基本コマンドの代替となるユーティリティ。

Makefile 内でシステムに依存しないように用意されました。
[[lib:mkmf]] が使用します。

Windows などワイルドカードを認識しないシステム(シェル)のために引数は
unがワイルドカード展開([[m:Dir.glob]]参照)します(Unix ではシェ
ルとunにより二重にワイルドカード展開されます)。

=== 使い方:

   ruby -run -e cp -- [-prv] SOURCE DEST
   ruby -run -e ln -- [-sfv] TARGET LINK_NAME
   ruby -run -e mv -- [-v] SOURCE DEST
   ruby -run -e rm -- [-frv] FILE
   ruby -run -e mkdir -- [-pv] DIRS
   ruby -run -e rmdir -- [-v] DIRS
   ruby -run -e install -- [-pv -m mode] SOURCE DEST
   ruby -run -e chmod -- [-v] OCTAL-MODE FILE
   ruby -run -e touch -- [-v] FILE
   ruby -run -e help [COMMAND]

= reopen Kernel
== Private Instance Methods
--- chmod -> ()
ファイルのアクセス権を変更します。

Change the mode of each FILE to OCTAL-MODE.

  ruby -run -e chmod -- [OPTION] OCTAL-MODE FILE

  -v          詳細表示

@see [[man:chmod(1)]]

--- cp -> ()
ファイルやディレクトリをコピーします。


  ruby -run -e cp -- [OPTION] SOURCE DEST

  -p          可能であればファイルの属性を保持します。
  -r          再帰的にコピーします。
  -v          詳細表示

@see [[man:cp(1)]]

--- help -> ()
ヘルプメッセージを表示します。


  ruby -run -e help [COMMAND]

--- install -> ()
ファイルをコピーし、その属性を設定します。


  ruby -run -e install -- [OPTION] SOURCE DEST

  -p          ファイルのアクセス時刻と修正時刻を保持します。
              corresponding destination files
  -m          chmod と同じようにファイルのパーミッションを設定します。
  -v          詳細表示

@see [[man:install(1)]]

--- ln -> ()
ファイルへのリンクを作成します。

  ruby -run -e ln -- [OPTION] TARGET LINK_NAME

  -s          ハードリンクの代わりにシンボリックリンクを作成します
  -f          LINK_NAME を上書きします
  -v          詳細表示

@see [[man:ln(1)]]

--- mkdir -> ()
ディレクトリを作成します。


  ruby -run -e mkdir -- [OPTION] DIR

  -p          ディレクトリが存在してもエラーになりません。
              必要であれば親ディレクトリも作成します。
  -v          詳細表示

@see [[man:mkdir(1)]]

--- mv -> ()

ファイルを移動します (ファイル名を変更します)。


  ruby -run -e mv -- [OPTION] SOURCE DEST

  -v          詳細表示

@see [[man:mv(1)]]

--- rm -> ()

ファイルやディレクトリを削除します。


  ruby -run -e rm -- [OPTION] FILE

  -f          存在しないファイルを無視します
  -r          ディレクトリを再帰的にたどってファイルやディレクトリを削除します
  -v          詳細表示

@see [[man:rm(1)]]

--- rmdir -> ()

空のディレクトリを削除します。

  ruby -run -e rmdir -- [OPTION] DIR

  -v          詳細表示

@see [[man:rmdir(1)]]

--- touch -> ()

ファイルのアクセス時刻と修正時刻を現在の時刻に変更します。


  ruby -run -e touch -- [OPTION] FILE

  -v          詳細表示

@see [[man:touch(1)]]

#@# 内部的に使用するだけ
#@# --- setup(options = "", * long_options) -> ()

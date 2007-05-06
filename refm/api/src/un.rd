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
#@todo
Change the mode of each FILE to OCTAL-MODE.

  ruby -run -e chmod -- [OPTION] OCTAL-MODE FILE

  -v          verbose

--- cp -> ()
#@todo
Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY

  ruby -run -e cp -- [OPTION] SOURCE DEST

  -p          preserve file attributes if possible
  -r          copy recursively
  -v          verbose

--- help -> ()
#@todo
Display help message.

  ruby -run -e help [COMMAND]

--- install -> ()
#@todo
Copy SOURCE to DEST.

  ruby -run -e install -- [OPTION] SOURCE DEST

  -p          apply access/modification times of SOURCE files to
              corresponding destination files
  -m          set permission mode (as in chmod), instead of 0755
  -v          verbose

--- ln -> ()
#@todo
Create a link to the specified TARGET with LINK_NAME.

  ruby -run -e ln -- [OPTION] TARGET LINK_NAME

  -s          make symbolic links instead of hard links
  -f          remove existing destination files
  -v          verbose

--- mkdir -> ()
#@todo
Create the DIR, if they do not already exist.

  ruby -run -e mkdir -- [OPTION] DIR

  -p          no error if existing, make parent directories as needed
  -v          verbose

--- mv -> ()
#@todo
Rename SOURCE to DEST, or move SOURCE(s) to DIRECTORY.

  ruby -run -e mv -- [OPTION] SOURCE DEST

  -v          verbose

--- rm -> ()
#@todo
Remove the FILE

  ruby -run -e rm -- [OPTION] FILE

  -f          ignore nonexistent files
  -r          remove the contents of directories recursively
  -v          verbose

--- rmdir -> ()
#@todo
Remove the DIR.

  ruby -run -e rmdir -- [OPTION] DIR

  -v          verbose

--- touch -> ()
#@todo
Update the access and modification times of each FILE to the current time.

  ruby -run -e touch -- [OPTION] FILE

  -v          verbose


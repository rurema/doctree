= class File::Stat < Object

include Comparable

ファイルの情報を格納したオブジェクトのクラス。

[[c:FileTest]] に同名のモジュール関数がある場合はそれと同じ働きをします。ただ、
ファイル名を引数に取るかわりに Stat 自身について判定する点が違います。

== Class Methods

--- new(path)

path に関する File::Stat オブジェクトを生成して返します。
[[m:File.stat]] と同じです。

== Instance Methods

--- <=>(o)

ファイルの最終更新時刻を比較します。self が other よりも
新しければ正の数を、等しければ 0 を古ければ負の数を返します。

--- ftype
ファイルのタイプを表す文字列を返します。文字列は以下のうちの
いずれかです。

  "file"
  "directory"
  "characterSpecial"
  "blockSpecial"
  "fifo"
  "link"
  "socket"
  
  "unknown"

#@# あらい 2002-01-06: 今のところ "unknown" を返すことはないはず。
#@# もしそのようなことがあれば、バグ報告をした方が良いと思われる。
#@# Solaris の Door とかは unknown になる？

以下の属性メソッドは、システムによってサポートされていない場合 0 が返ります。
#@if (version >= "1.8.0")
1.8.0 以降では nil が返ります。
#@end

--- dev
デバイス番号(ファイルシステム)

#@since 1.8.2
--- dev_major
dev の major 番号部
--- dev_minor
dev の minor 番号部
#@end

--- ino
i-node 番号
--- mode
ファイルモード
--- nlink
ハードリンクの数
--- uid
オーナーのユーザID
--- gid
オーナーのグループID
--- rdev
デバイスタイプ(スペシャルファイルのみ)
--- rdev_major
rdev の major 番号部
--- rdev_minor
rdev の minor 番号部
--- size
ファイルサイズ(バイト単位)
--- blksize
望ましいI/Oのブロックサイズ
--- blocks
割り当てられているブロック数
--- atime
最終アクセス時刻
--- mtime
最終更新時刻
--- ctime
最終状態変更時刻
(状態の変更とは chmod などによるもので、Unix では i-node の変更を意味します)

--- directory?
ディレクトリの時に真
--- readable?
読み込み可能な時に真
--- readable_real?
実ユーザ/実グループによって読み込み可能な時に真
--- writable?
書き込み可能な時に真
--- writable_real?
実ユーザ/実グループによって書き込み可能な時に真
--- executable?
実効ユーザ/グループIDで実行できる時に真
--- executable_real?
実ユーザ/グループIDで実行できる時に真
--- file?
通常ファイルの時に真
--- zero?
サイズが0である時に真
--- size?
サイズ(0の時には偽)
--- owned?
自分のものである時に真
--- grpowned?
グループIDが実行グループIDと等しい時に真

--- pipe?
名前つきパイプ(FIFO)の時に真
--- symlink?
シンボリックリンクである時に真
--- socket?
ソケットの時に真

--- blockdev?
ブロックスペシャルファイルの時に真
--- chardev?
キャラクタスペシャルファイルの時に真

--- setuid?
setuidされている時に真
--- setgid?
setgidされている時に真
--- sticky?
stickyビットが立っている時に真

#@since 1.9.0
--- world_readable?
#@todo
--- world_writable? 
#@todo
#@end

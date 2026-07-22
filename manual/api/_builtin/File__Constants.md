---
library: _builtin
---
# module File::Constants

[c:File] に関る定数を集めたモジュール。

[c:File] はこのモジュールをインクルードしているので、
以下に挙げる定数は [c:File] の定数のように扱うことができます。

Ruby 1.8 以降では、[c:File] ではなく、[c:IO] でインクルード
されるようになりました。

#@# 情報源: RUBY/ext/fcntl/fcntl.c

## Constants

#@# [[m:File#flock]] で使われる定数 ----------------------------------

### const LOCK_SH -> Integer

共有ロック。複数のプロセスが同時にロックを共有できます。
[m:File#flock] で使用します。

### const LOCK_EX -> Integer

排他ロック。同時にはただひとつのプロセスだけがロックを保持できます。
[m:File#flock] で使用します。

### const LOCK_UN -> Integer

アンロック。[m:File#flock] で使用します。

### const LOCK_NB -> Integer

ロックの際にブロックしない。他の指定と or することで指定します。
[m:File#flock] で使用します。

#@# [[m:File.open]] で使われる定数 -----------------------------------

### const RDONLY -> Integer

読み込みのみのモードでファイルを開くときに指定します。
[m:File.open]で使用します。

### const WRONLY -> Integer

書き込みのみのモードでファイルを開くときに指定します。
[m:File.open]で使用します。

### const RDWR -> Integer

読み書き両方のモードでファイルを開くときに指定します。
[m:File.open]で使用します。

### const APPEND -> Integer

追記モードでファイルを開くときに指定します。
[m:File.open]で使用します。

### const CREAT -> Integer

ファイルがなければ作成するよう指定します。
[m:File.open]で使用します。

### const EXCL -> Integer

CREATと併用し、もしファイルが既にある場合には失敗します。
[m:File.open]で使用します。

### const NONBLOCK -> Integer

ファイルが利用可能じゃなくてもブロックしません。
#@# IO.open で使用、かも...
[m:File.open]で使用します。

### const TRUNC -> Integer

もしファイルが存在するなら、中身を抹消してサイズをゼロにします。
[m:File.open]で使用します。

### const NOCTTY -> Integer

自身がTTY制御しないようにTTYを開きます。
[m:File.open]で使用します。

### const BINARY -> Integer

ファイルをバイナリとして開きます。
open(2) で O_BINARYが指定できる場合に使えます。
[m:File.open]で使用します。

### const SHARE_DELETE -> Integer

ファイルを開いたままの状態でも削除できるように指定して開きます。
O_SHARE_DELETE が指定できる場合に使えます。
[m:File.open]で使用します。

2.3.0 現在はファイルをバイナリとして開いた場合のみ有効です。

### const SYNC -> Integer

ファイルを同期モードで開きます。
open(2) で O_SYNCが指定できる場合に使えます。
[m:File.open]で使用します。

### const DSYNC -> Integer

ファイルをデータ同期モードで開きます。
open(2) で O_DSYNC が指定できる場合に使えます。
[m:File.open]で使用します。

### const NOFOLLOW -> Integer

ファイルがシンボリックリンクであった場合に
例外を発生させます。
open(2) で O_NOFOLLOW が指定できる場合に使えます。
[m:File.open]で使用します。

### const RSYNC -> Integer

ファイルを読み込み時同期モードで開きます。
open(2) で O_RSYNC が指定できる場合に使えます。
[m:File.open]で使用します。

### const NOATIME -> Integer

ファイル読み込み時に atime を更新しません。
open(2) で O_ATIME が指定できる場合に使えます。
[m:File.open]で使用します。

atime が更新されないのは確実ではないということに注意してください。
これは性能のためのオプションです。

### const DIRECT -> Integer

このファイルに対する I/O のキャッシュの効果を最小化しようとする。 

このフラグを使うと、一般的に性能が低下する。 しかしアプリケーションが独自に
キャッシングを行っているような 特別な場合には役に立つ。 ファイルの I/O
はユーザー空間バッファに対して直接行われる。 [m:File::Constants::DIRECT] フラグ自身はデー
タを同期で転送しようとはするが、 [m:File::Constants::SYNC] のようにデータと必要なメタデー
タの転送が保証されるわけではない。 同期 I/O を保証するためには、
[m:File::Constants::DIRECT] に加えて [m:File::Constants::SYNC] を使用しなければならない。

[m:File.open]で使用します。

### const TMPFILE -> Integer

名前なしの一時ファイルを作成します。
open(2) で O_TMPFILE が指定できる場合に使えます。
[m:File.open]で使用します。

#@# [[m:File.fnmatch]], [[m:Dir.glob で使われる定数 ------------------

### const FNM_NOESCAPE -> Integer

エスケープ文字 \`\' を普通の文字とみなします。
[m:File.fnmatch], [m:Dir.glob]で使用します。

### const FNM_PATHNAME -> Integer

ワイルドカード `*`, `?`, `[]` が `/` にマッチしなくなります。
シェルのパターンのマッチにはこのフラグが使用されています。
[m:File.fnmatch], [m:Dir.glob]で使用します。

### const FNM_DOTMATCH -> Integer

ワイルドカード `*`, `?`, `[]` が先頭の `.` にマッチするようになります。
[m:File.fnmatch], [m:Dir.glob]で使用します。

### const FNM_CASEFOLD -> Integer

アルファベットの大小文字を区別せずにパターンのマッチを行います。
[m:File.fnmatch], [m:Dir.glob]で使用します。

### const FNM_SYSCASE -> Integer

case hold なファイルシステムの場合、FNM_CASEFOLD の値になり、そうでなければゼロの値になります。
[m:File.fnmatch], [m:Dir.glob]で使用します。

### const FNM_EXTGLOB -> Integer

{} 内のコンマで区切られた文字列の組合せにマッチするようになります。
[m:File.fnmatch] で使用します。

### const NULL -> String

NULLデバイスのファイル名です。


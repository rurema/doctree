---
library: fileutils
---
# module FileUtils

基本的なファイル操作を集めたモジュールです。


### オプションの説明 {#options}

各メソッドでキーワード引数として指定できるオプションの説明です。
メソッドごとに指定できるキーワードは決まっています。
未対応のキーワードを指定すると [c:ArgumentError] が発生します。

- **`:noop`**:
  真を指定すると実際の処理は行いません。
- **`:preserve`**:
  真を指定すると更新時刻と、可能なら所有ユーザ・所有グループもコピーします。
- **`:verbose`**:
  真を指定すると詳細を出力します。
- **`:mode`**:
  パーミッションを8進数で指定します。
- **`:force`**:
  真を指定すると作業中すべての [c:StandardError] を無視します。
- **`:nocreate`**:
  真を指定するとファイルを作成しません。
- **`:dereference_root`**:
  真を指定すると src についてだけシンボリックリンクの指す
  内容をコピーします。偽の場合はシンボリックリンク自体をコピーします。
- **`:remove_destination`**:
  真を指定するとコピーを実行する前にコピー先を削除します。
- **`:secure`**:
  真を指定するとファイルの削除に [m:FileUtils?.remove_entry_secure] を使用します。
- **`:mtime`**:
  時刻を [c:Time] か、起算時からの経過秒数を数値で指定します。
- **`:parents`**:
  真を指定すると指定したディレクトリの親ディレクトリも含めて削除します。
- **`:owner`**:
  ユーザー名か uid を指定すると所有ユーザを変更します。
- **`:group`**:
  グループ名か gid を指定すると所有グループを変更します。

## Module Functions

### module_function def cd(dir, verbose: nil)                   -> 0
### module_function def cd(dir, verbose: nil) {|dir| .... }     -> object
### module_function def chdir(dir, verbose: nil)                -> 0
### module_function def chdir(dir, verbose: nil) {|dir| .... }  -> object

プロセスのカレントディレクトリを dir に変更します。

ブロックとともに呼び出された時はブロック終了後に
元のディレクトリに戻ります。

- **param** `dir` -- ディレクトリを指定します。

- **param** `verbose` -- 真を指定すると詳細を出力します。

```ruby
require 'fileutils'
FileUtils.cd('/', verbose: true)   # chdir and report it
```

### module_function def chmod(mode, list, noop: nil, verbose: nil) -> Array

ファイル list のパーミッションを mode に変更します。

- **param** `mode` -- パーミッションを8進数(absolute mode)か文字列(symbolic
            mode)で指定します。

- **param** `list` -- ファイルのリストを指定します。 対象のファイルが一つの場合は文字列でも指定可能です。
           二つ以上指定する場合は配列で指定します。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **return** -- list を配列として返します。

```ruby
# Absolute mode
require 'fileutils'
FileUtils.chmod(0644, %w(my.rb your.rb his.rb her.rb))
FileUtils.chmod(0755, 'somecommand')
FileUtils.chmod(0755, '/usr/bin/ruby', verbose: true)
# Symbolic mode
require 'fileutils'
FileUtils.chmod("u=wr,go=rr", %w(my.rb your.rb his.rb her.rb))
FileUtils.chmod("u=wrx,go=rx", 'somecommand')
FileUtils.chmod("u=wrx,go=rx", '/usr/bin/ruby', verbose: true)
```

symbolic mode では以下の指定を 操作対象 演算子 権限 の順番で指定します。

操作対象(複数指定可。省略した場合は a)。

 - "a": 全て(所有者、グループ、その他)のユーザを指定するマスク
 - "u": 所有者を指定するマスク
 - "g": グループ(ファイルと同じグループに属しているが所有者ではない)を指定するマスク
 - "o": その他(所有者でもなく、そのファイルと同じグループにも属していない)を指定するマスク

演算子。

 - "+": 以降で指定した権限を追加
 - "-" 以降で指定した権限を削除
 - "=" 以降で指定した権限を指定

権限(複数指定可)。

 - "w": 書き込み権限
 - "r": 読み込み権限
 - "x": 実行権限
 - "s": 実行時にユーザー、あるいはグループ ID を設定
 - "t": sticky ビット

### module_function def chmod_R(mode, list, noop: nil, verbose: nil, force: nil) -> Array

ファイル list のパーミッションを再帰的に mode へ変更します。

- **param** `mode` -- パーミッションを8進数(absolute mode)か文字列(symbolic
            mode)で指定します([m:FileUtils?.chmod] 参照)。

- **param** `list` -- ファイルのリストを指定します。対象のファイルが一つの場合は文字列でも指定可能です。
           二つ以上指定する場合は配列で指定します。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **param** `force` -- 真を指定すると処理中に発生した [c:StandardError] を無視します。

- **return** -- list を配列として返します。

```ruby
require 'fileutils'
FileUtils.chmod_R(0700, '/tmp/removing')
```

### module_function def chown(user, group, list, noop: nil, verbose: nil) -> Array

ファイル list の所有ユーザと所有グループを user と group に変更します。

user, group に nil または -1 を渡すとその項目は変更しません。

- **param** `user` -- ユーザー名か uid を指定します。nil/-1 を指定すると変更しません。

- **param** `group` -- グループ名か gid を指定します。nil/-1 を指定すると変更しません。

- **param** `list` -- ファイルのリストを指定します。対象のファイルが一つの場合は文字列でも指定可能です。
           二つ以上指定する場合は配列で指定します。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **return** -- list を配列として返します。


```ruby
require 'fileutils'
FileUtils.chown 'root', 'staff', '/usr/local/bin/ruby'
FileUtils.chown nil, 'bin', Dir.glob('/usr/bin/*'), verbose: true
```

### module_function def chown_R(user, group, list, noop: nil, verbose: nil, force: nil) -> Array

list 以下のファイルの所有ユーザと所有グループを
user と group へ再帰的に変更します。

user, group に nil または -1 を渡すとその項目は変更しません。

- **param** `user` -- ユーザー名か uid を指定します。nil/-1 を指定すると変更しません。

- **param** `group` -- グループ名か gid を指定します。nil/-1 を指定すると変更しません。

- **param** `list` -- ファイルのリストを指定します。対象のファイルが一つの場合は文字列でも指定可能です。
           二つ以上指定する場合は配列で指定します。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **param** `force` -- 真を指定すると処理中に発生した [c:StandardError] を無視します。

- **return** -- list を配列として返します。

```ruby
require 'fileutils'
FileUtils.chown 'root', 'staff', '/usr/local/bin/ruby'
FileUtils.chown nil, 'bin', Dir.glob('/usr/bin/*'), verbose: true

require 'fileutils'
FileUtils.chown_R 'www', 'www', '/var/www/htdocs'
FileUtils.chown_R 'cvs', 'cvs', '/var/cvs', verbose: true
```

### module_function def cmp(file_a, file_b)          -> bool
### module_function def compare_file(file_a, file_b) -> bool
### module_function def identical?(file_a, file_b)   -> bool

ファイル file_a と file_b の内容が同じなら真を返します。

- **param** `file_a` -- ファイル名。

- **param** `file_b` -- ファイル名。

```ruby
require 'fileutils'
p FileUtils.cmp('somefile', 'somefile')    #=> true
p FileUtils.cmp('/dev/null', '/dev/urandom') #=> false
```

### module_function def compare_stream(io_a, io_b) -> bool

[c:IO] オブジェクト io_a と io_b の内容が同じなら真を返します。

- **param** `io_a` -- [c:IO] オブジェクト。

- **param** `io_b` -- [c:IO] オブジェクト。

### module_function def copy_entry(src, dest, preserve = false, dereference_root = false) -> ()

ファイル src を dest にコピーします。

src が普通のファイルでない場合はその種別まで含めて完全にコピーします。
src がディレクトリの場合はその中身を再帰的にコピーします。

- **param** `src` -- コピー元。

- **param** `dest` -- コピー先。

- **param** `preserve` -- preserve が真のときは更新時刻と、
                可能なら所有ユーザ・所有グループもコピーします。

- **param** `dereference_root` -- dereference_root が真のときは src についてだけシンボリックリンクの指す
                        内容をコピーします。偽の場合はシンボリックリンク自体をコピーします。


### module_function def copy_file(src, dest, preserve = false, dereference_root = true) -> ()

ファイル src の内容を dest にコピーします。

- **param** `src` -- コピー元。

- **param** `dest` -- コピー先。

- **param** `preserve` -- preserve が真のときは更新時刻と、
                可能なら所有ユーザ・所有グループもコピーします。

- **param** `dereference_root` -- dereference_root が真のときは src についてだけシンボリックリンクの指す
                        内容をコピーします。偽の場合はシンボリックリンク自体をコピーします。


### module_function def copy_stream(src, dest) -> ()

src を dest にコピーします。
src には read メソッド、dest には write メソッドが必要です。

- **param** `src` -- read メソッドを持つオブジェクト。

- **param** `dest` -- write メソッドを持つオブジェクト。


### module_function def cp(src, dest, preserve: nil, noop: nil, verbose: nil)   -> ()
### module_function def copy(src, dest, preserve: nil, noop: nil, verbose: nil) -> ()

ファイル src を dest にコピーします。

src にファイルが一つだけ与えられた場合、
dest がディレクトリならdest/src にコピーします。
dest が既に存在ししかもディレクトリでないときは上書きします。

src にファイルが複数与えられた場合、
file1 を dest/file1 にコピー、file2 を dest/file2 にコピー、
というように、ディレクトリ dest の中にファイル file1、file2、 …を
同じ名前でコピーします。dest がディレクトリでない場合は例外
[c:Errno::ENOTDIR] が発生します。

- **param** `src` -- コピー元。一つの場合は文字列でも指定可能です。
           二つ以上指定する場合は配列で指定します。

- **param** `dest` -- コピー先のファイルかディレクトリです。

- **param** `preserve` -- 真を指定すると更新時刻と、可能なら所有ユーザ・所有グループもコピーします。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **raise** `Errno::ENOTDIR` -- src が複数のファイルかつ、dest がディレクトリでない場合に発生します。

```ruby
require 'fileutils'
FileUtils.cp 'eval.c', 'eval.c.org'
FileUtils.cp(['cgi.rb', 'complex.rb', 'date.rb'], '/usr/lib/ruby/1.8')
FileUtils.cp(%w(cgi.rb complex.rb date.rb), '/usr/lib/ruby/1.8', verbose: true)
```

### module_function def cp_r(src, dest, preserve: nil, noop: nil, verbose: nil, dereference_root: true, remove_destination: nil) -> ()

src を dest にコピーします。src がディレクトリであったら再帰的に
コピーします。その際 dest がディレクトリなら dest/src にコピーします。

- **param** `src` -- コピー元。一つの場合は文字列でも指定可能です。
           二つ以上指定する場合は配列で指定します。

- **param** `dest` -- コピー先のファイルかディレクトリです。

- **param** `preserve` -- 真を指定すると更新時刻と、可能なら所有ユーザ・所有グループもコピーします。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **param** `dereference_root` -- 真を指定すると src についてだけシンボリックリンクの指す
                        内容をコピーします。偽の場合はシンボリックリンク自体をコピーします。

- **param** `remove_destination` -- 真を指定するとコピーを実行する前にコピー先を削除します。

```ruby
# installing ruby library "mylib" under the site_ruby
require 'fileutils'
FileUtils.rm_r(site_ruby + '/mylib', force: true)
FileUtils.cp_r('lib/', site_ruby + '/mylib')
# other sample
require 'fileutils'
FileUtils.cp_r(%w(mail.rb field.rb debug/), site_ruby + '/tmail')
FileUtils.cp_r(Dir.glob('*.rb'), '/home/taro/lib/ruby',
                noop: true, verbose: true)
```

### module_function def install(src, dest, mode: nil, owner: nil, group: nil, preserve: nil, noop: nil, verbose: nil) -> ()

src と dest の内容が違うときだけ src を dest にコピーします。

- **param** `src` -- コピー元。一つの場合は文字列でも指定可能です。
           二つ以上指定する場合は配列で指定します。

- **param** `dest` -- コピー先のファイルかディレクトリです。

- **param** `mode` -- パーミッションを8進数(absolute mode)か文字列(symbolic
            mode)で指定します。symbolic mode の詳細は [m:FileUtils?.chmod] を
            参照してください。

- **param** `owner` -- ユーザー名か uid を指定すると所有ユーザを変更します。

- **param** `group` -- グループ名か gid を指定すると所有グループを変更します。

- **param** `preserve` -- 真を指定すると更新時刻と、可能なら所有ユーザ・所有グループもコピーします。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

```ruby
require 'fileutils'
FileUtils.install('ruby', '/usr/local/bin/ruby', mode: 0755, verbose: true)
FileUtils.install('lib.rb', '/usr/local/lib/ruby/site_ruby', verbose: true)
```

### module_function def ln(src, dest, force: nil, noop: nil, verbose: nil)   -> ()
### module_function def link(src, dest, force: nil, noop: nil, verbose: nil) -> ()

src へのハードリンク dest を作成します。

src が一つの場合、
dest がすでに存在しディレクトリであるときは dest/src を作成します。
dest がすでに存在しディレクトリでないならば例外 Errno::EEXIST が発生します。
ただし :force オプションを指定したときは dest を上書きします。

src が複数の場合、
src[0] へのハードリンク dest/src[0]、src[1] への
ハードリンク dest/src[1] …を作成します。
dest がディレクトリでない場合は例外 Errno::ENOTDIR が発生します。

- **param** `src` -- リンク元。一つの場合は文字列でも指定可能です。
           二つ以上指定する場合は配列で指定します。

- **param** `dest` -- リンク作成先のファイルかディレクトリです。

- **param** `force` -- 真を指定すると dest を上書きします。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **raise** `Errno::EEXIST` -- src が一つで dest がすでに存在しディレクトリでない場合に発生します。
- **raise** `Errno::ENOTDIR` -- src が複数で dest がディレクトリでない場合に発生します。


```ruby
require 'fileutils'
FileUtils.ln('gcc', 'cc', verbose: true)
FileUtils.ln('/usr/bin/emacs21', '/usr/bin/emacs')
FileUtils.cd('/bin')
FileUtils.ln(%w(cp mv mkdir), '/usr/bin')
```

### module_function def cp_lr(src, dest, noop: nil, verbose: nil, dereference_root: true, remove_destination: false)

src へのハードリンク dest を作成します。
src がディレクトリの場合、再帰的にリンクします。
dest がディレクトリの場合、src へのハードリンク dest/src を作成します。

- **param** `src` -- リンク元。一つの場合は文字列でも指定可能です。
           二つ以上指定する場合は配列で指定します。

- **param** `dest` -- リンク作成先のファイルかディレクトリです。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **param** `dereference_root` -- 真を指定すると src についてだけシンボリックリンクの指す
                        内容をコピーします。偽の場合はシンボリックリンク自体をコピーします。

- **param** `remove_destination` -- 真を指定するとコピーを実行する前にコピー先を削除します。

- **raise** `ArgumentError` -- dest が src に含まれる場合に発生します。
- **raise** `Errno::EEXIST` -- src が一つで dest がすでに存在しディレクトリでない場合に発生します。
- **raise** `Errno::ENOTDIR` -- src が複数で dest がディレクトリでない場合に発生します。

```ruby title="\"mylib\" ライブラリを site_ruby にインストールする例"
require 'fileutils'
FileUtils.rm_r site_ruby + '/mylib', force: true
FileUtils.cp_lr 'lib/', site_ruby + '/mylib'
```

```ruby title="様々なファイルを対象ディレクトリにリンクする例"
require 'fileutils'
FileUtils.cp_lr %w(mail.rb field.rb debug/), site_ruby + '/tmail'
FileUtils.cp_lr Dir.glob('*.rb'), '/home/aamine/lib/ruby', noop: true, verbose: true
```

```ruby title="内容をリンクする例"
require 'fileutils'
# ディレクトリそのものではなく、ディレクトリの内容をリンクしたい場合は、
# 以下のようになります。(たとえば src/x -> dest/x, src/y -> dest/y)
FileUtils.cp_lr 'src/.', 'dest'
# FileUtils.cp_lr('src', 'dest') は dest ディレクトリが存在すれば dest/src を作成しますが、この例はしません。
```
#@until 3.2
### module_function def ln_s(src, dest, force: nil, noop: nil, verbose: nil)    -> ()
### module_function def symlink(src, dest, force: nil, noop: nil, verbose: nil) -> ()
#@end
#@since 3.2
### module_function def ln_s(src, dest, force: nil, relative: false, target_directory: true, noop: nil, verbose: nil)    -> ()
### module_function def symlink(src, dest, force: nil, relative: false, target_directory: true, noop: nil, verbose: nil) -> ()
#@end

src へのシンボリックリンク dest を作成します。

src が一つの場合、
dest がすでに存在しディレクトリであるときは dest/src を作成します。
dest がすでに存在しディレクトリでないならば例外 Errno::EEXIST が発生します。
ただし :force オプションを指定したときは dest を上書きします。

src が複数の場合、
src[0] へのシンボリックリンク dest/src[0]、src[1] への
シンボリックリンク dest/src[1] …を作成します。
dest がディレクトリでない場合は例外 Errno::ENOTDIR が発生します。

#@since 3.2
relative オプションを指定すると、dest からの相対パスによるシンボリックリンクを作成します。
[m:FileUtils?.ln_sr] を使うのと同じです。
#@end

- **param** `src` -- リンク元。一つの場合は文字列でも指定可能です。
           二つ以上指定する場合は配列で指定します。

- **param** `dest` -- リンク作成先のファイルかディレクトリです。

- **param** `force` -- 真を指定すると dest を上書きします。
#@since 3.2

- **param** `relative` -- 真を指定すると dest からの相対パスでシンボリックリンクを作成します。

- **param** `target_directory` -- dest をディレクトリとして扱うかどうかを指定します(真がデフォルトです)。
#@end

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **raise** `Errno::EEXIST` -- src が一つで dest がすでに存在しディレクトリでない場合に発生します。
- **raise** `Errno::ENOTDIR` -- src が複数で dest がディレクトリでない場合に発生します。


```ruby
require 'fileutils'
FileUtils.ln_s('/usr/bin/ruby', '/usr/local/bin/ruby')
FileUtils.ln_s('verylongsourcefilename.c', 'c', force: true)
FileUtils.ln_s(Dir.glob('bin/*.rb'), '/home/aamine/bin')
```

#@since 3.2
### module_function def ln_sr(src, dest, target_directory: true, force: nil, noop: nil, verbose: nil) -> ()

src へのシンボリックリンク dest を、dest からの相対パスで作成します。
ln_s(src, dest, relative: true) と同じです。

src が一つの場合、
dest がすでに存在しディレクトリであるときは dest/src を作成します。
dest がすでに存在しディレクトリでないならば例外 Errno::EEXIST が発生します。
ただし :force オプションを指定したときは dest を上書きします。

src が複数の場合、
src[0] へのシンボリックリンク dest/src[0]、src[1] への
シンボリックリンク dest/src[1] …を作成します。
dest がディレクトリでない場合は例外 Errno::ENOTDIR が発生します。

- **param** `src` -- リンク元。一つの場合は文字列でも指定可能です。
           二つ以上指定する場合は配列で指定します。

- **param** `dest` -- リンク作成先のファイルかディレクトリです。

- **param** `target_directory` -- dest をディレクトリとして扱うかどうかを指定します(真がデフォルトです)。

- **param** `force` -- 真を指定すると dest を上書きします。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **raise** `Errno::EEXIST` -- src が一つで dest がすでに存在しディレクトリでない場合に発生します。
- **raise** `Errno::ENOTDIR` -- src が複数で dest がディレクトリでない場合に発生します。


```ruby
require 'fileutils'
FileUtils.ln_sr('/usr/local/src/ruby/ruby.c', '/usr/local/bin/ruby.c')
# => /usr/local/bin/ruby.c は ../src/ruby/ruby.c へのシンボリックリンクになります。
```

- **SEE** [m:FileUtils?.ln_s]
#@end

### module_function def ln_sf(src, dest, noop: nil, verbose: nil) -> ()

src へのシンボリックリンク dest を作成します。

ln_s(src, dest, force: true) と同じです。

- **param** `src` -- リンク元。一つの場合は文字列でも指定可能です。
           二つ以上指定する場合は配列で指定します。

- **param** `dest` -- リンク作成先のファイルかディレクトリです。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **raise** `Errno::ENOTDIR` -- src が複数で dest がディレクトリでない場合に発生します。

- **SEE** [m:FileUtils?.ln_s]

### module_function def mkdir(dir, mode: nil, noop: nil, verbose: nil) -> ()

ディレクトリ dir を作成します。

- **param** `dir` -- 作成するディレクトリ。

- **param** `mode` -- パーミッションを8進数で指定します。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。


```ruby
require 'fileutils'
FileUtils.mkdir('test')
FileUtils.mkdir(%w( tmp data ))
FileUtils.mkdir('notexist', noop: true)  # does not create really
```

### module_function def mkdir_p(list, mode: nil, noop: nil, verbose: nil)  -> Array
### module_function def mkpath(list, mode: nil, noop: nil, verbose: nil)   -> Array
### module_function def makedirs(list, mode: nil, noop: nil, verbose: nil) -> Array

ディレクトリ dir とその親ディレクトリを全て作成します。

例えば、
```ruby
require 'fileutils'
FileUtils.mkdir_p('/usr/local/bin/ruby')
```

は以下の全ディレクトリを (なければ) 作成します。

  - /usr
  - /usr/local
  - /usr/local/bin
  - /usr/local/bin/ruby

- **param** `list` -- 作成するディレクトリ。一つの場合は文字列でも指定できます。
            二つ以上指定する場合は配列で指定します。

- **param** `mode` -- パーミッションを8進数で指定します。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **return** -- ディレクトリ名文字列の配列を返します。

### module_function def mv(src, dest, force: nil, noop: nil, verbose: nil, secure: nil)   -> ()
### module_function def move(src, dest, force: nil, noop: nil, verbose: nil, secure: nil) -> ()

ファイル src を dest に移動します。

src が一つの場合、
dest がすでに存在しディレクトリであるときは src を dest/src へ移動します。
dest がすでに存在しディレクトリでないときは src は dest を上書きします。

src が複数の場合、
src[0] を dest/src[0]、src[1] を dest/src[1] へ移動します。
dest がディレクトリでない場合は例外 Errno::ENOTDIR が発生します。

- **param** `src` -- 元のファイル。一つの場合は文字列でも指定可能です。
           二つ以上指定する場合は配列で指定します。

- **param** `dest` -- 移動先のファイル、またはディレクトリ。

- **param** `force` -- 真を指定すると処理中に発生した [c:StandardError] を無視します。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **param** `secure` -- 真を指定するとファイルの削除に [m:FileUtils?.remove_entry_secure] を使用します。

```ruby
require 'fileutils'
FileUtils.mv('badname.rb', 'goodname.rb')
FileUtils.mv('stuff.rb', 'lib/ruby', force: true)
FileUtils.mv(['junk.txt', 'dust.txt'], "#{ENV['HOME']}/.trash")
FileUtils.mv(Dir.glob('test*.rb'), 'test', noop: true, verbose: true)
```

### module_function def pwd   -> String
### module_function def getwd -> String

プロセスのカレントディレクトリを文字列で返します。

### module_function def rm(list, force: nil, noop: nil, verbose: nil)     -> ()
### module_function def remove(list, force: nil, noop: nil, verbose: nil) -> ()

list で指定された対象を消去します。

- **param** `list` -- 削除する対象。一つの場合は文字列も指定可能です。
            二つ以上指定する場合は配列で指定します。

- **param** `force` -- 真を指定すると処理中に発生した [c:StandardError] を無視します。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

```ruby
require 'fileutils'
FileUtils.rm('junk.txt')
FileUtils.rm(Dir.glob('*~'))
FileUtils.rm('NotExistFile', force: true)    # never raises exception
```

### module_function def rm_f(list, noop: nil, verbose: nil)        -> ()
### module_function def safe_unlink(list, noop: nil, verbose: nil) -> ()

FileUtils.rm(list, force: true) と同じです。

- **param** `list` -- 削除する対象。一つの場合は文字列も指定可能です。
            二つ以上指定する場合は配列で指定します。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **SEE** [m:FileUtils?.rm]

### module_function def rm_r(list, force: nil, noop: nil, verbose: nil, secure: nil) -> ()

ファイルまたはディレクトリ list を再帰的に消去します。

- **param** `list` -- 削除する対象。一つの場合は文字列も指定可能です。
            二つ以上指定する場合は配列で指定します。

- **param** `force` -- 真を指定すると処理中に発生した [c:StandardError] を無視します。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **param** `secure` -- 真を指定するとファイルの削除に [m:FileUtils?.remove_entry_secure] を使用します。

### 注意

このメソッドにはローカル脆弱性が存在します。
この脆弱性を回避するには :secure オプションを使用してください。
詳しくは [m:FileUtils?.remove_entry_secure] の項を参照してください。

```ruby
require 'fileutils'
FileUtils.rm_r(Dir.glob('/tmp/*'))
FileUtils.rm_r(Dir.glob('/tmp/*'), secure: true)
```

- **SEE** [m:FileUtils?.rm], [m:FileUtils?.remove_entry_secure]

### module_function def rm_rf(list, noop: nil, verbose: nil, secure: nil)  -> ()
### module_function def rmtree(list, noop: nil, verbose: nil, secure: nil) -> ()

ファイルまたはディレクトリ list を再帰的に消去します。

rm_r(list, force: true) と同じです。

- **param** `list` -- 削除する対象。一つの場合は文字列も指定可能です。
            二つ以上指定する場合は配列で指定します。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **param** `secure` -- 真を指定するとファイルの削除に [m:FileUtils?.remove_entry_secure] を使用します。

### 注意

このメソッドにはローカル脆弱性が存在します。
この脆弱性を回避するには :secure オプションを使用してください。
詳しくは [m:FileUtils?.remove_entry_secure] の項を参照してください。

- **SEE** [m:FileUtils?.rm], [m:FileUtils?.rm_r], [m:FileUtils?.remove_entry_secure]

### module_function def rmdir(dir, parents: nil, noop: nil, verbose: nil) -> ()

ディレクトリ dir を削除します。

ディレクトリにファイルが残っていた場合は削除に失敗します。

- **param** `dir` -- 削除するディレクトリを指定します。一つの場合は文字列でも指定可能です。
           二つ以上指定する場合は配列で指定します。

- **param** `parents` -- 真を指定すると指定したディレクトリの親ディレクトリも含めて削除します。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

```ruby
require 'fileutils'
FileUtils.rmdir('somedir')
FileUtils.rmdir(%w(somedir anydir otherdir))
# 実際にはディレクトリの削除は行わずにメッセージ出力のみ
FileUtils.rmdir('somedir', verbose: true, noop: true)
```

### module_function def remove_entry(path, force = false) -> ()

ファイル path を削除します。path がディレクトリなら再帰的に削除します。

このメソッドにはローカル脆弱性が存在します。
詳しくは [m:FileUtils?.remove_entry_secure] の項を参照してください。

- **param** `path` -- 削除するパス。

- **param** `force` -- 真のときは削除中に発生した [c:StandardError] を無視します。

```ruby
require 'fileutils'
FileUtils.remove_entry '/tmp/ruby.tmp.08883'
```

- **SEE** [m:FileUtils?.remove_entry_secure]


### module_function def remove_entry_secure(path, force = false) -> ()

ファイル path を削除します。path がディレクトリなら再帰的に削除します。

[m:FileUtils?.rm_r] および [m:FileUtils?.remove_entry] には
TOCTTOU (time-of-check to time-of-use)脆弱性が存在します。
このメソッドはそれを防ぐために新設されました。
[m:FileUtils?.rm_r] および [m:FileUtils?.remove_entry] は以下の条件が
満たされるときにはセキュリティホールになりえます。

  - 親ディレクトリが全ユーザから書き込み可能 (/tmp を含む)
  - path 以下のいずれかのディレクトリが全ユーザから書き込み可能
  - システムがシンボリックリンクを持つ

この脆弱性を防ぐため、remove_entry_secure は削除前に path 以下の
ディレクトリのオーナーとパーミッションを変更し、上記の条件を回避します。
ただし remove_entry_secure は親ディレクトリが以下の条件を満たすことを
仮定しています。

  - UNIX システムおよびそれに類する環境では、sticky ビットが立っていること。
  - 全ユーザが書き込み可能であるのは、直接の親ディレクトリのみであること。
    例えば、/var/tmp のパーミッションが 1777 であるのは問題ありませんが、
    その場合 / や /var が全ユーザから書き込み可能であってはなりません。

この条件が満たされない場合 remove_entry_secure は安全ではありません。

- **param** `path` -- 削除するパス。

- **param** `force` -- 真のときは削除中に発生した [c:StandardError] を無視します。


### module_function def remove_file(path, force = false) -> ()

ファイル path を削除します。

- **param** `path` -- 削除するファイル。

- **param** `force` -- 真のときは削除中に発生した [c:StandardError] を無視します。

### module_function def remove_dir(path, force = false) -> ()

ディレクトリ path を削除します。

- **param** `path` -- 削除するディレクトリ。

- **param** `force` -- 真のときは削除中に発生した [c:StandardError] を無視します。

### module_function def touch(list, noop: nil, verbose: nil, mtime: nil, nocreate: nil) -> ()

list で指定されたファイルの最終変更時刻 (mtime) と
アクセス時刻 (atime) を変更します。

list で指定されたファイルが存在しない場合は空のファイルを作成します。

- **param** `list` -- 対象のファイル。一つの場合は文字列も指定可能です。
            二つ以上指定する場合は配列で指定します。

- **param** `noop` -- 真を指定すると実際の処理は行いません。

- **param** `verbose` -- 真を指定すると詳細を出力します。

- **param** `mtime` -- 時刻を [c:Time] か、起算時からの経過秒数を数値で指定します。

- **param** `nocreate` -- 真を指定するとファイルを作成しません。

```ruby
require 'fileutils'
FileUtils.touch('timestamp')
FileUtils.touch('timestamp', mtime: Time.now)
FileUtils.touch(Dir.glob('*.c'))
```

### module_function def uptodate?(newer, older_list) -> bool

newer が、older_list に含まれるすべてのファイルより新しいとき真。
存在しないファイルは無限に古いとみなされます。

- **param** `newer` -- ファイルを一つ指定します。

- **param** `older_list` -- ファイル名の配列を指定します。

```ruby
require 'fileutils'
FileUtils.uptodate?('hello.o', ['hello.c', 'hello.h']) or system('make')
```

## Singleton Methods
### def collect_method(opt) -> Array

与えられたオプションを持つメソッド名の配列を返します。

- **param** `opt` -- オプション名をシンボルで指定します。

```ruby
require 'fileutils'
p FileUtils.collect_method(:preserve) # => ["cp", "cp_r", "copy", "install"]
```

### def commands -> Array

何らかのオプションを持つメソッド名の配列を返します。

```ruby
require 'fileutils'
p FileUtils.commands  # => ["chmod", "cp", "cp_r", "install", ...]
```

### def have_option?(mid, opt) -> bool

mid というメソッドが opt というオプションを持つ場合、真を返します。
そうでない場合は、偽を返します。

- **param** `mid` -- メソッド名を指定します。

- **param** `opt` -- オプション名を指定します。

### def options -> Array

オプション名の配列を返します。

```ruby
require 'fileutils'
FileUtils.options
# => ["noop", "verbose", "force", "mode", "parents", "owner", "group", "preserve", "dereference_root", "remove_destination", "secure", "mtime", "nocreate"]
```

### def options_of(mid) -> Array

与えられたメソッド名で使用可能なオプション名の配列を返します。

- **param** `mid` -- メソッド名を指定します。

```ruby
require 'fileutils'
p FileUtils.options_of(:rm)  # => ["noop", "verbose", "force"]
```

#@# --- private_module_function(name) -> self
#@# nodoc
#@# name で指定されたメソッドをモジュール関数にします。
#@# また、可視性を private にします。
#@#
#@# @see [[m:Module#module_function]], [[m:Module#private_class_method]]

## Constants

### const METHODS -> Array

このモジュールで定義されている公開メソッドの配列を返します。

### const OPT_TABLE -> Hash

内部で使用します。


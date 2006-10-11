#@since 1.8.0

= module FileUtils

基本的なファイル操作を集めたモジュールです。

== Module Functions

--- cd(dir, options = {})
--- cd(dir, options = {}) {|dir| .... }

プロセスのカレントディレクトリを dir に変更します。
ブロックとともに呼び出された時はブロック終了後に
元のディレクトリに戻ります。

options には :verbose が指定できます。

#@since 1.8.3
:noop オプションは廃止されました。
#@end

例:

  FileUtils.cd('/', {:verbose => true})   # chdir and report it

--- chmod(mode, list, options = {})

ファイル list[0], list[1], …… のパーミッションを mode に変更します。

options には :noop と :verbose が指定可能です。

例:

  FileUtils.chmod(0644, 'my.rb', 'your.rb')
  FileUtils.chmod(0755, 'somecommand')
  FileUtils.chmod(0755, '/usr/bin/ruby', {:verbose => true})

#@since 1.8.3
--- chmod_R(mode, list, options = {})

ファイル list[0], list[1], …… のパーミッションを再帰的に mode へ変更します。

options には :noop と :verbose が指定可能です。

例:

  FileUtils.chmod_R(0700, '/tmp/removing')
#@end

#@since 1.8.3
--- chown(user, group, list, options = {})

ファイル list[0], list[1], ... の
所有ユーザと所有グループを user と group に変更します。
user, group に nil または -1 を渡すとその項目は変更しません。

options には :noop と :verbose が指定可能です。

例:

  FileUtils.chown 'root', 'staff', '/usr/local/bin/ruby'
  FileUtils.chown nil, 'bin', Dir.glob('/usr/bin/*'), :verbose => true
#@end

#@since 1.8.3
--- chown_R(user, group, list, options = {})

list[0], list[1], ... 以下のファイルの所有ユーザと所有グループを
user と group へ再帰的に変更します。
user, group に nil または -1 を渡すとその項目は変更しません。

options には :noop と :verbose が指定可能です。

例:

  FileUtils.chown 'root', 'staff', '/usr/local/bin/ruby'
  FileUtils.chown nil, 'bin', Dir.glob('/usr/bin/*'), :verbose => true
  
  FileUtils.chown_R 'www', 'www', '/var/www/htdocs'
  FileUtils.chown_R 'cvs', 'cvs', '/var/cvs', :verbose => true
#@end

--- cmp(file_a, file_b)
--- compare_file(file_a, file_b)
--- identical?(file_a, file_b)

ファイル a と b の内容が同じなら真を返します。

例:

  FileUtils.cmp('somefile', 'somefile')  #=> true
  FileUtils.cmp('/bin/cp', '/bin/mv')    #=> maybe false.

--- compare_stream(a, b)

[[c:IO]] オブジェクト a と b の内容が同じなら真を返します。

#@since 1.8.3
--- copy_entry(src, dest, preserve = false, dereference_root = false)

ファイル src を dest にコピーします。src が普通のファイルでない場合は
その種別まで含めて完全にコピーします。src がディレクトリの場合はその
中身を再帰的にコピーします。

preserve が真のときは更新時刻と、
可能なら所有ユーザ・所有グループもコピーします。

dereference_root が真のときは src についてだけシンボリックリンクの指す
内容をコピーします。偽の場合はシンボリックリンク自体をコピーします。
#@end

#@since 1.8.3
--- copy_file(src, dest, preserve = false, dereference_root = true)

ファイル src の内容を dest にコピーします。

preserve が真のときは更新時刻と、
可能なら所有ユーザ・所有グループもコピーします。

dereference_root が真のときは src についてだけシンボリックリンクの指す
内容をコピーします。偽の場合はシンボリックリンク自体をコピーします。
#@end

#@since 1.8.3
--- copy_stream(src, dest)

src を dest にコピーします。
src には read メソッド、dest には write メソッドが必要です。
#@end

--- cp(src, dest, options = {})
--- copy(src, dest, options = {})

ファイル src を dest にコピーします。dest がディレクトリなら
dest/src にコピーします。dest が既に存在ししかもディレクトリで
ないときは上書きします。

options には :preserve, :noop, :verbose が指定できます。

例:

  FileUtils.cp 'eval.c', 'eval.c.org'

--- cp(list, dir, options = {})

file1 を dir/file1 にコピー、file2 を dir/file2 にコピー、
というように、ディレクトリ dir の中にファイル file1、file2 …を
同じ名前でコピーします。dir がディレクトリでない場合は例外
Errno::ENOTDIR が発生します。

options には :preserve, :noop, :verbose が指定できます。

例:

  FileUtils.cp('cgi.rb', 'complex.rb', 'date.rb', '/usr/lib/ruby/1.6')
  FileUtils.cp(%w(cgi.rb complex.rb date.rb), '/usr/lib/ruby/1.6', {:verbose => true})

--- cp_r(src, dest, options = {})

src を dest にコピーします。src がディレクトリであったら再帰的に
コピーします。その際 dest がディレクトリなら dest/src にコピーします。

options には :preserve, :noop, :verbose が指定できます。

例:

  # installing ruby library "mylib" under the site_ruby
  FileUtils.rm_r(site_ruby + '/mylib', {:force => true})
  FileUtils.cp_r('lib/', site_ruby + '/mylib')

--- cp_r(list, dir, options = {})

list[0]、list[1], list[2], ... をディレクトリ dir の中にコピーします。
list[n] がディレクトリなら再帰的にコピーします。

options には :preserve, :noop, :verbose を指定できます。

例:

  FileUtils.cp_r(%w(mail.rb field.rb debug/), site_ruby + '/tmail')
  FileUtils.cp_r(Dir.glob('*.rb'), '/home/taro/lib/ruby',
                 {:noop => true, :verbose => true})

--- install(src, dest, options = {})

src と dest の内容が違うときだけ src を dest にコピーします。

options には :noop, :verbose, :mode を指定できます。
mode オプションを指定した場合はコピー先ファイルのパーミッションを
options[:mode] の値に設定します。

例:

  FileUtils.install('ruby', '/usr/local/bin/ruby', {:mode => 0755, :verbose => true})
  FileUtils.install('lib.rb', '/usr/local/lib/ruby/site_ruby'
                            , {:verbose => true})

--- ln(src, dest, options = {})
--- link(src, dest, options = {})

src へのハードリンク dest を作成します。
dest がすでに存在しディレクトリであるときは dest/src を作成します。
dest がすでに存在しディレクトリでないならば例外 Errno::ENOTDIR が発生します。
ただし :force オプションを指定したときは new を上書きします。

options には :force, :noop, :verbose が指定できます。

例:

  FileUtils.ln('gcc', 'cc', {:verbose => true})
  FileUtils.ln('/usr/bin/emacs21', '/usr/bin/emacs')

--- ln(list, destdir, options = {})
--- link(list, destdir, options = {})

list[0] へのハードリンク destdir/list[0]、list[1] への
ハードリンク destdir/list[1] …を作成します。
destdir がディレクトリでない場合は例外 Errno::ENOTDIR が発生します。

options には :force, :noop, :verbose が指定できます。

例:

  FileUtils.cd('/bin')
  FileUtils.ln(%w(cp mv mkdir), '/usr/bin')

--- ln_s(src, dest, options = {})
--- symlink(src, dest, options = {})

src へのシンボリックリンク dest を作成します。
dest がすでに存在しディレクトリであるときは dest/src を作成します。
dest がすでに存在しディレクトリでないならば例外 Errno::ENOTDIR が発生します。
ただし :force オプションを指定したときは dest を上書きします。

options には :force, :noop, :verbose を指定できます。

例:

  FileUtils.ln_s('/usr/bin/ruby', '/usr/local/bin/ruby')
  FileUtils.ln_s('verylongsourcefilename.c', 'c', {:force => true})

--- ln_s(list, destdir, options = {})
--- symlink(list, destdir, options = {})

list[0]、list[1] …へのシンボリックリンク dir/list[0], dir/list[1] …を
作成します。destdir がディレクトリでない場合は例外 Errno::ENOTDIR が
発生します。
ただし :force オプションを指定したときは dest を上書きします。

options には :noop, :verbose を指定できます。

例:

  FileUtils.ln_s(Dir.glob('bin/*.rb'), '/home/aamine/bin')

--- ln_sf(src, dest, options = {})

ln_s(src, dest, :force => true) と同じです。

--- mkdir(dir, options = {})

ディレクトリ dir を作成します。

options には :noop, :verbose が指定できます。

例:

  FileUtils.mkdir('test')
  FileUtils.mkdir(%w( tmp data ))
  FileUtils.mkdir('notexist', {:noop => true})  # does not create really

--- mkdir_p(dir, options = {})
--- mkpath(dir, options = {})
--- makedirs(dir, options = {})

ディレクトリ dir とその親ディレクトリを全て作成します。
例えば、

  FileUtils.mkdir_p('/usr/local/lib/ruby')

は以下の全ディレクトリを (なければ) 作成します。

  * /usr
  * /usr/local
  * /usr/local/bin
  * /usr/local/bin/ruby

options には :noop, :verbose が指定できます。

--- mv(src, dest, options = {})
--- move(src, dest, options = {})

ファイル src を dest に移動します。
dest がディレクトリなら dest/src に移動します。

options には :noop と :verbose が指定できます。

例:

  FileUtils.mv('badname.rb', 'goodname.rb')
  FileUtils.mv('stuff.rb', 'lib/ruby', {:force => true})

--- mv(list, dir, options = {})
--- move(list, dir, options = {})

list[0], list[1], ... をディレクトリ dir の中に移動します。
パーティションをまたいで移動するときはコピーします。

options には :noop と :verbose が指定できます。

例:

  FileUtils.mv(['junk.txt', 'dust.txt'], "#{ENV['HOME']}/.trash")
  FileUtils.mv(Dir.glob('test*.rb'), 'test',
               {:noop => true, :verbose => true} )

--- pwd
--- getwd

プロセスのカレントディレクトリを文字列で返します。

--- rm(list, options = {})
--- remove(list, options = {})

list[0], list[1], ... を消去します。:force オプションが
セットされた場合は作業中すべての StandardError を無視します。

options には :force, :noop, :verbose が指定できます。

例:

  FileUtils.rm('junk.txt')
  FileUtils.rm(Dir.glob('*~'))
  FileUtils.rm('NotExistFile', {:force => true})    # never raises exception

--- rm_f(list, options = {})
--- safe_unlink(list, options = {})

FileUtils.rm(list, :force => true) と同じです。

--- rm_r(list, options = {})

ファイルまたはディレクトリ list[0], list[1], ... を再帰的に消去します。
force オプションを渡した場合は削除中に発生した StandardError を無視します。

options には :force, :noop, :verbose を指定できます。

例:

  FileUtils.rm_r(Dir.glob('/tmp/*'))

このメソッドにはローカル脆弱性が存在します。
詳しくは remove_entry_secure の項を参照してください。

--- rm_rf(list, options = {})
--- rmtree(list, options = {})

rm_r(list, {:force => true}) と同じです。

--- rmdir(dir, options = {})

ディレクトリ dir を削除します。

options には :noop, :verbose が指定できます。

例:

  FileUtils.rmdir('somedir')
  FileUtils.rmdir(%w(somedir anydir otherdir))
  # does not remove directory really, outputing message.
  FileUtils.rmdir('somedir', {:verbose => true, :noop => true})

#@if (version >= "1.8.3")
--- remove_entry(path, force = false)

((<ruby 1.8.3 feature>))

ファイル path を削除します。path がディレクトリなら再帰的に削除します。

force が真のときは削除中に発生した StandardError を無視します。

例:

  FileUtils.remove_entry '/tmp/ruby.tmp.08883'

このメソッドにはローカル脆弱性が存在します。
詳しくは remove_entry_secure の項を参照してください。
#@end

--- remove_entry_secure(path, force = false)

ファイル path を削除します。path がディレクトリなら再帰的に削除します。

force が真のときは削除中に発生した StandardError を無視します。

rm_r および remove_entry には TOCTTOU (time-of-check to time-of-use)
脆弱性が存在します。このメソッドはそれを防ぐために新設されました。
rm_r および remove_entry は以下の条件が満たされるときにはセキュリティ
ホールになりえます。

  * 親ディレクトリが全ユーザから書き込み可能 (/tmp を含む)
  * path 以下のいずれかのディレクトリが全ユーザから書き込み可能
  * システムがシンボリックリンクを持つ

この脆弱性を防ぐため、remove_entry_secure は削除前に path 以下の
ディレクトリのオーナーとパーミッションを変更し、上記の条件を回避します。
ただし remove_entry_secure は親ディレクトリが以下の条件を満たすことを
仮定しています。

  * UNIX システムおよびそれに類する環境では、sticky ビットが立っていること。
  * 全ユーザが書き込み可能であるのは、直接の親ディレクトリのみであること。
    例えば、/var/tmp のパーミッションが 1777 であるのは問題ありませんが、
    その場合 / や /var が全ユーザから書き込み可能であってはなりません。

この条件が満たされない場合 remove_entry_secure は安全ではありません。

--- remove_file(path, force = false)

ファイル path を削除します。

force が真のときは削除中に発生した StandardError を無視します。

--- touch(list, options = {})

list[0], list[1], ... の最終変更時刻 (mtime) と
アクセス時刻 (atime) を変更します。
list[n] が存在しない場合は空のファイルを作成します。

option には :noop と :verbose が指定できます。

例:

  FileUtils.touch('timestamp')
  FileUtils.touch(Dir.glob('*.c'))

--- uptodate?(newer, older_list)

newer が、older_list に含まれるすべてのファイルより新しいとき真。
存在しないファイルは無限に古いとみなされます。

例:

  FileUtils.uptodate?('hello.o', ['hello.c', 'hello.h']) or system('make')



= module FileUtils::Verbose

FileUtils と同じメソッドが定義されており全く同じ動作をしますが、
しようとしていることを実行前に表示します。



= module FileUtils::NoWrite

FileUtils と同じメソッドが定義されていますが、
実際にファイルを変更する操作は実行しません。



= module FileUtils::DryRun

FileUtils と同じメソッドが定義されていますが、
実際にファイルを変更する操作は実行せず、操作を表示します。
#@end

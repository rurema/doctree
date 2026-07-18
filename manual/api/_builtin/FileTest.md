---
library: _builtin
---
# module FileTest

ファイルの検査関数を集めたモジュールです。

### 注意

FileTest で定義された各メソッドは、システムコールに失敗しても例外を発生させません。
真を返した時のみ、返り値は意味をもちます。
例えば、
```ruby
File.exist?('/root/.bashrc')
```
が false を返しても、それはファイルが存在しないことを保証しません。


## Module Functions

### module_function def blockdev?(file)    -> bool

ファイルがブロックスペシャルファイルである時に真を返します。
そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **raise** `IOError` -- 指定された IO オブジェクト file が既に close されていた場合に発生します。

```ruby title="例"
Dir.glob("/dev/*") { |file|
  puts file if FileTest.blockdev?(file)
}
# /dev/disk0
# /dev/disk0s3
# ...
```

### module_function def chardev?(file)    -> bool

ファイルがキャラクタスペシャルファイルの時に真を返します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **raise** `IOError` -- 指定された IO オブジェクト file が既に close されていた場合に発生します。

```ruby title="例"
Dir.glob("/dev/*") { |file|
  puts file if FileTest.chardev?(file)
}
# /dev/console
# /dev/tty
# ...
```

### module_function def executable?(file)    -> bool

ファイルがカレントプロセスにより実行できる時に真を返しま
す。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列を指定します。

```ruby title="例"
p FileTest.executable?('/bin') # => true
p FileTest.executable?('/bin/bash') # => true
```

### module_function def executable_real?(file)    -> bool

ファイルがカレントプロセスの実ユーザか実グループで実行できる時に真を返します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列を指定します。

```ruby title="例"
IO.write("empty.txt", "")
File.chmod(0744, "empty.txt")
p FileTest.executable_real?("empty.txt")    # => true
File.chmod(0644, "empty.txt")
p FileTest.executable_real?("empty.txt")    # => false
```

### module_function def exist?(file)    -> bool

ファイルが存在する時に真を返します。そうでない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **raise** `IOError` -- 指定された IO オブジェクト file が既に close されていた場合に発生します。

```ruby title="例"
p FileTest.exist?('/etc/passwd') # => true
p FileTest.exist?('/etc') # => true
p FileTest.exist?('/etc/no_such_file') # => false
p FileTest.exist?('/etc/no_such_directory') # => false
```

#@until 3.2
### module_function def exists?(file)    -> bool

このメソッドは Ruby 2.1 から deprecated です。[m:FileTest?.exist?] を使用してください。
#@end
### module_function def grpowned?(file)    -> bool

ファイルのグループ ID がカレントプロセスの実効グループ ID と等しい時に真を返
します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **raise** `IOError` -- 指定された IO オブジェクト file が既に close されていた場合に発生します。

```ruby title="例"
IO.write("testfile", "")
File.chown(-1, Process.gid, "testfile")
p FileTest.grpowned?("testfile")    # => true
File.chown(-1, Process.gid + 10, "testfile")
p FileTest.grpowned?("testfile")    # => false
```

### module_function def directory?(file)    -> bool

ファイルがディレクトリの時に真を返します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **raise** `IOError` -- 指定された IO オブジェクト file が既に close されていた場合に発生します。

```ruby title="例"
p FileTest.directory?('/etc') # => true
p FileTest.directory?('/etc/passwd') # => false

f = File.open('/etc')
p FileTest.directory?(f) # => true
f.close
FileTest.directory?(f) # ~> IOError: closed stream
```

### module_function def file?(file)    -> bool

ファイルが通常ファイルである時に真を返します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **raise** `IOError` -- 指定された IO オブジェクト file が既に close されていた場合に発生します。

```ruby title="例"
p FileTest.file?('/bin/bash') # => true
p FileTest.file?('/bin') # => false
p FileTest.file?('/no_such_file') # => false
```

### module_function def identical?(file1, file2)    -> bool

file1 と file2 が同じファイルを指している時に真を返します。
そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

ruby 1.8.3 以前では[m:Kernel?.test](?-, file1, file2)を使ってください。

```ruby
open("a", "w") {}
p File.identical?("a", "a")      #=> true
p File.identical?("a", "./a")    #=> true
File.link("a", "b")
p File.identical?("a", "b")      #=> true
File.symlink("a", "c")
p File.identical?("a", "c")      #=> true
open("d", "w") {}
p File.identical?("a", "d")      #=> false
```

- **param** `file1` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **param** `file2` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **raise** `IOError` -- 指定された IO オブジェクト file1, file2 が既に close されていた場合に発生します。

### module_function def pipe?(file)    -> bool

指定したファイルがパイプである時に真を返します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **raise** `IOError` -- 指定された IO オブジェクト file が既に close されていた場合に発生します。

```ruby title="例"
r, w = IO.pipe
p FileTest.pipe?(r) # => true
p FileTest.pipe?(w) # => true
```

### module_function def socket?(file)    -> bool

ファイルがソケットである時に真を返します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **raise** `IOError` -- 指定された IO オブジェクト file が既に close されていた場合に発生します。

```ruby title="例"
require "socket"

IO.write("testfile", "test")
p FileTest.socket?("testfile")                                           # => false
p Socket.unix_server_socket('testsock') { p FileTest.socket?('testsock') } # => true
```

### module_function def owned?(file)    -> bool

ファイルのユーザがカレントプロセスの実効ユーザと等しい時に真を返します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **raise** `IOError` -- 指定された IO オブジェクト file が既に close されていた場合に発生します。

```ruby title="例"
IO.write("testfile", "")
File.chown(Process.uid, -1, "testfile")
p FileTest.owned?("testfile")    # => true
File.chown(501, -1, "testfile")
p FileTest.owned?("testfile")    # => false
```

### module_function def readable?(file)    -> bool

ファイルがカレントプロセスにより読み込み可能な時に真を返します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列を指定します。

```ruby title="例"
IO.write("testfile", "")
File.chmod(0644, "testfile")
p FileTest.readable?("testfile")    # => true
File.chmod(0200, "testfile")
p FileTest.readable?("testfile")    # => false
```

### module_function def readable_real?(file)    -> bool

ファイルがカレントプロセスの実ユーザか実グループによって読み込み可能な時に真を
返します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列を指定します。

#@#noexample FileTest.#readable? を参照

- **SEE** [m:FileTest?.readable?]

### module_function def setuid?(file)    -> bool

ファイルが [man:setuid(2)] されている時に真を返
します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **raise** `IOError` -- 指定された IO オブジェクト file が既に close されていた場合に発生します。

```ruby title="例"
require 'fileutils'
IO.write("testfile", "")
FileUtils.chmod("u+s", "testfile")
p FileTest.setuid?("testfile")    # => true
FileUtils.chmod("u-s", "testfile")
p FileTest.setuid?("testfile")    # => false
```

### module_function def setgid?(file)    -> bool

ファイルが [man:setgid(2)] されている時に真を返
します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

```ruby title="例"
require 'fileutils'
IO.write("testfile", "")
FileUtils.chmod("g+s", "testfile")
p FileTest.setgid?("testfile")    # => true
FileUtils.chmod("g-s", "testfile")
p FileTest.setgid?("testfile")    # => false
```

### module_function def size(file)    -> Integer

ファイルのサイズを返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **raise** `Errno::EXXX` -- file が存在しない場合、あるいはシステムコールに失敗した場合に発生します。

- **raise** `IOError` -- 指定された IO オブジェクト file が既に close されていた場合に発生します。

- **SEE** [m:FileTest?.size?], [m:FileTest?.zero?]

```ruby title="例"
p FileTest.size('/etc/passwd') # => 5925
```

### module_function def size?(file)    -> Integer | nil

ファイルのサイズを返します。ファイルが存在しない時や
ファイルのサイズが0の時には nil を返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **raise** `IOError` -- 指定された IO オブジェクト file が既に close されていた場合に発生します。

```ruby title="例"
IO.write("testfile", "test")
p FileTest.size?("testfile")    # => 4
File.delete("testfile")
p FileTest.size?("testfile")    # => nil
```

- **SEE** [m:FileTest?.size], [m:FileTest?.zero?] 

### module_function def sticky?(file)    -> bool

ファイルの sticky ビット([man:chmod(2)] 参照)が
立っている時に真を返します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

```ruby title="例"
require 'fileutils'
IO.write("testfile", "")
FileUtils.chmod("o+t", "testfile")
p FileTest.sticky?("testfile")    # => true
FileUtils.chmod("o-t", "testfile")
p FileTest.sticky?("testfile")    # => false
```

### module_function def symlink?(file)    -> bool

ファイルがシンボリックリンクである時に真を返します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列を指定します。

```ruby title="例"
IO.write("testfile", "test")
p FileTest.symlink?("testfile")    # => false
File.symlink("testfile", "testlink")
p FileTest.symlink?("testlink")    # => true
```

### module_function def writable?(file)    -> bool

ファイルがカレントプロセスにより書き込み可能である時に真を返します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列を指定します。

```ruby title="例"
IO.write("testfile", "test")
File.chmod(0600, "testfile")
p FileTest.writable?("testfile")    # => true
File.chmod(0400, "testfile")
p FileTest.writable?("testfile")    # => false
```

### module_function def writable_real?(file)    -> bool

ファイルがカレントプロセスの実ユーザか実グループによって書き込み可能である時に真
を返します。そうでない場合、ファイルが存在しない場合、あるいはシステムコールに失敗した場合などには false を返します。

- **param** `file` -- ファイル名を表す文字列を指定します。

#@#noexample FileTest.#writable? を参照

- **SEE** [m:FileTest?.writable?]

### module_function def zero?(file)    -> bool
### module_function def empty?(file)   -> bool

ファイルが存在して、そのサイズが 0 である時に真を返します。
そうでない場合、あるいはシステムコールに失敗した場合には false を返します。

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **raise** `IOError` -- 指定された IO オブジェクト file が既に close されていた場合に発生します。

```ruby title="例:"
IO.write("zero.txt", "")
p FileTest.zero?("zero.txt")    # => true
IO.write("nonzero.txt", "1")
p FileTest.zero?("nonzero.txt")  # => false
```

- **SEE** [m:FileTest?.size], [m:FileTest?.size?]

### module_function def world_readable?(path)    -> Integer | nil

path が全てのユーザから読めるならばそのファイルのパーミッションを表す
整数を返します。そうでない場合は nil を返します。

整数の意味はプラットフォームに依存します。

- **param** `path` -- パスを表す文字列を指定します。

```ruby
m = FileTest.world_readable?("/etc/passwd")
p "%o" % m                             # => "644"
```

### module_function def world_writable?(path)    -> bool

path が全てのユーザから書き込めるならば、そのファイルのパーミッションを表す
整数を返します。そうでない場合は nil を返します。

整数の意味はプラットフォームに依存します。

- **param** `path` -- パスを表す文字列を指定します。

```ruby
m = FileTest.world_writable?("/tmp")
p "%o" % m                             #=> "777"
```

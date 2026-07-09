---
type: library
until: "2.7.0"
---
# class Shell::SystemCommand < Shell::Filter

## Singleton Methods

### def new(sh, command, *opts)
#@todo

- **param** `sh` --

- **param** `command` --

- **param** `opts` --

## Instance Methods

### def active? -> bool
#@todo

### def command -> String
### def name    -> String
#@todo

コマンド名を返します。

### def each(rs = nil){|line| ... }
#@todo

- **param** `rs` --

### def flush -> ()
#@todo

### def input=(inp)
#@todo

### def kill(signal) -> Integer

自身のプロセスにシグナルを送ります。

- **param** `signal` -- シグナルを整数かその名前の文字列で指定します。
              負の値を持つシグナル(あるいはシグナル名の前に-)を指定すると、
              プロセスではなくプロセスグループにシグナルを送ります。 

- **SEE** [m:Process?.kill]

### def notify(*opts) -> String
### def notify(*opts){|message| ... } -> String
#@todo

- **param** `opts` --

- **SEE** [m:Shell#notify]

### def start -> ()
#@todo

### def start_export
#@todo

### def start_import -> ()
#@todo

### def super_each -> ()
#@todo

[m:Shell::Filter#each] です。

### def terminate -> ()
#@todo

### def wait? -> bool
#@todo


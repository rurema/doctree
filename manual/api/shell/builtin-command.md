---
type: library
until: "2.7.0"
---
[c:Shell] で使用するビルトインコマンドを定義しているライブラリです。

# class Shell::BuiltInCommand < Shell::Filter

クラスとして実装されている全てのビルトインコマンドのスーパークラスです。

## Instance Methods

### def active? -> true
#@todo

### def wait?   -> false
#@todo

# class Shell::AppendFile < Shell::AppendIO

## Singleton Methods

### def new(sh, filename)
#@todo

## Instance Methods

### def input=(filter)
#@todo

# class Shell::AppendIO < Shell::BuiltInCommand

## Singleton Methods

### def new(sh, filename)
#@todo

## Instance Methods

### def input=(filter)
#@todo


# class Shell::Cat < Shell::BuiltInCommand

## Singleton Methods

### def new(sh, *filenames)
#@todo

## Instance Methods

### def each(rs = nil){|line| ... }
#@todo

# class Shell::Concat < Shell::BuiltInCommand

## Singleton Methods

### def new(sh, *jobs)
#@todo

## Instance Methods

### def each(rs = nil){|job| ... }
#@todo


# class Shell::Echo < Shell::BuiltInCommand


## Singleton Methods

### def new(sh, *strings)
#@todo

## Instance Methods

### def each(rs = nil){|str| ... }
#@todo


# class Shell::Glob < Shell::BuiltInCommand

## Singleton Methods

### def new(sh, pattern)
#@todo

## Instance Methods

### def each(rs = nil){|file| ... }
#@todo

# class Shell::Tee < Shell::BuiltInCommand

## Singleton Methods

### def new(sh, filename)
#@todo

## Instance Methods

### def each(rs = nil){|line| ... }
#@todo


# class Shell::Void < Shell::BuiltInCommand

何もしないコマンドです。

## Singleton Methods

### def new(sh, *opts)

## Instance Methods

### def each(rs = nil){ ... } -> nil

何もしません。


---
type: library
category: Development
---
ベンチマークを取るためのライブラリです。

# module Benchmark

ベンチマークを取るためのモジュールです。

## Module Functions

### module_function def measure(label = "") { ... }  -> Benchmark::Tms

与えられたブロックを実行して、経過した時間を [m:Process?.times] で計り、
[c:Benchmark::Tms] オブジェクトを生成して返します。

Benchmark::Tms オブジェクトには to_s が定義されているので、
基本的には以下のように使います。

```ruby
require 'benchmark'

puts Benchmark::CAPTION
puts Benchmark.measure { "a"*1_000_000 }

#=>
#
#     user     system      total        real
# 1.166667   0.050000   1.216667 (  0.571355)
```

### module_function def realtime { ... } -> Float

与えられたブロックを評価して実行時間を計測して返します。
返り値の単位は、秒です。

```ruby
require 'benchmark'
puts Benchmark.realtime { [0] * (10**8) } # => 1.0929416846483946
```

### module_function def bm(label_width = 0, *labels) {|rep| ... } -> [Benchmark::Tms]

[m:Benchmark?.benchmark] メソッドの引数を簡略化したものです。

[m:Benchmark?.benchmark] メソッドと同様に働きます。

- **param** `label_width` -- ラベルの幅を指定します。
- **param** `labels` --     ブロックが [c:Benchmark::Tms] オブジェクトの配列を返す場合に指定します。

```ruby
require 'benchmark'

n = 50000
Benchmark.bm do |x|
  x.report { for i in 1..n; a = "1"; end }
  x.report { n.times do   ; a = "1"; end }
  x.report { 1.upto(n) do ; a = "1"; end }
end

#=>
#
#     user     system      total        real
# 1.033333   0.016667   1.016667 (  0.492106)
# 1.483333   0.000000   1.483333 (  0.694605)
# 1.516667   0.000000   1.516667 (  0.711077)
```

以下のようにも書けます。

```ruby
require 'benchmark'

n = 50000
Benchmark.bm(7) do |x|
  x.report("for:")   { for i in 1..n; a = "1"; end }
  x.report("times:") { n.times do   ; a = "1"; end }
  x.report("upto:")  { 1.upto(n) do ; a = "1"; end }
end

#=>
#              user     system      total        real
# for:     1.050000   0.000000   1.050000 (  0.503462)
# times:   1.533333   0.016667   1.550000 (  0.735473)
# upto:    1.500000   0.016667   1.516667 (  0.711239)
```

集計を付けた場合

```ruby
require 'benchmark'

n = 50000
Benchmark.bm(7, ">total:", ">avg:") do |x|
  tf = x.report("for:")   { for i in 1..n; a = "1"; end }
  tt = x.report("times:") { n.times do   ; a = "1"; end }
  tu = x.report("upto:")  { 1.upto(n) do ; a = "1"; end }
  [tf + tt + tu, (tf + tt + tu) / 3]
end

#=>
#               user     system      total        real
# for:      0.001467   0.004727   0.006194 (  0.006193)
# times:    0.003814   0.000000   0.003814 (  0.003814)
# upto:     0.003855   0.000003   0.003858 (  0.003859)
# >total:   0.009136   0.004730   0.013866 (  0.013867)
# >avg:     0.003045   0.001577   0.004622 (  0.004622)
```

- **SEE** [m:Benchmark?.benchmark]

### module_function def bmbm(width = 0) {|job| ... } -> [Benchmark::Tms]

[c:Benchmark::Job] オブジェクトを生成して、それを引数として与えられたブロックを
実行します。

ベンチマークの結果は GC の影響によって歪められてしまうことがあります。
このメソッドは与えられたブロックを二度実行する事によってこの影響を最小化します。
一回目は実行環境を安定化するためにリハーサルとして実行します。二回目は本番として
実行します。

二回目のブロック実行の前に [m:GC.start] を実行しますが、この実行時間は計測には
含まれません。しかし、実際にはこのメソッドを使用しても、GC などの影響を分離する
ことは保証されません。

- **param** `width` -- ラベルの幅を指定します。

```ruby
require 'benchmark'

array = (1..1000000).map { rand }

Benchmark.bmbm do |x|
  x.report("sort!") { array.dup.sort! }
  x.report("sort")  { array.dup.sort  }
end

#=>
#
# Rehearsal -----------------------------------------
# sort!  11.928000   0.010000  11.938000 ( 12.756000)
# sort   13.048000   0.020000  13.068000 ( 13.857000)
# ------------------------------- total: 25.006000sec
#
#             user     system      total        real
# sort!  12.959000   0.010000  12.969000 ( 13.793000)
# sort   12.007000   0.000000  12.007000 ( 12.791000)
```

### module_function def benchmark(caption = "", label_width = nil, fmtstr = nil, *labels){|rep| ...} -> [Benchmark::Tms]

[c:Benchmark::Report] オブジェクトを生成し、それを引数として与えられたブロックを実行します。

基本的には以下のように使います。
ブロックが [c:Benchmark::Tms] オブジェクトの配列を返した場合は、
それらの数値も追加の行に表示されます。

- **param** `caption` --     レポートの一行目に表示する文字列を指定します。
- **param** `label_width` -- ラベルの幅を指定します。
- **param** `fmtstr` --      フォーマット文字列を指定します。
                   この引数を省略すると [m:Benchmark::FORMAT] が使用されます。
- **param** `labels` --  ブロックが [c:Benchmark::Tms] オブジェクトの配列を返す場合に指定します。

### フォーマット文字列

フォーマット文字列として以下が使用できます。

- **`%u`**:
  user CPU time で置き換えられます。[m:Benchmark::Tms#utime]
- **`%y`**:
  system CPU time で置き換えられます(Mnemonic: y of "s*y*stem")。[m:Benchmark::Tms#stime]
- **`%U`**:
  子プロセスの user CPU time で置き換えられます。[m:Benchmark::Tms#cutime]
- **`%Y`**:
  子プロセスの system CPU time で置き換えられます。[m:Benchmark::Tms#cstime]
- **`%t`**:
  total CPU time で置き換えられます。[m:Benchmark::Tms#total]
- **`%r`**:
  実経過時間で置き換えられます。[m:Benchmark::Tms#real]
- **`%n`**:
  ラベルで置き換えられます(Mnemonic: n of "*n*ame")。[m:Benchmark::Tms#label]

  ```ruby
  require 'benchmark'

  n = 50000

  # これは
  #    Benchmark.bm(7, ">total:", ">avg:") do |x| ... end
  # と同じ
  Benchmark.benchmark(" "*7 + Benchmark::CAPTION,
                      7,
                      Benchmark::FORMAT,
                      ">total:",
                      ">avg:") do |x|

    tf = x.report("for:")   { for i in 1..n; a = "1"; end }
    tt = x.report("times:") { n.times do   ; a = "1"; end }
    tu = x.report("upto:")  { 1.upto(n) do ; a = "1"; end }

    [tf+tt+tu, (tf+tt+tu)/3]
  end

  #=>
  #
  #              user     system      total        real
  # for:     1.016667   0.016667   1.033333 (  0.485749)
  # times:   1.450000   0.016667   1.466667 (  0.681367)
  # upto:    1.533333   0.000000   1.533333 (  0.722166)
  # >total:  4.000000   0.033333   4.033333 (  1.889282)
  # >avg:    1.333333   0.011111   1.344444 (  0.629761)
  ```

## Constants

### const CAPTION -> String

[m:Benchmark?.bm] の内部などで使用されます。

実際の定義は [m:Benchmark::Tms::CAPTION] でされています。

- **SEE** [m:Benchmark::Tms::CAPTION]

### const FORMAT -> String

[m:Benchmark?.benchmark] の第三引数のデフォルト値。

- **`%u`**:
  user CPU time で置き換えられます。[m:Benchmark::Tms#utime]
- **`%y`**:
  system CPU time で置き換えられます(Mnemonic: y of "s*y*stem")。[m:Benchmark::Tms#stime]
- **`%U`**:
  子プロセスの user CPU time で置き換えられます。[m:Benchmark::Tms#cutime]
- **`%Y`**:
  子プロセスの system CPU time で置き換えられます。[m:Benchmark::Tms#cstime]
- **`%t`**:
  total CPU time で置き換えられます。[m:Benchmark::Tms#total]
- **`%r`**:
  実経過時間で置き換えられます。[m:Benchmark::Tms#real]
- **`%n`**:
  ラベルで置き換えられます(Mnemonic: n of "*n*ame")。[m:Benchmark::Tms#label]

上記のフォーマット文字列を使用しています。
この定数の内容は以下の通りです。

```ruby
"%10.6u %10.6y %10.6t %10.6r\n"
```

- **SEE** [m:Benchmark?.benchmark], [m:Benchmark::Tms::FORMAT]

### const BENCHMARK_VERSION -> String

benchmark ライブラリのバージョンを表します。

# class Benchmark::Tms < Object

ベンチマークの計測に関連する各種時間を表現するクラスです。

## Class Methods

### def new(utime = 0.0, stime = 0.0, cutime = 0.0, cstime = 0.0, real = 0.0, label = nil) -> Benchmark::Tms

新しい [c:Benchmark::Tms] オブジェクトを生成して返します。

- **param** `utime` --  User CPU time
- **param** `stime` --  System CPU time
- **param** `cutime` -- 子プロセスの User CPU time
- **param** `cstime` -- 子プロセスの System CPU time
- **param** `real` --   実経過時間
- **param** `label` --  ラベル

## Instance Methods

### def *(x) -> Benchmark::Tms

self と x の乗算を計算します。

- **param** `x` -- [c:Benchmark::Tms] のオブジェクトか [c:Float] に暗黙の変換ができるオブジェクトです。

- **return** -- 計算結果は新しい [c:Benchmark::Tms] オブジェクトです。

- **SEE** [m:Benchmark::Tms#memberwise]

### def +(x) -> Benchmark::Tms

self と x の加算を計算します。

- **param** `x` -- [c:Benchmark::Tms] のオブジェクトか [c:Float] に暗黙の変換ができるオブジェクトです。

- **return** -- 計算結果は新しい [c:Benchmark::Tms] オブジェクトです。

- **SEE** [m:Benchmark::Tms#memberwise]

### def -(x) -> Benchmark::Tms

self と x の減算を計算します。

- **param** `x` -- [c:Benchmark::Tms] のオブジェクトか [c:Float] に暗黙の変換ができるオブジェクトです。

- **return** -- 計算結果は新しい [c:Benchmark::Tms] オブジェクトです。

- **SEE** [m:Benchmark::Tms#memberwise]

### def /(x) -> Benchmark::Tms

self と x の除算を計算します。

- **param** `x` -- [c:Benchmark::Tms] のオブジェクトか [c:Float] に暗黙の変換ができるオブジェクトです。

- **return** -- 計算結果は新しい [c:Benchmark::Tms] オブジェクトです。

- **SEE** [m:Benchmark::Tms#memberwise]

### def add { ... } -> Benchmark::Tms

与えられたブロックの実行時間を self に加算して
新しい [c:Benchmark::Tms] オブジェクトを生成して返します。

- **SEE** [m:Benchmark?.measure]

### def add!{ ... } -> self

与えられたブロックの実行時間を self に加算して返します。

このメソッドは self を破壊的に変更します。

- **SEE** [m:Benchmark?.measure]

### def format(fmtstr = nil, *args) -> String

self を指定されたフォーマットで整形して返します。

このメソッドは [m:Kernel?.format] のようにオブジェクトを整形しますが、
以下の拡張を使用できます。

- **`%u`**:
  user CPU time で置き換えられます。[m:Benchmark::Tms#utime]
- **`%y`**:
  system CPU time で置き換えられます(Mnemonic: y of "s*y*stem")。[m:Benchmark::Tms#stime]
- **`%U`**:
  子プロセスの user CPU time で置き換えられます。[m:Benchmark::Tms#cutime]
- **`%Y`**:
  子プロセスの system CPU time で置き換えられます。[m:Benchmark::Tms#cstime]
- **`%t`**:
  total CPU time で置き換えられます。[m:Benchmark::Tms#total]
- **`%r`**:
  実経過時間で置き換えられます。[m:Benchmark::Tms#real]
- **`%n`**:
  ラベルで置き換えられます(Mnemonic: n of "*n*ame")。[m:Benchmark::Tms#label]

- **param** `fmtstr` -- フォーマット文字列です。
              省略された場合は、[m:Benchmark::Tms::FORMAT] が使用されます。
- **param** `args` --  フォーマットされる引数です。

### def to_a -> Array

6 要素の配列を返します。

要素は以下の順番で配列に格納されています。
  - ラベル
  - user CPU time
  - system CPU time,
  - 子プロセスの user CPU time
  - 子プロセスの system CPU time,
  - 実経過時間

### def to_s -> String

引数を省略して [m:Benchmark::Tms#format] を呼び出すのと同じです。

### def utime -> Float

User CPU time

### def stime -> Float

System CPU time

### def cutime -> Float

子プロセスの User CPU time

### def cstime -> Float

子プロセスの System CPU time

### def real -> Float

実経過時間。

### def total -> Float

合計時間。(utime + stime + cutime + cstime)

### def label -> String

ラベル。

## Protected Instance Methods

### def memberwise(op, x) -> Benchmark::Tms

[c:Benchmark::Tms] の四則演算を実行するために内部で使用されるメソッドです。

- **param** `op` -- 演算子をシンボルで与えます。
- **param** `x` -- [c:Benchmark::Tms] のオブジェクトか [c:Float] に暗黙の変換ができるオブジェクトです。

- **return** -- 計算結果は新しい [c:Benchmark::Tms] オブジェクトです。

## Constants

### const CAPTION -> String

[m:Benchmark?.bm] の内部などで使用されます。

- **SEE** [m:Benchmark::CAPTION]

### const FORMAT -> String

[m:Benchmark?.benchmark] の第三引数のデフォルト値。

- **`%u`**:
  user CPU time で置き換えられます。[m:Benchmark::Tms#utime]
- **`%y`**:
  system CPU time で置き換えられます(Mnemonic: y of "s*y*stem")。[m:Benchmark::Tms#stime]
- **`%U`**:
  子プロセスの user CPU time で置き換えられます。[m:Benchmark::Tms#cutime]
- **`%Y`**:
  子プロセスの system CPU time で置き換えられます。[m:Benchmark::Tms#cstime]
- **`%t`**:
  total CPU time で置き換えられます。[m:Benchmark::Tms#total]
- **`%r`**:
  実経過時間で置き換えられます。[m:Benchmark::Tms#real]
- **`%n`**:
  ラベルで置き換えられます(Mnemonic: n of "*n*ame")。[m:Benchmark::Tms#label]

上記のフォーマット文字列を使用しています。
この定数の内容は以下の通りです。

```ruby
"%10.6u %10.6y %10.6t %10.6r\n"
```

- **SEE** [m:Benchmark?.benchmark], [m:Benchmark::FORMAT]

# class Benchmark::Job < Object

[m:Benchmark?.bmbm] メソッドの内部で使用されるクラスです。

このライブラリのユーザーが直接意識する必要はありません。

## Class Methods

### def new(width) -> Benchmark::Job

[c:Benchmark::Job] のインスタンスを初期化して返します。

通常このメソッドがユーザーによって直接呼び出されることはありません。

- **param** `width` -- [m:Benchmark::Job#list] のサイズ。

## Instance Methods

### def item(label = ""){ ... } -> self
### def report(label = ""){ ... } -> self

与えられたラベルとブロックをジョブリストに登録します。

- **param** `label` -- ラベル

### def list -> [String, Proc]

登録されているジョブのリストを返します。

それぞれの要素は、ラベルとブロックからなる二要素の配列です。

### def width -> Integer

[m:Benchmark::Job#list] のサイズ。

# class Benchmark::Report < Object

[m:Benchmark?.benchmark] メソッドや [m:Benchmark?.bm] メソッドの
内部で使用されているクラスです。

このライブラリのユーザーが直接意識する必要はありません。

## Class Methods

### def new(width = 0, fmtstr = nil) -> Benchmark::Report

[c:Benchmark::Report] のインスタンスを初期化して返します。

通常このメソッドがユーザーによって直接呼び出されることはありません。

- **param** `width` --  ラベルの幅
- **param** `fmtstr` -- フォーマット文字列

## Instance Methods

### def item(label = "", *fmt){ ... } -> Benchmark::Tms
### def report(label = "", *fmt){ ... } -> Benchmark::Tms

ラベルと与えられたブロックの実行時間を標準出力に出力します。

出力のフォーマットは [m:Benchmark::Tms#format] が行います。

- **param** `label` -- ラベル
- **param** `fmt` --   結果に出力したいオブジェクト

- **SEE** [m:Benchmark::Tms#format]

### def list -> [Benchmark::Tms]

[m:Benchmark::Report#item] 実行時に作成された [c:Benchmark::Tms] オ
ブジェクトの一覧を返します。

- **SEE** [m:Benchmark::Report#item]

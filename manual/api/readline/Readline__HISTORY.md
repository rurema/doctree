---
library: readline
extend:
  - Enumerable
---
# object Readline::HISTORY

Readline::HISTORY を使用してヒストリにアクセスできます。
[c:Enumerable] モジュールを extend しており、
[c:Array] クラスのように振る舞うことができます。
例えば、HISTORY[4] により 5 番目に入力した内容を取り出すことができます。

### def to_s -> "HISTORY"

文字列"HISTORY"を返します。

```ruby title="例"
require 'readline'
p Readline::HISTORY.to_s #=> "HISTORY"
```

### def [](index) -> String

ヒストリから index で指定したインデックスの内容を取得します。
例えば index に 0 を指定すると最初の入力内容が取得できます。
また、 -1 は最後の入力内容というように、index に負の値を指定することで、
最後から入力内容を取得することもできます。

- **param** `index` -- 取得対象のヒストリのインデックスを整数で指定します。
             インデックスは [c:Array] ように 0 から指定します。
             また、 -1 は最後の入力内容というように、負の数を指定することもできます。

- **raise** `IndexError` -- index で指定したインデックスに該当する入力内容がない場合に発生します。

- **raise** `RangeError` -- index で指定したインデックスが int 型よりも大きな値の場合に発生します。

```ruby title="例"
require "readline"

p Readline::HISTORY[0] #=> 最初の入力内容
p Readline::HISTORY[4] #=> 5番目の入力内容
p Readline::HISTORY[-1] #=> 最後の入力内容
p Readline::HISTORY[-5] #=> 最後から5番目の入力内容
```

例: 1000000 番目の入力内容が存在しない場合、例外 IndexError が発生します。

```ruby
require "readline"

Readline::HISTORY[1000000] #=> 例外 IndexError が発生します。
```

例: 32 bit のシステムの場合、例外 RangeError が発生します。

```ruby
require "readline"

Readline::HISTORY[2 ** 32 + 1] #=> 例外 RangeError が発生します。
```

例: 64 bit のシステムの場合、例外 RangeError が発生します。

```ruby
require "readline"

Readline::HISTORY[2 ** 64 + 1] #=> 例外 RangeError が発生します。
```

### def []=(index, string)

ヒストリの index で指定したインデックスの内容を string で指定した文字列で書き換えます。
例えば index に 0 を指定すると最初の入力内容が書き換えます。
また、 -1 は最後の入力内容というように、index に負の値を指定することで、
最後から入力内容を取得することもできます。
指定した string を返します。

- **param** `index` -- 取得対象のヒストリのインデックスを整数で指定します。
             インデックスは [c:Array] ように 0 から指定します。
             また、 -1 は最後の入力内容というように、負の数を指定することもできます。
- **param** `string` -- 文字列を指定します。この文字列でヒストリを書き換えます。

- **raise** `IndexError` -- index で指定したインデックスに該当する入力内容がない場合に発生します。

- **raise** `RangeError` -- index で指定したインデックスが int 型よりも大きな値の場合に発生します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

### def <<(string) -> self

ヒストリの最後に string で指定した文字列を追加します。
self を返します。

- **param** `string` -- 文字列を指定します。

例: "foo"を追加する。

```ruby
require "readline"

Readline::HISTORY << "foo"
p Readline::HISTORY[-1] #=> "foo"
```

例: "foo"、"bar"を追加する。

```ruby
require "readline"

Readline::HISTORY << "foo" << "bar"
p Readline::HISTORY[-1] #=> "bar"
p Readline::HISTORY[-2] #=> "foo"
```

- **SEE** [m:Readline::HISTORY.push]

### def push(*string) -> self

ヒストリの最後に string で指定した文字列を追加します。複数の string を指定できます。
self を返します。

- **param** `string` -- 文字列を指定します。複数指定できます。

例: "foo"を追加する。

```ruby
require "readline"

Readline::HISTORY.push("foo")
p Readline::HISTORY[-1] #=> "foo"
```

例: "foo"、"bar"を追加する。

```ruby
require "readline"

Readline::HISTORY.push("foo", "bar")
p Readline::HISTORY[-1] #=> "bar"
p Readline::HISTORY[-2] #=> "foo"
```

- **SEE** [m:Readline::HISTORY.<<]

### def pop -> String

ヒストリの最後の内容を取り出します。
最後の内容は、ヒストリから取り除かれます。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

```ruby title="例"
require "readline"
  
Readline::HISTORY.push("foo", "bar", "baz")
p Readline::HISTORY.pop #=> "baz"
p Readline::HISTORY.pop #=> "bar"
p Readline::HISTORY.pop #=> "foo"
```

- **SEE** [m:Readline::HISTORY.push]、[m:Readline::HISTORY.shift]、
     [m:Readline::HISTORY.delete_at]

### def shift -> String

ヒストリの最初の内容を取り出します。
最初の内容は、ヒストリから取り除かれます。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

```ruby title="例"
require "readline"
  
Readline::HISTORY.push("foo", "bar", "baz")
p Readline::HISTORY.shift #=> "foo"
p Readline::HISTORY.shift #=> "bar"
p Readline::HISTORY.shift #=> "baz"
```

- **SEE** [m:Readline::HISTORY.push]、[m:Readline::HISTORY.pop]、
     [m:Readline::HISTORY.delete_at]

### def each -> Enumerator
### def each {|string| ... }

ヒストリの内容に対してブロックを評価します。
ブロックパラメータにはヒストリの最初から最後までの内容を順番に渡します。

```ruby title="例: ヒストリの内容を最初から順番に出力する"
require "readline"
  
Readline::HISTORY.push("foo", "bar", "baz")
Readline::HISTORY.each do |s|
  p s #=> "foo", "bar", "baz"
end
```

例: [c:Enumerator] オブジェクトを返す場合。

```ruby
require "readline"
  
Readline::HISTORY.push("foo", "bar", "baz")
e = Readline::HISTORY.each
e.each do |s|
  p s #=> "foo", "bar", "baz"
end
```

### def length -> Integer
### def size -> Integer

ヒストリに格納された内容の数を取得します。

```ruby title="例: ヒストリの内容を最初から順番に出力する"
require "readline"
  
Readline::HISTORY.push("foo", "bar", "baz")
p Readline::HISTORY.length #=> 3
```

- **SEE** [m:Readline::HISTORY.empty?]

### def empty? -> bool

ヒストリに格納された内容の数が 0 の場合は true を、
そうでない場合は false を返します。

```ruby title="例"
require "readline"
  
p Readline::HISTORY.empty? #=> true
Readline::HISTORY.push("foo", "bar", "baz")
p Readline::HISTORY.empty? #=> false
```

- **SEE** [m:Readline::HISTORY.length]

### def delete_at(index) -> String | nil

index で指定したインデックスの内容をヒストリから削除し、その内容を返します。
該当する index の内容がヒストリになければ、 nil を返します。
index に 0 を指定すると [m:Readline::HISTORY.shift]
と同様に最初の入力内容を削除します。
また、 -1 は最後の入力内容というように、index に負の値を指定することで、
最後から入力内容を取得することもできます。
index が -1 の場合は [m:Readline::HISTORY.pop] と同様に動作します。

- **param** `index` -- 削除対象のヒストリのインデックスを指定します。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

```ruby title="例"
require "readline"
  
Readline::HISTORY.push("foo", "bar", "baz")
Readline::HISTORY.delete_at(1)
p Readline::HISTORY.to_a #=> ["foo", "baz"]
```

### def clear -> self

ヒストリの内容をすべて削除して空にします。

- **raise** `NotImplementedError` -- サポートしていない環境で発生します。

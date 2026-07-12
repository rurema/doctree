---
library: _builtin
extend:
  - Enumerable
---
# object ENV

環境変数を表すオブジェクト。[c:Hash] と同様のインターフェースを持ち
ます。ただし、Hash と異なり、ENV のキーと値には文字列しか
とることができません。

#@until 2.7.0
ENV で得られる文字列は ENV['PATH'] 以外は常に汚染されています。
オブジェクトの汚染に関しては [d:spec/safelevel] を参照して下さい。
ENV['PATH'] はその要素が誰でも書き込み可能なディレクトリを含ん
でいる場合に限り汚染されます。

```ruby title="例"
p ENV['TERM'].tainted?  # => true
p path = ENV['PATH']    # => "/usr/local/bin:/usr/bin:/bin:/usr/X11/bin"
p path.tainted?         # => false
```
#@end

また、ENV で得られる文字列は [m:Object#freeze] されています。

```ruby title="例"
p ENV['TERM'].frozen?  # => true
```

Windows では環境変数は大文字、小文字を区別しません。(cygwin を除く)

```ruby title="例"
p ENV['OS'] # => Windows_NT
p ENV['os'] # => Windows_NT
```

### def [](key) -> String

key に対応する環境変数の値を返します。該当する環境変数が存在
しない時には nil を返します。

- **param** `key` -- 環境変数名を指定します。文字列で指定します。文字列以外のオブ
           ジェクトを指定した場合は to_str メソッドによる暗黙の型変換
           を試みます。

```ruby
p ENV['PATH']         # => "/usr/local/bin:/usr/bin:/bin:/usr/X11/bin"
p ENV['NON_EXIST_KEY']  # => nil
```

### def []=(key, value)
### def store(key, value) -> String

key に対応する環境変数の値を value にします。
value が nil の時、key に対応する環境変数を取り除きます。

- **param** `key` --   環境変数名を指定します。文字列で指定します。文字列以外のオ
             ブジェクトを指定した場合は to_str メソッドによる暗黙の型変
             換を試みます。
- **param** `value` -- 置き換えるべき値を指定します。文字列で指定します。文字列以
             外のオブジェクトを指定した場合は to_str メソッドによる暗黙
             の型変換を試みます。

- **return** -- value を返します。

```ruby
ENV['NEW_KEY'] = 'some_value'
p ENV['NEW_KEY'] # => 'some_value'
p ENV.store('NEW_KEY', nil) # => nil
p ENV.has_key?('NEW_KEY') # => false
```

### def clear  -> self

環境変数をすべてクリアします。self を返します。

```ruby
ENV.clear
p ENV # => {}
```

### def delete(key) -> String | nil
### def delete(key) {|key| ... } -> String | nil

key に対応する環境変数を取り除きます。取り除かれた環境変数の
値を返しますが、key に対応する環境変数が存在しない時には
nil を返します。

ブロックが与えられた時には key にマッチするものがなかった時
に評価されます。

- **param** `key` -- 環境変数名を指定します。文字列で指定します。文字列で指定しま
           す。文字列以外のオブジェクトを指定した場合は to_str メソッド
           による暗黙の型変換を試みます。

```ruby
ENV['TEST'] = 'foo'
p ENV.delete('TEST')  # => "foo"
ENV.delete('TEST') { |key| puts "#{key} is not found in ENV" } # TEST is not found in ENV
```

#@since 1.9.1
### def reject                     -> Enumerator
#@else
### def reject                     -> Enumerable::Enumerator
#@end
### def reject {|key, value| ... } -> Hash

環境変数のうち、ブロックを評価した値が真であるものをとり除きます。
[m:Enumerable#reject] と異なり Hash を返します。また、とり除いた結果
は実際の環境変数に影響を与えません。

```ruby
ENV['TEST'] = 'foo'
result = ENV.reject { |key, value| key == 'TEST' }
p result['TEST'] # => nil
p ENV['TEST'] # => "foo"
```

### def delete_if {|key, value| ... } -> ENV
### def reject! {|key, value| ... }   -> ENV | nil
#@since 1.9.1
### def delete_if  -> Enumerator
### def reject!    -> Enumerator
#@else
### def delete_if  -> Enumerable::Enumerator
### def reject!    -> Enumerable::Enumerator
#@end

key と value を引数としてブロックを評価した値が真であ
る時、環境変数を削除します。

reject! は要素に変化がなければ nil を返します。

```ruby
ENV['FOO'] = 'bar'
p ENV.delete_if { |key, value| key == 'FOO' && value == 'bar' } # => ENV
p ENV.reject! { |key, value| key == 'FOO' && value == 'bar' } # => nil
```

#@since 1.9.1
### def each                          -> Enumerator
### def each_pair                     -> Enumerator
#@else
### def each                          -> Enumerable::Enumerator
### def each_pair                     -> Enumerable::Enumerator
#@end
### def each {|key, value| ... }      -> self
### def each_pair {|key, value| ... } -> self
key と value を引数としてブロックを評価します。

```ruby
ENV['FOO'] = 'bar'
ENV.each do |key, value|
  p "value is #{value}" if key == 'FOO' # => "value is bar"
end
# => ENV
```

#@since 1.9.1
### def each_key              -> Enumerator
#@else
### def each_key              -> Enumerable::Enumerator
#@end
### def each_key {|key| ... } -> self
key を引数としてブロックを評価します。

```ruby
ENV['FOO'] = 'bar'
ENV.each_key do |key|
  p "key #{key} detected" if key == 'FOO'
end
# "key FOO detected"
```

#@since 1.9.1
### def each_value                -> Enumerator
#@else
### def each_value                -> Enumerable::Enumerator
#@end
### def each_value {|value| ... } -> self
value を引数としてブロックを評価します。

### def empty? -> bool

環境変数がひとつも定義されていない時真を返します。

### def fetch(key) -> String
### def fetch(key, default) -> String
### def fetch(key) {|key| ... } -> String

key に関連づけられた値を返します。該当するキーが登録されてい
ない時には、引数 default が与えられていればその値を、ブロッ
クが与えられていればそのブロックを評価した値を返します。そのいずれ
でもなければ例外が発生します。

- **param** `key` --       環境変数の名前を指定します。 文字列で指定します。
                 文字列以外のオブジェクトを指定した場合は
                 to_str メソッドによる暗黙の型変換を試みます。
- **param** `default` --   keyに対応する環境変数の値がないときにこの値を返します。 
#@since 1.9.1
- **raise**  `KeyError` --   引数defaultもブロックも与えられてない時、キーの探索に失敗すると発生します。
#@else
- **raise**  `IndexError` -- 引数defaultもブロックも与えられてない時、キーの探索に失敗すると発生します。
#@end

### def has_key?(key) -> bool
### def include?(key) -> bool
### def key?(key)     -> bool
### def member?(key)  -> bool

key で指定される環境変数が存在する時、真を返します。

- **param** `key` -- 環境変数の名前を指定します。文字列で指定します。
           文字列以外のオブジェクトを指定した場合は to_str メソッ
           ドによる暗黙の型変換を試みます。

### def has_value?(val) -> bool
### def value?(val)     -> bool

val を値として持つ環境変数が存在する時、真を返します。

- **param** `val` -- 値を指定します。文字列で指定します。文字
           列以外のオブジェクトを指定した場合は to_str メソッドによる暗
           黙の型変換を試みます。

#@since 1.9.1
### def key(val)   -> String | nil
#@end
#@until 3.0
### def index(val) -> String | nil
#@end

val に対応するキーを返します。対応する要素が存在しない時には
nil を返します。

#@until 3.0
[m:ENV.index] は obsolete です。使用すると警告メッセージが表示されます。
[m:ENV.key] を使用してください。
#@end

- **param** `val` -- 値を指定します。文字列で指定します。文字
           列以外のオブジェクトを指定した場合は to_str メソッドによる暗
           黙の型変換を試みます。

### def inspect -> String

ENV オブジェクトを文字列化します。 [m:Hash#inspect] と同じように動作します。

### def invert -> Hash

環境変数の値をキー、名前を値とした [c:Hash] を生成して返します。

### def keys -> [String]

全環境変数の名前の配列を返します。

### def length -> Integer
### def size   -> Integer

環境変数の数を返します。

### def rehash -> nil

何もしません。nilを返します。

### def replace(hash) -> ENV

環境変数を hash と同じ内容に変更します。 self を返します。

- **param** `hash` --  キーと値の対応関係を指定します。 to_hash でハッシュに変換されます。

### def select                      -> Enumerator
### def select {|key, value| ... }  -> Hash
#@since 2.6.0
### def filter                      -> Enumerator
### def filter {|key, value| ... }  -> Hash
#@end

環境変数名と値についてブロックを評価し、真を返したものを集めたハッシュ
を返します。

### def shift -> [String, String] | nil

環境変数を一つ取り除いて、それを名前と値の組の配列で返します。
環境変数が一つも設定されていなければ nil を返します。

### def to_a -> [[String, String]]

環境変数から [変数名, 値] となる 2 要素の配列の配列を生成します。

### def to_hash -> Hash

環境変数の名前をキーとし、対応する値をもつハッシュを返します。

### def to_h -> Hash
#@since 2.6.0
### def to_h {|name, value| block } -> Hash
#@end

環境変数の名前をキーとし、対応する値をもつハッシュを返します。

#@since 2.6.0
ブロックを指定すると各ペアでブロックを呼び出し、
その結果をペアとして使います。
```ruby title="ブロック付きの例"
ENV.to_h {|name, value| [name, value.size] }
```
#@end

### def to_s -> String

環境変数を文字列化します。 Hash#to_s と同じように動作します。

#@since 3.2
### def merge!(*others) -> ENV
### def merge!(*others) {|key, self_val, other_val| ... } -> ENV
### def update(*others) -> ENV
### def update(*others) {|key, self_val, other_val| ... } -> ENV

ハッシュ others の内容を環境変数にマージします。重複するキー
に対応する値は others の内容で上書きされます。

self と others に同じキーがあった場合はブロック付きか否かで
判定方法が違います。ブロック付きのときはブロックを呼び出して
その返す値を重複キーに対応する値にします。ブロック付きでない
場合は常に others の値を使います。

- **param** `others` -- マージ用のハッシュです。
#@else
### def update(other) -> ENV
### def update(other) {|key, self_val, other_val| ... } -> ENV
#@since 2.7.0
### def merge!(other) -> ENV
### def merge!(other) {|key, self_val, other_val| ... } -> ENV
#@end

ハッシュ other の内容を環境変数にマージします。重複するキー
に対応する値は other の内容で上書きされます。

self と other に同じキーがあった場合はブロック付きか否かで
判定方法が違います。ブロック付きのときはブロックを呼び出して
その返す値を重複キーに対応する値にします。ブロック付きでない
場合は常に other の値を使います。

- **param** `other` --  上書きするハッシュを指定します。
#@end
### def values -> [String]

環境変数の全値の配列を返します。

### def values_at(*key) -> [String]

引数で指定されたキー(環境変数名)に対応する値の配列を返します。存在
しないキーに対しては nil が対応します。
#@until 1.9.1
[m:ENV.indexes] と [m:ENV.indices] と同じです。
#@end

例:

`````
ENV.update({'FOO' => 'foo', 'BAR' => 'bar'})
p ENV.values_at(*%w(FOO BAR BAZ))   # => ["foo", "bar", nil]
`````

- **param** `key` -- 環境変数名を指定します。文字列で指定します。
           文字列以外のオブジェクトを指定した場合は to_str メソッドによる暗黙の型変換を試みます。
           
#@since 1.9.1
### def assoc(key) -> Array | nil

自身が与えられたキーに対応する要素を持つとき、見つかった要素のキーと値のペアを
配列として返します。

- **param** `key` -- 検索するキーを指定します。

- **SEE** [m:Hash#assoc]

### def rassoc(value) -> Array | nil

自身が与えられた値に対応する要素を持つとき、見つかった要素のキーと値のペアを
配列として返します。

- **param** `value` -- 検索する値を指定します。

- **SEE** [m:Hash#rassoc]

#@end

#@since 1.9.2
### def keep_if {|key, value| ... } -> ENV
### def select! {|key, value| ... } -> ENV | nil
#@since 2.6.0
### def filter! {|key, value| ... } -> ENV | nil
#@end
### def keep_if -> Enumerator
### def select! -> Enumerator
#@since 2.6.0
### def filter! -> Enumerator
#@end

キーと値を引数としてブロックを評価した結果が真であ
るような要素を環境変数に残します。

keep_if は常に self を返します。
#@since 2.6.0
select! と filter! はオブジェクトが変更された場合に self を、
#@else
select! はオブジェクトが変更された場合に self を、
#@end
されていない場合に nil を返します。

ブロックが省略された場合には [c:Enumerator] を返します。

- **SEE** [m:ENV.delete_if],[m:ENV.reject!], [m:Hash#keep_if], [m:Hash#select!],
#@end
#@since 2.6.0
### def slice(*keys) -> Hash

引数で指定されたキーとその値だけを含む Hash を返します。

```ruby title="例"
ENV["foo"] = "bar"
ENV["baz"] = "qux"
ENV["bar"] = "rab"
p ENV.slice()           # => {}
p ENV.slice("")         # => {}
p ENV.slice("unknown")  # => {}
p ENV.slice("foo", "baz") # => {"foo"=>"bar", "baz"=>"qux"}
```

#@since 3.0
- **SEE** [m:Hash#slice], [m:ENV.except]
#@else
- **SEE** [m:Hash#slice]
#@end
#@end
#@since 2.7.0
### def freeze -> ()
ENV.freeze は環境変数の変更を禁止できないため、[c:TypeError]を発生させます。
#@end
#@since 3.0
### def except(*keys) -> Hash

引数で指定された以外のキーとその値だけを含む Hash を返します。

```ruby
p ENV                     #=> {"LANG"=>"en_US.UTF-8", "TERM"=>"xterm-256color", "HOME"=>"/Users/rhc"}
p ENV.except("TERM","HOME") #=> {"LANG"=>"en_US.UTF-8"}
```

- **SEE** [m:Hash#except], [m:ENV.slice]
#@end
### def clone(freeze: true) -> object
ENV オブジェクトの複製を作成して返します。

ENV は OS のプロセス全体で共有される環境変数を操作するラッパーオブジェクトなので、複製は有用ではありません。
そのため、3.1 からは複製で環境変数を操作するときに deprecated 警告がでます。

テスト実行中に環境変数を退避する用途には [m:ENV.to_h] を使用してください。

```ruby
saved_env = ENV.to_h
# (テストなど)
ENV.replace(saved_env)
```

- **SEE** [m:Object#clone]
#@since 3.1
- **SEE** [m:ENV.dup]
### def dup -> ()
[c:TypeError]を発生させます。

3.0 以前では Object.new と同様の ENV とは無関係の有用ではないオブジェクトを返していたため、3.1 からは例外が発生するようになりました。
詳細は[m:ENV.clone]を参照してください。

- **SEE** [m:ENV.clone]
#@end

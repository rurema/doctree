Rubyリファレンスマニュアル中のクラス・メソッド等に対してサンプルコードを記述する際のガイドラインをまとめます。

## 簡潔・全てを含む・コピー＆ペーストで実行可能なコード
サンプルコードは以下のような特徴を持つようにしてください。

* 簡潔であること
* 実行に必要な全てを含むこと
* コピー＆ペーストで実行可能な形式であること

例えば Prime.take の説明をする場合

```ruby
require 'prime'

p Prime.take(5) # => [2, 3, 5, 7, 11]
```

のようなサンプルです。

逆に、上記を守っていない場合は

* 対象を説明するために不要なコードを含むこと
* 実行に必要な require や変数の宣言を省略していること
* エラーになること

ということです。

例えば

```ruby
# prime の require がない

1 + 1 = 2 # 対象の説明に関係ないコードがある
p Prime.take(5) # => [2, 3, 5, 7, 11]
```

のようなサンプルです。

### 「簡潔」の意味
「簡潔」は対象の理解に不要な要素が無いことを指します。
コードの字面の短さ(バイト数)を最小にすることではありません。

* 値は一般性の高いものにしてください。空配列や要素1個の配列のような特殊な値は、
  一般的な挙動が読み取りづらいため、特殊ケース自体を説明する場合
  (`Array#empty?` など)を除いて避けてください。
* 必要な要素数は対象によって変わります。`Array#+` なら要素2個で十分ですが、
  範囲指定の `Array#[]` なら要素5個程度あるほうが挙動を読み取りやすくなります。
* 短くするために可読性を犠牲にしないでください
  (条件演算子の入れ子や、1行に長く連ねたメソッドチェーンなど)。

例えば `Array#[]`(範囲指定)の場合、良い例は

```ruby
a = [1, 2, 3, 4, 5]
p a[1..3] # => [2, 3, 4]
```

です。悪い例は

```ruby
# 要素が多すぎて一目で把握しづらい
a = [4, 3.7, -2, 0, 1.5, -1.4, 8, 42, -7]
p a[1..3] # => [3.7, -2, 0]
```

や

```ruby
# 要素1個の配列は特殊で、範囲指定の一般的な挙動が読み取れない
a = [5]
p a[0..0] # => [5]
```

のようなサンプルです。

### 目的
`簡潔で・全てを含み・コピー＆ペーストで実行可能なコード` というガイドラインを守ることで  
リファレンスの利用者は

* 誰でも同じコードをコピペするだけで動かして確認できる
* 最小の手間で対象を理解できる

などの恩恵を得ることができます。  
仮にこれらの恩恵が無かった場合は

* コピペして動かない部分に関してリファレンスの利用者が予測して理解する必要がある
* 理解に手間がかかる

という問題点があることになります。

### 参考資料
`簡潔・全てを含む・コピー＆ペーストで実行可能なコード` の内容は [SSCCE](http://sscce.org/)
(Short, Self Contained, Correct (Compilable), Example) を参考にしています。

## 値の明示
変数の値や、標準出力結果を明示することでサンプルを理解するための助けになると考えられる場合は  
`# => 任意の出力` のフォーマットで明示してください。

例:

```ruby
str = "tXt"
str = str*2      # => "tXttXt"
p str.upcase     # => "TXTTXT"
p str.downcase   # => "txttxt"
```

## 意味のある命名
リファレンスの読み手や、るりまのレビュアーへの配慮のため
クラス名、変数名などは意味のある命名をすること。

### 悪い例
```ruby
Hoge = Struct.new("Hoge", :foo, :bar)
hoge = Hoge.new("aaaa", 5)
```

### 良い例
```ruby
Person = Struct.new("Person", :name, :age)
tanaka = Person.new("tanaka", 32)
```

## 補足説明
サンプルコード中に補足説明があることで理解の助けになると考えられる場合は  
`# 任意の説明コメント` のフォーマットで補足説明をしてください。

例:

```ruby
str = "tXt"
# 変数は不変
p str.upcase     # => "TXT"
p str            # => "tXt"

str = "tXt"
# 破壊的に変更される
p str.upcase!      # => "TXT"
p str              # => "TXT"
```

## 体裁
* 各サンプルはフェンスドコードブロック（```` ```ruby ````）で書いてください
* `title` は必須ではありません。コードブロックであることは表示上明確なため、
  単に「例」とだけ書く `title="例"` は新規のコードブロックでは不要です
  （既存の `title="例"` をわざわざ消して回る必要もありません）
* 内容を区別・説明したい場合は `title="例: 引数を省略した場合"` のような
  説明的なラベルを付けられます
* `# =>`の`#`と`=>`の間にスペースを一つ入れてください
* 値を表示するための`p`はあってもなくても構いません

例

`````markdown
```ruby
"text"[1]  # => "e"
```
`````

* 複数のサンプルを続けて記述する場合は、サンプルごとにコードブロックを分けてください。
  区別が必要なときは `title="例1: ..."` のような説明的なラベルを付けると分かりやすくなります

悪い例

2つの例の区切りがわかりにくい

`````markdown
```ruby title="例"
require 'yaml'
data = [ "Taro san", "Jiro san", "Saburo san"]
str_r = YAML.dump(data)
str_l =<<EOT
--- 
- Taro san
- Jiro san
- Saburo san
EOT
p str_r == str_l #=> true

require 'yaml'
require 'date'
str_l =<<YAML_EOT
Tanaka Taro: { age: 35, birthday: 1970-01-01}
Suzuki Suneo: {
  age: 13,
  birthday: 1992-12-21
}
YAML_EOT
str_r = {}
str_r["Tanaka Taro"] = {
  "age" => 35,
  "birthday" => Date.new(1970, 1, 1)
}
str_r["Suzuki Suneo"] = {
  "age" => 13,
  "birthday" => Date.new(1992, 12, 21)
}
p str_r == YAML.load(str_l) #=> true
```
`````

良い例

2つの例の区切りが明確にわかる

`````markdown
```ruby title="例1: 構造化された配列"
require 'yaml'
data = [ "Taro san", "Jiro san", "Saburo san"]
str_r = YAML.dump(data)
str_l =<<EOT
--- 
- Taro san
- Jiro san
- Saburo san
EOT
p str_r == str_l #=> true
```

```ruby title="例2: 構造化されたハッシュ"
require 'yaml'
require 'date'
str_l =<<YAML_EOT
Tanaka Taro: { age: 35, birthday: 1970-01-01}
Suzuki Suneo: {
  age: 13,
  birthday: 1992-12-21
}
YAML_EOT
str_r = {}
str_r["Tanaka Taro"] = {
  "age" => 35,
  "birthday" => Date.new(1970, 1, 1)
}
str_r["Suzuki Suneo"] = {
  "age" => 13,
  "birthday" => Date.new(1992, 12, 21)
}
p str_r == YAML.load(str_l) #=> true
```
`````

## Time関連のタイムゾーンはJSTにする
* 悪い例

```ruby
t = Time.now       #=> 2007-11-19 08:12:12 -0600
t2 = t + 2592000   #=> 2007-12-19 08:12:12 -0600

t = Time.now       #=> 2007-11-19 08:13:38 -0600
t2 = t + 0.1       #=> 2007-11-19 08:13:38 -0600
```

* 良い例

```ruby
t = Time.now       # => 2017-11-10 04:42:19 +0900
t2 = t + 2592000   # => 2017-12-10 04:42:19 +0900

t = Time.now       # => 2017-11-10 04:42:19 +0900
t2 = t + 0.1       # => 2017-11-10 04:42:19 +0900
```

## サンプルをあえて書かないケース
* サンプルを書く意義があまりないケース
* 他のサンプルへの参照で十分なケース

など、意図的にサンプルを書かない場合は `#@#noexample <サンプルを書かない理由>` を記載してください。

例: https://docs.ruby-lang.org/ja/latest/method/Struct/i/equal=3f.html の例

```markdown
### def equal?(other)   -> bool

指定された other が self 自身である場合のみ真を返します。
これは [c:Object] クラスで定義されたデフォルトの動作で
す。

#@include(Struct.attention)

#@#noexample Object#equal? のデフォルトの動作と変わらないため

- **SEE** [m:Struct#eql?], [m:Struct#==]
```

## RDocとの関係
Ruby本家の　[RDoc](https://docs.ruby-lang.org/en/2.5.0/index.html)　があり、そのままの内容で問題ない場合はそのまま活用する。
RDoc があるが、あえて別の内容にする場合はプルリクエスト時に「なぜ別の内容にしたか」について理由を明記すること。

RDoc について補足。例えば るりまで Array#assoc を確認する場合は、以下を確認することになります。

* [instance method Array#assoc (Ruby 2.5.0)](https://docs.ruby-lang.org/ja/latest/method/Array/i/assoc.html)

このメソッドに対応する RDoc に遷移するには、画面右端にある `[rdoc]`をクリックします。

* [class Array - Documentation for Ruby 2.5.0](https://docs.ruby-lang.org/en/2.5.0/Array.html#method-i-assoc)

になります。
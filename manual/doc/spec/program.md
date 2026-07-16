# プログラム・文・式

  - [ref:exp]
  - [ref:terminate]

プログラムは [ref:exp] を並べたものです。
式と式の間はセミコロン(`;`)または改行で区切ります。ただし、バックスラッシュに続く改行は文
の区切りにならず、次の行へ継続します。

```ruby title="例"
print "hello world!\n"
```

### 式 {#exp}

Ruby の式には、さまざまな [d:spec/literal]、[d:spec/variables]、[d:spec/call]、
それらの [d:spec/operator]、`if` や `while` などの [d:spec/control]、
[d:spec/def] があります。

```ruby title="さまざまな式"
# リテラルだけでも式
"Ruby"
1.5

# 変数・擬似変数・定数だけでも式
foo
true
RUBY_VERSION

# メソッド呼び出しだけでも式
puts
"ruby".capitalize
1194794.to_s(35)

# 演算子式（式と演算子を組み合わせた式）
-Math::PI   # 単項演算子の例
355.0 / 113 # 二項演算子の例（算術演算子）
age < 20    # 二項演算子の例（関係演算子）
rand(10).zero? ? "当たり" : "はずれ" # 三項演算子の例
name = "Ruby" # 代入演算子の例
9..17 # 範囲式の例

# 制御構造も式
if rand(10).zero?
  "当たり"
else
  "はずれ"
end

case count
when 0
  "無し"
when ...10
  "少ない"
when ...100
  "ふつう"
else
  "多い"
end

# メソッド定義式
# （式の値は Symbol で表されたメソッド名）
def greeting(name)
  puts "Hello, #{name}!"
end

# モジュール定義式
module UnitsToRadian
  # 使用例
  # using UnitsToRadian
  # puts Math.sin(90.deg) # => 1.0

  refine Numeric do
    def deg = self * Math::PI / 180

    def gon = self * Math::PI / 200
    alias g gon

    def tr = self * Math::PI * 2
  end
end
```

式は括弧 `( )` によってグルーピングできます。

式は評価されると値（評価値）が定まり、その値を返します。
ただし、`return`、`break`, `next` といったものは値を返しません。これらは評価された
時点で制御が移ってしまいます。

空の式 `()` は `nil` を返します。

また、メソッドの引数に指定できない式と指定できる式があります(このよう
な式を「文」と呼び分ける場合があります)。

#### メソッドの引数に指定できない式

以下のような式はそのままではメソッドの引数にできません。

- `and`, `or` 演算子による演算子式
- `if`, `unless`, `while`, `until`, `rescue` 修飾子の付いた式

```text title="SyntaxError になる書き方"
p(true and nil)
p("当たり" if rand(10).zero?)
```

メソッドの引数に指定できない式は、括弧によるグルーピングを行うことで普
通の式として使用できます。

```ruby title="正しい書き方"
p((true and nil))
p(("当たり" if rand(10).zero?))
```

なお、`not` 演算子による式は、Ruby 3.3 以前のデフォルトパーサ(parse.y)ではメソッドの引数にできませんが、Ruby 3.4 以降のデフォルトパーサ(Prism)では引数に指定できます。

### プログラムの終り {#terminate}

Rubyインタプリタはプログラムを読みこんでいる際に以下のものに出会うとそこ
で読みこみを終了します。

- ファイルの終り(文字列を `eval` している場合は文字列の終り)
- `^D`(コントロールD) 、`^Z`(コントロールZ)
- `__END__` のみの行(前後に空白があると認識されません)

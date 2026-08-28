---
library: _builtin
include:
  - Comparable
---
# class Numeric < Object

数値を表す抽象クラスです。[c:Integer] や [c:Float] などの数値クラスは `Numeric` のサブクラスとして実装されています。

演算や比較を行うメソッド（`+`, `-`, `*`, `/`, `<=>`）は `Numeric` のサブクラスで定義されます。`Numeric` で定義されているメソッドは、サブクラスで提供されているメソッド（`+`, `-`, `*`, `/`, `%`）を利用して定義されるものがほとんどです。
つまり `Numeric` で定義されているメソッドは、`Numeric` のサブクラスとして新たに数値クラスを定義したときに、演算メソッド（`+`, `-`, `*`, `/`, `%`, `<=>`, `coerce`）だけを定義すれば、数値クラスのそのほかのメソッドが適切に定義されることを意図して提供されています。

`+@`, `-@` は単項演算子 `+`, `-` を表しメソッド定義などではこの記法を利用します。

効率のため `Numeric` のメソッドと同じメソッドがサブクラスで再定義されている場合があります。

[m:Numeric#coerce] メソッドを使うことによって異なる数値クラス間で演算を行うこともできます。

### 数値関連のメソッドが使えるクラス一覧

数値関連のメソッドがどのクラスで使えるかの一覧です。ほとんどのメソッドはサブクラスで再定義されています。これは、効率のためであったり上位抽象クラスで実装を定義できなかったりするためです。

- リンク付きの ○: 使えます。リンク先はそのクラス自身のメソッド項目です
- リンクなしの ○: 使えます。説明は上位クラスの同名メソッドの項目を参照してください
- ―: 使えません

#%#  # Numeric 系 5 クラスの「メソッド × 使えるか」Markdown 表を生成する
#%#  #   ruby numeric_table_md.rb        # るりまの内部参照記法でリンク(原稿用)
#%#  #   ruby numeric_table_md.rb --url  # docs.ruby-lang.org の URL でリンク(この表)
#%#  url_mode = ARGV.include?("--url")
#%#
#%#  classes = [Numeric, Integer, Float, Rational, Complex]
#%#  defined = classes.to_h { [_1, _1.instance_methods(false)] }
#%#  usable  = classes.to_h { [_1, _1.instance_methods(true)] }
#%#
#%#  # るりまに項目のあるクラスが 1 つもないメソッドは除外(2026-08 実測)
#%#  excluded = %i[singleton_method_added clone dup]
#%#
#%#  # ランタイムでは(再)定義されているが、るりまにそのクラス自身の項目がないセル
#%#  # (リンクなしの ○ にする。2026-08 実測)
#%#  no_entry = [
#%#    [Integer, :coerce], [Integer, :zero?],
#%#    [Float, :===], [Float, :coerce], [Float, :fdiv], [Float, :quo], [Float, :to_int],
#%#    [Complex, :eql?], [Complex, :hash],
#%#  ]
#%#
#%#  all_methods = defined.values.flatten.uniq.sort - excluded
#%#
#%#  # bitclust の URL エンコード(英数字と _ 以外は =XX)
#%#  def encode_url(name)
#%#    name.gsub(/[^A-Za-z0-9_]/) { "=%02x" % _1.ord }
#%#  end
#%#
#%#  # GFM テーブルのセル内ではリテラルの | を \| と書く
#%#  def escape_cell(str)
#%#    str.gsub("|", "\\\\|")
#%#  end
#%#
#%#  link =
#%#    if url_mode
#%#      ->(c, m) { "[○](https://docs.ruby-lang.org/ja/latest/method/#{c.name}/i/#{encode_url(m.to_s)}.html)" }
#%#    else
#%#      ->(c, m) { "[○](m:#{c.name}##{escape_cell(m.to_s)})" }
#%#    end
#%#
#%#  puts "| メソッド | #{classes.map(&:name).join(' | ')} |"
#%#  puts "|---:|#{([':---:'] * classes.size).join('|')}|"
#%#
#%#  all_methods.each do |m|
#%#    cells = classes.map do |c|
#%#      if defined[c].include?(m) && !no_entry.include?([c, m])
#%#        link.(c, m)
#%#      elsif usable[c].include?(m)
#%#        "○"
#%#      else
#%#        "―"
#%#      end
#%#    end
#%#    puts "| `#{escape_cell(m.to_s)}` | #{cells.join(' | ')} |"
#%#  end

| メソッド | Numeric | Integer | Float | Rational | Complex |
|---:|:---:|:---:|:---:|:---:|:---:|
| `%` | [○](m:Numeric#%) | [○](m:Integer#%) | [○](m:Float#%) | ○ | ― |
| `&` | ― | [○](m:Integer#&) | ― | ― | ― |
| `*` | ― | [○](m:Integer#*) | [○](m:Float#*) | [○](m:Rational#*) | [○](m:Complex#*) |
| `**` | ― | [○](m:Integer#**) | [○](m:Float#**) | [○](m:Rational#**) | [○](m:Complex#**) |
| `+` | ― | [○](m:Integer#+) | [○](m:Float#+) | [○](m:Rational#+) | [○](m:Complex#+) |
| `+@` | [○](m:Numeric#+@) | ○ | ○ | ○ | ○ |
| `-` | ― | [○](m:Integer#-) | [○](m:Float#-) | [○](m:Rational#-) | [○](m:Complex#-) |
| `-@` | [○](m:Numeric#-@) | [○](m:Integer#-@) | [○](m:Float#-@) | [○](m:Rational#-@) | [○](m:Complex#-@) |
| `/` | ― | [○](m:Integer#/) | [○](m:Float#/) | [○](m:Rational#/) | [○](m:Complex#/) |
| `<` | ○ | [○](m:Integer#<) | [○](m:Float#<) | ○ | ― |
| `<<` | ― | [○](m:Integer#<<) | ― | ― | ― |
| `<=` | ○ | [○](m:Integer#<=) | [○](m:Float#<=) | ○ | ― |
| `<=>` | [○](m:Numeric#<=>) | [○](m:Integer#<=>) | [○](m:Float#<=>) | [○](m:Rational#<=>) | [○](m:Complex#<=>) |
| `==` | ○ | [○](m:Integer#==) | [○](m:Float#==) | [○](m:Rational#==) | [○](m:Complex#==) |
| `===` | ○ | [○](m:Integer#===) | ○ | ○ | ○ |
| `>` | ○ | [○](m:Integer#>) | [○](m:Float#>) | ○ | ― |
| `>=` | ○ | [○](m:Integer#>=) | [○](m:Float#>=) | ○ | ― |
| `>>` | ― | [○](m:Integer#>>) | ― | ― | ― |
| `[]` | ― | [○](m:Integer#[]) | ― | ― | ― |
| `^` | ― | [○](m:Integer#^) | ― | ― | ― |
| `abs` | [○](m:Numeric#abs) | [○](m:Integer#abs) | [○](m:Float#abs) | [○](m:Rational#abs) | [○](m:Complex#abs) |
| `abs2` | [○](m:Numeric#abs2) | ○ | ○ | ○ | [○](m:Complex#abs2) |
| `allbits?` | ― | [○](m:Integer#allbits?) | ― | ― | ― |
| `angle` | [○](m:Numeric#angle) | ○ | [○](m:Float#angle) | ○ | [○](m:Complex#angle) |
| `anybits?` | ― | [○](m:Integer#anybits?) | ― | ― | ― |
| `arg` | [○](m:Numeric#arg) | ○ | [○](m:Float#arg) | ○ | [○](m:Complex#arg) |
| `bit_length` | ― | [○](m:Integer#bit_length) | ― | ― | ― |
| `ceil` | [○](m:Numeric#ceil) | [○](m:Integer#ceil) | [○](m:Float#ceil) | [○](m:Rational#ceil) | ― |
#%since 3.2
| `ceildiv` | ― | [○](m:Integer#ceildiv) | ― | ― | ― |
#%end
| `chr` | ― | [○](m:Integer#chr) | ― | ― | ― |
| `coerce` | [○](m:Numeric#coerce) | ○ | ○ | [○](m:Rational#coerce) | [○](m:Complex#coerce) |
| `conj` | [○](m:Numeric#conj) | ○ | ○ | ○ | [○](m:Complex#conj) |
| `conjugate` | [○](m:Numeric#conjugate) | ○ | ○ | ○ | [○](m:Complex#conjugate) |
| `denominator` | [○](m:Numeric#denominator) | [○](m:Integer#denominator) | [○](m:Float#denominator) | [○](m:Rational#denominator) | [○](m:Complex#denominator) |
| `digits` | ― | [○](m:Integer#digits) | ― | ― | ― |
| `div` | [○](m:Numeric#div) | [○](m:Integer#div) | ○ | ○ | ― |
| `divmod` | [○](m:Numeric#divmod) | [○](m:Integer#divmod) | [○](m:Float#divmod) | ○ | ― |
| `downto` | ― | [○](m:Integer#downto) | ― | ― | ― |
| `eql?` | [○](m:Numeric#eql?) | ○ | [○](m:Float#eql?) | ○ | ○ |
| `even?` | ― | [○](m:Integer#even?) | ― | ― | ― |
| `fdiv` | [○](m:Numeric#fdiv) | [○](m:Integer#fdiv) | ○ | [○](m:Rational#fdiv) | [○](m:Complex#fdiv) |
| `finite?` | [○](m:Numeric#finite?) | ○ | [○](m:Float#finite?) | ○ | [○](m:Complex#finite?) |
| `floor` | [○](m:Numeric#floor) | [○](m:Integer#floor) | [○](m:Float#floor) | [○](m:Rational#floor) | ― |
| `gcd` | ― | [○](m:Integer#gcd) | ― | ― | ― |
| `gcdlcm` | ― | [○](m:Integer#gcdlcm) | ― | ― | ― |
| `hash` | ○ | ○ | [○](m:Float#hash) | [○](m:Rational#hash) | ○ |
| `i` | [○](m:Numeric#i) | ○ | ○ | ○ | ― |
| `imag` | [○](m:Numeric#imag) | ○ | ○ | ○ | [○](m:Complex#imag) |
| `imaginary` | [○](m:Numeric#imaginary) | ○ | ○ | ○ | [○](m:Complex#imaginary) |
| `infinite?` | [○](m:Numeric#infinite?) | ○ | [○](m:Float#infinite?) | ○ | [○](m:Complex#infinite?) |
| `inspect` | ○ | [○](m:Integer#inspect) | [○](m:Float#inspect) | [○](m:Rational#inspect) | [○](m:Complex#inspect) |
| `integer?` | [○](m:Numeric#integer?) | [○](m:Integer#integer?) | ○ | ○ | ○ |
| `lcm` | ― | [○](m:Integer#lcm) | ― | ― | ― |
| `magnitude` | [○](m:Numeric#magnitude) | [○](m:Integer#magnitude) | [○](m:Float#magnitude) | [○](m:Rational#magnitude) | [○](m:Complex#magnitude) |
| `modulo` | [○](m:Numeric#modulo) | [○](m:Integer#modulo) | [○](m:Float#modulo) | ○ | ― |
| `nan?` | ― | ― | [○](m:Float#nan?) | ― | ― |
| `negative?` | [○](m:Numeric#negative?) | ○ | [○](m:Float#negative?) | [○](m:Rational#negative?) | ― |
| `next` | ― | [○](m:Integer#next) | ― | ― | ― |
| `next_float` | ― | ― | [○](m:Float#next_float) | ― | ― |
| `nobits?` | ― | [○](m:Integer#nobits?) | ― | ― | ― |
| `nonzero?` | [○](m:Numeric#nonzero?) | ○ | ○ | ○ | ○ |
| `numerator` | [○](m:Numeric#numerator) | [○](m:Integer#numerator) | [○](m:Float#numerator) | [○](m:Rational#numerator) | [○](m:Complex#numerator) |
| `odd?` | ― | [○](m:Integer#odd?) | ― | ― | ― |
| `ord` | ― | [○](m:Integer#ord) | ― | ― | ― |
| `phase` | [○](m:Numeric#phase) | ○ | [○](m:Float#phase) | ○ | [○](m:Complex#phase) |
| `polar` | [○](m:Numeric#polar) | ○ | ○ | ○ | [○](m:Complex#polar) |
| `positive?` | [○](m:Numeric#positive?) | ○ | [○](m:Float#positive?) | [○](m:Rational#positive?) | ― |
| `pow` | ― | [○](m:Integer#pow) | ― | ― | ― |
| `pred` | ― | [○](m:Integer#pred) | ― | ― | ― |
| `prev_float` | ― | ― | [○](m:Float#prev_float) | ― | ― |
| `quo` | [○](m:Numeric#quo) | ○ | ○ | [○](m:Rational#quo) | [○](m:Complex#quo) |
| `rationalize` | ― | [○](m:Integer#rationalize) | [○](m:Float#rationalize) | [○](m:Rational#rationalize) | [○](m:Complex#rationalize) |
| `real` | [○](m:Numeric#real) | ○ | ○ | ○ | [○](m:Complex#real) |
| `real?` | [○](m:Numeric#real?) | ○ | ○ | ○ | [○](m:Complex#real?) |
| `rect` | [○](m:Numeric#rect) | ○ | ○ | ○ | [○](m:Complex#rect) |
| `rectangular` | [○](m:Numeric#rectangular) | ○ | ○ | ○ | [○](m:Complex#rectangular) |
| `remainder` | [○](m:Numeric#remainder) | [○](m:Integer#remainder) | ○ | ○ | ― |
| `round` | [○](m:Numeric#round) | [○](m:Integer#round) | [○](m:Float#round) | [○](m:Rational#round) | ― |
| `size` | ― | [○](m:Integer#size) | ― | ― | ― |
| `step` | [○](m:Numeric#step) | ○ | ○ | ○ | ― |
| `succ` | ― | [○](m:Integer#succ) | ― | ― | ― |
| `times` | ― | [○](m:Integer#times) | ― | ― | ― |
| `to_c` | [○](m:Numeric#to_c) | ○ | ○ | ○ | [○](m:Complex#to_c) |
| `to_f` | ― | [○](m:Integer#to_f) | [○](m:Float#to_f) | [○](m:Rational#to_f) | [○](m:Complex#to_f) |
| `to_i` | ― | [○](m:Integer#to_i) | [○](m:Float#to_i) | [○](m:Rational#to_i) | [○](m:Complex#to_i) |
| `to_int` | [○](m:Numeric#to_int) | [○](m:Integer#to_int) | ○ | ○ | ○ |
| `to_r` | ― | [○](m:Integer#to_r) | [○](m:Float#to_r) | [○](m:Rational#to_r) | [○](m:Complex#to_r) |
| `to_s` | ○ | [○](m:Integer#to_s) | [○](m:Float#to_s) | [○](m:Rational#to_s) | [○](m:Complex#to_s) |
| `truncate` | [○](m:Numeric#truncate) | [○](m:Integer#truncate) | [○](m:Float#truncate) | [○](m:Rational#truncate) | ― |
| `upto` | ― | [○](m:Integer#upto) | ― | ― | ― |
| `zero?` | [○](m:Numeric#zero?) | ○ | [○](m:Float#zero?) | ○ | ○ |
| `\|` | ― | [○](m:Integer#\|) | ― | ― | ― |
| `~` | ― | [○](m:Integer#~) | ― | ― | ― |

### 丸めメソッドの動作一覧

#%#         numbers=[1.9, 1.1, -1.1, -1.9]
#%#         methods=%w(ceil floor round truncate)
#%#
#%#         fmt = "%5s |" + " %10s" * methods.size + "\n"
#%#
#%#         heading = sprintf(fmt, "", *methods)
#%#         puts heading
#%#         puts "-" * heading.size
#%#
#%#         numbers.each {|n|
#%#           printf(fmt, n,
#%#                  *methods.collect {|m| sprintf("%s", n.send(m))})
#%#         }

[m:Numeric#ceil], [m:Numeric#floor], [m:Numeric#round], [m:Numeric#truncate]
のふるまいの違いの表です。左の実数に対して各メソッドを呼ぶと表のような数を返します。

| 実数 | `ceil` | `floor` | `round` | `truncate` |
|-----:|-------:|--------:|--------:|-----------:|
| 1.9  | 2      | 1       | 2       | 1          |
| 1.1  | 2      | 1       | 1       | 1          |
| -1.1 | -1     | -2      | -1      | -1         |
| -1.9 | -1     | -2      | -2      | -1         |

### 丸めメソッドの拡張例

切上げは `ceil`, `floor` を使用して以下のように定義できます。

```ruby title="例"
if n > 0 then
  n.ceil
else
  n.floor
end
```

また、任意桁の切上げ、切捨て、四捨五入を行うメソッドは以下のように定義できます。

```ruby
class Numeric
  def roundup(d=0)
    x = 10**d
    if self > 0
      self.quo(x).ceil * x
    else
      self.quo(x).floor * x
    end
  end

  def rounddown(d=0)
    x = 10**d
    if self < 0
      self.quo(x).ceil * x
    else
      self.quo(x).floor * x
    end
  end

  def roundoff(d=0)
    x = 10**d
    if self < 0
      (self.quo(x) - 0.5).ceil * x
    else
      (self.quo(x) + 0.5).floor * x
    end
  end
end
```

#%#        numbers=[0.19, 0.15, 0.11, -0.11, -0.15, -0.19]
#%#        methods=%w(roundup rounddown roundoff)
#%#        arg=1
#%#
#%#        fmt = "%5s |" + " %10s" * methods.size + "\n"
#%#
#%#        heading = sprintf(fmt, "", *methods)
#%#        puts heading
#%#        puts "-" * heading.size
#%#
#%#        numbers.each {|n|
#%#          printf(fmt, n,
#%#                 *methods.collect {|m| sprintf("%s", n.send(m, arg))})
#%#        }
#%#              |    roundup  rounddown   roundoff
#%#        -----------------------------------------
#%#         0.19 |        0.2        0.1        0.2
#%#         0.15 |        0.2        0.1        0.2
#%#         0.11 |        0.2        0.1        0.1
#%#        -0.11 |       -0.2       -0.1       -0.1
#%#        -0.15 |       -0.2       -0.1       -0.2
#%#        -0.19 |       -0.2       -0.1       -0.2

### 除法と商・剰余 {#division}

`Numeric` には除法（除算；割り算；division）に関するメソッドがいくつもありますが、除法にはいくつか種類があるため、全貌が把握しづらくなっています。
この節では除法の種類を説明し、各メソッドがどの除法に基づいているのかが分かるようにします。

まず用語についてですが、割られる数を被除数（dividend）、割る数を除数（divisor）、割った結果を商（quotient）と言います。

除法は大きく2つに分類できます。

そのうちの一つを、ここでは「普通の除法」と呼ぶことにします。
普通の除法は、被除数を `x`、除数を `y`、商を `q` としたとき、`x == q⋅y` となるよう定義された除法です。
7 割る 2 を 3.5 とする除法は、普通の除法です。

普通の除法における商をここでは「普通の商」と呼ぶことにしましょう。

もう一つの除法は、商が必ず整数になるよう定義されるもので、これを「整除法」と言います。
7 割る 2 を 3 余り 1 とする除法は、整除法です。

整除法における商を特に「整商」と言います。

整除法では、被除数を `x`、除数を `y`、商を `q` としたとき、`x` と `q⋅y` が一致する（つまり割り切れる）とは限りません。
その差 `x − q⋅y` を剰余（余り；remainder）と言います。
整除法は商と剰余がセットで決まる除法なので「剰余付き除法」とも呼ばれます。

しばしば「整除法は整数の世界でしか成り立たない」と誤解されていますが、
2.5 メートルの紐から 0.75 メートルの紐が何本取れて何メートルの半端が出るか、という問題を考えれば、被除数や除数が整数でなくてもよいことが分かります。

```ruby title="例: Float の世界の整商と剰余"
p 2.5.divmod(0.75) # => [3, 0.25]
# 2.5 メートルの紐から 0.75 メートルの紐が 3 本取れて 0.25 メートル余る
```

ただし、複素数の世界では整商・剰余は考えないので、[c:Complex] に `divmod` などのメソッドは定義されていません。

以下では、まず普通の除法に基づくメソッドについて述べます。

普通の商を得るメソッドは [m:Numeric#quo] です。
`quo` の返り値のクラスは、被除数・除数のクラスによって異なります。
例えば、被除数・除数の一方が [c:Integer]、他方が [c:Float] なら返り値は `Float` です。

普通の商を得るメソッドには、[m:Numeric#fdiv] もあります。
これは商を `Float` で返します（被除数・除数の一方が `Complex` のときは `Complex` を返します）。

整数同士の除法の場合、`quo` は厳密値を [c:Rational] で返しますが、
`fdiv` では丸め誤差が生じうることに注意してください。

次に整除法に基づくメソッドについて述べます。

重要なことは、整除法の定義（言い換えれば整商・剰余の定義）がいくつもある、ということです。

しかし、どの定義にも共通していることが二つあります。

それは、被除数を `x`、除数を `y` としたときの整商を `q`、剰余を `r` とすると、第一に、

`x == y * q + r`（ただし `q` は整数）

が成り立つということです。
第二に、剰余 `r` は「半端」ですから、`r` の絶対値は `y` の絶対値より小さくなくてはならないということです。

この二つを満たす整商・剰余の定義は何通りもありますが、
Ruby では、2通りの定義を採用し、剰余について [m:Numeric#modulo] メソッドと [m:Numeric#remainder] メソッドとして実装されています。

`modulo` は、

- `y > 0` のとき `0 <= r <  y`
- `y < 0` のとき `y <  r <= 0`

となるように定められた剰余です。
定義からすぐ分かるとおり、剰余 `r` の符号は除数 `y` の符号と一致します。

`modulo` の別名は `%` で、普通はメソッド呼び出しの形ではなく二項演算子の形で用います。

`modulo` に対応する整商は [m:Numeric#div] です。
これは、普通の商を [m:Numeric#floor] で整数化したものと一致します。

さきほどの例で出てきた [m:Numeric#divmod] は、
`div` と `modulo` の値を一度に配列で返すメソッドです。

一方、`remainder` は

- `x > 0` のとき `0   <= r <  |y|`
- `x < 0` のとき `-|y| <  r <= 0`

となるように定められた剰余です。
定義からすぐ分かるとおり、剰余 `r` の符号は被除数 `x` の符号と一致します。

`remainder` に対応する整商を得るメソッドはありませんが、
`x.quo(y).truncate` で得ることができます。

`x` と `y` の符号が同じとき、`modulo` と `remainder` は一致します。

商を得るメソッドには [m:Numeric#/] もあります。
普通はメソッド呼び出しの形ではなく、二項演算子として用います。
これは被除数・除数のクラスによって挙動が異なります。例えば `Integer` 同士なら `div` と同じ、`Integer` や `Rational` と `Float` なら `quo` と同じ、といった具合です。
被除数のクラスの `/` メソッドの説明をご覧ください。

#%since 3.2
Ruby 3.2 では整商を得るメソッドとして [m:Integer#ceildiv] が追加されました。

`ceildiv` は普通の商を正の無限大に向かって丸めた整商を返します。

`n` 個の物を `m` 個ずつまとめたとき、（半端をまとめたものも含めて）いくつのグループができるかは以下のようにして得られます。

```ruby title="例: n 個を m 個ずつまとめて出来るグループの数"
p n.ceildiv(m)
```

`ceildiv` に対応した剰余を返すメソッドはありません。
#%end

## Instance Methods

### def +@    -> self

`self` を返します。

`Numeric` オブジェクトに対する単項演算子 `+` はこのメソッドの呼び出しになります。

```ruby title="例"
p(+ 10)         # => 10
p(+ (-10))        # => -10
p(+ 0.1)        # => 0.1
p(+ (3r)) # => (3/1)
p(+ (1+3i))     # => (1+3i)
```

### def -@    -> Numeric

`0` から `self` を引いた値を返します。

`self` が実数の場合、符号反転です。

このメソッドは、二項演算子の `-` で `0 - self` として定義されています。

`Numeric` オブジェクトに対する単項演算子 `-` はこのメソッドの呼び出しになります。

#%#noexample Integer、Float、Rational、Complex 各クラスに実装されているため

- **SEE** [m:Integer#-@]、[m:Float#-@]、[m:Rational#-@]、[m:Complex#-@]

### def /(other)    -> Numeric

`self` を `other` で割った値（＝商）を返します。

`Numeric` では定義されておらず、サブクラスの実装によります。

#%#noexample Integer、Float、Rational、Complex 各クラスに実装されているため

- **SEE** [m:Integer#/], [m:Float#/], [m:Rational#/], [m:Complex#/]

### def abs        -> Numeric
### def magnitude  -> Numeric

`self` の絶対値（absolute value）を返します。

```ruby title="例"
p 12.abs       # => 12
p (-34.56).abs # => 34.56
p -34.56.abs   # => 34.56
```

### def ceil   -> Integer

`self` と等しいかより大きな整数のうち最小のものを返します。

[c:Complex] では未定義化されています。

```ruby title="例"
p 1.ceil      # => 1
p 1.2.ceil    # => 2
p (-1.2).ceil # => -1
p (-1.5).ceil # => -1
```

- **SEE** [m:Numeric#floor], [m:Numeric#round], [m:Numeric#truncate]

### def floor(ndigits = 0) -> Integer

`self` と等しいかより小さな整数のうち最大のものを返します。

[c:Complex] では未定義化されています。

- **param** `ndigits` -- 10進数での小数点以下の有効桁数を整数で指定します。
               負の整数を指定した場合、小数点位置から左に少なくとも `n` 個の `0` が並びます。

```ruby title="例"
p 1.floor      # => 1
p 1.2.floor    # => 1
p (-1.2).floor # => -2
p (-1.5).floor # => -2
```

- **SEE** [m:Numeric#ceil], [m:Numeric#round], [m:Numeric#truncate]
- **SEE** [m:Integer#floor]

### def round   -> Integer

`self` ともっとも近い整数を返します。

中央値 `0.5`, `-0.5` はそれぞれ `1`, `-1` に切り上げされます。いわゆる四捨五入ですが、偶数丸めではありません。

[c:Complex] では未定義化されています。

```ruby title="例"
p 1.round      # => 1
p 1.2.round    # => 1
p (-1.2).round # => -1
p (-1.5).round # => -2
```

- **SEE** [m:Numeric#ceil], [m:Numeric#floor], [m:Numeric#truncate]

### def truncate   -> Integer

`0` から `self` までの整数で、`self` にもっとも近い整数を返します。

[c:Complex] では未定義化されています。

```ruby title="例"
p 1.truncate      # => 1
p 1.2.truncate    # => 1
p (-1.2).truncate # => -1
p (-1.5).truncate # => -1
```

- **SEE** [m:Numeric#ceil], [m:Numeric#floor], [m:Numeric#round]

### def coerce(other)    -> [Numeric]

`self` と `other` が同じクラスになるよう、`self` か `other` を変換し `[other, self]` という配列にして返します。

デフォルトでは `self` と `other` を [c:Float] に変換して `[other, self]` という配列にして返します。

`Numeric` のサブクラスは必要に応じてこのメソッドを適切に再定義しなければなりません。

以下は [c:Rational] の `coerce` のソースです。`other` が自身の知らない数値クラスであった場合、`super` を呼んでいることに注意して下さい。

```ruby title="例"
# lib/rational.rb より

def coerce(other)
  if other.kind_of?(Float)
    return other, self.to_f
  elsif other.kind_of?(Integer)
    return Rational.new!(other, 1), self
  else
    super
  end
end
```

数値クラスの算術演算子は通常自分と演算できないクラスをオペランドとして受け取ると `coerce` を使って自分とオペランドを変換した上で演算を行います。
以下は [c:Rational] の `+` メソッドを一部省略したものです。
引数が自身の知らない数値クラスである場合、引数の coerce により `self` を変換してから `+` 演算子を呼んでいます。

```ruby title="例"
# lib/rational.rb より

def + (a)
  if a.kind_of?(Rational)
    # 長いので省略
  elsif a.kind_of?(Integer)
    # 長いので省略
  elsif a.kind_of?(Float)
    Float(self) + a
  else
    x, y = a.coerce(self)
    x + y
  end
end
```

- **param** `other` -- オペランドを数値で指定します。

### def div(other)    -> Integer

`self` を `other` で割った整数の商 `q` を返します。

ここで、商 `q` と余り `r` は、それぞれ

- `self == other * q + r`

と

- `other > 0` のとき:  `0     <= r <  other`
- `other < 0` のとき:  `other <  r <= 0`
- `q` は整数

をみたす数です。
商に対応する余りは [m:Numeric#modulo] で求められます。
`div` はメソッド `/` を呼びだし、`floor` を取ることで計算されます。

メソッド `/` の定義はサブクラスごとの定義を用います。

[c:Complex] では未定義化されています。

- **param** `other` -- `self` に対する除数

```ruby title="例"
p 3.div(2) # => 1
p (-3).div(2) # => -2
p (-3.0).div(2) # => -2
```

### def divmod(other)    -> [Numeric]

`self` を `other` で割った商 `q` と余り `r` を、`[q, r]` という 2 要素の配列にして返します。
商 `q` は常に整数ですが、余り `r` は整数であるとは限りません。

ここで、商 `q` と余り `r` は、

- `self == other * q + r`

と

- `other > 0` のとき: `0     <= r < other`
- `other < 0` のとき: `other <  r <= 0`
- `q` は整数

をみたす数です。

`divmod` が返す商は [m:Numeric#div] と同じです。
また余りは、[m:Numeric#modulo] と同じです。
このメソッドは、メソッド `/` と `%` によって定義されています。

[c:Complex] では未定義化されています。

- **param** `other` -- `self` に対する除数

```ruby title="例"
p 11.divmod(3)       # => [3, 2]
p (11.5).divmod(3.5) # => [3, 1.0]
p 11.divmod(-3)      # => [-4, -1]
p 11.divmod(3.5)     # => [3, 0.5]
p (-11).divmod(3.5)  # => [-4, 3.0]
```

- **SEE** [m:Numeric#div], [m:Numeric#modulo]

### def quo(other)    -> Rational | Float | Complex

`self` を `other` で割った商（quotient）を返します。
整商を得たい場合は [m:Numeric#div] を使ってください。

[m:Numeric#fdiv] が結果を [c:Float] で返すメソッドなのに対して `quo` はなるべく正確な数値を返すことを意図しています。
具体的には有理数の範囲に収まる計算では [c:Rational] の値を返します。
[c:Float] や [c:Complex] が関わるときはそれらのクラスになります。

`Numeric` のサブクラスは必要に応じてこのメソッドを適切に再定義しなければなりません。

- **param** `other` -- `self` に対する除数

```ruby title="例"
p 1.quo(3)    # => (1/3)
p 1.0.quo(3)  # => 0.3333333333333333
p 1.quo(3.0)  # => 0.3333333333333333
p 1.quo(0.5)  # => 2.0

p (1+1i).quo(1)  # => (1+1i)
p 1.quo(1+1i)    # => ((1/2)-(1/2)*i)
```

- **SEE** [m:Numeric#fdiv]

### def fdiv(other)   -> Float | Complex

`self` を `other` で割った商を [c:Float] で返します。
ただし [c:Complex] が関わる場合は例外です。
その場合も成分は `Float` になります。

`self` が [c:Integer] や [c:Rational] で、`other` が虚部を持つ [c:Complex] の場合は、商を [c:Float] に変換できないため [c:RangeError] が発生します。

`Numeric` のサブクラスは必要に応じてこのメソッドを適切に再定義しなければなりません。

- **param** `other` -- `self` に対する除数

```ruby title="例"
p 1.fdiv(3)      # => 0.3333333333333333
p (1+1i).fdiv 1  # => (1.0+1.0i)
1.fdiv(1+1i)   # ~> RangeError: can't convert 0.5-0.5i into Float
```

- **SEE** [m:Numeric#quo]

### def integer?    -> bool

`false` を返します。

[c:Integer] では `true` を返すよう再定義されています。

数値として整数であるかを問うものではありません。

`Numeric` のサブクラスは必要に応じてこのメソッドを適切に再定義しなければなりません。

```ruby title="true を返す例"
p 1.integer? # => true
```

```ruby title="数学的には整数でも false を返す例"
p 1.0.integer?    # => false
p 1r.integer?     # => false
p (1+0i).integer? # => false
```

- **SEE** [m:Numeric#real?]

### def modulo(other)    -> Numeric
### def %(other)         -> Numeric

`self` を `other` で割った余り `r` を返します。

ここで、商 `q` と余り `r` は、

- `self == other * q + r`

と

- `other > 0` のとき `0     <= r <  other`
- `other < 0` のとき `other <  r <= 0`
- `q` は整数

をみたす数です。

余り `r` は、`other` と同じ符号になります。
商 `q` は、[m:Numeric#div]（あるいは `/`）で求められます。
`modulo` はメソッド `%` の呼び出しとして定義されています。

[c:Complex] では未定義化されています。

- **param** `other` -- `self` に対する除数

```ruby title="例"
p 13.modulo(4)       # =>  1
p (11.5).modulo(3.5) # => 1.0
p 13.modulo(-4)      # => -3
p (-13).modulo(4)    # =>  3
p (-13).modulo(-4)   # => -1
p (-11).modulo(3.5)  # => 3.0
```

- **SEE** [m:Numeric#divmod], [m:Numeric#remainder]

### def positive? -> bool

`self` が正の数なら `true` を、そうでないなら `false` を返します。

一般の複素数には正・負の概念が無いので [c:Complex] では未定義化されています。

```ruby title="例"
p 1.positive?  # => true
p 0.positive?  # => false
p -1.positive? # => false
```

- **SEE** [m:Numeric#negative?]

### def negative? -> bool

`self` が負の数なら `true` を、そうでないなら `false` を返します。

一般の複素数には正・負の概念が無いので [c:Complex] では未定義化されています。

```ruby title="例"
p -1.negative? # => true
p 0.negative?  # => false
p 1.negative?  # => false
```

- **SEE** [m:Numeric#positive?]

### def remainder(other)    -> Numeric

`self` を `other` で割った余り `r` を返します。

ここで、商 `q` と余り `r` は、

- `self == other * q + r`

と

- `self > 0` のとき `0        <= r <  |other|`
- `self < 0` のとき `-|other| <  r <= 0`
- `q` は整数

をみたす数です。

`r` の符号は `self` と同じになります。
商 `q` を直接返すメソッドはありません。`self.quo(other).truncate` がそれに相当します。

[c:Complex] では未定義化されています。

- **param** `other` -- `self` に対する除数

```ruby title="例"
p 13.remainder(4)       # =>  1
p (11.5).remainder(3.5) # => 1.0
p 13.remainder(-4)      # =>  1
p (-13).remainder(4)    # => -1
p (-13).remainder(-4)   # => -1
p (-11).remainder(3.5)  # => -0.5
```

- **SEE** [m:Numeric#divmod], [m:Numeric#modulo]

### def nonzero?    -> self | nil

`self` が非ゼロなら `self` を、ゼロなら `nil` を返します。

```ruby title="例"
p 10.nonzero?   # => 10
p 0.nonzero?    # => nil
p 0.0.nonzero?  # => nil
p 0r.nonzero?   # => nil
```

非ゼロのときに `self` を返すので、`self` がゼロのときに他の処理をさせたければ以下のように書けます。

```ruby title="例"
a = %w[z Bb bB bb BB a aA Aa AA A]
b = a.sort { |a, b| (a.downcase <=> b.downcase).nonzero? || a <=> b }
p b # => ["A", "a", "AA", "Aa", "aA", "BB", "Bb", "bB", "bb", "z"]
```

- **SEE** [m:Numeric#zero?]

### def finite? -> bool

`self` の絶対値が有限値なら `true` を、そうでないなら `false` を返します。

```ruby title="例"
p 10.finite?                    # => true
p 3r.finite?                    # => true

p Float::INFINITY.finite?       # => false
p Float::INFINITY.is_a?(Numeric)  # => true
```

- **SEE** [m:Numeric#infinite?]

### def infinite? -> nil

`nil` を返します。

[c:Float] と [c:Complex] では、`self` の絶対値が負の無限大の場合に `-1` を、正の無限大の場合に `1` を、有限値の場合に `nil` を返すよう再定義されています。

```ruby title="例"
p 10.infinite?   # => nil
p (3r).infinite? # => nil
```

- **SEE** [m:Numeric#finite?]、[m:Float#infinite?]、[m:Complex#infinite?]

### def to_int    -> Integer

`self.to_i` と同じです。

```ruby title="例"
p (2+0i).to_int      # => 2
p 3r.to_int          # => 3
```

### def zero?    -> bool

`self` がゼロなら `true` を、そうでないなら `false` を返します。

```ruby title="例"
p 10.zero?              # => false
p 0.zero?               # => true
p 0.0.zero?             # => true
```

- **SEE** [m:Numeric#nonzero?]

### def step(limit, step = 1) {|n| ... }    -> self
### def step(limit, step = 1) -> Enumerator
### def step(limit, step = 1) -> Enumerator::ArithmeticSequence
### def step(by: 1, to: Float::INFINITY) {|n| ... } -> self
### def step(by: 1, to: Float::INFINITY) -> Enumerator
### def step(by: 1, to: Float::INFINITY) -> Enumerator::ArithmeticSequence
### def step(by:, to: -Float::INFINITY) {|n| ... } -> self
### def step(by:, to: -Float::INFINITY) -> Enumerator
### def step(by:, to: -Float::INFINITY) -> Enumerator::ArithmeticSequence

`self` から始め、`step` を足しながら `limit` を越える前までブロックを繰り返します。`step` は負の数も指定できます。また、`limit` や `step` には [c:Float] なども指定できます。

[c:Complex] では未定義化されています。

- **param** `limit` -- ループの上限あるいは下限を数値で指定します。`step` に負の数が指定された場合は、下限として解釈されます。

- **param** `step` -- 各ステップの大きさを数値で指定します。負の数を指定することもできます。

- **param** `to` -- 引数 `limit` と同じですが、省略した場合はキーワード引数 `by` が正の数なら `Float::INFINITY` を、負の数なら `-Float::INFINITY` を指定したとみなされます。

- **param** `by` -- 引数 `step` と同じです。

- **return** -- ブロックが与えられたときは `self` を返します。
- **return** -- ブロックが与えられなかったときは [c:Enumerator] を返します。
- **return** -- 特に `limit`（または `to`）と `step` の両方が `Numeric` または `nil` のときは [c:Enumerator::ArithmeticSequence] を返します。

- **raise** `ArgumentError` -- `step` に `0` を指定した場合に発生します。

#%#このメソッドは、[[c:Fixnum]], [[c:Integer]] から移動しまし
#%#た。これにより [[c:Float]] も `step` できるようになりました。

```ruby title="例"
2.step(5) { |n| p n }
# => 2
#    3
#    4
#    5

1.1.step(1.5, 0.1) { |n| p n }
# => 1.1
#    1.2000000000000002
#    1.3
#    1.4000000000000001
#    1.5

10.step(6, -1) { |n| p n }
# => 10
#    9
#    8
#    7
#    6

3.step(by:2, to:10) { |n| p n }
# => 3
#    5
#    7
#    9
```

注：0.1 は 2 進法の浮動小数点数では正確な表現ができない（2 進法で 0.1 は 0.00011001100.... となる）ので、以下のようなループでは誤差が生じて意図した回数ループしないことがある。`step` はこの誤差を考慮して実装されている。

```ruby title="例"
i = 1.1
while i <= 1.5
  p i
  i += 0.1
end
# => 1.1
#    1.2000000000000002
#    1.3000000000000003
#    1.4000000000000004
# 1.5 が表示されない
```

- **SEE** [m:Integer#downto]

### def <=>(other) -> -1 | 0 | 1 | nil

`self` を `other` と比較し、`self` が `other` より大きければ `1` を、等しければ `0` を、小さければ `-1` を返します。
比較できないときは `nil` を返します。

`Numeric` のサブクラスは必要に応じてこのメソッドを適切に再定義しなければなりません。

`Numeric` オブジェクトを左項とする比較演算子 `<=>` はこのメソッドの呼び出しになります。

- **param** `other` -- 比較対象

```ruby title="例"
p 1 <=> 0   # => 1
p 1 <=> 1   # => 0
p 1 <=> 2   # => -1
p 1 <=> "0" # => nil
```

### def eql?(other) -> bool

`self` と `other` のクラスが等しくかつ `==` メソッドで比較して等しい場合に `true` を返します。
そうでない場合に `false` を返します。

`Numeric` のサブクラスは、`eql?` で比較して等しい数値同士が同じハッシュ値を返すように `hash` メソッドを適切に定義する必要があります。

- **param** `other` -- 比較対象

```ruby title="例"
p 1.eql?(1)    # => true
p 1.eql?(1.0)  # => false
p 1 == 1.0     # => true
```

- **SEE** [m:Object#equal?], [m:Object#eql?], [m:Object#==], [m:Object#===]

### def abs2 -> Numeric

`self` の絶対値（absolute value）の 2 乗を返します。

```ruby title="実数に対する abs2 の例"
# 2 乗と結果は同じ
p 2.abs2    # => 4
p -2.abs2   # => 4
p 2.0.abs2  # => 4.0
p -2.0.abs2 # => 4.0
p 0.5r.abs2 # => (1/4)
```

```ruby title="複素数に対する abs2 の例"
# 虚部が 0 でないときは 2 乗と異なる
p 2i.abs2 # => 4
p (-1+0.5i).abs2 # => 1.25
```

`Numeric` のサブクラスは必要に応じてこのメソッドを適切に再定義しなければなりません。

### def arg   -> 0 | Math::PI
### def angle -> 0 | Math::PI
### def phase -> 0 | Math::PI

`self` の複素数としての偏角（argument）を返します。

`self` が正の実数か `0.0` なら `0`、負の実数か `-0.0` なら [m:Math::PI] となります。
（`-0.0` は [m:Float#negative?] では負とはみなされませんが、`arg` は符号ビットに従います）。

```ruby title="実数に対する arg の例"
p 1.arg    # => 0
p 0.arg    # => 0
p -1.arg   # => 3.141592653589793
p -0.0.arg # => 3.141592653589793
```

```ruby title="複素数に対する arg の例"
p 1i.arg # => 1.5707963267948966
```

`Numeric` のサブクラスは必要に応じてこのメソッドを適切に再定義しなければなりません。

- **SEE** [m:Complex#arg]

### def conj      -> Numeric
### def conjugate -> Numeric

`self` を返します。

[c:Complex] では `self` の共役複素数を返すよう再定義されています。

`Numeric` のサブクラスは必要に応じてこのメソッドを適切に再定義しなければなりません。

```ruby title="例"
p 10.conj     # => 10
p 0.1.conj    # => 0.1
p (2/3r).conj # => (2/3)
```

- **SEE** [m:Complex#conj]

### def denominator -> Integer

`self` を [c:Rational] に変換したときの分母（denominator）を返します。

#%#noexample Integer、Float、Rational、Complex 各クラスに実装されているため

- **SEE** [m:Numeric#numerator]、[m:Integer#denominator]、[m:Float#denominator]、[m:Rational#denominator]、[m:Complex#denominator]

### def imag      -> 0
### def imaginary -> 0

`0` を返します。

[c:Complex] では `self` の虚部を返すよう再定義されています。

```ruby title="例"
p 12.imag   # => 0
p -12.imag  # => 0
p 1.2.imag  # => 0
p -1.2.imag # => 0
```

`Numeric` のサブクラスは必要に応じてこのメソッドを適切に再定義しなければなりません。

- **SEE** [m:Numeric#real]、[m:Complex#imag]

### def numerator -> Integer

`self` を [c:Rational] に変換したときの分子（numerator）を返します。

#%#noexample Integer、Float、Rational、Complex 各クラスに実装されているため

- **SEE** [m:Numeric#denominator]、[m:Integer#numerator]、[m:Float#numerator]、[m:Rational#numerator]、[m:Complex#numerator]

### def polar -> [Numeric, Numeric]

`self` の複素数としての極形式（polar form）を `[self.abs, self.arg]` として返します。

```ruby title="例"
p 1.0.polar  # => [1.0, 0]
p 2.0.polar  # => [2.0, 0]
p -1.0.polar # => [1.0, 3.141592653589793]
p -2.0.polar # => [2.0, 3.141592653589793]
```

`Numeric` のサブクラスは必要に応じてこのメソッドを適切に再定義しなければなりません。

- **SEE** [m:Complex#polar]

### def real     -> Numeric

`self` を返します。

[c:Complex] では `self` の実部を返すよう再定義されています。

`Numeric` のサブクラスは必要に応じてこのメソッドを適切に再定義しなければなりません。

```ruby title="例"
p 10.real             # => 10
p -10.real            # => -10
p 0.1.real            # => 0.1
p (2/3r).real         # => (2/3)
```

- **SEE** [m:Numeric#imag]、[m:Complex#real]

### def real?    -> bool

`true` を返します。

[c:Complex] では `false` を返すよう再定義されています。

つまり、`self` が「実数を表すクラスのインスタンス」であれば `true` を、そうでなければ `false` を返すものです。

「実数であるか」を返すものではありません（例参照）。

`Numeric` のサブクラスは必要に応じてこのメソッドを適切に再定義しなければなりません。

```ruby title="true を返す例"
# Integer, Float, Rational のインスタンスは `true` を返す
p -10.real?    # => true
p 0.1.real?    # => true
p (2/3r).real? # => true
```

```ruby title="false を返す例"
# Complex のインスタンスはたとえ虚部がゼロでも `false` を返す
p Complex(1, 0).real? # => false
```

- **SEE** [m:Numeric#integer?]、[m:Complex#real?]

### def rect        -> [Numeric, Numeric]
### def rectangular -> [Numeric, Numeric]

`[self, 0]` を返します。

[c:Complex] では `[self.real, self.imag]` を返すよう再定義されています。

つまり `self` の直交形式（rectangular form）を `[実部, 虚部]` の形で返すメソッドです。

```ruby title="例"
p 1.rect  # => [1, 0]
p -1.rect # => [-1, 0]
p 1.0.rect  # => [1.0, 0]
p -1.0.rect # => [-1.0, 0]
```

`Numeric` のサブクラスは必要に応じてこのメソッドを適切に再定義しなければなりません。

- **SEE** [m:Complex#rect]

### def to_c -> Complex

`Complex(self, 0)` を返します。

[c:Complex] では `self` を返すよう再定義されています。

つまり、`self` を [c:Complex] に型変換するメソッドです。

```ruby title="例"
p 1.to_c            # => (1+0i)
p -1.to_c           # => (-1+0i)
p 1.0.to_c          # => (1.0+0i)
p (1/2r).to_c       # => ((1/2)+0i)
```

`Numeric` のサブクラスは必要に応じてこのメソッドを適切に再定義しなければなりません。

### def i    -> Complex

`Complex(0, self)` を返します。

[c:Complex] では未定義化されています。

```ruby title="例"
p 10.i           # => (0+10i)
p -10.i          # => (0-10i)
p (0.1).i        # => (0+0.1i)
p (1/2r).i       # => (0+(1/2)*i)
```

---
library: _builtin
---
# class Module < Object

モジュールのクラスです。

## Class Methods

### def constants -> [Symbol]

このメソッドを呼び出した時点で参照可能な定数名の配列を返します。

```ruby title="例"
class C
  FOO = 1
end
p Module.constants   # => [:RUBY_PLATFORM, :STDIN, ..., :C, ...]
                     # 出力中に :FOO は現われない
```

- **SEE** [m:Module#constants], [m:Kernel?.local_variables], [m:Kernel?.global_variables], [m:Object#instance_variables], [m:Module#class_variables]

### def nesting -> [Class, Module]

このメソッドを呼び出した時点でのクラス/モジュールのネスト情
報を配列に入れて返します。

```ruby title="例"
module Company
  module Department
    module Team
      p Module.nesting   # => [Company::Department::Team, Company::Department, Company]
    end
  end
end
```

### def new -> Module
### def new {|mod| ... } -> Module

名前の付いていないモジュールを新しく生成して返します。

ブロックが与えられると生成したモジュールをブロックに渡し、
モジュールのコンテキストでブロックを実行します。

```ruby title="例"
mod = Module.new
mod.module_eval {|m|
  # ...
}
mod
```

と同じです。
ブロックの実行は Module#initialize が行います。

ブロックを与えた場合も生成したモジュールを返します。

このメソッドで生成された直後のモジュールは無名で、
最初にいずれかの定数に代入された時点で名前が確定します
([m:Module#name] を参照)。

```ruby title="例"
m = Module.new
p m               # => #<Module 0lx40198a54>
p m.name          # => nil   # まだ名前は未定
Utils = m
p m.name          # => "Utils"   # 最初に代入された定数名で確定する
Helpers = m
p m.name          # => "Utils"   # 一度確定した名前は変わらない
```

### def used_modules -> [Module]

現在のスコープで using されているすべてのモジュールを配列で返します。
配列内のモジュールの順番は未定義です。

```ruby title="例"
module A
  refine Object do
  end
end

module B
  refine Object do
  end
end

using A
using B
p Module.used_modules
#=> [B, A]
```

#@since 3.2
### def used_refinements -> [Refinement]

現在のスコープで using されているすべての [c:Refinement] を配列で返します。
配列内の順番は未定義です。

[m:Module.used_modules] が refinement を定義しているモジュール自体を返すのに対し、
このメソッドは refinement そのものを返します。

```ruby title="例"
module A
  refine Object do
  end
end

module B
  refine Object do
  end
end

using A
using B
p Module.used_refinements
#=> [#<refinement:Object@B>, #<refinement:Object@A>]
```

- **SEE** [m:Module.used_modules], [m:Module#refinements]
#@end

## Instance Methods

### def <=>(other) -> -1 | 0 | 1 | nil

self と other の継承関係を比較します。

self と other を比較して、
self が other の子孫であるとき -1、
同一のクラス／モジュールのとき 0、
self が other の先祖であるとき 1
を返します。

継承関係にないクラス同士の比較では
nil を返します。

other がクラスやモジュールでなければ
nil を返します。

- **param** `other` -- 比較対象のクラスやモジュール

```ruby title="例"
module Flyable
end
class Bird
  include Flyable
end
class Eagle < Bird
end
class Fish
end
p Bird <=> Flyable      # => -1
p Eagle <=> Bird        # => -1
p Eagle <=> Flyable     # => -1
p Eagle <=> Fish        # => nil
p Fish <=> Eagle        # => nil

p Eagle <=> Object.new  # => nil
```

### def <(other)  -> bool | nil

比較演算子。self が other の子孫である場合、 true を返します。
self が other の先祖か同一のクラス／モジュールである場合、false を返します。
#@# self < other が成立します。

継承関係にないクラス同士の比較では
nil を返します。

- **param** `other` -- 比較対象のモジュールやクラス

- **raise** `TypeError` -- other がクラスやモジュールではない場合に発生します。

```ruby title="例"
module Flyable
end
class Bird
  include Flyable
end
class Eagle < Bird
end
class Fish
end
p Bird < Flyable        # => true
p Eagle < Bird          # => true
p Eagle < Flyable       # => true
p Eagle < Fish          # => nil
p Eagle > Fish          # => nil
#@since 3.4
Flyable < Object.new    # => in '<': compared with non class/module (TypeError)
#@else
Flyable < Object.new    # => in `<': compared with non class/module (TypeError)
#@end
```

### def <=(other) -> bool | nil

比較演算子。self が other の子孫であるか、self と other が
同一クラスである場合、 true を返します。
self が other の先祖である場合、false を返します。

継承関係にないクラス同士の比較では
nil を返します。

- **param** `other` -- 比較対象のモジュールやクラス

- **raise** `TypeError` -- other がクラスやモジュールではない場合に発生します。

- **SEE** [m:Module#<]

```ruby title="例"
module Awesome; end
module Included
  include Awesome
end
module Prepended
  prepend Awesome
end

p Included.ancestors # => [Included, Awesome]
p Awesome <= Included # => false
p Included <= Awesome # => true

p Prepended.ancestors # => [Awesome, Prepended]
p Awesome <= Prepended # => false
p Prepended <= Awesome # => true

p Awesome <= Awesome # => true
p Awesome <= Object # => nil
```

### def >(other)  -> bool | nil

比較演算子。 self が other の先祖である場合、true を返します。
self が other の子孫か同一クラスである場合、false を返します。

継承関係にないクラス同士の比較では
nil を返します。

- **param** `other` -- 比較対象のモジュールやクラス

- **raise** `TypeError` -- other がクラスやモジュールではない場合に発生します。

- **SEE** [m:Module#<]

```ruby title="例"
module Awesome; end
module Included
  include Awesome
end
module Prepended
  prepend Awesome
end

p Included.ancestors # => [Included, Awesome]
p Awesome > Included # => true
p Included > Awesome # => false

p Prepended.ancestors # => [Awesome, Prepended]
p Awesome > Prepended # => true
p Prepended > Awesome # => false

p Awesome > Awesome # => false
p Awesome > Object # => nil
```

### def >=(other) -> bool | nil

比較演算子。self が other の先祖か同一クラスである場合、 true を返します。
self が other の子孫である場合、false を返します。

継承関係にないクラス同士の比較では
nil を返します。

- **param** `other` -- 比較対象のモジュールやクラス

- **raise** `TypeError` -- other がクラスやモジュールではない場合に発生します。

- **SEE** [m:Module#<]

```ruby title="例"
module Awesome; end
module Included
  include Awesome
end
module Prepended
  prepend Awesome
end

p Included.ancestors # => [Included, Awesome]
p Awesome >= Included # => true
p Included >= Awesome # => false

p Prepended.ancestors # => [Awesome, Prepended]
p Awesome >= Prepended # => true
p Prepended >= Awesome # => false

p Awesome >= Awesome # => true
p Awesome >= Object # => nil
```

### def ===(obj) -> bool

指定された obj が self かそのサブクラスのインスタンスであるとき真を返します。
また、obj が self をインクルードしたクラスかそのサブクラスのインスタンスである場合にも
真を返します。上記のいずれでもない場合に false を返します。

言い替えると obj.kind_of?(self) が true の場合、 true を返します。

このメソッドは主に case 文での比較に用いられます。
case ではクラス、モジュールの所属関係をチェックすることになります。

```ruby title="例"
str = String.new
case str
when String     # String === str を評価する
  p true        # => true
end
```

- **param** `obj` -- 任意のオブジェクト

- **SEE** [m:Object#kind_of?], [m:Object#instance_of?], [ref:d:spec/control#case]

### def ancestors -> [Class, Module]

クラス、モジュールのスーパークラスとインクルードしているモジュール
を優先順位順に配列に格納して返します。

```ruby title="例"
module Drivable
end
class Vehicle
  include Drivable
end
class Car < Vehicle
  p ancestors
  p included_modules
  p superclass
end
# => [Car, Vehicle, Drivable, Object, Kernel, BasicObject]
# => [Drivable, Kernel]
# => Vehicle
```

- **SEE** [m:Module#included_modules]

#@include(Module.attr)

### def autoload(const_name, feature) -> nil

定数 const_name を最初に参照した時に feature を [m:Kernel?.require] するように設定します。

const_name が autoload 設定されていて、まだ定義されてない(ロードされていない)ときは、
autoload する対象を置き換えます。
const_name が(autoloadではなく)既に定義されているときは何もしません。

- **param** `const_name` -- [c:String] または [c:Symbol] で指定します。
       なお、const_name には、"::" 演算子を含めることはできません。
       つまり、self の直下に定義された定数しか指定できません。

- **param** `feature` -- [m:Kernel?.require] と同様な方法で autoload する対象を指定する。

```ruby title="例"
# ------- /tmp/zoo.rb ---------
class Zoo
  class Animal
  end
end
# ----- end of /tmp/zoo.rb ----

class Zoo
  autoload :Animal, '/tmp/zoo'
end
p Zoo::Animal # => Zoo::Animal
```

以下のようにモジュールを明示的にレシーバとして呼び出すこともできます。

```ruby title="例"
# ------- /tmp/zoo.rb ---------
class Zoo
  class Animal
  end
end
# ----- end of /tmp/zoo.rb ----

class Zoo
end
Zoo.autoload :Animal, '/tmp/zoo'
p Zoo::Animal # => Zoo::Animal
```

以下のように、autoload したライブラリがネストした定数を定義しない場
合、NameError が発生します。

```ruby title="例"
# ------- /tmp/animal.rb ---------
class Animal
end
# ----- end of /tmp/animal.rb ----

class Zoo
  autoload :Animal, '/tmp/animal.rb'
end
Zoo::Animal
#@since 3.4
# => -:4:in '<main>': uninitialized constant Zoo::Animal (NameError)
#@else
# => -:4:in `<main>': uninitialized constant Zoo::Animal (NameError)
#@end
```

- **SEE** [m:Kernel?.autoload]

### def autoload?(const_name, inherit = true) -> String | nil

autoload 定数がまだ定義されてない(ロードされていない) ときにそのパス名を返します。
また、ロード済みなら nil を返します。

- **param** `const_name` -- [c:String] または [c:Symbol] で指定します。

- **param** `inherit` -- false にすると、スーパークラスや include したモジュールで
       定義された autoload を検索対象にしません。

- **SEE** [m:Kernel?.autoload?]

```ruby title="例"
autoload :Date, 'date'

p autoload?(:Date) # => "date"
Date
p autoload?(:Date) # => nil
p autoload?(:Foo) # => nil
```

```ruby title="例: inherit引数"
class Parent
  autoload :Logger, "logger"
end

class Child < Parent
end

p Child.autoload?(:Logger)        # => "logger"
p Child.autoload?(:Logger, false) # => nil
```

### def class_variables(inherit = true) -> [Symbol]

クラス／モジュールに定義されているクラス変数の名前の配列を返します。

- **param** `inherit` -- false を指定しない場合はスーパークラスやインクルードして
       いるモジュールのクラス変数を含みます。

```ruby title="例"
class One
  @@var1 = 1
end
class Two < One
  @@var2 = 2
end
p One.class_variables        # => [:@@var1]
p Two.class_variables        # => [:@@var2, :@@var1]
p Two.class_variables(false) # => [:@@var2]
```

- **SEE** [m:Module.constants], [m:Kernel?.local_variables], [m:Kernel?.global_variables], [m:Object#instance_variables], [m:Module#constants]

### def const_defined?(name, inherit = true) -> bool

モジュールに name で指定される名前の定数が定義されている時真
を返します。

スーパークラスや include したモジュールで定義された定数を検索対象
にするかどうかは第二引数で制御できます。

- **param** `name` -- [c:String], [c:Symbol] で指定される定数名。

- **param** `inherit` -- false を指定するとスーパークラスや include したモジュールで
       定義された定数は対象にはなりません。

```ruby title="例"
module Kernel
  ANSWER = 42
end

# Object は include したモジュールの定数に対しても
# true を返す
p Object.const_defined?(:ANSWER)        # => true

module Greeting
  HELLO = 'hello'
end
class Object
  include Greeting
end
# ユーザ定義のモジュールに対しても同様
p Object.const_defined?(:HELLO)         # => true

class Robot
  include Greeting
end
# Object 以外でも同様になった
# 第二引数のデフォルト値が true であるため
p Robot.const_defined?(:HELLO)          # => true

# 第二引数を false にした場合
p Robot.const_defined?(:HELLO, false)   # => false
```

### def const_get(name, inherit = true) -> object

name で指定される名前の定数の値を取り出します。

[m:Module#const_defined?] と違って [c:Object] を特別扱いすることはありません。

- **param** `name` -- 定数名。[c:String] か [c:Symbol] で指定します。
            完全修飾名を指定しなかった場合はモジュールに定義されている
            name で指定される名前の定数の値を取り出します。

- **param** `inherit` -- false を指定するとスーパークラスや include したモジュールで
       定義された定数は対象にはなりません。

- **raise** `NameError` -- 定数が定義されていないときに発生します。

```ruby title="例"
module Loggable
  LEVEL = 1
end
class Object
  include Loggable
end
# Object では include されたモジュールに定義された定数を見付ける
p Object.const_get(:LEVEL)            # => 1

class Widget
  include Loggable
end
# Object以外でも同様
p Widget.const_get(:LEVEL)            # => 1
# 定義されていない定数
Widget.const_get(:NOT_DEFINED)        # => raise NameError
# 第二引数に false を指定すると自分自身に定義された定数から探す
Widget.const_get(:LEVEL, false)       # => raise NameError
# 完全修飾名を指定すると include や自分自身へ定義されていない場合でも参照できる
p Class.const_get("Loggable::LEVEL")  # => 1
```

### def const_missing(name)

定義されていない定数を参照したときに Ruby インタプリタが
このメソッドを呼びます。

- **param** `name` -- 参照した定数名の [c:Symbol]

- **raise** `NameError` -- このメソッドを呼び出した場合、デフォルトで発生する例外

```ruby title="例"
class Application
  def Application.const_missing(id)
    warn "undefined constant #{id.inspect}"
  end

  Timezone
end
Application::Timezone

# => undefined constant :Timezone
#    undefined constant :Timezone
```

### def const_set(name, value) -> object

モジュールに name で指定された名前の定数を value とい
う値として定義し、value を返します。

そのモジュールにおいてすでにその名前の定数が定義されている場合、警
告メッセージが出力されます。

- **param** `name` --  [c:Symbol],[c:String] で定数の名前を指定します。
- **param** `value` -- セットしたい値を指定します。

```ruby title="例"
module Config; end

# Symbolを指定した場合
Config.const_set(:VERSION, 123)
p Config::VERSION # => 123

# Stringを指定した場合
Config.const_set('NAME', 'abc')
p Config::NAME # => "abc"

# 既に定義されている定数の名前を指定した場合
Config.const_set('NAME', '123')
# warning: already initialized constant Config::NAME
# warning: previous definition of NAME was here
# => "123"

# 不適切な定数名を指定した場合
Config.const_set('name', 1) # ~> NameError: wrong constant name name
```

### def const_source_location(name, inherited = true)   -> [String, Integer]

name で指定した定数の定義を含むソースコードのファイル名と行番号を配列で返します。

- **param** `name` --  [c:Symbol],[c:String] で定数の名前を指定します。
- **param** `inherited` -- true を指定するとスーパークラスや include したモジュールで定義された定数が対象にはなります。false を指定した場合 対象にはなりません。
- **return** -- ソースコードのファイル名と行番号を配列で返します。
        指定した定数が見つからない場合は nil を返します。
        定数は見つかったがソースファイルが見つからなかった場合は空の配列を返します。

```ruby title="例"
# test.rb:
class A         # line 1
  C1 = 1
  C2 = 2
end

module M        # line 6
  C3 = 3
end

class B < A     # line 10
  include M
  C4 = 4
end

class A # 継続して A を定義する
  C2 = 8 # 定数を再定義する
end

p B.const_source_location('C4')           # => ["test.rb", 12]
p B.const_source_location('C3')           # => ["test.rb", 7]
p B.const_source_location('C1')           # => ["test.rb", 2]

p B.const_source_location('C3', false)    # => nil  -- include したモジュールは検索しない

p A.const_source_location('C2')           # => ["test.rb", 16] -- 最後に定義された位置を返す

p Object.const_source_location('B')       # => ["test.rb", 10] -- Object はトップレベルの定数を検索する
p Object.const_source_location('A')       # => ["test.rb", 1] -- クラスが再定義された場合は最初の定義位置を返す

p B.const_source_location('A')            # => ["test.rb", 1]  -- Object を継承している為
p M.const_source_location('A')            # => ["test.rb", 1]  -- Object は継承していないが追加で modules をチェックする

p Object.const_source_location('A::C1')   # => ["test.rb", 2]  -- ネストの指定もサポートしている
p Object.const_source_location('String')  # => []  -- 定数は C のコードで定義されている
```

### def constants(inherit = true) -> [Symbol]

そのモジュール(またはクラス)で定義されている定数名の配列を返します。

inherit に真を指定すると
スーパークラスやインクルードしているモジュールの定数も含みます。
[c:Object] のサブクラスの場合、Objectやそのスーパークラスで定義されている
定数は含まれません。 Object.constants とすると Object クラスで定義された
定数の配列が得られます。

得られる定数の順序は保証されません。

- **param** `inherit` -- true を指定するとスーパークラスや include したモジュールで
       定義された定数が対象にはなります。false を指定した場合 対象にはなりません。

- **SEE** [m:Module.constants], [m:Kernel?.local_variables], [m:Kernel?.global_variables], [m:Object#instance_variables], [m:Module#class_variables]

```ruby title="Module.constants と Module#constants の違い"
# 出力の簡略化のため起動時の定数一覧を取得して後で差し引く
$clist = Module.constants

class Circle
  PI = 3.14
end
class Shape
  SIDES = 4

  # Shape は SIDES を含む
  p constants                         # => [:SIDES]
  # 出力に PI は含まれない
  p Module.constants - $clist         # => [:SIDES, :Circle, :Shape]
  class Square
    # Square は定数を含まない
    p constants                       # => []

    # ネストしたクラスでは、外側のクラスで定義した定数は
    # 参照可能なので、SIDES は、Module.constants には含まれる
    # (クラス Square も Shape の定数なので同様)
    p Module.constants - $clist       # => [:Square, :SIDES, :Circle, :Shape]
  end
end
```

### def deprecate_constant(*name) -> self

name で指定した定数を deprecate に設定します。
deprecate に設定した定数を参照すると警告メッセージが表示されます。

Ruby 2.7.2 から Warning[:deprecated] のデフォルト値が false に変更になったため、
デフォルトでは警告が表示されません。

コマンドラインオプション(詳細は[ref:d:spec/rubycmd#cmd_option]参照)で、
「-w」か「-W2」などを指定するか、実行中に「Warning[:deprecated] = true」で
変更すると表示されるようになります。

「$VERBOSE = true」は「Warning[:deprecated]」に影響しないため、
表示されるかどうかは変わりません。

- **param** `name` -- 0 個以上の [c:String] か [c:Symbol] を指定します。

- **raise** `NameError` -- 存在しない定数を指定した場合に発生します。

- **return** -- self を返します。

```ruby title="例"
FOO = 123
p Object.deprecate_constant(:FOO) # => Object

FOO
# warning: constant ::FOO is deprecated
# => 123

Object.deprecate_constant(:BAR)
# NameError: constant Object::BAR not defined
```

### def freeze -> self

モジュールを凍結（内容の変更を禁止）します。

凍結したモジュールにメソッドの追加など何らかの変更を加えようとした場合に
[c:FrozenError]
が発生します。

- **SEE** [m:Object#freeze]

```ruby title="例"
module Settings; end
Settings.freeze

module Settings
  def foo; end
end # ~> FrozenError: can't modify frozen module: Settings
```

#@include(Module.include)

### def include?(mod) -> bool

self かその親クラス / 親モジュールがモジュール mod を
インクルードしていれば true を返します。

- **param** `mod` -- [c:Module] を指定します。

```ruby title="例"
module M
end
class C1
  include M
end
class C2 < C1
end

p C1.include?(M)   # => true
p C2.include?(M)   # => true
```

### def included_modules -> [Module]

self にインクルードされているモジュールの配列を返します。

```ruby title="例"
module Mixin
end

module Outer
  include Mixin
end

p Mixin.included_modules #=> []
p Outer.included_modules #=> [Mixin]
```

- **SEE** [m:Module#ancestors]

### def instance_method(name) -> UnboundMethod

self のインスタンスメソッド name をオブジェクト化した [c:UnboundMethod] を返します。

- **param** `name` -- メソッド名を [c:Symbol] または [c:String] で指定します。

- **raise** `NameError` -- self に存在しないメソッドを指定した場合に発生します。

- **SEE** [m:Module#public_instance_method], [m:Object#method]

```ruby title="例"
class Interpreter
  def do_a() print "there, "; end
  def do_d() print "Hello ";  end
  def do_e() print "!\n";     end
  def do_v() print "Dave";    end
  Dispatcher = {
    "a" => instance_method(:do_a),
    "d" => instance_method(:do_d),
    "e" => instance_method(:do_e),
    "v" => instance_method(:do_v)
  }
  def interpret(string)
    string.each_char {|b| Dispatcher[b].bind(self).call }
  end
end

interpreter = Interpreter.new
interpreter.interpret('dave')
# => Hello there, Dave!
```

### def method_defined?(name, inherit=true) -> bool

モジュールにインスタンスメソッド name が定義されており、
かつその可視性が public または protected であるときに
true を返します。

- **param** `name` -- [c:Symbol] か [c:String] を指定します。
- **param** `inherit` -- 真を指定するとスーパークラスや include したモジュールで
       定義されたメソッドも対象になります。

- **SEE** [m:Module#public_method_defined?], [m:Module#private_method_defined?], [m:Module#protected_method_defined?]

```ruby title="例"
module A
  def method1()  end
  def protected_method1()  end
  protected :protected_method1
end
class B
  def method2()  end
  def private_method2()  end
  private :private_method2
end
class C < B
  include A
  def method3()  end
end

p A.method_defined? :method1            #=> true
p C.method_defined? "method1"           #=> true
p C.method_defined? "method2"           #=> true
p C.method_defined? "method2", true     #=> true
p C.method_defined? "method2", false    #=> false
p C.method_defined? "method3"           #=> true
p C.method_defined? "protected_method1" #=> true
p C.method_defined? "method4"           #=> false
p C.method_defined? "private_method2"   #=> false
```

### def module_eval(expr, fname = "(eval)", lineno = 1) -> object
### def module_eval{|mod| ... }                         -> object
### def class_eval(expr, fname = "(eval)", lineno = 1)  -> object
### def class_eval{|mod| ... }                          -> object

モジュールのコンテキストで文字列 expr またはモジュール自身をブロックパラメータとするブロックを
評価してその結果を返します。

モジュールのコンテキストで評価するとは、実行中そのモジュールが self になるということです。
つまり、そのモジュールの定義式の中にあるかのように実行されます。

ただし、ローカル変数は module_eval/class_eval の外側のスコープと共有します。

定数とクラス変数のスコープは、文字列が与えられた場合とブロックが与えられた場合で挙動が異なります。
文字列が与えられた場合には、定数とクラス変数のスコープは自身のモジュール定義式内と同じスコープになります。
ブロックが与えられた場合には、定数とクラス変数のスコープはブロックの外側のスコープになります。

- **param** `expr` -- 評価される文字列。

- **param** `fname` -- 文字列を指定します。ファイル fname に文字列 expr が書かれているかのように実行されます。
             スタックトレースの表示などを差し替えることができます。

- **param** `lineno` -- 文字列を指定します。行番号 lineno から文字列 expr が書かれているかのように実行されます。
              スタックトレースの表示などを差し替えることができます。

```ruby title="例"
class C
end
a = 1
C.class_eval %Q{
  def m                   # メソッドを動的に定義できる。
    return :m, #{a}
  end
}

p C.new.m        #=> [:m, 1]
```

```ruby title="定数のスコープが異なる例"
class C
end

# ブロックが渡された場合は、ブロックの外側のスコープになる。
# つまり、この場合はトップレベルに定数 X を定義する。
C.class_eval { X = 1 }

# 文字列が渡された場合は、モジュール定義式内と同じスコープになる。つまり、この場合は
# class C
#   X = 2
# end
# と書いたのと同じ意味になる。
C.class_eval 'X = 2'

p X    #=> 1
p C::X #=> 2
```

- **SEE** [m:BasicObject#instance_eval], [m:Module.new], [m:Kernel?.eval]

### def module_exec(*args) {|*vars| ... }       -> object
### def class_exec(*args) {|*vars| ... }        -> object

与えられたブロックを指定された args を引数としてモジュールのコンテキストで評価します。

モジュールのコンテキストで評価するとは、実行中そのモジュールが self になるということです。
つまり、そのモジュールの定義式の中にあるかのように実行されます。

ローカル変数、定数とクラス変数のスコープはブロックの外側のスコープになります。

- **param** `args` -- ブロックに渡す引数を指定します。

```ruby title="例"
class Thing
end
c = 1

Thing.class_exec{
  def hello() 
    "Hello there!" 
  end

  define_method(:foo) do   # ローカル変数がブロックの外側を参照している
    c
  end
}

t = Thing.new
p t.hello()            #=> "Hello there!"
p t.foo()              #=> 1
```

- **SEE** [m:Module#module_eval], [m:Module#class_eval]

### def name -> String | nil
### def to_s -> String
### def inspect -> String
{: since=""}

モジュールやクラスの名前を文字列で返します。

このメソッドが返す「モジュール / クラスの名前」とは、
より正確には「クラスパス」を指します。
クラスパスとは、ネストしているモジュールすべてを
「::」を使って表示した名前のことです。
クラスパスの例としては「CGI::Session」「Net::HTTP」が挙げられます。

[m:Module.new] や [m:Class.new] で生成した直後の無名のモジュール /
クラスは、最初にいずれかの定数に代入された時点で名前が確定します。
一度確定した名前は、その定数を remove_const で取り除いたり、
そのモジュール / クラスを別の定数へ代入し直したりしても変わりません。
返り値の文字列は freeze されています。

- **return** -- 名前のないモジュール / クラスに対しては、name は nil を、それ以外はオブジェクト ID の文字列を返します。

```ruby title="例"
module A
  module B
  end

  p B.name  #=> "A::B"

  class C
  end
end

p A.name    #=> "A"
p A::B.name #=> "A::B"
p A::C.name #=> "A::C"

# 名前のないモジュール / クラス
p Module.new.name   #=> nil
p Class.new.name    #=> nil
p Module.new.to_s   #=> "#<Module:0x00007f90b09112c8>"
p Class.new.to_s    #=> "#<Class:0x00007fa5c40b41b0>"

# 名前は最初に代入された定数で確定し、以後は変わらない
c = Class.new
p c.name         #=> nil
Foo = c
p c.name         #=> "Foo"
Bar = c
p c.name         #=> "Foo"
p c.name.frozen? #=> true
```

#@since 3.3
### def set_temporary_name(string) -> self
### def set_temporary_name(nil) -> self

モジュール / クラスに一時的な名前を設定します。self を返します。

設定した名前は [m:Module#name] や [m:Module#inspect] の結果に反映され、
そのモジュール / クラスのインスタンスや定数、メソッドの表示にも使われます。
定数に代入せずに、動的に生成したモジュール / クラスを区別したい場合に便利です。

引数に nil を指定すると、再び無名の状態に戻ります。

定数に代入されて永続的な名前が付くと、一時的な名前は破棄されます。
また、既に永続的な名前を持つモジュール / クラスには設定できません。

- **param** `string` -- 一時的な名前を文字列で指定します。
             永続的な名前と紛らわしくならないよう、クラスパスとして
             有効な文字列は指定できません。nil を指定すると無名に戻ります。

- **raise** `ArgumentError` -- string がクラスパスとして有効な文字列(`Foo` や
             `Foo::Bar` など)である場合や、空文字列である場合に発生します。

- **raise** `RuntimeError` -- 既に永続的な名前を持つモジュール / クラスに対して
             呼び出した場合に発生します。

```ruby title="例"
m = Module.new
p m.name                          # => nil

m.set_temporary_name("<my temp>")
p m.name                          # => "<my temp>"

m.set_temporary_name(nil)
p m.name                          # => nil
```

```ruby title="例: 定数に代入すると永続的な名前になる"
m = Module.new
m.set_temporary_name("<my temp>")
p m.name # => "<my temp>"

MyModule = m
p m.name # => "MyModule"
```

```ruby title="例: 設定できない名前"
Module.new.set_temporary_name("Foo")      # ~> ArgumentError
Module.new.set_temporary_name("Foo::Bar") # ~> ArgumentError
Module.new.set_temporary_name("")         # ~> ArgumentError
String.set_temporary_name("<x>")          # ~> RuntimeError
```

- **SEE** [m:Module#name]
#@end

### def instance_methods(inherited_too = true) -> [Symbol]

そのモジュールで定義されている public および protected メソッド名
の一覧を配列で返します。

- **param** `inherited_too` -- false を指定するとそのモジュールで定義されているメソッドのみ返します。

- **SEE** [m:Object#methods], [m:Module#public_instance_methods], [m:Module#private_instance_methods], [m:Module#protected_instance_methods]

```ruby title="例1"
class Cat
  private;   def private_foo()   end
  protected; def protected_foo() end
  public;    def public_foo()    end
end

# あるクラスのインスタンスメソッドの一覧を得る
p Cat.instance_methods(false)
p Cat.public_instance_methods(false)
p Cat.private_instance_methods(false)
p Cat.protected_instance_methods(false)

class Kitten < Cat
end
```

```text title="実行結果"
[:protected_foo, :public_foo]
[:public_foo]
[:private_foo]
[:protected_foo]
```

```ruby title="例2"
class Dog
  private;   def private_foo()   end
  protected; def protected_foo() end
  public;    def public_foo()    end
end

# あるクラスのインスタンスメソッドの一覧を得る。
# 親のクラスのインスタンスメソッドも含めるため true を指定して
# いるが、Object のインスタンスメソッドは一覧から排除している。
p Dog.instance_methods(true)           - Object.instance_methods(true)
p Dog.public_instance_methods(true)    - Object.public_instance_methods(true)
p Dog.private_instance_methods(true)   - Object.private_instance_methods(true)
p Dog.protected_instance_methods(true) - Object.protected_instance_methods(true)
```

```text title="実行結果"
[:protected_foo, :public_foo]
[:public_foo]
[:private_foo]
[:protected_foo]
```

#@since 3.2
### def undefined_instance_methods -> [Symbol]

そのモジュールで [m:Module#undef_method] によって未定義にされた
インスタンスメソッド名の一覧を配列で返します。

祖先で未定義にされたメソッドは含まれません。

```ruby title="例"
class Foo
  def bar; end
  def baz; end
end

class Sub < Foo
  undef bar
end

p Sub.undefined_instance_methods # => [:bar]
p Foo.undefined_instance_methods # => []
```

- **SEE** [m:Module#undef_method], [m:Module#instance_methods]
#@end

#@since 3.2
### def refinements -> [Refinement]

self の中で [m:Module#refine] によって定義された [c:Refinement] の
一覧を配列で返します。

```ruby title="例"
module A
  refine Integer do
  end

  refine String do
  end
end

p A.refinements
#=> [#<refinement:Integer@A>, #<refinement:String@A>]
```

- **SEE** [m:Module#refine], [m:Module.used_refinements]
#@end

### def public_instance_method(name) -> UnboundMethod

self の public インスタンスメソッド name をオブジェクト化した [c:UnboundMethod] を返します。

- **param** `name` -- メソッド名を [c:Symbol] または [c:String] で指定します。

- **raise** `NameError` -- 定義されていないメソッド名や、
       protected メソッド名、 private メソッド名を引数として与えると発生します。

```ruby title="例"
p Kernel.public_instance_method(:object_id) #=> #<UnboundMethod: Kernel#object_id>
#@since 3.4
Kernel.public_instance_method(:p)         #   method 'p' for module 'Kernel' is private (NameError)
#@else
Kernel.public_instance_method(:p)         #   method `p' for module `Kernel' is private (NameError)
#@end
```

- **SEE** [m:Module#instance_method],[m:Object#public_method]

### def public_instance_methods(inherited_too = true) -> [Symbol]

そのモジュールで定義されている public メソッド名
の一覧を配列で返します。

- **param** `inherited_too` -- false を指定するとそのモジュールで定義されているメソッドのみ返します。

#@#noexample 参照先のModule#instance_methodsにサンプルが書かれているため

- **SEE** [m:Object#public_methods], [m:Module#instance_methods], [m:Module#private_instance_methods], [m:Module#protected_instance_methods]

### def private_instance_methods(inherited_too = true) -> [Symbol]

そのモジュールで定義されている private メソッド名
の一覧を配列で返します。

- **param** `inherited_too` -- false を指定するとそのモジュールで定義されているメソッドのみ返します。

- **SEE** [m:Object#private_methods], [m:Module#instance_methods], [m:Module#public_instance_methods], [m:Module#protected_instance_methods]

```ruby title="例"
module Taggable
  def foo; end
  private def bar; end
end

module Sortable
  include Taggable

  def baz; end
  private def qux; end
end

p Sortable.private_instance_methods # => [:qux, :bar]
p Sortable.private_instance_methods(false) # => [:qux]
```

### def protected_instance_methods(inherited_too = true) -> [Symbol]

そのモジュールで定義されている protected メソッド名
の一覧を配列で返します。

- **param** `inherited_too` -- false を指定するとそのモジュールで定義されているメソッドのみ返します。

#@#noexample 参照先のModule#instance_methodsにサンプルが書かれているため

- **SEE** [m:Object#protected_methods], [m:Module#instance_methods], [m:Module#public_instance_methods], [m:Module#private_instance_methods]

### def private_class_method(*name) -> self
### def private_class_method(names) -> self

name で指定したクラスメソッド (クラスの特異メソッド) の
可視性を private に変更します。

- **param** `name` --  0 個以上の [c:String] または [c:Symbol] を指定します。
- **param** `names` -- 0 個以上の [c:String] または [c:Symbol] を [c:Array] で指定します。

```ruby title="例"
module Gadget
  def self.foo; end
end

p Gadget.singleton_class.private_method_defined?(:foo) # => false
p Gadget.private_class_method(:foo) # => Gadget
p Gadget.singleton_class.private_method_defined?(:foo) # => true
```

### def private_constant(*name) -> self

name で指定した定数の可視性を private に変更します。

- **param** `name` -- 0 個以上の [c:String] か [c:Symbol] を指定します。

- **raise** `NameError` -- 存在しない定数を指定した場合に発生します。

- **return** -- self を返します。

#@since 3.2
- **SEE** [m:Module#public_constant]
#@else
- **SEE** [m:Module#public_constant], [m:Object#untrusted?]
#@end

```ruby title="例"
module Api
  VERSION = '1.0'
  class Client; end
  SECRET = 'token'
  class Internal; end

  private_constant :SECRET
  private_constant :Internal
end

p Api::VERSION  # => "1.0"
p Api::Client   # => Api::Client
Api::SECRET     # ~> NameError: private constant Api::SECRET referenced
Api::Internal   # ~> NameError: private constant Api::Internal referenced
```

### def public_class_method(*name) -> self
### def public_class_method(names) -> self

name で指定したクラスメソッド (クラスの特異メソッド) の
可視性を public に変更します。

- **param** `name` --  0 個以上の [c:String] または [c:Symbol] を指定します。
- **param** `names` -- 0 個以上の [c:String] または [c:Symbol] を [c:Array] で指定します。

```ruby title="例"
class Factory
  def self.foo
    "foo"
  end

  private_class_method :foo
end

#@if("3.4" <= version)
Factory.foo # NoMethodError: private method 'foo' called for class Factory
#@end
#@if("3.3" <= version and version < "3.4")
Factory.foo # NoMethodError: private method `foo' called for class Factory
#@end
#@if(version < "3.3")
Factory.foo # NoMethodError: private method `foo' called for Factory:Class
#@end

p Factory.public_class_method(:foo) # => Factory
p Factory.foo # => "foo"
```

### def public_constant(*name) -> self

name で指定した定数の可視性を public に変更します。

- **param** `name` -- 0 個以上の [c:String] か [c:Symbol] を指定します。

- **raise** `NameError` -- 存在しない定数を指定した場合に発生します。

- **return** -- self を返します。

```ruby title="例"
module SampleModule
  class SampleInnerClass
  end

  # => 非公開クラスであることを明示するために private にする
  private_constant :SampleInnerClass
end

begin
  SampleModule::SampleInnerClass
rescue => e
  e # => #<NameError: private constant SampleModule::SampleInnerClass referenced>
end

module SampleModule
  # => 非公開クラスであることは承知で利用するために public にする
  public_constant :SampleInnerClass
end

p SampleModule::SampleInnerClass # => SampleModule::SampleInnerClass
```

#@since 3.2
- **SEE** [m:Module#private_constant]
#@else
- **SEE** [m:Module#private_constant], [m:Object#untrusted?]
#@end

### def private_method_defined?(name, inherit=true) -> bool

インスタンスメソッド name がモジュールに定義されており、
しかもその可視性が private であるときに true を返します。
そうでなければ false を返します。

- **param** `name` -- [c:Symbol] か [c:String] を指定します。
- **param** `inherit` -- 真を指定するとスーパークラスや include したモジュールで
       定義されたメソッドも対象になります。

- **SEE** [m:Module#method_defined?], [m:Module#public_method_defined?], [m:Module#protected_method_defined?]

```ruby title="例"
module A
  def method1()  end
end
class B
  private
  def method2()  end
end
class C < B
  include A
  def method3()  end
end

p A.method_defined? :method1                 #=> true
p C.private_method_defined? "method1"        #=> false
p C.private_method_defined? "method2"        #=> true
p C.private_method_defined? "method2", true  #=> true
p C.private_method_defined? "method2", false #=> false
p C.method_defined? "method2"                #=> false
```

### def protected_method_defined?(name, inherit=true) -> bool

インスタンスメソッド name がモジュールに定義されており、
しかもその可視性が protected であるときに true を返します。
そうでなければ false を返します。

- **param** `name` -- [c:Symbol] か [c:String] を指定します。
- **param** `inherit` -- 真を指定するとスーパークラスや include したモジュールで
       定義されたメソッドも対象になります。

- **SEE** [m:Module#method_defined?], [m:Module#public_method_defined?], [m:Module#private_method_defined?]

```ruby title="例"
module A
  def method1()  end
end
class B
  protected
  def method2()  end
end
class C < B
  include A
  def method3()  end
end

p A.method_defined? :method1                  #=> true
p C.protected_method_defined? "method1"       #=> false
p C.protected_method_defined? "method2"       #=> true
p C.protected_method_defined? "method2", true #=> true
p C.protected_method_defined? "method2", false  #=> false
p C.method_defined? "method2"                 #=> true
```

### def public_method_defined?(name, inherit=true) -> bool

インスタンスメソッド name がモジュールに定義されており、
しかもその可視性が public であるときに true を返します。
そうでなければ false を返します。

- **param** `name` -- [c:Symbol] か [c:String] を指定します。
- **param** `inherit` -- 真を指定するとスーパークラスや include したモジュールで
       定義されたメソッドも対象になります。

- **SEE** [m:Module#method_defined?], [m:Module#private_method_defined?], [m:Module#protected_method_defined?]

```ruby title="例"
module A
  def method1()  end
end
class B
  protected
  def method2()  end
end
class C < B
  include A
  def method3()  end
end

p A.method_defined? :method1               #=> true
p C.public_method_defined? "method1"       #=> true
p C.public_method_defined? "method1", true #=> true
p C.public_method_defined? "method1", false  #=> true
p C.public_method_defined? "method2"       #=> false
p C.method_defined? "method2"              #=> true
```

### def class_variable_defined?(name) -> bool

name で与えられた名前のクラス変数がモジュールに存在する場合 true を
返します。
#@# Returns true if the given class variable is defined in obj.

- **param** `name` -- [c:Symbol] か [c:String] を指定します。

```ruby title="例"
class Fred
  @@foo = 99
end
p Fred.class_variable_defined?(:@@foo)  #=> true
p Fred.class_variable_defined?(:@@bar)  #=> false
p Fred.class_variable_defined?('@@foo')  #=> true
p Fred.class_variable_defined?('@@bar')  #=> false
```

### def class_variable_get(name) -> object

クラス／モジュールに定義されているクラス変数 name の値を返します。

- **param** `name` -- [c:String] または [c:Symbol] を指定します。

- **raise** `NameError` -- クラス変数 name が定義されていない場合、発生します。

```ruby title="例"
class Fred
  @@foo = 99
end

def Fred.foo
  class_variable_get(:@@foo)
end

p Fred.foo #=> 99
```

### def class_variable_set(name, val) -> object

クラス／モジュールにクラス変数 name を定義して、その値として
val をセットします。val を返します。

- **param** `name` -- [c:String] または [c:Symbol] を指定します。

```ruby title="例"
class Fred
  @@foo = 99
  def foo
    @@foo
  end
end

def Fred.foo(val)
  class_variable_set(:@@foo, val)
end

p Fred.foo(101)   # => 101
p Fred.new.foo    # => 101
```

### def remove_class_variable(name) -> object

引数で指定したクラス変数を取り除き、そのクラス変数に設定さ
れていた値を返します。

- **param** `name` -- [c:String] または [c:Symbol] を指定します。

- **return** -- 引数で指定されたクラス変数に設定されていた値を返します。

- **raise** `NameError` -- 引数で指定されたクラス変数がそのモジュールやクラスに定義されていない場合に発生します。

```ruby title="例"
class Counter
  @@count = 1
  p remove_class_variable(:@@count) # => 1
  @@count     # => uninitialized class variable @@count in Counter (NameError)
end
```

- **SEE** [m:Module#remove_const], [m:Object#remove_instance_variable]

### def singleton_class? -> bool

self が特異クラスの場合に true を返します。そうでなければ false を返し
ます。

```ruby title="例"
class C
end
p C.singleton_class?                # => false
p C.singleton_class.singleton_class?  # => true
```

#@include(Module.prepend)
#@include(Module.alias_method)
#@include(Module.define_method)
#@include(Module.remove_method)
#@include(Module.undef_method)

## Private Instance Methods

### def append_features(module_or_class) -> self

モジュール(あるいはクラス)に self の機能を追加します。

このメソッドは [m:Module#include] の実体であり、
include を Ruby で書くと以下のように定義できます。

```ruby title="例"
def include(*modules)
  modules.reverse_each do |mod|
    # append_features や included はプライベートメソッドなので
    # 直接 mod.append_features(self) などとは書けない
    mod.__send__(:append_features, self)
    mod.__send__(:included, self)
  end
end
```

- **SEE** [m:Module#included]

### def extend_object(obj) -> object

[m:Object#extend] の実体です。オブジェクトにモジュールの機能を追加します。

[m:Object#extend] は、Ruby で書くと以下のように定義できます。

```ruby title="例"
def extend(*modules)
  modules.reverse_each do |mod|
    # extend_object や extended はプライベートメソッドなので
    # 直接 mod.extend_object(self) などとは書けない
    mod.__send__(:extend_object, self)
    mod.__send__(:extended, self)
  end
end
```

extend_object のデフォルトの実装では、self に定義されて
いるインスタンスメソッドを obj の特異メソッドとして追加します。

- **param** `obj` -- self の機能を追加するオブジェクトを指定します。

- **return** -- obj で指定されたオブジェクトを返します。

- **SEE** [m:Module#extended]

### def extended(obj) -> ()

self が他のオブジェクト に [m:Object#extend] されたときに
呼ばれます。引数には extend を行ったオブジェクトが渡されます。

- **param** `obj` -- [m:Object#extend] を行ったオブジェクト

```ruby title="例"
module Debuggable
  def self.extended(obj)
    p "#{obj} extend #{self}"
  end
end

Object.new.extend Debuggable

# => "#<Object:0x401cbc3c> extend Debuggable"
```

- **SEE** [m:Module#extend_object]

### def included(class_or_module) -> ()

self が [m:Module#include] されたときに対象のクラスまたはモジュー
ルを引数にしてインタプリタがこのメソッドを呼び出します。

- **param** `class_or_module` -- [m:Module#include] を実行したオブジェクト

```ruby title="例"
module Trackable
  def self.included(mod)
    p "#{mod} include #{self}"
  end
end
class Report
  include Trackable
end
# => "Report include Trackable"
```

- **SEE** [m:Module#append_features]

#@since 3.2
### def const_added(name) -> ()

定数 name が追加された時にインタプリタがこのメソッドを呼び出します。

```ruby
module Chatty
  def self.const_added(const_name)
    super
    puts "Added #{const_name.inspect}"
  end
  FOO = 1
end
# => Added :FOO
```

#@end
### def method_added(name) -> ()

メソッド name が追加された時にインタプリタがこのメソッドを呼び出します。

特異メソッドの追加に対するフックには
[m:BasicObject#singleton_method_added]
を使います。

- **param** `name` -- 追加されたメソッドの名前が [c:Symbol] で渡されます。

```ruby title="例"
class Watcher
  def Watcher.method_added(name)
    puts "method \"#{name}\" was added"
  end

  def foo
  end
  define_method :bar, instance_method(:foo)
end

# => method "foo" was added
#    method "bar" was added
```

### def method_removed(name) -> ()

メソッドが [m:Module#remove_method] により削除
された時にインタプリタがこのメソッドを呼び出します。

特異メソッドの削除に対するフックには
[m:BasicObject#singleton_method_removed]
を使います。

- **param** `name` -- 削除されたメソッド名が [c:Symbol] で渡されます。

```ruby title="例"
class Watcher
  def Watcher.method_removed(name)
    puts "method \"#{name}\" was removed"
  end

  def foo
  end
  remove_method :foo
end

# => method "foo" was removed
```

### def method_undefined(name) -> ()

このモジュールのインスタンスメソッド name が
[m:Module#undef_method] によって削除されるか、
undef 文により未定義にされると、インタプリタがこのメソッドを呼び出します。

特異メソッドの削除をフックするには
[m:BasicObject#singleton_method_undefined]
を使います。

- **param** `name` -- 削除/未定義にされたメソッド名が [c:Symbol] で渡されます。

```ruby title="例"
class C
  def C.method_undefined(name)
    puts "method C\##{name} was undefined"
  end

  def foo
  end
  def bar
  end

  undef_method :foo
  undef bar
end
```

```text title="実行結果"
method C#foo was undefined
method C#bar was undefined
```

### def module_function() -> nil
### def module_function(name) -> String | Symbol
### def module_function(*name) -> Array

メソッドをモジュール関数にします。

引数が与えられた時には、
引数で指定されたメソッドをモジュール関数にします。
引数なしのときは今後このモジュール定義文内で
新しく定義されるメソッドをすべてモジュール関数にします。

モジュール関数とは、プライベートメソッドであると同時に
モジュールの特異メソッドでもあるようなメソッドです。
例えば [c:Math] モジュールのメソッドはすべてモジュール関数です。

単一の引数が与えられた時には与えられた引数をそのまま返します。
複数の引数が与えられた時には配列にまとめて返します。
引数なしの時は nil を返します。

- **param** `name` -- [c:String] または [c:Symbol] を 0 個以上指定します。

### 注意

module_function はメソッドに「モジュール関数」という属性をつけるメ
ソッドではなく、プライベートメソッドとモジュールの特異メソッドの 2
つを同時に定義するメソッドです。
そのため、以下のように書いてもモジュール関数の別名は定義できません。

```ruby title="例"
module M
  def foo
    p "foo"
  end
  module_function :foo
  alias bar foo
end

p M.foo # => "foo"
#@since 3.4
M.bar   # => undefined method 'bar' for module M (NoMethodError)
#@else
#@since 3.3
M.bar   # => undefined method `bar' for module M (NoMethodError)
#@else
M.bar   # => undefined method `bar' for M:Module (NoMethodError)
#@end
#@end
```

このコードでは、モジュール関数 foo と
プライベートインスタンスメソッド bar を定義してしまいます。

正しくモジュール関数に別名を付けるには、
以下のように、先に別名を定義してから
それぞれをモジュール関数にしなければいけません。

```ruby title="例"
module M
  def foo
    p "foo"
  end

  alias bar foo
  module_function :foo, :bar
end

p M.foo # => "foo"
p M.bar # => "foo"
```

### def private() -> nil
### def private(name) -> String | Symbol
### def private(*name) -> Array
### def private(names) -> Array

メソッドを private に設定します。

引数なしのときは今後このクラスまたはモジュール定義内で新規に定義さ
れるメソッドを関数形式でだけ呼び出せるように(private)設定します。

引数が与えられた時には引数によって指定されたメソッドを private に
設定します。

可視性については [ref:d:spec/def#limit] を参照して下さい。

- **param** `name` --  0 個以上の [c:String] または [c:Symbol] を指定します。
- **param** `names` -- 0 個以上の [c:String] または [c:Symbol] を [c:Array] で指定します。

- **raise** `NameError` -- 存在しないメソッド名を指定した場合に発生します。

```ruby title="例"
class Account
  def foo1() 1 end      # デフォルトでは public
  private               # 可視性を private に変更
  def foo2() 2 end      # foo2 は private メソッド
end

account = Account.new
p account.foo1          # => 1
#@if("3.4" <= version)
account.foo2            # => private method 'foo2' called for an instance of Account (NoMethodError)
#@end
#@if("3.3" <= version and version < "3.4")
account.foo2            # => private method `foo2' called for an instance of Account (NoMethodError)
#@end
#@if(version < "3.3")
account.foo2            # => private method `foo2' called for #<Account:0x401b7628> (NoMethodError)
#@end
```

### def protected() -> nil
### def protected(name) -> String | Symbol
### def protected(*name) -> Array
### def protected(names) -> Array

メソッドを protected に設定します。

引数なしのときは今後このクラスまたはモジュール定義内で新規に定義さ
れるメソッドを protected に設定します。

引数が与えられた時には引数によって指定されたメソッドを protected
に設定します。

可視性については [ref:d:spec/def#limit] を参照して下さい。

- **param** `name` --  0 個以上の [c:String] または [c:Symbol] を指定します。
- **param** `names` -- 0 個以上の [c:String] または [c:Symbol] を [c:Array] で指定します。

- **raise** `NameError` -- 存在しないメソッド名を指定した場合に発生します。

#@#noexample 参照先の Module#protected_method_defined? にサンプルが書かれているため

- **SEE** [m:Module#protected_method_defined?]

### def public() -> nil
### def public(name) -> String | Symbol
### def public(*name) -> Array
### def public(names) -> Array

メソッドを public に設定します。

引数なしのときは今後このクラスまたはモジュール定義内で新規に定義さ
れるメソッドをどんな形式でも呼び出せるように(public)設定します。

引数が与えられた時には引数によって指定されたメソッドを public に設
定します。

可視性については [ref:d:spec/def#limit] を参照して下さい。

- **param** `name` --  0 個以上の [c:String] または [c:Symbol] を指定します。
- **param** `names` -- 0 個以上の [c:String] または [c:Symbol] を [c:Array] で指定します。

- **raise** `NameError` -- 存在しないメソッド名を指定した場合に発生します。

```ruby title="例"
def foo() 1 end
p foo             # => 1
# the toplevel default is private
# (Ruby 2.7 以降、レシーバが self そのものの呼び出しは private でも可能なため
#  self.foo はエラーにならない。別のオブジェクトをレシーバにすると呼び出せない)
#@if("3.4" <= version)
Object.new.foo    # => private method 'foo' called for an instance of Object (NoMethodError)
#@end
#@if("3.3" <= version and version < "3.4")
Object.new.foo    # => private method `foo' called for an instance of Object (NoMethodError)
#@end
#@if(version < "3.3")
Object.new.foo    # => private method `foo' called for #<Object:0x401c83b0> (NoMethodError)
#@end

def bar() 2 end
public :bar       # visibility changed (all access allowed)
p bar             # => 2
p Object.new.bar  # => 2
```

### def remove_const(name) -> object

name で指定した定数を取り除き、その定数に設定されていた値を
返します。

- **param** `name` -- [c:String] または [c:Symbol] を指定します。

- **return** -- 引数で指定された定数に設定されていた値を返します。

- **raise** `NameError` -- 引数で指定された定数がそのモジュールやクラスに定義されていない場合に発生します。

```ruby title="例"
class Registry
  VALUE = 1
  p remove_const(:VALUE)    # => 1
  VALUE       # => uninitialized constant Registry::VALUE (NameError)
end
```

組み込みクラス/モジュールを設定している定数や [m:Kernel?.autoload] を指定した(まだロードしてない)定数を含めて削除する事ができます。

取り除かれた定数は参照できなくなりますが、消える訳ではないので注意して
使用してください。

- **SEE** [m:Module#remove_class_variable], [m:Object#remove_instance_variable]

### def refine(klass) { ... } -> Module

引数 klass で指定したクラスまたはモジュールだけに対して、ブロックで指定した機能を提供で
きるモジュールを定義します。定義した機能は Module#refine を使用せずに直
接 klass に対して変更を行う場合と異なり、限られた範囲のみ有効にできます。
そのため、既存の機能を局所的に修正したい場合などに用いる事ができます。

refinements 機能の詳細については以下を参照してください。

- <https://magazine.rubyist.net/articles/0041/0041-200Special-refinement.html>
- <https://docs.ruby-lang.org/en/master/syntax/refinements_rdoc.html>

定義した機能は [m:main.using], [m:Module#using] を実行した場合のみ
有効になります。

- **param** `klass` -- 拡張する対象のクラスまたはモジュールを指定します。

- **return** -- ブロックで指定した機能を持つ無名のモジュールを返します。

```ruby title="例"
class C
  def foo
    puts "C#foo"
  end
end

module M
  refine C do
    def foo
      puts "C#foo in M"
    end
  end
end

x = C.new
p x.foo # => "C#foo"

using M

x = C.new
p x.foo # => "C#foo in M"
```

- **SEE** [m:main.using]

### def prepend_features(mod) -> self

[m:Module#prepend] から呼び出されるメソッドで、
prepend の処理の実体です。このメソッド自体は mod で指定した
モジュール/クラスの継承チェインの先頭に self を追加します。

このメソッドを上書きすることで、prepend の処理を変更したり
追加したりできます。

- **param** `mod` -- prepend を呼び出したモジュール
- **return** -- mod が返されます

```ruby title="例"
class Recorder
  RECORDS = []
end

module X
  def self.prepend_features(mod)
    Recorder::RECORDS << mod
  end
end

class A
  prepend X
end

class B
  include X
end

class C
  prepend X
end

p Recorder::RECORDS # => [A, C]
```

- **SEE** [m:Module#prepend], [m:Module#prepended]

### def prepended(class_or_module) -> ()

self が [m:Module#prepend] されたときに対象のクラスまたはモジュールを
引数にしてインタプリタがこのメソッドを呼び出します。

- **param** `class_or_module` -- [m:Module#prepend] を実行したオブジェクト

```ruby title="例"
module A
  def self.prepended(mod)
    puts "#{self} prepended to #{mod}"
  end
end
module Enumerable
  prepend A
end
# => "A prepended to Enumerable"
```

- **SEE** [m:Module#included], [m:Module#prepend], [m:Module#prepend_features]

### def ruby2_keywords(method_name, ...)    -> nil

For the given method names, marks the method as passing keywords through
a normal argument splat.  This should only be called on methods that
accept an argument splat (\`*args\`) but not explicit keywords or a
keyword splat.  It marks the method such that if the method is called
with keyword arguments, the final hash argument is marked with a special
flag such that if it is the final element of a normal argument splat to
another method call, and that method call does not include explicit
keywords or a keyword splat, the final element is interpreted as
keywords. In other words, keywords will be passed through the method to
other methods.

This should only be used for methods that delegate keywords to another
method, and only for backwards compatibility with Ruby versions before
2.7.

This method will probably be removed at some point, as it exists only
for backwards compatibility. As it does not exist in Ruby versions
before 2.7, check that the module responds to this method before calling
it. Also, be aware that if this method is removed, the behavior of the
method will change so that it does not pass through keywords.

```ruby title="例"
module Mod
  def foo(meth, *args, &block)
    send(:"do_#{meth}", *args, &block)
  end
  ruby2_keywords(:foo) if respond_to?(:ruby2_keywords, true)
end
```

### def using(module) -> self

引数で指定したモジュールで定義された拡張を現在のクラス、モジュールで有
効にします。

有効にした拡張の有効範囲については以下を参照してください。

- <https://docs.ruby-lang.org/en/master/syntax/refinements_rdoc.html#label-Scope>

- **param** `module` -- 有効にするモジュールを指定します。

- **SEE** [m:Module#refine], [m:main.using]

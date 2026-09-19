---
type: library
---
Gem の依存関係を管理するためのライブラリです。

# class Gem::Dependency

Gem の依存関係を管理するクラスです。

## Public Instance Methods

### def <=>(other) -> Integer

self と other を [m:Gem::Dependency#name] の ASCII コードで比較して
self が大きい時には正の整数、等しい時には 0、小さい時には負の整数を返します。

### def =~(other) -> bool
### def ===(other) -> bool
{: since=""}

self と other を比較して真偽値を返します。

self の [m:Gem::Dependency#name] が正規表現として other とマッチしない場合は偽を返します。
self が other との依存関係を満たしていれば真を返します。満たしていなければ偽を返します。

### def name -> String

依存関係の名前を文字列か正規表現で返します。

### def name=(name)

依存関係の名前を文字列か正規表現でセットします。

### def requirements_list -> [String]

バージョンの必要条件を文字列の配列として返します。

### def type -> Symbol

依存関係の型を返します。

### def identity -> Symbol
{: since="2.7.0"}

`self` の依存関係の種類を表すシンボルを返します。

`self` がプレリリース版を要求しており、かつ [m:Gem::Dependency#specific?] が真であれば `:complete` を、
プレリリース版を要求しているが `specific?` が偽であれば `:abs_latest` を返します。
プレリリース版を要求しておらず、[m:Gem::Dependency#latest_version?] が真であれば `:latest` を、
それ以外の場合は `:released` を返します。

```ruby title="例"
p Gem::Dependency.new("rake").identity           # => :latest
p Gem::Dependency.new("rake", ">= 1.0").identity # => :released
```

- **SEE** [m:Gem::Dependency#prerelease?], [m:Gem::Dependency#specific?], [m:Gem::Dependency#latest_version?]

### def latest_version? -> bool
{: since="2.0.0"}

`self` が単に最新のバージョンを要求しているだけかどうかを返します。

[m:Gem::Dependency#requirement] が条件を持たない([m:Gem::Requirement#none?] が真である)場合に true を返します。

### def match?(obj, version = nil, allow_prerelease = false) -> bool
{: since="1.9.2"}

`self` が指定した Gem やスペックにマッチするかどうかを返します。

`version` を省略した場合、`obj` には `name` と `version` に応答するオブジェクト
([c:Gem::Specification] など)を指定します。`version` を指定した場合は、
`obj` には Gem の名前を文字列で指定します。

- **param** `obj` -- `version` を省略する場合は `name`・`version` に応答するオブジェクトを、
           指定する場合は Gem の名前を表す文字列を指定します。
- **param** `version` -- `obj` のバージョンを表す文字列を指定します。省略できます。
- **param** `allow_prerelease` -- `obj` のバージョンがプレリリース版であっても
           マッチを許可するかどうかを true か false で指定します。
- **return** -- `self` の [m:Gem::Dependency#name] が一致せず、
           またはバージョンが `self` の条件を満たさない場合は false を返します。
           マッチする場合は true を返します。

```ruby title="例"
dep = Gem::Dependency.new("rake", "~> 1.0")
p dep.match?("rake", "1.0.1") # => true
p dep.match?("rake", "2.0.0") # => false

spec = Gem::Specification.new("rake", "1.0.1")
p dep.match?(spec)            # => true
```

- **SEE** [m:Gem::Dependency#matches_spec?]

### def matches_spec?(spec) -> bool
{: since="1.9.3"}

`self` が spec にマッチするかどうかを返します。

[m:Gem::Dependency#name] が spec の名前と一致せず、または spec のバージョンが `self` の条件を
満たさない場合は false を返します。[m:Gem::Dependency#match?] と異なり、`self` が
プレリリース版を要求していなくても、spec 自体がプレリリース版であれば true を返すことがあります。

- **param** `spec` -- マッチさせたい [c:Gem::Specification] のインスタンスを指定します。

```ruby title="例"
dep = Gem::Dependency.new("rake", "~> 1.0")

spec1 = Gem::Specification.new("rake", "1.0.1")
p dep.matches_spec?(spec1) # => true

spec2 = Gem::Specification.new("rake", "2.0.0")
p dep.matches_spec?(spec2) # => false
```

- **SEE** [m:Gem::Dependency#match?]

### def matching_specs(platform_only = false) -> [Gem::Specification]
{: since="1.9.3"}

`self` の [m:Gem::Dependency#name] と [m:Gem::Dependency#requirement] を満たす、
インストール済みの [c:Gem::Specification] を配列で返します。

`platform_only` に true を指定すると、さらに現在のプラットフォームにインストール可能な
ものだけに絞り込みます。無効化された(`ignored?` な)スペックは結果に含まれません。

- **param** `platform_only` -- true を指定すると、現在のプラットフォームに
           インストール可能なスペックだけに絞り込みます。

### def merge(other) -> Gem::Dependency
{: since="1.9.3"}

`self` と other の条件をマージした、新しい [c:Gem::Dependency] を返します。

other の [m:Gem::Dependency#requirement] が [m:Gem::Requirement.default] と等しい場合は
`self` の条件を、`self` の条件が `Gem::Requirement.default` と等しい場合は other の条件を、
それ以外の場合は両方の条件を連結したものを持つ、新しい `Gem::Dependency` を返します。

- **param** `other` -- マージする [c:Gem::Dependency] を指定します。
- **raise** `ArgumentError` -- `self` と other の [m:Gem::Dependency#name] が異なる場合に発生します。

```ruby title="例"
dep1 = Gem::Dependency.new("rake", "< 5.0")
dep2 = Gem::Dependency.new("rake", ">= 1.9")
p dep1.merge(dep2)
# => <Gem::Dependency type=:runtime name="rake" requirements="< 5.0, >= 1.9">
```

### def prerelease=(prerelease)
{: since="1.9.2"}

`self` を強制的にプレリリース版の依存関係として扱うかどうかを設定します。

- **param** `prerelease` -- プレリリース版として扱うかどうかを true か false で指定します。

- **SEE** [m:Gem::Dependency#prerelease?]

### def prerelease? -> bool
{: since="1.9.2"}

`self` がプレリリース版を要求するかどうかを返します。

[m:Gem::Dependency#prerelease=] で明示的に true が設定されているか、
[m:Gem::Dependency#requirement] が [m:Gem::Requirement#prerelease?] を満たす場合に true を返します。

```ruby title="例"
dep = Gem::Dependency.new("rake", ">= 1.0")
p dep.prerelease?    # => false

dep.prerelease = true
p dep.prerelease?    # => true
```

### def requirement -> Gem::Requirement
{: since="1.9.2"}

`self` が要求するバージョンの条件を、[c:Gem::Requirement] のインスタンスで返します。

```ruby title="例"
dep = Gem::Dependency.new("rake", "= 1.0")
pp dep.requirement
# => Gem::Requirement.new(["= 1.0"])
```

### def runtime? -> bool
{: since="2.3.0"}

`self` の [m:Gem::Dependency#type] が `:runtime` かどうかを返します。

`type` が明示的に設定されていない場合も true を返します。

```ruby title="例"
p Gem::Dependency.new("rake", ">= 1.0").runtime?               # => true
p Gem::Dependency.new("rake", ">= 1.0", :development).runtime? # => false
```

### def specific? -> bool
{: since="1.9.3"}

`self` の条件が、常に最新バージョンにマッチするとは限らない場合に true を返します。

[m:Gem::Dependency#requirement] の [m:Gem::Requirement#specific?] の結果をそのまま返します。

```ruby title="例"
p Gem::Dependency.new("rake", ">= 1.0").specific? # => false
p Gem::Dependency.new("rake", "= 1.0").specific?  # => true
```

### def to_spec -> Gem::Specification
{: since="1.9.3"}

`self` の条件を満たす、インストール済みの [c:Gem::Specification] を 1 つ返します。

[m:Gem::Dependency#to_specs] が返す候補の中から、既にロードされている(`activated?` な)
ものを優先して返します。`self` が [m:Gem::Dependency#prerelease?] でなければ、
プレリリース版は他に候補が無いときだけ選ばれます。

- **SEE** [m:Gem::Dependency#to_specs]

### def to_specs -> [Gem::Specification]
{: since="1.9.3"}

`self` の条件を満たす、インストール済みの [c:Gem::Specification] を配列で返します。

- **raise** `Gem::MissingSpecError` -- 条件を満たすスペックが見つからず、
           同名のスペックも全く無い場合に発生します。
- **raise** `Gem::MissingSpecVersionError` -- 同名のスペックは存在するものの、
           条件を満たすバージョンのものが無い場合に発生します。

- **SEE** [m:Gem::Dependency#to_spec], [m:Gem::Dependency#matching_specs]

## Constants

### const TYPES -> Array

有効な依存関係の型を表す配列です。

- **SEE** [m:Gem::Specification::CURRENT_SPECIFICATION_VERSION]

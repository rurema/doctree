---
type: library
require:
  - rubygems
---
選択した Gem のインストールを実行できるプラットフォームのリストを扱うライブラリです。

# class Gem::Platform

選択した Gem のインストールを実行できるプラットフォームのリストを扱うクラスです。

## Public Instance Methods

### def ==(other) -> bool
### def eql?(other) -> bool
{: since=""}

自身と other が同じプラットフォームである場合に真を返します。
そうでない場合は偽を返します。

同じプラットフォームであるとは、二つのプラットフォームの
CPU, OS, バージョンが同じであるということです。

- **param** `other` -- 比較対象のオブジェクトです。

### def ===(other) -> bool

自身と other のプラットフォームが一致する場合に真を返します。
そうでない場合は、偽を返します。

プラットフォームが一致するとは、以下の条件を満たすことです。

  - 同じ CPU であること、または、どちらか一方が 'universal' であること
  - 同じ OS であること
  - 同じバージョンであること、または、どちらか一方がバージョンを持たないこと

- **param** `other` -- 比較対象のオブジェクトです。

### def =~(other) -> bool

自身と other のプラットフォームが一致する場合に真を返します。
そうでない場合は、偽を返します。

other が文字列の場合は、まず [c:Gem::Platform] に変換してから比較を行います。
other が文字列でも [c:Gem::Platform] でもない場合は nil を返します。

- **param** `other` -- 比較対象のオブジェクトです。

- **SEE** [m:Gem::Platform#===]

### def cpu -> String

CPU のアーキテクチャを返します。

### def cpu=(cpu)

CPU のアーキテクチャをセットします。

- **param** `cpu` -- CPU のアーキテクチャを指定します。

### def os -> String

OS の種類を返します。

### def os=(os)

OS の種類をセットします。

- **param** `os` -- OS の種類を指定します。

### def to_a -> Array
#%since 4.0
### def deconstruct -> Array
#%end

自身にセットされている CPU, OS, バージョンを配列として返します。

### def to_s -> String

自身にセットされている CPU, OS, バージョンを文字列として返します。

### def version -> String

プラットフォームのバージョンを返します。

### def version=(version)

プラットフォームのバージョンをセットします。

- **param** `version` -- プラットフォームのバージョンを指定します。

#%since 4.0
### def deconstruct_keys(keys) -> {Symbol => String | nil}

`self` を `cpu`・`os`・`version` をキーとするハッシュに分解して返します。

パターンマッチングのハッシュパターンに対応するためのメソッドです。

- **param** `keys` -- パターンマッチングの実装から渡されるキーの配列です。`self` では無視されます。

```ruby title="例"
p Gem::Platform.new("x86_64-linux").deconstruct_keys(nil)
# => {cpu: "x86_64", os: "linux", version: nil}

result = case Gem::Platform.new("x86_64-linux")
         in cpu: "x86_64", os: "linux"
           :matched
         end
p result # => :matched
```

- **SEE** [m:Gem::Platform#deconstruct], [m:Gem::Platform#to_a]

#%end

## Singleton Methods

### def Gem::Platform.local -> Gem::Platform
#%todo ???

#%until 4.0
### def Gem::Platform.match(platform) -> bool
#%todo ???

#%end
### def Gem::Platform.new(arch)-> Gem::Platform

自身を初期化します。

- **param** `arch` -- アーキテクチャを指定します。

#%since 4.0
### def Gem::Platform.generic(platform) -> Gem::Platform | String

platform に対応する一般化されたプラットフォームを返します。

Java 用や各種 Windows 用としてまとめて扱われる代表的なプラットフォームが存在する場合はそれを返します。
該当するものが無い場合や、platform が nil または [m:Gem::Platform::RUBY] の場合は
`Gem::Platform::RUBY` を返します。

- **param** `platform` -- 一般化したい [c:Gem::Platform] のインスタンス、または nil を指定します。

```ruby title="例"
p Gem::Platform.generic(Gem::Platform::RUBY)               # => "ruby"
p Gem::Platform.generic(Gem::Platform.new("x86_64-linux")) # => "ruby"
```

- **SEE** [m:Gem::Platform.sort_priority]

#%end

### def Gem::Platform.installable?(spec) -> bool
{: since="2.1.0"}

spec が現在の環境にインストール可能かどうかを返します。

spec が `installable_platform?` に応答する場合はその結果を、応答しない場合は
[m:Gem::Platform.match_spec?] の結果を返します。

- **param** `spec` -- 判定したい [c:Gem::Specification] のインスタンスを指定します。

```ruby title="例"
spec = Gem::Specification.new("rake", "1.0.0")
spec.platform = Gem::Platform::RUBY
p Gem::Platform.installable?(spec) # => true
```

- **SEE** [m:Gem::Platform.match_spec?]

### def Gem::Platform.match_gem?(platform, gem_name) -> bool

platform が現在の環境にインストール可能なプラットフォームかどうかを返します。

内部で `Gem.platforms` を参照し、そのいずれかと platform が一致するかどうかを調べます。
gem_name は TruffleRuby など一部の Ruby 処理系でのみ判定に使われます。

- **param** `platform` -- 判定したい [c:Gem::Platform] のインスタンス、または文字列を指定します。
- **param** `gem_name` -- 対象の Gem の名前を文字列で指定します。

```ruby title="例"
p Gem::Platform.match_gem?(Gem::Platform::RUBY, "rake") # => true
```

- **SEE** [m:Gem::Platform.match_spec?]

### def Gem::Platform.match_spec?(spec) -> bool

spec のプラットフォームが現在の環境にインストール可能かどうかを返します。

[m:Gem::Platform.match_gem?] に、spec の [m:Gem::Specification#platform] と
[m:Gem::Specification#name] を渡した結果を返します。

- **param** `spec` -- 判定したい [c:Gem::Specification] のインスタンスを指定します。

```ruby title="例"
spec = Gem::Specification.new("rake", "1.0.0")
spec.platform = Gem::Platform::RUBY
p Gem::Platform.match_spec?(spec) # => true
```

- **SEE** [m:Gem::Platform.match_gem?]

#%since 3.1
### def Gem::Platform.sort_priority(platform) -> Integer

ソートする際に platform を優先させるための整数を返します。

platform が [m:Gem::Platform::RUBY] であれば -1 を、そうでなければ 1 を返します。
値が小さいほど優先順位が高いことを表します。

- **param** `platform` -- 優先順位を調べたい [c:Gem::Platform] のインスタンスを指定します。

```ruby title="例"
p Gem::Platform.sort_priority(Gem::Platform::RUBY)               # => -1
p Gem::Platform.sort_priority(Gem::Platform.new("x86_64-linux")) # => 1
```

#%end

## Constants

### const CURRENT -> String

特定のプラットフォーム向けの Gem をビルドするときに使用します。

### const RUBY -> String

Pure Ruby の Gem はバイナリファイルをビルドするために [m:Gem::Specification#extensions]
を使用する可能性があります。

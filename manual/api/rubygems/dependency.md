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

### def version_requirements -> Gem::Requirement

依存しているバージョンを返します。

### def version_requirements=(version_requirements)

依存しているバージョンを設定します。

- **param** `version_requirements` -- [c:Gem::Requirement] のインスタンスを指定します。

## Constants

### const TYPES -> Array

有効な依存関係の型を表す配列です。

- **SEE** [m:Gem::Specification::CURRENT_SPECIFICATION_VERSION]

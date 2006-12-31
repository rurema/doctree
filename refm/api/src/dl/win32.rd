require dl

Ruby/DL が [[c:Win32API]] と互換性を持つようにするライブラリ。

= class Win32API < Object

== Class Methods

--- new(dllname, func, import, export = "0")

指定された関数を [[c:DL::Symbol]] オブジェクトとして生成します。

== Instance Methods

--- call(*args)
--- Call(*args)

[[DL::Symbol#call]] により関数を実行します。

== Constants

--- DLL


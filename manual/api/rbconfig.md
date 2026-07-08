---
type: library
alias:
#@until 2.2.0
  - Config
#@end
category: Development
---
Ruby インタプリタ作成時に設定された情報を格納したライブラリです。

# module RbConfig

Ruby インタプリタ作成時に設定された情報を格納したライブラリです。
RbConfig モジュールを定義します。


## Singleton Methods

### def expand(val, config = CONFIG) -> String

与えられたパスを展開します。

`````
RbConfig.expand("$(bindir)") # => /home/foobar/all-ruby/ruby19x/bin
`````

- **param** `val` -- 展開したい変数名を Makefile に書く形式で指定します。

- **param** `config` -- 変数展開に使用する設定を [c:Hash] で指定します。
  
#@since 1.9.1
- **SEE** [m:RbConfig::MAKEFILE_CONFIG]
#@else
- **SEE** [m:Config::MAKEFILE_CONFIG]
#@end
#@since 1.9.2
### def ruby -> String

ruby コマンドのフルパスを返します。
#@end

## Constants

### const DESTDIR -> String

make install するときに指定した DESTDIR を返します。
クロスコンパイルしたときなどは値がセットされています。

### const TOPDIR -> String

Ruby がインストールされているディレクトリです。

`````
TOPDIR
├── bin
│   ├── ...
│   └── ruby
├── include
├── lib
└── share
`````
  
### const CONFIG -> Hash

設定値を格納したハッシュです。

格納されている要素のキーと値は Ruby のバージョンや使用しているプラット
フォームによって変わります。

- **SEE** [man:autoconf(1)], [man:make(1)]

### const MAKEFILE_CONFIG -> Hash

#@since 1.9.1
[m:RbConfig::CONFIG]
#@else
[m:Config::CONFIG]
#@end
と同じですが、その値は以下のような形
で他の変数への参照を含みます。
`````
MAKEFILE_CONFIG["bindir"] = "$(exec_prefix)/bin"
`````
これは、Makefile の変数参照の形式で MAKEFILE_CONFIG は、
Makefile 作成の際に利用されることを想定しています。

`````
require 'rbconfig'
  
print <<-END_OF_MAKEFILE
prefix = #{RbConfig::MAKEFILE_CONFIG['prefix']}
exec_prefix = #{RbConfig::MAKEFILE_CONFIG['exec_prefix']}
bindir = #{RbConfig::MAKEFILE_CONFIG['bindir']}
END_OF_MAKEFILE
  
=> prefix = /usr/local
   exec_prefix = $(prefix)
   bindir = $(exec_prefix)/bin
`````

#@since 1.9.1
[m:RbConfig.expand]
#@else
[m:Config.expand]
#@end
は、このような参照を解決する
メソッドとして rbconfig 内部で利用されています。
(CONFIG 変数は、MAKEFILE_CONFIG の内容から
#@since 1.9.1
[m:RbConfig.expand]
#@else
[m:Config.expand]
#@end
を使って生成されています)

`````
require 'rbconfig'
p Config.expand(RbConfig::MAKEFILE_CONFIG["bindir"])
# => "/usr/local/bin"
`````

require rubygems

[[m:Kernel#require]] を再定義するためのライブラリです。

Ruby1.9 以前で使用しています。

= reopen Kernel

== Private Instance Methods

--- require(path) -> bool

RubyGems を require すると、[[m:Kernel#require]] が Gem を
要求されたときにロードするように置き換えます。

再定義された [[m:Kernel#require]] を呼び出すと以下の事を行います。
Ruby のロードパスに存在するライブラリを指定した場合はそのままロードします。
そうではなく、インストールされた Gem ファイルの中から見つかった場合は、
その Gem をロードパスに登録します。

@param path ロードしたいライブラリの名前を指定します。

@return 既にロードされているライブラリを再度ロードしようとした場合は false を返します。
        そうでない場合は true を返します。


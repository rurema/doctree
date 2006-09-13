= class Exception < Object

全ての例外の祖先のクラスです。

== Class Methods

--- new([error_message])
--- exception([error_message])

例外オブジェクトを生成して返します。引数としてエラーメッセージを表
す文字列を与えることができます。このメッセージは属性
[[m:Exception#message]] の値になり、デフォルトの例外ハンドラで表示
されます。

== Instance Methods

--- exception([error_message])

引数を指定しない場合は self を返します。そうでなければ、自身のコピー
を生成し、[[m:Exception#message]] 属性を error_message にし
て返します。

[[m:Kernel#raise]] は、実質的に、例外オブジェクトの exception
メソッドの呼び出しです。

--- backtrace

バックトレース情報を返します。

  * "#{sourcefile}:#{sourceline}:in `#{method}'"
    (メソッド内の場合)
  * "#{sourcefile}:#{sourceline}"
    (トップレベルの場合)

という形式(デフォルトでは)の [[c:String]] の配列です。

--- message
--- to_s
--- to_str

エラーメッセージをあらわす文字列を返します。

--- set_backtrace(errinfo)

バックトレース情報に errinfo を設定し、設定されたバックトレース
情報を返します。errinfo は
nil、[[c:String]] あるいは [[c:String]] の配列のいずれかでな
くてはなりません。

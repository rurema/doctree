
[[c:Shell::Filter]] を定義しているライブラリです。

= class Shell::Filter < Object

include Enumerable

コマンドの実行結果はすべて [[c:Shell::Filter]] か、そのサブクラスのインスタンスとして返ります。 

== Class Methods

--- new(sh) -> Shell::Filter

[[c:Shell::Filter]] クラスのインスタンスを返します。
通常このメソッドを直接使う機会は少ないでしょう。

== Instance Methods

--- each(rs = nil) -> ()

フィルタの一行ずつをblockに渡します。

@param rs レコードセパレーターを表す文字列を指定します。
          nil ならば、[[m:Shell.record_separator]]の値が使用されます。

使用例
  require 'shell'
  sh = Shell.new
  sh.cat("/etc/passwd").each { |line|
    puts line
  }

--- <(src) -> self

srcをフィルタの入力とする。 srcが, 文字列ならばファイルを, IOオブジェクトであれ
ばそれをそのまま入力とする。

@param src フィルタの入力を, 文字列もしくは,IO オブジェクトで指定します。

使用例
  require 'shell'
  Shell.def_system_command("head")
  sh = Shell.new
  sh.transact {
    (sh.head("-n 30") < "/etc/passwd") > "ugo.txt"
  }

--- >(to) -> self

toをフィルタの出力とする。 toが, 文字列ならばファイルに, IOオブジェクトであれ
ばそれをそのまま出力とする。

@param to 出力先を指定します。文字列ならばファイルに,IOオブジェクトならばそれに出力します。

使用例
  require 'shell'
  Shell.def_system_command("tail")
  sh = Shell.new
  sh.transact {
    (sh.tail("-n 3") < "/etc/passwd") > File.open("tail.out", "w")
    #(sh.tail("-n 3") < "/etc/passwd") > "tail.out" # と同じ.
  }

--- >>(to) -> self

toをフィルタに追加する。 toが, 文字列ならばファイルに, IOオブジェクトであれば
それをそのまま出力とする。

@param to 出力先を指定します。文字列ならばファイルに、IOオブジェクトならばそれに出力します。

使用例
  require 'shell'
  Shell.def_system_command("tail")
  sh = Shell.new
  sh.transact {
    (sh.tail("-n 3") < "/etc/passwd") >> "tail.out" 
    #(sh.tail("-n 3") < "/etc/passwd") >> File.open("tail.out", "w") # でも同じ。
  }

--- |(filter) -> object

パイプ結合を filter に対して行います。

@param filter Shell::Filter オブジェクトを指定します。

@return filter を返します。

使用例
  require 'shell'
  Shell.def_system_command("tail")
  Shell.def_system_command("head")
  Shell.def_system_command("wc")
  sh = Shell.new
  sh.transact {
    i = 1
    while i <= (cat("/etc/passwd") | wc("-l")).to_s.chomp.to_i
      puts (cat("/etc/passwd") | head("-n #{i}") | tail("-n 1")).to_s
      i += 1
    end
  }

--- +(filter)
執筆者募集

filter1 + filter2 は filter1の出力の後, filter2の出力を行う。

--- to_a -> [String]
実行結果を文字列の配列で返します。

  require 'shell'
  Shell.def_system_command("wc")
  sh = Shell.new
  puts sh.cat("/etc/passwd").to_a

--- to_s -> String
実行結果を文字列で返します。

  require 'shell'
  Shell.def_system_command("wc")
  sh = Shell.new

  sh.transact {
    puts (cat("/etc/passwd") | wc("-l")).to_s
  }

--- inspect -> String

オブジェクトを人間が読める形式に変換した文字列を返します。

@see [[m:Object#inspect]]

--- input -> Shell::Filter | nil
現在のフィルターを返します。

--- input=(filter)

フィルターを設定します。

@param filter フィルターを指定します。


#@include(builtincommands)


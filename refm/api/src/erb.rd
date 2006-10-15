eRuby スクリプトを処理するクラス。
従来 ERbLight と呼ばれていたもので、
標準出力への印字が文字列の挿入とならない点が eruby と異なります。


=== 使い方

ERB クラスを使うためには require 'erb' する必要があります。

例:

  require 'erb'

  ERB.new($<.read).run

=== trim_mode

trim_mode は整形の挙動を変更するオプションです。次の振舞いを指定できます。
  * 改行の扱い
  * %ではじまる行の扱い (ERB 2.0 から追加されました)


trim_mode に指定できる値は次の通りです。

  * ERb-1.4.x 互換の指定方法
    * nil, 0: そのまま変換
    * 1: 行末が%>のとき改行を出力しない
    * 2: 行頭が<%で行末が%>のとき改行を出力しない

  * 2.0 からの指定方法
    * nil, "": そのまま変換
    * ">": 1と同じ
    *  "<>": 2と同じ
    * "-": 行末が-%>のとき改行を出力しない。また、行頭が<%-のとき行頭の空白文字を削除する
    * "%": %ではじまる行を<%..%>とみなして変換する。この行の改行は出力しない
    * "%>", ">%": 1と"%"の両方を行なう
    * "%<>", "<>%": 2と"%"の両方を行なう
    * "%-": "-"と"%"の両方を行なう

実行例:

  # スクリプト
  <% 3.times do |n| %>
  % n = 0
  * <%= n%>
  <% end %>
  
  # trim_mode = nil, '', 0
  
  % n = 0
  * 0
  
  % n = 0
  * 1
  
  % n = 0
  * 2
  
  # trim_mode = 1, '>'
  % n = 0
  * 0% n = 0
  * 1% n = 0
  * 2
  
  # trim_mode = 2, '<>'
  % n = 0
  * 0
  % n = 0
  * 1
  % n = 0
  * 2
  
  # trim_mode = '%'
  
  * 0
  
  * 0
  
  * 0
  
  # trim_mode = '%>', '>%'
  * 0* 0* 0
  
  # trim_mode = '%<>', '<>%'
  * 0
  * 0
  * 0
  
  # スクリプト
  <% 3.times do |n| -%>
  % n = 0
    <%- m = 0 %>*
  * <%= n%>
  <% end -%>
  
  # trim_mode = '%-'
  *
  * 0
  *
  * 0
  *
  * 0
  
  # スクリプト
  <% 3.times do |n| %>
  % n = 0
    <%- m = 0 %>*
  * <%= n%>
  <% end %>
  
  # trim_mode = '%'
  
    *
  * 0
  
    *
  * 0
  
    *
  * 0

= class ERB < Object

== Class Methods

--- new(eruby_script, safe_level=nil, trim_mode=nil, eoutvar='_erbout')

    eruby_script から ERB を生成します。eval 時の $SAFE、trim_mode(後述)、
    eoutvar(eRuby スクリプトの中でさらに ERB を使うときに変更します。
    普通、変更する必要はありません。)を指定できます。

== Instance Methods

--- run(b=TOPLEVEL_BINDING)

ERB をb の binding で実行し、印字します。

--- result(b=TOPLEVEL_BINDING)

ERB を b の binding で実行し、文字列を返します。

--- src

変換した Ruby スクリプトを取得します。

--- def_method(mod, methodname, fname='(ERB)')

変換した Ruby スクリプトをメソッドとして定義します。
定義先のモジュールは mod で指定し、メソッド名は methodname で指定します。
fname はスクリプトを定義する際のファイル名です。主にエラー時に活躍します。

例:

  erb = ERB.new(script)
  erb.def_method(MyClass, 'foo(bar)', 'foo.erb')

--- def_module(methodname='erb')

変換した Ruby スクリプトをメソッドとして定義した無名のモジュールを返します。

--- def_class(suplerklass=Object, methodname='erb')

変換した Ruby スクリプトをメソッドとして定義した無名のクラスを返します。
#@# 使い途がなさそうだ…。

= module ERB::Util

== Module Functions

--- html_escape(s)
--- h(s)

HTML の &"<> をエスケープします
([[m:CGI.escapeHTML]]とほぼ同じです)。

--- url_encode(s)
--- u(s)

文字列を URL エンコードします
([[m:CGI.escape]]とほぼ同じです)。

= module ERB::DefMethod

== Module Functions

--- def_erb_method(methodname, erb)

self に erb のスクリプトをメソッドとして定義します。メソッド名は methodname で指定します。
self が文字列の時、そのファイルを読み込み ERB で変換したのち、メソッドとして定義します。

例:

  class Writer
    extend ERB::DefMethod
    def_erb_method('to_html', 'writer.erb')
    ...
  end
  ...
  puts writer.to_html

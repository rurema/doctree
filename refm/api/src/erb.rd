category Text

eRuby スクリプトを扱うためのライブラリです。

= class ERB < Object

eRuby スクリプトを処理するクラス。

従来 ERbLight と呼ばれていたもので、
標準出力への印字が文字列の挿入とならない点が eruby と異なります。

 * [[url:https://magazine.rubyist.net/articles/0017/0017-BundledLibraries.html]]


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

#@since 1.9.1
=== エンコーディング

ERB は入力した文字列と同じエンコーディングの文字列を返すのがデフォルト
の動作ですが、以下のようにマジックコメントを指定すると、ERB によって生
成される文字列のエンコーディングを指定できます。

  # -*- coding: UTF-8 -*-
  require 'erb'
  
  template = ERB.new <<EOF
  <%#-*- coding: Big5 -*-%>
    __ENCODING__ is <%= __ENCODING__ %>.
  EOF
  puts template.result # => __ENCODING__ is Big5

#@end

== Class Methods

#@since 2.6.0
--- new(str, safe_level=NOT_GIVEN, trim_mode=NOT_GIVEN, eoutvar=NOT_GIVEN, trim_mode: nil, eoutvar: '_erbout') -> ERB
#@else
--- new(str, safe_level=nil, trim_mode=nil, eoutvar='_erbout') -> ERB
#@end

eRubyスクリプト から ERB オブジェクトを生成して返します。

@param str eRubyスクリプトを表す文字列

@param safe_level eRubyスクリプトが実行されるときのセーフレベル

@param trim_mode 整形の挙動を変更するオプション

@param eoutvar eRubyスクリプトの中で出力をためていく変数の名前を表す文
               字列。eRuby スクリプトの中でさらに ERB を使うときに変更
               します。通常は指定する必要はありません。

Ruby 2.6.0 から位置引数での safe_level, trim_mode, eoutvar の指定は非推奨です。
Ruby 2.5 が EOL になったときに削除される予定です。
trim_mode と eoutvar の指定はキーワード引数に移行してください。

#@samplecode 例
require "erb"

# build data class
class Listings
  PRODUCT = { :name => "Chicken Fried Steak",
              :desc => "A well messages pattie, breaded and fried.",
              :cost => 9.95 }

  attr_reader :product, :price

  def initialize( product = "", price = "" )
    @product = product
    @price = price
  end

  def build
    b = binding
    # create and run templates, filling member data variables
#@since 2.6.0
    ERB.new(<<-'END_PRODUCT'.gsub(/^\s+/, ""), eoutvar: "@product").result b
#@else
    ERB.new(<<-'END_PRODUCT'.gsub(/^\s+/, ""), 0, "", "@product").result b
#@end
      <%= PRODUCT[:name] %>
      <%= PRODUCT[:desc] %>
    END_PRODUCT
#@since 2.6.0
    ERB.new(<<-'END_PRICE'.gsub(/^\s+/, ""), eoutvar: "@price").result b
#@else
    ERB.new(<<-'END_PRICE'.gsub(/^\s+/, ""), 0, "", "@price").result b
#@end
      <%= PRODUCT[:name] %> -- <%= PRODUCT[:cost] %>
      <%= PRODUCT[:desc] %>
    END_PRICE
  end
end

# setup template data
listings = Listings.new
listings.build

puts listings.product + "\n" + listings.price

# Chicken Fried Steak
# A well messages pattie, breaded and fried.
# 
# Chicken Fried Steak -- 9.95
# A well messages pattie, breaded and fried.
#@end

--- version -> String

erb.rbのリビジョン情報を返します。

== Instance Methods

--- run(b=TOPLEVEL_BINDING) -> nil

ERB を b の binding で実行し、結果を標準出力へ印字します。

@param b eRubyスクリプトが実行されるときのbinding

#@samplecode 例
require 'erb'
erb = ERB.new("test <%= test1 %>\ntest <%= test2 %>\n")
test1 = "foo"
test2 = "bar"
erb.run
# test foo
# test bar
#@end

--- result(b=TOPLEVEL_BINDING) -> String

ERB を b の binding で実行し、結果の文字列を返します。

@param b eRubyスクリプトが実行されるときのbinding

#@samplecode 例
require 'erb'
erb = ERB.new("test <%= test1 %>\ntest <%= test2 %>\n")
test1 = "foo"
test2 = "bar"
puts erb.result
# test foo
# test bar
#@end

#@since 2.5.0
@see [[m:ERB#result_with_hash]]

--- result_with_hash(hash) -> String

ERB をハッシュオブジェクトで指定されたローカル変数を持つ
新しいトップレベルバインディングで実行し、結果の文字列を返します。

@param hash ローカル変数名をキーにしたハッシュ

@see [[m:ERB#result]]
#@end

--- src -> String

変換した Ruby スクリプトを取得します。

#@samplecode 例
require 'erb'
erb = ERB.new("test1<%= @arg1%>\ntest2<%= @arg2%>\n\n")
puts erb.src

# #coding:UTF-8
# _erbout = +''; _erbout.<< "test1".freeze; _erbout.<<(( @arg1).to_s); _erbout.<< "\ntest2".freeze
# ; _erbout.<<(( @arg2).to_s); _erbout.<< "\n\n".freeze
#
# ; _erbout
#@end

--- def_method(mod, methodname, fname='(ERB)') -> nil

変換した Ruby スクリプトをメソッドとして定義します。

定義先のモジュールは mod で指定し、メソッド名は methodname で指定します。
fname はスクリプトを定義する際のファイル名です。主にエラー時に活躍します。

@param mod メソッドを定義するモジュール（またはクラス）

@param methodname メソッド名

@param fname スクリプトを定義する際のファイル名

例:

  require 'erb'
  erb = ERB.new(script)
  erb.def_method(MyClass, 'foo(bar)', 'foo.erb')

--- def_module(methodname='erb') -> Module

変換した Ruby スクリプトをメソッドとして定義した無名のモジュールを返します。

@param methodname メソッド名

#@samplecode 例
require 'erb'
filename = 'example.rhtml'
erb = ERB.new("test1<%= arg1 %>\ntest2<%= arg2 %>\n")
erb.filename = filename
MyModule = erb.def_module('render(arg1, arg2)')
class MyClass
  include MyModule
end
print MyClass.new.render('foo', 123)
# test1foo
# test2123
#@end

--- def_class(superklass=Object, methodname='erb') -> Class

変換した Ruby スクリプトをメソッドとして定義した無名のクラスを返します。

#@# 使い途がなさそうだ…。
 
@param superklass 無名クラスのスーパークラス

@param methodname メソッド名

#@samplecode 例
require 'erb'

class MyClass_
  def initialize(arg1, arg2)
    @arg1 = arg1;  @arg2 = arg2
  end
end
filename = 'example.rhtml'  # @arg1 と @arg2 が使われている example.rhtml

erb = ERB.new(File.read(filename))
erb.filename = filename
MyClass = erb.def_class(MyClass_, 'render()')
print MyClass.new('foo', 123).render()

# => test1foo
#    test2123
#@end

--- set_eoutvar(compiler, eoutvar = '_erbout') -> Array

ERBの中でeRubyスクリプトの出力をためていく変数を設定します。

ERBでeRubyスクリプトの出力をためていく変数を設定するために使用します。
この設定は ERB#new でも行えるため、通常はそちらを使用した方がより容易です。
本メソッドを使用するためには、引数にて指定する eRuby コンパイラを事前に生成しておく必要があります。

@param compiler eRubyコンパイラ

@param eoutvar eRubyスクリプトの中で出力をためていく変数


--- filename -> String

エラーメッセージを表示する際のファイル名を取得します。

#@samplecode 例
require 'erb'
filename = 'example.rhtml'
erb = ERB.new(File.read(filename))
erb.filename # => nil
erb.filename = filename
erb.filename # =>"example.rhtml"
#@end

--- filename= -> String

エラーメッセージを表示する際のファイル名を設定します。

filename を設定しておくことにより、エラーが発生した eRuby スクリプトの特定が容易になります。filename を設定していない場合は、エラー発生箇所は「 (ERB) 」という出力となります。

#@samplecode 例
require 'erb'
filename = 'example.rhtml'
erb = ERB.new(File.read(filename))
erb.filename # => nil
erb.filename = filename
erb.filename # =>"example.rhtml"
#@end

= module ERB::Util

eRubyスクリプトのためのユーティリティを提供するモジュールです。

== Module Functions

--- html_escape(s) -> String
--- h(s) -> String

文字列 s を HTML用にエスケープした文字列を返します。

文字列 s 中に含まれる  &"<> を、実体参照 &amp; &quot; &lt; &gt; にそれぞれ変更した文字列を返します
([[m:CGI.escapeHTML]]とほぼ同じです)。

@param s HTMLエスケープを行う文字列

#@samplecode 例
require "erb"
include ERB::Util

puts html_escape("is a > 0 & a < 10?")
# is a &gt; 0 &amp; a &lt; 10?
#@end

--- url_encode(s)  -> String
--- u(s) -> String

文字列 s を URLエンコードした文字列を返します。

文字列 s 中に含まれる 2バイト文字や半角スペースについて URL エンコードを行った文字列を返します([[m:CGI.escape]]とほぼ同じです)。

@param s URLエンコードを行う文字列

#@samplecode 例
require "erb"
include ERB::Util

puts url_encode("Programming Ruby:  The Pragmatic Programmer's Guide")
# Programming%20Ruby%3A%20%20The%20Pragmatic%20Programmer%27s%20Guide
#@end

= module ERB::DefMethod

def_erb_methodを提供するモジュールです。

== Module Functions

--- def_erb_method(methodname, erb) -> nil

self に erb のスクリプトをメソッドとして定義します。

メソッド名は methodname で指定します。
erb が文字列の時、そのファイルを読み込み ERB で変換したのち、メソッドとして定義します。

@param methodname メソッド名

@param erb ERBインスタンスもしくはERBソースファイル名

例:

  require 'erb'
  class Writer
    extend ERB::DefMethod
    def_erb_method('to_html', 'writer.erb')
    ...
  end
  ...
  puts writer.to_html

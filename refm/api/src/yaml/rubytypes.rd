require date

Ruby の組み込みクラスのいくつかを YAML に変換するためのサブライブラリで
す。

= reopen Class

== instance methods

--- to_yaml(opts = {}) -> String

例外を発生する。

@param opts YAMLドキュメント出力の際のオプションを指定するが使われない。

@raise TypeError

  require 'yaml'
  
  begin
    cc = Class.new
    cc.to_yaml
  rescue
    p $!
    #=> #<TypeError: can't dump anonymous class Class>
  end

= reopen Object

== instance methods

--- to_yaml(opts = {})

オブジェクトをYAMLドキュメントに変換します。

@param opts YAMLドキュメント出力の際のオプションを指定する。

#@# optsの使い方

  require 'yaml'
  
  h = {
    :ugo => 17,
    :hoge => "fuga",
  }
  
  print h.to_yaml
  #=> ---
  #=> :ugo: 17
  #=> :hoge: fuga
  
  class MyDog
    attr_accessor :name, :age
  end
  
  c = MyDog.new
  c.name = "Pochi"
  c.age = 3
  print c.to_yaml
  #=> --- !ruby/object:MyDog
  #=> age: 3
  #=> name: Pochi

--- to_yaml_style -> nil

nilを返します。

@return nilを返します。

例:

  require 'yaml'
  
  p to_yaml_style
  #=> nil
  a = []
  p a.to_yaml_style
  #=> nil

--- to_yaml_properties -> [String]

[[m:Object#instance_variables]].sortの結果を返します。

@return オブジェクトのインスタンス変数名の配列

  require 'yaml'
  
  h = {
    :ugo => 17,
    :hoge => "fuga",
  }
  
  p h.to_yaml_properties
  #=> []
  class MyDog
    attr_accessor :name, :age
  end
  
  c = MyDog.new
  c.name = "Pochi"
  c.age = 3
  p c.to_yaml_properties.join(",")
  #=> ["@age,@name"]

= reopen Struct

== class methods

--- yaml_tag_class_name -> String

自身のクラス名から Struct::をのぞいた文字列を返します。

@return 自身のクラス名から Struct::をのぞいた文字列

  require 'yaml'
  
  YStruct = Struct.new("YStruct", :name)
  p YStruct::yaml_tag_class_name
  #=> "YStruct"

--- yaml_tag_read_class(name) -> String

引数 name に Struct:: を加えた文字列を返します。

@param name 構造体の名前を指定します。

@return 引数nameにStruct::を加えた文字列

  require 'yaml'
  
  YStruct = Struct.new("YStruct", :name)
  p YStruct::yaml_tag_read_class("YStruct")
  #=> "Struct::YStruct"

#@# TODO: Exception#to_yaml を追加するか検討する。

= reopen String

== instance methods

--- is_complex_yaml? -> Integer | nil

自身が複数行になるキーを含むような YAML である場合に真になる値を返しま
す。

例: ["Detroit Tigers", "Chicago cubs"] をキーとする場合

  require 'yaml'
  s = <<EOS
  ? 
    - Detroit Tigers
    - Chicago cubs
  : 
    - 2001-07-23
  EOS
  p s.is_complex_yaml? # => 2
  p YAML.load(s) # => {["Detroit Tigers", "Chicago cubs"]=>[#<Date: 4904227/2,0,2299161>]}

--- is_binary_data? -> true | nil

自身が ASCII 文字以外の文字列を含む場合に true を返します。

この値が true になる場合、self.to_yaml した結果、"!binary ..." というよ
うな文字列を返します。

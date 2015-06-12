複数の YAML ドキュメントを一度に扱うためのサブライブラリです。

#@since 1.9.2
= class Syck::Stream < Object
#@else
= class YAML::Stream < Object
#@end

YAML ドキュメントを複数保持することができるストリームクラスです。

=== 参考

Rubyist Magazine: [[url:http://magazine.rubyist.net/]]

 * プログラマーのための YAML 入門 (中級編): [[url:http://magazine.rubyist.net/?0010-YAML]]

== class methods

#@since 1.9.2
--- new(opts = {}) -> Syck::Stream
#@else
--- new(opts = {}) -> YAML::Stream
#@end

ストリームを返します。ストリームはYAMLドキュメントを複数保持することができます。

@param opts オプションを指定します。設定可能なオプションは
#@since 1.9.2
            [[m:Syck::DEFAULTS]] を参照してください。
#@else
            [[m:YAML::DEFAULTS]] を参照してください。
#@end

#@since 1.9.2
@see [[m:Syck::Stream#options]], [[m:Syck::Stream#options=]]
#@else
@see [[m:YAML::Stream#options]], [[m:YAML::Stream#options=]]
#@end

== instance methods

--- [](i) -> object

i番目のドキュメントを参照します。

@param i 参照したいドキュメントの番号を指定します。

  require 'yaml'
  
  class Dog
    attr_accessor :name
    def initialize(name)
      @name = name
    end
  end
  
  ys = YAML::Stream.new
  begin
    ys[0] = Dog.new("kuro")
  rescue
    p $!
    #=> #<NoMethodError: undefined method `[]=' for #<YAML::Stream:0x2b07d48 @documents=[], @options={}>>
  end
  
  ys.add Dog.new("pochi")
  p ys[0]
  #=> #<Dog:0x2b07b04 @name="pochi">

--- add(doc) -> ()

オブジェクトをドキュメントに追加します。

@param doc 適切なオブジェクトを指定します。

  require 'yaml'
  
  class Dog
    attr_accessor :name
    def initialize(name)
      @name = name
    end
  end
  
  str1=<<EOT
  --- !ruby/Dog
  name: pochi
  EOT
  
  ys = YAML.load_stream(str1)
  p ys.documents
  #=> [#<YAML::DomainType:0x2b07af0 @value={"name"=>"pochi"}, @type_id="Dog", @domain="ruby.yaml.org,2002">]
  ys.add(Dog.new("tama"))
  p ys.documents
  #=> [#<YAML::DomainType:0x2b07af0 @value={"name"=>"pochi"}, @type_id="Dog", @domain="ruby.yaml.org,2002">, #<Dog:0x2b079b0 @name="tama">]

--- edit(doc_num, doc) -> ()

doc_num番目のドキュメントをdocに変更します。
もし、doc_numが現在のドキュメント数より大きい場合は間にはnilが挿入されます。

@param doc_num 変更されるドキュメントの番号
@param doc 適切なオブジェクト

  require 'yaml'
  
  class Dog
    attr_accessor :name
    def initialize(name)
      @name = name
    end
  end
  
  ys = YAML::Stream.new
  ys.add(Dog.new("tama"))
  ys.edit(1, Dog.new("pochi"))
  ys.edit(5, Dog.new("jack"))
  p ys.documents
  #=> [#<Dog:0x2b07c44 @name="tama">, #<Dog:0x2b07c1c @name="pochi">, nil, nil, nil, #<Dog:0x2b07bf4 @name="jack">]

--- emit(io = nil) -> IO | String

ストリームに含まれる各ドキュメントを引数 io に YAML 形式で書き込みます。
io が nil の場合は文字列を返します。

@param io 書き込み先の IO オブジェクト

  require 'yaml'
  
  class Dog
    attr_accessor :name
    def initialize(name)
      @name = name
    end
  end
  
  ys = YAML::Stream.new
  ys.add(Dog.new("pochi"))
  ys.edit(1, { :age => 17, :color => "white"})
  ys.edit(2, [ "Chiba", "Saitama"])
  ys.emit.split(/\n/).each {|l|
    puts l
  }
  
  #結果
  --- !ruby/object:Dog
  name: pochi
  ---
  :age: 17
  :color: white
  ---
  - Chiba
  - Saitama

--- documents -> Array

自身のドキュメントを配列で返します。

  require 'yaml'
  
  str1=<<EOT
  --- !ruby/Dog
  name: pochi
  --- 
  :age: 17
  :color: white
  EOT
  
  ys = YAML.load_stream(str1)
  p ys.documents.pop
  #=> {:age=>17, :color=>"white"}
  p ys.documents.pop
  #=> #<YAML::DomainType:0x2b07e24 @type_id="Dog", @domain="ruby.yaml.org,2002", @value={"name"=>"pochi"}>
  p ys.documents.pop
  #=> nil

--- documents=(val)

現在のドキュメントを配列で設定します。

@param val YAML に変換できる任意のオブジェクトを配列で指定します。

--- options -> {Symbol => object}

オプションの一覧を返します。

--- options=(val)

オプションの一覧を設定します。

@param val 設定を [[c:Hash]] オブジェクトで指定します。設定可能なオプショ
#@since 1.9.2
           ンは [[m:Syck::DEFAULTS]] を参照してください。
#@else
           ンは [[m:YAML::DEFAULTS]] を参照してください。
#@end

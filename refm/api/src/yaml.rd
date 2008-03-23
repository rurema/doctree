#@since 1.8.0
構造化されたデータを表現するフォーマットであるYAML (YAML Ain't Markup Language) を扱うためのライブラリです。

例１: 構造化された配列
  require 'yaml'

  data = [ "Taro san", "Jiro san", "Saburo san"]
  str_r = YAML.dump(data)

  str_l =<<EOT
  --- 
  - Taro san
  - Jiro san
  - Saburo san
  EOT

  p str_r == str_l #=> true

例２：構造化されたハッシュ

  require 'yaml'
  require 'date'

  str_l =<<YAML_EOT
  Tanaka Taro: { age: 35, birthday: 1970-01-01}
  Suzuki Suneo: {
    age: 13,
    birthday: 1992-12-21
  }
  YAML_EOT

  str_r = {}
  str_r["Tanaka Taro"] = {
    "age" => 35,
    "birthday" => Date.new(1970, 1, 1)
  }
  str_r["Suzuki Suneo"] = {
    "age" => 13,
    "birthday" => Date.new(1992, 12, 21)
  }

  p str_r == YAML.load(str_l) #=> true

例３：構造化されたログ

  require 'yaml'
  require 'stringio'

  strio_r = StringIO.new(<<EOT
  ---
  time: 2008-02-25 17:03:12 +09:00
  target: YAML
  version: 4
  log: | 
    例を加えた。
    アブストラクトを修正した。
  ---
  time: 2008-02-24 17:00:35 +09:00
  target: YAML
  version: 3
  log: | 
    アブストラクトを書いた。 

  EOT
  )

  YAML.load_stream(strio_r).documents.sort{|a, b| a["version"] <=> b["version"]}.each{|obj|
    printf "version %d\ntime %s\ntarget:%s\n%s\n", obj["version"], obj["time"], obj["target"], obj["log"]
  }

#@include(yaml/YAML)
#@include(yaml/Stream)
#@include(yaml/Error)
#@include(yaml/YPath)
#@include(yaml/BaseNode)
#@include(yaml/YamlNode)

== Constants

--- DEFAULTS

YAMLのデフォルトの設定のハッシュです。
#@if (version >= 1.8.3)
Ruby 1.8.3 以降では変更できません。
#@end

下記のオプションがあります。
 {  
  :SortKeys=>false, 
  :UseFold=>false, 
  :AnchorFormat=>"id%03d",
  :Encoding=>:None, 
  :Indent=>2, 
  :ExplicitTypes=>false, 
  :UseHeader=>false, 
  :WidthType=>"absolute", 
  :UseVersion=>false, 
  :BestWidth=>80, 
  :Version=>"1.0", 
  :UseBlock=>false
 }

#@end

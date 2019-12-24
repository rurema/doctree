YAML 関連の定数のためのサブライブラリです。

#@since 1.9.2
= reopen Syck
#@else
= reopen YAML
#@end

== Constants

--- VERSION -> "0.60"

このライブラリのバージョンを文字列で返します。

--- SUPPORTED_YAML_VERSIONS -> ["1.0"]

サポートする YAML のバージョンを文字列の配列で返します。

--- DEFAULTS -> Hash

YAMLのデフォルトの設定のハッシュです。
Ruby 1.8.3 以降では変更できません。

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

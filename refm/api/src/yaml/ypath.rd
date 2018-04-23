YAML ドキュメントから特定のデータを検索する機能を提供するサブライブラリ
です。

#@since 1.9.2
= class Syck::YPath
#@else
= class YAML::YPath
#@end

YAML ドキュメントから特定のデータを検索する機能を提供するクラスです。

使用例；"name" を含むセグメントを表示する。

#@since 1.9.3
  require 'syck'
#@end
  require 'yaml'

  YAML.parse_documents(DATA){|doc|
    doc.search('/*//name').each {|node|
      YAML::YPath.each_path(node){|u|
        p u.segments
      }
    }
  }

  __END__
  cat:
   - name: taro
     age: 7
   - name: jiro
     age: 23
  ---
  dog:
   shiba:
    - name: goro
      age: 3
    - name: rokuro
      age: 1
  # end of sample

=== 参考

Rubyist Magazine: [[url:https://magazine.rubyist.net/]]

 * プログラマーのための YAML 入門 (探索編): [[url:https://magazine.rubyist.net/articles/0013/0013-YAML.html]]

== class methods

#@since 1.9.2
--- new(str) -> Syck::YPath
#@else
--- new(str) -> YAML::YPath
#@end

自身を初期化します。

@param str YPath でパース可能なパスを文字列で指定します。

例:

#@since 1.9.3
  require 'syck'
#@end
  require 'yaml'

  str = "/ugo[:hoge]/0/name"

  p YAML::YPath.new(str)
  #=> #<YAML::YPath:0x3238cc @predicates=[":hoge", nil, nil], @segments=["ugo", "0", "name"], @flags=nil>


--- each_path(str) {|ypath| ...} -> Array

#@since 1.9.2
引数 str を [[c:Syck::YPath]] が
#@else
引数 str を [[c:YAML::YPath]] が
#@end
検索できる複数のパスに再構築して、その各パスに対してブロックを評価します。

各パスに対してブロックを評価した結果の配列を返します。

例1: YAML::YPath.each_path を使用する場合

#@since 1.9.3
  require 'syck'
#@end
  require 'yaml'

  path = "/*/((one|three)/name|place)|//place"
  YAML::YPath.each_path(path) { |ypath|
    ...
  }

例2: YAML::YPath.each_path を使用しない場合

#@since 1.9.3
  require 'syck'
#@end
  require 'yaml'

  ["/*/one/name", "/*/three/name", "/*/place", "//place"].each do |path|
    ypath = YAML::YPath.new(path)
    ...
  end

== instance methods
--- segments -> [String]

検索するパスを / で区切った文字列の配列を返します。

--- segments=(val)

検索するパスを文字列の配列で設定します。

@param val 文字列の配列を指定します。

--- predicates -> [String]

self.segments の同じ位置に対応する検索条件を文字列の配列で返します。

--- predicates=(val)

self.segments の同じ位置に対応する検索条件を文字列の配列で設定します。

@param val 検索条件を文字列の配列で指定します。

--- flags -> nil

使用されていません。常に nil を返します。

--- flags=(val)

使用されていません。

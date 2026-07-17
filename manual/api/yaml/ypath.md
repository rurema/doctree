YAML ドキュメントから特定のデータを検索する機能を提供するサブライブラリ
です。

# class Syck::YPath

YAML ドキュメントから特定のデータを検索する機能を提供するクラスです。

使用例；"name" を含むセグメントを表示する。

```ruby
require 'syck'
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
```

### 参考

Rubyist Magazine: <https://magazine.rubyist.net/>

 - プログラマーのための YAML 入門 (探索編): <https://magazine.rubyist.net/articles/0013/0013-YAML.html>

## class methods

### def new(str) -> Syck::YPath

自身を初期化します。

- **param** `str` -- YPath でパース可能なパスを文字列で指定します。

```ruby title="例"
require 'syck'
require 'yaml'

str = "/ugo[:hoge]/0/name"

p YAML::YPath.new(str)
#=> #<YAML::YPath:0x3238cc @predicates=[":hoge", nil, nil], @segments=["ugo", "0", "name"], @flags=nil>
```


### def each_path(str) {|ypath| ...} -> Array

引数 str を [c:Syck::YPath] が
検索できる複数のパスに再構築して、その各パスに対してブロックを評価します。

各パスに対してブロックを評価した結果の配列を返します。

例1: YAML::YPath.each_path を使用する場合

```text
require 'syck'
require 'yaml'

path = "/*/((one|three)/name|place)|//place"
YAML::YPath.each_path(path) { |ypath|
  ...
}
```

例2: YAML::YPath.each_path を使用しない場合

```text
require 'syck'
require 'yaml'

["/*/one/name", "/*/three/name", "/*/place", "//place"].each do |path|
  ypath = YAML::YPath.new(path)
  ...
end
```

## instance methods
### def segments -> [String]

検索するパスを / で区切った文字列の配列を返します。

### def segments=(val)

検索するパスを文字列の配列で設定します。

- **param** `val` -- 文字列の配列を指定します。

### def predicates -> [String]

self.segments の同じ位置に対応する検索条件を文字列の配列で返します。

### def predicates=(val)

self.segments の同じ位置に対応する検索条件を文字列の配列で設定します。

- **param** `val` -- 検索条件を文字列の配列で指定します。

### def flags -> nil

使用されていません。常に nil を返します。

### def flags=(val)

使用されていません。

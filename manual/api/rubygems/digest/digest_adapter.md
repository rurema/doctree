---
type: library
---
Ruby 1.8.5 と 1.8.6 の間に存在する API の差異を吸収するためのライブラリです。

古いバージョンの API を新しいバージョンのものに合わせます。
RubyGems では digest, hexdigest の二つのメソッドが使用されるのでこの二つのメソッドのみ
API を変換するようにしています。

Ruby 1.8.6 以降ではこのライブラリは使用されません。

- **SEE** [lib:digest]

# class Gem::DigestAdapter

## Public Instance Methods

### def digest(string) -> String
#@todo

与えられた文字列のダイジェストを返します。

- **param** `string` -- ダイジェストを取得したい文字列を指定します。

### def hexdigest(string) -> String
#@todo

与えられた文字列のヘックスダイジェストを返します。

- **param** `string` -- ダイジェストを取得したい文字列を指定します。

### def new -> self
#@todo

## Singleton Methods

### def new(digest_class)

自身を初期化します。

#@since 1.8.0
RubyのオブジェクトをYAML形式の外部ファイルに格納するためのクラスです。

  require "yaml/store"

  db = YAML::Store.new("sample.yml")
  db.transaction do
    db["hoge"] = {1 => 100, "bar" => 101}
  end

= class YAML::Store < PStore

[[c:PStore]] の [[c:YAML]] 版です。
[[m:Marshal.#dump]] したバイナリ形式の
代わりに YAML 形式でファイルに保存します。

使い方は [[c:PStore]] とほとんど同じです。
インターフェースは [[c:Hash]] に似ています。 

== class methods
--- new(*options)

YAML形式のファイルを読み込ませたい場合は、最初の引数にファイル名を文字列で指定します。
最後の引数がハッシュであった場合は、YAMLのデフォルトの設定を変更します。

@param options 読み込ませたいファイルや、オプションを与えます。

@see [[m:YAML::DEFAULTS]]

== instance methods
--- [](name) -> object
ルートnameに対応する値を得ます。

@param name 探索するルートの名前を指定します。

  require 'yaml/store'

  db = YAML::Store.new('/tmp/store.yaml')
  db.transaction {
    db["hoge"] = [ 1, 2, 3, 4]
  }

  db.transaction {
    p db["hoge"] #=> [1, 2, 3, 4]
  }

--- fetch(name, default = PStore::Error) -> object

ルートnameに対応する値を得る。

該当するルートが登録されていない時には、
引数 default が与えられていればその値を返し、
与えられていなければ例外 [[c:PStore::Error]] が発生します。 

@param name 探索するルートを文字列で指定します。
@param default name に対応するルートが登録されていない場合に返す値を指定します。

@raise PStore::Error name に対応するルートが登録されていないかつ、
                     default が与えられていない場合に発生します。
                     また、トランザクション外でこのメソッドが呼び出された場合に発生します。 

  require 'yaml/store'

  db = YAML::Store.new('/tmp/store.yaml')
  db.transaction {
    db["hoge"] = [ 1, 2, 3, 4]
  }

  db.transaction {
    p db.fetch("hoge") #=> [1, 2, 3, 4]
    begin
      p db.fetch("fuga")
    rescue PStore::Error
      puts "name に対応するルートが登録されていなく、さらに、 default が与えられていません。"
    end
    p db.fetch("fuga", "ugougo") #=> "ugougo"
  }

--- []=(name, value) -> object
ルート name に対応する値 value を代入します。

@param name 探索するルートの名前を指定します。
@param value 代入するオブジェクトを指定します。

  require 'yaml/store'

  class HogeHoge
    def initialize
      @ho = 'hoge'
      @ge = 'fuga'
    end
  end

  hoge = HogeHoge.new

  db = YAML::Store.new('/tmp/store.yaml')
  db.transaction {
    db["hoge"] = hoge
  }

  db.transaction {
    p db["hoge"] #=> #<HogeHoge:0x3bcc5c @ho="hoge", @ge="fuga">
  }

--- delete(name) -> object | nil
ルートnameに対応する値を削除します。 

@param name 探索するルートの名前を指定します。

@return 削除した値を返します。ルートが存在しない場合はnilを返します。

@raise PStore::Error トランザクション外でこのメソッドが呼び出された場合に発生します。 

  require 'yaml/store'

  db = YAML::Store.new('/tmp/store.yaml')
  db.transaction {
    db["hoge"] = [ 1, 2, 3, 4]
    db["fuga"] = [ 5, 6, 7]
  }

  rt = ''
  db.transaction {
    rt = db.delete("fuga") 
    p db.delete("ugougo") #=> nil
  }

  p rt #=> [5, 6, 7]
  begin
    db.delete("hoge")
  rescue PStore::Error
    puts "transaction に与えるブロックのなかでdelete は呼び出す。"
  end

--- roots -> Array
ルートの集合を配列で返します。 

@raise PStore::Error トランザクション外でこのメソッドが呼び出された場合に発生します。 

  require 'yaml/store'

  db = YAML::Store.new('/tmp/store.yaml')
  db.transaction {
    db["hoge"] = [ 1, 2, 3, 4]
    db["fuga"] = [ 5, 6, 7]
  }

  db.transaction {
    p db.roots #=> ["fuga", "hoge"]
  }

  begin
    p db.roots
  rescue PStore::Error
    puts "transaction に与えるブロックのなかでroots は呼び出す。"
  end

--- root?(name) -> bool
ルート name がデータベースに格納されている場合に真を返します。

@param name 探索するルートの名前を指定します。

@raise PStore::Error トランザクション外でこのメソッドが呼び出された場合に発生します。 

  require 'yaml/store'

  db = YAML::Store.new('/tmp/store.yaml')
  db.transaction {
    db["hoge"] = [ 1, 2, 3, 4]
    db["fuga"] = [ 5, 6, 7]
  }

  db.transaction {
    p db.root?('fuga')   #=> true
    p db.root?('ugougo') #=> false
  }

  begin
    p db.root?('hoge')
  rescue PStore::Error
    puts "transaction に与えるブロックのなかでroot? は呼び出す。"
  end

--- path -> String
データベースのファイル名を得ます。 

  require 'yaml/store'

  db = YAML::Store.new('/tmp/store.yaml')
  db.transaction {
    p db.path #=> /tmp/store.yaml
  }

--- commit -> ()
データベースの読み書きを終了します。 

@raise PStore::Error トランザクション外でこのメソッドが呼び出された場合に発生します。 

  require 'yaml/store'

  db = YAML::Store.new('/tmp/store.yaml')
  db.transaction {
    db["hoge"] = [ 1, 2, 3, 4]
    db["fuga"] = [ 5, 6, 7]
    db.commit
    db["ugougo"] = [ 8, 9, 10]
  }

  db.transaction {
    p db.root?("fuga")   #=> true
    p db.root?('ugougo') #=> false
  }

  begin
    p db.commit
  rescue PStore::Error
    puts "transaction に与えるブロックのなかでcommit は呼び出す。"
  end

--- abort -> ()
データベースの読み書きを終了する。
transaction ブロックから抜けますが、データベースの変更は反映されません。 

@raise PStore::Error トランザクション外でこのメソッドが呼び出された場合に発生します。 

  require 'yaml/store'
  require 'tmpdir'

  db = YAML::Store.new("/#{Dir.tmpdir}/#{$$}.yaml")
  db.transaction {
    db["hoge"] = [ 1, 2, 3, 4]
    db["fuga"] = [ 5, 6, 7]
    db.abort
    db["ugougo"] = [ 8, 9, 10]
  }

  db.transaction {
    p db.root?("hoge")   #=> false
    p db.root?('ugougo') #=> false
  }

  begin
    p db.abort
  rescue PStore::Error
    puts "transaction に与えるブロックのなかでabort は呼び出す。"
  end

--- transaction(read_only = false) -> ()
トランザクションに入ります。このブロックの中でのみデータベースの読み書きができます。
読み込み専用のトランザクションが使用可能です。 

@param read_only 真を指定すると、読み込み専用のトランザクションになります。 

@raise PStore::Error read_only を真にしたときに、データベースを変更しようした場合に発生します。 

  require 'yaml/store'

  db = YAML::Store.new("/tmp/store.yaml")
  db.transaction {
    db["hoge"] = [ 1, 2, 3, 4]
  }

  begin
    db.transaction(true) {
      db["hoge"] = [ 1, 2, 3, 4]
    }
  rescue PStore::Error
    puts "読み込み専用のトランザクションに書き込もうとしました。 "
  end


使い方は [[c:PStore]] とほとんど同じです。

例

  require "yaml/store"

  db = YAML::Store.new("sample.yml")
  db.transaction do
    db["hoge"] = {1 => 100, "bar" => 101}
  end

  # sample.yml
  hoge:
    1: 100
    bar: 101

[[c:PStore]] 同様、ユーザが定義したクラスのオブジェクトを保存することもできます。

  require "yaml/store"
  
  class Foo
    attr_accessor :foo
  end
  
  db = YAML::Store.new("sample.yml")
  db.transaction do
    f = Foo.new
    f.foo = 777
    db["bar"] = f
  end
  
  # sample.yml
  bar: !ruby/object:Foo
    foo: 777
#@end

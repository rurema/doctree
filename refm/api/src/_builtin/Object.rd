= Object

全てのクラスのスーパークラス。
オブジェクトの一般的な振舞いを定義します。

== インクルードしているモジュール:

* ((<Kernel>))

== メソッド一覧:

=== インスタンスメソッド:

((<Object/__id__>))
((<Object/__send__>))
((<Object/class>))
((<Object/clone>))
((<Object/display>))
((<Object/dup>))
((<Object/eql?>))
((<Object/equal?>))
((<Object/extend>))
((<Object/freeze>))
((<Object/frozen?>))
((<Object/hash>))
((<Object/id>))
((<Object/inspect>))
((<Object/instance_eval>))
((<Object/instance_of?>))
((<Object/instance_variable_get>))
((<Object/instance_variable_set>))
((<Object/instance_variables>))
((<Object/is_a?>))
((<Object/kind_of?>))
((<Object/method>))
((<Object/method_missing>))
((<Object/methods>))
((<Object/methods>))
((<Object/nil?>))
((<Object/object_id>))
((<Object/private_methods>))
((<Object/private_methods>))
((<Object/protected_methods>))
((<Object/protected_methods>))
((<Object/public_methods>))
((<Object/public_methods>))
((<Object/respond_to?>))
((<Object/self===>))
((<Object/self==>))
((<Object/self=~>))
((<Object/send>))
((<Object/singleton_methods>))
((<Object/taint>))
((<Object/tainted?>))
((<Object/to_a>))
((<Object/to_ary>))
((<Object/to_hash>))
((<Object/to_int>))
((<Object/to_s>))
((<Object/to_str>))
((<Object/type>))
((<Object/untaint>))

=== プライベートメソッド:

((<Object/initialize>))
((<Object/initialize_copy>))
((<Object/remove_instance_variable>))
((<Object/singleton_method_added>))
((<Object/singleton_method_removed>))
((<Object/singleton_method_undefined>))


== メソッド:

--- self==(other)

    (({self})) と ((|other|)) が等しければ真を返します。
    デフォルトでは (({equal?})) と同じ効果です。

    このメソッドは各クラスの性質に合わせて再定義するべきです。

--- self=~(other)

    右辺に正規表現オブジェクトを置いた正規表現マッチ (({obj =~ /RE/})) 
    をサポートするためのメソッドです。常に false を返します。

    この定義により例えば

        nil =~ /re/

    は正常に false を返します。

--- self===(other)

    このメソッドは ((<制御構造/case>)) 
    文での比較に用いられます。デフォルトは
    ((<Object#==|Object/==>)) と同じ働きをしますが、
    この挙動はサブクラスで所属性のチェックを実現するため
    適宜再定義されます。

--- class
--- type        ((<obsolete>))

    レシーバのクラスを返します。

    ((<ruby 1.7 feature>)): type は、version 1.7 では、((<obsolete>)) 
    となりました。

--- clone
--- dup

    オブジェクトの複製を作成して返します。

    (({clone})) は (({freeze}))、(({taint}))、特異メソッドなどの情報も
    含めた完全な複製を、(({dup})) はオブジェクトの内容のみの複製を
    作ります。

    (({clone})) や (({dup})) は「浅い(shallow)」コピーであることに注意
    してください。オブジェクト自身を複製するだけで、オブジェクトの指し
    ている先(たとえば配列の要素など)までは複製しません。
    ((-深い(deep)コピーが必要な場合には、
    (({Marshal.load(Marshal.dump(obj)}))を
    使ってください。ただしMarshal出来ないオブジェクトが
    含まれている場合には使えません。-))

    また複製したオブジェクトに対して

      obj.equal?(obj.clone)

    は一般に成立しませんが
    ((-version 1.6 では、0.equal?(0.clone) が成立してしまいます-))、

      obj == obj.clone

    は多くの場合に成立します。

    (({true})), (({false})), (({nil})), ((<Symbol>)) オブジェクトなど
    を複製しようとすると例外 ((<TypeError>)) が発生します。

    ((<ruby 1.7 feature>)):
    version 1.7 では、((<Numeric>)) オブジェクトなど immutable(内容不
    変)であるオブジェクトを複製しようとすると例外 ((<TypeError>)) が発
    生します。

--- display(out = $stdout)

    オブジェクトを ((|out|)) に出力します。以下のように定義されています。

      class Object
        def display(out=$stdout)
          out.print to_s
          nil
        end
      end

    (({nil})) を返します。

--- eql?(other)

    二つのオブジェクトが等しければ真を返します。((<Hash>)) で二つのキー
    が等しいかどうかを判定するのに使われます。

    このメソッドを再定義した時には ((<Object#hash|Object/hash>)) メソッ
    ドも再定義しなければなりません。

    (({eql?})) のデフォルトの定義は (({equal?})) と同じくオブジェクト
    の同一性判定になっています。

--- equal?(other)

    (({other})) が (({self})) 自身の時、真を返します。

    このメソッドを再定義してはいけません。

--- extend(module ... )

    引数で指定したモジュールのインスタンスメソッドを (({self})) の特異
    メソッドとして追加します。(({self})) を返します。

    ((<Module/include>)) は、クラス(のインスタンス)に機能を追加します
    が、extend は、ある特定のオブジェクトだけにモジュールの機能を追加
    したいときに使用します。

        module Foo
          def a
            'ok'
          end
        end

        obj = Object.new
        obj.extend Foo
        p obj.a         #=> "ok"

    (({extend})) の機能は、「特異クラスに対する ((<Module/include>))」
    と言い替えることもできます。

    ((<ruby 1.7 feature>)): 引数に複数のモジュールを指定した場合、最後
    の引数から逆順に extend を行います。

--- freeze

    オブジェクトの内容の変更を禁止します。(({self})) を返します。

    フリーズされたオブジェクトの変更は例外 ((<TypeError>)) を発生させます。

--- frozen?

    オブジェクトの内容の変更が禁止されているときに真を返します。

--- hash

    オブジェクトのハッシュ値を返します。((<Hash>)) クラスでオブジェク
    トを格納するのに用いられています。

    (({A.eql?(B)})) が成立する時は必ず (({A.hash == B.hash})) も成立し
    なければいけません。(({eql?}))を再定義した時には必ずこちらも合わせ
    て再定義してください。

    デフォルトでは、((<Object#__id__|Object/__id__>)) と同じ値を返します。
    ただし、((<Fixnum>)), ((<Symbol>)), ((<String>)) だけは組込みのハッ
    シュ関数が使用されます(これを変えることはできません)。

    hash を再定義する場合は、一様に分布する任意の整数を返すようにしま
    す。

--- id                  ((<obsolete>))
--- __id__
--- object_id         ((<ruby 1.7 feature>))

    各オブジェクトに対して一意な整数を返します。あるオブジェクトに対し
    てどのような整数が割り当てられるかは不定です。

    (({id})) メソッドの再定義に備えて別名 (({__id__})) が用意されて
    おり、ライブラリでは後者の利用が推奨されます。また (({__id__})) を
    再定義すべきではありません。

    ((<ruby 1.7 feature>)): id は、version 1.7 では、((<obsolete>)) 
    となりました。

--- inspect

    オブジェクトを人間が読める形式に変換した文字列を返します。

    組み込み関数 ((<組み込み関数/p>)) は、このメソッドの結果を使用して
    オブジェクトを表示します。

--- instance_eval(expr, [fname, [lineno=1]])
--- instance_eval {|obj| ... }

    オブジェクトのコンテキストで文字列 ((|expr|)) を評価してその結果を
    返します。

    ((|fname|))、((|lineno|)) が与えられた場合は、ファイル ((|fname|))、
    行番号 ((|lineno|)) にその文字列があるかのようにコンパイルされ、ス
    タックトレース表示などのファイル名／行番号を差し替えることができま
    す。

    ブロックが与えられた場合にはそのブロックをオブジェクトのコンテキス
    トで評価してその結果を返します。ブロックの引数 ((|obj|)) には 
    (({self})) が渡されます。

    オブジェクトのコンテキストで評価するとは (({self})) をそのオブジェ
    クトにして実行するということです。また、文字列／ブロック中でメソッ
    ドを定義すれば (({self})) の特異メソッドが定義されます。

    ただし、ローカル変数だけは (({instance_eval})) の外側のスコープと
    共有します。

    ((*注*)): メソッド定義の中で instance_eval のブロックを使用してメ
    ソッド定義を行うと、"nested method definition" とコンパイルエラー
    になります。これは、現在の ruby パーサの制限です。

        def foo
           instance_eval {
             def bar            # <- ネストしたメソッド定義と判断される
               "bar"
             end
           }
        end

        # => -:4: nested method definition

    文字列で渡す形式を使えば、この制限は回避できます。

        def foo
           instance_eval %Q{
             def bar
               "bar"
             end
           }
        end

        # foo を実行すると関数(厳密には foo のレシーバのメソッド) bar 
        # を定義する
        foo
        p bar
        # => "bar"

    ((<ruby 1.7 feature>)): メソッド定義のネストに関して、この制限はな
    くなっています。さらに、version 1.7 以降 instance_eval を使わなく
    ても以下で同じことができます(厳密には異なります。
    ((<クラス／メソッドの定義/メソッド定義のネスト>)) を参照してくださ
    い)。

        def foo
           def bar
             "bar"
           end
        end

        foo
        p bar
        # => "bar"

    ((<Module#module_eval|Module/module_eval>)),
    ((<Module#class_eval|Module/class_eval>)) も参照してください。

--- instance_of?(klass)

    (({self})) がクラス ((|klass|)) の直接のインスタンスである時、
    真を返します。

    (({obj.instance_of?(c)})) が成立する時には、常に
    (({obj.kind_of?(c)})) も成立します。

    ((<Object/kind_of?>)) も参照してください。

--- instance_variable_get(var)

    ((<ruby 1.8 feature>))

    オブジェクトのインスタンス変数の値を取得して返します。

    ((|var|)) にはインスタンス変数名を文字列か ((<Symbol>)) で指定しま
    す。

    インスタンス変数が定義されていなければ (({nil})) を返します。

        class Foo
          def initialize
            @foo = 1
          end
        end

        obj = Foo.new
        p obj.instance_variable_get("@foo")     # => 1
        p obj.instance_variable_get(:@foo)      # => 1
        p obj.instance_variable_get(:@bar)      # => nil

--- instance_variable_set(var, val)

    ((<ruby 1.8 feature>))

    オブジェクトのインスタンス変数に値 ((|val|)) を設定して ((|val|)) 
    を返します。


    ((|var|)) にはインスタンス変数名を文字列か ((<Symbol>)) で指定しま
    す。

    インスタンス変数が定義されていなければ新たに定義されます。

        obj = Object.new
        p obj.instance_variable_set("@foo", 1)  # => 1
        p obj.instance_variable_set(:@foo, 2)   # => 2
        p obj.instance_variable_get(:@foo)      # => 2

--- instance_variables

    オブジェクトのインスタンス変数名を文字列の配列として返します。

        obj = Object.new
        obj.instance_eval { @foo, @bar = nil }
        p obj.instance_variables

        # => ["@foo", "@bar"]

    ((<組み込み関数/local_variables>)),
    ((<組み込み関数/global_variables>)),
    ((<Module/Module.constants>)),
    ((<Module#constants|Module/constants>)),
    ((<Module#class_variables|Module/class_variables>))
    も参照してください。

--- is_a?(mod)
--- kind_of?(mod)

    (({self})) が、クラス ((|mod|)) とそのサブクラス、および
    モジュール ((|mod|)) をインクルードしたクラスとそのサブクラス、
    のいずれかのインスタンスであるとき真を返します。

        module M
        end
        class C < Object
          include M
        end
        class S < C
        end

        obj = S.new
        p obj.is_a? S       # true
        p obj.is_a? M       # true
        p obj.is_a? C       # true
        p obj.is_a? Object  # true
        p obj.is_a? Hash    # false

    ((<Object/instance_of?>)), ((<Module#===|Module/===>)) も参照してください。

--- method(name)

    (({self})) のメソッド ((|name|)) をオブジェクト化した 
    ((<Method>)) オブジェクトを返します。((|name|)) は 
    ((<Symbol>)) または文字列で指定します。

    ((<Module#instance_method|Module/instance_method>)) も参照してください。

--- method_missing(name, args, ... )

    呼びだされたメソッドが定義されていなかった時、Ruby がこのメソッド
    を呼び出します。

    呼び出しに失敗したメソッドの名前 (((<Symbol>))) が ((|name|)) に
    その時の引数が ((|arg ...|)) に渡されます。

    デフォルトではこのメソッドは例外 ((<NameError>)) を発生させます。

--- methods
--- public_methods
--- private_methods
--- protected_methods
--- methods([inherited_too])            ((<ruby 1.8 feature>))
--- public_methods([inherited_too])     ((<ruby 1.8 feature>))
--- private_methods([inherited_too])    ((<ruby 1.8 feature>))
--- protected_methods([inherited_too])  ((<ruby 1.8 feature>))

    そのオブジェクトが理解できる public/private/protected メソッド名の
    一覧を文字列の配列で返します。

    methods は、instance_methods と同じです。
    ((<ruby 1.7 feature>)): methods は、public および protected メソッ
    ド名の一覧を配列で返します。

    ((<ruby 1.8 feature>)): 引数が指定できるようになりました。
    ((|inherited_too|)) が真であれば、スーパークラスで定義されたメソッ
    ドも探索します。デフォルトは真です。

    methods(false) は、((<Object/singleton_methods>))(false) と同じで
    す。

    例:

        class Foo
          private;   def private_foo()   end
          protected; def protected_foo() end
          public;    def public_foo()    end
        end

        class Bar < Foo
        end

        p Bar.new.methods           - Object.new.methods
        p Bar.new.public_methods    - Object.new.public_methods
        p Bar.new.private_methods   - Object.new.private_methods
        p Bar.new.protected_methods - Object.new.protected_methods
        => ["public_foo"]   # version 1.7 以降、["protected_foo", "public_foo"]
           ["public_foo"]
           ["private_foo"]
           ["protected_foo"]

    ((<Module#instance_methods|Module/instance_methods>)),
    ((<Module#public_instance_methods|Module/public_instance_methods>)),
    ((<Module#private_instance_methods|Module/private_instance_methods>)),
    ((<Module#protected_instance_methods|Module/protected_instance_methods>))
    も参照してください。

    ((<Object#singleton_methods|Object/singleton_methods>))
    も参照してください。

--- nil?

    レシーバが (({nil})) であれば真を返します。

--- respond_to?(name[, priv=false])

    オブジェクトが public メソッド ((|name|)) を持つとき真を返します。

    ((|name|)) は ((<Symbol>)) または文字列です。((|priv|)) が真のとき
    は private メソッドに対しても真を返します。

--- send(name[, args ... ])
--- send(name[, args ... ]) { .... }
--- __send__(name[, args ... ])
--- __send__(name[, args ... ]) { ... }

    オブジェクトのメソッド ((|name|)) を、引数に ((|args|)) を
    渡して呼び出し、メソッドの実行結果を返します。

    ブロック付きで呼ばれたときはブロックもそのまま引き渡します。メソッ
    ド名 ((|name|)) は文字列か((<Symbol>)) です。

    (({send})) が再定義された場合に備えて別名 (({__send__})) も
    用意されており、ライブラリではこちらを使うべきです。また
    (({__send__})) は再定義すべきではありません。

    (({send})), (({__send__})) は、((<クラス／メソッドの定義/呼び出し制限>))
    にかかわらず任意のメソッドを呼び出せます。

    ((<ruby 1.9 feature>)):
    ((<クラス／メソッドの定義/呼び出し制限>))が(({send})), (({__send__}))にも
    影響するようになり、レシーバを指定した呼び出しではprivateメソッドを
    呼び出せなくなりました。
    privateメソッドを呼び出す必要がある場合は((<Object/instance_eval>))を
    使用してください。

--- singleton_methods
--- singleton_methods([inherited_too])  ((<ruby 1.7 feature>))

    そのオブジェクトに対して定義されている特異メソッド名(publicメソッ
    ドのみ)の一覧を文字列の配列で返します。

    ((<ruby 1.7 feature>)): 引数が指定できるようになりました。
    ((|inherited_too|)) が偽であれば(1.8.0までのデフォルトは偽。1.8.1 
    以降のデフォルト値は真)、スーパークラスで定義されたメソッドは対象
    になりません。

    ((<ruby 1.8 feature>)): public あるいは protected 属性の特異メソッド
    名の一覧を返すようになりました。特に singleton_methods(false) は、
    ((<Object/methods>))(false) と同じです。

        obj = Object.new
        module Foo
          private;   def private_foo()   end
          protected; def protected_foo() end
          public;    def public_foo()    end
        end

        class <<obj
          include Foo
          private;   def private_bar()   end
          protected; def protected_bar() end
          public;    def public_bar()    end
        end
        p obj.singleton_methods
        p obj.singleton_methods(false)

        # => ["public_foo", "public_bar", "protected_foo", "protected_bar"]
             ["public_bar", "protected_bar"]

    あるいは、((<Object#extend|Object/extend>)) は特異クラスに対するイ
    ンクルードなので以下も同様になります。

        obj = Object.new

        module Foo
          private;   def private_foo()   end
          protected; def protected_foo() end
          public;    def public_foo()    end
        end

        obj.extend(Foo)
        p obj.singleton_methods
        p obj.singleton_methods(false)

        # => ["public_foo", "protected_foo"]
             []

    クラスメソッド(クラスオブジェクトの特異メソッド)に関しては引数が真
    のとき、スーパークラスのクラスメソッドも対象になります。

        class Foo
          def Foo.foo
          end
        end

        class Bar < Foo
          def Bar.bar
          end
        end

        p Bar.singleton_methods        #=> ["bar", "foo"]
        p Bar.singleton_methods(false) #=> ["bar"]

--- taint

    オブジェクトの「汚染マーク」をセットします。(({self})) を返します。

    オブジェクトの汚染に関しては((<セキュリティモデル>))を参照してください。

--- tainted?

    オブジェクトの「汚染マーク」がセットされている時真を返します。

    オブジェクトの汚染に関しては((<セキュリティモデル>))を参照してください。

--- to_a        ((<obsolete>))

    オブジェクトを配列に変換してその配列を返します。

    普通に配列に変換できないオブジェクトは、自身のみを含む長さ 1 の配
    列に変換されます

    (((<ruby 1.7 feature>)): Object のこのメソッドは将来なくなるかもし
    れません。1.7 では警告が出ます)。

    例
        p( {'a'=>1}.to_a )  # [["a", 1]]
        p ['array'].to_a    # ["array"]
        p 1.to_a            # [1]       (warning: default `to_a' will be obsolete)
        p 'str'.to_a        # ["str"]

    ((<ruby 1.8 feature>)):
    多重代入の右辺に (({*})) を伴ったオブジェクトが現れた場合、
    そのオブジェクトが to_a を定義していればその結果が利用されます。
    to_a が定義されていない場合は、右辺が自身を含む長さ 1 の配列に
    変換された後で代入が行われます。
    ((-あらい 2003-10-07: 覚書: 簡単に言えば、(({Array(右辺)})) と同じ
    規則で右辺が変換される。この辺りの記述は整理しなおすこと-))

        class Foo
          def to_a
            [1, 2, 3]
          end
        end

        a, b, c = *Foo.new
        p [a, b, c]

        # => [1, 2, 3]

--- to_ary

    オブジェクトを配列に変換してその配列を返します。

    オブジェクトの配列への暗黙の変換が必要なときに内部で呼ばれます。
    ((-to_ary, to_hash, to_int, to_str は、説明の便宜上このページに書
    いてますが、デフォルトでは (({Object})) のメソッドとしては定義され
    ていません-))

    このメソッドが定義されたオブジェクトが単独で多重代入の右辺に
    現れた場合にも呼ばれます。

        class Foo
          def to_ary
            [1, 2, 3]
          end
        end

        a, b, c = Foo.new
        p [a, b, c]

        => [1, 2, 3]

--- to_hash

    オブジェクトのハッシュへの暗黙の変換が必要なときに内部で呼ばれます。

--- to_int

    オブジェクトの整数への暗黙の変換が必要なときに内部で呼ばれます。

--- to_s

    オブジェクトの文字列表現を返します。

    ((<組み込み関数/print>)) や ((<組み込み関数/sprintf>)) は文字列以外の
    オブジェクトが引数に渡された場合このメソッドを使って文字列に変換し
    ます。

--- to_str

    オブジェクトの文字列への暗黙の変換が必要なときに呼ばれます。

--- untaint

    オブジェクトの「汚染マーク」を取り除きます。(({self})) を返します。

    汚染マークを取り除くことによる危険性はプログラマが責任を負う必要が
    あります。

    セキュリティレベルが3以上の場合は例外 ((<SecurityError>)) が
    発生します。

    オブジェクトの汚染に関しては((<セキュリティモデル>))を参照してください。

== プライベートメソッド:

--- initialize

    ユーザ定義クラスのオブジェクト初期化メソッド。

    このメソッドは ((<Class#new|Class/new>)) から新しく生成されたオブ
    ジェクトの初期化のために呼び出されます。デフォルトの動作ではなにも
    しません。サブクラスではこのメソッドを必要に応じて再定義されること
    が期待されています。(({initialize})) には 
    ((<Class#new|Class/new>)) に与えられた引数がそのまま渡されます。

    (({initialize})) という名前のメソッドは自動的に private に設定され
    ます。

--- initialize_copy(obj)

    ((<ruby 1.8 feature>))

    (拡張ライブラリによる)ユーザ定義クラスのオブジェクトコピー(clone,
    dup)の初期化メソッド。

    このメソッドは (({self})) を ((|obj|)) の内容で置き換えます。ただ
    し、self のインスタンス変数や特異メソッドは変化しません。

    レシーバが (({freeze})) されているか、((|obj|)) のクラスがレシーバ
    のクラスと異なる場合は例外 ((<TypeError>)) が発生します。

    デフォルトでは(Object#initialize_copy は)、上記の freeze チェックおよ
    び型のチェックを行い (({self})) を返すだけのメソッドです。

    obj.((<Object/dup>)) は、新たに生成したオブジェクトに対して 
    initialize_copy を呼び

        obj2 = obj.class.allocate
        obj2.initialize_copy(obj)

    obj2 に対してさらに obj の汚染状態、インスタンス変数、ファイナライ
    ザをコピーすることで複製を作ります。((<Object/clone>)) は、さらに
    特異メソッドのコピーも行います。

        obj = Object.new
        class <<obj
          attr_accessor :foo
          def bar
            :bar
          end
        end

        def check(obj)
          puts "instance variables: #{obj.inspect}"
          puts "tainted?: #{obj.tainted?}"
          print "singleton methods: "
          begin
            p obj.bar
          rescue NameError
            p $!
          end
        end

        obj.foo = 1
        obj.taint

        check Object.new.send(:initialize_copy, obj)
                # => instance variables: #<Object:0x4019c9d4>
                #    tainted?: false
                #    singleton methods: #<NoMethodError: ...>
        check obj.dup
                # => instance variables: #<Object:0x4019c9c0 @foo=1>
                #    tainted?: true
                #    singleton methods: #<NoMethodError: ...>
        check obj.clone
                # => instance variables: #<Object:0x4019c880 @foo=1>
                #    tainted?: true
                #    singleton methods: :bar

    initialize_copy は、Ruby インタプリンタが知り得ない情報をコピーするた
    めに使用(定義)されます。例えば C 言語でクラスを実装する場合、情報
    をインスタンス変数に保持させない場合がありますが、そういった内部情
    報を initialize_copy でコピーするよう定義しておくことで、dup や clone 
    を再定義する必要がなくなります。

    (({initialize_copy})) という名前のメソッドは自動的に private に設
    定されます。

--- remove_instance_variable(name)

    オブジェクトからインスタンス変数 ((|name|)) を取り除き、そのインス
    タンス変数に設定されていた値を返します。((|name|)) は ((<Symbol>)) 
    か文字列です。

    オブジェクトがインスタンス変数 ((|name|)) を持たない場合は例外 
    ((<NameError>)) が発生します。

        class Foo
          def foo
            @foo = 1
            p remove_instance_variable :@foo # => 1
            p remove_instance_variable :@foo # => instance variable @foo not defined (NameError)
          end
        end
        Foo.new.foo

    ((<Module#remove_class_variable|Module/remove_class_variable>)),
    ((<Module#remove_const|Module/remove_const>)) 
    も参照してください。

--- singleton_method_added(name)

    特異メソッドが追加された時にインタプリタから呼び出されます。
    ((|name|)) には追加されたメソッド名が ((<Symbol>)) で渡されます。

        class Foo
          def singleton_method_added(name)
            puts "singleton method \"#{name}\" was added"
          end
        end

        obj = Foo.new
        def obj.foo
        end

        => singleton method "foo" was added

    通常のメソッドの追加に対するフックには
    ((<Module#method_added|Module/method_added>))を使います。

--- singleton_method_removed(name)

    ((<ruby 1.7 feature>))

    特異メソッドが ((<Module#remove_method|Module/remove_method>)) に
    より削除された時にインタプリタから呼び出されます。
    ((|name|)) には削除されたメソッド名が ((<Symbol>)) で渡されます。

        class Foo
          def singleton_method_removed(name)
            puts "singleton method \"#{name}\" was removed"
          end
        end

        obj = Foo.new
        def obj.foo
        end

        class << obj
          remove_method :foo
        end

        => singleton method "foo" was removed

    通常のメソッドの削除に対するフックには
    ((<Module#method_removed|Module/method_removed>))を使います。

--- singleton_method_undefined(name)

    ((<ruby 1.7 feature>))

    特異メソッドが ((<Module#undef_method|Module/undef_method>)) または 
    ((<クラス／メソッドの定義/undef>)) により未定義にされた時にインタプリタ
    から呼び出されます。
    ((|name|)) には未定義にされたメソッド名が ((<Symbol>)) で渡されます。

        class Foo
          def singleton_method_undefined(name)
            puts "singleton method \"#{name}\" was undefined"
          end
        end

        obj = Foo.new
        def obj.foo
        end
        def obj.bar
        end

        class << obj
          undef_method :foo
        end
        obj.instance_eval {undef bar}

        => singleton method "foo" was undefined
           singleton method "bar" was undefined

    通常のメソッドの未定義に対するフックには 
    ((<Module#method_undefined|Module/method_undefined>)) を使います。

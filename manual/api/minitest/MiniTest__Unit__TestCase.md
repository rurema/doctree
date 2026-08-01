---
library: minitest/unit
include:
  - MiniTest::Assertions
since: "1.9.1"
until: "2.2.0"
---
# class MiniTest::Unit::TestCase

テストの基本単位(あるいは「テスト本体」)を表すクラスです。

テストを行うメソッド (テストメソッド) は TestCase のサブクラスの
インスタンスメソッドとして定義されます。
テストメソッドの名前は "test" で始まっていなければなりません。
逆に、"test" で始まっているメソッドは全てテストメソッドと見なされます。

## Public Instance Methods

### def __name__ -> String

自身の名前を返します。

### def passed? -> bool

自身の実行に成功した場合は真を返します。
そうでない場合は偽を返します。

### def run(runner) -> String

自身に関連付けられているテストを実行します。

[m:MiniTest::Unit::TestCase#setup] がサブクラスで再定義されている場合はそれらも実行します。

- **param** `runner` -- テストの実行結果を管理するオブジェクトを指定します。

### def setup

各テストケースの実行前に実行するメソッドです。

サブクラスで再定義します。

### def teardown

各テストケースの実行後に実行するメソッドです。

サブクラスで再定義します。

## Singleton Methods

### def MiniTest::Unit::TestCase.new(name)

自身を初期化します。

- **param** `name` -- 自身の名前を指定します。

### def MiniTest::Unit::TestCase.inherited(klass)

テストクラス名をテストスイート登録します。

### def MiniTest::Unit::TestCase.reset

テストスイートをクリアします。

### def MiniTest::Unit::TestCase.test_methods -> Array

テストメソッドのリストを返します。

[m:MiniTest::Unit::TestCase.test_order] の値が :random である場合は
返されるメソッドリストの順番はランダムです。
そうでない場合は、文字コード順にソートされます。

### def MiniTest::Unit::TestCase.test_order -> Symbol

テストの実行順序を返します。

デフォルトはランダムです。

### def MiniTest::Unit::TestCase.test_suites -> Array

テストクラス名のリストを返します。

## Constants
### const PASSTHROUGH_EXCEPTIONS -> [Class]

システム関連の例外のリストです。内部で使用します。

### const SUPPORTS_INFO_SIGNAL -> Fixnum | nil

[c:Signal] が INFO というシグナルをサポートしているかどうかを
調べるための定数です。内部で使用します。


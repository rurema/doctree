# class MiniTest::Unit

ユニットテストで使用する様々なメソッドを定義しているクラスです。

## Public Instance Methods

### def assertion_count -> Fixnum

アサーション数を返します。

### def assertion_count=(count)

アサーション数をセットします。

- **param** `count` -- 件数を指定します。

### def errors -> Fixnum

エラー数を返します。

### def errors=(count)

エラー数をセットします。

- **param** `count` -- 件数を指定します。

### def failures -> Fixnum

失敗したアサーション数を返します。

### def failures=(count)

失敗したアサーション数をセットします。

- **param** `count` -- 件数を指定します。

### def location(exception) -> String

与えられた例外の発生した場所を返します。

### def puke(klass, method_name, exception) -> String

テストメソッドの実行結果が成功以外の場合に、その種類と理由を記録します。

- **param** `klass` -- テストクラスを指定します。

- **param** `method_name` -- テストメソッドの名前を指定します。

- **param** `exception` -- 例外クラスを指定します。

- **return** -- 与えられた例外クラスによって "Skip", "Failure", "Error" の
        いずれかの頭文字を返します。

### def report -> Array

テストメソッドの実行結果のリストを返します。

### def report=(list)

テストメソッドの実行結果のリストをセットします。

- **param** `list` -- テストメソッドの実行結果のリストを指定します。

### def run(args = []) -> Fixnum | nil

全てのテストを実行するためのメソッドです。

- **param** `args` -- コマンドライン引数を指定します。

### def run_test_suites(filter = /./) -> Array

全てのテストを実行します。

- **param** `filter` -- 実行するテストメソッド名を正規表現で指定します。

- **return** -- テストケース数とアサーション数を返します。

### def skips -> Fixnum

実行しなかったテストケース数を返します。

### def skips=(count)

実行しなかったテストケース数をセットします。

- **param** `count` -- 件数を指定します。

### def test_count -> Fixnum

テストケース数を返します。

### def test_count=(count)

テストケース数をセットします。

- **param** `count` -- 件数を指定します。

#@since 1.9.2
### def process_args(args = []) -> Hash

[lib:optparse] を使ってコマンドライン引数を解析した結果を返します。

- **param** `args` -- コマンドライン引数を指定します。

- **SEE** [lib:optparse]

### def start_time -> Time

テストの実行開始時刻を返します。

### def start_time=(time)

テストの実行開始時刻をセットします。

- **param** `time` -- [c:Time] オブジェクトを指定します。

### def status(io = @@out) -> ()

テスト結果を与えられた IO に書き込みます。

- **param** `io` -- テスト結果の出力先を指定します。


#@end

## Singleton Methods

### def autorun -> true

プロセスの終了時にテストを実行するように登録します。

### def output=(stream)

出力先をセットします。

- **param** `stream` -- [c:IO] を指定します。

## Constants

### const VERSION -> String

このライブラリのバージョンを返します。




BitClust データベースについて

## クラスリファレンスデータベース

ファイルシステムべったりの実装。
以下のようなディレクトリツリーを持つ。

    PREFIX/
        properties
        library/
            _builtin
            English
            Env
            Win32API
            abbrev
            base64
            benchmark
            bigdecimal
            bigdecimal.jacobian
                :
                :
        class/
            ARGF
            Abbrev
            ArgumentError
            Array
            Base64
            Benchmark
            BigDecimal
            Bignum
            Binding
            CGI
                :
                :
        method/
            ARGF/
                s.binmode._builtin
                s.close._builtin
                s.closed=3f._builtin
                s.dup._builtin
                s.each._builtin
                s.each_byte._builtin
                s.each_line._builtin
                s.eof._builtin
                s.file._builtin
                s.filename._builtin
                        :
                        :
            Abbrev/
            Array/
            Base64/
            Benchmark/
            BigDecimal/
            Bignum/
            Binding/
            CGI/
            CGI__Cookie/
                :
                :


メソッドのファイル名のフォーマットは以下の通り。

    TYPECHAR.METHODNAME.LIBID

<dl>
<dt>TYPECHAR</dt>
<dd>
メソッドの名前空間を表す一文字。
s: 特異メソッド、i: インスタンスメソッド、m: モジュール関数、
c: 定数、v: 特殊変数
</dd>
<dt>METHODNAME</dt>
<dd>
メソッド名をエンコードしたもの。
/?w/ 以外の文字は「=」+「文字コード」にエンコードされる。
</dd>
<dt>LIBID</dt>
<dd>
ライブラリ ID。require に書く名前を tr('/', '.') したもの。
既存のライブラリに「.」を使ってるようなバカがいないことを願う。
</dd>
</dl>

メソッドの追加や上書きに対応するため、
メソッドのファイルにライブラリ ID を入れたところが特徴である。

各ライブラリやクラス、メソッドのファイルの内容は
以下のようなフォーマットで記録される。

    requires=
    classes=ERB,ERB__Util,ERB__DefMethod
    methods=
    
    eRuby スクリプトを処理するクラス。
    従来 ERbLight と呼ばれていたもので、標準出力への印字が文字列の挿入とならない点が
    eruby と異なります。
    
    (以下略)

最初に key=value の行が並び、
空行を 1 行入れてドキュメントが来る。これだけ。
ドキュメントのフォーマットについては
[[ClassReferenceManualFormat]] を参照。

## C API データベース (予定)

こちらもファイルシステムべったり構造。
シンボル名でディレクトリを掘っただけの超シンプルなディレクトリツリーを持つ。

    PREFIX/
        rb_define_method/
            document
            source

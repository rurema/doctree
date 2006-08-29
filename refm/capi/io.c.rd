
: void rb_p(VALUE obj)
    (({p})) の実体。((|obj|)) を見やすく出力します。

: int rb_io_mode_flags(const char *mode);

    fopen(3)のようなモード指定((|mode|))をruby内部のモードフラグに
    変換します。

    ((|mode|))は、(('[rwa][b][+]'))という文字列です(例: "rb+")
    戻り値は、
    (({FMODE_READABLE})),
    (({FMODE_WRITABLE})),
    (({FMODE_BINMODE})),
    (({FMODE_READWRITE}))
    の論理和です。(({FMODE_READWRITE}))は、(({FMODE_READABLE}))と
    (({FMODE_WRITEABLE}))の論理和です。

: static int rb_io_mode_flags2(int mode)

    open(2)のようなモード指定((|mode|))をruby内部のモードフラグに
    変換します。

    ((|mode|))は、((|O_RDONLY|)), ((|O_WRONLY|)), ((|O_RDWR|))のい
    ずれかで
    対応する以下の値のいずれかを返します。
    (({FMODE_READABLE})),
    (({FMODE_WRITABLE})),
    (({FMODE_READWRITE}))

    (({FMODE_READWRITE}))は、(({FMODE_READABLE}))と
    (({FMODE_WRITEABLE}))の論理和です。

    MS-Windowsなどファイルにバイナリ／テキスト属性の区別があるプラッ
    トホームでは、((|mode|))に((|O_BINARY|))の論理和が指定されてい
    れば、戻り値には(({FMODE_BINMODE}))の論理和が指定されます。

: static VALUE pipe_open(char *pname, char *mode)

    popen(3)を実行します。引数((|pname|))、((|mode|))はpopen(3)の
    引数に対応します。

    ((|pname|))は、実行するプロセスで(({"-"}))ならば、自身を
    fork(2)します。

    ((<IO>))オブジェクトを生成し、
    ((|mode|))が(({"r"}))のとき、
    子プロセスの標準出力を生成した(({IO}))の入力につなぎます。

    ((|mode|))が(({"w"}))のとき、
    子プロセスの標準入力を生成した(({IO}))の出力につなぎます。

    ((|mode|))に(({"+"}))が含まれれば、子プロセスの標準入出力を
    生成した(({IO}))の入出力につなぎます。

    生成した(({IO}))オブジェクトを返します。(((|pname|))が
    (({"-"}))であれば、子プロセスには、(({nil}))を返します)

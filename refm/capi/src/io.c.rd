--- void rb_p(VALUE obj)

p の実体。obj を見やすく出力します。

#@until 2.2.0
--- int rb_io_mode_flags(const char *mode)

この関数は deprecated です。[[f:rb_io_modestr_fmode]] を使用してください。

[[man:fopen(3)]] のようなモード指定modeをruby内部のモードフラグに
変換します。

modeは、[rwa][b][+] という文字列です (例: "rb+").
戻り値は、
FMODE_READABLE,
FMODE_WRITABLE,
FMODE_BINMODE,
FMODE_READWRITE
の論理和です。FMODE_READWRITEは、FMODE_READABLEと
FMODE_WRITEABLEの論理和です。
#@end

--- static int rb_io_mode_flags2(int mode)

[[man:open(2)]] のようなモード指定modeをruby内部のモードフラグに変換します。

modeは、O_RDONLY, O_WRONLY, O_RDWRのいずれかで
対応する以下の値のいずれかを返します。

  * FMODE_READABLE,
  * FMODE_WRITABLE,
  * FMODE_READWRITE

FMODE_READWRITEは、FMODE_READABLEと
FMODE_WRITEABLEの論理和です。

Microsoft Windows などファイルにバイナリ／テキスト属性の区別があるプラッ
トホームでは、modeにO_BINARYの論理和が指定されてい
れば、戻り値にはFMODE_BINMODEの論理和が指定されます。

--- static VALUE pipe_open(char *pname, char *mode)

[[man:popen(3)]] を実行します。引数pname、modeは [[man:popen(3)]] の
引数に対応します。

pnameは、実行するプロセスで "-" ならば、自身を [[man:fork(2)]] します。

[[c:IO]] オブジェクトを生成し、mode が "r" のとき、
子プロセスの標準出力を生成した IO の入力につなぎます。

mode が "w" のとき、
子プロセスの標準入力を生成した IO の出力につなぎます。

mode に "+" が含まれれば、子プロセスの標準入出力を
生成した IO の入出力につなぎます。

生成した IO オブジェクトを返します。
pnameが "-" であれば、子プロセスには、nil を返します

#@until 2.2.0
--- void rb_read_check(FILE *fp)

この関数は deprecated です。
#@end

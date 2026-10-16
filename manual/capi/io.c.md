### void rb_p(VALUE obj)

p の実体。obj を見やすく出力します。

### static VALUE pipe_open(char *pname, char *mode)

[man:popen(3)] を実行します。引数pname、modeは [man:popen(3)] の引数に対応します。

pnameは、実行するプロセスで "-" ならば、自身を [man:fork(2)] します。

[c:IO] オブジェクトを生成し、mode が "r" のとき、子プロセスの標準出力を生成した IO の入力につなぎます。

mode が "w" のとき、子プロセスの標準入力を生成した IO の出力につなぎます。

mode に "+" が含まれれば、子プロセスの標準入出力を生成した IO の入出力につなぎます。

生成した IO オブジェクトを返します。
pnameが "-" であれば、子プロセスには、nil を返します

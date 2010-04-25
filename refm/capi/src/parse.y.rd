--- static NODE *arg_add(NODE *node1, NODE *node2)

--- static void arg_ambiguous(void)

メソッド引数の括弧が省略され、最初の引数の一文字目が
演算子とも解釈できる場合に警告を出します。

--- static NODE *arg_blk_pass(NODE *node1, NODE *node2)

--- static NODE *arg_concat(NODE *node1, NODE *node2)

--- static NODE *arg_prepend(NODE *node1, NODE *node2)

--- static NODE *aryset(NODE *recv, NODE *idx)

--- static int assign_in_cond(NODE *node)

条件式中の代入に警告を出します。

--- static NODE *assignable(ID id, NODE *val)

--- static NODE *attrset(NODE *recv, ID id)

--- static NODE *block_append(NODE *head, NODE *tail)

head と tail を NODE_BLOCK のリストとして連結し、
先頭ノードを返します。head または tail が NODE_BLOCK
でない場合は NODE_BLOCK に入れたうえでそれを連結します。
head もしくは tail が NULL なら連結はせず、
NULL でないほうを返します。

--- static NODE *call_op(NODE *recv, ID id, int narg, NODE *arg1)

--- static NODE *cond(NODE *node)

--- static NODE *cond0(NODE *node)

--- static int dyna_in_block(void)

ブロックにネストしているコードをパース中は真。

--- static void dyna_pop(struct RVarmap *vars)

ブロックローカル変数テーブルをポップします。

--- static struct RVarmap *dyna_push(void)

ブロックローカル変数テーブルをプッシュします。

--- static int e_option_supplied(void)

ruby -e で与えたプログラムを実行中なら真。

--- static void fixpos(NODE *node, NODE *orig)

orig に格納されているファイル名と行番号を node にコピーします。
node もしくは orig が NULL のときは何もしません。

--- static NODE *gettable(ID id)

id が変数・定数として有効ならば、それを参照するノードを返します。
(get + able であって get table ではない)

--- static int here_document(NODE *here)

lex_strterm 形式の term に従ってヒアドキュメントを
終端行まで読み込む。

--- static int heredoc_identifier(void)

ヒアドキュメントの「<<」を既に読みこんだものと仮定して
開始記号を読みこみ、lex_strterm をセットします。
返り値は、読み込みに成功したときはシンボル、解析できないときは 0 です。

--- static void heredoc_restore(NODE *here)

ヒアドキュメントの本体の読み込みに失敗したとき、開始記号
のある行を復帰します。here は lex_strterm です。

--- void Init_sym(void)

シンボル関係の変数を初期化します。

--- static ID internal_id(void)

インタプリタ内部でだけ使う、
他のものとは重複しない ID を返します。

--- static VALUE lex_get_str(VALUE s)

文字列 s の lex_gets_ptr の後から一行取得し、返します。
lex_gets_ptr も進められます。

--- static VALUE lex_getline(void)

関数 lex_gets を使って lex_input から
Ruby プログラムを一行読みこみます。

--- static NODE *list_append(NODE *head, NODE *tail)

NODE_LIST のリスト head に非 NODE_LIST のノード
tail を連結し、先頭ノードを返します。head が NULL
のときは tail を NODE_LIST でラップして返します。

--- static NODE *list_concat(NODE *head, NODE *tail)

NODE_LISTのリストheadにNODE_LISTのノードtailを連結し、
先頭ノードを返す。head、tailともにNULLであってはならない。

--- static NODE *literal_append(NODE *head, NODE *tail)

--- static NODE *literal_concat(NODE *head, NODE *tail)

--- static NODE *literal_concat_dstr(NODE *head, NODE *tail)

--- static NODE *literal_concat_list(NODE *head, NODE *tail)

--- static NODE *literal_concat_string(NODE *head, NODE *tail, VALUE str)

--- static int local_append(ID id)

新しいローカル変数 id をテーブルに追加します。

--- static int local_cnt(ID id)

ローカル変数 id の変数 ID を取得します。
定義されていてもいなくても正しい ID が取得できます。

--- static int local_id(ID id)

現在のスコープでローカル変数 id が定義されていれば真。

--- static void local_pop(void)

ローカル変数テーブルをポップします。
テーブルが参照されていない場合、
テーブルは自動的に開放されます。

--- static void local_push(int top)

ローカル変数テーブルをプッシュします。
プログラムのトップレベルをパースしているときは top を真にします。

--- static ID *local_tbl(void)

ローカル変数テーブルスタックの先頭にあるテーブルを取得します。

--- static NODE *logop(enum node_type type, NODE *left, NODE *right)

--- static NODE *match_gen(NODE *node1, NODE *node2)

--- static NODE *new_call(NODE *r, ID m, NODE *a)

--- static NODE *new_fcall(ID m, NODE *a)

--- static NODE *new_super(NODE *a)

--- static NODE *newline_node(NODE *node)

nodeがNULLでなければ現在パース中の行番号を格納した
NODE_NEWLINEをnodeの前に付加し、それを返す。

--- static char *newtok(void)

トークンバッファを初期化またはクリアし、
次のトークンを開始する。

--- static int nextc(void)

入力から次の一文字を読み込みます。
CR LF に対して LF を、EOF に対して -1 を返します。

--- static NODE *node_assign(NODE *lhs, NODE *rhs)

--- static int nodeline(NODE *node)

node に埋め込まれている行番号を返します。
デバッグ用です。

--- static enum node_type nodetype(node)

node の種類を返します。
デバッグ用です。

--- static int parse_string(NODE *quote)

lex_strterm 形式のノード quote の指示に従い、
文字列の終端または埋め込み式の始まりまで読みこみます。

--- MACRO static int peek(int c)

現在読み込み中のプログラムの次の文字が c ならば真。

--- static void pushback(int c)

入力に一文字戻します。
c が EOF (-1) のときはなにもしません。

--- static NODE *range_op(NODE *node)

--- static void rb_backref_error(NODE *node)

--- VALUE rb_backref_get(void)

現在の SCOPE の $~ の値を返します。

--- void rb_backref_set(VALUE val)

現在の SCOPE の $~ に val を代入します。

--- NODE *rb_compile_cstr(const char *f, const char *s, int len, int line)

C の文字列 s を構文木にコンパイルし、ruby_eval_tree と
ruby_eval_tree_begin に格納します。ruby_eval_tree を返します。
またコンパイルするときにファイル f の line 行目からをコンパイル
していると仮定します。

--- NODE *rb_compile_file(const char *f, VALUE file, int start)

Ruby の IO オブジェクト file から文字列を読み込み、
それを Ruby プログラムとして構文木にコンパイルします。
作成した構文木は ruby_eval_tree と ruby_eval_tree_begin に
格納し、同時に ruby_eval_tree を返します。
またコンパイルするときにファイル f の line 行目からをコンパイル
していると仮定します。

--- NODE *rb_compile_string(const char *f, VALUE s, int line)

Ruby の文字列 s を構文木にコンパイルし、ruby_eval_tree と
ruby_eval_tree_begin に格納します。ruby_eval_tree を返します。
またコンパイルするときにファイル f の line 行目からをコンパイル
していると仮定します。

--- char *rb_id2name(ID id)

id に対応する文字列を返します。
返り値は開放できません。

--- ID rb_id_attrset(ID id)

--- ID rb_intern(const char *name)

任意の char* と一対一に対応する整数 ID を返す。

--- int rb_is_class_id(ID id)

クラス変数名として有効な ID ならば真。

--- int rb_is_const_id(ID id)

定数名として有効な ID ならば真。

--- int rb_is_instance_id(ID id)

インスタンス変数名として有効な ID ならば真。

--- int rb_is_local_id(ID id)

ローカル変数名として有効な ID ならば真。

--- VALUE rb_lastline_get(void)

現在評価中の SCOPE の $_ の値を取得します。

--- void rb_lastline_set(VALUE val)

現在評価中の SCOPE の $_ に val を代入します。

--- NODE *rb_node_newnode(enum node_type type, NODE *a0, NODE *a1, NODE *a2)

ノードタイプが type で a0 a1 a2 を
要素に持つノードを生成し、返します。

--- void rb_parser_append_print(void)

ruby の -p オプションの実装。
ループと print のノードを ruby_eval_tree に加えます。

--- void rb_parser_while_loop(int chop, int split)

ruby の -n オプションの実装。
ループと print のノードを ruby_eval_tree に加えます。

--- static struct kwtable *rb_reserved_word(const char *str, unsigned int len)

長さ len の文字列 str が予約語であれば
そのフラグテーブルを返します。str が予約語でなければ
NULL を返します。

    struct kwtable {
        char *name;            /* 予約語の名前 */
        int id[2];             /* 0:  非修飾型シンボル
                                  1:  修飾型シンボル (kIF_MOD など) があれば
                                      それを格納する。なければ id[0] と同じ  */
        enum lex_state state;  /* 遷移すべきlex_state */
    };

--- VALUE rb_sym_all_symbols(void)

呼び出し時までに変換が行われたすべてのシンボルの
配列を返す。

--- static int read_escape(void)

一文字に相当するバックスラッシュ記法が許す
文字列を入力バッファから読みとり、評価値を返す。
先頭のバックスラッシュはすでに読みこんでいるものと仮定する。
不正な記法に対しては yyerror を呼び出し, 0 を返す。

--- static int regx_options(void)

正規表現のオプション (ixmo nesu) を読み込み
フラグ (ビットマスク) を返します。

--- static NODE *ret_args(NODE *node)

--- static void special_local_set(char c, VALUE val)

$~ と $_ をセットします。
現在は c=0 が $_ で c=1 が $~ です。

--- static int symbols_i(char *key, ID value, VALUE ary)

rb_sym_all_symbols() のイテレータブロック。

--- MACRO static char *tok(void)

現在のトークンの先頭へのポインタ。
free してはならない。

--- static void tokadd(char c)

トークンバッファに文字 c を追加します。

--- static int tokadd_escape(int term)

文字列・正規表現中で許されるバックスラッシュ記法を
入力バッファから読みとり、トークンバッファに追加します。
先頭のバックスラッシュはすでに読みこんでいるものと仮定します。
不正な記法に対しては yyerror を呼び出し 0 を返します。

--- static int tokadd_string(int func, int term, int paren)

--- MACRO static void tokfix(void)

トークンバッファを NUL で終端します。

--- MACRO static char* toklast(void)

現在のトークンの末尾へのポインタ。

--- MACRO static int toklen(void)

現在のトークンの長さ。

--- static void top_local_init(void)

パース中のプログラムのトップレベルのためのローカル変数テーブルをプッシュする。

--- static void top_local_setup(void)

パース中のプログラムのトップレベルのためのローカル変数テーブルをポップし、
現在存在する SCOPE にそれを接ぎ足す。

--- static int value_expr(NODE *node)

node を評価したときに、確実に値が得られない式が
あるならば警告またはエラーにする。

--- static void void_expr(NODE *node)

node の表すプログラムの中に値を使わないと
意味のない式があれば警告を出す。

    # 警告が出る例
    lvar = 1
    lvar      # 無駄
    p lvar

--- static void void_stmts(NODE *node)

node の表すプログラムの中に値を使わないと
意味のない式があれば警告を出す。

    # 警告が出る例
    lvar = 1
    lvar      # 無駄
    p lvar

--- static void warn_unless_e_option(const char *str)

ruby -e で与えたプログラムの評価中ではないなら、
警告メッセージ str を出力する。

--- static void warning_unless_e_option(const char *str)

ruby -e で与えたプログラムの評価中ではなく、
しかも $VERBOSE が真ならば、警告メッセージ str を出力する。

--- static int whole_match_p(char *eos, int len, int indent)

現在の入力行がヒアドキュメントの終端記号であれば真。

--- static NODE *yycompile(char *f, int line)

コンパイルを開始します。そのとき、
ファイル名 f の line 行目からを
コンパイルするものと仮定します。

--- static int yyerror(char *msg)

パースエラーを報告するときに yyparse から呼び出されます。
エラーメッセージ msg とエラーになった場所を出力して 0 を返します。

--- static int yylex(void)

yyparse から呼び出されるスキャンルーチンです。
次のトークンを読み込み、そのシンボルを返します。

--- static int yyparse(void)

パースを開始します。
この関数は yacc が自動的に生成するので parse.y には存在しません。

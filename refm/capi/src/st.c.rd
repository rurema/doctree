--- static int delete_never(char *key, char *value, char *never)

st_cleanup_safe() のイテレータブロック。

--- static int new_size(int size)

必要なサイズ size から、最適なハッシュエントリの
サイズを返す。

--- static int numcmp(long x, long y)

int用の比較関数。

--- static int numhash(long n)

int用のハッシュ関数。
n に対するハッシュ値を計算する。

--- static void rehash(register st_table *table)

テーブルの全要素に対しハッシュ値を計算しなおして
テーブルを再構成する。エントリに対して要素の数が
増えすぎ、テーブルが狭くなってきたときに発生する。

--- void st_add_direct(st_table *table, char *key, char *value)

st_insert() と似ているが、同じハッシュ値を持つエントリーに対する
「同値検査」を省略する。key がまだ登録されていないことがはっきり
している場合には、少し高速に登録できる。

--- void st_cleanup_safe(st_table *table, char *never)

never と同じ値を持つエントリーを削除する。

--- st_table *st_copy(st_table *old_table)

[[m:Hash#dup]] の実体。
old_table と同じ内容の st_table を新たに作成して返す。

--- int st_delete(register st_table *table, register char **key, char **value)

*key に対応する値をテーブルから削除し、*key、*value に登録時のキーと
値を書きこむ。返り値は削除したかどうか。

--- int st_delete_safe(register st_table *table, register char **key, char **value, char *never)

[[f:st_delete]] と似ているが、その場ですぐに削除するのではなく never を
書きこんでおく。st_cleanup_safe() で本当に削除できる。
Ruby では never には Qundef を使う。

--- void st_foreach(st_table *table, enum st_retval (*func)(), char *arg)

[[m:Hash#each]], delete_if などの実体。ハッシュ内の全てのキーと値、arg を
引数にして、func を実行する。func の返り値 enum st_retval は ST_CONTINUE
ST_STOP ST_DELETE のどれか。どれも見ためどおりの働きをする。

--- void st_free_table(st_table *table)

table を解放する。キー、値は解放されない。

--- st_table *st_init_numtable(void)

キーが int 型であるハッシュテーブルを作成する。

--- st_table *st_init_numtable_with_size(int size)

キーが int 型であるハッシュテーブルを作成する。
st_init_table() に int 用の操作関数を渡しているだけ。

--- st_table *st_init_strtable(void)

キーが char* 型であるハッシュテーブルを作成する。

--- st_table *st_init_strtable_with_size(int size)

キーが char* 型であるハッシュテーブルを作成する。
[[f:st_init_table]] に文字列用の操作関数を渡しているだけ。

--- st_table *st_init_table(struct st_hash_type *type)

--- st_table *st_init_table_with_size(struct st_hash_type *type, int size)

st_table を作成する。_with_size はサイズを指定して生成する。
struct st_hash_type はハッシュ値を得る関数と、同値判定を行う
関数を持つ。

--- int st_insert(register st_table *table, register char *key, char *value)

ハッシュに key と value の組を追加する。
古いライブラリなので void* のかわりに char* を使っている。

--- int st_lookup(st_table *table, register char *key, char **value)

key に対応する値をみつけて value にポインタを書きこむ。
返り値は見つかったかどうかの真偽値。

任意の型ポインタにvoid*でなくchar*を使っているのは
古いライブラリだからだ。ANSI C以前はvoid*の意味に
char*を使っていた。

--- static void stat_col(void)

ハッシュの衝突に関する統計を /tmp/col に出力する。
#ifdef HASH_LOG のときだけ定義される、開発者用関数。

--- static int strhash(register char *string)

文字列用のハッシュ関数。
string に対するハッシュ値を計算する。

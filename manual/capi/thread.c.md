### void *rb_nogvl(void *(*func)(void *), void *data1, rb_unblock_function_t *ubf, void *data2, int flags)

`func` を GVL を解放して呼び出します。
`rb_thread_call_without_gvl` と同じですが、動作を変える `flags` を追加で受け取ります。
`func` を呼ぶ前に保留中の割り込みを処理し、`func` から戻って GVL を再取得したあとで、その間に発生した割り込みを処理します。
他のスレッドから `Thread#kill` などで割り込まれたときは `ubf` が呼ばれます。
`func` の中では、メソッド呼び出しや例外の発生など、ほとんどの Ruby の C API は使えません。

- **param** `func` -- GVL なしで呼び出す関数です。
- **param** `data1` -- `func` にそのまま渡されます。
- **param** `ubf` -- `func` を中断させるための関数です。
- **param** `data2` -- `ubf` にそのまま渡されます。
- **param** `flags` -- [f:RB_NOGVL_INTR_FAIL] などのフラグの論理和です。
- **return** -- `func` の返り値です。`ubf` によって `func` が中断されたときは `0` です。

### MACRO int RB_NOGVL_INTR_FAIL

[f:rb_nogvl] の `flags` に指定するフラグです。
`func` から戻ったあとで割り込みを処理しなくなります。
代わりに、ブロッキング領域に入る前に割り込みを検出したときは、`func` を呼ばずに戻ります。
`func` の副作用を考慮したうえで、あとから呼び出し側で割り込みを確認できます。

### MACRO int RB_NOGVL_UBF_ASYNC_SAFE

[f:rb_nogvl] の `flags` に指定するフラグです。
渡した `ubf` がシグナルハンドラから呼べる (async-signal-safe な) 関数であることを示します。
async-signal-safe でない `ubf` でも問題ないため、よく分からなければ指定しなくて構いません。

#%since 3.4
### MACRO int RB_NOGVL_OFFLOAD_SAFE

[f:rb_nogvl] の `flags` に指定するフラグです。
`func` をバックグラウンドのスレッドやワーカープールにオフロードしても安全であることを示します。
つまり `func` を [c:Fiber] スケジューラの `blocking_operation_wait` フックで実行できます。
`func` がスレッドローカルストレージやスレッド固有のデータ操作 (たとえば [c:Mutex] の unlock) に依存するときは、別のスレッドでは動作が異なったり失敗したりするため、指定しないでください。
#%end

#%since 4.1
### MACRO int RB_NOGVL_PENDING_INTR_FAIL

[f:rb_nogvl] の `flags` に指定するフラグです。
現在のスレッドに保留中の割り込みがあるとき、[m:Thread.handle_interrupt] でマスクされた割り込みも含めて、ブロッキング領域に入らず、`func` も呼ばずに `0` を返します。
`errno` は [f:RB_NOGVL_INTR_FAIL] による既存のスキップ時と同じく、`func` が呼ばれていないため `0` です。
#%end

### void rb_fd_clr(int fd, rb_fdset_t *f)

ファイルディスクリプタ `fd` を、`f` から取り除きます。
`FD_CLR(3)` に相当します。

- **param** `fd` -- 取り除くファイルディスクリプタです。
- **param** `f` -- `fd` を持つ `rb_fdset_t` です。

### void rb_fd_init(rb_fdset_t *f)

`rb_fdset_t` を初期化します。
ほかの `rb_fd_*` を使う前に、必ず初期化してください。
`fd_set` のためのメモリを `malloc(3)` で確保することに相当します。
初期化後の `f` はファイルディスクリプタを持ちません。

- **param** `f` -- 初期化する `rb_fdset_t` です。

### int rb_fd_isset(int fd, const rb_fdset_t *f)

ファイルディスクリプタ `fd` が `f` に含まれているかどうかを調べます。
`FD_ISSET(3)` に相当します。

- **param** `fd` -- 調べるファイルディスクリプタです。
- **param** `f` -- 調べる `rb_fdset_t` です。
- **return** -- 含まれていれば `1`、含まれていなければ `0` です。

### void rb_fd_set(int fd, rb_fdset_t *f)

ファイルディスクリプタ `fd` を、`f` に追加します。
`FD_SET(3)` に相当します。

- **param** `fd` -- 追加するファイルディスクリプタです。
- **param** `f` -- 追加先の `rb_fdset_t` です。

### void rb_fd_term(rb_fdset_t *f)

`rb_fdset_t` を破棄し、使っていたメモリなどの資源を解放します。
`fd_set` のメモリを `free(3)` で解放することに相当します。
再び使うには、[f:rb_fd_init] で初期化し直す必要があります。
破棄後の `f` はファイルディスクリプタを持ちません。

- **param** `f` -- 破棄する `rb_fdset_t` です。

### void rb_fd_zero(rb_fdset_t *f)

`f` からすべてのファイルディスクリプタを取り除きます。
`FD_ZERO(3)` に相当します。

- **param** `f` -- 空にする `rb_fdset_t` です。

### int rb_thread_fd_select(int nfds, rb_fdset_t *rfds, rb_fdset_t *wfds, rb_fdset_t *efds, struct timeval *timeout)

複数のファイルディスクリプタを同時に待ちます。
`select(2)` を呼ぶ関数ですが、GVL を解放して待つので、ほかの Ruby のスレッドが並行して動けます。

1 つのファイルディスクリプタだけを待つときは、[f:rb_io_wait_readable]、[f:rb_io_wait_writable]、[f:rb_wait_for_single_fd] を使ってください。
環境によっては(現在は Linux だけ)最適化されているためです。

すべてのポインタに `NULL` を指定できます。
待っている間にほかのスレッドが同じファイルディスクリプタを操作すると、問題が起きることがあります。
たとえば、別のスレッドが `select` 中のファイルディスクリプタを閉じたときの動作は、OS によって大きく異なります。
同じファイルディスクリプタを複数のスレッドから操作するのは避けてください。

- **param** `nfds` -- 渡したファイルディスクリプタの最大値に 1 を足した値です。
- **param** `rfds` -- 読み込みを待つファイルディスクリプタの集合です。戻ったときは、読み込み可能なものだけになります。
- **param** `wfds` -- 書き込みを待つファイルディスクリプタの集合です。戻ったときは、書き込み可能なものだけになります。
- **param** `efds` -- 例外状態(OOB)を待つファイルディスクリプタの集合です。戻ったときは、例外状態のものだけになります。
- **param** `timeout` -- 最大で待つ時間です。戻ったときは、残りの時間になります。
- **return** -- 失敗したときは `-1` で、`errno` が設定されます。タイムアウトしたときは `0` です。それ以外は、返ってきたファイルディスクリプタの総数です。

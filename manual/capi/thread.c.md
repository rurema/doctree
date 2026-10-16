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

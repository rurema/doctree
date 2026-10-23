# メソッド引数チェック(Ruby 3.0〜4.1・組み込み・標準添付)— 2026-10-12(組み込み)・2026-10-23(標準添付)

## 方法

- doctree master 629beb441 の版別 DB(3.0〜4.1)から `lib == _builtin` のシグネチャ行を抽出し(`tools/extract_db_sigs.rb`)、実 Ruby の `Method#arity`/`Method#parameters`(`real/`)と RBS のオーバーロード(`rbs/`)に突き合わせた(`tools/compare_params.rb`)。版間の差分は `tools/diff_versions.rb`、本文の `- **param**` との名前の差は `tools/check_params.rb`
- 実測した Ruby と rbs(`real/<版>/ruby-v.txt`・`rbs/<版>.log`)

| 版 | 実 Ruby | 同梱 rbs gem |
|---|---|---|
| 3.0 | ruby 3.0.0p0 (2020-12-25 revision 95aff21468) [x86_64-linux] | 1.0.0 |
| 3.1 | ruby 3.1.0p0 (2021-12-25 revision fb4df44d16) [x86_64-linux] | 2.0.0 |
| 3.2 | ruby 3.2.0 (2022-12-25 revision a528908271) [x86_64-linux] | 2.8.2 |
| 3.3 | ruby 3.3.0 (2023-12-25 revision 5124f9ac75) [x86_64-linux] | 3.4.0 |
| 3.4 | ruby 3.4.0dev (2024-12-25 master f450108330) +PRISM [x86_64-linux] | 3.8.0 |
| 4.0 | ruby 4.0.0 (2025-12-25 revision 553f1675f3) +PRISM [x86_64-linux] | 3.10.0 |
| 4.1 | ruby 4.1.0dev (2026-10-11T13:56:36Z v4.1.0-preview1 2d08b5f42f) +PRISM [x86_64-linux] | 4.2.0 |

- RBS の解析は全版とも手元の rbs 4.1.3(bitclust の `RbsSigImporter`)
- doc の位置引数がリテラル(`nil`・数値・引用符つき文字列)のものは必須の位置引数として数え、名前の比較には使わない
- 判定の細部: C 実装は arity しか分からないので、必須数の過不足と「固定 arity なのに doc が任意引数を許す」ことだけを見る。Ruby 定義のメソッドは必須数・任意数・rest・キーワード集合・位置引数名・ブロックを厳密に比べる。エントリは 1 行でも `ok` なら `ok`

## 段階 1: 実 Ruby との突き合わせ(エントリ単位・組み込み)

| 版 | エントリ数 | ok | ok-split | forwarding? | doc-no-optional? | req-count | opt-count | rest | kw-mismatch | name-mismatch | block-missing | doc-allows-more | no-real | no-real:inherited | no-class |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 3.0 | 1839 | 1520 | 101 | 0 | 16 | 3 | 0 | 0 | 3 | 12 | 0 | 0 | 29 | 2 | 153 |
| 3.1 | 1910 | 1589 | 106 | 0 | 16 | 2 | 1 | 0 | 5 | 5 | 0 | 0 | 30 | 2 | 154 |
| 3.2 | 2003 | 1673 | 107 | 0 | 16 | 2 | 2 | 0 | 9 | 6 | 0 | 0 | 33 | 2 | 153 |
| 3.3 | 2023 | 1689 | 108 | 0 | 16 | 3 | 2 | 0 | 9 | 6 | 0 | 0 | 33 | 2 | 155 |
| 3.4 | 2040 | 1702 | 110 | 0 | 16 | 3 | 2 | 0 | 8 | 7 | 0 | 0 | 33 | 2 | 157 |
| 4.0 | 2069 | 1717 | 110 | 2 | 17 | 2 | 3 | 0 | 10 | 5 | 0 | 0 | 35 | 2 | 166 |
| 4.1 | 2139 | 1791 | 113 | 2 | 18 | 2 | 2 | 0 | 14 | 9 | 0 | 0 | 37 | 3 | 148 |

- `ok-split`= 1 行では整合しないが、エントリの ok な行を合成(必須数は最小・最大数は最大・rest とキーワードは和集合・ブロックはいずれか)すると整合する。引数パターンごとに行を分ける書き方の吸収で、整合している扱い。合成した行では位置引数名は比べない
- `forwarding?`= 実 Ruby が無名の転送(`*, **, &`)で定義されていて arity から何も言えない(弱い信号)
- `doc-no-optional?` は弱い信号(C の可変長で doc に任意引数が無い。`rb_scan_args` が doc の必須数ちょうどを受けることもある)
- `no-class` は実測側に行が無いクラス(`Object`・`ARGF.class`・`ENV`・`main`・`RubyVM::YJIT` 系・`Errno::EXXX`。独自の定義を持たないか、ビルドに無い)
- 行単位の件数は `result/<版>/summary.txt`

## 段階 1: RBS との突き合わせ(エントリ単位)

| 版 | ok | no-rbs | rbs-unmatched-sig | rbs-unmatched-overload |
|---|---|---|---|---|
| 3.0 | 1453 | 374 | 8 | 4 |
| 3.1 | 1481 | 417 | 8 | 4 |
| 3.2 | 1573 | 417 | 9 | 4 |
| 3.3 | 1659 | 349 | 10 | 5 |
| 3.4 | 1707 | 318 | 10 | 5 |
| 4.0 | 1719 | 335 | 10 | 5 |
| 4.1 | 1732 | 396 | 6 | 5 |

- `rbs-unmatched-sig` は「アリティ範囲がどの overload とも重ならず、名前の共通も無い doc の行」、`rbs-unmatched-overload` は「どの doc の行にも最良一致せず、アリティも重ならない overload」

## 段階 3: check_params(本文の param 行とシグネチャの名前の差)

| 版 | エントリ | param 行つき | 不一致 | 引数ありで param 行なし |
|---|---|---|---|---|
| 3.0 | 7671 | 3545 | 80 | 417 |
| 3.1 | 7653 | 3533 | 79 | 410 |
| 3.2 | 7733 | 3589 | 80 | 408 |
| 3.3 | 7824 | 3636 | 79 | 408 |
| 3.4 | 7927 | 3671 | 79 | 409 |
| 4.0 | 7824 | 3640 | 79 | 408 |
| 4.1 | 7728 | 3569 | 77 | 402 |

(全ライブラリが対象。段階 1/2 は組み込みのみ)

## 段階 2: 版間の変化(組み込み)

| 版の組 | unreflected | name-only | already-consistent | forwarding | impl-change | c-decl-change | reflected | rbs-only | no-doc | doc-only | 計 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 3.0→3.1 | 2 | 0 | 19 | 0 | 0 | 1 | 10 | 38 | 0 | 0 | 70 |
| 3.1→3.2 | 10 | 0 | 17 | 0 | 0 | 0 | 11 | 24 | 0 | 0 | 62 |
| 3.2→3.3 | 1 | 0 | 8 | 0 | 0 | 0 | 3 | 173 | 2 | 2 | 189 |
| 3.3→3.4 | 0 | 0 | 7 | 0 | 0 | 0 | 2 | 58 | 22 | 0 | 89 |
| 3.4→4.0 | 1 | 0 | 71 | 3 | 1 | 0 | 7 | 9 | 5 | 1 | 98 |
| 4.0→4.1 | 7 | 5 | 13 | 0 | 0 | 1 | 5 | 157 | 20 | 5 | 213 |
| 計 | 21 | 5 | 135 | 3 | 1 | 2 | 38 | 459 | 49 | 8 | 721 |

- `unreflected`= 実 Ruby か RBS の指紋が変わり、doc の行の集合が変わっておらず、変化後の段階 1 の判定が `ok`/`ok-split` でないもの(本命)。`changes.tsv` の `verdict_after` に変化後の判定(`to` 版のエントリ単位)を付けてある
- `already-consistent`= 実 Ruby の指紋は変わったが、変化後の doc が実 Ruby と整合している(C から Ruby 定義への移行で名前が見えるようになっただけ、など)
- `name-only`= 変化後に残る差が仮引数名だけ(`verdict_after` が `name-mismatch`)
- `forwarding`= 変化後の実 Ruby が無名の転送(`*, **, &`)で、arity から何も言えない
- `impl-change`= C と Ruby 定義の入れ替えで arity が同じ・RBS 不変・Ruby 側にキーワードが無く、変化後の判定が弱い信号(`doc-no-optional?`)だけのもの
- `c-decl-change`= C の宣言が固定 arity と `-1` の間で変わっただけ
- `rbs-only`= RBS だけ変わった(RBS 側の追随が主で信頼度は低い)。`reflected`= doc も変わっている
- `no-doc`= どちらかの版で doc のエントリが無い(多くは `Kernel` の私的メソッド・`Pathname` の内部メソッド等)
- `doc-only`= doc だけ変わった(`#%since` の置き場所違いの候補)

## 実測で確認した候補(本物)

実機(4.0.0 の all-ruby と 4.1.0-preview1 2d08b5f42f)でメソッドを呼んで確認し、NEWS.md も見たもの(確認は別作業で行った。このスクリプトの出力は `parameters` までで、ここは実行の裏付けが取れている項目)。いずれも doc はその引数を書いていない。

| メソッド | 実 Ruby | 今の doc | 場所(4.0) |
|---|---|---|---|
| `String#unpack`/`unpack1` | 3.1 から `offset:` キーワード(4.0 の parameters は `req:fmt key:offset`) | `template`/`format` のみ | String.md:3187・3925 |
| `Thread::Queue#pop`/`deq`/`shift`、`Thread::SizedQueue#push`/`<<`/`enq`/`pop`/`deq`/`shift` | 3.2 から `timeout:` | `non_block` まで | thread/Queue.md:118・thread/SizedQueue.md:68・87 |
| `Set#merge` | 3.3 から `merge(*enums)`(4.1 で `[1].to_set.merge([2],[3])` が通る) | `merge(enum)` | Set.md:511 |
| `GC.verify_compaction_references` | 3.2 から `expand_heap:`(3.2/3.3 は Ruby 定義で `toward:, double_heap:, expand_heap:`。4.0 は C で rest) | `toward:, double_heap:` のみ | GC.md:600 |
| `Enumerable#to_set` | 4.0 は `(*args, &block)`。`[1,2].to_set(Set)` は Set を返すが「passing arguments to Enumerable#to_set is deprecated」の警告が出て、引数 2 個は ArgumentError(0..1) | `to_set(klass = Set, *args)`。本文に 4.0 の非推奨の注記は既にあり、挙動も `klass = Set` のときと同じなので直す必要なし(見出しの形だけの差) | Enumerable.md:1565 |
| `Ractor.shareable_proc`/`shareable_lambda` | 4.0 で `self:` キーワード(`Ractor.shareable_proc(self: nil) { 1 }.call` が 1) | 引数なし | Ractor.md:117・137 |
| `Dir.glob` | 4.0 は `(pattern, _flags = 0, flags: _flags, base: nil, sort: true)` で `flags:` もキーワード(`Dir.glob("/etc/host*", flags: File::FNM_DOTMATCH)` が通る) | 位置引数 `flags = 0` のみ(軽微) | Dir.md:30 |
| `Marshal.load`/`restore` | `(source, proc = nil, freeze: false)`。`freeze:` は 3.1 から | `options = {}` と書いている | Marshal.md:67 |
| `TracePoint#enable` | `target:, target_line:, target_thread:` キーワード(4.0 の parameters) | 引数なし | TracePoint.md:212 |
| `GC#garbage_collect`(モジュール GC のインスタンスメソッド。モジュール関数ではなく `GC.garbage_collect` は NoMethodError)と `ObjectSpace.garbage_collect` | 4.1 で `global:` 追加(NEWS.md は `GC.start` について記載) | GC.md:645 と ObjectSpace.md:168 に無い。ObjectSpace 側は全版で `immediate_mark:` も無い | GC.md:645・ObjectSpace.md:168 |
| `Ractor.receive`/`recv`、`Ractor::Port#receive`、`Ractor.select` | 4.1 で `timeout:` キーワード。`Ractor.receive(timeout: 0.2)`・`port.receive(timeout: 0.2)`・`Ractor.select(port, timeout: 0.2)` はいずれも 0.2 秒後に nil を返し例外にならない。NEWS.md には記載なし | 引数なし/`*ports` のみ | Ractor.md:73・74(receive/recv)・94・98(select)・ractor/Port.md:36 |

## 確認してノイズと判断したもの

- `Time.at`(3.1): `in:` は 2.7 からあり、C から Ruby 定義になって parameters に出ただけ。doc は元から `in:` つきの行を持つ
- `RubyVM::MJIT.pause`(3.2)・`IO#readline`(3.3)・`Kernel#Integer`(3.3)・`Thread::ConditionVariable#wait`(4.0): 同じく C から Ruby 定義になって名前が見えただけ
- `Set#delete_if`/`keep_if`(3.4): 明示的な `&block` が parameters に現れただけ
- `Binding#irb`(4.0)・`Ractor#send`/`<<`(4.0): 無名の転送(`*, **, &`)。arity から何も言えず `forwarding?` とした
- `Dir.new`/`Dir.open`: doc の 2 行目に `encoding:` があり、違うのは仮引数名 `path` 対 `name` だけ
- `RubyVM::AbstractSyntaxTree.of`: キーワードは版ゲートされた行にあり、違うのは `proc` 対 `body` だけ
- `Process::Sys.setruid`/`setrgid`: Linux では未実装(`rb_f_notimplement`)で arity が環境依存。`req-count` のまま残るが無視してよい
- 初版で `opt-count` 11・`block-missing` 1 だった 4.0 のエントリは、`ok-split` で吸収した結果 `opt-count` 3・`block-missing` 0 になった。残りの `opt-count` は `Enumerable#to_set`・`Marshal.#load,restore`・`Time.new`(`Time.new` は未確認、`Marshal.load` と `Enumerable#to_set` は上の本物の候補)

## 名前だけの差(5 件・4.0)

仮引数名の違いだけ。バグではなく、#3589 に近い話(rurema は読みやすい名前を選ぶ慣例がある)。合成した行(`ok-split`)では名前を比べていないので、`Array#pack`(`template` 対 `fmt`)や `Dir.new` のように複数行のエントリの名前差はここに出ない。

- `GC.stress=` (manual/api/_builtin/GC.md:318) — doc=value real=flag
- `IO#read_nonblock` (manual/api/_builtin/IO.md:1569) — doc=maxlen,outbuf real=len,buf
- `IO#write_nonblock` (manual/api/_builtin/IO.md:1937) — doc=string real=buf
- `Ractor.store_if_absent` (manual/api/_builtin/Ractor.md:151) — doc=key real=sym
- `Ractor::Port#<<,send` (manual/api/ractor/Port.md:15) — doc=msg real=obj

## 候補一覧

### 候補 A: unreflected(21 件・全件)

【実測済み】は上の節で実機確認したもの、それ以外は `parameters` のみからの読み。

| 版 | メソッド | 実 Ruby の変化 | 変化後の判定 | 読み |
|---|---|---|---|---|
| 3.4→4.0 | `Enumerable#to_set` | `-1\|opt:klass rest:args block:block\|rb` → `-1\|rest:args block:block\|rb` | opt-count | 【実測済み】4.0 で `(*args, &block)`。doc は `klass = Set, *args` |
| 4.0→4.1 | `GC#garbage_collect` | `-1\|key:full_mark key:immediate_mark key:immediate_sweep\|rb` → `-1\|key:full_mark key:immediate_mark key:immediate_sweep key:global\|rb` | kw-mismatch | 【実測済み】4.1 で `global:` 追加 |
| 3.1→3.2 | `GC.verify_compaction_references` | `-1\|key:toward key:double_heap\|rb` → `-1\|key:toward key:double_heap key:expand_heap\|rb` | kw-mismatch | 【実測済み】`expand_heap:` が 3.2 で追加。doc は `toward`/`double_heap` のみ |
| 4.0→4.1 | `ObjectSpace#garbage_collect` | `-1\|key:full_mark key:immediate_mark key:immediate_sweep\|rb` → `-1\|key:full_mark key:immediate_mark key:immediate_sweep key:global\|rb` | kw-mismatch | 【実測済み】同上(`immediate_mark:` も欠落) |
| 4.0→4.1 | `ObjectSpace.garbage_collect` | `-1\|key:full_mark key:immediate_mark key:immediate_sweep\|rb` → `-1\|key:full_mark key:immediate_mark key:immediate_sweep key:global\|rb` | kw-mismatch | 同上 |
| 4.0→4.1 | `Ractor.receive` | `0\|-\|rb` → `-1\|key:timeout\|rb` | kw-mismatch | 【実測済み】4.1 で `timeout:` |
| 4.0→4.1 | `Ractor.recv` | `0\|-\|rb` → `-1\|key:timeout\|rb` | kw-mismatch | 同上 |
| 4.0→4.1 | `Ractor.select` | `-1\|rest:ports\|rb` → `-1\|rest:ports key:timeout\|rb` | kw-mismatch | 同上 |
| 4.0→4.1 | `Ractor::Port#receive` | `0\|-\|rb` → `-1\|key:timeout\|rb` | kw-mismatch | 同上 |
| 3.2→3.3 | `Set#merge` | `1\|req:enum\|rb` → `-1\|rest:enums nokey\|rb` | req-count | 【実測済み】3.3 で可変長 `*enums`。doc は `enum` 1 個 |
| 3.0→3.1 | `String#unpack` | `1\|req:fmt\|rb` → `-2\|req:fmt key:offset\|rb` | kw-mismatch | 【実測済み】`offset:` が 3.1 で追加。doc は `template` のみ |
| 3.0→3.1 | `String#unpack1` | `1\|req:fmt\|rb` → `-2\|req:fmt key:offset\|rb` | kw-mismatch | 【実測済み】同上 |
| 3.1→3.2 | `Thread::Queue#deq` | `-1\|rest\|C` → `-1\|opt:non_block key:timeout\|rb` | kw-mismatch | 同上 |
| 3.1→3.2 | `Thread::Queue#pop` | `-1\|rest\|C` → `-1\|opt:non_block key:timeout\|rb` | kw-mismatch | 【実測済み】3.2 で `timeout:` 追加 |
| 3.1→3.2 | `Thread::Queue#shift` | `-1\|rest\|C` → `-1\|opt:non_block key:timeout\|rb` | kw-mismatch | 同上 |
| 3.1→3.2 | `Thread::SizedQueue#<<` | `-1\|rest\|C` → `-2\|req:object opt:non_block key:timeout\|rb` | kw-mismatch | 同上 |
| 3.1→3.2 | `Thread::SizedQueue#deq` | `-1\|rest\|C` → `-1\|opt:non_block key:timeout\|rb` | kw-mismatch | 同上 |
| 3.1→3.2 | `Thread::SizedQueue#enq` | `-1\|rest\|C` → `-2\|req:object opt:non_block key:timeout\|rb` | kw-mismatch | 同上 |
| 3.1→3.2 | `Thread::SizedQueue#pop` | `-1\|rest\|C` → `-1\|opt:non_block key:timeout\|rb` | kw-mismatch | 同上 |
| 3.1→3.2 | `Thread::SizedQueue#push` | `-1\|rest\|C` → `-2\|req:object opt:non_block key:timeout\|rb` | kw-mismatch | 【実測済み】3.2 で `timeout:` 追加 |
| 3.1→3.2 | `Thread::SizedQueue#shift` | `-1\|rest\|C` → `-1\|opt:non_block key:timeout\|rb` | kw-mismatch | 同上 |

name-only(5 件・仮引数名の差だけ。parameters のみで未実測): Thread::Queue#<<(4.0→4.1)、Thread::Queue#enq(4.0→4.1)、Thread::Queue#push(4.0→4.1)、Thread::SizedQueue#initialize(4.0→4.1)、Thread::SizedQueue#max=(4.0→4.1)

`forwarding`/`impl-change`(4 件): Binding#irb(3.4→4.0・forwarding)、Ractor#<<(3.4→4.0・forwarding)、Ractor#send(3.4→4.0・forwarding)、Set#merge(3.4→4.0・impl-change)

### 候補 B: doc-only(8 件・全件。`Array#join` の旧抽出由来の 2 件は再抽出で消えた)

| 版 | メソッド | doc の行の変化 | 読み |
|---|---|---|---|
| 3.2→3.3 | `Regexp.compile` | `1/2/0///0/0/string,option,code` → `1/1/0///0/0/string,option` | 3.3 で doc が 3 引数形(`code`)を落とす。実 Ruby は C で判別不能。妥当と思われる(未確認) |
| 3.2→3.3 | `String#bytesplice` | `2/0/0///0/0/range,str ; 3/0/0///0/0/index,length,str` → `2/0/0///0/0/range,str ; 3/0/0///0/0/index,length,str ; 3/0/0///0/0/range,str,str_range ; 5/0/0///0/0/index,length,str,str_index,str_length` | 3.3 で 3/5 引数形と範囲形を追加。RBS も 3.3 で出現= 妥当と思われる(未確認) |
| 3.4→4.0 | `Enumerator.produce` | `0/1/0///0/1/initial` → `0/1/0//size/0/1/initial` | 4.0 で doc が `size:` を追加(4.0 の機能追加に合うか要確認) |
| 4.0→4.1 | `IO::Buffer#pread` | `2/2/0///0/0/io,from,length,offset` → `2/2/0///0/0/io,from,offset,length` | 名前の並びだけ変更(`length, offset`→`offset, length`)= 説明の整理 |
| 4.0→4.1 | `IO::Buffer#pwrite` | `2/2/0///0/0/io,from,length,offset` → `2/2/0///0/0/io,from,offset,length` | 同上 |
| 4.0→4.1 | `IO::Buffer#read` | `1/2/0///0/0/io,length,offset` → `1/2/0///0/0/io,offset,length` | 同上 |
| 4.0→4.1 | `IO::Buffer#write` | `1/2/0///0/0/io,length,offset` → `1/2/0///0/0/io,offset,length` | 同上 |
| 4.0→4.1 | `Module#method_defined?` | `1/1/0///0/0/name,inherit` → `1/2/0///0/0/name,inherit,include_all` | 4.1 で doc が `include_all` を追加。実 Ruby は C で判別不能(4.1 の追加= 妥当と思われる。未確認) |

(doc の指紋は `req/opt/rest/kwreq/kwopt/kwrest/block/位置引数名`)

### 候補 C: 4.0 の実 Ruby との不一致(名前だけの差を除く・全件)

#### req-count(2 件)

- `Process::Sys.#setrgid` (manual/api/_builtin/Process__Sys.md:65) — doc_req=1 real_arity=0
- `Process::Sys.#setruid` (manual/api/_builtin/Process__Sys.md:55) — doc_req=1 real_arity=0

#### opt-count(3 件)

- `Enumerable#to_set` (manual/api/_builtin/Enumerable.md:1565) — doc=1 real=0
- `Marshal.#load,restore` (manual/api/_builtin/Marshal.md:67) — doc=2 real=1
- `Time.new` (manual/api/_builtin/Time.md:227) — doc=0 real=7 / doc=1 real=0

#### rest(0 件)


#### kw-mismatch(10 件)

- `Dir.glob` (manual/api/_builtin/Dir.md:30) — doc=req[] opt[base,sort] rest0 real=req[] opt[base,flags,sort] rest0
- `ObjectSpace.#garbage_collect` (manual/api/_builtin/ObjectSpace.md:168) — doc=req[] opt[full_mark,immediate_sweep] rest0 real=req[] opt[full_mark,immediate_mark,immediate_sweep] rest0
- `Ractor.shareable_lambda` (manual/api/_builtin/Ractor.md:137) — doc=req[] opt[] rest0 real=req[] opt[self] rest0
- `Ractor.shareable_proc` (manual/api/_builtin/Ractor.md:117) — doc=req[] opt[] rest0 real=req[] opt[self] rest0
- `String#unpack` (manual/api/_builtin/String.md:3187) — doc=req[] opt[] rest0 real=req[] opt[offset] rest0
- `String#unpack1` (manual/api/_builtin/String.md:3925) — doc=req[] opt[] rest0 real=req[] opt[offset] rest0
- `Thread::Queue#deq,pop,shift` (manual/api/thread/Queue.md:118) — doc=req[] opt[] rest0 real=req[] opt[timeout] rest0
- `Thread::SizedQueue#<<,enq,push` (manual/api/thread/SizedQueue.md:68) — doc=req[] opt[] rest0 real=req[] opt[timeout] rest0 / doc=0 real=1
- `Thread::SizedQueue#deq,pop,shift` (manual/api/thread/SizedQueue.md:87) — doc=req[] opt[] rest0 real=req[] opt[timeout] rest0
- `TracePoint#enable` (manual/api/_builtin/TracePoint.md:212) — doc=req[] opt[] rest0 real=req[] opt[target,target_line,target_thread] rest0

#### forwarding?(2 件)

- `Binding#irb` (manual/api/_builtin/Binding.md:248) — real forwards *, **, &
- `Ractor#<<,send` (manual/api/_builtin/Ractor.md:303) — real forwards *, **, &

#### doc-no-optional?(17 件)

弱い信号なので件数だけ。一覧は `result/4.0/mismatch-entries.tsv`。

### 候補 D: RBS との不一致(4.0・全件)

- rbs-unmatched-sig: `Encoding::Converter.search_convpath` (manual/api/_builtin/Encoding__Converter.md:77) — `Encoding::Converter.search_convpath(source_encoding, destination_encoding, options) -> Array`
- rbs-unmatched-sig: `Enumerable#all?` (manual/api/_builtin/Enumerable.md:13) — `all?               -> bool`
- rbs-unmatched-sig: `Enumerable#any?` (manual/api/_builtin/Enumerable.md:47) — `any?               -> bool`
- rbs-unmatched-sig: `Enumerable#none?` (manual/api/_builtin/Enumerable.md:942) — `none?               -> bool`
- rbs-unmatched-sig: `Enumerable#one?` (manual/api/_builtin/Enumerable.md:970) — `one?                -> bool`
- rbs-unmatched-sig: `Hash#transform_keys` (manual/api/_builtin/Hash.md:1741) — `transform_keys {|key| ... } -> Hash`
- rbs-unmatched-sig: `Hash#transform_keys!` (manual/api/_builtin/Hash.md:1771) — `transform_keys! {|key| ... } -> self`
- rbs-unmatched-overload: `Kernel.#printf` (manual/api/_builtin/functions.md:2390) — `printf(format, *arg) -> nil` [unmatched-overload: Kernel.printf#0 Kernel#printf#0]
- rbs-unmatched-overload: `Numeric#ceil` (manual/api/_builtin/Numeric.md:435) — `ceil   -> Integer` [unmatched-overload: Numeric#ceil#1]
- rbs-unmatched-overload: `Numeric#round` (manual/api/_builtin/Numeric.md:469) — `round   -> Integer` [unmatched-overload: Numeric#round#1]
- rbs-unmatched-overload: `Numeric#truncate` (manual/api/_builtin/Numeric.md:486) — `truncate   -> Integer` [unmatched-overload: Numeric#truncate#1]
- rbs-unmatched-sig: `SystemCallError.new` (manual/api/_builtin/SystemCallError.md:15) — `SystemCallError.new(error_message) -> SystemCallError`
- rbs-unmatched-sig: `Thread.each_caller_location` (manual/api/_builtin/Thread.md:277) — `Thread.each_caller_location(start = 1, length = nil) {|location| ... } -> nil`
- rbs-unmatched-overload: `Thread#raise` (manual/api/_builtin/Thread.md:812) — `raise(error_type, message, traceback)     -> ()` [unmatched-overload: Thread#raise#0]
- rbs-unmatched-sig: `Time.at` (manual/api/_builtin/Time.md:44) — `Time.at(time)         -> Time`

- `Enumerable#all?`/`any?`/`none?`/`one?` の `pattern` 形は RBS に overload が無い(RBS 側の欠落)。`Numeric#ceil`/`round`/`truncate` の RBS の 2 番目の overload は doc の引数なし行にアリティが重ならない形(RBS 側の書き方)。いずれも `parameters` と RBS のファイルだけからの読みで未確認

### 候補 E: 4.0 の check_params の不一致(79 件)

| loc | class#name | only_in_sig | only_in_body |
|---|---|---|---|
| manual/api/_builtin/Enumerable.md:1565 | Enumerable#to_set |  | block |
| manual/api/_builtin/Fiber.md:419 | Fiber#resume |  | arg |
| manual/api/_builtin/Fiber.md:189 | Fiber.yield |  | arg |
| manual/api/_builtin/IO.md:430 | IO.popen |  | arg0,args,cmdname,execopt |
| manual/api/_builtin/MatchData.md:16 | MatchData#[] | length,start |  |
| manual/api/_builtin/Module.md:1457 | Module#class_variable_set | val |  |
| manual/api/_builtin/Object.md:1871 | Object#initialize_clone | obj |  |
| manual/api/_builtin/Set.md:787 | Set#disjoint? | set |  |
| manual/api/_builtin/Set.md:773 | Set#intersect? | set |  |
| manual/api/_builtin/String.md:3753 | String#bytesplice | str |  |
| manual/api/_builtin/String.md:401 | String#concat | other |  |
| manual/api/_builtin/String.md:3548 | String#encode | options | option |
| manual/api/_builtin/String.md:3602 | String#encode! | options |  |
| manual/api/_builtin/Symbol.md:414 | Symbol#[],slice | substr |  |
| manual/api/drb.md:213 | DRb.#start_service | config_or_acl | config |
| manual/api/drb/DRbServer.md:52 | DRb::DRbServer.new | config_or_acl | config |
| manual/api/erb.md:435 | ERB#location= |  | filename,lineno |
| manual/api/fiddle/2.0/Fiddle__MemoryView.md:116 | Fiddle::MemoryView#[] |  | ... |
| manual/api/json/JSON.md:433 | JSON.#load_file | opts | options |
| manual/api/json/JSON.md:443 | JSON.#load_file! | opts | options |
| manual/api/mkmf.md:337 | Kernel#egrep_cpp | opt |  |
| manual/api/mkmf.md:959 | Kernel#try_compile | opts |  |
| manual/api/mkmf.md:314 | Kernel#try_cpp | opts |  |
| manual/api/mkmf.md:293 | Kernel#try_link | options |  |
| manual/api/net/ftp.md:784 | Net::FTP#open_timeout= | seconds | second |
| manual/api/net/ftp.md:820 | Net::FTP#read_timeout= | seconds | second |
| manual/api/net/http/Net__HTTP.md:612 | Net::HTTP#open_timeout= | seconds | second |
| manual/api/net/http/Net__HTTP.md:1139 | Net::HTTP#patch | data,initheader | header |
| manual/api/net/http/Net__HTTP.md:825 | Net::HTTP#post | data |  |
| manual/api/net/http/Net__HTTP.md:640 | Net::HTTP#read_timeout= | seconds | second |
| manual/api/net/http/Net__HTTP.md:669 | Net::HTTP#write_timeout= | seconds | second |
| manual/api/net/imap.md:608 | Net::IMAP#search | keys | key |
| manual/api/net/imap.md:832 | Net::IMAP#sort,uid_sort | search_keys,sort_keys | search_key,sort_key |
| manual/api/net/imap.md:990 | Net::IMAP#thread | search_keys | search_key |
| manual/api/net/imap.md:633 | Net::IMAP#uid_search | keys | key |
| manual/api/net/imap.md:1012 | Net::IMAP#uid_thread | search_keys | search_key |
| manual/api/openssl/OpenSSL__ASN1__Constructive.md:26 | OpenSSL::ASN1::Constructive#tagging= | tag | tagging |
| manual/api/openssl/OpenSSL__BN.md:493 | OpenSSL::BN#prime? | checks | check |
| manual/api/openssl/OpenSSL__Buffering.md:108 | OpenSSL::Buffering#printf | args | arg |
| manual/api/openssl/OpenSSL__PKCS7.md:189 | OpenSSL::PKCS7#add_signer | singer | signer |
| manual/api/openssl/X509__ExtensionFactory.md:113 | OpenSSL::X509::ExtensionFactory#subject_certificate= | name | cert |
| manual/api/optparse/OptionParser.md:1141 | OptionParser#default_argv |  | argv |
| manual/api/psych.md:214 | Psych.safe_load | yaml |  |
| manual/api/resolv.md:669 | Resolv::DNS::Resource::SOA.new | retry_ | retry |
| manual/api/resolv-replace.md:23 | TCPSocket.new,open | serv | service |
| manual/api/resolv-replace.md:57 | UDPSocket#send | dest_sockaddr |  |
| manual/api/rexml/document.md:270 | REXML::Document#write | encoding |  |
| manual/api/rexml/REXML__Elements.md:235 | REXML::Elements#inject | initial |  |
| manual/api/rexml/REXML__Elements.md:17 | REXML::Elements.new | parent | parant |
| manual/api/rexml/xpath.md:61 | REXML::XPath.each | namespaces | namespace |
| manual/api/rexml/xpath.md:14 | REXML::XPath.first | namespaces | namespace |
| manual/api/rexml/xpath.md:98 | REXML::XPath.match | namespaces | namespace |
| manual/api/rexml/parsers/pullparser/REXML__Parsers__PullParser.md:14 | REXML::Parsers::PullParser.new | stream | source |
| manual/api/rexml/sax2listener.md:65 | REXML::SAX2Listener#start_element | attributes | attribute |
| manual/api/rinda/Rinda__TupleSpaceProxy.md:20 | Rinda::TupleSpaceProxy#notify | ev,tuple | event,pattern |
| manual/api/rubygems.md:407 | Gem.#done_installing |  | installer,specs |
| manual/api/rubygems.md:523 | Gem.#needs |  | request_set |
| manual/api/rubygems.md:571 | Gem.#post_build |  | installer |
| manual/api/rubygems.md:589 | Gem.#post_install |  | installer |
| manual/api/rubygems.md:622 | Gem.#post_uninstall |  | uninstaller |
| manual/api/rubygems.md:640 | Gem.#pre_install |  | installer |
| manual/api/rubygems.md:675 | Gem.#pre_uninstall |  | uninstaller |
| manual/api/rubygems.md:264 | Kernel#gem | gem_name | gem |
| manual/api/rubygems/requirement.md:209 | Gem::Requirement#pretty_print | pp | PP |
| manual/api/stringio.md:564 | StringIO#read_nonblock | maxlen | len |
| manual/api/syslog/logger.md:219 | Syslog::Logger#add | block |  |
| manual/api/time.md:163 | Time.strptime | now |  |
| manual/api/tsort.md:409 | TSort#each_strongly_connected_component_from | id_map,stack |  |
| manual/api/tsort.md:256 | TSort.each_strongly_connected_component_from | id_map,stack |  |
| manual/api/uri/Generic.md:81 | URI::Generic.new | parser |  |
| manual/api/win32ole/WIN32OLE.md:286 | WIN32OLE#[] |  | key |
| manual/api/win32ole/WIN32OLE.md:306 | WIN32OLE#[]= |  | key |
| manual/api/win32ole/WIN32OLE.md:454 | WIN32OLE#each |  | i |
| manual/api/win32ole/WIN32OLE.md:698 | WIN32OLE#setproperty |  | args |
| manual/api/win32ole/WIN32OLE_EVENT.md:99 | WIN32OLE_EVENT#on_event |  | args |
| manual/api/win32ole/WIN32OLE_EVENT.md:137 | WIN32OLE_EVENT#on_event_with_outargs |  | args |
| manual/api/win32ole/WIN32OLE_VARIANT.md:104 | WIN32OLE_VARIANT#[] |  | i |
| manual/api/win32ole/WIN32OLE_VARIANT.md:126 | WIN32OLE_VARIANT#[]= |  | i |
| manual/api/yaml/dbm.md:107 | YAML::DBM#fetch | ifnone |  |

## 標準添付ライブラリ — 2026-10-23

### 方法(標準添付)

- doctree master be865330e の版別 DB(3.0〜4.1・`update --markdowntree=manual/api`)から `tools/extract_db_sigs.rb` で `db-extract/` を作り直した。組み込みの節(上)は 629beb441 の DB の結果のままで、作り直していない(下の「組み込みの結果は変えていない」)
- 実 Ruby: `tools/measure_lib.sh`(docker を 1 版ずつ・`--memory=1500m`・`ulimit -c 0`)。ライブラリごとに新しいプロセスで `dump_params.rb --lib`。require に失敗したら gems 有効、さらに `--pre <親>` で再実行。未加工のダンプ(7 版で 265MB)は `tools/filter_lib.rb` で doctree にエントリのある [クラス, 名前] に絞って `real/<版>/lib.tsv`(先頭に lib 列)にまとめた
- 測った Ruby は 3.0〜4.0 が組み込みと同じ all-ruby の x.y.0、4.1 は `ghcr.io/ruby/ruby:master` の `ruby 4.1.0dev (2026-10-19T07:07:39Z master dfe721da1e)`(組み込みを測った 4.1.0-preview1 2d08b5f42f のイメージは手元に残っていない。比較で `builtin.tsv` を引く分は preview1 のもの)
- RBS: `measure_lib.sh` が取り出した各版の rbs gem の `stdlib/` を `tools/extract_rbs_stdlib.rb`(手元の rbs 4.1.3)で解析。同時に取り出した `core/` を `extract_rbs.rb` で解析し直した結果は 7 版とも既存の `rbs/<版>.tsv` とバイト単位で一致
- 実行したコマンド(doctree の worktree で。`W=/tmp/claude-1000/mps-work`)

```
for v in 3.0 3.1 3.2 3.3 3.4 4.0 4.1; do ruby -I../bitclust/lib tools/method-params/tools/extract_db_sigs.rb /tmp/claude-1000/db/$v tools/method-params $v; done
sh tools/method-params/tools/measure_lib.sh $PWD/tools/method-params $W
for v in 3.0 3.1 3.2 3.3 3.4 4.0 4.1; do
  ruby tools/method-params/tools/filter_lib.rb tools/method-params $W/lib-raw/$v $v
  BITCLUST_PATH=../bitclust bundle exec ruby tools/method-params/tools/extract_rbs_stdlib.rb $W/rbs-src/$v tools/method-params/rbs $v
  ruby tools/method-params/tools/compare_params.rb tools/method-params $v --stdlib
done
ruby tools/method-params/tools/diff_versions.rb tools/method-params --stdlib 3.0 3.1 3.2 3.3 3.4 4.0 4.1
```

### 測定できた範囲

| 版 | シグネチャ行を持つライブラリ | SKIP | 測定(lib-status.tsv の行) | nogems | gems | pre | gems+pre | failed |
|---|---|---|---|---|---|---|---|---|
| 3.0 | 223 | 4(debug・win32ole・win32/registry・win32/resolv) | 226 | 150 | 38 | 28 | 1 | 9 |
| 3.1 | 217 | 3(win32ole・win32/registry・win32/resolv) | 221 | 143 | 44 | 28 | 1 | 5 |
| 3.2 | 216 | 3 | 220 | 142 | 45 | 28 | 1 | 4 |
| 3.3 | 214 | 3 | 218 | 137 | 48 | 28 | 1 | 4 |
| 3.4 | 207 | 3 | 211 | 111 | 70 | 26 | 1 | 3 |
| 4.0 | 202 | 3 | 206 | 85 | 91 | 0 | 27 | 3 |
| 4.1 | 186 | 3 | 190 | 69 | 94 | 0 | 24 | 3 |

- 測定にはシグネチャ行を持たない親ライブラリ 7 つ(`cgi`・`io`・`net`・`racc`・`rdoc`・`rinda`・`yaml`)を含む。このうち `io`・`net`・`rinda` はその名前のライブラリが無いので全版で `failed`(エントリは無く、比較には影響しない)
- 本物の require 失敗(エントリが `lib-require-failed` になるもの):
  - 3.0: `fiddle`・`fiddle/import`(libffi.so.7 が無い)・`dbm`・`yaml/dbm`(libgdbm_compat.so.4 が無い)・`rexml`(all-ruby 3.0.0 に bundled gem が入っていない)・`irb/cmd/subirb`(単体では `IRB.conf` が nil で NoMethodError)
  - 3.1: `irb/cmd/subirb`・`yaml/dbm`(dbm が bundled gem になり all-ruby に無い)
  - 3.2・3.3: `yaml/dbm`
  - 3.4〜4.1: なし。ただし 3.4 以降の `yaml/dbm` は require できても `YAML::DBM` が定義されない(dbm が無い)ので、エントリは `no-class`
- シグネチャ行を持たないライブラリ(定数・概要だけ。3.4 で 101 個)は対象外: `English`・`bundler`・`did_you_mean`・`digest/md5` などの digest のサブライブラリ・`fcntl`・`irb/*` の多く・`json/add/core`・`minitest/*`・`net/https`・`optparse/date` などの optparse のサブライブラリ・`rbconfig/sizeof`・`rdoc/code_object/*` の多く・`rubygems/commands/*`・`thread`・`typeprof`・`yaml` など

### 段階 1: 実 Ruby との突き合わせ(エントリ単位・標準添付)

| 版 | エントリ数 | ok | ok-split | forwarding? | doc-no-optional? | req-count | opt-count | rest | kw-mismatch | name-mismatch | block-missing | doc-allows-more | no-real | no-real:inherited | no-class | lib-require-failed | lib-not-measured |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 3.0 | 5825 | 4537 | 95 | 102 | 22 | 75 | 71 | 12 | 30 | 227 | 7 | 0 | 241 | 9 | 99 | 138 | 160 |
| 3.1 | 5736 | 4500 | 102 | 106 | 31 | 74 | 70 | 12 | 34 | 217 | 4 | 0 | 235 | 10 | 158 | 24 | 159 |
| 3.2 | 5723 | 4476 | 102 | 106 | 30 | 77 | 72 | 12 | 37 | 223 | 5 | 0 | 236 | 10 | 158 | 20 | 159 |
| 3.3 | 5794 | 4496 | 101 | 139 | 30 | 76 | 74 | 12 | 44 | 225 | 5 | 0 | 248 | 12 | 153 | 20 | 159 |
| 3.4 | 5880 | 4554 | 101 | 141 | 30 | 75 | 75 | 12 | 53 | 225 | 5 | 0 | 264 | 11 | 175 | 0 | 159 |
| 4.0 | 5748 | 4412 | 101 | 152 | 30 | 81 | 73 | 12 | 52 | 219 | 6 | 0 | 252 | 12 | 187 | 0 | 159 |
| 4.1 | 5584 | 4254 | 100 | 147 | 28 | 78 | 81 | 13 | 59 | 201 | 6 | 1 | 266 | 11 | 180 | 0 | 159 |

- `lib-not-measured` は SKIP のライブラリ(大半が `win32ole`)。ライブラリ別の件数は `result/<版>/lib-summary-by-lib.tsv`
- `name-mismatch` が組み込みより多い(200 件台)。rurema の読みやすい仮引数名と実装の名前の差で、#3589 に近い話
- `no-real`(250 件前後)の多くは doc の置き場と実装のモジュールの違い: `mkmf`(4.0 で 52 件。doc は `Kernel#...`、実装は `MakeMakefile`)・`net/imap`(44 件。`Struct` で作る応答クラスのメンバー)・`rss`・`digest`・`un`・`prism`・`etc`・`stringio` など
- `no-class` の主なもの(4.0): `RSS::DublinCoreModel`(30・メソッドを動的に定義するモジュール)・`YAML::DBM`(20・上記)・`OpenSSL::Engine`(14・OpenSSL 3 で無い)・`Readline::HISTORY`(12・オブジェクト)・`Net::IMAP::*` の応答の構造体・`CGI`(cgi/util)・`Object`(pp)・`OpenSSL::Digest::SHA` など OpenSSL 3 で消えたダイジェスト

### 段階 1: RBS との突き合わせ(エントリ単位・標準添付)

| 版 | ok | no-rbs | rbs-unmatched-sig | rbs-unmatched-overload |
|---|---|---|---|---|
| 3.0 | 692 | 5129 | 2 | 2 |
| 3.1 | 2094 | 3630 | 8 | 4 |
| 3.2 | 2121 | 3592 | 6 | 4 |
| 3.3 | 2320 | 3465 | 5 | 4 |
| 3.4 | 2403 | 3466 | 7 | 4 |
| 4.0 | 2242 | 3494 | 7 | 5 |
| 4.1 | 2204 | 3369 | 6 | 5 |

- rbs gem 同梱の stdlib は 3.0(rbs 1.0.0)で 30 ライブラリ・4.1(rbs 4.2.0)で 60 ライブラリ。`no-rbs` が多いのはそのため
- 読めなかった RBS ファイル: 3.0 は `benchmark`、3.1・3.2 は `benchmark`・`fileutils`(いずれも `void` の構文エラー。`rbs/<版>-stdlib.log`)

### 段階 2: 版間の変化(標準添付)

| 版の組 | unreflected | name-only | already-consistent | forwarding | c-decl-change | reflected | rbs-only | doc-only | 計 |
|---|---|---|---|---|---|---|---|---|---|
| 3.0→3.1 | 10 | 7 | 38 | 85 | 11 | 3 | 3 | 0 | 157 |
| 3.1→3.2 | 16 | 9 | 15 | 0 | 0 | 9 | 8 | 3 | 60 |
| 3.2→3.3 | 16 | 4 | 1 | 37 | 0 | 2 | 3 | 0 | 63 |
| 3.3→3.4 | 31 | 4 | 25 | 5 | 0 | 3 | 4 | 3 | 75 |
| 3.4→4.0 | 19 | 6 | 98 | 136 | 2 | 5 | 8 | 2 | 276 |
| 4.0→4.1 | 38 | 3 | 5 | 0 | 0 | 3 | 16 | 0 | 65 |
| 計 | 130 | 33 | 182 | 263 | 13 | 25 | 42 | 8 | 696 |

- `forwarding` の内訳: 3.0→3.1 は委譲メソッド(`forwardable` の `def_delegator`・`Gem::Deprecate` のラッパーなど)の `parameters` が `rest:args block:block` から `rest:args keyrest:** block:block` になったもの 85 件(`reline` 38・`csv` 28・`rss` 6・`rubygems/*` 7・`prime` 4・`rexml/parsers/pullparser` 2)。3.2→3.3 は C 実装の `readline` が `reline` の委譲になったもの 36 件と `Gem::Platform.match` 1 件。3.4→4.0 は委譲メソッドが無名の `(*, **, &)` になったもの(`reline` 40・`readline` 35・`csv` 28・`rss` 6・`prime` 4・`rexml` 2)、C 実装の `Pathname` のメソッドが Ruby 定義の `(*, **, &)` になったもの 15 件、`JSON.unparse`/`fast_unparse`/`pretty_unparse` が `(obj, opts = nil)` から `(*, **, &)` の転送になったもの 6 件。3.3→3.4 は `Net::IMAP#fetch`/`uid_fetch`/`search`/`uid_search` が `(*, **, &)` になったもの 4 件と `OptionParser#order` 1 件(`(*argv, **keywords, &nonopt)`。ブロックを持つので転送とみなした)
- `forwarding` にした行は実 Ruby の引数の形から何も言えないだけで、API が変わっていないとは限らない(`Net::IMAP#fetch` は 3.3 で `changedsince:` が付いたあと 3.4 で転送の形になった)
- `impl-change`・`no-doc` は 0 件

### 候補: unreflected(130 件)

`result/lib-changes.tsv` の flag が `unreflected` の行をライブラリごとにまとめた。「実 Ruby の変化」は `parameters` の差(`+` 追加・`-` 削除)。【実測済み】は docker で呼んで確かめたもの(下の「実測の記録」)、それ以外は `parameters` からの読み。

| ライブラリ | 版 | メソッド | 実 Ruby の変化 | 読み |
|---|---|---|---|---|
| json | 4.0→4.1 | `JSON.parse`/`parse!`/`load`/`load_file`/`load_file!`/`unsafe_load`(`JSON#...` のモジュール関数も。12 件)・`JSON::Coder.new` | 位置引数の `opts`/`options` が `**options` になり、`parse` に `on_load:`・`object_class:`・`array_class:`、`load` に `allow_blank:` | 【実測済み】本物。4.1(json 3.1.0)で `JSON.parse(src, {symbolize_names: true})` は ArgumentError(given 2, expected 1)。doc は全版 `parse(source, options = {})` |
| json | 3.2→3.3・4.0→4.1 | `JSON.dump`(と `JSON#dump`) | 3.3 で `kwargs` を追加、4.1 で `limit` が `_deprecated_limit` に | 本物(軽微)。4.1 の `limit` 非推奨は本文の確認が要る |
| json | 3.3→3.4・3.4→4.0 | `JSON::State#configure`/`merge`/`generate` | 3.4 で C から Ruby 定義(`generate(obj, io = nil)`)、4.0 で C に戻る | `generate` の `io` は 3.4 からの追加の可能性(未確認)。他は実装の移行 |
| json/add/symbol | 3.4→4.0 | `Symbol#to_json` | `(*a)` → `(state = nil, *a)` | ノイズ(呼び方は同じ) |
| net/imap | 3.2→3.3 | `#examine`/`#select`(`condstore:`)・`#fetch`/`#uid_fetch`(`changedsince:`)・`#store`/`#uid_store`(`unchangedsince:`)・`#responses(type = nil)` | キーワード・任意引数の追加 | 本物(bundled gem net-imap) |
| net/imap | 3.1→3.2・3.2→3.3・3.3→3.4 | `#authenticate` | `(auth_type, *args)` → `(mechanism, *creds, sasl_ir:, **props, &callback)` → `(*args, sasl_ir:, **props, &callback)` | 本物。doc は `authenticate(auth_type, user, password)` のまま |
| net/imap | 4.0→4.1 | `#disconnect` | `timeout:` | 本物 |
| net/smtp | 3.0→3.1 | `Net::SMTP.new`・`.start`・`#start`・`.default_ssl_context` | `tls:`・`starttls:`・`tls_verify:`・`tls_hostname:`・`ssl_context_params:`(net-smtp は 3.1 から bundled gem) | 本物。doc は 3.0 の形のまま |
| optparse | 3.1→3.2 | `OptionParser#load` | `into:` | 本物 |
| optparse | 3.2→3.3 | `OptionParser#getopts`・`.getopts` | `symbolize_names:` | 【実測済み】本物(3.3 から `getopts(["-a"], "a", symbolize_names: true)` が `{a: true}`。3.2 以前は NoMethodError)。`OptionParser::Arguable#getopts` の doc には既にある |
| optparse | 3.3→3.4 | `#parse`/`parse!`/`order!`/`permute`/`permute!`/`environment`/`load`/`getopts`・`Arguable#parse!`/`order!`/`permute!`/`getopts`(12 件) | `into:` などが `**keywords` に | ノイズ寄り(`into:` を `**keywords` で受けて下へ渡す形に変わっただけ)。doc の `into:` はそのまま使える |
| psych | 3.0→3.1 | `Psych.load_stream`・`Psych.parse_stream` | 位置引数 `legacy_filename` が無くなり `filename:` キーワードだけに | 本物。doc は `load_stream(yaml, filename=nil)` で、3.1 から `Psych.load_stream("--- 1\n", "f.yml")` は ArgumentError【実測済み】 |
| psych | 3.1→3.2・3.4→4.0 | `Psych::Nodes::Node#to_ruby`/`transform`・`Psych::ScalarScanner.new` | 3.2 で `strict_integer:`、4.0 で `parse_symbols:` | 本物 |
| psych | 3.1→3.2 | `Psych::Parser#parse` | C から Ruby 定義 `parse(yaml, path = ...)` | `path` は C 実装にもあった可能性(未確認)。doc は `parse(yaml)` |
| openssl | 3.3→3.4 | `OpenSSL::Buffering#gets` | `chomp:` | 本物 |
| openssl | 4.0→4.1 | `OpenSSL::Buffering#each`/`each_line`/`readline`/`readlines` | `limit`・`chomp:` | 本物 |
| openssl | 4.0→4.1 | `OpenSSL::SSL::SSLSocket#connect`/`accept`(`timeout:`)・`#connect_nonblock`/`accept_nonblock`(`exception:`) | C から Ruby 定義 | 【実測済み】`connect` の `parameters` は 4.1 で `[[:key, :timeout]]`、4.0 で `[]`。`exception:` は C 実装にもあった(doc に無い) |
| logger | 3.3→3.4・3.4→4.0 | `Logger.new`・`Logger::LogDevice.new` | 3.4 で `reraise_write_errors:`、4.0 で `LogDevice` に `skip_header:` | 【実測済み】`Logger.new($stderr, reraise_write_errors: [IOError])` は 3.4 から通り、3.3 以前は unknown keyword |
| net/http | 3.3→3.4 | `Net::HTTP.new`・`Net::HTTP.Proxy` | 8 番目の位置引数 `p_use_ssl` | 【実測済み】3.4 から 8 引数が通る(3.3 以前は 1..7) |
| pathname | 3.0→3.1・3.1→3.2 | `Pathname#mkpath`(`mode:`)・`Pathname#rmtree`(`noop:`・`verbose:`・`secure:`) | キーワードの追加 | 【実測済み】`mkpath(mode: 0700)` は 3.1 から、`rmtree(noop: true)` は 3.2 から通る。doc はどちらも引数なし |
| pathname | 3.4→4.0 | `Pathname.glob`・`Pathname#glob` | C から Ruby 定義 `(*args, **kwargs)` | ノイズ(実装の移行) |
| resolv | 3.2→3.3 | `Resolv.new` | `use_ipv6:` | 本物(`parameters` のみ。3.2 以前は位置引数の Hash として受けてしまうので呼んでも区別できない) |
| rexml/document | 3.3→3.4 | `REXML::Text.unnormalize` | `entity_expansion_text_limit:` | 本物(内部向けに近い) |
| ostruct | 3.1→3.2 | `OpenStruct#delete_field` | `&block` | 【実測済み】3.1 からブロックで既定値を返す(`parameters` に出たのは 3.2)。doc にブロックが無い |
| bigdecimal/util | 3.4→4.0 | `Rational#to_d` | `precision` が省略可能に | 【実測済み】4.0 から `Rational(1,3).to_d` が通る(4.0 同梱 bigdecimal)。doc は `to_d(nFig)` |
| time | 4.0→4.1 | `Time.parse` | `zone:` | 【実測済み】4.1 の `parameters` は `[[:req, :date], [:opt, :now], [:key, :zone]]`。4.0 は `zone:` を `now` の Hash として受けてしまう |
| rdoc/parser/c・ruby・simple | 3.4→4.0 | `RDoc::Parser::C.new` など 3 件 | `file_name` 引数が無くなる | 本物。doc は全版 5 引数 `(top_level, file_name, body, options, stats)` |
| rdoc/markup/* | 4.0→4.1 | `ToAnsi`/`ToBs`/`ToRdoc.new`(`markup` が無くなる)・`ToHtmlCrossref.new`(`options` が無くなりキーワードに)・`RDoc::Context::Section.new`(`store` の追加) | 4.1 の rdoc での変更 | 本物(rdoc のクラス API) |
| rubygems/ext/* | 3.1→3.2・3.3→3.4・3.4→4.0 | `Gem::Ext::Builder.make`/`run`・`ConfigureBuilder`/`ExtConfBuilder`/`RakeBuilder.build`(10 件) | `sitedir`・`targets`・`env`・`target_rbconfig`・`n_jobs:` | 本物だが RubyGems の内部 API |
| rubygems/* | 3.3→3.4・3.4→4.0・4.0→4.1 | `Gem::Platform.local`(`refresh:`)・`Gem::Uninstaller#uninstall_gem`(引数 1 つ。doc は 2 つ)・`Gem::Package::TarWriter#add_file`(`mtime`)・`Gem::Package.build`(`content_addressable:`) | 追加・変更 | 本物(内部 API 寄り。`content_addressable:` は #3613 で保留の件) |
| csv | 3.1→3.2 | `CSV.new`(`max_field_size:`)・`CSV::Table#to_csv`/`to_s`(`limit:`) | キーワードの追加 | 本物。doc は `options` の Hash で受ける書き方なので、本文の表に足すかどうか |
| csv | 3.0→3.1・3.3→3.4・4.0→4.1 | `CSV.new` の並び替え・`CSV.open`/`foreach`/`read`/`readlines`/`table` の仮引数名(`path` → `path_or_io`) | 名前だけ | ノイズ(doc の `options` Hash の書き方で opt-count/kw-mismatch が残る) |
| prism | 4.0→4.1 | `Prism::Source.for` | `start_line`・`offsets` が必須になり、`comments` などを追加 | 本物(4.1 は prism の master) |
| irb・irb/* | 3.0→4.0 | `IRB.irb_exit`・`IRB::ExtendCommand::*`・`IRB::ExtendCommandBundle.def_extend_command`・`IRB::Inspector#inspect_value`(8 件) | 内部 API の変化 | 低優先(irb の内部。doc の掲載自体の見直し候補) |
| delegate・open-uri・resolv-replace・tmpdir・weakref | 各版 | `Delegator#method_missing`・`URI.open`・`TCPSocket.new`(resolv-replace)・`Dir.mktmpdir`・`WeakRef#__getobj__` | 無名の `**` や `&block` が増えただけ | ノイズ(呼び方は変わらない) |

### 実測の記録

```
# ghcr.io/ruby/ruby:master(4.1.0dev dfe721da1e)と all-ruby 4.0.0
JSON::VERSION                                    4.1: "3.1.0"   4.0: "2.18.0"
JSON.parse('{"a":1}', {symbolize_names: true})   4.1: ArgumentError (given 2, expected 1)   4.0: {a: 1}
Time.method(:parse).parameters                   4.1: [[:req, :date], [:opt, :now], [:key, :zone]]   4.0: [[:req, :date], [:opt, :now]]
OpenSSL::SSL::SSLSocket.instance_method(:connect).parameters   4.1: [[:key, :timeout]]   4.0: []
# all-ruby 3.0.0〜4.0.0(左から初めて通った版)
Pathname#mkpath(mode: 0700)                       3.1
Pathname#rmtree(noop: true)                       3.2
Psych.load_stream("--- 1\n", "f.yml")             3.0 だけ通り、3.1 以降は ArgumentError (given 2, expected 1)
OptionParser.new.getopts(["-a"], "a", symbolize_names: true)   3.3
Logger.new($stderr, reraise_write_errors: [IOError])            3.4
Net::HTTP.new("example.com", 80, nil, nil, nil, nil, nil, true) 3.4
OpenStruct.new.delete_field(:x) { :dflt }         3.1
Rational(1,3).to_d                                4.0
```

### doc-only(8 件)と name-only(33 件)

- `doc-only`: `result/lib-changes.tsv` の flag `doc-only`。doc の行の集合だけが変わったもの(`#%since` の置き場所の確認候補)
- `name-only`: 変化後に残る差が仮引数名だけ(多くは csv・net/imap・rdoc の名前の変更)

### 組み込みの結果は変えていない

- 組み込みの出力(`result/<版>/{mismatch,mismatch-entries,entry-verdicts,summary}.*`・`result/changes*`)は、変更前の `compare_params.rb`/`diff_versions.rb`(HEAD のもの)と変更後のものを同じ入力(be865330e の `db-extract/` と既存の `real/<版>/builtin.tsv`・`rbs/<版>.tsv`)で動かし、`diff -r` で全ファイル一致を確かめた
- `dump_params.rb` も `--lib` なしの出力が変更前と一致する(手元の ruby 3.4 で `ruby --disable-gems` の出力を `cmp`)
- コミットしてある組み込みの結果は 629beb441 の DB のもので、be865330e で作り直すと doctree 側の修正(上の候補の反映)の分だけ件数が変わる。作り直しはしていない

## 限界と次の作業

### 検証の区分

- 「実測で確認した候補」の節は実機で呼んで確認済み。他の表の「読み」は `parameters`・RBS・doc の指紋からの推測で、未確認のものは未確認と書いた

### ノイズの源(件数を鵜呑みにしない)

- C 実装の `parameters` は `[[:rest]]`(arity -1)か名前なしの `req` だけ。任意引数の数・キーワード・名前は分からず、`doc-no-optional?` は弱い信号(`rb_scan_args` で doc の必須数ちょうどを受けるメソッドも多い)。C の `rest` と doc の引数の差は検出できない
- 転送(`*, **, &`)で定義された Ruby 定義のメソッドも arity から何も言えない(`forwarding?`)
- `ok-split` は引数パターンを合成して比べるので、合成した行では位置引数名を比べず、パターン同士の矛盾(ある行だけ誤り)も見えない
- rurema の書き方による差: `-> ()` の戻り値表記、`...`(`rest`/`kwrest`/`block` として扱った)、`[env, cmdname, ...]`・`first..last`・`key...`・`*arg = nil` のようなシグネチャ行(`status: unusual` で除外。全版で 12 行前後)、`opt={}` を位置引数として書く慣例(実 Ruby ではキーワード。`Marshal.load` は本物だった)
- 仮引数名は rurema が読みやすい名前を選ぶ慣例がある
- `Klass.new` は `initialize` の行で比較。`initialize` を持たないクラスは `no-real:inherited`
- 実測側に行が無いクラス(`Object`・`ENV`・`ARGF.class`・`main`・`RubyVM::YJIT`/`ZJIT`)は `no-class`。独自の型として別に実測が必要
- 環境依存の arity(`Process::Sys` など Linux で未実装のもの)
- 段階 2 の `no-doc` は doc の別名・エントリの置き場(`Kernel`↔`Object` など)の違いを含む。RBS が片方の版にしか無いメソッドは `rbs-only` を判定しない
- 標準添付は上の「標準添付ライブラリ」の節。README の「標準添付に固有の限界」も参照

### 修正する前に手で確認すること

- キーワードの追加は、実 Ruby で呼び出して挙動を確かめ、`since` を実測した版(x.y.0 タグ)で付ける
- `doc-only` は doc の `#%since` が実際の導入版と合っているか(NEWS・コミット)を確認する
- 候補 D は RBS 側の欠落が多く、rurema の修正対象ではない(RBS への報告の材料)

### 次の作業

- 実測で確認した候補を doctree の PR にする(キーワード追加+版分岐)
- 標準添付の本物の候補(json 4.1 の `**options` 化・psych の `filename:`・pathname・net/smtp・net/imap・optparse・logger・openssl など)を doctree の PR にする
- `check_params` の結果(#3589)との突き合わせ・`rbs-unmatched-*` を RBS 側へ報告するか判断

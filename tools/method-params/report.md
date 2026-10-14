# メソッド引数チェック(Ruby 3.0〜4.1・組み込み)— 2026-10-12(初版)

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
- 組み込みのみ。標準添付(`require` が必要なライブラリ)は未着手

### 修正する前に手で確認すること

- キーワードの追加は、実 Ruby で呼び出して挙動を確かめ、`since` を実測した版(x.y.0 タグ)で付ける
- `doc-only` は doc の `#%since` が実際の導入版と合っているか(NEWS・コミット)を確認する
- 候補 D は RBS 側の欠落が多く、rurema の修正対象ではない(RBS への報告の材料)

### 次の作業

- 実測で確認した候補を doctree の PR にする(キーワード追加+版分岐)
- 標準添付ライブラリへの拡張(`require` 後の差分ダンプ)
- `check_params` の結果(#3589)との突き合わせ・`rbs-unmatched-*` を RBS 側へ報告するか判断

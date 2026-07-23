# mismatch-report.md — 実測 vs doctree/本番DB 不一致レポート

作成: 2026-07-23。`tools/compare.rb` の出力 `mismatches.tsv`(2163エントリ)
を doctree/gd(generated-documents)の修正アクション検討用に整理したもの。
ロジックの詳細・用語の定義は `notes-compare.md` 参照。

## エグゼクティブサマリ

**何と何を突き合わせたか**: (1) 実 Ruby 処理系19版(1.8.6〜4.0、all-ruby
Docker実測)から得た「メソッドが実際に存在する版」、(2) doctree
`_builtin/*.md` の明示 `{: since=}`/`{: until=}` 属性、(3) 本番
docs.ruby-lang.org を配信する generated-documents リポジトリの各版DB
(17版、1.8.7〜4.1)のメソッドファイル `names=` から得た「本番バッジ計算が
実際に使っている、名前単位の存在データ」。doctree の組み込みクラス
ドキュメントの kind=singleton/instance/module_function エントリ2163件
(kind=constant/special-variableは対象外)全件について、本番相当で計算した
現在のバッジと、実測から導かれる期待バッジを突き合わせた。

**内訳**: OK 1544件(71.4%)、INFO(参考情報のみ・不一致なし) 140件
(6.5%)、MISMATCH_SINCE 432件(20.0%)、MISMATCH_UNTIL 12件(0.6%)、
DOC_ONLY 35件(1.6%)。

**最重要の発見**:

1. **凍結DB混入(frozen-db-contamination)11件**のうち7件は
   doctree#3269(`Module#prepend`)と同種の「凍結版DBへの後年機能混入」
   バグで、**修正には凍結DBのパッチ+HTML再生成が必要**(過去に issue
   #157 で実施した手順と同種)。残り4件(`Ractor` の `[]`/`[]=`/
   `main?`/`store_if_absent`)は凍結版ではなくライブ版DB(3.0)側の
   バージョンゲート漏れ(doctree-entries.tsv で pp_cond なしを確認済み)で、
   **doctree側に `#@since 3.4` ゲートを追加すれば次回生成で修正される**
   (バッジが直るだけでなく、実在しない 3.0〜3.3 の版ページからも記載が
   消える。`{: since="3.4"}` 属性だけではバッジしか直らないので不適)。
   両者は原因も修正方法もまったく別なので取り違えないこと。
2. **`ladder-gap-1.9.1-1.9.3`(since 273件+until 2件)**が
   `MISMATCH_SINCE` の過半数(63%)を占める。これは DB のバージョン
   ラダーに1.9.1/1.9.2に相当する版が存在しないという**構造的制約**で
   あり、自動バッジ計算が原理的に正しい値を出せない。個別の doctree
   バグではなく、方針判断(明示 `since=` を大量投入するか否か)が必要。
3. **`db-late`(92件)**はドキュメント側の since 明示が実装より遅れている
   典型パターンで、35クラスに分散(`ObjectSpace::WeakMap` 12件、
   `BasicObject` 10件など特定クラスに偏りあり)。件数が多いためトリアージ
   前提。
4. **`real-autoload-gap:Set`(52件)**と**`real-build-gap:YJIT`
   (4件+関連DOC_ONLY6件)**は測定環境側の既知ギャップで、doctree/DBの
   問題ではない。アクション不要。
5. **until 側(MISMATCH_UNTIL 12件)は査読の結果、本物のドキュメント/DB
   バグ0件**(測定条件ギャップ・規約説明エントリ・alias-union の限界・
   YJIT ビルド・ラダーギャップのいずれか)。修正対象は since 側のみ。
   副産物として、DOC_ONLY の精査から **doctree の記載セクション誤り3件**
   (`Thread.ignore_deadlock`/`ignore_deadlock=`・`Rational.convert` が
   インスタンスメソッドとして記載)と既知の `Thread::DEBUG` 構造バグの
   再確認が得られた(DOC_ONLY セクション参照)。

## verdict件数表

再集計コマンド: `awk -F'\t' 'NR>1{c[$17]++} END{for(k in c) print
k"\t"c[k]}' mismatches.tsv`

| verdict | 件数 | 比率 |
|---|---:|---:|
| OK | 1544 | 71.4% |
| MISMATCH_SINCE | 432 | 20.0% |
| INFO_1_8_7 | 72 | 3.3% |
| INFO_1_9_2 | 68 | 3.1% |
| DOC_ONLY | 35 | 1.6% |
| MISMATCH_UNTIL | 12 | 0.6% |
| **合計** | **2163** | 100% |

MISMATCH_SINCE の note 内訳(いずれか1つが排他的に付く):

| note | 件数 |
|---|---:|
| `ladder-gap-1.9.1-1.9.3` | 273 |
| `db-late` | 92 |
| `real-autoload-gap:Set` | 52 |
| `frozen-db-contamination` | 11 |
| `explicit-wrong` | 4 |
| 合計 | 432 |

MISMATCH_UNTIL の note 内訳:

| note | 件数 |
|---|---:|
| `until-mismatch` | 6 |
| `real-build-gap:YJIT-disabled-in-prebuilt-3.2+` | 4 |
| `ladder-gap-1.9.1-1.9.3` | 2 |
| 合計 | 12 |

## カテゴリ別セクション

### frozen-db-contamination(11件)

**意味**: `db_first < real_first`。本番DB上でメソッドの初出版が、実測の
初出版より**早い**——「実際には後の版で追加された機能が、より古い版のDBに
紛れ込んでいる」状態。バッジは実際より早い版から存在したかのように誤表示
される。

**原因**: 2系統ある(区別して読むこと)。

- **db_first ≤ 2.7.0(7件)**: 凍結版DB(1.8.7〜2.7.0は特定時点のソース
  スナップショットから固定生成されたDB)への後年機能の混入。
  doctree#3269 で報告された `Module#prepend`(本来2.0.0導入なのに
  1.9.3に掲載)と原因が同一——凍結タグ選定時、対象コミット時点で既に
  `#@since` ゲートが削除済みだった機能がそのまま凍結版に混入した。
  **修正 = generated-documents の凍結DB(該当版のblob)をパッチ+
  静的HTML再生成**(issue #157で実施した手順と同種。db側とhtml側の
  両方を直す必要がある)。
- **db_first ≥ 3.0(4件、全て `Ractor`)**: 凍結版ではなく**ライブ版**
  DB(3.0)への混入。ライブ版は最新の doctree ソースから都度再生成される
  ため、こちらは凍結DBのパッチでは直らない。**修正 = doctree の該当
  4エントリを `#@since 3.4`〜`#@end` で囲む**(Ractor.md の該当エントリに
  プリプロセッサ条件が無いことは doctree-entries.tsv の pp_cond 列で
  確認済み)。ゲートすれば db-3.0〜3.3 からエントリ自体が消え、バッジも
  自動計算で 3.4 になる。`{: since="3.4"}` 属性の追加だけではバッジ表示
  しか直らず、Ruby 3.0〜3.3 の版ページに実在しないメソッドの記載が残る
  ため不十分。

| class | kind | method | real_first | db_first | 現バッジ | 期待値 | 分類 |
|---|---|---|---:|---:|---:|---:|---|
| Binding | i | irb | 2.5 | 2.4.0 | 2.4.0 | 2.5.0 | 凍結DB混入 |
| Enumerator | i | size | 2.0.0 | 1.9.3 | 1.9.3 | 2.0.0 | 凍結DB混入 |
| Enumerator::Lazy | i | force | 2.3 | 2.0.0 | 2.0.0 | 2.3.0 | 凍結DB混入 |
| Module | i | prepend | 2.0.0 | 1.9.3 | 1.9.3 | 2.0.0 | 凍結DB混入(doctree#3269 本体) |
| String | i | b | 2.0.0 | 1.9.3 | 1.9.3 | 2.0.0 | 凍結DB混入 |
| main | s | define_method | 2.0.0 | 1.9.3 | 1.9.3 | 2.0.0 | 凍結DB混入 |
| main | s | using | 2.0.0 | 1.9.3 | 1.9.3 | 2.0.0 | 凍結DB混入 |
| Ractor | s | [] | 3.4 | 3.0 | 3.0 | 3.4 | ライブDBゲート漏れ |
| Ractor | s | []= | 3.4 | 3.0 | 3.0 | 3.4 | ライブDBゲート漏れ |
| Ractor | s | main? | 3.4 | 3.0 | 3.0 | 3.4 | ライブDBゲート漏れ |
| Ractor | s | store_if_absent | 3.4 | 3.0 | 3.0 | 3.4 | ライブDBゲート漏れ |

**推奨アクション**: 凍結DB混入7件は「実害があるものだけ手動パッチ」
方針(過去のstudyinghttp.net issueと同じ判断軸)で個別トリアージ。
`Module#prepend` は既に issue #3269 として報告済みなので優先。
`Ractor` 4件は doctree PR 1本で `{: since="3.4"}` 追加すれば完結する
軽微な修正。

### explicit-wrong(4件)

**意味**: doctree に明示 `since="X"` 属性が書かれているが、その値自体が
実測と食い違っている(著者記載ミス)。

| class | kind | method | 明示since | real_first |
|---|---|---|---:|---:|
| ARGF.class | i | print | 1.9.3 | 1.9.1 |
| ARGF.class | i | printf | 1.9.3 | 1.9.1 |
| ARGF.class | i | putc | 1.9.3 | 1.9.1 |
| ARGF.class | i | puts | 1.9.3 | 1.9.1 |

**推奨アクション**: `ARGF.md` の該当4箇所を `{: since="1.9.1"}` へ修正。
実測ベースの単純な訂正であり、他のカテゴリと違って解釈の余地がない。

### until-mismatch(6件)——査読の結果、全件アクション不要

**意味**(機械的分類): 実測の消滅時期と本番DBの存在範囲から導いた
期待untilと現在バッジが食い違う。当初「until側のゲート漏れ疑い」として
抽出したが、**個別査読の結果、6件すべてが実測側のアーティファクトであり、
本番の until バッジ(いずれも表示なし=none、Fixnum#zero? のみ
「2.4.0まで」)は現状のままで正しい**と結論した。

| class | kind | method | real_first | real_last | db_first | db_last | 現until | 期待until |
|---|---|---|---:|---:|---:|---:|---:|---:|
| Kernel | o | sub | 1.8.6 | 1.8.7 | 1.8.7 | 4.1 | none | 1.9.1 |
| Kernel | o | gsub | 1.8.6 | 1.8.7 | 1.8.7 | 4.1 | none | 1.9.1 |
| Kernel | o | chop | 1.8.6 | 1.8.7 | 1.8.7 | 4.1 | none | 1.9.1 |
| Kernel | o | chomp | 1.8.6 | 1.8.7 | 1.8.7 | 4.1 | none | 1.9.1 |
| Object | i | to_a | 1.8.6 | 1.8.7 | 1.8.7 | 4.1 | none | 1.9.1 |
| Fixnum | i | zero? | 1.8.6 | 4.0 | 1.8.7 | 2.3.0 | 2.4.0 | none |

- **`Kernel.#sub`/`gsub`/`chop`/`chomp`(4件)= 測定条件ギャップ**。
  これらは 1.9 以降「削除された」のではなく、**`-p`/`-n` オプション
  指定時のみ動的に定義される**トップレベル関数に変わった(CRuby の
  ruby.c が do_loop 時に `rb_define_global_function` する。現在の 4.x
  でも `echo abc | ruby -pe 'sub(/b/,"X")'` は動く)。1.8 系だけは
  フラグなしでも無条件定義だったため、フラグなしで実行する
  `dump_methods.rb` には「1.8.7 を最後に消滅」と見えた。doctree
  (functions.md)の「コマンドラインオプションで -p または -n を指定した
  時のみ定義されます」という記述は正確で、db-4.1 まで存在扱いなのも
  正当。**アクション不要**。
- **`Object#to_a`(1件)= `{: nomethod}` 付き規約説明エントリ**。
  Object.md:322 の実物は `{: nomethod}` 付きで「このメソッドは実際には
  Object クラスには定義されていません」と明記された変換プロトコルの
  説明(to_str/to_ary 等の DOC_ONLY 群と同種)。real 側が 1.8 系で
  観測できたのは、1.8 に実在した `Kernel#to_a`(1.9 で削除)を tier4
  継承解決が拾ったため(`{: nomethod}` は `{: undef}` と違い継承解決を
  抑制しない)。規約説明エントリに until 判定は無意味であり、
  **アクション不要**(compare.rb の改良候補: `nomethod` フラグでも
  real 側解決を抑制すれば、この行は to_str 等と同じ DOC_ONLY に
  分類されるようになる)。
- **`Fixnum#zero?`(1件)= alias-union の限界**。real側は
  `alias-union`(Fixnum→Integerのエイリアス統合)で2.4.0以降も
  `Integer#zero?`として存在し続けるため、compare.rbのreal側解決では
  「union全体としては消えていない」= `real_last=4.0` → `expected_until=
  none`と出る。しかし**`Fixnum`という個別クラスのドキュメントページ
  としては「2.4.0でFixnumクラス自体が統合されて消えた」ことを示す
  「2.4.0まで」バッジはむしろ正当**。**誤って`until`バッジを削除しない
  よう注意。**

**結論: until 側に本物のドキュメント/DBバグは0件**。今回の突き合わせで
修正対象になるのは since 側のみ。

### db-late(92件)

**意味**: `db_first > real_first`。実際にはもっと早くから存在した
メソッドなのに、本番バッジは実装よりも遅い版から存在するかのように
表示している(=バッジがドキュメント化の遅れをそのまま反映してしまう
自動計算の宿命的な弱点)。多くは `expected_since=none`(実測初出が
1.8.6/1.8.7で「本来バッジなしが正しい」)なのに、DBの初出版がそれより
ずっと後ろにずれているため、badge が「実は最初からあった機能」を
「最近追加された機能」のように見せてしまっているケース。

**クラス別件数**(35クラス、多い順):

| class | 件数 | class | 件数 | class | 件数 |
|---|---:|---|---:|---|---:|
| ObjectSpace::WeakMap | 12 | UnboundMethod | 2 | NilClass | 1 |
| BasicObject | 10 | Thread | 2 | NameError | 1 |
| Range | 6 | Symbol | 2 | Module | 1 |
| Data | 6 | Struct | 2 | KeyError | 1 |
| Array | 6 | Object | 2 | Float | 1 |
| Rational | 5 | Integer | 2 | Fixnum | 1 |
| Proc | 3 | Enumerator::Lazy | 2 | Fiber | 1 |
| Method | 3 | Complex | 2 | FalseClass | 1 |
| MatchData | 3 | Bignum | 2 | Exception | 1 |
| ENV | 3 | ARGF.class | 2 | Enumerator::Generator | 1 |
| main | 1 | TrueClass | 1 | Binding | 1 |
| String | 1 | Process::Waiter | 1 | | |

**代表例**(10件抜粋。列: real_first / db_first / 現since / 期待since):

| class#method | real_first | db_first | 現バッジ | 期待バッジ |
|---|---:|---:|---:|---:|
| `ObjectSpace::WeakMap#key?`ほか11メソッド | 2.1 | 3.0 | 3.0 | 2.1.0 |
| `Array#all?`/`none?`/`one?` | 1.8.6〜1.8.7 | 2.6.0 | 2.6.0 | none |
| `Array#max`/`min` | 1.8.6 | 2.4.0 | 2.4.0 | none |
| `Range#reverse_each` | 1.8.7 | 3.3 | 3.3 | none |
| `Range#to_a`/`entries` | 1.8.6 | 2.6.0 | 2.6.0 | none |
| `Thread#to_s` | 1.8.6 | 2.5.0 | 2.5.0 | none |
| `String#===` | 1.8.6 | 1.9.3 | 1.9.3 | none |
| `Struct#deconstruct`/`deconstruct_keys` | 2.7 | 3.0 | 3.0 | 2.7.0 |
| `Enumerator::Generator#each` | 1.9.1 | 3.0 | 3.0 | 1.9.1 |
| `Rational#positive?`/`negative?` | 2.3 | 2.4.0 | 2.4.0 | 2.3.0 |

**解釈上の注意が必要な2クラス**(件数の多さの割に単純な「ドキュメント化
遅延」と断定できない):

- **`BasicObject`(10件)**: `BasicObject`という**クラス自体**の実測初出は
  1.9.2(`classes.tsv`で確認)だが、compare.rbのreal側解決には
  「`BasicObject`のメソッドはObject/Kernel経由でも解決してよい」という
  special-case(`notes-compare.md` §3 tier5)があり、`BasicObject#==`
  等の`real_first`は1.8.6まで遡って算出される(「同じ振る舞いは
  Objectの一部として大昔から存在した」という意味論)。DB側バッジの
  「1.9.3から」は**`BasicObject`というクラスが実在する最初の版**という
  意味では正しい情報であり、どちらの見方を採用するかは解釈次第——
  機械的に`since`バッジを剥がすのは早計。
- **`Data`(6件)**: `real_first=1.8.6`と出ているが、これは**名前の
  衝突**による見かけ上の値。`classes.tsv`によれば`Data`というクラス名は
  1.8.6〜2.7で「C構造体ラッパー用の古い組み込みクラス」として存在し、
  3.0〜3.1でいったん消え、3.2で**現在の値オブジェクト`Data`**として
  再登場した(全くの別概念)。dumpスクリプトはクラス名だけで同一視する
  ため、古い`Data`のメソッド(`Object`から継承した`==`等)が
  `real_first=1.8.6`として現在の`Data.new`等に紐づいてしまっている。
  **実際には`Data.new`/`Data#==`等はRuby 3.2導入が正しく、DB側の
  `3.2`バッジはむしろ正しい**。この6件は`db-late`という分類名の
  誤検出であり、**修正不要**(compare.rbのreal解決側の既知の限界として
  記録)。

**推奨アクション**: `BasicObject`・`Data`を除いた実質80件が
トリアージ対象。特に`ObjectSpace::WeakMap`(1クラスで12件、いずれも
2.1.0が正しい初出)は1PRでまとめて`{: since="2.1.0"}`を追加できる
高効率な修正候補。過去の#3256(誤バッジ補正)と同種の作業。

### ladder-gap-1.9.1-1.9.3(since 273件 + until 2件)

**意味**: 本番DBのバージョンラダーには1.8.7の次が1.9.3という並びしかなく
(1.9.1/1.9.2に相当するDBが存在しない)、実測の初出/消滅が1.9.1または
1.9.2の場合、自動計算は原理的に1.9.3より早い値を出せない。

**実測first版の内訳**(since側273件):

```
$ awk -F'\t' 'NR>1 && $17=="MISMATCH_SINCE" && $18 ~ /ladder-gap-1\.9\.1-1\.9\.3/{print $8}' mismatches.tsv | sort | uniq -c
    273 1.9.1
```

**273件全てreal_first=1.9.1で、1.9.2発の該当は0件**(1.9.2発は
`expected_since`計算時点で自動的に`1.9.3`+`INFO_1_9_2`に繰り上げられ
一致するため、そもそもミスマッチにならない——`notes-compare.md`§6参照)。

**既存の対応実績**: 明示`since="1.9.1"`属性は既に13件存在する
(`notes-doctree-format.md`より)。これはまさにこのギャップを埋めるために
過去に手動追記された値であり、残り273件は未対応。

**推奨アクション**: 件数が多いため一括対応は要方針判断。選択肢:
(a) 273件全てに`{: since="1.9.1"}`を機械的に追加、(b) 利用頻度の高い
主要メソッドのみ選んで追加、(c) 対応しない(現状の「1.9.3から」表示を
実用上許容範囲とする)。実装するにしても本レポート対象外
(doctree変更はレポートの対象外・提案のみ)。

### real-autoload-gap:Set(52件)

**意味**: `Set`クラスはRuby 3.2で`require 'set'`不要の組み込みクラスに
なったが、実装はKernel#autoload経由(初回参照まで未ロード)。
`dump_methods.rb`はrequireを一切行わない設計上、autoload未解決の定数を
意図的にスキップするため、実測データ上`Set`は3.1〜3.4では「存在しない」
ように見え、db_first=3.2のみが観測される。

**確認**: 52件全て`class=Set`、`db_first`は全件`3.2`。

**アクション不要**: これは測定方法論のギャップであり、`db_first=3.2`
という現在のバッジ表示はむしろ「requireなしでSetが使える最初の版」という
実際のユーザー体験を正しく反映している可能性が高い。doctree/DB側の
修正は不要。

### real-build-gap:YJIT(4件、関連DOC_ONLY 6件)

**意味**: 実測に使用した`ghcr.io/ruby/all-ruby`のプリビルドバイナリは
3.2以降YJITが無効でビルドされている(3.1のビルドだけ有効)ため、
`RubyVM::YJIT`配下のメソッドが3.2以降の実測から丸ごと欠落する。

| class | kind | method | 状態 |
|---|---|---|---|
| RubyVM::YJIT | s | enabled?/stats_enabled?/reset_stats!/runtime_stats | MISMATCH_UNTIL(3.1でのみ観測、以降欠落) |
| RubyVM::YJIT | s | log_enabled?/enable/dump_exit_locations/stats_string/log/code_gc | DOC_ONLY(一度も観測されず) |

いずれも同一原因(測定環境のYJIT無効ビルド)による副作用であり、
手元の実行環境(mise Ruby 3.4.8)で`--yjit`有無に関わらず
`RubyVM::YJIT.singleton_methods(false)`に対象メソッドが載ることを
確認済み(実際のRuby本体では3.2以降も削除されていない)。

**アクション不要**: doctree/DBのバグではなく測定インフラの制約。

### DOC_ONLY(35件)

**意味**: doctreeに記載があるが、19版のいずれでも実測で一度も観測
されないエントリ(継承・alias-union・special-case解決を含めても
real側が全滅)。

**傾向**(4パターンに分類できる):

1. **暗黙変換/Marshalプロトコルの規約説明(11件)**:
   `Object#to_str`/`to_ary`/`to_hash`/`to_int`/`to_proc`/`to_io`/
   `to_regexp`(7件、`{: nomethod}`フラグ付き=doctree自身が「実メソッド
   ではなく規約」と明示済み)、`Object#_dump`/`marshal_dump`/
   `marshal_load`、`Class#_load`(Marshal連携規約、`_load`は本来
   `self._load`という特異メソッド規約なのに doctree は`kind=i`で
   記載——これも一種の規約説明)。**アクション不要**(doctree自身が
   「実装のない規約」として書いている箇所)。
2. **`{: undef}`による意図的サプレス(6件)**: `Complex`の比較演算子
   `<`/`>`/`<=`/`>=`/`between?`/`clamp`。`Comparable`(`Numeric`経由)を
   継承しているがComplexは明示的に`undef_method`しているため、
   `{: undef}`フラグが継承解決を正しく抑制した結果。**設計どおりの
   正常動作であり、doctree側もcompare.rb側も問題なし**。
3. **YJIT無効ビルド由来(6件)**: 上記「real-build-gap:YJIT」参照。
4. **メタプログラミングで動的生成される特異メソッド(4件)**:
   `Struct.[]`/`Struct.members`/`Struct.keyword_init?`/`Data.[]`/
   `Data.members`(重複含め該当5行)。これらは`Struct`/`Data`という
   基底クラス自身の特異メソッドではなく、`Struct.new(...)`/
   `Data.define(...)`で動的生成される**サブクラスごと**の特異メソッド。
   `dump_methods.rb`は`Object.constants`到達可能な名前付きクラスしか
   見ないため、動的生成サブクラスは観測されない。**測定方法論の限界で
   あり、doctree側のバグではない**。
5. **doctreeの記載セクション誤り(3件・実物確認済み)**:
   - `Thread#ignore_deadlock`/`ignore_deadlock=`(Thread.md:647/657):
     インスタンスメソッドのセクションに記載されているが、**本文の例自体が
     `Thread.ignore_deadlock = true` とクラスメソッド呼び出し**であり、
     実 Ruby にも特異メソッド `Thread.ignore_deadlock`(real_first=3.0、
     `matrix.tsv` の `Thread s ignore_deadlock` で確認)しか存在しない。
     パーサーの誤認識ではなく **doctree の記載位置バグ**(`## Class
     Methods` セクションへ移動すべき)。修正すると相互参照
     `[m:Thread#ignore_deadlock=]` の `#` も `.` に直す必要がある。
   - `Rational#convert`(Rational.md:489): `## Private Instance
     Methods` 配下に記載されているが、実体は **private な特異メソッド
     `Rational.convert`**(real_first=1.9.1、本文にも
     「`Kernel.#Rational` の本体です」とあり、CRuby の実装
     nurat_s_convert は特異側)。これも doctree の記載位置バグ。
   これらは `notes-doctree-format.md`§5 の `Thread::DEBUG`(セクション
   構造由来)とは異なり、**ドキュメント本文が最初から誤った種別で
   書かれているケース**。`Numeric#/`(抽象規約、サブクラスが個別実装する
   ため基底自体には存在しない——上記1と同種)も便宜上ここに含めた。

**全件リスト**:

```
Class            i  _load
Complex          i  <
Complex          i  >
Complex          i  <=
Complex          i  >=
Complex          i  between?
Complex          i  clamp
Data             s  []
Data             s  members
Numeric          i  /
Object           i  to_str
Object           i  to_ary
Object           i  to_hash
Object           i  to_int
Object           i  to_proc
Object           i  to_io
Object           i  to_regexp
Object           i  _dump
Object           i  marshal_dump
Object           i  marshal_load
Rational         i  convert
RubyVM::YJIT     s  log_enabled?
RubyVM::YJIT     s  enable
RubyVM::YJIT     s  dump_exit_locations
RubyVM::YJIT     s  stats_string
RubyVM::YJIT     s  log
RubyVM::YJIT     s  code_gc
Struct           s  []
Struct           s  members
Struct           s  keyword_init?
Thread           s  DEBUG
Thread           s  DEBUG=
Thread           i  ignore_deadlock
Thread           i  ignore_deadlock=
Warning          s  warn
```

**`Thread::DEBUG`/`DEBUG=`について補足**: これは`notes-doctree-format.md`
§5で既に指摘済みの既知バグそのもの——`Thread.md:232`の`### const DEBUG`
が、間に`## Constants`セクションへの遷移がないまま`## Class Methods`
セクション配下にあるため、パーサーが`kind=s`(特異メソッド)として
誤認識してしまう(本来は`kind=c`=定数として解釈されるべき)。real側には
当然`Thread.DEBUG`という特異メソッドは存在しないため`DOC_ONLY`になる。
**doctreeのドキュメント構造修正(該当箇所を`## Constants`セクション配下に
移動)が必要**——過去メモの「follow-up issue候補」として記録されていた
ものと一致する。

**`Warning.warn`について補足**: real側は`Warning#warn`(kind=i、
2.4〜4.0)としては存在するが、`Warning.warn`(kind=s)としては
`dump_methods.rb`の「`inherit=false`の自クラス定義メソッドのみ観測」
という設計(README参照)では観測できない。実際のRubyでは`Warning`
モジュールが自分自身を`extend`するパターンで`Warning.warn`を呼び出し
可能にしており、これは`singleton_methods(false)`では「自クラス定義」と
見なされない(mixin由来のため)。**doctreeの記載自体は実態と合っており、
これは測定方法論側の死角**(アクション不要)。

### INFO_1_8_7 / INFO_1_9_2 の意味

不一致ではなく**参考情報タグ**。`verdict`列にそのまま出る場合は
「バッジは正しく一致しているが、実測の初出版が観測範囲の下限(1.8.7)、
または DB ラダーの構造的ギャップの片割れ(1.9.2)に触れている」ことを
示すだけ。件数はそれぞれ72件・68件(`compare.err`参照)。

## 再現コマンド集

全て `ulimit -v 1048576;` を前置してから、このディレクトリ(doctree checkout の `tools/method-versions/`)で実行:

```sh
# verdict件数
awk -F'\t' 'NR>1{c[$17]++} END{for(k in c) print k"\t"c[k]}' mismatches.tsv | sort

# MISMATCH_SINCE の note内訳
awk -F'\t' 'NR>1 && $17=="MISMATCH_SINCE"{print $18}' mismatches.tsv | tr ';' '\n' | \
  grep -E '^(frozen-db-contamination|db-late|ladder-gap-1.9.1-1.9.3|explicit-wrong|real-autoload-gap:Set)$' | \
  sort | uniq -c | sort -rn

# MISMATCH_UNTIL の note内訳
awk -F'\t' 'NR>1 && $17=="MISMATCH_UNTIL"{print $18}' mismatches.tsv | tr ';' '\n' | \
  grep -E '^(until-mismatch|real-build-gap|ladder-gap-1.9.1-1.9.3)' | sort | uniq -c | sort -rn

# frozen-db-contamination 全件
awk -F'\t' 'NR>1 && $18 ~ /frozen-db-contamination/{print $1"\t"$2"\t"$3"\t"$8"\t"$11"\t"$13"\t"$15}' mismatches.tsv

# db-late クラス別件数
awk -F'\t' 'NR>1 && $18 ~ /(^|;)db-late(;|$)/{print $1}' mismatches.tsv | sort | uniq -c | sort -rn

# DOC_ONLY 全件
awk -F'\t' 'NR>1 && $17=="DOC_ONLY"{print $1"\t"$2"\t"$3}' mismatches.tsv

# ladder-gap(since) の real_first内訳
awk -F'\t' 'NR>1 && $17=="MISMATCH_SINCE" && $18 ~ /ladder-gap-1\.9\.1-1\.9\.3/{print $8}' mismatches.tsv | sort | uniq -c

# real-autoload-gap:Set の対象クラス確認
awk -F'\t' 'NR>1 && $18 ~ /real-autoload-gap:Set/{print $1}' mismatches.tsv | sort -u
```

## 検証メモ

本レポートの数字は全て上記コマンドで自分で再集計して確認したもので、
依頼文の事前集計とすべて一致した(件数・分類とも食い違いなし)。

**fable 査読(2026-07-23)での修正点**: ①until-mismatch 6件は当初
「ゲート漏れ疑い」としていたが、実物査読(functions.md の -p/-n 記述・
CRuby ruby.c の do_loop 分岐・Object.md:322 の `{: nomethod}`)により
**全件アクション不要**と結論を訂正 ②Ractor 4件の修正手段を
`{: since="3.4"}` から `#@since 3.4` ゲートに訂正(属性だけでは
3.0〜3.3 の版ページに実在しないメソッドの記載が残る) ③kind分類ミス
「疑い」3件は Thread.md/Rational.md の実物確認により doctree の記載
位置バグと確定。

集計過程で追加で見つけたデータの特性(依頼文にはなかった補足知見):

- `db-late`のうち`BasicObject`(10件)と`Data`(6件)は、他の80件とは
  性質が異なる「解釈注意」ケースであることが分かった(上記参照)。
  特に`Data`はRuby 3.0〜3.1に一時的に消えた**歴史的に無関係な同名
  クラス**(1.8系のCデータラッパー用`Data`)との衝突が原因で、
  `real_first=1.8.6`という値自体が今の`Data`クラスとは無関係な
  アーティファクトだった。
- `DOC_ONLY`35件のうち3件(`Thread#ignore_deadlock`/`ignore_deadlock=`・
  `Rational#convert`)は、`notes-doctree-format.md`で見つかっていた
  「kindはH2見出しの文脈依存で、キーワードだけでは決まらない」という
  パーサー仕様に起因する、doctree側の構造的なkind誤分類の可能性がある
  (実装は`s`=特異メソッドなのに`i`=インスタンスメソッドとして記載)。
  `Thread::DEBUG`/`DEBUG=`は`notes-doctree-format.md`§5で既知だった
  バグそのものであることを本レポートで確認した。
- `RubyVM::YJIT`関連は`MISMATCH_UNTIL`4件と`DOC_ONLY`6件、合計10件が
  全て同一原因(測定バイナリのYJIT無効ビルド)であることを横断確認した。

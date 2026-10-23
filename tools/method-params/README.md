# tools/method-params — メソッドの引数(シグネチャ)の実測データ(組み込み・標準添付・3.0〜4.1)

doctree の版別 DB に収録されている全メソッドエントリのシグネチャ(`### def` 見出し)の引数と、
実 Ruby の各版の引数情報(`Method#parameters`/`Method#arity` と、その版に同梱の rbs gem の
core・stdlib シグネチャ)を突き合わせた実測データ一式。rurema/doctree#3645 の作業用。

[tools/method-coverage](../method-coverage/README.md)(エントリの有無の過不足)の次の段階で、
「エントリはあるが引数が実 Ruby と合っていない」「版の途中で引数が変わったのに見出しが
`#%since`/`#%else` で分岐されていない」ものを機械的に洗い出す。
同時に、rurema/doctree#3589 の `check_params`(シグネチャの引数名と本文の `- **param**` 行の
名前の集合の一致)も同じシグネチャ解析で実行する。

対象は `_builtin`(組み込み)と、シグネチャ行を持つ標準添付ライブラリ(`tools/method-coverage` と
同じ require 前後差分の方式。下の「2b」)。段階 1・2 は組み込みと標準添付で別のファイルに出す。

## 対応する版

| DB の版 | 実 Ruby | rbs gem(同梱) |
|---------|---------|----------------|
| 3.0 | 3.0.0(`ghcr.io/ruby/all-ruby`・`/all-ruby/build/3.0.0/bin/ruby`) | 1.0.0 |
| 3.1 | 3.1.0(同上) | 2.0.0 |
| 3.2 | 3.2.0(同上) | 2.8.2 |
| 3.3 | 3.3.0(同上) | 3.4.0 |
| 3.4 | 3.4.0(同上) | 3.8.0 |
| 4.0 | 4.0.0(同上) | 3.10.0 |
| 4.1 | `ghcr.io/ruby/ruby:master`(4.1.0dev・`real/4.1/ruby-v.txt` 参照) | 4.2.0 |

組み込みと標準添付は別の時期に測ったので、4.1 の `ghcr.io/ruby/ruby:master` は同じイメージではない
(組み込みは `real/4.1/ruby-v.txt`、標準添付は `real/4.1/lib-ruby-v.txt`)。3.0〜4.0 は同じ all-ruby の x.y.0。

all-ruby は非 JIT ビルドなので `RubyVM::YJIT`/`RubyVM::ZJIT` は対象外(method-coverage の
「ビルド環境依存の差分」と同じ扱い)。teeny の途中で変わった引数は x.y.0 の実測では見えない。

## データソースと正規化

### 1. doctree 側(`db-extract/`)

版別 DB(`rake generate:X.Y` と同じ手順で生成)の全メソッドエントリ(typemark `#`・`.`・`.#`)を
走査し、エントリの `source` にある `### def ...` 行(bitclust の `MDParser::SIG_RE`)を
`--- ` 形式に落として `BitClust::MethodSignature.parse` で解析する。`params` 文字列は
深さ 0 のカンマで分割し、各項目を次に分類する。

| 書き方 | 分類 |
|--------|------|
| `name` | 必須の位置引数(req) |
| `name = default` | 省略可能な位置引数(opt) |
| `*name` / `*` | 可変長(rest) |
| `name:` | 必須キーワード(kwreq) |
| `name: default` | 省略可能キーワード(kwopt) |
| `**name` / `**` | キーワード可変長(kwrest) |
| `&name` | ブロック引数(block) |
| `...` | 引数の転送(rest+kwrest+block とみなす) |
| 上記以外 | `unusual`(そのまま記録して集計対象から外す) |

`MethodSignature#block`(`{ |x| ... }` 形式)があればブロックありとする。
エントリの引数名の集合は、そのエントリの全シグネチャ行の名前の和集合(`check_params` 用)。
本文側の名前は `- **param** `name`` / `- **arg** `name`` 行(bitclust の MDCompiler と同じ
`/\A- \*\*(param|arg)\*\*\s+`([^`]+)`/`)から取る。

### 2. 実 Ruby 側(`real/<版>/`)

`tools/method-coverage/tools/dump_all.rb` と同じ走査(Object から定数をたどって全モジュールを
列挙・require はしない・`--disable-gems`)で、各モジュールの特異メソッドとインスタンスメソッド
(public/protected/private)について `Method#arity` と `Method#parameters` と
`Method#source_location` を記録する。

- C 実装のメソッドは `parameters` が `[[:rest]]`(arity -1)か名前無しの `[[:req], [:req]]` に
  なるので、分かるのは必須引数の数と可変長かどうかだけ
- Ruby で定義されたメソッド(`<internal:...>` の prelude や `.rb`)は名前つきで取れる
- `Klass.new` は `Klass#initialize`(private)の引数で比較する。モジュール関数(`.#`)は
  特異メソッド側で比較する

### 2b. 実 Ruby 側・標準添付(`real/<版>/lib.tsv`)

`tools/measure_lib.sh` が 1 版ずつ docker を起動し、コンテナの中でライブラリごとに新しいプロセスで
`ruby --disable-gems dump_params.rb --lib LIB` を実行して、require 前後で新しく現れたか内容が変わった
メソッドを記録する(コンテナは `--memory=1500m`・`ulimit -c 0`・1 ライブラリ 120 秒で打ち切り)。

- 対象: `db-extract/sigs-<版>.tsv` の lib 列のうち `_builtin` と SKIP(`debug win32ole win32/registry
  win32/resolv`。method-coverage と同じ)以外、つまりシグネチャ行を持つライブラリ。加えて `a/b` の形の
  ライブラリの親 `a`(`rdoc`・`cgi`・`yaml` などシグネチャ行を持たない親も。比較で親の行も引くため)
- require に失敗したら gems 有効で再実行(bundled gem 用)、それでも失敗した `a/b` は `--pre a`
  (`a` を先に require してから前後差分を取る)で gems 無効・有効の順に再実行する。どの方法で取れたかは
  `real/<版>/lib-status.tsv` の mode 列(`nogems`/`gems`/`pre:a`/`gems+pre:a`/`failed`)
- gems 有効で測ったライブラリは、RubyGems が起動時に読み込む分(`Gem::` の多く・did_you_mean など)が
  require 前から存在するので差分に出ない。`--pre a` で測ったサブライブラリは、`a` が読み込む分が差分に出ない。
  どちらも比較では親のライブラリの行と `builtin.tsv` を順に引いて補う
- 未加工のダンプはライブラリごとのファイルで、ファイル名はライブラリ名の `/` を `__` にしたもの
  (`net/http` → `net__http.tsv`)
- 未加工のダンプは 1 版 40MB ほどあるので、`tools/filter_lib.rb` で doctree のいずれかの版のエントリに
  ある [クラス, 名前] の P 行だけに絞り、全ライブラリを 1 版 1 ファイルの `real/<版>/lib.tsv` にまとめる。
  各行の先頭はライブラリ名の列で、その後ろは `dump_params.rb` の出力と同じ(ライブラリ L の行には L と
  `L/` で始まるライブラリのエントリ分。`.new` のエントリは `initialize` も)。絞り込みに使うのは `db-extract/sigs-*.tsv`(全版)なので、
  全版の手順 1 を先に済ませる
- 絞り込んだ行には、それらのエントリのクラスのうち未加工のダンプに P 行が 1 つでもあったものを
  K 行で、定数のパスと `Module#name` が違うもの(`JSON::State` → `JSON::Ext::Generator::State` など)を
  A 行で残す(`dump_params.rb` は `--lib` のときだけ A 行を出す)

### 3. RBS 側(`rbs/`)

各版の同梱 rbs gem の `core/`(と `stdlib/`)を docker から取り出し、bitclust の
`RbsSigImporter`(手元の bundle の rbs で解析)で "Class#name"/"Class.name" ごとのオーバーロード
(引数名の並び・位置引数の [最小, 最大]・ブロックの req/opt)にする。
これは bitclust の `RbsOverloadMatcher` が rurema のシグネチャへ振り分けるときに使うのと
同じメタ情報。古い rbs の core を新しいパーサで読めない版があれば、その版の rbs 自身で
解析する補助スクリプトに切り替える(どちらで解析したかは `rbs/<版>.log` に残す)。

stdlib は `tools/extract_rbs_stdlib.rb` が `stdlib/<rbs のライブラリ名>/` ごとに 1 ファイルずつ構文解析し、
入れ子の class/module の名前をつないでキーにする(依存ライブラリと core は読み込まない。キーと
オーバーロードの作り方は `RbsSigImporter` と同じ)。読めないファイルは飛ばして `rbs/<版>-stdlib.log` に
残す(手元の rbs 4.1.3 では rbs 1.0.0〜2.8.2 の `benchmark`・`fileutils` の `void` が構文エラー)。

## 比較

### 段階 1: 版ごとの突き合わせ(`result/<版>/mismatch.tsv`)

エントリのシグネチャ行ごとに、実 Ruby と RBS に対して次を判定する。

- `arity`: 実 Ruby の arity と doc の [必須数, 最大数] の整合。arity が n >= 0 なら
  doc は必須 n 個ちょうど(opt/rest があれば `doc-allows-more`)。arity が -(n+1) なら
  doc の必須数は n で、opt か rest か kw が必要(無ければ `doc-no-optional`)
- `names`: 実 Ruby の `parameters` に名前があるものは、位置引数の名前と順序、
  キーワードの名前の集合を比較する
- `block`: 実 Ruby の `parameters` に `[:block, name]` があるのに doc にブロックが無い
  (逆方向は `yield` が `parameters` に出ないので判定しない)
- `rbs`: `RbsOverloadMatcher` と同じスコア(ブロック有無 → 引数名の一致 → アリティ範囲の
  重なり)で、どのオーバーロードにも対応しない doc の行(`rbs-unmatched-sig`)と、
  どの行にも対応しないオーバーロード(`rbs-unmatched-overload`)を出す

同じエントリに複数のシグネチャ行(別名や引数パターン)があるときは、いずれか 1 行が
実 Ruby と整合すればエントリとしては `ok` とする。

エントリ単位の判定の語彙(`summary.txt` と `mismatch-entries.tsv`):

- `ok`: いずれか 1 行が実 Ruby と整合する
- `ok-split`: 1 行では整合しないが、エントリの ok な行を合成したもの(必須数は最小、最大数は
  最大、rest/キーワードは和集合、ブロックはいずれか)が実 Ruby と整合する。`first` / `first(n)`
  のように引数パターンごとに行を分ける書き方の吸収。整合している扱い
- `forwarding?`: 実 Ruby が無名の転送(`*`・`**`・`&`)で定義されていて arity から何も言えない(弱い信号)
- `doc-no-optional?`: C の可変長なのに doc に任意引数が無い(弱い信号)
- `req-count` / `opt-count` / `rest` / `kw-mismatch` / `name-mismatch` / `block-missing` /
  `doc-allows-more`: 上記の比較で食い違ったもの
- `no-real` / `no-real:inherited` / `no-class`: 実測側に無い
- doc の位置引数がリテラル(`nil`・数値・引用符つき文字列)のときは必須の位置引数として数え、
  名前の比較には使わない

#### 標準添付(`compare_params.rb --stdlib` → `result/<版>/lib-*`)

判定の語彙と規則は組み込みと同じで、次が違う。

- ライブラリ L のエントリは `real/<版>/lib.tsv` の L の行 → 親 `a` の行(L が `a/b` のとき)→
  `real/<版>/builtin.tsv` の順に引く。クラスが K 行・P 行のどちらにも無く A 行にあれば `Module#name` で引き直す
- RBS は `rbs/<版>-stdlib.tsv` を先に引き、キーが複数の rbs ライブラリにあれば L の名前(`/` を `-` にした
  もの・先頭要素の `_` を `-` にしたもの・先頭要素)に一致する rbs ライブラリを優先する。stdlib に無いキーは
  core(`rbs/<版>.tsv`)を引く
- 実 Ruby の引数が rest・keyrest・block だけでブロックか無名の `**` を持つもの(`def_delegator`・
  `Gem::Deprecate` のラッパー・ruby2_keywords の `(*args, &block)` など)も `forwarding?`
- require に失敗したライブラリのエントリは `lib-require-failed`、SKIP で測っていないライブラリのエントリは
  `lib-not-measured`
- `lib-summary-by-lib.tsv` はライブラリごとの件数(mode 列は `lib-status.tsv` のもの)

### 段階 2: 版間の差分(`result/changes.tsv`・標準添付は `result/lib-changes.tsv`)

メソッドごとに版別の指紋(実 Ruby: arity+名前つき parameters、RBS: 正規化した
オーバーロード列)を並べ、隣り合う版の間で指紋が変わったものを列挙する。同じ 2 つの版で
doc のシグネチャ行の集合が変わっているか(`#%since`/`#%else` で分岐されているか)を付け、

- 実 Ruby か RBS が変わったのに doc が変わっていない → `unreflected`(本命の候補)。ただし変化後の
  段階 1 の判定が `ok`/`ok-split` なら `already-consistent`(C から Ruby 定義への移行で名前が見えただけ等)、
  `forwarding?` なら `forwarding`、仮引数名の差だけが残るなら `name-only`
- doc だけ変わった → `doc-only`(分岐の版が違う候補)
- C 実装の `parameters` が固定数と `[[:rest]]` の間で変わっただけで RBS が変わっていない →
  `c-decl-change`(API の変更ではないので低優先)

標準添付(`--stdlib`)はライブラリごとに、いずれかの版の doc にあるメソッドだけを対象にし、
両方の版でそのライブラリを測れたもの(`failed` でない)だけを比べる。出力は先頭に lib 列が付く。

### 段階 3: `check_params`(`result/<版>/check-params.tsv`)

本文に `- **param**`/`- **arg**` 行が 1 つ以上あるエントリについて、シグネチャ側の名前の
集合と本文側の名前の集合の差(片側にしか無い名前)を `ファイル:行` 付きで出す。
param 行が 1 つも無いのに引数があるエントリは件数だけ数える(#3589 の方針どおり)。

## ファイル構成

| パス | 内容 |
|------|------|
| `README.md` | このファイル |
| `report.md` | 分析本文(版ごとの件数・分類の内訳・本物の不一致の候補・限界) |
| `db-extract/sigs-<版>.tsv` | DB の全シグネチャ行(lib / class / typemark / names / 行番号 / 生の行 / 正規化した引数)。**コミットしない**(7 版で 14MB。版別 DB から再生成手順 1 で作る・`.gitignore` 済み) |
| `db-extract/params-<版>.tsv` | エントリごとのシグネチャ側と本文側の引数名の集合(同上・コミットしない) |
| `real/<版>/ruby-v.txt` | 実測した Ruby の `ruby -v` |
| `real/<版>/builtin.tsv` | 組み込みの全メソッドの arity・parameters・source_location |
| `real/<版>/lib.tsv` | 標準添付のライブラリごとの require 前後差分(doctree にエントリのあるメソッドに絞ったもの。先頭に lib 列、続いて V/X/A/K/P 行) |
| `real/<版>/lib-status.tsv` | ライブラリごとの測定方法(lib / mode / exit / 未加工の P 行の数) |
| `real/<版>/lib-ruby-v.txt` | 標準添付を測った Ruby の `ruby -v` |
| `rbs/<版>.tsv` | RBS core のオーバーロード(key / 添字 / 引数名 / アリティ / ブロック / 型の文字列) |
| `rbs/<版>.log` | 解析に使った rbs の版と、読めなかったファイル |
| `rbs/<版>-stdlib.tsv`・`rbs/<版>-stdlib.log` | RBS stdlib のオーバーロード(先頭に rbs のライブラリ名)と解析の記録 |
| `result/<版>/mismatch.tsv`・`mismatch-entries.tsv`・`entry-verdicts.tsv`・`summary.txt` | 段階 1 の判定と件数 |
| `result/<版>/lib-mismatch-entries.tsv`・`lib-entry-verdicts.tsv`・`lib-summary.txt`・`lib-summary-by-lib.tsv` | 段階 1(標準添付)。行単位の `lib-mismatch.tsv`(ok の行も含む・7 版で 7.5MB)は**コミットしない**(手順 10 で再生成・`.gitignore` 済み) |
| `result/changes.tsv` | 段階 2 の版間差分 |
| `result/lib-changes.tsv`・`lib-changes-summary.txt` | 段階 2(標準添付) |
| `result/<版>/check-params.tsv` | 段階 3 の名前の不一致 |
| `tools/` | 再生成スクリプト一式(下記) |

## 再生成手順

doctree ディレクトリで実行する(`BITCLUST_PATH=../bitclust`・`bundle exec`)。

1. `tools/extract_db_sigs.rb <dbpath> <outdir> <版>`: 版別 DB から `db-extract/` を作る
   (DB は `bitclust init` → `update --markdowntree=manual/api` で生成。`Rakefile` の
   `generate_database` と同じ)。`db-extract/` はコミットしていないので、4〜6 を動かす前に
   対象の版すべてでこの手順を実行する(1 版あたり DB 生成 30 秒ほど・抽出は数秒)
2. `tools/measure.sh`: docker(all-ruby と ruby:master)を 1 版ずつ順に起動し、
   `tools/dump_params.rb` で `real/<版>/` を作り、同梱 rbs gem の `core/`・`stdlib/` を
   作業ディレクトリへ取り出す
3. `tools/extract_rbs.rb <rbs-src dir> <outdir> <版>`: 取り出した core を解析して `rbs/<版>.tsv`・`rbs/<版>.log` にする
4. `tools/compare_params.rb <method-params dir> <版>`: 段階 1
5. `tools/check_params.rb <method-params dir> <版>`: 段階 3
6. `tools/diff_versions.rb <method-params dir> <版...>`: 段階 2

標準添付は 1 を全版で済ませたあと、次を続ける(作業ディレクトリ `$W` は docker から書ける場所。
未加工のダンプが 7 版で 270MB ほどになる)。

7. `tools/measure_lib.sh <tool dir の絶対パス> $W`: docker で `$W/lib-raw/<版>/`・`real/<版>/lib-status.tsv`・`real/<版>/lib-ruby-v.txt`・
   `$W/rbs-src/<版>/` を作る(7 版で 15 分ほど)。版を引数で絞れる
8. 各版で `ruby tools/filter_lib.rb <method-params dir> $W/lib-raw/<版> <版>`: `real/<版>/lib.tsv` を作る
9. 各版で `bundle exec ruby tools/extract_rbs_stdlib.rb $W/rbs-src/<版> <method-params dir>/rbs <版>`
10. 各版で `ruby tools/compare_params.rb <method-params dir> <版> --stdlib`
11. `ruby tools/diff_versions.rb <method-params dir> --stdlib <版...>`

## 既知の限界

- C 実装の引数名は実 Ruby からは取れない(RBS か rdoc の `call-seq` に頼る)。
  `rb_scan_args` の省略可能引数の数は arity からは分からない
- rurema 側の慣例(`-> ()` の返り値・`...`・引数パターンごとに見出しを分ける書き方・
  キーワード引数を `opts` で受ける旧い記述)は `unusual` か `rbs-unmatched` に出るので、
  本物の不一致と手で切り分ける
- RBS が実装より進んでいたり遅れていたりすることがある(RBS 側の不一致は RBS の版も併記して判断する)

標準添付に固有の限界:

- 実測側の名前で引くので、doc が別のモジュールに書いているメソッド(`mkmf` の `Kernel#...` は実際は
  `MakeMakefile`、`pp` の `Object#pretty_print` などは `PP::ObjectMixin`)は `no-real`/`no-class` になる。
  祖先はたどらない
- `define_method`・`method_missing`・`Struct.new` で作るメソッド(`Net::IMAP` の応答の構造体・
  `RSS::DublinCoreModel` など)や、オブジェクトの特異メソッド(`Readline::HISTORY`)は取れないか、
  取れても名前が無い
- require の副作用で既存メソッドを定義し直すライブラリは「内容が変わった」ものだけが差分に出る
- all-ruby に入っていない bundled gem・共有ライブラリ(3.0 の fiddle/dbm・rexml、3.1〜3.3 の dbm)は
  `failed`。どの版で何が測れなかったかは `real/<版>/lib-status.tsv`
- RBS stdlib は rbs gem 同梱の分だけ(bundled gem が自前で持つ `sig/` は読まない)

# tools/method-params — メソッドの引数(シグネチャ)の実測データ(組み込み・3.0〜4.1)

doctree の版別 DB に収録されている全メソッドエントリのシグネチャ(`### def` 見出し)の引数と、
実 Ruby の各版の引数情報(`Method#parameters`/`Method#arity` と、その版に同梱の rbs gem の
core シグネチャ)を突き合わせた実測データ一式。rurema/doctree#3645 の作業用。

[tools/method-coverage](../method-coverage/README.md)(エントリの有無の過不足)の次の段階で、
「エントリはあるが引数が実 Ruby と合っていない」「版の途中で引数が変わったのに見出しが
`#%since`/`#%else` で分岐されていない」ものを機械的に洗い出す。
同時に、rurema/doctree#3589 の `check_params`(シグネチャの引数名と本文の `- **param**` 行の
名前の集合の一致)も同じシグネチャ解析で実行する。

対象はまず `_builtin`(組み込み)のみ。標準添付ライブラリは `tools/method-coverage` と同じ
require 前後差分の方式で後から足せるように、スクリプトは `--lib LIB` を受け付ける形にしておく。

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
| `*name = default` / `name...` | 可変長(rest)。rurema の慣例的な表記 |
| `[a, *b]` | 必須の位置引数(req)。要素の名前を引数名として拾う |
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

### 3. RBS 側(`rbs/`)

各版の同梱 rbs gem の `core/`(と `stdlib/`)を docker から取り出し、bitclust の
`RbsSigImporter`(手元の bundle の rbs で解析)で "Class#name"/"Class.name" ごとのオーバーロード
(引数名の並び・位置引数の [最小, 最大]・ブロックの req/opt)にする。
これは bitclust の `RbsOverloadMatcher` が rurema のシグネチャへ振り分けるときに使うのと
同じメタ情報。古い rbs の core を新しいパーサで読めない版があれば、その版の rbs 自身で
解析する補助スクリプトに切り替える(どちらで解析したかは `rbs/<版>.log` に残す)。

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

### 段階 2: 版間の差分(`result/changes.tsv`)

メソッドごとに版別の指紋(実 Ruby: arity+名前つき parameters、RBS: 正規化した
オーバーロード列)を並べ、隣り合う版の間で指紋が変わったものを列挙する。同じ 2 つの版で
doc のシグネチャ行の集合が変わっているか(`#%since`/`#%else` で分岐されているか)を付け、

- 実 Ruby か RBS が変わったのに doc が変わっていない → `unreflected`(本命の候補)。ただし変化後の
  段階 1 の判定が `ok`/`ok-split` なら `already-consistent`(C から Ruby 定義への移行で名前が見えただけ等)、
  `forwarding?` なら `forwarding`、仮引数名の差だけが残るなら `name-only`
- doc だけ変わった → `doc-only`(分岐の版が違う候補)
- C 実装の `parameters` が固定数と `[[:rest]]` の間で変わっただけで RBS が変わっていない →
  `c-decl-change`(API の変更ではないので低優先)

### 段階 3: `check_params`(`result/<版>/check-params.tsv`)

本文に `- **param**`/`- **arg**` 行が 1 つ以上あるエントリについて、シグネチャ側の名前の
集合と本文側の名前の集合の差(片側にしか無い名前)を `ファイル:行` 付きで出す。
param 行が 1 つも無いのに引数があるエントリは件数だけ数える(#3589 の方針どおり)。
名前は先頭の `*`・`**`・`&` と末尾の `:` を除いて比べ、`self` と `...` は数えない。

## ファイル構成

| パス | 内容 |
|------|------|
| `README.md` | このファイル |
| `report.md` | 分析本文(版ごとの件数・分類の内訳・本物の不一致の候補・限界) |
| `db-extract/sigs-<版>.tsv` | DB の全シグネチャ行(lib / class / typemark / names / 行番号 / 生の行 / 正規化した引数)。**コミットしない**(7 版で 14MB。版別 DB から再生成手順 1 で作る・`.gitignore` 済み) |
| `db-extract/params-<版>.tsv` | エントリごとのシグネチャ側と本文側の引数名の集合(同上・コミットしない) |
| `real/<版>/ruby-v.txt` | 実測した Ruby の `ruby -v` |
| `real/<版>/builtin.tsv` | 組み込みの全メソッドの arity・parameters・source_location |
| `rbs/<版>.tsv` | RBS core のオーバーロード(key / 添字 / 引数名 / アリティ / ブロック / 型の文字列) |
| `rbs/<版>.log` | 解析に使った rbs の版と、読めなかったファイル |
| `result/<版>/mismatch.tsv`・`mismatch-entries.tsv`・`entry-verdicts.tsv`・`summary.txt` | 段階 1 の判定と件数 |
| `result/changes.tsv` | 段階 2 の版間差分 |
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

## 既知の限界

- C 実装の引数名は実 Ruby からは取れない(RBS か rdoc の `call-seq` に頼る)。
  `rb_scan_args` の省略可能引数の数は arity からは分からない
- rurema 側の慣例(`-> ()` の返り値・`...`・引数パターンごとに見出しを分ける書き方・
  キーワード引数を `opts` で受ける旧い記述)は `unusual` か `rbs-unmatched` に出るので、
  本物の不一致と手で切り分ける
- RBS が実装より進んでいたり遅れていたりすることがある(RBS 側の不一致は RBS の版も併記して判断する)

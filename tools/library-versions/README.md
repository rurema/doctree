# tools/library-versions — 標準添付ライブラリのバージョン存在実測データ

doctree の要 require ライブラリ(`_builtin` 以外)のドキュメントを、実 Ruby と
ruby/ruby・各 gem のソースツリーに突き合わせた実測データ一式。
ライブラリ単位(存在の有無・en rdoc との差)→ ファイル単位(require 可否)→
メソッド単位(全エントリの実在)の 3 段階で検証した。
組み込みメソッド版の [tools/method-versions](../method-versions/README.md) の姉妹編。

作成: 2026-08-28。分析の本文は [report.md](report.md)、
この検証で見つかった問題は doctree #3514〜#3531 の各 PR で対応済み
(**本データは修正前のスナップショット**)。

## データ生成時点(スナップショット情報)

- doctree 側(`rurema-libs.tsv`・`entries/`): master 4ee3411c2 時点
  (#3511 マージ直後・#3514 以降の修正前)
- 実測バイナリ: 3.0.7 / 3.1.7 / 3.2.11 = `ghcr.io/ruby/all-ruby` Docker、
  3.3.12 / 3.4.8 / 4.0.6 = mise インストール。4.1 はバイナリなし
  (ツリー判定のみ)
- ソースツリー(`github-trees/`・`ruby-stdlib/raw/`): ruby/ruby の
  v3_0_7 / v3_1_7 / v3_2_11 / v3_3_12 / v3_4_10 / v4.0.6 / master と、
  bundled gem 各リポジトリのピン版タグ。いずれも 2026-08-28 に
  api.github.com から取得
- ローカル環境の注意: 3.4.8 にはピン版より新しい gem
  (minitest 6.0.x・net-imap 0.6.2 等)が混入していた。この影響は
  境界確定時に x.y.0 タグで補正済み(後述の「既知の限界」参照)

## ファイル構成

| パス | 内容 |
|------|------|
| `report.md` | 分析本文(発見の全リストと分類) |
| `rurema-libs.tsv` | doctree の `type: library` 全 365 件(name/since/until/category) |
| `matrix-libs.tsv` | ライブラリ×7 版の在否マトリクス(ruby 側種別+rurema 収載) |
| `findings.md` | ライブラリ単位の突き合わせ結果(A: rurema 欠落/B: 撤去漏れ/C: en 差分) |
| `notes-doctree.md`・`gate-anomalies.txt`・`non-library-files.tsv` | doctree 側抽出の集計とメモ |
| `ruby-stdlib/` | 各版の標準添付一覧(`doc/standard_library.*`+`gems/bundled_gems` のパース結果と raw) |
| `local-rubies/` | 測定環境の default gem 実測リスト |
| `require-check/` | 各版の有効ページ名簿(`active-*.txt`)と require 可否分類(`req2-*.tsv`= ok/missing/loaderr/err) |
| `github-trees/` | ruby/ruby 7 ref の lib・ext 再帰ツリー、bundled gem ピン版ツリー、4.1 存在判定(`tree-4.1.tsv` 等) |
| `entries/` | 各版 DB から抽出した全メソッドエントリ(lib/class/typemark/name。約 8,000 名/版) |
| `probe/` | エントリ駆動プローブの結果(`probe2-*.tsv`= ok/no-method/no-class/lib-require-failed) |
| `mismatch-matrix.tsv` | 問題エントリ 709 件の版マトリクスと分類(new-only/old-only/always/platform) |
| `always-ng-triage.tsv`・`-notes.md` | 常時 NG 291 件の二次調査(改名先探索・要因分類) |
| `boundary-report.md` | 削除境界の x.y.0 確定調査(openssl・net-smtp・net-imap・strscan・rubygems ほか) |
| `tools/` | 再生成スクリプト一式(下記) |

## 再生成手順

doctree/bitclust が変わったら次の順で再生成できる(DB はスクラッチ領域に作ること):

1. `tools/extract_doctree_libs.py` 相当で `rurema-libs.tsv` を再抽出(front matter の type: library を走査)
2. `bundle exec bitclust --database=DB init/update --markdowntree=manual/api` で各版 DB を構築し、`tools/extract_entries.rb DB > entries/entries-<v>.tsv`
3. `tools/gen_active_lists.rb rurema-libs.tsv require-check/` → `tools/sweep2.sh <ruby> active-<v>.txt req2-<v>.tsv tools/req_classify.rb` で require 可否(3.0〜3.2 は all-ruby Docker: `/all-ruby/build/<ver>/bin/ruby`)
4. `tools/split_by_lib.rb entries-<v>.tsv split-<v>` → `tools/run_probe.sh <ruby> split-<v> tools/probe.rb probe2-<v>.tsv`
5. `tools/aggregate.rb <dir>` で `mismatch-matrix.tsv`、`tools/crosscheck.rb` でライブラリ単位マトリクス
6. ruby-stdlib 側は `tools/parse_stdlib_doc.rb`(gh api で `doc/standard_library.*`・`gems/bundled_gems` を取得してから)

`tools/triage_script.rb`・`triage_worker.rb`・`github-trees/tools/*.rb` は採取時の
一時ディレクトリの絶対パスを含むため、再実行時は冒頭のパス定義を書き換えること。

## 既知の限界(結果を読むときの注意)

- **teeny ドリフト**: 実測は各 minor の最新 teeny なので、x.y.0 と食い違うことがある
  (実例: strscan の旧別名は 3.4 系全 teeny で健在だが測定環境の後入れ gem で NG に
  見えた= 真の境界は 4.0.0/irb/cmd/* は 3.3.0 に存在するが 3.3.12 で消えている)。
  **版ゲートの境界を決めるときは必ず x.y.0 タグ・ピン版 gem ソースで確認する**
- **probe の no-class は偽陰性がある**: 定数解決に inherit=false を使ったため、
  ネスト定数や mixin(`append_features`)で include 先に生成されるクラスを見逃す
  (実例: rss のモデルモジュール群・Mutex_m)。no-class は
  `Object.const_get` フルパスで再確認してから使う
- **環境起因の NG が含まれる**: socket/etc のプラットフォーム定数・
  Etc::Passwd の BSD フィールド・all-ruby の readline(libedit)・
  bundled gems 不在(3.0〜3.2 の Docker)・yaml/dbm(dbm gem 不在)・
  システム OpenSSL 依存(Digest::MD2・Engine 等)
- `lookup --class` の instance_methods プロパティはエントリごとに 1 名しか出ない。
  収載判定は `bitclust lookup --method='Klass#name'`(module function は
  `Klass.#name`)の exit code で行う
- en rdoc との差(findings.md の C)は docs.ruby-lang.org の外形実測ではなく、
  ruby/actions の生成機構(`make html`+`.document`)からの導出

## 4.1 リリース後の追補

4.1 のリリースバイナリ入手後に、require スイープとプローブ(手順 3〜4)を
4.1 で実行して `req2-4.1.tsv`・`probe2-4.1.tsv` を追加し、
`tools/aggregate.rb` の VERSIONS に 4.1 を足して再集計する。
あわせて `github-trees/` の master 系データをリリースタグで取り直すとよい。

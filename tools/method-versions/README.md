# tools/method-versions — 組み込みメソッドのバージョン存在実測データ

doctree の組み込みクラス(`_builtin`)ドキュメントのメソッド単位 `{: since=}` / `{: until=}`
バッジを検証するための、実 Ruby 処理系からの実測データ一式。
(bitclust#132 のバッジ機能・doctree#3269 の凍結版混入問題のフォローアップ)

作成: 2026-07-23。実測は `ghcr.io/ruby/all-ruby` Docker イメージ使用。

## データ生成時点(スナップショット情報)

- 実測(`raw/`・`matrix.tsv`・`classes.tsv`・`aliases.tsv`): 2026-07-23 採取。
  doctree/DB の状態に依存しない安定データ
- `doctree-entries.tsv`: doctree 18152a7ef 時点の `manual/api/_builtin/*.md`
- `gd-db-presence.tsv` / `gd-db-classes.tsv` / `gd-db-names.tsv`:
  generated-documents `origin/main` = c6fac23de13 時点の `db/db-*`
- `mismatches.tsv` / `mismatch-report.md`: 上記スナップショットでの突き合わせ
  結果(バッジ計算仕様の参照実装は bitclust 04e561e 時点)
- doctree/gd 側が変わったら `tools/parse_doctree.rb` → `tools/extract_gd_names.rb`
  → `tools/compare.rb` の順で再生成できる(gd の再抽出はファイル構成の
  プリフェッチ注意を参照)

## 対象バージョン(19)

| doc 版 | 実測バイナリ |
|--------|--------------|
| 1.8.6  | ruby-1.8.6-p420 |
| 1.8.7  | ruby-1.8.7-p374 |
| 1.9.1  | ruby-1.9.1-p431 |
| 1.9.2  | ruby-1.9.2-p330 |
| 1.9.3  | ruby-1.9.3-p551 |
| 2.0.0  | ruby-2.0.0-p648 |
| 2.1〜2.7 | ruby-2.1.10 / 2.2.10 / 2.3.8 / 2.4.10 / 2.5.9 / 2.6.10 / 2.7.8 |
| 3.0〜3.4 | ruby-3.0.7 / 3.1.7 / 3.2.11 / 3.3.12 / 3.4.10 |
| 4.0    | ruby-4.0.6 |

- **4.1 は未実測**(リリースバイナリなし)。4.1 リリース後(または nightly 入手後)に
  `raw/4.1.tsv` を追加して `tools/build_matrix.rb` を再実行すれば追補できる。
- 1.8.6 はドキュメント対象外だが「1.8.7 で導入されたか、それ以前からあるか」の判別用。
- 1.9.1/1.9.2 は `since="1.9.1"` 等の明示バッジ値の検証用(指定 17 本+2 本)。

## 再現方法

```sh
# 1 バージョン分の実測(1.9.1+ は --disable-gems 付き、1.8.x はフラグなし)
docker run --rm -v $PWD/tools:/work:ro ghcr.io/ruby/all-ruby \
  /all-ruby/bin/ruby-3.4.10 --disable-gems /work/dump_methods.rb > raw/3.4.tsv
```

## ファイル構成

- `tools/dump_methods.rb` — 実測ダンパ(1.8.6〜4.x で無修正動作・require なし)
- `raw/<版>.tsv` — 実測結果(形式はダンパ冒頭コメント参照。V/P/A/M レコード)
- `matrix.tsv` — メソッド × バージョンの統合マトリクス(pub/priv/prot/`-`)+ first/last/gaps
- `classes.tsv` / `aliases.tsv` — クラス存在・定数エイリアス(Fixnum→Integer 等)の変遷
- `doctree-entries.tsv` — doctree `_builtin/*.md` の全エントリ+明示 since/until 属性
- `gd-db-presence.tsv` — 本番 docs.ruby-lang.org の各版 DB のエントリ存在
  (ファイルパス単位。初期抽出・参考用)
- `gd-db-names.tsv` — 各版 DB のメソッドファイルの中身の `names=` を実読した
  名前単位の存在(`tools/extract_gd_names.rb` で生成。本番のバッジ計算
  MethodSinceCalculator と同粒度 = compare.rb の DB 側入力。凍結版 DB の
  混入もそのまま映る)。**注意: gd リポジトリは blob:none パーシャル
  クローンなので、再生成時は必ず先にブロブを一括プリフェッチすること**
  (`git ls-tree -r` で OID 列挙 → `GIT_NO_LAZY_FETCH=1 git cat-file
  --batch-check` で欠落判定 → 欠落 OID を 2000 件ずつ `git fetch --no-tags
  --no-write-fetch-head origin <oids>`)。逐次 lazy fetch に任せると
  数万回のフェッチが走りメモリ/時間を食い潰す(2026-07-23 に OOM 実績)。
- `notes-*.md` — 各抽出の形式調査メモ
- `mismatch-report.md` / `mismatches.tsv` — 実測 vs doctree/本番 DB の不一致レポート

## 実測の設計と既知の注意点

- **観測対象**: `Object.constants` から再帰到達できる全モジュール/クラスの
  「自クラス定義メソッド」(inherit=false)を可視性(pub/priv/prot)付きで記録。
  require を一切せず gems も無効化しているので、観測されるのは組み込みのみ。
- **可視性は重要**: 例 `Module#prepend` は 2.0.0 で private として導入、2.1 で public 化。
  「メソッドが使えるようになった版」の判定には可視性の変化も見ること。
- **旧版の特異クラスリーク対策**: 1.9.1 以前は特異クラスへの `instance_methods(false)` が
  Class/Module 由来のメソッドを混入させる。1.8.7+ は `UnboundMethod#owner == 特異クラス`
  で厳密除去、1.8.6 のみ `singleton_methods(false)`+減算による近似
  (1.8.6 の protected 特異メソッドは pub 扱い・Class/Module 連鎖と同名の
  private 特異メソッドは拾えない可能性があるが、組み込みでは実例を確認していない)。
- **スクリプト自身の汚染ゼロ**: トップレベル def / 定数を使わず lambda+ローカル変数のみ。
- **正規名で記録**: 例 2.4〜3.1 の `Fixnum` は `P Fixnum Integer`(エイリアス)として
  記録され、メソッドは `Integer` 側に付く。旧版で Fixnum/Bignum に定義されていた
  メソッドを Integer のドキュメントと突き合わせる際は union を取ること。
- **doc とのマッピング注意**:
  - `Klass.new` のドキュメントは実装上は `Klass#initialize`(private インスタンス)。
    特異側に `new` が無くても initialize の導入版で判定する。
  - 継承メソッドをサブクラス側で文書化している場合(例 IO.read と File)、
    ancestors(A レコード)で親を辿って判定する。
  - 1.8 で stdlib だったもの(Rational/Complex/Enumerator 等)は 1.8 列が `-` になるが、
    これは「組み込みとしては存在しない」の意味(require すれば使えた)。
  - メソッドの「存在」はエントリの定義であり、引数追加などの機能拡張
    (シグネチャ単位の since)は検出できない。シグネチャ単位の明示属性の検証には
    別途各版での呼び出し実験が必要。

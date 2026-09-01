# ruby/ruby 標準添付ライブラリ一覧 データ収集メモ

収集日: 2026-08-28。取得元: GitHub API (`gh api`, api.github.com のみ)。

## 1. タグ対応表

各 minor の最新 teeny タグ(プレリリース `_preview*`/`_rc*` は除外)。

| minor  | タグ         | 備考 |
|--------|--------------|------|
| 3.0    | `v3_0_7`     | アンダースコア形式 |
| 3.1    | `v3_1_7`     | アンダースコア形式 |
| 3.2    | `v3_2_11`    | アンダースコア形式(`v3_2_9` の次が `v3_2_10`→`v3_2_11` で、辞書順ソートだと `v3_2_2` 等より前に来るので注意) |
| 3.3    | `v3_3_12`    | アンダースコア形式(同上、teeny 2 桁に注意) |
| 3.4    | `v3_4_10`    | アンダースコア形式 |
| 4.0    | `v4.0.6`     | **ドット形式**(`v4_0_6` ではない) |
| master | `master`     | ブランチ名そのもの |

**ハマった点**: 4.0 系からタグ命名規則が `vX_Y_Z`(アンダースコア)から `vX.Y.Z`(ドット)に変わっている。`repos/ruby/ruby/git/matching-refs/tags/v4_0` では 0 件で、`v4` で検索し直して発見した。`matching-refs` の結果は文字列ソートなので `v3_2_10`/`v3_2_11` が `v3_2_2`〜`v3_2_9` より前に出る(teeny 2 桁到達後の罠)。

## 2. 各版の kind 別件数

`<ver>.tsv`(列: name, kind, source)の集計。

| ver    | lib | ext | default-gem | bundled-gem | 合計 |
|--------|-----|-----|--------------|--------------|------|
| 3.0    | 3   | 6   | 75           | 8            | 92   |
| 3.1    | 3   | 6   | 66           | 15           | 90   |
| 3.2    | 3   | 6   | 68           | 15           | 92   |
| 3.3    | 3   | 6   | 67           | 16           | 92   |
| 3.4    | 3   | 6   | 54           | 29           | 92   |
| 4.0    | 3   | 6   | 44           | 39           | 92   |
| master | 4   | 6   | 42           | 39           | 91   |

- `lib`/`ext`(gem でないコア添付ライブラリ)はほぼ不変。唯一の変化は master で `Pathname` が(旧版では Default gems > Extensions 扱いだったのが)コアの `Libraries` セクションに移動し `lib` が 3→4 に増加。
- **3.4 で default-gem→bundled-gem への大規模な移動**(67→54, bundled 16→29)。新規に bundled 化: `abbrev, base64, bigdecimal, csv, drb, getoptlong, mutex_m, nkf, observer, resolv-replace, rinda, syslog` + 新規ライブラリ `repl_type_completor`(後述)。これは実際の Ruby 3.4 リリースでの「多数の default gems → bundled gems 降格」と一致する。
- **4.0 でさらに降格**(default 54→44, bundled 29→39): `benchmark, fiddle, logger, ostruct, pstore, readline, reline, win32ole` が bundled 化。加えて Tools(IRB, RDoc)の分類が Default gems → Bundled gems セクションへ移動(内容の kind 自体は default-gem→bundled-gem に変化、詳細は §3)。
- **master(4.1 開発版)でも継続**: `tsort` が bundled 化(default 44→42 の内の 1)。`net-ftp`/`net-pop` は bundled_gems ファイル・standard_library 双方から完全に削除(bundled → 消滅。廃止と見られる)。新規に `win32-registry` が bundled として追加。

## 3. standard_library ドキュメントのフォーマット差

- **拡張子・記法の分岐点は 3.3→3.4**: `doc/standard_library.rdoc`(RD 風記法、`= 見出し` / `== 見出し` / `Name:: 説明`)は 3.0〜3.3。`doc/standard_library.md`(Markdown、`# 見出し` / `## 見出し` / `- Name: 説明` or `- \`Name\`: 説明` or `- [name]: 説明`)は 3.4/4.0/master。両方存在しないバージョンはなかった(常にどちらか一方が存在)。
- 大セクション構成は全版で共通: `Ruby Standard Library`(先頭、無題、コア = lib/ext)→ `Default gems` → `Bundled gems`。サブセクションは `Libraries`/`Extensions`(+一部に `Tools`)。
- **`Tools` サブセクションの所属替え**: 3.4 では `Default gems > Tools`(IRB, RDoc)。4.0/master では `Bundled gems > Tools` に移動。IRB/RDoc 自体は元々 bundled_gems ファイルには載っていたが(3.4 の bundled_gems.txt にも `irb`/`repl_type_completor` は無いが、4.0/master の bundled_gems.txt には `irb`/`rdoc` が明記)、ドキュメント上の分類が版によって違う。
- 3.3 の rdoc には Bundled gems セクション冒頭に説明の箇条書き(`* bundled gems are...`)が追加されている(3.0〜3.2には無い)。3.4 以降の md でも同様の説明箇条書きが Default/Bundled 双方に付く。
- 表記ゆれ: rdoc 版は `resolv-replace.rb`, `tmpdir.rb`, `un.rb`, `Mutex_m` のようにファイル名や独特の大文字小文字を使う項目がある。md 版は原則ライブラリ表示名(`TmpDir`, `UN` 等)またはリンク参照名(小文字ハイフン区切りの実 gem 名)に統一されている。

## 4. bundled_gems ファイルとの不一致

`gems/bundled_gems`(実際にビルド時に取り込む gem 名の正)と standard_library ドキュメントの Bundled gems セクションを突き合わせ。

- **3.0, 3.2, 3.3**: 完全一致(ドキュメントに漏れなし)。
- **3.1**: `gems/bundled_gems` に `debug 1.6.3` があるが、`doc/standard_library.rdoc` の Bundled gems セクションには記載なし(Default gems にも無い =完全に未記載)。`<ver>.tsv` では `debug / bundled-gem / bundled_gems-file` として追加行を起こした。3.2 の rdoc で `DEBUGGER__::` が Bundled gems に追記され解消。
- **3.4, 4.0, master**: いずれも `gems/bundled_gems` に `repl_type_completor` があるが、standard_library ドキュメントには一切記載がない(IRB の補完ライブラリで、エンドユーザー向け require 対象として案内する性質のものではないため意図的に省いていると推測される)。3 版とも `repl_type_completor / bundled-gem / bundled_gems-file` を追加行にした。
- 逆方向(standard_library の bundled セクションにあって bundled_gems ファイルに無い)は **全版で 0 件**(ドキュメントが bundled_gems ファイルのスーパーセットになることはなかった)。
- 名寄せの注意: rdoc 版(3.0〜3.3)は表示名が `MiniTest`, `PowerAssert`, `Test::Unit`, `REXML`, `RSS`, `RBS`, `TypeProf`, `Net::FTP` 等の CamelCase/モジュール名で、実 gem 名(`minitest`, `power_assert`, `test-unit`, `rexml`, `rss`, `rbs`, `typeprof`, `net-ftp` 等)と機械的に一致しないため、手動のエイリアス表(`parse.rb` 内 `RDOC_BUNDLED_ALIAS`)を使って突き合わせた。md 版(3.4 以降)は表示名がほぼ実 gem 名そのもの(小文字ハイフン)なので直接比較で足りるが、`IRB`/`RDoc`(Tools)だけは表示が大文字始まりで実 gem 名 `irb`/`rdoc` と大文字小文字が異なる(大小無視で一致とみなした)。

## 5. スポット確認(bundled gem のソースがツリーに存在しないこと)

`lib-toplevel.tsv` / `ext-toplevel.tsv`(トップレベルのみ、追加 API 呼び出しなしで確認可能)で判定。各版 2 例、あわせて「bundled 化される直前の版ではソースが存在する」対比も確認。

| 版 | 確認内容 | 結果 |
|----|----------|------|
| 3.0 | `lib/rexml` | 不在(確認) |
| 3.0 | `lib/rake` | 不在(確認) |
| 3.1 | `lib/matrix` | 不在(確認。3.0 では `matrix.rb`+`matrix/` が存在=bundled 化の境目) |
| 3.1 | `lib/debug` | 不在(確認。3.0 では `debug.rb`+`debug.gemspec` が存在) |
| 3.2 | `lib/rss` | 不在(確認) |
| 3.2 | `lib/rbs` | 不在(確認) |
| 3.3 | `lib/racc`, `ext/racc` | 両方不在(確認。3.2 では `lib/racc.rb`+`lib/racc/` が存在=bundled 化の境目) |
| 3.4 | `lib/csv` | 不在(確認。3.3 では `csv.rb`+`csv/` が存在=bundled 化の境目) |
| 3.4 | `lib/abbrev` | 不在(確認。3.3 では `abbrev.rb`+`abbrev.gemspec` が存在) |
| 4.0 | `ext/fiddle` | 不在(確認。3.4 では `ext/fiddle/` が存在=bundled 化の境目) |
| 4.0 | `lib/reline` | 不在(確認。3.4 では `lib/reline.rb`+`lib/reline/` が存在) |
| master | `lib/tsort` | 不在(確認。4.0 では `lib/tsort.rb`+`lib/tsort.gemspec` が存在=bundled 化の境目) |
| master | `lib/csv`(依頼元の例示) | 不在(確認、3.4 以降ずっと不在) |

全 14 件とも「bundled gem 化された版以降、ソースがツリーから消える」という期待どおりの結果。default-gem のソースは(gem 化されていても)`lib/`・`ext/` にベンダリングされており `.gemspec` ファイルが並存するのに対し、bundled gem は `gems/bundled_gems` に gem 名・バージョン・リポジトリ URL が載るのみでツリー本体には一切現れない、という構造上の違いをそのまま裏付けている。

## 6. その他の実測上の発見(要求外だが記録)

- **DBM, GDBM, Tracer は 3.0→3.1 で完全に消滅**: 3.0 の `standard_library.rdoc`(Default gems)には載っているが、3.1 以降はドキュメント記載も `ext/`(dbm, gdbm)・`lib/`(tracer)のソースも一切無い。default-gem→bundled-gem の「降格」ではなく標準添付からの完全撤去。これは doctree 側の記録(dbm/gdbm ページに `until: "3.1"` を付与した過去の対応 = #3509/#3510/#3511)と整合する実測結果。
- `Net::FTP`/`Net::POP3`(`net-ftp`/`net-pop`)は 4.0 まで bundled gem として存続するが、master(4.1 開発版)では `gems/bundled_gems` からもドキュメントからも削除済み(廃止)。`lib/net` ディレクトリ自体は残存(net-http 等が同居するため)。

## 7. ファイル構成

```
raw/<ver>-standard_library.(rdoc|md)   # 生データ(存在する方のみ)
raw/<ver>-bundled_gems.txt             # gems/bundled_gems 生データ
raw/<ver>-lib-toplevel.tsv             # lib/ トップレベル一覧(name\ttype)
raw/<ver>-ext-toplevel.tsv             # ext/ トップレベル一覧(name\ttype)
<ver>.tsv                              # パース済み(name, kind, source)
parse.rb                               # パーススクリプト(rdoc/md 両対応、bundled_gems 突合せ込み)
notes-ruby-stdlib.md                   # 本ファイル
```

`ver` は `3.0, 3.1, 3.2, 3.3, 3.4, 4.0, master` の 7 種。

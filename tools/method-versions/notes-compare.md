# notes-compare.md — `tools/compare.rb` ロジック解説

作成: 2026-07-23。`tools/compare.rb`(約600行)のヘッダコメントが参照する
「ロジックの詳細・エッジケースの判断根拠」用のノート。出力は
`mismatches.tsv`(ヘッダ込み2164行 = 2163エントリ)、集計サマリは
`compare.err`(標準エラー出力)。

## 0. 目的

3つの独立データセット——①実 Ruby 処理系19版の実測(`matrix.tsv` 等)、
②doctree `_builtin/*.md` の明示 `{: since=}`/`{: until=}` 属性
(`doctree-entries.tsv`)、③本番 docs.ruby-lang.org 各版 DB のエントリ存在
(`gd-db-names.tsv`)——を突き合わせ、doctree の集約エントリ1件ごとに
「本番が実際に表示しているバッジ」と「実測から導かれる期待バッジ」を
比較する。目的は本番バッジの誤り・doctree の未整備箇所の発見であり、
compare.rb 自体は doctree/bitclust/本番のいずれも変更しない(読み取り
専用の突き合わせツール)。

## 1. 入力データセットと読み込み(compare.rb §1-6)

| ファイル | 内容 | 読み込み先 |
|---|---|---|
| `matrix.tsv` | (class,kind,method) × 19実測版の可視性(pub/priv/prot/`-`) | `REAL[[cls,kind,meth]] = Set(存在する版)` |
| `raw/<version>.tsv` の `A` 行 | 各版のクラス継承情報(type/superclass/ancestors) | `ANCESTORS[version][class]` |
| `aliases.tsv` | 定数リネームの同一実体グループ(Fixnum→Integer 等) | `ALIAS_ADJ` 無向グラフ→`alias_group()` |
| `gd-db-names.tsv` | 本番各版 DB のメソッドファイルの `names=` 実データ(名前単位) | `DB[[cls,typechar,meth]] = Set(存在するDB版)` |
| `doctree-entries.tsv` | doctree 全シグネチャ行(3160行) | `groups[[cls,kind,meth]] = [DocRow,...]` |
| `doctree/manual/api/_builtin/*.md` | ソース再スキャンで `{: undef}`/`{: nomethod}` フラグ抽出 | `FLAGGED[[file,lineno]]` |

実測版ラベル(`REAL_VERSIONS`、19: 1.8.6〜4.0)と DB 版ラベル
(`DB_VERSIONS`、17: 1.8.7〜4.1)は表記が異なる版がある(2.x は teeny `.0`
省略 vs DB は `.0` 付き、1.9.x/2.0.0はどちらも同じ表記)。`doc_label()` が
実測ラベル→doc/DB表示ラベルの変換を行う(`feedback_version_format.md`
準拠: 3.0以上は teeny `.0` を省略)。

## 2. doctree 3160行 → kind s|i|o の2163集約エントリへの集約規則

`doctree-entries.tsv` は「1シグネチャ行(`### def`/`### module_function
def`/`### const`/`### gvar`)= 1行」の生データ。内訳(`compare.err` 1行目):
`i`=2042, `s`=476, `c`=336, `o`=250, `v`=56 (合計3160)。

比較対象は kind `c`(定数)・`v`(特殊変数)を**除外**した kind `s`/`i`/`o`
の2768行。これを `[class_name, kind, method_name]` の組でグループ化すると
**2163グループ**になる(`compare.err` 2行目: "2163 (from 2768 raw
signature rows)")。差分605行はオーバーロード(同名メソッドの複数シグネチャ
行、例: 引数パターン違いの多重定義)。集約時のグループ内行数は `note` 列に
`overloads:N`(N≥2、404件、最大14=1グループに14シグネチャ行)として記録
される。

### 属性の集約

各グループ内の行がそれぞれ独立した `since_attr`/`until_attr` を持ちうる
(doctree-entries.tsv の値は物理的な見出し出現ごとの値であり、bitclust の
実行時の「名前単位」集約とは異なる——詳細は `notes-doctree-format.md` §2
「Design note」参照)。compare.rb の集約規則(§9 メインループ冒頭):

```ruby
since_values = rows.map(&:since_attr).reject { |v| v == '-' }.uniq
since_attr_agg = since_values.empty? ? '-' : since_values.first
since_conflict = since_values.size > 1
```

- `-`(属性なし)を除いた非空値の**最初の値**を代表値として採用。
- 複数の異なる非空値がある場合は `since-conflict:val1|val2` を note に
  記録するが、代表値としては引き続き最初の値を使う。
- 実データでは `since-conflict`/`until-conflict` は**0件**(全同名
  シグネチャ群は属性ありなら全シグネチャに同じ値、を裏付け——
  `notes-doctree-format.md` §2 の「every same-named signature group that
  has any attribute has one on every occurrence」と整合)。
- `until_attr` は現状コーパス全体で `until=` 属性が0件のため常に `-`。

### `{: undef}`/`{: nomethod}` フラグ

`doctree-entries.tsv` には反映されない属性なので、compare.rb は
`_builtin/*.md` を独立に再スキャンして `FLAGGED[[file, 見出し行番号]]` を
構築する(§6)。グループ内の全行から `flags = rows.flat_map { FLAGGED[...] }.uniq`
で集約し、`undef` を含む場合のみ後述の「継承抑制」が働く。`nomethod` は
バッジ計算・real 側解決のいずれにも影響しない(注釈的なフラグ)。
コーパス全体で109属性行 = 95個の `since=`トークン(EMPTY 75+`1.9.1` 13+
`1.9.3` 7)+ `undef` 6(全て `Complex.md`)+ `nomethod` 8(全て
`Object.md`)。

## 3. real 側解決のtier構造(`resolve_real_version`, compare.rb §7)

doc の `(class, kind, method)` に対し、実測19版それぞれで以下を優先順位
順に判定する。`kind='o'`(module_function)は `kinds = %w[s i]` の両方を
試す(module_function は実装上 singleton にも instance にも見えうるため)。

1. **tier1 direct**: `alias_group(doc_class)` に属するいずれかのクラス名で
   直接 `REAL[[c,k,meth]]` に版が載っていれば即座に真(`via: 'direct'`)。
2. **tier2 alias-union**: tier1 と同じ判定だが group サイズ>1(実際には
   同じコード経路。`alias_group` が単一要素なら 'direct'、複数要素なら
   `'alias-union:他の構成員'` を via に記録)。例: `Fixnum`→`Integer`
   (`aliases.tsv` で無向グラフ結合済み)。旧版で Fixnum/Bignum に定義され
   実装は現在 Integer 側に付いている、というケースをカバーする。
3. **tier3 new→initialize**: `kind='s' && method='new'` のときのみ、
   group内いずれかのクラスに `i initialize` があれば真
   (`via: 'new-via-initialize'`)。`Klass.new` は実装上
   `Klass#initialize`(private instance)であるため。
4. **tier4 inherited**(`suppress_inherited` が偽の場合のみ):
   - `kind='s'` → `superclass_chain(doc_class, version)`(A行の
     superclass を自分自身を除いて遡る連鎖)
   - `kind='i'`/`'o'` → `instance_ancestors(doc_class, version)`
     (A行の ancestors リスト、自分自身除く、MRO順)
   - 連鎖を順に見て最初に見つかった祖先で真、`via: "inherited:祖先名"`。
   - **tier3+4 combined**(`new→initialize` を祖先連鎖にも適用):
     `Object.new` は `Object` 自身が1.9.2以降 `#initialize` を
     `BasicObject` に譲っている(matrix.tsv 上 `Object i initialize` は
     1.8.6/1.8.7のみ、`BasicObject i initialize` が1.9.2以降)ため、
     tier3単体では 1.9.1以降 `Object.new` が「消えた」と誤判定してしまう。
     これを避けるため、`instance_ancestors` を辿って `i initialize` を
     持つ祖先を探す専用ロジックがある(`via:
     "inherited-new-via-initialize:祖先名"`)。
5. **tier5 special cases**(`suppress_inherited` に関わらず常に試行):
   - `ARGF.class`: `real_exists?('ARGF', 's', method, version)` を見る
     (`ARGF.class` は `ARGF` オブジェクトの特異クラスの意味的表現)。
   - `BasicObject`: `Object`→`Kernel` の順に `i` メソッドとして存在するか
     を見る。**注意**: これは `BasicObject` というクラス自体が実際に
     存在する前の版(1.8.6〜1.9.1、`classes.tsv` によれば `BasicObject`
     クラス自体の実測初出は1.9.2)にも `real_first` を遡らせる設計上の
     選択であり、「その動作は Object の一部として1.8.6から存在した」と
     いう意味論的な主張である。これが db 側の「BasicObject クラス自体は
     1.9.3から」という時系列と食い違い、`db-late` ミスマッチ(10件)を
     生む一因になっている——詳細は mismatch-report.md 参照。
   - `ENV`/`main`: A行の superclass フィールド(`ENV`/`main` は実装上
     無名クラスのインスタンスとして表現される)+ その祖先連鎖を辿って
     `i` メソッドを探す(`special:ENV.class(祖先)`)。
   - `Errno::EXXX`: `kind='s' && method='new'` のときのみ、
     `SystemCallError` とその祖先連鎖で `i initialize` を探す
     (全 `Errno::EXXX` サブクラスの代表としての解決)。

`resolve_real` はこれを19版全てに適用し、真になった版の最初/最後を
`real_first`/`real_last` として返す(1つも真にならなければ `'-'`
= real側「未観測」)。`via` が最初と最後の版で異なる場合は note に
`last-resolved-via:...` を付与する(133件——長命なメソッドが解決経路を
跨ぐケース、例: 若い版は direct、後の版で continued alias-union 等)。

### `{: undef}` フラグによる継承抑制

グループの `flags` に `undef` が含まれる場合、`suppress_inherited=true`
となり **tier4(継承)がまるごとスキップ**される(tier1-3, tier5は生きた
まま)。これは「継承元にはメソッドがあっても `undef_method` で意図的に
塞がれている」ケースの表現——実データでの唯一の適用例は `Complex.md` の
比較演算子6件(`<`,`>`,`<=`,`>=`,`between?`,`clamp`)で、いずれも
`Comparable`(`Numeric` 経由で継承)にメソッド自体は存在するが、`Complex`
は明示的に `undef_method` しているため、tier4を素通しすると誤って
「real側に存在する」と判定してしまう。`{: undef}` フラグはこの誤判定を
正しく防いでおり、結果は `DOC_ONLY` 検証(real側`-`)として現れる
(mismatch-report.md 参照)。

同じ `undef` フラグは `forced_none_badges` としてバッジ計算側にも渡り
(§5)、`current_since_badge`/`current_until_badge` を強制的に `'none'`
にする。

## 4. db 側解決(`resolve_db`, compare.rb §7後半)

```ruby
def resolve_db(doc_class, kind, method)
  group = alias_group(doc_class)
  primary_typechar = kind == 'o' ? 'm' : kind
  found = DB_VERSIONS.select { |v| group.any? { |c| db_exists?(c, primary_typechar, method, v) } }
  if found.empty? && kind == 'o'
    # 'm' で1件も見つからなければ s/i 合算にフォールバック(未使用: 実データ0件)
  end
  ...
end
```

- **alias-union**: real側と同じく `alias_group` で定数リネームを合算する
  (DB側にも旧クラス名で登録された版が残っているケースをカバー)。
- **typechar**: kind `s`/`i` はそのまま、kind `o`(module_function)は
  DB上の typechar `m` に対応する(bitclust 内部の5typechar体系
  `i/s/m/c/v` のうち `m` が `module_function`——`notes-gd-db.md` §4
  参照)。`m` で1件も見つからない場合のみ `s`/`i` 合算にフォールバックし
  `db-typechar-fallback:s/i` を note に残す設計だが、**実データでは
  この分岐は0件**(全 `kind=o` エントリが `m` typechar で解決済み)。
- **DB は名前単位**: `gd-db-names.tsv` は各版 DB のメソッドファイルの
  中身(`names=` プロパティ、1ファイルに複数別名が同居しうる)を実際に
  読んで名前ごとに展開したデータなので、`db_exists?` は本番の
  `MethodSinceCalculator`(`bitclust/lib/bitclust/method_since_calculator.rb`)
  と完全に同じ粒度で引ける。歴史的経緯は§8参照。

`resolve_db` は19版でなく **17版(DB_VERSIONS)** で判定する点に注意
(実測版と DB 版はラダーの刻み方自体が違う——特に1.9.1/1.9.2に相当する
DB版が存在しない。これがバッジ計算・expected計算双方に効いてくる、
§5-6参照)。

## 5. バッジ計算(本番相当、compare.rb §8前半)

本番 `bitclust/lib/bitclust/version_badges.rb` /
`method_since_calculator.rb` のロジックを再実装したもの(実装詳細の
出典は `notes-doctree-format.md` §7 参照)。

```ruby
def current_since_badge(since_attr, db_first, forced_none)
  return 'none' if forced_none                          # {: undef}
  return 'none' if since_attr == 'EMPTY'                 # {: since=""} 明示抑制
  return since_attr unless since_attr == '-'             # 明示 since="X" が最優先
  return 'none' if db_first == '-' || db_first == DB_VERSIONS.first  # DB未検出/ラダー最古=バッジ不要
  db_first                                                # 自動計算値
end
```

- **優先順位**(`notes-doctree-format.md` §7(2)の再掲): 明示
  `since="X"` > 明示 `since=""`(EMPTY、恒久的にバッジ非表示・自動計算も
  ブロック) > 自動計算(`MethodSinceCalculator` 相当 = `db_first`) >
  何もなし。
- **EMPTY 属性**: `since=""` は「著者が意図的にバッジ非表示にした」印。
  75件がこれに該当(全109属性行のうち)。
- **ラダー端の none 化**: `db_first` が DB_VERSIONS の**先頭
  (`1.8.7`)** と一致する場合もバッジは `'none'`。理由: 「観測開始版に
  すでに存在した」場合、それより古い時点で存在したかどうかを自動計算は
  区別できない(本番の `MethodSinceCalculator#since_for` の「floor」
  ケースと同じ、`notes-doctree-format.md` §7(3)末尾)。
- **`db_last` の次版が until 表示になる点**: `current_until_badge` は
  「削除された版」を表示する仕様(`until="X"` = 「X で削除」であって
  「Xまで存在」ではない、`notes-doctree-format.md` §7(3)参照)。DB上の
  最終観測版の**次のラダー版**を計算する:

```ruby
def current_until_badge(until_attr, db_last, forced_none)
  return 'none' if forced_none
  return until_attr unless until_attr == '-'
  return 'none' if db_last == '-' || db_last == DB_VERSIONS.last   # ラダー最新=削除未検出
  next_in(DB_VERSIONS, db_last)                                     # 消えた最初の版
end
```

コーパスに `until=` 明示属性が0件のため、実データでは常に自動計算経路
(`db_last` ベース)を通る。

## 6. expected 計算(real側から導く「あるべき」バッジ、compare.rb §8後半)

```ruby
def expected_since(real_first)
  return ['-', nil] if real_first == '-'
  return ['none', nil] if %w[1.8.6 1.8.7].include?(real_first)
  return ['1.9.3', 'INFO_1_9_2'] if real_first == '1.9.2'
  [doc_label(real_first), nil]
end
```

- **1.8.6/1.8.7 → none**: これらは実測範囲の最古2版であり、DB ラダーの
  先頭(`1.8.7`)と同じ「floor」扱い——「本当に大昔から存在した」ことしか
  分からず、バッジを出すべきではない。1.8.6は「1.8.7から存在するのか
  それ以前か」を判別するためだけの補助版(README参照)。
- **1.9.2 → 1.9.3 + INFO_1_9_2**: DB ラダーには1.9.1/1.9.2に相当する版が
  ない(`db-1.8.7` の次は `db-1.9.3`)。実測 `real_first=1.9.2` の場合、
  自動計算が絶対に出せる最善値は `1.9.3` であるため、期待値自体を
  `1.9.3` に繰り上げ、`INFO_1_9_2` という情報タグを添える(「不一致では
  なく、構造的な理由でこれが到達可能な最良値」という宣言)。
- **`doc_label(real_first)`**: それ以外は実測ラベルを doc 表示形式に
  変換して返す(teeny `.0` 規則の適用)。

`expected_until` は対称的なロジック(`real_last='4.0'` → `'none'`
[4.1は未実測なので「もう消えていない」と断言できない=バッジなし]、
`next_in(REAL_VERSIONS, real_last)` が `'1.9.2'` になる場合は同様に
`'1.9.3'` + `INFO_1_9_2` へ繰り上げ)。

## 7. verdict と note の用語集

### verdict(必ず単一値、複合は無し——実データで確認済み)

| verdict | 意味 | 件数 |
|---|---:|---:|
| `OK` | 期待値と現在バッジが一致(情報タグなし) | 1544 |
| `INFO_1_8_7` | 一致だが `real_first=1.8.7`(観測範囲の下限に接触、参考情報) | 72 |
| `INFO_1_9_2` | 一致だが `real_first=1.9.2` かつ expected繰り上げ後1.9.3で一致(§6参照) | 68 |
| `MISMATCH_SINCE` | since側のバッジ不一致 | 432 |
| `MISMATCH_UNTIL` | until側のバッジ不一致 | 12 |
| `DOC_ONLY` | `real_first='-'`(実測で一度も観測されない。since/until判定は行わない) | 35 |

DOC_ONLY 以外は since と until を独立に判定し、両方一致なら
`OK`/`INFO_*`、いずれかが不一致ならその `MISMATCH_*` になる
(実データでは since と until が同時に不一致になる行は無い=
`MISMATCH_SINCE` と `MISMATCH_UNTIL` が同時に付くケースは0件)。
`INFO_1_8_7`/`INFO_1_9_2` は verdict としてだけでなく、他の
`MISMATCH_*` verdict の**note欄**にも(情報タグとして)付くことがある
(`INFO_1_8_7` は note として6件、`INFO_1_9_2` は note として2件——
つまり「real_first=1.8.7/1.9.2」であることと「ミスマッチが起きている
かどうか」は独立)。

### note タグ(`;` 区切り、複数付与されうる。compare.rb §9)

MISMATCH_SINCE の原因分類(相互排他、`since_attr_agg`/`db[:first]`/
`real[:first]`/`cls` を見て順に判定):

| note | 意味 | 件数 |
|---|---:|---|
| `explicit-empty-suppressed` | 明示 `since=""` により意図的にバッジ非表示だが、real側には存在が確認できる(想定内・要修正ではない可能性が高い) | 0(実データ) |
| `explicit-wrong` | 明示 `since="X"` の値そのものが実測と食い違う(著者記載の誤り) | 4 |
| `real-autoload-gap:Set` | `Set` クラスの autoload により dump_methods.rb が観測不能(測定側の既知ギャップ、要対応なし) | 52 |
| `not-in-db` | DB側に該当エントリが一切ない(=db_first='-') | 0(実データ) |
| `ladder-gap-1.9.1-1.9.3` | DB ラダーに1.9.1/1.9.2が無い構造的制約で正しい値を自動計算できない | 273(since) |
| `frozen-db-contamination` | `db_first < real_first`(DB側の方が早い=凍結DB等への後年機能混入。db_firstが2.7.0以前なら凍結DB prune対象、3.0以降ならdoctreeのバージョンゲート漏れ) | 11 |
| `db-late` | `db_first > real_first`(DB側の方が遅い=ドキュメント化がリアルより遅れた) | 92 |
| `label-format` | `db_first == real_first` だが表記系の違いなどでバッジ文字列が一致しない(実データ0件、理論上の分岐) | 0(実データ) |

MISMATCH_UNTIL の原因分類:

| note | 意味 | 件数 |
|---|---:|---|
| `not-in-db` | DB側に無い(実データ0件) | 0 |
| `UNVERIFIED_4_1` | `real_last='4.0' && db_last='4.0'`(4.1が単に未実測で確認不能なだけの可能性——verdictを`UNVERIFIED_4_1`に置き換える特殊分岐だが実データでは到達なし) | 0(実データ) |
| `ladder-gap-1.9.1-1.9.3` | since側と対称。1.9.1/1.9.2で削除されたケースを自動計算では表現不可 | 2 |
| `real-build-gap:YJIT-disabled-in-prebuilt-3.2+` | 実測に使った all-ruby プリビルドバイナリが3.2以降YJIT無効ビルドなだけ(要対応なし) | 4 |
| `until-mismatch` | 上記いずれにも当たらない until 不一致(機械的分類。実データ6件は査読の結果すべて実測側アーティファクトで要修正0件——mismatch-report.md の until-mismatch セクション参照) | 6 |

その他の一般的な note(原因分類ではなく解決過程の記録):

- `overloads:N`(N≥2、404件) — グループ内シグネチャ行数。
- `since-conflict:...`/`until-conflict:...` — 集約時の属性値の食い違い
  (実データ0件)。
- `alias-union:...`(175件)/`inherited:...`(136件)/
  `inherited-new-via-initialize:...`(4件)/`new-via-initialize:...`
  (25件)/`special:...`(48件) — real側解決の tier2/tier4/tier5 の
  経由先記録(`via` が `direct` 以外のとき note に転記)。
- `last-resolved-via:...`(133件) — 最初と最後の観測版で解決 tier が
  異なった場合。
- `flag:undef`/`flag:nomethod`(計14件) — `{: undef}`/`{: nomethod}`
  フラグの記録。
- `db-typechar-fallback:s/i` — kind=o の db解決で `m`→`s/i` フォール
  バックが発生した場合(実データ0件)。
- `db-chunk-alias` — **廃止済み**。旧実装(§8参照)で使っていたチャンク
  別名解決のフォールバックタグ。`gd-db-names.tsv` への置き換えで
  不要になり、現行コードには存在しない。

## 8. 履歴: gd-db-presence.tsv + チャンク推測 → gd-db-names.tsv への置き換え

旧実装は本番 DB のエントリ存在を2段階のヒューリスティックで近似していた:

1. `gd-db-presence.tsv`(**ファイルパス**単位の存在。1メソッドファイル
   = 1エントリという前提)
2. 現行 doctree ソース上で「本文を挟まず連続する見出し」を1つの
   「チャンク」とみなし、そのチャンク内の全シグネチャ名を「同じDBファイル
   に同居する別名グループ」と推測するロジック(`CHUNK_DB_ALT`、compare.rb
   §6のコメントに痕跡が残る)

これは**現在のdoctreeソースの見出し隣接関係**から**過去のDBファイルの
`names=` 構成**を逆算するものであり、両者が食い違うケース(doctreeの
見出し構成が改訂された、または過去版DBだけで別名が合体していた等)を
正しく扱えなかった。実データ(`gd-db-names.tsv` = 各版DBのメソッド
ファイルの中身を実際に読んで `names=` を展開したデータ、
`tools/extract_gd_names.rb` で生成)に置き換えたところ、**46エントリの
verdict/note が変化**した(旧実装時の記録との比較。旧実装の出力は
保存されていないため本ノートでは個別差分は再現できないが、下記2方向の
代表例で挙動を確認済み)。

### 誤検出の解消例: `Object#send`

`db-2.4.0` 以前は `Object#send` が独立ファイルとして存在せず、
`i.__send__._builtin` ファイルの `names=__send__,send` の中にのみ
同居していた(=`send` という名前は昔から`__send__`と同じファイルに
同居する別名だった)。ファイルパス単位の `gd-db-presence.tsv` は
`send` という独立ファイルが無いバージョンを「存在しない」と誤判定して
いたが、`gd-db-names.tsv` は `names=` を実読しているため正しく
「`Object#send` は`__send__`と同じ版から存在する」と判定する。
現在の `mismatches.tsv` で `Object i send` は `verdict=OK`
(`real_first=1.8.6, db_first=1.8.7, via=inherited:Kernel`)——誤った
ミスマッチが解消されている。

### 発見された真のミスマッチの例

- **`Thread#to_s`**: `names=` ベースで見ると `db-2.5.0` が初出であり、
  本番バッジは「Ruby 2.5.0 から」と表示している(誤り。実測
  `real_first=1.8.6`)。旧ヒューリスティックはこの不一致を隠していた
  (確認済み: `gd-db-presence.tsv` に `Thread i to_s` のパス行は1件も
  無く、旧実装は現行 doctree の inspect/to_s 同居チャンクから
  `CHUNK_DB_ALT` で `inspect` の存在(db-1.8.7〜)を to_s に合算して
  「1.8.7 から存在」と誤判定していた)。現在 `mismatches.tsv` で
  `Thread i to_s` は `db-late` (`real_first=1.8.6, db_first=2.5.0,
  expected_since=none`)として捕捉されている。
- **`String#===`**: `db-1.8.7` は `names="=="` のみを持つファイルで
  `===` は含まれておらず、`===` は `db-1.9.3` から独立に存在する
  (実測 `real_first=1.8.6`)。現在 `mismatches.tsv` で `String i ===`
  は `db-late`(`db_first=1.9.3`)として捕捉されている。

いずれも「過去版DBでのみ別名が合体/分離していた」という、ファイルパスや
現行ソース構成からは推測できない実データ固有の事実であり、これが
`gd-db-names.tsv` への置き換えを必要とした理由そのものである。

## 9. 検証: verdict合計の再計算

`mismatches.tsv`(データ行、ヘッダ除く)を集計列(17列目 `verdict`)で
再集計:

```
$ awk -F'\t' 'NR>1{c[$17]++} END{for(k in c) print k"\t"c[k]}' mismatches.tsv | sort
DOC_ONLY        35
INFO_1_8_7      72
INFO_1_9_2      68
MISMATCH_SINCE  432
MISMATCH_UNTIL  12
OK              1544
```

合計 = 35+72+68+432+12+1544 = **2163**。`compare.rb` 実行時の
`compare.err`(標準エラー出力)の集計値と完全一致(自己検証済み)。

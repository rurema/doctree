# tools/method-coverage — メソッド単位の過不足実測データ(組み込み+標準添付・3.0〜4.1)

doctree の版別 DB に収録されている全メソッドエントリと、実 Ruby の各版で実際に定義されている
メソッドを双方向に突き合わせた実測データ一式。

- **過剰**: DB にあるが実 Ruby に無いエントリ(until/since 漏れ・削除済み API・慣例記述の候補)
- **不足**: 実 Ruby にあるが DB に無いメソッド(未収録・版追随漏れの候補)

組み込みメソッド版の [tools/method-versions](../method-versions/README.md)(latest teeny 実測・
バッジ検証)と、標準添付ライブラリ版の [tools/library-versions](../library-versions/README.md)
(ライブラリ/ファイル/メソッド単位の実在チェック= 過剰方向のみ)を統合し、
「版別 DB を基準に、不足方向も含めて」計測できるようにしたもの。
分析の本文は [report.md](report.md)。

作成: 2026-09-05。

## データ生成時点(スナップショット情報)

- doctree 側(`db-extract/`): master 948a607c3 の `manual/api` から生成した 3.0〜4.1 の 7 版の DB
- 実測バイナリ: 3.0.0 / 3.1.0 / 3.2.0 / 3.3.0 / 3.4.0 / 4.0.0 = `ghcr.io/ruby/all-ruby`
  (`/all-ruby/bin/ruby-x.y.0`)、4.1 = `ghcr.io/ruby/ruby:master`
  (2026-09-04 ビルド・4.1.0dev 07ef97df22・json 3.0.0.rc1)。各版の `real/<版>/ruby-v.txt` 参照
- 実測環境の注意: all-ruby の 3.2〜4.0 は YJIT 非ビルド(`RubyVM::YJIT` が no-class になる)、
  readline は libedit、システム OpenSSL は 3.0 系(`OpenSSL::Engine`・`Digest::MD2` 等が無い)。
  3.0.0 は fiddle/dbm の共有ライブラリ依存が欠けて require 不可
- bundled gem の判定: [tools/library-versions/matrix-libs.tsv](../library-versions/matrix-libs.tsv)
  の版別種別(B)。集計対象はその版で lib/ext/default gem かつメソッドエントリを 1 件以上持つライブラリ

## ファイル構成

| パス | 内容 |
|------|------|
| `report.md` | 分析本文(版ごとの件数・過剰/不足の内訳・候補・限界) |
| `db-extract/entries-<版>.tsv` | DB の全メソッドエントリ(lib / class / typemark / name / kind / visibility)。`_builtin` 込み |
| `db-extract/classes-<版>.tsv` | DB の全クラス(name / type / library / superclass / included / extended / aliasof) |
| `db-extract/libs-<版>.tsv` | DB の全ライブラリ(name / category / top・sub / クラス数 / エントリ数) |
| `real/<版>/builtin.tsv` | `--disable-gems` で観測した組み込みのモジュール・メソッド一覧(A/M レコード)と `_builtin` エントリのプローブ結果(R レコード) |
| `real/<版>/base.tsv` | gems 有効・require なしの状態(rubygems・did_you_mean 等の事前ロード分) |
| `real/<版>/status.tsv`・`status2.tsv` | ライブラリごとの測定ステータス(1 巡目 / 親ライブラリ pre-require の 2 巡目) |
| `result/<版>/excess.tsv` | 過剰側: DB エントリごとの判定(ok 以外のみ。EXCESS(no-method / no-class)・unmeasured・NOMETHOD_BUT_EXISTS) |
| `result/<版>/summary-by-lib.tsv` | ライブラリ別の件数(過剰・不足の各分類) |
| `result/<版>/summary.txt` | 版ごとのスコープ別サマリ |
| `result/matrix-excess.tsv` | 過剰キー(403)× 7 版のマトリクス(X= 過剰 / o= 実在 / -= その版の DB に無し / ?= 未測定)+ pattern(all / new-only / old-only / middle / mixed)+ first_present |
| `result/matrix-shortage.tsv` | 不足キー(25,055 = UNDOC・UNDOC(class-stub)・UNDOC(class-undoc)・NOMETHOD_CONFLICT の public/protected)× 7 版のマトリクス(X= 不足 / o= 実在かつ記載あり / -= その版に無し)+ pattern + first_present |
| `result/aggregate-summary.txt` | マトリクスの集計(スコープ×分類×パターン、pattern=all の初出版別) |
| `tools/` | 再生成スクリプト一式(下記) |

ライブラリごとの require 前後差分ダンプ(`real/<版>/libs/*.tsv`・約 90MB/版)と、
各版の全実測キー一覧(`result/<版>/real-keys.tsv`)・不足側の全行(`result/<版>/shortage.tsv`・
DOC_ON_ANCESTOR 等の除外分類を含む約 1 万行/版)はサイズの都合で含めていない。
必要なら下記手順で再生成できる。

## 分類

出力の `scope` 列:

- `builtin` / `stdlib` / `bundled`: `_builtin` / その版で lib・ext・default gem / その版で bundled gem
- `stdlib(no-method-docs)` 等: ページはあるがメソッドエントリが 1 件も無いライブラリ(概要のみ)
- `stdlib(no-page)`: rurema にページが無いユニット(feature からの推定)
- `vendored`: `rubygems/vendor/*`・`bundler/vendor/*`。`undoc-lib`: どのライブラリにも帰属できなかった feature

不足側の `category` 列:

- `UNDOC`: DB にクラスがあり、そのクラスにメソッド記載もあるが当該メソッドが無い(主指標)
- `UNDOC(class-stub)`: DB にクラスページはあるがメソッド記載がゼロ
- `UNDOC(class-undoc)`: DB にクラスが無い(内部クラス等)
- `UNDOC_PRIV` / `UNDOC_UNDERSCORE`: private / `_foo` 形(生成メソッド)
- `ALIAS_OF_DOC`: 別名の元(`original_name`)側は記載あり
- `DOC_ON_ANCESTOR` / `DOC_ON_DESCENDANT`: 祖先(module_function の複製先を含む)/ 子孫側(Kernel→Object の慣例)で記載あり
- `NOMETHOD_CONFLICT`: DB では `{: nomethod}`/`{: undef}` だが実 Ruby には存在する

不足側のライブラリ帰属は「DB でそのクラスを記載しているライブラリ → メソッドの source_location から
求めた feature の最長一致 → クラス内の多数派 feature → 差分に含んだライブラリのうち最小のもの」の順。
forwardable/delegate 等で生成されたメソッド(source_location が forwardable.rb になる)は前段で吸収されるが、
未文書クラスでは帰属ノイズとして残る。

過剰側で除外しているもの: `$` 特殊変数(`defined?($1)` は未マッチで nil になり判定不能)、
プレースホルダ `Errno::EXXX`、`-n`/`-p` 時のみ定義される `Kernel.#chomp`/`chop`/`gsub`/`sub`、
プラットフォーム定数クラス(Socket・Etc・Process 等)の定数。

## 再生成手順

DB と実測ダンプはリポジトリ外(作業用ディレクトリ `WORK`)に作ること。以下は doctree ディレクトリで実行する。

1. 版別 DB を作り、エントリを抽出する

   ```sh
   T=tools/method-coverage/tools
   for v in 3.0 3.1 3.2 3.3 3.4 4.0 4.1; do
     bundle exec bitclust --database=$WORK/db/db-$v init version=$v encoding=UTF-8
     bundle exec bitclust --database=$WORK/db/db-$v update --markdowntree=manual/api
     bundle exec ruby $T/extract_db.rb $WORK/db/db-$v $WORK/db-extract $v
     ruby $T/gen_inputs.rb $WORK/db-extract $WORK/probe-in $v
   done
   cp $T/*.rb $T/*.sh $WORK/tools/   # コンテナからは $WORK を /work としてマウントする
   ```

2. 各版の実 Ruby で測定する(1 巡目= `measure.sh`・2 巡目= `measure2.sh`)。
   `docker run` は `--user $(id -u):$(id -g)` で(出力ファイルが root 所有にならないように)

   ```sh
   for v in 3.0 3.1 3.2 3.3 3.4 4.0; do
     docker run --rm --user $(id -u):$(id -g) -e HOME=/tmp -v $WORK:/work ghcr.io/ruby/all-ruby \
       sh /work/tools/measure.sh $v /all-ruby/bin/ruby-$v.0
     docker run --rm --user $(id -u):$(id -g) -e HOME=/tmp -v $WORK:/work ghcr.io/ruby/all-ruby \
       sh /work/tools/measure2.sh $v /all-ruby/bin/ruby-$v.0
   done
   docker run --rm --user $(id -u):$(id -g) -e HOME=/tmp -v $WORK:/work ghcr.io/ruby/ruby:master \
     sh /work/tools/measure.sh 4.1 ruby
   docker run --rm --user $(id -u):$(id -g) -e HOME=/tmp -v $WORK:/work ghcr.io/ruby/ruby:master \
     sh /work/tools/measure2.sh 4.1 ruby
   ```

   `dump_all.rb` は require を一切せず、トップレベルの def・定数も使わない(自身の汚染防止)。
   `--lib LIB` で LIB を require し、前後の差分(新規メソッド・新規/変化したクラス)と
   `--probe FILE` のエントリ判定を出力する。`dump_all_pre.rb` は `--pre LIB` で親ライブラリを
   先に require する版(`rdoc/markdown` のように単体では require できないサブライブラリ向け)

3. 突き合わせと集計

   ```sh
   for v in 3.0 3.1 3.2 3.3 3.4 4.0 4.1; do
     ruby $T/compare_mc.rb $WORK $v tools/library-versions/matrix-libs.tsv
   done
   ruby $T/aggregate_mc.rb $WORK 3.0 3.1 3.2 3.3 3.4 4.0 4.1 > $WORK/result/aggregate-summary.txt
   ```

   `compare_mc.rb` は `$WORK/{db-extract,real,probe-in}` を読み、`$WORK/result/<版>/` に
   `excess.tsv`・`shortage.tsv`・`real-keys.tsv`・`summary-by-lib.tsv`・`summary.txt` を書く。
   `aggregate_mc.rb` は `result/matrix-*.tsv` を書く

## 既知の限界(結果を読むときの注意)

- **x.y.0 基準**: 実測は各 minor の x.y.0(4.1 は master スナップショット)なので、teeny で追加された
  メソッド(例: `Prism::Node#each_child_node` は 4.0.1 から)は過剰側に出る。doctree 側が
  `{: since="x.y.z"}` で対応済みのものは無視する
- 4.1 の json は 3.0.0.rc1。json 3.0 で消える API(`JSON.fast_generate` 等)・`json/add/*` の削除は
  リリース版で再確認してから対応する
- 「存在する」はメソッド定義の有無のみで、引数追加などシグネチャ単位の差分は検出しない
- サブクラス側に定義される慣例記述(`Struct.members`・`Data.new`・`Singleton.instance` 等)、
  プロトコル記述(`Object#marshal_dump` 等)、`Struct`/`Data` の生成メソッドは過剰側に出るが削除不要
- probe の `no-class` は定数解決に inherit=false を使うため、mixin 先で生成されるクラスを見逃すことがある
  (tools/library-versions の README 参照)

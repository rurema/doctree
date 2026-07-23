# notes-gd-db.md — rurema/generated-documents (gd) DB からの _builtin 存在抽出

作成: 2026-07-23。ツール: `tools/extract_gd_presence.rb`。
参照 rev: `origin/main` = `c6fac23de13c088b7b31570256d73009a2fa9476`
(2026-07-23 の gd #176 マージ後の HEAD。fetch 済み)。

## 0. 重要な訂正: 「gd」の実体

依頼文では「docs.ruby-lang.org リポジトリ(通称 gd)」とあったが、実際に
db-* ツリーを持つのは **`rurema/generated-documents`**(ローカルでは doctree checkout の
隣に clone してある前提。以下同)である。

`docs.ruby-lang.org` リポジトリは
Capistrano デプロイ設定・rsync スクリプトのみを持ち、db/html 本体は含まない。
`system/bc-setup-all` を見ると、デプロイ用サーバー上で

```
GENERATED_DOCUMENTS_BASE = "/var/rubydoc/generated-documents"
git clone https://github.com/rurema/generated-documents.git  # なければ
Dir.glob("#{GENERATED_DOCUMENTS_BASE}/db/db-*")               # これを doctree/refm/db-* へ symlink
```

としており、"gd" は本来 **g**enerated-**d**ocuments の略と考えられる
(過去セッションメモの「gd」呼称も generated-documents リポジトリを指して
使われている)。今回の抽出は generated-documents 側で実施した。

## 1. db 一覧(17件)

```
db-1.8.7  db-1.9.3  db-2.0.0  db-2.1.0  db-2.2.0  db-2.3.0  db-2.4.0
db-2.5.0  db-2.6.0  db-2.7.0  db-3.0    db-3.1    db-3.2    db-3.3
db-3.4    db-4.0    db-4.1
```

凍結版 10(1.8.7〜2.7.0)+ ライブ版 7(3.0〜4.1)= 計17、依頼文の想定どおり。
`db/` 直下には他に `bitclust.rev` / `doctree.rev`(生成時に使った bitclust /
doctree の commit SHA を記録したファイル)がある。

## 2. バージョンごとのエントリ数

`_builtin` ライブラリに属するメソッド数(`gd-db-presence.tsv`)とクラス数
(`gd-db-classes.tsv`、`library/_builtin` の `classes=` プロパティ由来):

| db_version | method 数 | class 数 |
|---|---|---|
| 1.8.7 | 1241 | 207 |
| 1.9.3 | 1666 | 228 |
| 2.0.0 | 1758 | 232 |
| 2.1.0 | 1810 | 254 |
| 2.2.0 | 1833 | 258 |
| 2.3.0 | 1885 | 266 |
| 2.4.0 | 1894 | 267 |
| 2.5.0 | 1939 | 269 |
| 2.6.0 | 1991 | 274 |
| 2.7.0 | 2021 | 274 |
| 3.0   | 2046 | 283 |
| 3.1   | 2067 | 285 |
| 3.2   | 2109 | 285 |
| 3.3   | 2111 | 284 |
| 3.4   | 2118 | 284 |
| 4.0   | 2124 | 285 |
| 4.1   | 2124 | 285 |

合計: method 32737 行 / class 4520 行。おおむね単調増加(想定どおり)。
3.2→3.3 と 2.7.0→3.0 でクラス数が微減しているのは Fixnum/Bignum が
Integer に統合され `library/_builtin` の `classes=` から外れた影響などと
推測されるが、今回は存在一覧の抽出のみが目的のため深追いしていない
(必要なら `matrix.tsv`/`classes.tsv` 側の実測データと突き合わせ可能)。

typechar 別の全体件数(全バージョン合算): i(instance_method)=20900,
s(singleton_method)=4380, c(constant)=3649, m(module_function)=3214,
v(special_variable)=594。5種すべて出現し、想定外の typechar は無かった
(スクリプトは未知 typechar を検出したら warn するようにしてあるが、
実行時に警告は出なかった)。

## 3. ファイルパスのエンコーディング規則

db 配下のディレクトリ/ファイル名は2段階のエンコーディングが重なっている。

### 3.1 外側: `encodeid` / `decodeid` (パス全体)

`bitclust/lib/bitclust/nameutils.rb:248-255`:

```ruby
# case-sensitive ID -> encoded string (encode only [A-Z])
def encodeid(str)
  str.gsub(/[A-Z]/n) {|ch| "-#{ch}" }.downcase
end

# encoded string -> case-sensitive ID (decode only [A-Z])
def decodeid(str)
  str.gsub(/-[a-z]/ni) {|s| (s[1,1] || raise).upcase }
end
```

`Database#realpath` (`bitclust/lib/bitclust/database.rb:199-201`) が
`"#{@prefix}/#{encodeid(rel)}"` という形でこれを適用しており、db 内の
相対パス文字列(`ClassID/typechar.method_id.libid` 形式)をまるごと
`encodeid` した結果がファイルシステム上のパスになる。`/` は
`encodeid`/`decodeid` の対象外なのでディレクトリ区切りとして無傷で残る。

例: `Module` → (M が大文字) → `-Module` → downcase → `-module`
(実際のディレクトリ名 `-module` と一致)。
`FileTest` → `F`,`T` が大文字 → `-file-test`。
`ARGF.class`(`CLASS_NAME_RE` にある特殊クラス名。`.` はそのまま)→
`-a-r-g-f.class`。
`Benchmark::Job` → 先に `classname2id` で `::`→`=` → `Benchmark=Job` →
`encodeid` → `-benchmark=-job`。

### 3.2 内側: `encodename_url` / `decodename_url`(メソッド名・ライブラリ名)

`nameutils.rb:230-237`:

```ruby
def encodename_url(str)
  str.gsub(/[^A-Za-z0-9_]/n) {|ch| sprintf('=%02x', (ch[0] || raise).ord) }
end

def decodename_url(str)
  str.gsub(/=[\da-h]{2}/ni) {|s| (s[1,2] || raise).hex.chr }
end
```

`[A-Za-z0-9_]` 以外の1文字を `=XX`(小文字16進2桁)に変換する。
`build_method_id`(`nameutils.rb:124-126`)がメソッド ID 文字列
`"#{cid}/#{typechar}.#{encodename_url(name)}.#{libid}"` を組み立てる際に
メソッド名側だけに適用され、`libid`(`libname2id`、`nameutils.rb:34-36`。
`/` 区切りの各セグメントに同じく `encodename_url` を適用して `.` 連結)
にも使われる。

2つのエンコーディングは **マーカー文字が異なる**(外側は `-`、内側は
`=`)ため衝突しない。よって全体のデコード手順は:

1. パス全体(`classdir_enc/filename_enc`)に `decodeid` を適用
   (`-x` → `X` を全体に対して一括で戻す。`/` はそのまま)
2. `/` は既に分かれているので、`classdir` 側は `classid2name`
   (`gsub(/=/, '::')`)でクラス名に、`filename` 側は `.split('.', 3)`
   で `[typechar, mname_enc, libid_enc]` に分解
   (`split_method_id` 相当。`nameutils.rb:131-136`)
3. `mname_enc` に `decodename_url`、`libid_enc` に `libid2name`
   (`libname2id` の逆、`nameutils.rb:38-40`)を適用

`split('.', 3)` で問題ないのは、`encodename_url` された `mname_enc` 自体には
(元のメソッド名にリテラルな `.` が来ることは `METHOD_NAME_RE` 上ありえず、
仮にあっても `=2e` にエンコードされるため)リテラル `.` が絶対に含まれない
ことが保証されているから。一方 `libid_enc` 側は `minitest.spec` のように
サブライブラリの `.` 区切りをそのまま残す設計(`libname2id` は `/` を `.`
に変換するだけで `.` はエンコード対象外)なので、`split('.', 3)` の limit
3 でちょうど「typechar . mname . 残り全部(libid)」に分かれる。

## 4. typechar の意味

`nameutils.rb:138-144`(`NAME_TO_MARK`)と `162-168`(`NAME_TO_CHAR`):

| typechar | 種別 (symbol) | 表記 (mark) |
|---|---|---|
| `i` | `instance_method` | `#` |
| `s` | `singleton_method` | `.` |
| `m` | `module_function` | `.#` (4.0以降の表示は `?.`。`display_typemark`, `nameutils.rb:219-223`) |
| `c` | `constant` | `::` |
| `v` | `special_variable` | `$` |

`v` の実例: `Kernel$FILENAME`(ファイル名では `-kernel/v.-f-i-l-e-n-a-m-e._builtin`)
`Kernel$!`(`-kernel/v.=21._builtin`)、`Kernel$1`(`-kernel/v.1._builtin`)など。
特殊変数名はエンコード前の生の名前(先頭 `$` を含まない)がそのまま
`method_name` として保存される。

## 5. クラス一覧の取得方法

各 db の `class/` ツリーは1クラスにつき1ファイル(blob)で、中身に
`library=_builtin` のようなプロパティ行を持つ(1766ファイル/db 程度)。
これを全部読むより、`library/_builtin` という1ファイルの `classes=` 行
(`_builtin` ライブラリが持つ全クラス ID をカンマ区切りで列挙したもの)
を読む方が圧倒的に速く、かつ「`_builtin` に属するか」の判定そのもの
なので、`gd-db-classes.tsv` はこちらを情報源にした
(バージョンごとに `git show` 1回・計17回のみ)。

## 6. 検証結果

### 6.1 Module#prepend の 1.9.3 混入 (doctree#3269)

```
$ grep -P "^1\.9\.3\tModule\ti\tprepend$" gd-db-presence.tsv
1.9.3	Module	i	prepend
```

**確認: `db-1.9.3` に `Module#prepend`(生パスは `-module/i.prepend._builtin`)
が存在する。** 依頼文にあった既知の凍結版混入(doctree#3269、
Module#prepend は本来 Ruby 2.0.0 導入)がこのデータにもそのまま
反映されている。バッジの自動算出はこの DB 存在一覧を最古/最新の
根拠にしているため、この混入がバッジの誤表示(「Ruby 1.9.3 から」)に
直結する、という issue の分析と整合する。

### 6.2 デコードのラウンドトリップ確認

`decodeid` → 分解 → `decodename_url`/`classid2name`/`libid2name` で得た
論理名を、逆変換(`classname2id`/`encodename_url`/`libname2id` で
組み立て直してから `encodeid`)で元のファイルパスに戻し、完全一致するか
を検証した(スクラッチスクリプトで実施、成果物には含めていない)。

対象: `db-1.8.7` / `db-1.9.3` / `db-2.0.0` / `db-3.4` / `db-4.1` の
**method/ 以下の全エントリ(_builtin 以外の全ライブラリも含む)= 56841件**。
**不一致 0件**。演算子メソッド(`<=>`, `[]=`, `!~` 等)・`?`/`!`/`=` 付き
メソッド名・特殊変数(`$1`, `$!`, `$FILENAME`)・ネストしたクラス
(`File::Stat`, `Benchmark::Job`, `Errno::EXXX`)・特殊クラス名
(`ARGF.class`, `fatal`, `main`)を含め、いずれも往復一致した。

## 7. 気づいたエッジケース

- **`ARGF.class`**: `CLASS_NAME_RE` に埋め込まれたリテラル特殊クラス名。
  クラス ID にリテラル `.` を含む唯一の例(`encodeid` は `.` を素通しする
  ため `-a-r-g-f.class` という、一見メソッドパスのような `.` を含む
  ディレクトリ名になる。`/` で先に分割してから `.` 分割するので実害はない)。
- **`fatal` / `main` / `X::compatible`**: `CLASS_NAME_RE` にある大文字
  始まりでない特殊クラス名。すべて小文字のみなので `encodeid` は無変換。
- **特殊変数の記号名**: `$!`, `$~`, `$0`〜`$9` 等は `v.=21`(`!`）
  `v.0`〜`v.9` のように、名前部分がそのまま(1文字なら `encodename_url`
  でエンコード、数字はそのまま)保存される。
- **`=index` / `=sindex`**: 各 `method/` 直下、各クラスディレクトリ直下に
  存在する索引ファイル。`decodeid`/`decodename_url` の対象ではなく、
  `Database#entries` 同様「先頭が `.` か `=`」で単純に除外する必要がある
  (`nameutils.rb` のデコード関数自体はこれらを弾かないので、呼び出し側で
  フィルタする設計になっている)。
- **サブライブラリの `.` 混在**: `-module/i.infect_with_assertions.minitest.spec`
  のように、`libid` 側に `.` が複数含まれるケース(`minitest.spec` という
  サブライブラリ名)がある。`split('.', 3)` の limit 3 で正しく
  `mname="infect_with_assertions"`, `libid="minitest.spec"` に分かれる
  ことを確認済み(このエントリ自体は `_builtin` ではないため
  `gd-db-presence.tsv` には出てこないが、デコードロジックの網羅性
  確認のため上記ラウンドトリップ検証の対象に含めた)。
- **クラス数の微減**: 2.7.0→3.0、3.2→3.3 でクラス数が1〜2件減っている
  (§2 参照)。Fixnum/Bignum の Integer への統合など既知の変遷が
  関係している可能性が高いが、今回のタスク範囲では未特定。

## 8. 成果物

- `tools/extract_gd_presence.rb` — 抽出スクリプト(再実行可能。使い方は
  冒頭コメント参照。`git fetch` はスクリプト側では行わないので、
  実行前に `git -C <generated-documents> fetch origin`
  しておくこと)
- `gd-db-presence.tsv` — 32737行。列: db_version / class_name / typechar /
  method_name
- `gd-db-classes.tsv` — 4520行。列: db_version / class_name
- 本ファイル

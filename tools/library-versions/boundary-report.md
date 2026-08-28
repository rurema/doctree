# 版ゲート境界調査レポート(x.y.0 タグ実物ベース)

調査日: 2026-08-28。すべて `gh api`(api.github.com のみ)で ruby/ruby および各 gem リポジトリの
タグ時点のツリー/ファイル内容を取得し、`grep`/`rb_define_method` 突き合わせで判定した。
ローカルの「実測」(mise 等の実行環境)は teeny ドリフトや環境汚染の罠があるため一切使わず、
すべて GitHub 上の tag 時点のソースのみを根拠にしている。

## 総括表

| # | 対象 | 判定(最初に無くなる版) | 確信度 | 備考 |
|---|---|---|---|---|
| 1 | `OpenSSL::Config#[]=`/`#add_value`/`#section`/`#value` | **3.1.0** | 高 | ext/openssl/lib/openssl/config.rb が v3_1_0 でファイルごと消滅(C実装 ossl_config.c に移行、該当4メソッドは移植されず) |
| 2 | `Net::SMTP::Revision`/`#auth_cram_md5`/`#auth_login`/`#auth_plain` | **3.3.0** | 高 | net-smtp gem 0.3.3(3.2.0 pin)に有り→0.4.0(3.3.0 pin)で auth_method/auth_capable? 方式に置換され消滅 |
| 3 | `StringScanner#clear`/`#empty?`/`#getbyte`/`#peep`/`#restsize` | **4.0.0**(当初仮説の 3.4 ではない) | 高 | ext/strscan/strscan.c は v3_4_0〜v3_4_10 まで全て strscan 3.1.2 で5メソッド健在。v4.0.0(strscan 3.1.6)で消滅。ruby/strscan 側は v3.1.5→v3.1.6 の間で削除 |
| 4a | `Net::IMAP.max_flag_count`/`.max_flag_count=` | **3.1.0** | 高 | net-imap が bundled gem 化した最初の pin(0.2.2)時点で既に消滅済み(0.2.1 までは有り) |
| 4b | `Net::IMAP#client_thread=`(setter) | **3.3.0** | 高 | pin 0.3.4(3.2.0)まで `attr_accessor` で setter 健在。pin 0.4.9(3.3.0)で reader のみに縮小 |
| 4c | `Net::IMAP#client_thread`(getter) | **3.4.0** | 高 | pin 0.4.9(3.3.0)では非推奨警告付きで健在。pin 0.5.4(3.4.0)で完全消滅 |
| 5 | `Net::FTP`/`Net::POP`(ファイル自体) | **4.1(master、未リリース)** | 高 | v4.0.0 時点は bundled(net-ftp 0.3.9 / net-pop 0.1.2)。master の lib/net/・gems/bundled_gems から完全に消滅(ライブ再確認済み) |
| 6 | rubygems 旧API 39件 | 下表参照(pre-3.0 / 4.0.0 / 3.4.0 の3群) | 高 | 詳細は「6. rubygems 旧API」節 |

---

## 1. OpenSSL::Config

- v3_0_7: `ext/openssl/lib/openssl/config.rb` が存在し、対象4メソッドすべて定義:
  `def value`(305行)、`def add_value`(339行)、`def section`(368行)、`def []=`(399行)。
- v3_1_0: 同パスの `contents` API が **404**。`ext/openssl/lib/openssl` ディレクトリの一覧を
  取得すると `config.rb` 自体が存在せず(bn.rb/buffering.rb/cipher.rb/digest.rb/hmac.rb/
  marshal.rb/pkcs5.rb/pkey.rb/ssl.rb/version.rb/x509.rb のみ)、Config クラスは
  `ext/openssl/ossl_config.c` の C 実装に一本化されていた。
  `ossl_config.c` の `rb_define_method`/`rb_define_singleton_method` を全部拾うと
  `initialize, initialize_copy, get_value, [], sections, to_s, each, inspect` のみで、
  `[]=`/`add_value`/`section`/`value` は移植されていない。
- 判定: **3.1.0** で4メソッドとも消滅。

## 2. Net::SMTP

`gems/bundled_gems`(各タグ時点)のピン:

| ruby タグ | net-smtp pin |
|---|---|
| v3_1_0 | 0.3.1 |
| v3_2_0 | 0.3.3 |
| v3_3_0 | 0.4.0 |
| v3_4_0 | 0.5.0 |
| v4.0.0 | 0.5.1 |

ruby/net-smtp の `lib/net/smtp.rb` をタグ v0.3.3 / v0.4.0 で確認:

- v0.3.3(=3.2.0 相当): `Revision = %q$Revision$.split[1]`(191行)、
  `def auth_plain`(840)、`def auth_login`(849)、`def auth_cram_md5`(860) すべて健在。
- v0.4.0(=3.3.0 相当): 上記4つとも grep 0件。代わりに `auth_capable?`/`authenticate`/
  `auth_method` という新方式に置換されている(class SMTP 自体は健在、ファイルも1139行で
  正常に取得できていることを確認済み)。
- 判定: **3.3.0** で消滅。

## 3. StringScanner(要修正: 当初仮説の「3.4 以降不在」は誤り)

`ext/strscan/strscan.c` の `rb_define_method(StringScanner, "clear"/"getbyte"/"peep"/
"empty?"/"restsize", ...)` を数えた結果:

| ruby タグ | STRSCAN_VERSION | 5メソッドのヒット数 |
|---|---|---|
| v3_3_0 | 3.0.7 | 5(全部あり) |
| v3_4_0 | 3.1.2 | 5(全部あり) |
| v3_4_1 | 3.1.2 | 5 |
| v3_4_5 | 3.1.2 | 5 |
| v3_4_8 | 3.1.2 | 5 |
| v3_4_10(3.4系最新) | 3.1.2 | 5 |
| v4.0.0 | 3.1.6 | **0** |

**3.4系はどのテイニーを見ても strscan 3.1.2 のまま変わらず、5メソッドとも一貫して健在**。
つまり ruby/ruby 側は 3.4.0〜3.4.10 の間で strscan を一切更新していない。
念のため ruby/strscan 本体リポジトリでも二分探索し、`v3.1.5` までは5メソッド健在、
`v3.1.6` で消滅(v4.0.0 が pin する版と一致)を確認した。

→ タスク説明にあった「実測では 3.4 以降不在」は、**ローカル実行環境の汚染**
(グローバルインストールされた新しい strscan gem が組み込み実装を上書きしていた可能性が高い)
によるものであり、GitHub 上の x.y.0 タグの実物ツリーとは矛盾する。
**「境界は必ず x.y.0 時点のツリーで判定」の原則に従い、正しい判定は 4.0.0 とする。**

- 判定: **4.0.0**(3.4 系では一切消えていない)。

## 4. Net::IMAP

`gems/bundled_gems` ピン:

| ruby タグ | net-imap pin |
|---|---|
| v3_1_0 | 0.2.2 |
| v3_2_0 | 0.3.4 |
| v3_3_0 | 0.4.9 |
| v3_4_0 | 0.5.4 |
| v4.0.0 | 0.6.2 |

ruby/net-imap の `lib/net/imap.rb` を各ピンタグで grep(`client_thread`/`max_flag_count`):

| pin (ruby) | `client_thread`(getter) | `client_thread=`(setter) | `.max_flag_count`/`=` |
|---|---|---|---|
| v0.2.2 (3.1.0) | attr_accessor で両方あり | 同左 | **なし**(既に消滅) |
| v0.3.4 (3.2.0) | attr_accessor(`:nodoc:`)で両方あり | 同左 | なし |
| v0.4.9 (3.3.0) | `def client_thread`(非推奨警告付き)のみ **残存** | **消滅**(setter だけ先に無くなる) | なし |
| v0.5.4 (3.4.0) | **消滅** | 消滅 | なし |
| v0.6.2 (4.0.0) | 消滅 | 消滅 | なし |

`.max_flag_count`/`.max_flag_count=` の追加調査: 3.0系(default gem 形態。ruby/ruby 本体
`lib/net/imap.rb`)の v3_0_7 では `def self.max_flag_count`/`max_flag_count=` が健在。
net-imap gem の初期タグ v0.1.0〜v0.2.1 まで健在、**v0.2.2 で消滅**(=3.1.0 の pin と完全一致)。
つまり bundled gem 化した最初の版から既に無い。

- 判定:
  - `.max_flag_count` / `.max_flag_count=`: **3.1.0**
  - `#client_thread=`: **3.3.0**
  - `#client_thread`: **3.4.0**

## 5. Net::FTP / Net::POP(ファイル自体)

- v4.0.0 の `gems/bundled_gems`: `net-ftp 0.3.9`、`net-pop 0.1.2` が健在(bundled gem として残存)。
- master をライブ再確認:
  - `repos/ruby/ruby/contents/lib/net?ref=master` → `http.rb, http/, https.rb,
    net-protocol.gemspec, protocol.rb` のみ。`ftp.rb`/`pop.rb`/`imap.rb`/`smtp.rb` は無い
    (これらは完全に bundled gem 化されファイルの実体すら ruby/ruby 内に存在しない設計のため
    元々置かれない。今回は ftp/pop が **bundled gem リストからも落ちている**ことが主眼)。
  - `gems/bundled_gems`(master, ライブ取得)を `ftp|pop` で grep → **0件**。
- 判定: **master(rurema の 4.1)で不在**。4.0.0 までは bundled として存在。

## 6. rubygems 旧API(mismatch-matrix.tsv の lib=rubygems / rubygems/specification、39件)

RubyGems は bundled gem ではなく ruby/ruby の `lib/rubygems/` 以下に**直接ベンダリング**されている
(gems/bundled_gends のピン対象ではない)。そのため各タグの ruby/ruby ツリーを直接 grep した。

### 6a. pre-3.0(31件、always-ng bucket)— v3_0_7 で既に不在を確認

v3_0_7 の `lib/rubygems.rb`・`lib/rubygems/specification.rb`・`lib/rubygems/errors.rb`・
`lib/rubygems/exceptions.rb` を対象語で grep し、全て0件(=3.0 時点で既に無い)を確認:

- `Gem::DIRECTORIES`、`Gem::RubyGemsPackageVersion`
- `Gem.set_home`、`Gem.set_paths`、`Gem.source_index`
- `Gem::LoadError#version_requirement`、`#version_requirement=`
- `Gem::QuickLoader`(クラスごと存在せず): `::GemPaths`、`::GemVersions`、
  `#calculate_integers_for_gem_version`、`#const_missing`、`.load_full_rubygems_library`、
  `#method_missing`、`#push_all_highest_version_gems_on_load_path`、
  `#push_gem_version_on_load_path`
- `Gem::Specification`(DSL 群、`specification.rb` に `def self.array_attributes`
  (**複数形**)/`attribute_names`/`required_attribute?`/`required_attributes` 等の
  **後継メソッドは存在するが単数形の旧名は無い**ことを確認):
  `.array_attribute`、`#assign_defaults`、`.attribute`、`.attribute_alias_singular`、
  `.attribute_defaults`、`.attributes`、`.default_value`、`#installation_path`、`.list`、
  `#loaded=`、`#loaded?`、`.overwrite_accessor`、`.read_only`、`.required_attribute`、
  `#test_suite_file`、`#test_suite_file=`
  (`test_suite_file` はソース中のコメントに `# 1 0.8.0 2004-08-01 Deprecated
  "test_suite_file" for "test_files"` とあり、RubyGems 0.8.0(2004年)時点で既に非推奨化
  されていたことが裏付けられる)

→ 全31件「pre-3.0」。境界調査は不要(タスク指示どおり)。

### 6b. 4.0.0 で消滅(7件、new-only-ng bucket)

- `Gem::ConfigMap`、`Gem::RubyGemsVersion`:
  実体は `lib/rubygems.rb` ではなく `lib/rubygems/compatibility.rb`(`deprecate_constant`
  でマークされた定数)。v3_0_7〜v3_4_0 まで同ファイルが存在し両定数とも健在
  (v3_1_0/v3_2_0/v3_4_0 で `contents` API 確認、ファイル自体は存在)。
  v4.0.0 では `lib/rubygems/compatibility.rb` 自体が **404(ファイルごと削除)**。
  `lib/rubygems` ディレクトリ一覧にも `compatibility.rb` は無い。
- `Gem::Specification#default_executable`/`#default_executable=`/`#has_rdoc`/`#has_rdoc=`/
  `#has_rdoc?`:
  v3_2_0/v3_3_0/v3_4_0 の `specification.rb` はいずれも `attr_writer :default_executable`
  + `def default_executable`(`rubygems_deprecate` 付きだが実体は健在)、
  `def has_rdoc`/`def has_rdoc=`/`alias(_method) has_rdoc?` が定義されている。
  v4.0.0 ではこれらの `def`/`attr_writer` が完全に見当たらず(該当箇所は
  `# offset due to has_rdoc removal` というコメントのみ)。
- 判定: 7件とも **4.0.0**。

### 6c. 3.4.0 で消滅(1件、new-only-ng bucket)— 当初推定(3.3)からの修正

- `Gem::Specification#mark_version`:
  - v3_2_0: `def mark_version` (2144行) 健在。
  - v3_3_0: `def mark_version` (2175行) **健在**(以前の実測では3.3から無いとされていたが、
    x.y.0 タグの実物では 3.3.0 時点でまだ本物のメソッドとして定義されている)。
  - v3_4_0: `def mark_version` は grep 0件。代わりに
    `REMOVED_METHODS = [:rubyforge_project=, :mark_version].freeze` が導入され、
    `method_missing` 経由で「削除済みメソッド呼び出し」を検知する仕組みに置き換わっている
    (実体メソッドとしては存在しない = `method_defined?` は false になる)。
  - 判定: **3.4.0**(3.3 ではなく3.4が正しい境界。teeny ドリフトの罠の実例)。

---

## ハマった点・タグ名解決の教訓

1. **ruby/ruby のタグ命名がバージョンで変わる**: 3.4系までは `v3_0_7`/`v3_1_0`/`v3_4_10` の
   ような **アンダースコア区切り**。4.0系からは `v4.0.0`/`v4.0.0-preview2`/`v4.0.1` の
   **ドット区切り**に変更されている。`v4_0_0` で引くと 404 になるため要注意
   (`git/refs/tags` を `--paginate` で全件引いて実在確認するのが安全)。
2. **gem リポジトリ(ruby/net-smtp, ruby/net-imap, ruby/strscan)は常にドット区切り
   `vX.Y.Z`** で統一(`v0.3.1.1` や `v0.6.4.1` のような4節版も存在する)。
3. **api.github.com のみ許可のため raw.githubusercontent.com は使えない**。
   `GET /repos/{owner}/{repo}/contents/{path}?ref={tag}` の `.content`(base64)を
   `base64 -d` してファイル本文を得る方式で統一した。
4. **`contents` API の 404 は「ファイルが無い」ことの直接証拠になる**が、リネーム/移動の
   可能性を必ず親ディレクトリ一覧で確認してから「削除」と断定すること
   (今回は `ext/openssl/lib/openssl/config.rb`、`lib/rubygems/compatibility.rb` の両方で
   404→ディレクトリ一覧確認→本当に削除、という手順を踏んだ)。
5. **RubyGems は bundled gem 扱いではなく ruby/ruby に直接ベンダリングされている**ため、
   `gems/bundled_gems` にピンが無い。`lib/rubygems/` 以下を直接タグ指定で見る必要がある。
6. **目的のメソッド/定数が「素直な場所」に無いことがある**(`Gem::ConfigMap`/
   `Gem::RubyGemsVersion` は `lib/rubygems.rb` ではなく `lib/rubygems/compatibility.rb`)。
   grep 0件で即「無い」と判定せず、関連ファイル(defaults.rb, compatibility.rb, errors.rb 等)
   も確認すること。
7. **teeny ドリフトの実例が2件見つかった**:
   - StringScanner: ローカル実測は「3.4以降不在」だったが、GitHub 上の v3_4_0〜v3_4_10
     (3.4系の最初から最新まで全部)は一貫して健在。実際の境界は 4.0.0。ローカル実測は
     おそらく環境汚染(グローバルにインストールされた新しい strscan gem)。
   - `Gem::Specification#mark_version`: ローカル実測は「3.3から不在」だったが、v3_3_0
     タグでは本物のメソッドとして健在。実際の境界は 3.4.0(`REMOVED_METHODS` 機構への
     切り替えがここで起きている)。
   → **「x.y.0 タグの実物」を必ず見ないと、後続の teeny や環境汚染で境界を1版早く
   誤認する**ことが具体的に実証された。

## 成果物

- 調査ワークディレクトリ: `/tmp/claude-1000/-home-debian-rurema/58ba4581-c6ee-4450-bb72-29d0c6d1cc48/scratchpad/boundary-check/`
  (取得した各タグのソース断片・rubygems 各タグの `rg-vX_Y_Z/` サブディレクトリを含む)
- 本レポート: `/tmp/claude-1000/-home-debian-rurema/58ba4581-c6ee-4450-bb72-29d0c6d1cc48/scratchpad/method-check/boundary-report.md`

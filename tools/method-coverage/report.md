# メソッド過不足チェック(Ruby 3.0〜4.1・組み込み+標準添付・bundled gem 除外)— 2026-09-05

## 方法

- doctree master 948a607c3 の版別 DB(3.0〜4.1)から全メソッドエントリを抽出し、実 Ruby と双方向に突き合わせた
  - 過剰= DB にあるが実 Ruby に無い(probe: 各ライブラリを require して method_defined? 判定)
  - 不足= 実 Ruby にあるが DB に無い(ライブラリごとに require 前後の差分ダンプ+組み込みは --disable-gems ダンプ)
- 実測環境= x.y.0 タグ(all-ruby docker: 3.0.0/3.1.0/3.2.0/3.3.0/3.4.0/4.0.0)+ 4.1= `ghcr.io/ruby/ruby:master`(2026-09-04 07ef97df22・json 3.0.0.rc1)
- bundled gem の判定= tools/library-versions/matrix-libs.tsv の版別種別(B)。対象= その版で lib/ext/default gem かつメソッドエントリを 1 件以上持つライブラリ
- スクリプト= `tools/`(extract_db.rb → gen_inputs.rb → measure.sh/dump_all.rb(+measure2.sh/dump_all_pre.rb)→ compare_mc.rb → aggregate_mc.rb)。結果= `result/<版>/{excess,summary-by-lib}.tsv`・`result/matrix-excess.tsv`・`result/matrix-shortage.tsv`(ファイル構成は README 参照)

## 版ごとの件数(メソッドのみ・定数/特殊変数は除外)

| 版 | 対象 lib 数 | DB メソッド数 | 組み込み 過剰 | 組み込み 不足 | 標準添付 過剰 | 標準添付 不足(文書済みクラス) | 〃 stub クラス | 〃 未文書クラス | 未測定 |
|---|---|---|---|---|---|---|---|---|---|
| 3.0 | 212 | 8195 | 15 | 6 | 185 | 1942 | 109 | 2709 | 352 |
| 3.1 | 200 | 8135 | 15 | 12 | 205 | 1904 | 106 | 2875 | 226 |
| 3.2 | 199 | 8200 | 24 | 12 | 203 | 1977 | 111 | 2970 | 222 |
| 3.3 | 196 | 8262 | 26 | 12 | 199 | 1992 | 124 | 6004 | 222 |
| 3.4 | 164 | 8300 | 28 | 13 | 220 | 2009 | 122 | 5298 | 200 |
| 4.0 | 111 | 8196 | 27 | 12 | 148 | 1054 | 100 | 4370 | 70 |
| 4.1 | 109 | 8060 | 18 | 55 | 169 | 1088 | 100 | 4390 | 26 |

- 「不足」は public/protected のみ。private(約 1,200〜1,400/版)・別名の片側だけ未記載(約 40)・親クラス側で記載済み(約 1,000〜2,900)・`_foo` 形の生成メソッド(約 280)は別集計で除外
- 3.4/4.0 で対象 lib 数が減るのは多数のライブラリが bundled 化されたため(除外側へ移動)
- 未測定= debug(対話開始)・win32ole/win32(Windows 専用)は常時スキップ。3.0 は fiddle/dbm の .so 依存欠落(87+38)。4.1 は json/add/*(json 3.0 で削除)

## 過剰(版横断のユニークキー: 組み込み 30・標準添付 209)

### 組み込み 30 → 実質の候補は 2 件

- 文書慣例(削除不要)17: プロトコル記述(`Class#_load`・`Object#_dump`・`Object#marshal_dump/marshal_load`・`Numeric#/`)、サブクラス側に定義される `Data.new/[]/members`・`Struct.[]/members/keyword_init?`、`Thread.DEBUG/DEBUG=`(デバッグビルドのみ)、`Process::Sys.issetugid/setrgid/setruid`(プラットフォーム)
- 環境起因 12: `RubyVM::YJIT.*` 10(all-ruby の 3.2〜4.0 は YJIT 非ビルド。master では存在)・`File.lchmod`(3.0 のみ)・`File::Stat#birthtime`(Linux は 4.0 から)
- **候補**: `ObjectSpace._id2ref`(master で削除→ 4.1 の until 候補)・`Random::Formatter#alphanumeric`(require 'random/formatter' が必要なのに _builtin に記載)

### 標準添付 209 → 内訳

| 分類 | 件数 | 内容 |
|---|---|---|
| until 候補(新版で消えた) | 33 | **4.0 で消滅(4.0.0 で実測確認)**: `IO#nread`・`IO#ready?`(io/wait)・`Class#json_creatable?`・`Gem::Platform.match`・`Gem::Installer#unpack`・`Gem::DependencyInstaller#find_gems_with_sources`。**3.4 から**: `Gem::Installer.path_warning(=)`。**4.1(master・json 3.0.0.rc1)**: json 22 件(`JSON.fast_generate/unparse/restore/create_id(=)`・`Kernel#j/jj`・`JSON::State#[]/[]=`・`GeneratorMethods::*#to_json` の再編)・`Socket.gethostbyaddr/gethostbyname`・`TCPSocket.gethostbyname`。`OpenSSL::Engine` 14 は 3.1 以降で no-class(OpenSSL 3 系ビルド依存) |
| since 候補(旧版に無い) | 5 | `CSV::Row#deconstruct/deconstruct_keys`(3.1 に無い)・`OpenSSL::Random.pseudo_bytes`(3.0〜3.4 に無く 4.0 で復活)・`Prism::Node#each_child_node`・`Prism::Source#byte_offset`(4.1 から) |
| 全版 stale(rubygems/rdoc 内部) | 57 | 3.0 以前に消えた内部 API(`Gem::SpecFetcher#fetch` 系 9・`Gem::Security.build_cert` 系 7・`RDoc::TopLevel.find_class_named` 系 7 ほか) |
| 全版 その他 | 39 | OpenSSL 1.0 系向け PKey setter 17(`RSA#n=` 等)・`CGI::QueryExtension::Value` 6(no-class)・`CGI::Html*#element_init` 4・`DateTime.today`・`Net::HTTPHeader#method`・`Net::HTTPResponse#reader_header`・`Kernel#y`(psych)・`Zlib::GzipFile#path`・`Singleton.instance`/`Prism::Node#copy` 等の慣例記述 |
| 環境起因 | 75 | システム OpenSSL 3 依存(Engine/Digest::MD2 等・egd)31・yaml/dbm 22(dbm gem 不在)・`Etc::Passwd` BSD フィールド 12・readline 6(libedit)・SOCKSSocket 等 4 |

## 不足(版横断のユニークキー)

### 組み込み: 公開メソッド 58(うちリリース済み版 16)+ 未文書クラス 36

- リリース済み版(3.0〜4.0)16 件は大半がデバッグ/開発用: `GC.verify_internal_consistency`・`GC.verify_transient_heap_internal_consistency`・`GC.using_rvargc?`・`RubyVM::YJIT.simulate_oom!`・`RubyVM::InstructionSequence.compile_prism/compile_file_prism/compile_parsey`・同 `#each_child/#trace_points/#script_lines`・`RubyVM.keep_script_lines(=)`・`Process::Tms.inspect`・`Random::Formatter#random_number`・`Class.allocate`・`Set#flatten_merge`(protected)
- 4.1(master)新規 42: `String#bit_count/bitwise_and(!)/…` 14・`Method/Proc/UnboundMethod/Thread::Backtrace::Location#source_range・#syntax_tree` 9・`Range#clamp`・`Dir.scan/#scan`・`ENV.fetch_values`・`Integer#bit_count`・`IO::Buffer#bit_count`・`MatchData#integer_at`・`Module#descendants`・`Module#autoload_relative`/`Kernel.autoload_relative`・`Enumerator::Lazy#tap_each`・`Proc#refined`・`GC::Profiler.configure`・YJIT 4
- 未文書クラス 36: `Ruby::Box::Loader`(**4.0 に存在**・3)・`RubyVM::RJIT`(3.3・2)・4.1= `RubyVM::ZJIT` 11・`Thread::Monitor(::ConditionVariable)` 13・`Ruby::SourceRange` 6・`Enumerator::Producer#each`

### 標準添付(非 bundled・メソッド文書あり): 文書済みクラスの公開メソッド 1,580 + stub クラス 112 + 未文書クラス 5,105

- 1,580 の初出版別= 3.0 以前から 1,263 / **3.1: 52・3.2: 58・3.3: 44・3.4: 74・4.0: 34・4.1: 55(= 版追随漏れ 317)**
- ライブラリ別(上位): cgi/html 241(`CGI::Html3/Html4/Html4Tr` の要素メソッド= 生成物)・openssl 137(`OpenSSL.secure_compare`・`Cipher#auth_tag` 系・`BN#mod_sqrt` 等= 公開 API)・rubygems 系 約 500(`Gem` 98・`Gem::Specification` 97・`Gem::Package` 35・`Gem::Installer` 28…)・psych 74(`Psych.safe_dump/unsafe_load/add_tag/Nodes::Node#start_line` 等)・net/imap 62(3.0 のみ= 0.1 系の Struct setter)・prism 60・net/http 49(`#min_version/#max_version/#ignore_eof/#response_body_encoding/.post/.put` 等)・uri 37・resolv 32・optparse 28・io/console 24(`cursor` 系)・ostruct 21(`foo!` 生成)・json 19・ipaddr 17(`link_local?/private?/loopback?` 等)
- 版追随漏れ 317 の内訳(版:lib(件)): 3.1= openssl 16・coverage 4・ipaddr 3・psych 3・uri 3/3.2= net/http 8・openssl 5・uri 4・rubygems/config_file 4/3.3= prism 18・tempfile 5・rubygems 5/3.4= prism 33・openssl 17・rubygems 8・net/http 5・ipaddr 4・json 3・socket 3・strscan 3/4.0= prism 5・rubygems/platform 5・psych 4・openssl 3・uri 3/4.1= rubygems/config_file 13・openssl 8・io/console 4・prism 4 ほか
- stub クラス 112(ページはあるがメソッド記載ゼロ): `JSON::Ext::Generator::State` 43・`OptionParser::Switch` 17・`Digest::Class/Instance` 8・`OpenSSL::PKey` 5・`IRB::Irb` 5・`FileUtils::Verbose/NoWrite/DryRun`(module_function 複製は親側記載として除外済み)
- 未文書クラス 5,105 は意図的な非掲載が大半: prism ノードクラス 3,831・rubygems 内部 789・forwardable 経由の帰属 421(委譲メソッドの帰属ノイズ)・ripper/sexp 189・resolv 148・reline 148

### 参考(集計対象外)

- bundled gem(その版で B): 公開メソッド不足 2,120・未文書クラス 3,262(csv/rexml/rss/minitest/test-unit/bigdecimal 等)。過剰 164
- メソッド文書のないページ(bundler・did_you_mean・error_highlight・rubygems/commands/* 等 85〜93 ページ)は「メソッド単位で書いているライブラリ」に該当しないため対象外(未文書クラス 4,440 相当)

## 注意(読むときの限界)

- 4.1 は master スナップショット(json 3.0.0.rc1 は RC)。json 系の until 候補はリリース版で再確認が必要
- all-ruby の 3.2〜4.0 は YJIT 非ビルド・readline は libedit・システム OpenSSL 3.0(Engine/MD2 等が無い)
- probe は `-n/-p` 限定の `Kernel.#chomp` 系・`$1` 等の特殊変数を判定できない(除外済み)。`Errno::EXXX` プレースホルダも除外
- 不足のライブラリ帰属は「DB でクラスを記載しているライブラリ → source_location の feature → クラス内多数派」の順の推定。forwardable/delegate 生成メソッドは前段で吸収済みだが未文書クラスでは残る
- 「存在する」= メソッド定義の有無のみ。引数追加などシグネチャ単位の差分は検出しない

## 追記(2026-09-16): ビルド環境依存の確認と 4.1 の再測定

- `ghcr.io/ruby/ruby:<版>`(YJIT/ZJIT 有効)と all-ruby の同じ teeny で 3.0〜4.0 を測り直した(README「ビルド環境依存の差分」・`result/env-diff/`)。
  ビルドで有無が変わるのは `RubyVM::YJIT`(3.2〜4.0)・`RubyVM::ZJIT`(4.0)・`Readline` の libedit 差(3.0〜3.2)・3.0 の fiddle だけ
- 上の「不足」で 4.1 新規に数えた YJIT 4 件と未文書クラスの `RubyVM::ZJIT` 11 件は訂正: YJIT の 4 件は 3.2〜3.3 から存在するが原典で `:nodoc:`、
  ZJIT は 4.0 から存在する(rurema にページが無い= 実際の不足)
- 4.1 は 2026-09-15 の master(0c3c61ca82)で組み込みを再測定したが、09-04 のスナップショットと差は無かった。
  4.1 新規 42 件(+ `Ruby::SourceRange`)は #3573、`Thread::Monitor` の組み込み化は #3574 で対応

## 追記(2026-10-03): 現 master での再測定

doctree master 1c1f6965c で再生成手順を再実行し、同梱データ(`db-extract/`・`real/`・`result/`)を置き換えた。
実 Ruby は 3.0.0〜4.0.0 が前回と同じバイナリで、4.1 は `ghcr.io/ruby/ruby:master` の 2026-10-03(088bf8962f・json 3.0.2・rubygems 4.1.0.beta1・rdoc 8.1.0)。
この追記より前の本文は 2026-09-05 のスナップショット(コミット 82aaea377)の数字のまま残している。
09-05 以降の対応(rurema/doctree#3548 に並ぶ各 PR)と、rurema/doctree#3566 の方針による `POLICY(...)` 分類の導入で、件数は次のように変わった。

### 版ごとの件数(09-05 → 10-03)

| 版 | DB メソッド数 | 組み込み 過剰 | 組み込み 不足 | 標準添付 過剰 | 標準添付 不足(文書済みクラス) | 〃 stub クラス | 〃 未文書クラス | 未測定 |
|---|---|---|---|---|---|---|---|---|
| 3.0 | 8195 → 8535 | 15 → 15 | 6 → 2 | 185 → 121 | 1942 → 1132 | 109 → 101 | 2709 → 1844 | 352 → 352 |
| 3.1 | 8135 → 8500 | 15 → 15 | 12 → 4 | 205 → 123 | 1904 → 1064 | 106 → 96 | 2875 → 1892 | 226 → 226 |
| 3.2 | 8200 → 8591 | 24 → 24 | 12 → 4 | 203 → 123 | 1977 → 1115 | 111 → 98 | 2970 → 1972 | 222 → 222 |
| 3.3 | 8262 → 8686 | 26 → 26 | 12 → 3 | 199 → 118 | 1992 → 1132 | 124 → 109 | 6004 → 2059 | 222 → 222 |
| 3.4 | 8300 → 8794 | 28 → 28 | 13 → 3 | 220 → 136 | 2009 → 1082 | 122 → 106 | 5298 → 2208 | 200 → 200 |
| 4.0 | 8196 → 8691 | 27 → 36 | 12 → 2 | 148 → 81 | 1054 → 382 | 100 → 82 | 4370 → 1224 | 70 → 70 |
| 4.1 | 8060 → 8571 | 18 → 30 | 55 → 13 | 169 → 83 | 1088 → 405 | 100 → 85 | 4390 → 1227 | 26 → 2 |

- 不足・stub・未文書クラスの減少には、記載を追加した分のほかに `POLICY(...)` へ移った分(cgi/html の要素メソッド・prism のノードクラスと Visitor 系・rubygems の内部クラス)が含まれる。
  4.1 の標準添付では generated(node) 1,108・generated(visitor) 1,784・internal 1,006(private を含む)
- 対象 lib 数が変わるのは 4.0(`io/wait` のエントリが無くなり −1)と 4.1(`io/wait` と、`until: "4.1"` にした json/add/* の 12 本で −13)だけ
- 組み込みの過剰が増えたのは測定上の理由。4.0 の +9 は追加した `RubyVM::ZJIT` の 9 件(all-ruby が ZJIT 非対応ビルド。`ghcr.io/ruby/ruby:4.0.7` には存在)。
  4.1 の +12 は、`IO::Buffer` の 8 件(master 側の再編。下記)と `Thread::Monitor` の `mon_enter` などの別名 5 件(`--disable-gems` で測るため。`require "monitor"` 後は存在)が増え、
  `ObjectSpace._id2ref` の 1 件が解消した結果
- 4.1 の未測定 26 → 2 は json/add/* を `until: "4.1"` にした分(残り 2 は win32/resolv)

### ユニークキー(版横断)

- 標準添付の不足(文書済みクラスの公開メソッド): 全版で不足のキー 1,580 → 578。一部の版だけ不足のものを含めると 1,613 → 590。
  解消した 1,034 = 記載を追加 581・`POLICY` 451(cgi/html の要素メソッド 238・rubygems の内部クラス 213)・その他 2
- 残り 590 の主なもの: rubygems 系 255(`Gem::Specification` 66・`Gem` 63・`Gem::ConfigFile` 46・`Gem::Package` 46 ほか)・net/imap 62(3.0 のみ)・irb 系 54(3.x のみ)・
  psych 44・resolv 35・uri 26・ostruct 21(3.0〜3.1)・net/http 13・optparse 12・json 10・open-uri 10。
  rurema/doctree#3566 で判断待ちの `Gem::ConfigFile`・`Gem::Package` と 4.1 の新規を除くと、各 PR で載せない判断をしたもの(`:nodoc:`・protected・内部用・生成物)が中心
- stub クラス: 112 → 96 キー(13 クラス)。`JSON::Ext::Generator::State` の 47 は別名クラス側で数えられる見かけ上のもので、43 件は `JSON::State` に記載済み(残り 4 件は 4.1 の新規)。
  `OptionParser::Switch` 17 は対象外にしたもの。それ以外の 32 キー(`Digest::Class`/`Digest::Instance` 8・`IRB::Irb` 5・`Resolv::DNS::Resource::Generic` 5 など)は未着手
- 組み込みの不足: 公開メソッド 58 → 15・未文書クラス 36 → 6。残り 21 = 意図的に載せていないもの 11(rurema/doctree#3568 で対象外にした 4 件と、原典で `:nodoc:` の 7 件)・
  `Ruby::Box::Loader` 3(原典で `:nodoc:`)・`RubyVM::RJIT` 2(3.3〜3.4)・master で増えた 5
- 過剰: 403 → 323 行(同じメソッドがライブラリ名違いで 2 行になる重複を除くと 391 → 322)。108 件が解消し、39 件が新しく出た。
  39 件のうち 28 件は環境・測定条件によるもの(`RubyVM::ZJIT` 9・Windows 専用の io/console 7・libedit ビルドの `Readline` 7・`Thread::Monitor` の別名 5)、
  10 件は master 側の変化(`IO::Buffer` 8・rdoc の 2)、1 件は版ゲート漏れ(`RDoc::Parser::Simple#remove_private_comment`)

### 残っている候補

- `Set#eql?`(3.x では `==` と別実装・4.0 で別名化)の項目追加、`OpenSSL::Random.pseudo_bytes`(3.0〜3.4 に無く 4.0 で復活)の扱い
- rdoc の過剰 48 件(scope は bundled)。3.0.0〜master のどの版にも無いもの 35 件(`RDoc::Options` 14・`RDoc::Stats` 7・`RDoc::Markdown` 6・`RDoc::Markup` 3・`RDoc::CodeObject` 2・`RDoc::Parser` 2・`RDoc::Parser::C` 1)、
  3.4.0(rdoc 6.10.0)にあり 4.0.0(rdoc 7.0.3)に無いもの 7 件、4.0.0 にあり master(rdoc 8.1.0)に無いもの 6 件
- json: `String.json_create`・`String#to_json_raw`・`#to_json_raw_object` は json 2.14.0 から `json/add/string` を読み込んだときだけ定義される。
  4.0(json 2.18.0)では `require "json"` だけでは定義されず、`json/add/string`(4.0 だけに存在)のページが無い
- 4.1 の master が 09-15 から進んだ分(リリース版で再確認が必要): `IO::Buffer` の再編(`IO::Buffer.new` が `IO::Buffer::Storage` を返し、`free`・`resize`・`transfer`・
  `external?`・`internal?`・`mapped?`・`shared?`・`private?` の定義が `IO::Buffer::Storage` に移動。`IO::Buffer::Slice` は `resize` だけ。`IO::Buffer#advance`・`#source` を追加)、
  `Enumerator::Lazy#each_with_index`、`RubyVM::YJIT.max_compile_time_ns`・`.max_compile_time_ns=`・`.total_compile_time_ns`、`JSON::State#rfc8785?`・`#rfc8785=`、
  RubyGems 4.1.0.beta1 の `Gem.ruby_abi`・`Gem::Specification#ruby_abi`・`#content_address`・`#content_address=` など
- `IO::Buffer::Storage`・`IO::Buffer::Slice`・`Enumerator::Lazy#each_with_index` は祖先クラスの記載に隠れて集計の「不足」に現れない(README「既知の限界」)。
  4.1 の `real/4.1/builtin.tsv` を前回と比べて拾った

## 追記(2026-10-10): 現 master での再測定(2 回目)

doctree master aa88f1b72 で再生成手順を再実行し、同梱データ(`db-extract/`・`real/`・`result/`)を置き換えた。
実 Ruby は 3.0.0〜4.0.0 が前回と同じバイナリで、4.1 は `ghcr.io/ruby/ruby:master` の 2026-10-09(a9d3eadfc8・json 3.0.2・rubygems 4.1.0.beta2・rdoc 8.1.0)。
10-03 の再測定以降の対応(rurema/doctree#3604〜#3627 のうちメソッドの有無に関わるもの)で、件数は次のように変わった。

### 版ごとの件数(10-03 → 10-10)

| 版 | DB メソッド数 | 組み込み 過剰 | 組み込み 不足 | 標準添付 過剰 | 標準添付 不足(文書済みクラス) | 〃 stub クラス | 〃 未文書クラス | 未測定 |
|---|---|---|---|---|---|---|---|---|
| 3.0 | 8535 → 8585 | 15 → 15 | 2 → 2 | 121 → 85 | 1132 → 1075 | 101 → 101 | 1844 → 1844 | 352 → 352 |
| 3.1 | 8500 → 8552 | 15 → 15 | 4 → 4 | 123 → 87 | 1064 → 1005 | 96 → 96 | 1892 → 1892 | 226 → 226 |
| 3.2 | 8591 → 8643 | 24 → 24 | 4 → 4 | 123 → 87 | 1115 → 1056 | 98 → 98 | 1972 → 1972 | 222 → 222 |
| 3.3 | 8686 → 8740 | 26 → 26 | 3 → 3 | 118 → 82 | 1132 → 1073 | 109 → 109 | 2059 → 2059 | 222 → 222 |
| 3.4 | 8794 → 8850 | 28 → 28 | 3 → 3 | 136 → 100 | 1082 → 1021 | 106 → 106 | 2208 → 2208 | 200 → 200 |
| 4.0 | 8691 → 8740 | 36 → 36 | 2 → 2 | 81 → 79 | 382 → 338 | 82 → 82 | 1224 → 1224 | 70 → 70 |
| 4.1 | 8571 → 8621 | 30 → 30 | 13 → 10 | 83 → 83 | 405 → 356 | 85 → 85 | 1227 → 1220 | 2 → 2 |

- 標準添付の過剰: 3.0〜3.4 の −36 は、どの版にも無い rdoc の 35 件(rurema/doctree#3605。rdoc は 3.x では標準添付)と `OpenSSL::Random.pseudo_bytes`(rurema/doctree#3618)。
  4.0 の −2 は `String#to_json_raw`・`#to_json_raw_object`(rurema/doctree#3604)。4.1 は変わらず(`IO::Buffer` の 8 件は別 PR で対応中)。
  bundled 側(参考)では rdoc の 48 件がすべて解消した(rurema/doctree#3605・#3612・#3615)
- 標準添付の不足: 解消したキーは `Gem::ConfigFile` 30・`Gem::Package` 19(rurema/doctree#3613)と `String.json_create`(rurema/doctree#3604)の 50。
  版ごとの減り方(−44〜−61)の差は、キーが存在する版の数の違い
- 組み込みの不足: 4.1 の 13 → 10 は `RubyVM::YJIT.max_compile_time_ns`(`=`)・`.total_compile_time_ns`(rurema/doctree#3626)。
  残りの 10 件は、意図的に載せていないもの 8(rurema/doctree#3568 で対象外にした `Class.allocate`・`Process::Tms.inspect`、原典で `:nodoc:` の `RubyVM::YJIT` の 5 件と `RubyVM::ZJIT.assert_compiles`)と、
  4.1 の再編で追加された `IO::Buffer#advance`・`#source`(別 PR で対応中)。未文書クラスは `RubyVM::RJIT`(rurema/doctree#3619)が解消し、
  残りは `Ruby::Box::Loader` の 3 件(原典で `:nodoc:`)と `Enumerator::Producer#each`
- 4.1 の未文書クラスの −7 は、rinda の `Rinda::TupleBag::TupleBin` の 7 件が標準添付側から bundled 側の集計に移った分(分類の移動で、記載の変化ではない)
- 未測定は実測データが同じなので変わらない(標準添付の `unmeasured(require-failed)` と `unmeasured(skipped-lib)` の合計)

### ユニークキー(版横断)

- 過剰: 323 → 272 行(同じメソッドがライブラリ名違いで 2 行になる重複を除くと 322 → 271)。51 件が解消し、新しく出たものは無い。
  内訳は rdoc 48・`OpenSSL::Random.pseudo_bytes`・`String#to_json_raw`/`#to_json_raw_object`
- 標準添付の不足(文書済みクラスの公開メソッド): 全版で不足のキー 578 → 528。一部の版だけ不足のものを含めると 590 → 540。
  残りの主なもの: rubygems 系 206(`Gem::Specification` 66・`Gem` 63・`Gem::Package` 27・`Gem::ConfigFile` 16・`Gem::Dependency` 11 ほか)・net/imap 62(3.0 のみ)・irb 系 54(3.x のみ)・
  psych 44・resolv 35・uri 26・ostruct 21(3.0〜3.1)・net/http 13・optparse 12・open-uri 10・json 9。
  いずれも各 PR で載せない判断をしたもの(`:nodoc:`・protected・内部用・生成物。理由は各 PR 本文)か、4.1 の未リリース分
- stub クラス: 96 キー(13 クラス)で変わらず
- 組み込みの不足: 公開メソッド 15 → 12・未文書クラス 6 → 4(上記)
- 4.1 の master が 10-03 から進んだ分: 組み込み(`--disable-gems` で観測したクラス・メソッド一覧)は 10-03 のスナップショットと差が無かった。
  標準添付で新しく出たのは `JSON::Ext::Generator::State.rfc8785_number_formatter_proc=`(json master の RFC 8785 対応。json gem は 3.0.2 が最新で未リリース)と、
  bundler の 5 件(`Bundler::Override` ほか。bundler はメソッド文書のないページ)

### 残っている候補

- `IO::Buffer::Storage`・`IO::Buffer::Slice`(4.1 の再編)と `IO::Buffer#advance`・`#source`: ページ追加と 8 件の振り分けを別 PR で対応中。master の NEWS.md には未記載なので、リリース版で再確認が必要
- `JSON::State#rfc8785?`・`#rfc8785=`・`JSON::Ext::Generator::State.rfc8785_number_formatter_proc=`: ruby/json#1091(2026-10-02 マージ)が ruby master に同期されたもの。json 3.1 のリリース後に対応
- RubyGems 4.1.0.beta2 の `Gem.ruby_abi`・`Gem::Specification#ruby_abi`・`#content_address`(`=`)など: 4.1 リリース後
- `Ruby::Box::Loader`(4.0 から・原典で `:nodoc:`): 他の `:nodoc:` のメソッドと同じく載せない

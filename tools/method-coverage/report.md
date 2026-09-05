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

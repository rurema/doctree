# 標準添付ライブラリ ファイル・メソッドレベルチェック 結果(2026-08-28)

対象: doctree の非 _builtin ライブラリページ(各版有効 327〜336 ページ・メソッドエントリ名 約 8,000/版)。
実測: require 可否スイープ+エントリ駆動プローブを 3.0.7/3.1.7/3.2.11(all-ruby)+3.3.12/3.4.8/4.0.6(ローカル)で実施。
ツリー裏取り: ruby/ruby 7 ref の lib/ext 再帰ツリー+bundled gem リポジトリのピン版ツリー(gh api)。
4.1(master)はツリー判定のみ(バイナリなし= method-versions と同じ制約)。

## 更新(2026-08-31): 修正適用後の再採取

以下の A/B の分析本文は 2026-08-28 の初回採取(修正前)に基づく調査記録で、
発見はすべて doctree #3514〜#3531 で対応済み。同梱データは修正マージ後の
master 9c18dceb5 で再採取した版(doctree 側抽出・sweep・probe・集計を再実行。
ソースツリー系スナップショットは Ruby 側不変のため 08-28 のまま)。主な変化:

- mismatch-matrix: 709 → 630 エントリ。残りは platform-const 309(socket/etc)と
  環境起因・既知の偽陰性(rss/mutex_m の no-class・yaml/dbm・readline・
  システム OpenSSL 依存= B-1 参照)が中心
- findings: A 残= set(3.2〜3.4)のみ・B 残= thread(墓標として妥当= A-3)のみ
- 残課題(改名修正でクラス解決が通り新たに可視化):
  `JSON::Ext::Generator::GeneratorMethods::String#to_json_raw`/`#to_json_raw_object`
  が 4.0 で no-method(until 候補・要精査)。なお同系エントリの 3.4 列の
  no-class はローカル json ドリフト起因(README の既知の限界参照)
- 修正前後の全差分は、本ディレクトリを追加した初回コミットとの diff を参照

## 測定の信頼性メモ

- 4.0.6 ローカルの bundled gem はピン版と完全一致(検証済み)。3.4.8 は minitest 6.0.x・net-imap 0.6.2 など**ピンより新しい gem が混入**= 3.4 の bundled gem 境界判定には使わない(3.3 と 4.0 で挟む)
- all-ruby(3.0〜3.2)には bundled gems が無い= その版の bundled ライブラリはメソッド未測定(lib-require-failed として除外済み)
- readline の 3.0〜3.2 NG は all-ruby の libedit ビルド起因= 環境要因(3.3+ は reline ラッパで全 API あり)
- master は json・psych の Ruby ソースをツリー非同梱化(ビルド時取得へ変更)→ ツリー判定不能。4.0 実測 ok なので問題なし扱い。**副作用: en rdoc(master)から JSON/Psych のページが消えている可能性**(rdoc はツリーしか走査しない)
- mixin 提供型(Mutex_m の lock 系= append_features で include 先に別名定義)はプローブでは検出不能= **文書は正しい**(mutex_m 5 行は非問題と判定)

## A. ファイルレベルの発見

### A-1. 全版(3.0〜4.1)でファイル不在= 削除候補(#3510/#3515 と同型)— 25 ページ
- rubygems 古代内部 20: builder, custom_require, digest/digest_adapter, digest/md5, digest/sha1, digest/sha2, doc_manager, format, gem_openssl, gem_path_searcher, old_format, package/f_sync_dir, package/tar_input, package/tar_output, require_paths_builder, source_index, source_info_cache, source_info_cache_entry, test_utilities, timer(RubyGems 2.0 時代=2013 年に削除された内部)
- rake 旧 4: classic_namespace, gempackagetask, rdoctask, runtest(rake 13.0.3〜13.4.2 の全ピン版ツリーで不在確認)
- json/editor(json 2.x で削除)

### A-2. 版境界の until 候補
- **until "4.0"**: cgi/cookie, cgi/core, cgi/html, cgi/session, cgi/session/pstore(cgi 4.0 縮退。残存は cgi.rb+escape/util のみ。**cgi.md 本文の縮退対応も必要**+cgi/cookie.md には `httopnly` タイポ 2 箇所= 185/190 行)/minitest/mock, minitest/unit(minitest 6.0.0 で mock.rb・unit.rb 消滅= ピン一致環境で確認。spec.rb は残存)/rubygems/commands/query_command
- **until "3.3"**: rubygems/indexer(ゲートなし)+ **irb 7 ページの until "3.4"→"3.3" 修正**(irb/cmd/{chws,help,load,pushws,subirb}, irb/ext/save-history, irb/extend-command= irb 1.8/1.11 でファイル消滅済みなのに 3.3 で有効)
- **until "4.1"(4.1 対応時)**: net/ftp, net/pop(既知)+ rdoc/parser/ruby_tools(rdoc 8.0.0 で削除)
- **rdoc 内部 14 ページ= 3.3 でファイル消滅**(alias, anon_class, any_method, attr, class_module, constant, context, ghost_method, include, meta_method, normal_class, normal_module, require, single_class, top_level)。rdoc 6.x で `rdoc/code_object/` 配下へ移動= クラス自体は現存。**until か改名(新パスへページ移動)かは編集判断**
- irb/cmd/nop: ファイルは互換 shim として全版残存だが、クラス IRB::ExtendCommand::Nop は 3.3 で消滅(IRB::Command 系へ改名)→ 版対応要

### A-3. 問題なしと確定
- win32/registry, win32/resolv, win32ole: 全版ツリー実在(Linux で測定不能なだけ)
- thread: 墓標ページとして妥当・rdoc/rdoc.lib: 偽陽性(name: rdoc/rdoc、rdoc 8 にも実在)・json/add/* 13 ページ: 全版 ok
- 単体 require 不可(err:NameError 系 約 40〜57/版): rdoc/rubygems の内部ページでファイルは実在(rubygems/package/tar_header 等)。単体 require 想定でない構造の情報のみ

## B. メソッドレベルの発見(問題 709 エントリ名の分類)

### B-1. 環境・プラットフォーム起因= 非問題(約 350)
- socket 定数 304+etc 定数 5(プラットフォーム依存・rurema は網羅主義)/Etc::Passwd の BSD 系フィールド 12+Socket::Ifaddr#vhid/yaml/dbm 23(dbm gem 不在)/readline 6(libedit)/mutex_m 5(mixin 機構)

### B-2. since バッジ漏れ(旧版に無い)
- **prism 7**: Prism::Node の accept/child_nodes/comment_targets/compact_child_nodes/deconstruct/type/.type = 3.3 に無く 3.4+ にあり → `{: since="3.4"}` 候補

### B-3. until バッジ漏れ・API 削除(新版に無い)
- **openssl**: OpenSSL::Config#[]=/add_value/section/value= 3.1 以降なし(until "3.1" 候補)
- **net/smtp 4**: Net::SMTP::Revision, #auth_cram_md5, #auth_login, #auth_plain = 3.3 以降なし
- **strscan 5**: StringScanner#clear/empty?/getbyte/peep/restsize = 3.4 以降なし(旧別名の削除。default gem なので 3.4 測定は信頼可)
- **net/imap 4**: client_thread(=), max_flag_count(=) — 境界はピン汚染のため要精査(4.0 では確実に無い)
- rubygems 旧 API 群(specification 中心に 22 行)= 個別精査の上 until/削除
- irb/cmd/nop 4(クラス改名に伴う)

### B-4. クラス名変更・文書構造の更新候補(renamed-class 77)
- **rss 59**: DublinCoreModel→RSS::DublinCoreModel(45)/RSS::RDF::Channel::ImageFavicon→RSS::ImageFaviconModel::ImageFavicon(8)/RSS::Rss::Skip{Days,Hours}→RSS::Rss::Channel::Skip{Days,Hours}(6)
- **rake 9**: Kernel#task/desc/file 等 → 実体は Rake::DSL(rake 0.9=2011 から)
- **json 9**: JSON::Generator::GeneratorMethods::X#to_json → 現在は Array/Hash 等コアクラスへ直接 include

### B-5. その他の実文書バグ
- **cgi/cookie.md: `httopnly`/`httopnly=` タイポ**(正: httponly)— 実測+原文確認済み
- bigdecimal 3: save_exception_mode 等がインスタンスメソッド表記(実際は特異メソッド)
- psych: Kernel#y は require "psych/y" が必要(文書の require 案内確認)
- rss の残 21(mixin 由来を含む)+openssl の Digest DSS/DSS1/MD2/MDC2/SHA・Engine・EGD 系= **システム OpenSSL 依存の消滅**(Ruby 版でなく OpenSSL 3 環境で消える)→ 版ゲートでなく記述の編集判断

## データ

本ディレクトリに同梱(構成と再生成手順は [README.md](README.md))。
`always-ng-triage.*`・`boundary-report.md` は 2026-08-28 調査時の記録。

# rurema ライブラリページ require ファイル存在確認 データ収集メモ

収集日: 2026-08-28。取得元: GitHub API(`gh api`, api.github.com のみ、GET のみ)。

## 1. ruby/ruby lib/ext ツリー(7 ref)

| doctree 版 | ref | root tree sha | lib subtree sha | ext subtree sha | lib truncated | ext truncated |
|---|---|---|---|---|---|---|
| 3.0 | `v3_0_7` | 2ae09e6... | 768b9fc5... | 94dac3f9... | false(971行) | false(698行) |
| 3.1 | `v3_1_7` | a3ef114... | c29008b5... | 7de83136... | false(966行) | false(696行) |
| 3.2 | `v3_2_11` | c7649f8... | ce44b74b... | a1811592... | false(1022行) | false(698行) |
| 3.3 | `v3_3_12` | b7f5428... | 7226e116... | 1617393d... | false(1121行) | false(705行) |
| 3.4 | `v3_4_10` | 15b26c2... | 32710b69... | ea479dff... | false(1106行) | false(670行) |
| 4.0 | `v4.0.6`(ドット形式) | fefa2366... | e5924877... | 8be45e82... | false(771行) | false(634行) |
| master(=4.1) | `master` | 859b2009... | 451d17ff... | 8f98ffb4... | false(731行) | false(643行) |

7 ref × 2(lib/ext)= 14 ツリーとも `truncated: false`(GitHub API の recursive tree は 10 万エントリ/7MB 超で truncate されるが、いずれも大きく下回る)。保存先: `github/<ver>-lib-files.txt` / `github/<ver>-ext-files.txt`(ver は表記どおり `3.0`〜`4.0`, `master`)。タグ対応は既存メモ([builtin-method-versions 系の既存調査](../lib-check/ruby-stdlib/notes-ruby-stdlib.md) §1)と同一のものを再利用(取り直し不要と確認済み)。

## 2. 4.1(master)の判定(`github/tree-4.1.tsv`、328 件)

**内訳: yes=259 / no=69**。

判定パス:
1. `lib/<name>.rb` 完全一致 → yes(where=lib)
2. ext 側で `<name>/` プレフィクス配下に `extconf.rb` か `*.c` が直接ある → yes(where=ext)
3. ext 側で `.../lib/<name>.rb` サフィックス一致(io/console 型のデフォルト gem 同梱 pure-ruby ファイル。例: `ripper/lib/ripper/filter.rb` → `ripper/filter`)→ yes(where=ext)
4. 1〜3 で見つからない場合、name を bundled_gems 名に変換(先頭セグメント or 全パスの `/`→`-`)して該当 gem があれば、そのバージョンのタグ(`v<version>` 優先、無ければ裸 `<version>`、rdoc/irb は bundled_gems.txt 記載の明示コミットハッシュを使用)で gem リポジトリの `lib/` 再帰ツリーを取得し `<name>.rb` の有無を確認 → yes/no(where=`gem:<gem>@<ref>`)
5. bundled_gems にも該当なし → no(全ツリー・全 bundled gem 候補で未発見を確認した上で no と判定)

**master 向けに追加取得した bundled gem リポジトリ = 35 個**(`github/gem-<gemname>-files.txt`、全て `lib/` サブツリーの再帰取得。パスはすべて gem の `lib/` を基準とした相対パス、つまり `rexml.rb` は gem の `lib/rexml.rb` を指す点に注意): abbrev, base64, benchmark, bigdecimal, csv, drb, fiddle, getoptlong, irb, logger, matrix, minitest, mutex_m, net-imap, net-smtp, nkf, observer, ostruct, power_assert, prime, pstore, racc, rake, rdoc, readline, reline, resolv-replace, rexml, rinda, rss, syslog, test-unit, tsort, win32-registry, win32ole。全 35 件 `truncated: false`。解決ログ= `github/gem-resolution-4.1.log`。

### タグ解決でハマった点
- **`test-unit`(test-unit/test-unit)と `rss`(ruby/rss)は `v<version>` 形式のタグが存在せず、裸の `<version>`(`3.7.8` / `0.3.3`)がタグ名**。最初 `v3.7.8`/`v0.3.3` で試みて 404(gh api がエラー JSON 本文を stdout に返し、`--jq .commit.tree.sha` が拾えず変数に生 JSON が入るバグを誘発 → シェルスクリプトを sha 形式(40 桁 16 進)の正規表現検証に修正して対処。**メモリの教訓([gh api の --jq は 404 のエラーボディにも適用](../../../.claude/projects/-home-debian-rurema/memory/MEMORY.md)としての一般化) は 40 桁 hex 検証で確実に弾ける**)。
- `rdoc`(8.0.0)・`irb`(1.18.0)は `master-bundled_gems.txt` に明示コミットハッシュが付いており、それをそのまま `repos/<repo>/commits/<hash>` で解決(タグ探索不要)。
- gem の `lib/` 再帰ツリーは「`lib/` サブツリー自体のルート」から取得しているため、収録パスに `lib/` プレフィックスが付かない(例: `rexml/document.rb` = gem の `lib/rexml/document.rb`)。判定スクリプトはこれを前提に `<name>.rb`(prefix なし)で照合。**初回実装でこれを見落とし、全件 `lib/<name>.rb` で誤照合して全部 no になるバグを起こし、修正して再実行した**(重要な自己チェックポイント)。

### 4.1 で no になった 69 件の内訳と根拠
- **rdoc 内部 API のリネーム/再編(17 件)**: `rdoc/alias, rdoc/anon_class, rdoc/any_method, rdoc/attr, rdoc/class_module, rdoc/constant, rdoc/context, rdoc/ghost_method, rdoc/include, rdoc/meta_method, rdoc/normal_class, rdoc/normal_module, rdoc/parser/ruby_tools, rdoc/rdoc.lib, rdoc/require, rdoc/single_class, rdoc/top_level`。rdoc 8.0.0(未リリース開発版・commit a9ebd59)で多数のクラスが `rdoc/code_object/*.rb` 配下に移動済み(例: 旧 `rdoc/alias.rb` → `rdoc/code_object/alias.rb`)。旧パスでの `require` は失敗する。
- **RubyGems の廃止済み内部ファイル(22 件)**: `rubygems/builder, rubygems/commands/query_command, rubygems/custom_require, rubygems/digest/digest_adapter, rubygems/digest/md5, rubygems/digest/sha1, rubygems/digest/sha2, rubygems/doc_manager, rubygems/format, rubygems/gem_openssl, rubygems/gem_path_searcher, rubygems/indexer, rubygems/old_format, rubygems/package/f_sync_dir, rubygems/package/tar_input, rubygems/package/tar_output, rubygems/require_paths_builder, rubygems/source_index, rubygems/source_info_cache, rubygems/source_info_cache_entry, rubygems/test_utilities, rubygems/timer`。master の `lib/rubygems/` (250 ファイル)を全数確認済みで該当なし。RubyGems の古いバージョン(0.9 系以前)由来の内部実装で、現行 RubyGems では削除済み。
- **JSON の `add`/`editor`(13 件)**: `json/add/bigdecimal, json/add/complex, json/add/core, json/add/date, json/add/date_time, json/add/exception, json/add/ostruct, json/add/range, json/add/rational, json/add/regexp, json/add/struct, json/add/symbol, json/add/time, json/editor`。**注意すべき方法論の限界**: json はデフォルト gem だが、ruby/ruby の `ext/json/lib/` にはブート用の最小構成(`json.rb, json/common.rb, json/ext.rb, json/ext/generator/state.rb, json/version.rb`)しか同梱されておらず、`add/`・`editor.rb`・`pure/` 等は一切無い(本家 ruby/json gem のフル配布物には存在する可能性が高いが、bundled_gems.txt には json 自体が載っておらず本タスクの照合方法では確認できない)。**つまりこの 13 件は「ruby/ruby ソースツリー+bundled gem リポジトリ」という調査方法の対象範囲外にあり、実際にインストールされた Ruby で動くかどうかとは別の話** — 要注意点として明記。
- **rake の廃止済みレガシーファイル(4 件)**: `rake/classic_namespace, rake/gempackagetask, rake/rdoctask, rake/runtest`。rake 13.4.2 で確認、該当なし(3.0〜3.2 の古い rake バージョンでも同様に無し。§3 参照)。
- **minitest の廃止済み後方互換ファイル(2 件)**: `minitest/mock, minitest/unit`。minitest 6.0.6(ruby/minitest リポジトリ)で確認、該当なし(4系以降で削除)。
- **CGI の縮小(5 件)**: `cgi/cookie, cgi/core, cgi/html, cgi/session, cgi/session/pstore`。master の `lib/cgi/` は `cgi.rb, cgi/escape.rb, cgi/util.rb` の 3 ファイルのみ(+ ext/cgi/escape の C 拡張)。Session/Cookie/HTML ヘルパー相当のソースはツリー中に存在しない。
- **net-ftp / net-pop の完全撤去(2 件)**: `net/ftp, net/pop`。4.0 までは bundled gem だったが master の `bundled_gems` からもドキュメントからも削除済み(既知・[ruby-stdlib 調査](../lib-check/ruby-stdlib/notes-ruby-stdlib.md) §2 で既報告)。lib/ext どちらにも無く、bundled_gems にも無い。
- **その他の完全撤去(3 件)**: `net/telnet`(旧くから独立 gem 化され標準添付から外れたまま、どの版の bundled_gems にも一度も記載なし), `thread`(Thread 互換シムの `lib/thread.rb` は完全に削除済み、lib/ext 全域で該当ファイルなし), `xmlrpc`(default gem/bundled gem いずれの一覧にも一度も記載なし。標準添付から完全撤去)。

`cgi/*`(5 件)+ `json/add,editor`(14 件)+ `rake` レガシー(4 件)+ `minitest` レガシー(2 件)+ `net/ftp,net/pop`(2 件)+ `rdoc`(17 件)+ `rubygems`(22 件)+ その他(3 件)= **合計 69 件**(`tree-4.1.tsv` の no 件数と一致)。なお `kconv` は当初 gem 名変換ルールでは検出できず一時的に「不明」だったが、下記「特例判定」で `gem:nkf` 同梱と確認できたため最終的に **yes**(no のリストには含まれない)。

### 特例判定(自動照合ルールでは拾えず個別確認したもの)
- **`io/console/size` → yes(ext)**: 機械的な `^io/console/size/` プレフィックス一致も `.../lib/io/console/size.rb` サフィックス一致もしない。実ファイルは `ext/io/console/lib/console/size.rb`。`ext/io/console/extconf.rb` の `create_makefile("io/console")` を確認した上で、io-console 拡張のビルド規約(`ext/<target>/lib/X` → インストール後は `<targetの親>/X`、ここでは `io/` + `console/size.rb` = `io/console/size.rb`)から推定し yes と判定。実運用で `require 'io/console/size'` が機能することと整合。
- **`kconv` → yes(`gem:nkf@v0.3.0`)**: bundled_gems の gem 名変換(`kconv` 自体や `nkf` への変換)が一致しないため自動照合では検出できなかったが、nkf gem の `lib/` 再帰ツリーに `kconv.rb` が同梱されていることを確認(nkf.rb と並んで昔から一緒に配布されている)。名前が gem 名と無関係な数少ない例。
- **`rbconfig` → yes(実体は「ビルド時生成」で判断保留気味)**: 機械的な判定は `ext/rbconfig/sizeof/` に `extconf.rb` があることに引きずられて「`rbconfig/` プレフィックス一致」でマッチしていたが、これは `rbconfig` 自体の実体ではなく `rbconfig/sizeof` という別ユニットの副作用(疑似陽性)。実際には `rbconfig.rb` は `tool/mkconfig.rb` によりビルド時に生成される非コミットファイルで、リポジトリ全体(root tree recursive 検索)を検索しても `rbconfig.rb`/`rbconfig.rb.in` は存在しない。実際の Ruby インストールでは必ず生成されるため実用上は動くが、「lib/ext ツリーにソースがあるか」という本タスクの基準では「無い」が正確。**yes/no どちらとも言い切れない特殊ケースとして where 欄に注記した**(verdict は実用に寄せて yes、where で生成物であることを明記)。

## 3. 3.0/3.1/3.2 の bundled gem 配下ページ判定(`github/tree-bundled-<ver>.tsv`)

対象抽出は「active-<ver>.txt にある名前のうち、名前(先頭セグメント or 全パス `/`→`-`)がその版の `bundled_gems.txt` の gem 名に一致するもの」(= 各版 `<ver>.tsv` の `kind=bundled-gem` 行の実体となっている一覧と同一集合であることを確認済み。[ruby-stdlib 調査](../lib-check/ruby-stdlib/notes-ruby-stdlib.md) §4 参照)。

- 3.0: 26 件抽出(gem: minitest 5.14.2(**seattlerb/minitest**, まだ ruby/minitest に移管前), power_assert 1.2.1, rake 13.0.3, rexml 3.2.5, rss 0.2.9(タグは明示コミット `0.2.9`), test-unit 3.3.7)。**no は 4 件のみ**: `rake/classic_namespace, rake/gempackagetask, rake/rdoctask, rake/runtest`(rake 13.0.3 時点で既に削除済み=古い版でも無い)。
- 3.1: 32 件抽出(3.0 の gem 群 + matrix 0.4.2, net-ftp 0.1.4, net-imap 0.2.4, net-pop 0.1.1, net-smtp 0.3.1.1, prime 0.1.2 が新規 bundled 化)。**no は 4 件**(rake 系、同上。rake 13.0.6)。
- 3.2: 32 件抽出(3.1 と同一 gem 集合、バージョンのみ上昇: minitest 5.25.1, net-ftp 0.2.1, net-imap 0.3.9, net-pop 0.1.2, net-smtp 0.3.4, power_assert 2.0.3, test-unit 3.5.7。rake/matrix/prime/rss は 3.1 と同一バージョンのため gem ツリーを再取得せず使い回し、rexml 3.4.4 は master 用に取得済みのツリーをそのまま再利用)。**no は 4 件**(rake 系、同上。rake 13.0.6)。

3 版とも **no は `rake/classic_namespace, rake/gempackagetask, rake/rdoctask, rake/runtest` の同じ 4 件で完全に一致**(rake 13.0.3〜13.4.2 のどのバージョンでも一貫して存在しない古いレガシーファイル)。

**追加で取得した gem リポジトリ(バージョン別、35 リビジョン)**: `github/gem-<gemname>-<version>-files.txt` 形式(例: `gem-rexml-3.2.5-files.txt`)。minitest(seattlerb/minitest)@5.14.2/5.15.0/5.25.1、power_assert@1.2.1/2.0.1/2.0.3、rake@13.0.3/13.0.6、rexml@3.2.5/3.3.9(3.4.4 は master 分を再利用)、rss@0.2.9/0.3.1、test-unit@3.3.7/3.5.3/3.5.7、matrix@0.4.2、net-ftp@0.1.4/0.2.1、net-imap@0.2.4/0.3.9、net-pop@0.1.1/0.1.2、net-smtp@0.3.1.1/0.3.4、prime@0.1.2。全て `truncated: false`。解決ログ= `github/gem-resolution-bundled.log`。同一バージョンの重複取得はなし(版間で共有できるものは再利用)。

## 4. その他の判定に迷ったケース

- **minitest のリポジトリ移管**: 3.0〜3.2(bundled_gems.txt)は `https://github.com/seattlerb/minitest` を指すが、master(4.1)は `https://github.com/minitest/minitest` に移管済み。両方とも正しく解決できることを確認(タグ形式は両方とも `v<version>`)。
- **`resolv`(コア lib)と `resolv-replace`(bundled gem)は別ユニット**: 4.1 で `resolv` は `lib/resolv.rb` として in-tree(yes/lib)、`resolv-replace` は同名の bundled gem として個別に yes(gem:resolv-replace@v0.2.0)。取り違えないよう名前完全一致でマッピング。
- **`win32/registry` → `win32-registry` gem、`win32/resolv` → ext 内蔵**: 同じ `win32/` 配下でも判定経路が異なる(前者は bundled gem 化、後者はコア ext のまま)。誤って同一グループとして扱わないよう個別に確認。
- **json/add 系(§2 参照)は本方式の対象外**である旨を明記(ext/json/lib の縮小版のみ確認可能で、フル gem 配布物は非対象)。

## 5. ファイル一覧

```
github/<ver>-lib-files.txt, <ver>-ext-files.txt   # ruby/ruby の lib/ext 再帰ツリー(ver=3.0〜4.0,master)
github/tree-4.1.tsv                                # 4.1 の全 328 件判定(name, verdict, where)
github/tree-bundled-3.0.tsv 〜 -3.2.tsv             # 3.0〜3.2 の bundled gem 配下ページ判定
github/gem-<gemname>-files.txt                      # 4.1 判定用(bundled_gems.txt の master ピン版)
github/gem-<gemname>-<version>-files.txt            # 3.0〜3.2 判定用(バージョン別)
github/gem-resolution-4.1.log, gem-resolution-bundled.log  # タグ解決ログ(使用 ref・truncated・行数)
github/{check41,map_gems,resolve_gem_pass,find_bundled_candidates,resolve_bundled}.rb  # 判定スクリプト
github/{fetch_gems.sh,fetch_gems_v.sh}              # gem ツリー取得スクリプト
github/gemlist-4.1.tsv, gemlist-bundled.tsv         # 取得対象 gem 一覧(手動生成)
github/pass1-4.1.tsv, pass2-4.1.tsv, mapped-4.1.tsv, unresolved-4.1.tsv, bundled-candidates-3.*.tsv  # 中間生成物
github/notes.md                                     # 本ファイル
github/_meta/<ver>-rootsub.txt                      # root tree の lib/ext サブツリー sha 一覧(作業用)
```

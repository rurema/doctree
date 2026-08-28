# always-ng 二次調査 記録

対象: `mismatch-matrix.tsv` の bucket=always-ng、314 件中 yaml/dbm(23 件・dbm gem 不在の
環境要因と判明済み)を除いた 291 件。出力: `always-ng-triage.tsv`。

## スクリプト構成

- `frontmatter_requires.rb` — doctree `manual/api/<lib>.md` の front matter から
  `require:`/`sublibrary:` のリスト項目を抜き出すパーサ。`#%until`/`#%else`/`#%end`
  等の版分岐ディレクティブが挟まっていても両方の枝を候補として拾う。
- `triage_worker.rb` — 1 ライブラリ分をこのプロセス内で調べ、行ごとの生データ
  (クラス解決結果・method_defined? 系 4 形式・ObjectSpace 走査による類似クラス候補・
  mixin 経由確認・Kernel DSL 探索・綴り/構造近似メソッド)を JSON Lines で出す。
  ObjectSpace はプロセス内状態なので**ライブラリごとに新しい ruby プロセス**として起動する。
- `triage_script.rb` — host 側オーケストレーション。ライブラリ単位で worker を
  3.4 → (not-found のみ) 4.0 の順に起動し、判定ロジック `decide()` で
  resolution/detail を確定して `always-ng-triage.tsv` を書き出す。
  `ruby triage_script.rb [method-check dir] [doctree root]` で再実行可能
  (既定値はこの環境のパス)。デバッグ用に `LIBS_FILTER=lib1,lib2` 環境変数で
  対象ライブラリを絞れる。

## resolution 別件数(最終)

| resolution | 件数 |
| --- | ---: |
| not-found | 195 |
| renamed-class | 77 |
| env | 14 |
| wrong-type | 4 |
| needs-require | 1 |
| **合計** | **291** |

## lib 別の傾向

- **rss (80 件)**: renamed-class 59 / not-found 21。
  - `DublinCoreModel` 45 件 → 全て `RSS::DublinCoreModel` への改名で解決
    (ObjectSpace 上の末尾セグメント一致で一意にヒット)。
  - `RSS::RDF::Channel::ImageFavicon` 8 件 → `RSS::ImageFaviconModel::ImageFavicon`
    (ネストの親が `Channel` ではなく `*Model` モジュール直下だった)。
  - `RSS::Rss::SkipDays`/`SkipHours` 各3件 → `RSS::Rss::Channel::SkipDays`/`SkipHours`
    (`Channel` が一段挟まる)。
  - 残り 21 件は not-found だが、うち `ContentModel`/`ImageItemModel`/
    `SyndicationModel`/`TaxonomyTopicModel`/`TaxonomyTopicsModel` はクラス名は
    正しく、`append_features` によるメタプログラミングで include 先の具象クラス
    (`RSS::RDF::Channel`/`RSS::RDF::Item` 等)にしかメソッドが実体化しないため
    `method_defined?` では検出できない(**自動チェックの構造的な限界であり、
    ドキュメント記載自体はおそらく妥当**。detail に include 先クラス名を記録)。
    `RSS::BaseTrackBackModel` は include 先が無名クラス(内部実装専用、ソースに
    `:nodoc: all` 注記あり)しか無く実質使えないので純粋な not-found。
- **openssl (35 件、全 not-found)**: 現行 OpenSSL 3.x で削除された機能ばかり
  — `OpenSSL::Digest::{DSS,DSS1,MD2,MDC2,SHA}`(弱い/廃止アルゴリズム)、
  `OpenSSL::PKey::{DH,DSA,RSA}` の `p=`/`g=`/`priv_key=` 等セッター(OpenSSL 3.0 で
  鍵コンポーネントが不変(opaque EVP_PKEY)になり削除)、`OpenSSL::Random.egd`
  (EGD 廃止)。**バージョン until ゲート漏れの強い候補群**。
- **rubygems 系(15+16+8+9+... 件、ほぼ全 not-found)**: `Gem::QuickLoader`、
  `Gem::Specification` の属性定義 DSL(`attribute`/`array_attribute`/`read_only` 等)、
  `Gem::Security` の署名/証明書関連クラスメソッド、`rubygems/indexer`・
  `rubygems/server` のファイル自体が現行 RubyGems から削除済み(後述)など、
  RubyGems の内部実装が長年のリファクタで置き換わった/削除された形跡。
  front matter の require:/sublibrary: を全部試しても解決しないものが大半で、
  **needs-require は 291 件中 1 件のみ**という結果になった
  (rubygems 系は「サブファイルの読み忘れ」ではなく「機能自体が無くなった」
  パターンが支配的、という実態)。
- **json (13 件)**: `renamed-class` 9 件が興味深いパターン。ドキュメントは
  `JSON::Generator::GeneratorMethods::Array#to_json` のように mixin モジュール配下に
  書いているが、現行 json gem は該当モジュールを `Array`/`Hash`/`String` 等の
  組み込みクラスへ直接 `include` 済みなので、**`Array#to_json` はそのまま
  トップレベルの `Array` クラスの実メソッドとして存在する**(末尾セグメント一致で
  ObjectSpace 上の `Array` にヒット)。`to_json_raw`/`to_json_raw_object` 等は
  実際に削除されており not-found。
- **rake (12 件)**: `Kernel#desc`/`task`/`namespace` 等 9 件が全て `renamed-class:Rake::DSL`
  に解決。rurema の慣習で「グローバルに見える DSL 関数」を Kernel として文書化する
  パターン(mkmf 等)だが、rake の場合は plain `require "rake"` だけでは
  Kernel にも Object にも現れず、実体は `Rake::DSL` が自身で持つ private メソッド
  (`rake` コマンド実行時に self へ extend されて初めてトップレベルから呼べる)。
  これを見つけるため、Kernel 文書化行専用に「同名メソッドを自身で定義している
  モジュール」を全探索するロジック(`kernel_dsl_search`)を追加した。
  `Rake::Cloneable#clone`/`#dup` は現行 rake でも `:nodoc:` の空モジュールで
  not-found、`Rake::TaskManager#last_comment` は `last_description`
  (`attr_accessor`)へ改名されているが編集距離が離れすぎており今回のツールでは
  自動検出できなかった(手動確認)。
- **etc (12 件、全 env)**: `Etc::Passwd` の `age`/`change`/`comment`/`expire`/
  `quota`/`uclass` は BSD 系にのみ存在するフィールドで、この検証環境(Linux)の
  `Etc::Passwd.members` には最初から含まれない。`aggregate.rb` の
  `PLATFORM_CLASSES`(Socket/Socket::Constants/Etc の `::` 定数のみ対象)と
  同種の環境要因だが、`Etc::Passwd`(`#` 側)は対象外だったため always-ng に
  紛れ込んでいた。同じ理由で `socket` lib の `Socket::Ifaddr#vhid`
  (FreeBSD の CARP 関連フィールド)も env とした。
- **irb/magic-file (1 件)**: ページ front matter が `until: "3.3"` で、
  3.4/4.0 のどちらでも `require "irb/magic-file"` 自体が LoadError になる
  (ファイルが無い)。この検証で使える Ruby(3.4/4.0)の範囲では実行時検証が
  そもそも不可能なので env とした。同種で `rubygems/indexer`・`rubygems/server`
  も 3.4/4.0 でファイル自体が無いが、front matter の `require: [rubygems, ...]`
  のうち `rubygems` 単体は読み込めるため(機能の一部が生きている)、
  こちらは「env」ではなく素直に「クラス/メソッドが現行 RubyGems から
  削除された」という not-found のままにした(判定基準: base require も
  追加 require も 3.4・4.0 とも全滅した場合だけ env に格上げする)。
- **bigdecimal (3 件、全 wrong-type:singleton)**: `save_exception_mode`/
  `save_limit`/`save_rounding_mode` はドキュメントでは `#`(インスタンスメソッド)
  だが、実際は `BigDecimal.save_exception_mode` のようなクラスメソッド。
- **cgi/* (2+7+4 = 13 件、全 not-found)**: `require "cgi"`/`"cgi/core"` 等は
  3.4 では成功する(cgi gem が入っている)ため 3.4 で判定が完結している。
  `CGI::QueryExtension::Value`、`CGI::Html3/4/4Fr/4Tr#element_init` は
  現行 cgi gem (0.4.2) に実体が無く、クラス名が似た別名も見つからないので
  素直な not-found(4.0 では cgi gem 自体が無い=doctree 本文にも明記済みの
  既知の事実で、3.4 で判定済みのため 4.0 再検証はほぼ意味を持たない)。
- **mutex_m (5 件、全 not-found)**: `lock`/`unlock`/`synchronize`/`try_lock`/
  `locked?` は現行 mutex_m では全て `mu_` 接頭辞付き(`mu_lock` 等)に
  変わっている。編集距離ベースの誤字検出では拾えない(距離が閾値を超える)
  ため、**部分文字列一致**(`mu_lock` が `lock` を含む)を近似メソッド探索に
  追加してようやく検出できた。ドキュメントの誤字ではなく実際の改名。
- **strscan (1 件)**: `StringScanner#matchedsize` → `matched_size` の
  アンダースコア抜け(編集距離1で検出、正真正銘のドキュメント誤字候補)。
- **cgi/cookie (2 件)**: `httopnly`/`httopnly=` → `httponly`/`httponly=` の
  誤字(`n` の位置がずれている)。
- **psych (1 件、needs-require)**: `Kernel#y` は `require "psych"` だけでは
  定義されず、`lib/psych/y.rb`(`require "psych/y"`)で初めて `Kernel` に
  追加される。front matter には require: が無かったが、ソースを直接確認して
  `psych/y` を手動で追加 require リストに加えた
  (`triage_script.rb` の `MANUAL_EXTRA_SUBS`)。

## 実装上のポイント・ハマった点

1. **ObjectSpace はプロセス内状態**なので、ライブラリごとに新しい ruby
   プロセスを起動する必要がある(1 プロセスで複数ライブラリを続けて require
   すると、後の require が前のライブラリの読み込み結果に汚染される)。
2. **`Module#name` を直接呼ぶと壊れることがある**: `REXML::Functions` は
   XPath の `name()` 関数を実装するために自分自身に `def self.name` を
   定義しており、これが `Module#name` を上書きしてしまう。
   `ObjectSpace.each_object(Module) { |m| m.name }` を素朴に書くと
   `REXML::Functions.name` の呼び出しで `NoMethodError` が起きて全体が
   落ちる。`Module.instance_method(:name).bind(m).call` で unbind した
   本来のメソッドを呼ぶことで回避した。
3. **`singleton_class.method_defined?` は Kernel の分だけ常に true になる**:
   どんな Class/Module も Object なので、`clone`/`dup`/`freeze` 等
   Kernel 由来のメソッド名を持つ行を「特異メソッドとして存在するか」で
   チェックすると常に真になってしまう(`Rake::Cloneable#clone`/`#dup` で発覚)。
   `Module.new`/`Class.new` の素の singleton_class が持つメソッド集合を
   ベースラインとして差し引く(`TRIVIAL_SINGLETON_SYMS`)ことで対処した。
4. **mixin モジュールへの `method_defined?` は成立しないことがある**:
   `RSS::DublinCoreModel` 等は `append_features` で include 先のクラスに
   動的にメソッドを注入する設計で、モジュール自身への `method_defined?` は
   常に false になる。`ObjectSpace.each_object(Class)` で
   `ancestors.include?(mod)` な具象クラスを探し、そちらでメソッドの有無を
   確認するフォールバック(`mixin_hits_for`)を追加した。
   ただし **`Kernel` のような「事実上全クラスが include している」
   モジュールにこのフォールバックを適用すると無意味な誤検出になる**
   (`OptionParser::Switch#desc` のような無関係なクラスが「Kernel を
   include しているクラス」として大量にヒットしてしまう)。
   `class == "Kernel"` のときはこのフォールバックを使わず、専用の
   `kernel_dsl_search`(自分自身が定義する private メソッドとして
   その名前を持つモジュールを全探索)に切り替えた。
5. **編集距離だけでは接頭辞付与のリネームを検出できない**(`lock` →
   `mu_lock` は距離 3)。編集距離に加えて部分文字列包含も
   「近い名前」の判定に加えることで mutex_m のケースを拾えた。
6. **`renamed-class` の候補が複数ヒットする場合がある**(例:
   `RSS::RDF::Channel::ImageFavicon` は `RSS::ImageFaviconModel::ImageFavicon`
   の他に `RSS::Maker::RSS092::Channel::ImageFavicon` 等 6 種の Maker
   (ビルダー API)側のクラスにも同名かつ同形のメソッドがある)。
   `::Maker::` を含む候補を後回しにし、名前が短い方を優先する簡単な
   ヒューリスティックで一意に選び、detail 列には見つかった候補を全て列挙した。
7. **`always-ng` に混入していた「プラットフォーム依存」の見落とし**:
   `aggregate.rb` の `PLATFORM_CLASSES` は `Socket`/`Socket::Constants`/`Etc`
   の `::`(定数)エントリだけを対象にしていたため、`Etc::Passwd`(`#`側)や
   `Socket::Ifaddr#vhid` のような libc 由来 Struct のメンバー違いは
   always-ng バケットに紛れ込んでいた。今回はこれを検出して `env` に
   格上げする後処理を追加した(既知のクラス名を明示的に列挙する方式。
   一般化はしていない)。

## 既知の未解決・要目視確認

- `Rake::TaskManager#last_comment` → 実際は `last_description`
  (`attr_accessor`)に改名されているとソースで確認したが、編集距離/部分
  文字列一致のどちらの近似ロジックでも拾えなかった(意味的なリネームで
  綴りが大きく変わるケースは今回のツールの守備範囲外)。
- `rubygems/dependency`・`rubygems/defaults` 等 rubygems 系の not-found
  多数は個別のソース調査までは行っていない(件数が少なく明らかに historical
  な内部実装なので、まとめて「削除された可能性が高い」とだけ判定)。

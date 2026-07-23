#!/usr/bin/env ruby
# frozen_string_literal: true
#
# tools/compare.rb
#
# 使い方:
#   ruby tools/compare.rb > mismatches.tsv
#
# 引数なし。標準ライブラリのみに依存(bitclust gem は require しない)。
# 全ての入力(matrix.tsv, classes.tsv, aliases.tsv, doctree-entries.tsv,
# gd-db-names.tsv, raw/<version>.tsv, doctree/manual/api/_builtin/*.md
# の {: undef}/{: nomethod} 行)はこのリポジトリ配下の相対パスで解決する
# ので、どのディレクトリから実行しても同じ結果になる(決定的・再実行可能)。
#
# 目的:
#   実測(matrix.tsv 等)・doctree の明示 since/until 属性・本番 DB の
#   エントリ存在(gd-db-names.tsv: 名前単位)の3データセットを突き合わせ、
#   doctree の kind s|i|o エントリ1件ごとに「期待されるバッジ」と
#   「現状のバッジ(本番相当の計算結果)」を比較したレポートを
#   mismatches.tsv (全件) として出力する。ロジックの詳細・エッジケースの
#   判断根拠は notes-compare.md 参照。
#
# 出力列:
#   class kind method file line since_attr until_attr
#   real_first real_last real_via
#   db_first db_last
#   current_since_badge current_until_badge
#   expected_since expected_until
#   verdict note

require 'set'

ROOT_DIR = File.expand_path('..', __dir__)
RAW_DIR  = File.join(ROOT_DIR, 'raw')
BUILTIN_DIR = File.expand_path('../../../manual/api/_builtin', __dir__)

# 実測(matrix.tsv)の19版。doctree/DB のバージョンラベルとは表記が異なる
# (2.x は teeny .0 省略、1.9.x/2.0.0 はそのまま)。doc_label() で変換する。
REAL_VERSIONS = %w[
  1.8.6 1.8.7 1.9.1 1.9.2 1.9.3 2.0.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7
  3.0 3.1 3.2 3.3 3.4 4.0
].freeze

# 本番 DB (gd) のバージョンラダー。既にバッジ表示用ラベルと同じ表記。
DB_VERSIONS = %w[
  1.8.7 1.9.3 2.0.0 2.1.0 2.2.0 2.3.0 2.4.0 2.5.0 2.6.0 2.7.0
  3.0 3.1 3.2 3.3 3.4 4.0 4.1
].freeze

def gem_ver(label)
  Gem::Version.new(label)
rescue ArgumentError
  nil
end

# 実測ラベル -> doc/DB 表示ラベル (feedback_version_format.md: 3.0以上は
# teeny .0 省略。2.x は teeny .0 付き。1.9.x/2.0.0/3.x/4.x はそのまま)
def doc_label(v)
  case v
  when /\A2\.\d\z/ then "#{v}.0"
  else v
  end
end

def next_in(list, v)
  idx = list.index(v)
  return nil unless idx

  list[idx + 1]
end

# ---------------------------------------------------------------------------
# 1. matrix.tsv 読み込み -> REAL[[class,kind,method]] = Set(versions)
# ---------------------------------------------------------------------------

REAL = Hash.new { |h, k| h[k] = Set.new }

File.foreach(File.join(ROOT_DIR, 'matrix.tsv'), encoding: 'UTF-8') do |line|
  line.chomp!
  next if line.empty? || line.start_with?('#')

  f = line.split("\t", -1)
  cls, kind, meth = f[0], f[1], f[2]
  REAL_VERSIONS.each_with_index do |v, i|
    vis = f[3 + i]
    REAL[[cls, kind, meth]] << v if vis != '-'
  end
end

def real_exists?(cls, kind, meth, version)
  REAL.key?([cls, kind, meth]) && REAL[[cls, kind, meth]].include?(version)
end

# ---------------------------------------------------------------------------
# 2. raw/<version>.tsv の A 行 -> ANCESTORS[version][class] =
#      { type:, superclass:, ancestors: [...] }  (ancestors は自分自身含む MRO 順)
# ---------------------------------------------------------------------------

ANCESTORS = {}

REAL_VERSIONS.each do |v|
  h = {}
  File.foreach(File.join(RAW_DIR, "#{v}.tsv"), encoding: 'UTF-8') do |line|
    line.chomp!
    next if line.empty?

    f = line.split("\t", -1)
    next unless f[0] == 'A'

    name = f[1]
    type = f[2]
    superclass = f[3]
    ancestors = f[4].to_s.empty? ? [] : f[4].split(',')
    h[name] = { type: type, superclass: superclass, ancestors: ancestors }
  end
  ANCESTORS[v] = h
end

# kind='s' 用: スーパークラス連鎖(自分自身を除く)。クラスが存在しない/
# モジュール/superclass が空ならそこで終わり。
def superclass_chain(cls, version)
  chain = []
  seen = Set.new
  cur = ANCESTORS[version][cls]&.dig(:superclass)
  while cur && !cur.empty? && !seen.include?(cur)
    seen << cur
    chain << cur
    cur = ANCESTORS[version][cur]&.dig(:superclass)
  end
  chain
end

# kind='i' 用: A 行の ancestors リスト(自分自身除く、MRO 順)
def instance_ancestors(cls, version)
  info = ANCESTORS[version][cls]
  return [] unless info

  info[:ancestors].reject { |a| a == cls }
end

# ---------------------------------------------------------------------------
# 3. aliases.tsv -> 無向グラフ(定数リネームの同一実体グループ化)
# ---------------------------------------------------------------------------

ALIAS_ADJ = Hash.new { |h, k| h[k] = [] }

File.foreach(File.join(ROOT_DIR, 'aliases.tsv'), encoding: 'UTF-8') do |line|
  line.chomp!
  next if line.empty? || line.start_with?('#')

  path, canonical, = line.split("\t", -1)
  next if path == canonical

  ALIAS_ADJ[path] << canonical
  ALIAS_ADJ[canonical] << path
end

$alias_group_cache = {}

def alias_group(name)
  $alias_group_cache[name] ||= begin
    seen = Set.new([name])
    queue = [name]
    until queue.empty?
      cur = queue.shift
      ALIAS_ADJ[cur].each do |nbr|
        next if seen.include?(nbr)

        seen << nbr
        queue << nbr
      end
    end
    seen.to_a.sort
  end
end

# ---------------------------------------------------------------------------
# 4. gd-db-names.tsv -> DB[[class,typechar,method]] = Set(db versions)
#
#    extract_gd_names.rb が各版 DB のメソッドファイルの中身(names=
#    プロパティ)を読んで生成した「名前単位」の存在データ。本番の
#    MethodSinceCalculator はファイルパスではなく names= に載る全別名を
#    登録する(method_since_calculator.rb:48-56)ので、これと同じ粒度になる。
#    旧実装はファイルパスの存在一覧(gd-db-presence.tsv)+ 現行 doctree
#    ソースのチャンク推測(CHUNK_DB_ALT)で names= を近似していたが、
#    「過去版 DB でのみ別名が合体していた」ケース(例: Object#send は
#    db-2.4.0 以前 i.__send__._builtin の names=__send__,send の中にしか
#    存在しない)を検出できなかったため、実データに置き換えた。
#    names 空欄の行(Kernel の kind=v 特殊変数ファイルのみ・全17版)は
#    比較対象外なのでスキップしてよい。
# ---------------------------------------------------------------------------

DB = Hash.new { |h, k| h[k] = Set.new }

File.foreach(File.join(ROOT_DIR, 'gd-db-names.tsv'), encoding: 'UTF-8') do |line|
  line.chomp!
  next if line.empty?

  version, cls, typechar, names_csv = line.split("\t", -1)
  next if names_csv.nil? || names_csv.empty?

  names_csv.split(',').each do |meth|
    DB[[cls, typechar, meth]] << version
  end
end

def db_exists?(cls, typechar, meth, version)
  DB.key?([cls, typechar, meth]) && DB[[cls, typechar, meth]].include?(version)
end

# ---------------------------------------------------------------------------
# 5. doctree-entries.tsv 読み込み・集約
# ---------------------------------------------------------------------------

DocRow = Struct.new(:file, :line, :class_name, :kind, :method_name,
                     :since_attr, :until_attr, :pp_cond, :class_since, :class_until)

IDX = {} # [file, line(Integer)] => DocRow (全 kind。チャンク別名解決に使う)
groups = {} # [class,kind,method] => [DocRow, ...]  (insertion order preserved)
group_order = []
kind_counts = Hash.new(0)

File.foreach(File.join(ROOT_DIR, 'doctree-entries.tsv'), encoding: 'UTF-8') do |line|
  line.chomp!
  next if line.empty?

  f = line.split("\t", -1)
  row = DocRow.new(*f)
  kind_counts[row.kind] += 1
  IDX[[row.file, row.line.to_i]] = row
  next unless %w[s i o].include?(row.kind)

  key = [row.class_name, row.kind, row.method_name]
  unless groups.key?(key)
    groups[key] = []
    group_order << key
  end
  groups[key] << row
end

warn "doctree kind counts: #{kind_counts.inspect}"
warn "aggregated target entries (kind s|i|o): #{group_order.size} " \
     "(from #{groups.values.sum(&:size)} raw signature rows)"

# ---------------------------------------------------------------------------
# 6. ソース再スキャン: {: undef}/{: nomethod} フラグ
#
#    parse_doctree.rb の doctree-entries.tsv には反映されていない属性なので
#    ここで独立に検出する。
#    (かつてはここで「本文を挟まず連続する見出し=1チャンク」の別名
#     グループも推測して DB 解決のフォールバック(CHUNK_DB_ALT)にして
#     いたが、DB ファイルの実際の names= を読んだ gd-db-names.tsv に
#     置き換えたため不要になった。セクション4のコメント参照。)
# ---------------------------------------------------------------------------

SIG_RE_SCAN = /\A### (module_function def |def |const |gvar )/
ATTR_RE_SCAN = /\A\{:(.*)\}[ \t]*\z/

FLAGGED = {} # [file, signature_lineno(1-based)] => ['undef'] / ['nomethod']

Dir.glob(File.join(BUILTIN_DIR, '*.md')).sort.each do |path|
  file = File.basename(path)
  lines = File.read(path, encoding: 'UTF-8').split("\n", -1)
  n = lines.length
  i = 0
  while i < n
    unless SIG_RE_SCAN.match?(lines[i])
      i += 1
      next
    end

    while i < n && SIG_RE_SCAN.match?(lines[i])
      sig_lineno = i + 1 # 1-based
      i += 1
      if i < n && (m = ATTR_RE_SCAN.match(lines[i]))
        toks = m[1].strip.split(/\s+/)
        flags = toks.reject { |t| t.include?('=') }
        (FLAGGED[[file, sig_lineno]] ||= []).concat(flags) unless flags.empty?
        i += 1
      end
    end
  end
end

# sanity check against notes-doctree-format.md (109 total attr lines = 95
# since/until tokens + 6 undef + 8 nomethod)
flagged_count = FLAGGED.values.sum(&:size)
warn "FLAGGED entries: #{FLAGGED.size} lines, #{flagged_count} flags (expect 14)" if flagged_count != 14

# ---------------------------------------------------------------------------
# 7. 特殊クラスの解決ルール
# ---------------------------------------------------------------------------

# real 側の "new -> initialize" 代用 (kind=s, method=new のときのみ)
def real_new_via_init?(group, version)
  group.any? { |c| real_exists?(c, 'i', 'initialize', version) }
end

# doc_class に対する real 側の解決(1バージョン分)。
# 戻り値: [true/false, via_tag]
def resolve_real_version(doc_class, kind, method, version, suppress_inherited)
  group = alias_group(doc_class)
  kinds = kind == 'o' ? %w[s i] : [kind]

  # tier 1+2: direct + alias-union
  if group.any? { |c| kinds.any? { |k| real_exists?(c, k, method, version) } }
    return [true, group.size > 1 ? "alias-union:#{(group - [doc_class]).join(',')}" : 'direct']
  end

  # tier 3: new -> initialize
  if kind == 's' && method == 'new' && real_new_via_init?(group, version)
    return [true, 'new-via-initialize']
  end

  # tier 4: inherited (undef フラグの場合は抑制: 継承元にあっても
  # undef_method で塞がれている可能性があるため、direct のみで判定する)
  unless suppress_inherited
    kinds.each do |k|
      chain = k == 's' ? superclass_chain(doc_class, version) : instance_ancestors(doc_class, version)
      chain.each do |anc|
        return [true, "inherited:#{anc}"] if real_exists?(anc, k, method, version)
      end
    end

    # tier 3+4 combined: new -> initialize, walked up the ancestor chain too
    # (e.g. Object.new: Object itself lost its own #initialize to BasicObject
    # from 1.9.2 on -- matrix.tsv shows "Object i initialize" only for
    # 1.8.6/1.8.7, and "BasicObject i initialize" from 1.9.2 -- so checking
    # only the doc_class's own group would wrongly conclude Object.new
    # "disappeared" at 1.9.1)
    if kind == 's' && method == 'new'
      instance_ancestors(doc_class, version).each do |anc|
        return [true, "inherited-new-via-initialize:#{anc}"] if real_exists?(anc, 'i', 'initialize', version)
      end
    end
  end

  # tier 5: special cases
  case doc_class
  when 'ARGF.class'
    return [true, 'special:ARGF(s)'] if real_exists?('ARGF', 's', method, version)
  when 'BasicObject'
    %w[Object Kernel].each do |c|
      return [true, "special:BasicObject->#{c}(i)"] if real_exists?(c, 'i', method, version)
    end
  when 'ENV', 'main'
    cls_field = ANCESTORS[version][doc_class]&.dig(:superclass)
    if cls_field && !cls_field.empty?
      ([cls_field] + instance_ancestors(cls_field, version)).each do |anc|
        return [true, "special:#{doc_class}.class(#{anc})"] if real_exists?(anc, 'i', method, version)
      end
    end
  when 'Errno::EXXX'
    if kind == 's' && method == 'new'
      (['SystemCallError'] + instance_ancestors('SystemCallError', version)).each do |anc|
        return [true, "special:errno-template(#{anc})"] if real_exists?(anc, 'i', 'initialize', version)
      end
    end
  end

  [false, nil]
end

def resolve_real(doc_class, kind, method, suppress_inherited)
  presence = {}
  via = {}
  REAL_VERSIONS.each do |v|
    ok, tag = resolve_real_version(doc_class, kind, method, v, suppress_inherited)
    if ok
      presence[v] = true
      via[v] = tag
    end
  end
  found = REAL_VERSIONS.select { |v| presence[v] }
  if found.empty?
    { first: '-', last: '-', via: '-' }
  else
    first = found.first
    last = found.last
    note = via[last] != via[first] ? "last-resolved-via:#{via[last]}" : nil
    { first: first, last: last, via: via[first], extra_note: note }
  end
end

# db 側解決: alias-union のみ。kind='o' は typechar 'm'。'm' が全バージョンで
# 見つからない場合のみ s/i 合算にフォールバック(note に記録)。
# DB は gd-db-names.tsv 由来の「名前単位」の存在(セクション4)なので、
# チャンク別名(1ファイルの names= に複数名)は既に展開済み。本番の
# MethodSinceCalculator と同じ粒度で直接引ける。
def resolve_db(doc_class, kind, method)
  group = alias_group(doc_class)
  primary_typechar = kind == 'o' ? 'm' : kind
  notes = []

  found = DB_VERSIONS.select do |v|
    group.any? { |c| db_exists?(c, primary_typechar, method, v) }
  end

  if found.empty? && kind == 'o'
    found2 = DB_VERSIONS.select { |v| group.any? { |c| %w[s i].any? { |tc| db_exists?(c, tc, method, v) } } }
    unless found2.empty?
      found = found2
      notes << 'db-typechar-fallback:s/i'
    end
  end

  note = notes.empty? ? nil : notes.join(';')
  if found.empty?
    { first: '-', last: '-', note: note }
  else
    { first: found.first, last: found.last, note: note }
  end
end

# ---------------------------------------------------------------------------
# 8. バッジ計算(本番 bitclust 相当。version_badges.rb / method_since_calculator.rb
#    を参照して実装。notes-compare.md 参照)
# ---------------------------------------------------------------------------

def current_since_badge(since_attr, db_first, forced_none)
  return 'none' if forced_none
  return 'none' if since_attr == 'EMPTY'
  return since_attr unless since_attr == '-'
  return 'none' if db_first == '-' || db_first == DB_VERSIONS.first

  db_first
end

def current_until_badge(until_attr, db_last, forced_none)
  return 'none' if forced_none
  return until_attr unless until_attr == '-' # 現状コーパスに until= は無いが将来のため対応
  return 'none' if db_last == '-' || db_last == DB_VERSIONS.last

  next_in(DB_VERSIONS, db_last)
end

def expected_since(real_first)
  return ['-', nil] if real_first == '-'
  return ['none', nil] if %w[1.8.6 1.8.7].include?(real_first)
  return ['1.9.3', 'INFO_1_9_2'] if real_first == '1.9.2'

  [doc_label(real_first), nil]
end

def expected_until(real_last)
  return ['-', nil] if real_last == '-'
  return ['none', nil] if real_last == '4.0'

  nxt = next_in(REAL_VERSIONS, real_last)
  return ['1.9.3', 'INFO_1_9_2'] if nxt == '1.9.2' # symmetric with expected_since's 1.9.2 case

  [doc_label(nxt), nil]
end

# ---------------------------------------------------------------------------
# 9. メインループ
# ---------------------------------------------------------------------------

rows_out = []
verdict_counts = Hash.new(0)

group_order.each do |key|
  cls, kind, meth = key
  rows = groups[key]
  rep = rows.first

  since_values = rows.map(&:since_attr).reject { |v| v == '-' }.uniq
  since_attr_agg =
    if since_values.empty?
      '-'
    else
      since_values.first
    end
  since_conflict = since_values.size > 1

  until_values = rows.map(&:until_attr).reject { |v| v == '-' }.uniq
  until_attr_agg = until_values.empty? ? '-' : until_values.first
  until_conflict = until_values.size > 1

  flags = rows.flat_map { |r| FLAGGED[[r.file, r.line.to_i]] || [] }.uniq
  suppress_inherited = flags.include?('undef')
  forced_none_badges = flags.include?('undef')
  real = resolve_real(cls, kind, meth, suppress_inherited)
  db = resolve_db(cls, kind, meth)

  cur_since = current_since_badge(since_attr_agg, db[:first], forced_none_badges)
  cur_until = current_until_badge(until_attr_agg, db[:last], forced_none_badges)

  exp_since, info_since = expected_since(real[:first])
  exp_until, _info_until = expected_until(real[:last])

  notes = []
  notes << real[:extra_note] if real[:extra_note]
  notes << db[:note] if db[:note]
  notes << "since-conflict:#{since_values.join('|')}" if since_conflict
  notes << "until-conflict:#{until_values.join('|')}" if until_conflict
  notes << "overloads:#{rows.size}" if rows.size > 1
  flags.each { |fl| notes << "flag:#{fl}" }
  notes << real[:via] if real[:via] != '-' && real[:via] != 'direct'

  mismatch_tags = []
  if real[:first] == '-'
    verdict = 'DOC_ONLY'
  else
    since_mismatch = (exp_since != cur_since)
    until_mismatch = (exp_until != cur_until)

    if since_mismatch
      mismatch_tags << 'MISMATCH_SINCE'
      if since_attr_agg == 'EMPTY'
        notes << 'explicit-empty-suppressed'
      elsif since_attr_agg != '-'
        notes << 'explicit-wrong'
      elsif cls == 'Set'
        # Set は Ruby 3.2 で "require 'set'" 不要の組み込みクラスになったが、
        # 実装は Kernel#autoload 経由(初回参照まで未ロード)。dump_methods.rb
        # は autoload 未解決の定数を意図的にスキップする設計(README 参照:
        # require を一切行わず組み込みのみを観測するため)なので、Set は
        # 実測上 3.1〜3.4 では「存在しない」ように見え、4.0 で初めて
        # 検出される(4.0 で autoload ではなく即時ロードに変わった、または
        # スクリプト内の他の到達経路で先に解決されたと推測される)。
        # これは real 側の測定方法論のギャップであり、db_first=3.2 の方が
        # 実際のユーザー体験(require 無しで Set が使える最初の版)を正しく
        # 反映している可能性が高い。frozen-db-contamination とは逆向きの
        # 事情なので区別する(notes-compare.md 参照)。
        notes << 'real-autoload-gap:Set'
      elsif db[:first] == '-'
        notes << 'not-in-db'
      elsif %w[1.9.1 1.9.2].include?(real[:first]) && db[:first] == '1.9.3'
        # DB ラダーには 1.9.1/1.9.2 に相当する版が無い(db-1.8.7 の次は
        # db-1.9.3)。実測 first がこの2版に落ちるメソッドは、たとえ
        # ドキュメント化のタイミングが完璧でも自動計算は 1.9.3 より
        # 早い値を絶対に出せない(構造的な制約)。既存の明示 since="1.9.1"
        # 属性(13件)はまさにこのギャップを埋めるための手動記録であり、
        # 残りはこの構造的ギャップとして区別する(要修正の "db-late" とは
        # 性質が異なる)。
        notes << 'ladder-gap-1.9.1-1.9.3'
      else
        rf = gem_ver(real[:first])
        df = gem_ver(db[:first])
        if rf && df
          if df < rf
            notes << 'frozen-db-contamination'
          elsif df > rf
            notes << 'db-late'
          else
            notes << 'label-format'
          end
        end
      end
    end

    if until_mismatch
      mismatch_tags << 'MISMATCH_UNTIL'
      if db[:last] == '-'
        notes << 'not-in-db'
      elsif real[:last] == '4.0' && db[:last] == '4.0'
        # 真に "4.1 だけが未実測で確認できない" ケースに限定する(db_last が
        # 4.0 ちょうど、すなわち db 上は 4.1 でだけ消えている場合)。db_last
        # がそれより前(例 2.4.0)なのに real は 4.0 まで存在する、という
        # ケースは 4.1 の話ではなく通常の until ミスマッチ(db 側のクラス
        # 帰属漏れ等)なので下の分岐に委ねる。
        notes << 'UNVERIFIED_4_1'
        mismatch_tags.delete('MISMATCH_UNTIL')
        mismatch_tags << 'UNVERIFIED_4_1' unless mismatch_tags.include?('UNVERIFIED_4_1')
      elsif %w[1.9.1 1.9.3].include?(exp_until) && db[:last] == '1.8.7' && cur_until == '1.9.3'
        # since 側と対称のラダーギャップ: db-1.8.7 の次が db-1.9.3 なので
        # 「1.9.1/1.9.2 で削除された」という真の until を自動計算では
        # 絶対に表現できない。
        notes << 'ladder-gap-1.9.1-1.9.3'
      elsif cls == 'RubyVM::YJIT'
        # raw/3.2.tsv〜raw/4.0.tsv に "A RubyVM::YJIT" 行自体が無い(=
        # Object.constants から到達不能)。手元の mise Ruby 3.4.8 では
        # --yjit フラグの有無を問わず RubyVM::YJIT.singleton_methods(false)
        # に対象4メソッドが載る(autoload でもない: RubyVM.autoload?(:YJIT)
        # は nil)ことを確認済みなので、これは実測に使った
        # ghcr.io/ruby/all-ruby の 3.2 以降のプリビルドバイナリが YJIT
        # 抜きでビルドされている(3.1 のビルドだけ含まれていた)ことによる
        # 測定環境側のギャップであり、実際の Ruby 本体で 3.2 以降に
        # 削除されたわけではない。until バッジを追加すべきという意味の
        # 実データではないので、他の until-mismatch とは区別する。
        notes << 'real-build-gap:YJIT-disabled-in-prebuilt-3.2+'
      else
        notes << 'until-mismatch'
      end
    end

    info_tags = []
    info_tags << 'INFO_1_8_7' if real[:first] == '1.8.7'
    info_tags << info_since if info_since

    if mismatch_tags.empty?
      verdict = info_tags.empty? ? 'OK' : info_tags.uniq.join(',')
    else
      verdict = mismatch_tags.uniq.join(',')
      notes.concat(info_tags)
    end
  end

  verdict_counts[verdict] += 1

  rows_out << [
    cls, kind, meth, rep.file, rep.line,
    since_attr_agg, until_attr_agg,
    real[:first], real[:last], real[:via],
    db[:first], db[:last],
    cur_since, cur_until,
    exp_since, exp_until,
    verdict, notes.compact.uniq.join(';')
  ]
end

# ---------------------------------------------------------------------------
# 10. 出力
# ---------------------------------------------------------------------------

HEADER = %w[
  class kind method file line since_attr until_attr
  real_first real_last real_via db_first db_last
  current_since_badge current_until_badge
  expected_since expected_until verdict note
].freeze

puts HEADER.join("\t")
rows_out.each { |r| puts r.join("\t") }

warn '--- verdict counts ---'
verdict_counts.sort.each { |k, v| warn "#{k}\t#{v}" }
warn "total: #{rows_out.size}"
warn "excluded (kind c): #{kind_counts['c']}"
warn "excluded (kind v): #{kind_counts['v']}"

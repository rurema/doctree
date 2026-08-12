#!/usr/bin/env ruby
# frozen_string_literal: true
#
# tools/list_undocumented.rb
#
# 使い方:
#   ruby tools/list_undocumented.rb [--min-version 3.0] [--entries FILE ...] \
#     > undocumented.tsv
#
# 実測データ(matrix.tsv)に存在するのに doctree に見出し(エントリ)が
# 無い組み込みメソッドを列挙する。compare.rb が「doctree のエントリごとに
# 実測・DB と突き合わせる」のに対し、こちらは逆方向で「実測にあるのに
# ドキュメントが無いもの」を探す。標準ライブラリのみに依存。
#
# 対象の絞り込み:
#   --min-version V (既定 3.0) — matrix.tsv の V 以降の列のいずれかで
#   存在(pub/priv/prot)するメソッドだけを対象にする。つまり既定では
#   「現在サポート対象の 3.0 以降に組み込みとして存在するメソッド」。
#   raw/4.1.tsv を追補して build_matrix.rb を再実行すれば、そのまま
#   4.1(master)の新規メソッドも対象に入る(バージョン列は matrix.tsv の
#   ヘッダ行から動的に読む)。
#
# doctree 側の入力:
#   既定では doctree-entries.tsv(_builtin のみ)。組み込みメソッドでも
#   ドキュメントが _builtin 以外に置かれているもの(例: IO#wait_readable は
#   3.2 から require 不要だが文書は manual/api/io/wait.md)があるので、
#   誤検出を減らすには他ライブラリのエントリを parse_doctree.rb --dir で
#   抽出した TSV を --entries で追加する(複数指定可):
#
#     cd tools/method-versions
#     { ruby tools/parse_doctree.rb --dir ../../manual/api   # 単一ファイル型 (pathname.md 等)
#       for d in ../../manual/api/*/; do
#         lib=$(basename "$d")
#         ruby tools/parse_doctree.rb --dir "$d" | sed "s|^|$lib/|"
#       done; } > /tmp/entries-libs.tsv
#     ruby tools/list_undocumented.rb --entries /tmp/entries-libs.tsv
#
# 解決規則(compare.rb の逆適用):
#   - doctree の kind o(module_function)は実測の s/i どちらにもマッチ
#   - 実測 Klass#initialize(private)は doctree の Klass.new でマッチ
#   - 定数リネーム(aliases.tsv: Fixnum->Integer 等)は同一グループとして
#     どの名前のエントリでもマッチ
#   - 特殊クラス: 実測 ARGF(s)-> doctree ARGF.class / 実測 Errno::EXXX 個別
#     クラス -> doctree Errno::EXXX / 実測 Object・Kernel -> doctree
#     BasicObject(1.8 系の付け替え)
#   - 自クラスに無くても祖先クラス(kind i は ancestors、kind s は
#     superclass 連鎖)にエントリがあれば DOC_ON_ANCESTOR に分類する
#     (オーバーライドを親側で一括文書化している通常ケース。真の未収録
#     とは区別して出力する)
#   - 逆に、実測の定義クラスを ancestors に含むクラス(= include 先/
#     サブクラス)側にエントリがあれば DOC_ON_DESCENDANT に分類する。
#     CRuby は Object のメソッドの大半を Kernel モジュールに定義するが
#     doctree の慣例では Object.md に記載する(compare.rb の inherited
#     解決の逆)。これも真の未収録とは区別する
#
# 出力(TSV, ヘッダ行あり):
#   class kind method vis first last category hint
#     vis      - 対象窓内の最新版での可視性(pub/priv/prot)
#     first/last - matrix.tsv の first/last(全期間)
#     category - UNDOC(どこにもエントリ無し)/ DOC_ON_ANCESTOR /
#                DOC_ON_DESCENDANT
#     hint     - DOC_ON_* の解決先「クラス(ファイル)」、UNDOC では
#                クラス自体のエントリが1件も無い場合に class-undocumented
#
# 注意:
#   - 「エントリがある」= 見出しが存在すること。#@since/#@until ゲートの
#     真偽は評価しない(旧版ゲート内のみのエントリも「あり」扱い)。
#   - 実測は require なしの観測なので、autoload 経由で初回参照まで
#     ロードされないもの(3.1〜3.4 の Set 等)は実測側に現れない。
#   - 別名メソッド(alias)の実体関係は実測データに無いので、別名の
#     片方だけ文書化されている場合はもう片方が UNDOC として出る。

require 'optparse'
require 'set'

ROOT_DIR = File.expand_path('..', __dir__)
RAW_DIR  = File.join(ROOT_DIR, 'raw')

options = { min_version: '3.0', entries: [] }
OptionParser.new do |opt|
  opt.banner = 'Usage: list_undocumented.rb [--min-version V] [--entries FILE ...]'
  opt.on('--min-version V', '対象窓の下限 (既定 3.0)') { |v| options[:min_version] = v }
  opt.on('--entries FILE', '追加の doctree エントリ TSV (parse_doctree.rb 出力)') { |v| options[:entries] << v }
end.parse!(ARGV)

def gem_ver(label)
  Gem::Version.new(label)
rescue ArgumentError
  nil
end

# ---------------------------------------------------------------------------
# 1. matrix.tsv — バージョン列はヘッダ行から動的に決定
# ---------------------------------------------------------------------------

matrix_lines = File.readlines(File.join(ROOT_DIR, 'matrix.tsv'), chomp: true)
header = matrix_lines.shift
cols = header.sub(/\A#/, '').split("\t")
raise "unexpected matrix.tsv header: #{header}" unless cols[0, 3] == %w[class kind method] && cols[-3, 3] == %w[first last gaps]

VERSIONS = cols[3..-4].freeze
min_v = gem_ver(options[:min_version]) or raise "bad --min-version: #{options[:min_version]}"
WINDOW = VERSIONS.select { |v| gem_ver(v) >= min_v }.freeze
raise "no versions >= #{options[:min_version]} in matrix.tsv" if WINDOW.empty?

# 対象窓内に存在する行だけ残す
Row = Struct.new(:cls, :kind, :meth, :vis, :first, :last, :newest)
rows = []
matrix_lines.each do |line|
  next if line.empty? || line.start_with?('#')

  f = line.split("\t", -1)
  cls, kind, meth = f[0], f[1], f[2]
  by_version = {}
  VERSIONS.each_with_index { |v, i| by_version[v] = f[3 + i] if f[3 + i] != '-' }
  present_in_window = WINDOW.select { |v| by_version.key?(v) }
  next if present_in_window.empty?

  newest = present_in_window.last
  rows << Row.new(cls, kind, meth, by_version[newest], f[-3], f[-2], newest)
end

# ---------------------------------------------------------------------------
# 2. aliases.tsv — 定数リネームの同一実体グループ(compare.rb と同じ)
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
      ALIAS_ADJ[queue.shift].each do |nbr|
        next if seen.include?(nbr)

        seen << nbr
        queue << nbr
      end
    end
    seen.to_a.sort
  end
end

# ---------------------------------------------------------------------------
# 3. raw/<newest 窓内版>.tsv の A 行 — 祖先解決用(compare.rb と同じ形)
# ---------------------------------------------------------------------------

ANCESTORS = {}
WINDOW.each do |v|
  h = {}
  File.foreach(File.join(RAW_DIR, "#{v}.tsv"), encoding: 'UTF-8') do |line|
    line.chomp!
    next if line.empty?

    f = line.split("\t", -1)
    next unless f[0] == 'A'

    h[f[1]] = { superclass: f[3], ancestors: f[4].to_s.empty? ? [] : f[4].split(',') }
  end
  ANCESTORS[v] = h
end

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

def instance_ancestors(cls, version)
  info = ANCESTORS[version][cls]
  return [] unless info

  info[:ancestors].reject { |a| a == cls }
end

# ---------------------------------------------------------------------------
# 4. doctree エントリ読み込み(既定 + --entries)
# ---------------------------------------------------------------------------

DOC = {}            # [class, kind(s|i|o), method] => file (最初の1件)
DOC_CLASSES = Set.new # 何かしらのエントリ(c/v 含む)があるクラス名

entries_files = [File.join(ROOT_DIR, 'doctree-entries.tsv')] + options[:entries]
entries_files.each do |path|
  File.foreach(path, encoding: 'UTF-8') do |line|
    line.chomp!
    next if line.empty?

    f = line.split("\t", -1)
    file, _line, cls, kind, meth = f[0], f[1], f[2], f[3], f[4]
    DOC_CLASSES << cls
    next unless %w[s i o].include?(kind)

    DOC[[cls, kind, meth]] ||= file
  end
end

# ---------------------------------------------------------------------------
# 5. 解決(compare.rb の tier 1〜5 の逆適用)
# ---------------------------------------------------------------------------

# doc_classes のどれかに (kinds, meth) のエントリがあれば file を返す
def doc_find(doc_classes, kinds, meth)
  doc_classes.each do |c|
    kinds.each do |k|
      file = DOC[[c, k, meth]]
      return [c, file] if file
    end
  end
  nil
end

# 実測 (cls, kind, meth) が「そのクラスとして」文書化されているか
def documented_on_self(cls, kind, meth)
  group = alias_group(cls)
  kinds = [kind, 'o']

  found = doc_find(group, kinds, meth)
  return found if found

  # 実測 initialize (i, 通常 priv) <-> doctree Klass.new
  if kind == 'i' && meth == 'initialize'
    found = doc_find(group, ['s'], 'new')
    return found if found
  end

  # 特殊クラスの付け替え(compare.rb tier 5 の逆)
  case cls
  when 'ARGF'
    found = doc_find(['ARGF.class'], %w[s i o], meth) if kind == 's'
    return found if found
  when /\AErrno::/
    found = doc_find(['Errno::EXXX'], kinds, meth)
    return found if found
    found = doc_find(['Errno::EXXX'], ['s'], 'new') if kind == 'i' && meth == 'initialize'
    return found if found
  when 'Object', 'Kernel'
    found = doc_find(['BasicObject'], kinds, meth)
    return found if found
  end

  nil
end

# 祖先クラス側のエントリ(オーバーライドの親側一括文書化)を探す
def documented_on_ancestor(cls, kind, meth, version)
  chain = kind == 's' ? superclass_chain(cls, version) : instance_ancestors(cls, version)
  chain.each do |anc|
    found = doc_find(alias_group(anc), [kind, 'o'], meth)
    return found if found

    if kind == 'i' && meth == 'initialize'
      found = doc_find(alias_group(anc), ['s'], 'new')
      return found if found
    end
  end
  nil
end

# 子孫クラス(include 先/サブクラス)側のエントリを探す。CRuby が
# Kernel に定義するメソッドを doctree は Object.md に記載する、の逆引き。
$descendants_cache = {}
def descendants(cls, kind, version)
  $descendants_cache[[cls, kind, version]] ||= begin
    list = []
    ANCESTORS[version].each_key do |c|
      next if c == cls

      chain = kind == 's' ? superclass_chain(c, version) : instance_ancestors(c, version)
      list << [chain.length, c] if chain.include?(cls)
    end
    # 継承の浅い順(Kernel なら Array より先に Object)。ヒントが慣例的な
    # 記載先(Object.md 等)を指すようにするため
    list.sort.map { |_, c| c }
  end
end

def documented_on_descendant(cls, kind, meth, version)
  descendants(cls, kind, version).each do |desc|
    found = doc_find(alias_group(desc), [kind, 'o'], meth)
    return found if found

    if kind == 'i' && meth == 'initialize'
      found = doc_find(alias_group(desc), ['s'], 'new')
      return found if found
    end
  end
  nil
end

# ---------------------------------------------------------------------------
# 6. 出力
# ---------------------------------------------------------------------------

out_rows = []
counts = Hash.new(0)

real_singleton = rows.each_with_object(Set.new) { |r, s| s << [r.cls, r.meth] if r.kind == 's' }

rows.each do |r|
  next if documented_on_self(r.cls, r.kind, r.meth)
  # module_function 型の twin: 同名の特異メソッドが実在し、そちらが
  # 文書化されていれば private インスタンス側の片割れは文書済みとみなす
  # (例: Ractor#receive(priv) は Ractor.receive のエントリで足りる)
  next if r.kind == 'i' && r.vis == 'priv' && real_singleton.include?([r.cls, r.meth]) &&
          documented_on_self(r.cls, 's', r.meth)

  anc = documented_on_ancestor(r.cls, r.kind, r.meth, r.newest)
  desc = anc ? nil : documented_on_descendant(r.cls, r.kind, r.meth, r.newest)
  if anc
    category = 'DOC_ON_ANCESTOR'
    hint = "#{anc[0]}(#{anc[1]})"
  elsif desc
    category = 'DOC_ON_DESCENDANT'
    hint = "#{desc[0]}(#{desc[1]})"
  else
    category = 'UNDOC'
    hint = alias_group(r.cls).none? { |c| DOC_CLASSES.include?(c) } ? 'class-undocumented' : '-'
  end
  counts[category] += 1
  out_rows << [r.cls, r.kind, r.meth, r.vis, r.first, r.last, category, hint]
end

puts %w[class kind method vis first last category hint].join("\t")
out_rows.each { |r| puts r.join("\t") }

warn "window: #{WINDOW.first}..#{WINDOW.last} (#{rows.size} methods in window)"
counts.sort.each { |k, v| warn "#{k}\t#{v}" }
undoc_classes = out_rows.select { |r| r[6] == 'UNDOC' }.group_by { |r| r[0] }
warn "UNDOC classes: #{undoc_classes.size} (top: #{undoc_classes.sort_by { |_, v| -v.size }.first(8).map { |c, v| "#{c}=#{v.size}" }.join(', ')})"

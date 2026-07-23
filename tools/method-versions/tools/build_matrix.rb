#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# build_matrix.rb : merge the per-version raw method dumps (see
# dump_methods.rb for the input TSV format) into a set of "existence
# across versions" matrices.
#
# Usage:
#   ruby tools/build_matrix.rb
#
# Run from anywhere; paths are resolved relative to this file, i.e. the
# repository root is the parent directory of tools/. No arguments, no
# external gems (standard library only). Re-running produces byte
# identical output (all iteration is over data sorted into a fixed
# order), so the generated files can be safely committed and diffed.
#
# Inputs:
#   raw/<version>.tsv  for each version in VERSIONS below, in the format
#   produced by dump_methods.rb:
#     V <RUBY_VERSION> <PATCHLEVEL> <DESCRIPTION>
#     P <constant path> <canonical module name>   (includes aliases)
#     A <name> <class|module> <superclass> <ancestors joined by ,>
#     M <name> <s|i> <pub|priv|prot> <method name>
#
# Outputs (written next to raw/, i.e. the repository root):
#   matrix.tsv       - one row per (class, kind, method) triple observed
#                       in any version; one column per version holding
#                       the visibility (pub|priv|prot) or "-" if the
#                       method did not exist (as a method defined
#                       directly on that class/module) in that version,
#                       plus first/last/gaps summary columns.
#   classes.tsv       - one row per class/module name observed in any
#                       version; one column per version holding
#                       class|module|"-", plus first/last and a summary
#                       of how the superclass changed over time.
#   aliases.tsv       - one row per constant path whose canonical name
#                       differs from the path in at least one version
#                       (e.g. Fixnum -> Integer); one column per version
#                       holding the canonical name observed for that
#                       path in that version, or "-".
#   notes-matrix.md   - row counts, per-version stats, gap/visibility
#                       change listings, and the validation checks
#                       described in the task (fixed spot checks +
#                       cross-check of M-line counts against the
#                       matrix).
#
# All output files are TSV with a leading "#"-commented header row
# (except notes-matrix.md, which is Markdown), sorted so that output is
# deterministic given the same inputs.

require "set"

ROOT_DIR = File.expand_path("..", __dir__)
RAW_DIR  = File.join(ROOT_DIR, "raw")

VERSIONS = %w[
  1.8.6 1.8.7 1.9.1 1.9.2 1.9.3 2.0.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7
  3.0 3.1 3.2 3.3 3.4 4.0
].freeze

# --- parsing ---------------------------------------------------------

ParsedVersion = Struct.new(:paths, :classes, :methods, :m_count)

# paths   : Array of [path, canonical]
# classes : Hash[name] => { type: "class"|"module", superclass: String }
# methods : Hash[[name, kind, method]] => vis ("pub"|"priv"|"prot")
def parse_version_file(file)
  paths = []
  classes = {}
  methods = {}
  m_count = 0

  File.foreach(file, encoding: "UTF-8") do |line|
    line.chomp!
    next if line.empty?

    fields = line.split("\t", -1)
    case fields[0]
    when "P"
      _, path, canonical = fields
      paths << [path, canonical]
    when "A"
      _, name, type, superclass = fields
      classes[name] = { type: type, superclass: superclass }
    when "M"
      _, name, kind, vis, method = fields
      methods[[name, kind, method]] = vis
      m_count += 1
    when "V"
      # version metadata is not needed; the version label comes from the
      # filename / VERSIONS list.
    else
      raise "unrecognized record type #{fields[0].inspect} in #{file}"
    end
  end

  ParsedVersion.new(paths, classes, methods, m_count)
end

data = {}
VERSIONS.each do |v|
  file = File.join(RAW_DIR, "#{v}.tsv")
  raise "missing raw file: #{file}" unless File.exist?(file)

  data[v] = parse_version_file(file)
end

# --- helpers -----------------------------------------------------------

# Collapse a contiguous run within VERSIONS (indices lo..hi inclusive)
# into ranges of missing versions, given a boolean "present?" lookup.
def gap_ranges(present_versions)
  return "-" if present_versions.empty?

  first_idx = VERSIONS.index(present_versions.first)
  last_idx  = VERSIONS.index(present_versions.last)
  present_set = present_versions.to_set

  ranges = []
  run_start = nil
  (first_idx..last_idx).each do |idx|
    v = VERSIONS[idx]
    if present_set.include?(v)
      if run_start
        ranges << (run_start..(idx - 1))
        run_start = nil
      end
    else
      run_start ||= idx
    end
  end
  ranges << (run_start..last_idx) if run_start

  return "-" if ranges.empty?

  ranges.map { |r|
    if r.first == r.last
      VERSIONS[r.first]
    else
      "#{VERSIONS[r.first]}-#{VERSIONS[r.last]}"
    end
  }.join(";")
end

# Collapse a sequence of [version, value] pairs (only for versions where
# the value is defined) into "v1:val1;v2:val2" form, or plain "val" if it
# never changes.
def change_summary(pairs)
  return "-" if pairs.empty?

  collapsed = []
  prev = nil
  pairs.each do |v, val|
    if val != prev
      collapsed << [v, val]
      prev = val
    end
  end

  if collapsed.size == 1
    collapsed.first[1]
  else
    collapsed.map { |v, val| "#{v}:#{val}" }.join(";")
  end
end

# --- matrix.tsv ----------------------------------------------------------

row_keys = {} # [class, kind, method] => { version => vis }
data.each do |v, d|
  d.methods.each do |(cls, kind, meth), vis|
    (row_keys[[cls, kind, meth]] ||= {})[v] = vis
  end
end

sorted_rows = row_keys.keys.sort_by { |cls, kind, meth| [cls, kind, meth] }

matrix_lines = []
matrix_lines << "#class\tkind\tmethod\t#{VERSIONS.join("\t")}\tfirst\tlast\tgaps"

visibility_changed_rows = []

sorted_rows.each do |cls, kind, meth|
  by_version = row_keys[[cls, kind, meth]]
  present_versions = VERSIONS.select { |v| by_version.key?(v) }
  first = present_versions.first
  last  = present_versions.last
  gaps  = gap_ranges(present_versions)

  vises_in_order = present_versions.map { |v| by_version[v] }
  if vises_in_order.uniq.size > 1
    visibility_changed_rows << [cls, kind, meth, present_versions.zip(vises_in_order)]
  end

  cols = VERSIONS.map { |v| by_version[v] || "-" }
  matrix_lines << ([cls, kind, meth] + cols + [first, last, gaps]).join("\t")
end

File.write(File.join(ROOT_DIR, "matrix.tsv"), matrix_lines.join("\n") + "\n")

# --- classes.tsv -----------------------------------------------------------

class_types = {}  # name => { version => "class"|"module" }
class_supers = {} # name => { version => superclass string ("" for root) }
data.each do |v, d|
  d.classes.each do |name, info|
    (class_types[name] ||= {})[v] = info[:type]
    (class_supers[name] ||= {})[v] = info[:superclass]
  end
end

sorted_classes = class_types.keys.sort

classes_lines = []
classes_lines << "#class\t#{VERSIONS.join("\t")}\tfirst\tlast\tsuperclass"

sorted_classes.each do |name|
  types_by_version = class_types[name]
  present_versions = VERSIONS.select { |v| types_by_version.key?(v) }
  first = present_versions.first
  last  = present_versions.last

  cols = VERSIONS.map { |v| types_by_version[v] || "-" }

  # Superclass history: only meaningful for versions where this name was
  # recorded as a class (modules have no superclass). Empty string means
  # "no superclass" (BasicObject, or Object on pre-BasicObject rubies) and
  # is rendered as "-".
  super_pairs = present_versions
    .select { |v| types_by_version[v] == "class" }
    .map { |v| [v, class_supers[name][v].to_s.empty? ? "-" : class_supers[name][v]] }
  superclass_summary = types_by_version.values.all? { |t| t == "module" } ? "-" : change_summary(super_pairs)

  classes_lines << ([name] + cols + [first, last, superclass_summary]).join("\t")
end

File.write(File.join(ROOT_DIR, "classes.tsv"), classes_lines.join("\n") + "\n")

# --- aliases.tsv -----------------------------------------------------------

alias_canonicals = {} # path => { version => canonical }
data.each do |v, d|
  d.paths.each do |path, canonical|
    (alias_canonicals[path] ||= {})[v] = canonical
  end
end

alias_paths = alias_canonicals.select { |path, by_version|
  by_version.any? { |_v, canonical| canonical != path }
}.keys.sort

aliases_lines = []
aliases_lines << "#path\tcanonical\t#{VERSIONS.join("\t")}"

alias_paths.each do |path|
  by_version = alias_canonicals[path]
  present_versions = VERSIONS.select { |v| by_version.key?(v) }
  canonical_summary = by_version[present_versions.last]
  cols = VERSIONS.map { |v| by_version[v] || "-" }
  aliases_lines << ([path, canonical_summary] + cols).join("\t")
end

File.write(File.join(ROOT_DIR, "aliases.tsv"), aliases_lines.join("\n") + "\n")

# --- validation --------------------------------------------------------

# 1) fixed spot checks
def row_for(row_keys, cls, kind, meth)
  row_keys[[cls, kind, meth]] || {}
end

checks = []

prepend_row = row_for(row_keys, "Module", "i", "prepend")
prepend_expected_absent = %w[1.8.6 1.8.7 1.9.1 1.9.2 1.9.3]
prepend_ok =
  prepend_expected_absent.all? { |v| !prepend_row.key?(v) } &&
  prepend_row["2.0.0"] == "priv" &&
  %w[2.1 2.2 2.3 2.4 2.5 2.6 2.7 3.0 3.1 3.2 3.3 3.4 4.0].all? { |v| prepend_row[v] == "pub" }
checks << ["Module#prepend (i): 1.9.3以前=-, 2.0.0=priv, 2.1以降=pub", prepend_ok]

byterindex_row = row_for(row_keys, "String", "i", "byterindex")
first_present = VERSIONS.find { |v| byterindex_row.key?(v) }
checks << ["String#byterindex (i): first=3.2", first_present == "3.2"]

match_row = row_for(row_keys, "Symbol", "i", "match")
first_present = VERSIONS.find { |v| match_row.key?(v) }
checks << ["Symbol#match (i): first=1.9.1", first_present == "1.9.1"]

string_prepend_row = row_for(row_keys, "String", "i", "prepend")
first_present = VERSIONS.find { |v| string_prepend_row.key?(v) }
checks << ["String#prepend (i): first=1.9.3", first_present == "1.9.3"]

sum_row = row_for(row_keys, "Array", "i", "sum")
first_present = VERSIONS.find { |v| sum_row.key?(v) }
checks << ["Array#sum (i): first=2.4", first_present == "2.4"]

# 2) M-line count cross-check per version
m_count_checks = VERSIONS.map { |v|
  raw_count = data[v].m_count
  matrix_count = row_keys.values.count { |by_version| by_version.key?(v) }
  [v, raw_count, matrix_count, raw_count == matrix_count]
}

all_ok = checks.all? { |_desc, ok| ok } && m_count_checks.all? { |*, ok| ok }

# --- notes-matrix.md -----------------------------------------------------

notes = +""
notes << "# builtin-method-versions: matrix build notes\n\n"
notes << "Generated by `tools/build_matrix.rb` from `raw/<version>.tsv` "
notes << "(#{VERSIONS.size} versions: #{VERSIONS.join(', ')}).\n\n"

notes << "## Row counts\n\n"
notes << "- matrix.tsv: #{sorted_rows.size} rows (class, kind, method triples)\n"
notes << "- classes.tsv: #{sorted_classes.size} rows (class/module names)\n"
notes << "- aliases.tsv: #{alias_paths.size} rows (constant paths whose canonical name differs from the path in at least one version)\n\n"

notes << "## Per-version existence counts\n\n"
notes << "Number of (class, kind, method) rows present (non-\"-\") per version, and number of class/module names present per version:\n\n"
notes << "| version | methods present | classes/modules present |\n"
notes << "|---|---:|---:|\n"
VERSIONS.each do |v|
  methods_present = row_keys.values.count { |by_version| by_version.key?(v) }
  classes_present = class_types.values.count { |by_version| by_version.key?(v) }
  notes << "| #{v} | #{methods_present} | #{classes_present} |\n"
end
notes << "\n"

gap_rows = sorted_rows.select { |cls, kind, meth|
  by_version = row_keys[[cls, kind, meth]]
  present_versions = VERSIONS.select { |v| by_version.key?(v) }
  gap_ranges(present_versions) != "-"
}

notes << "## Rows with existence gaps\n\n"
notes << "#{gap_rows.size} rows have a non-contiguous existence (removed then re-added under the same class/kind/method).\n\n"
if gap_rows.any?
  notes << "Examples (up to 15):\n\n"
  gap_rows.first(15).each do |cls, kind, meth|
    by_version = row_keys[[cls, kind, meth]]
    present_versions = VERSIONS.select { |v| by_version.key?(v) }
    notes << "- `#{cls}#{kind == 's' ? '.' : '#'}#{meth}` (kind=#{kind}): gaps=#{gap_ranges(present_versions)}\n"
  end
  notes << "\n"
end

notes << "## Rows with a visibility change over time\n\n"
notes << "#{visibility_changed_rows.size} rows change visibility (pub/priv/prot) at least once while remaining otherwise present.\n\n"
if visibility_changed_rows.any?
  notes << "Representative examples (up to 15):\n\n"
  visibility_changed_rows.first(15).each do |cls, kind, meth, pairs|
    transitions = pairs.each_cons(2).select { |(_v1, vis1), (_v2, vis2)| vis1 != vis2 }
    transitions_str = transitions.map { |(v1, vis1), (v2, vis2)| "#{v1}(#{vis1})->#{v2}(#{vis2})" }.join(", ")
    notes << "- `#{cls}#{kind == 's' ? '.' : '#'}#{meth}` (kind=#{kind}): #{transitions_str}\n"
  end
  notes << "\n"
end

notes << "## Validation\n\n"
notes << "### Fixed spot checks\n\n"
checks.each do |desc, ok|
  notes << "- [#{ok ? 'PASS' : 'FAIL'}] #{desc}\n"
end
notes << "\n"

notes << "### M-line count cross-check (raw file vs. matrix non-\"-\" cells)\n\n"
notes << "| version | raw M lines | matrix non-\"-\" cells | match |\n"
notes << "|---|---:|---:|---|\n"
m_count_checks.each do |v, raw_count, matrix_count, ok|
  notes << "| #{v} | #{raw_count} | #{matrix_count} | #{ok ? 'PASS' : 'FAIL'} |\n"
end
notes << "\n"

notes << "### Overall result: #{all_ok ? 'ALL CHECKS PASS' : 'SOME CHECKS FAILED'}\n"

File.write(File.join(ROOT_DIR, "notes-matrix.md"), notes)

warn "done. matrix.tsv=#{sorted_rows.size} rows, classes.tsv=#{sorted_classes.size} rows, aliases.tsv=#{alias_paths.size} rows. validation: #{all_ok ? 'PASS' : 'FAIL'}"

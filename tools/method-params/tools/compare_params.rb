# 段階 1: DB のシグネチャ行(組み込み)を実 Ruby と RBS に突き合わせる
# usage: ruby tools/method-params/tools/compare_params.rb <method-params dir> <ver>
#   result/<ver>/mismatch.tsv          シグネチャ行ごとの判定(ok の行も含む)
#   result/<ver>/mismatch-entries.tsv  エントリ単位で ok/ok-split でないものだけ(ファイル・行番号順)
#   result/<ver>/entry-verdicts.tsv    全エントリの判定(diff_versions.rb が使う)
#   result/<ver>/summary.txt           判定ごとの件数(行単位・エントリ単位)
require "fileutils"

dir, ver = ARGV
abort "usage: compare_params.rb <method-params dir> <ver>" unless ver
SCOPE = "_builtin"

def read_tsv(path)
  lines = File.readlines(path, chomp: true)
  head = lines.shift.split("\t", -1)
  lines.map { |l| head.zip(l.split("\t", -1)).to_h }
end

# ---- 実 Ruby ----
Real = Struct.new(:name, :arity, :tokens, :source, :vis)
real = {}   # [class, kind, name] => Real
real_classes = {}
File.foreach(File.join(dir, "real", ver, "builtin.tsv"), chomp: true) do |l|
  f = l.split("\t", -1)
  next unless f[0] == "P"
  _, k, kind, vis, name, arity, params, _owner, source = f
  toks = params == "-" ? [] : params.split(" ").map { |t| t.split(":", 2) }
  toks.each { |t| t[1] = nil if t[1] && t[1] =~ /\A[*&]+\z/ } # 無名の * ** & は名前なし
  real[[k, kind, name]] = Real.new(name, arity.to_i, toks, source, vis)
  real_classes[k] = true
end

# ---- RBS ----
rbs = Hash.new { |h, k| h[k] = [] } # key => [{names:, min:, max:, block:}]
read_tsv(File.join(dir, "rbs", "#{ver}.tsv")).each do |r|
  rbs[r["key"]] << {key: r["key"], idx: r["idx"], names: r["params"].split(","),
                    min: r["arity_min"] == "-" ? nil : r["arity_min"].to_i,
                    max: r["arity_max"] == "-" ? nil : r["arity_max"].to_i,
                    block: r["block"]}
end

# ---- 対応づけ ----
def find_real(real, real_classes, k, typemark, line_name, names)
  return [nil, "no-class"] unless real_classes[k]
  cands = ([line_name] + names).uniq
  cands.each do |n|
    order =
      case typemark
      when "#" then [["i", n]]
      when "." then n == "new" ? [["s", n], ["i", "initialize"]] : [["s", n]]
      else [["s", n], ["i", n]]
      end
    order.each do |kind, nm|
      r = real[[k, kind, nm]]
      return [r, nil] if r
    end
  end
  [nil, cands.include?("new") && typemark == "." ? "no-real:inherited" : "no-real"]
end

def rbs_keys(k, typemark, line_name, names)
  ([line_name] + names).uniq.flat_map do |n|
    ks = case typemark
         when "#" then ["#{k}##{n}"]
         when "." then ["#{k}.#{n}"] + (n == "new" ? ["#{k}#initialize"] : [])
         else ["#{k}.#{n}", "#{k}##{n}"]
         end
    ks
  end.uniq
end

def ival(s) = s.to_i

# 実 Ruby 側との判定
def judge_real(row, r)
  req, opt, rest = ival(row["req"]), ival(row["opt"]), ival(row["rest"])
  kwreq = row["kwreq"].split(",")
  kwopt = row["kwopt"].split(",")
  kwrest = ival(row["kwrest"])
  has_kw = !kwreq.empty? || !kwopt.empty? || kwrest == 1
  has_optional = opt > 0 || rest == 1 || has_kw
  if r.source == "C"
    ar = r.arity
    if ar >= 0
      return ["ok", ""] if req == ar && !has_optional
      return ["req-count", "doc_req=#{req} real_arity=#{ar}"] if req != ar
      return ["doc-allows-more", "doc has opt/rest/kw but C arity=#{ar}"]
    else
      real_req = -ar - 1
      return ["req-count", "doc_req=#{req} real_req>=#{real_req}"] if req < real_req
      return ["doc-no-optional?", "doc has no opt/rest/kw; C arity=#{ar}"] unless has_optional
      return ["ok", ""]
    end
  end
  t = r.tokens
  r_req = t.count { |x| x[0] == "req" }
  r_opt = t.count { |x| x[0] == "opt" }
  r_rest = t.any? { |x| x[0] == "rest" } ? 1 : 0
  r_kwreq = t.select { |x| x[0] == "keyreq" }.map { |x| x[1] }.compact.sort
  r_kwopt = t.select { |x| x[0] == "key" }.map { |x| x[1] }.compact.sort
  r_kwrest = t.any? { |x| x[0] == "keyrest" } ? 1 : 0
  r_block = t.any? { |x| x[0] == "block" }
  # 無名の転送(*, **, &)は arity から何も言えない
  if t.any? { |x| x[0] == "rest" && x[1].nil? } && t.any? { |x| x[0] == "keyrest" && x[1].nil? }
    return ["forwarding?", "real forwards *, **#{r_block ? ', &' : ''}"]
  end
  return ["req-count", "doc=#{req} real=#{r_req}"] if req != r_req
  return ["opt-count", "doc=#{opt} real=#{r_opt}"] if opt != r_opt
  return ["rest", "doc=#{rest} real=#{r_rest}"] if rest != r_rest
  if kwreq.sort != r_kwreq || kwopt.sort != r_kwopt || kwrest != r_kwrest
    return ["kw-mismatch", "doc=req[#{kwreq.join(',')}] opt[#{kwopt.join(',')}] rest#{kwrest} real=req[#{r_kwreq.join(',')}] opt[#{r_kwopt.join(',')}] rest#{r_kwrest}"]
  end
  rn = t.select { |x| %w[req opt].include?(x[0]) }.map { |x| x[1] }
  dn = row["pos_names"].split(",").reject { |x| x.start_with?("*") || x.start_with?("=") }
  if !row["union"] && !rn.empty? && rn.all? && rn != dn # 合成した行では行ごとに名前が違うので比べない
    return ["name-mismatch", "doc=#{dn.join(',')} real=#{rn.join(',')}"]
  end
  return ["block-missing", "real has &block"] if r_block && ival(row["block"]) == 0
  ["ok", ""]
end

SEVERITY = %w[ok forwarding? doc-no-optional? block-missing name-mismatch kw-mismatch rest opt-count doc-allows-more req-count]

# 同じエントリの ok な行を 1 つに合成する(引数パターンごとに行を分ける書き方の吸収)
def union_row(rows)
  mn = rows.map { |r| ival(r["req"]) }.min
  mx = rows.map { |r| ival(r["req"]) + ival(r["opt"]) }.max
  kws = rows.map { |r| r["kwreq"].split(",") }
  kwreq = kws.reduce(:&)
  allkw = (rows.flat_map { |r| r["kwreq"].split(",") + r["kwopt"].split(",") }).uniq
  longest = rows.max_by { |r| r["pos_names"].split(",").size }
  {"req" => mn.to_s, "opt" => (mx - mn).to_s,
   "rest" => rows.map { |r| ival(r["rest"]) }.max.to_s,
   "kwreq" => kwreq.join(","), "kwopt" => (allkw - kwreq).join(","),
   "kwrest" => rows.map { |r| ival(r["kwrest"]) }.max.to_s,
   "block" => rows.map { |r| ival(r["block"]) }.max.to_s,
   "pos_names" => longest["pos_names"], "union" => true}
end

# ---- RBS スコア(RbsOverloadMatcher と同じ発想) ----
def line_features(row)
  names = row["pos_names"].split(",").reject { |x| x.start_with?("=") }.map { |x| x.sub(/\A\*/, "") }.reject(&:empty?) +
          row["kwreq"].split(",") + row["kwopt"].split(",")
  max = ival(row["rest"]) == 1 ? nil : ival(row["req"]) + ival(row["opt"])
  {names: names, min: ival(row["req"]), max: max, block: ival(row["block"]) == 1}
end

def overlap?(ov, lf)
  return true if ov[:min].nil? # アリティ不明は重なるとみなす
  omax = ov[:max] || Float::INFINITY
  lmax = lf[:max] || Float::INFINITY
  ov[:min] <= lmax && lf[:min] <= omax
end

def score(ov, lf)
  s = 0
  case ov[:block]
  when "req" then s += lf[:block] ? 2 : -3
  when "opt" then s += 1
  else s += lf[:block] ? -3 : 2
  end
  s += 2 * (ov[:names] & lf[:names]).size
  s += overlap?(ov, lf) ? 1 : -2 if ov[:min]
  s
end

def plausible?(ov, lf)
  return true if overlap?(ov, lf)
  !ov[:names].empty? && !lf[:names].empty? && !(ov[:names] & lf[:names]).empty?
end

# ---- 本体 ----
sigs = read_tsv(File.join(dir, "db-extract", "sigs-#{ver}.tsv")).select { |r| r["lib"] == SCOPE }
entries = sigs.group_by { |r| [r["class"], r["typemark"], r["names"], r["loc"]] }

out_lines = []
out_entries = []
all_entries = []
line_counts = Hash.new(0)
entry_real_counts = Hash.new(0)
entry_rbs_counts = Hash.new(0)
line_rbs_counts = Hash.new(0)

entries.each do |(k, tm, names_s, loc), rows|
  names = names_s.split(",")
  oks = rows.select { |r| r["status"] == "ok" }
  # RBS 側: 全シグネチャ行の名前に対応するキーのオーバーロードを集める
  keys = rows.flat_map { |r| rbs_keys(k, tm, r["name"], names) }.uniq
  ovs = keys.flat_map { |kk| rbs.key?(kk) ? rbs[kk] : [] }.uniq { |o| [o[:key], o[:idx]] }
  has_rbs = !ovs.empty?
  best_for = {} # ov => true
  line_rbs = {}
  oks.each do |r|
    lf = line_features(r)
    if ovs.empty?
      line_rbs[r] = "no-rbs"
      next
    end
    best = ovs.max_by.with_index { |o, i| [score(o, lf), -i] }
    best_for[best] = true
    line_rbs[r] = ovs.any? { |o| plausible?(o, lf) } ? "ok" : "rbs-unmatched-sig"
  end
  unmatched_ov = ovs.reject { |o| best_for[o] || oks.any? { |r| overlap?(o, line_features(r)) } }
  # 行ごとの判定
  verdicts = []
  real_rows = []
  rows.each do |r|
    if r["status"] != "ok"
      v = "skip:#{r['status'].split(':').first}"
      out_lines << [loc, k, tm, names_s, r["idx"], r["raw"], v, r["status"], "", "", "", has_rbs ? ovs.size : "-", "skip"]
      next
    end
    real_row, why = find_real(real, real_classes, k, tm, r["name"], names)
    if real_row
      v, d = judge_real(r, real_row)
      ra, rp, rs = real_row.arity, real_row.tokens.map { |t| t.compact.join(":") }.join(" "), real_row.source
    else
      v, d, ra, rp, rs = why, "", "", "", ""
    end
    verdicts << v
    real_rows << real_row
    line_counts[v] += 1
    line_rbs_counts[line_rbs[r]] += 1
    out_lines << [loc, k, tm, names_s, r["idx"], r["raw"], v, d, ra, rp, rs, has_rbs ? ovs.size : "-", line_rbs[r]]
  end
  next if oks.empty?
  # エントリ単位
  ev = verdicts.include?("ok") ? "ok" :
       (verdicts.find { |v| !v.start_with?("no-") } ? verdicts.reject { |v| v.start_with?("no-") }.min_by { |v| SEVERITY.index(v) || 99 } : verdicts.first)
  if ev != "ok" && !ev.start_with?("no-") && oks.size >= 2 && real_rows.compact.size == oks.size && real_rows.uniq.size == 1
    uv, = judge_real(union_row(oks), real_rows.first)
    if uv == "ok"
      ev = "ok-split"
      out_lines.last(rows.size).each { |l| l[7] = (l[7].to_s + " [entry:ok-split]").strip }
    end
  end
  entry_real_counts[ev] += 1
  rv = if !has_rbs then "no-rbs"
       elsif line_rbs.values.include?("rbs-unmatched-sig") then "rbs-unmatched-sig"
       elsif !unmatched_ov.empty? then "rbs-unmatched-overload"
       else "ok" end
  entry_rbs_counts[rv] += 1
  all_entries << [loc, k, tm, names_s, ev, rv]
  next if %w[ok ok-split].include?(ev) && %w[ok no-rbs].include?(rv)
  detail = out_lines.last(rows.size).map { |l| l[7] }.reject(&:empty?).uniq.join(" / ")
  detail += " [unmatched-overload: #{unmatched_ov.map { |o| o[:key] + '#' + o[:idx] }.join(' ')}]" if rv == "rbs-unmatched-overload"
  out_entries << [loc, k, tm, names_s, ev, rv, detail, rows.first["raw"]]
end

res = File.join(dir, "result", ver)
FileUtils.mkdir_p(res)
File.open(File.join(res, "mismatch.tsv"), "w") do |f|
  f.puts %w[loc class typemark names idx raw verdict detail real_arity real_params real_source rbs_overloads rbs_verdict].join("\t")
  out_lines.each { |l| f.puts l.join("\t") }
end
sortkey = ->(e) { f, n = e[0].split(":"); [f, n.to_i] }
File.open(File.join(res, "mismatch-entries.tsv"), "w") do |f|
  f.puts %w[loc class typemark names real_verdict rbs_verdict detail first_raw].join("\t")
  out_entries.sort_by(&sortkey).each { |l| f.puts l.join("\t") }
end
File.open(File.join(res, "entry-verdicts.tsv"), "w") do |f|
  f.puts %w[loc class typemark names real_verdict rbs_verdict].join("\t")
  all_entries.each { |l| f.puts l.join("\t") }
end
File.open(File.join(res, "summary.txt"), "w") do |f|
  f.puts "#{ver} (#{SCOPE}): entries=#{entry_real_counts.values.sum} lines(ok-status)=#{line_counts.values.sum}"
  f.puts "skipped lines (unusual/parse-error)=#{out_lines.count { |l| l[6].start_with?('skip:') }}"
  { "line-level vs real" => line_counts, "entry-level vs real" => entry_real_counts,
    "line-level vs rbs" => line_rbs_counts, "entry-level vs rbs" => entry_rbs_counts }.each do |t, h|
    f.puts "", "[#{t}]"
    h.sort_by { |k, v| [-v, k] }.each { |k, v| f.puts "#{k}\t#{v}" }
  end
end
puts File.read(File.join(res, "summary.txt")).lines.first(2)

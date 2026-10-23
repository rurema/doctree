# 段階 2: 隣り合う版の間で、実 Ruby・RBS・doc の引数指紋の変化を列挙する
# usage: ruby tools/method-params/tools/diff_versions.rb <method-params dir> [--stdlib] <ver...>
#   組み込み(既定):
#     result/changes.tsv           変化のあったメソッドと flag
#     result/changes-summary.txt   flag ごと・版の組ごとの件数
#   --stdlib: `_builtin` 以外の全ライブラリ。ライブラリごとに、そのライブラリのいずれかの版の doc に
#     あるメソッドだけを対象にする。実 Ruby と RBS は compare_params.rb --stdlib と同じ順で引く
#     (A 行の別名のクラスは Module#name の側の行で比べる)
#     result/lib-changes.tsv・result/lib-changes-summary.txt(先頭に lib 列)
require "fileutils"

dir, *vers = ARGV
stdlib = vers.delete("--stdlib") ? true : false
abort "usage: diff_versions.rb <method-params dir> [--stdlib] <ver...>" if vers.size < 2

def read_tsv(path)
  lines = File.readlines(path, chomp: true)
  head = lines.shift.split("\t", -1)
  lines.map { |l| head.zip(l.split("\t", -1)).to_h }
end

# src はファイルのパスか行の配列
def load_real(src, aliases = nil)
  real = {}
  (src.is_a?(String) ? File.foreach(src, chomp: true) : src).each do |l|
    f = l.split("\t", -1)
    aliases[f[1]] = f[2] if aliases && f[0] == "A"
    next unless f[0] == "P"
    _, k, kind, _vis, name, arity, params, _owner, source = f
    real[[k, kind, name]] = {arity: arity.to_i, params: params, c: source == "C",
                             fp: "#{arity}|#{params}|#{source == 'C' ? 'C' : 'rb'}"}
  end
  real
end

# real/<ver>/lib.tsv を lib 列で分ける: lib => [lib 列を除いた行]
def load_lib_lines(path)
  h = Hash.new { |hh, k| hh[k] = [] }
  File.foreach(path, chomp: true) do |l|
    lib, rest = l.split("\t", 2)
    h[lib] << rest
  end
  h
end

def load_rbs(path, with_lib)
  rbs = Hash.new { |h, k| h[k] = [] }
  read_tsv(path).each do |r|
    key = with_lib ? [r["key"], r["lib"]] : r["key"]
    rbs[key] << "#{r['params']}|#{r['arity_min']}|#{r['arity_max']}|#{r['block']}"
  end
  rbs.transform_values { |a| a.sort }
end

def kinds_of(tm) = case tm when "#" then ["i"] when "." then ["s"] else %w[s i] end

def load_doc(rows)
  doc = Hash.new { |h, k| h[k] = [] }
  rows.each do |r|
    norm = r["status"] == "ok" ?
      [r["req"], r["opt"], r["rest"], r["kwreq"], r["kwopt"], r["kwrest"], r["block"], r["pos_names"]].join("/") :
      "raw:" + r["raw"].gsub(/\s+/, " ")
    r["names"].split(",").each do |n|
      kinds_of(r["typemark"]).each { |kd| doc[[r["class"], kd, n]] << norm }
      doc[[r["class"], "i", "initialize"]] << norm if r["typemark"] == "." && n == "new"
    end
  end
  doc.transform_values { |a| a.uniq.sort }
end

# 段階 1 のエントリ単位の判定(実 Ruby との突き合わせ)。複数エントリが同じキーに当たるときは
# 一貫していない方を優先する
def load_verdict(rows)
  verdict = {}
  rows.each do |r|
    r["names"].split(",").each do |n|
      keys = kinds_of(r["typemark"]).map { |kd| [r["class"], kd, n] }
      keys << [r["class"], "i", "initialize"] if r["typemark"] == "." && n == "new"
      keys.each do |key|
        old = verdict[key]
        verdict[key] = r["real_verdict"] if old.nil? || %w[ok ok-split].include?(old)
      end
    end
  end
  verdict
end

def rbs_key(k, kind, name) = "#{k}#{kind == 's' ? '.' : '#'}#{name}"

# 隣り合う版 a, b の 1 単位(組み込み全体、またはライブラリ 1 つ)の差分行
def diff_pair(a, b, da, db, keys)
  rows = []
  keys.each do |key|
    k, kind, name = key
    ra, rb = da[:real][key], db[:real][key]
    next unless ra && rb
    xa, xb = da[:rbs].call(k, kind, name), db[:rbs].call(k, kind, name)
    da_doc, db_doc = da[:doc][key], db[:doc][key]
    real_ch = ra[:fp] != rb[:fp]
    rbs_ch = xa && xb && xa != xb
    doc_ch = da_doc && db_doc && da_doc != db_doc
    next unless real_ch || rbs_ch || doc_ch
    va = db[:verdict][key] || "-"
    if real_ch || rbs_ch
      source = real_ch && rbs_ch ? "both" : real_ch ? "real" : "rbs"
      flag =
        if da_doc.nil? || db_doc.nil? then "no-doc"
        elsif doc_ch then "reflected"
        elsif !real_ch then "rbs-only"
        elsif ra[:c] && rb[:c] && !rbs_ch &&
              ((ra[:arity] >= 0 && rb[:arity] == -1) || (ra[:arity] == -1 && rb[:arity] >= 0))
          "c-decl-change"
        elsif %w[ok ok-split].include?(va) then "already-consistent" # 変化後の doc は実 Ruby と整合
        elsif va == "forwarding?" then "forwarding"
        elsif va == "name-mismatch" then "name-only" # 変化後に残る差が仮引数名だけ
        elsif ra[:c] != rb[:c] && ra[:arity] == rb[:arity] && !rbs_ch && va == "doc-no-optional?" &&
              !(ra[:c] ? rb : ra)[:params].split(" ").any? { |t| t =~ /\A(key|keyreq|keyrest)/ }
          # C と Ruby 定義の入れ替えで arity が同じ(API の変更ではなく実装の移行。キーワードが
          # 現れた場合は C 側から分からないので unreflected に残す)
          "impl-change"
        else "unreflected"
        end
    else
      source = "-"
      flag = "doc-only"
    end
    rows << [k, kind, name, a, b, source, ra[:fp], rb[:fp], (xa || []).join(" ; "), (xb || []).join(" ; "),
             (da_doc || []).join(" ; "), (db_doc || []).join(" ; "), doc_ch ? 1 : 0, va, flag]
  end
  rows
end

rows = []
if stdlib
  # lib => 版 => {real:, rbs:, doc:, verdict:}
  units = Hash.new { |h, k| h[k] = {} }
  vers.each do |v|
    builtin = load_real(File.join(dir, "real", v, "builtin.tsv"))
    core = load_rbs(File.join(dir, "rbs", "#{v}.tsv"), false)
    std = load_rbs(File.join(dir, "rbs", "#{v}-stdlib.tsv"), true)
    std_libs = Hash.new { |h, k| h[k] = [] }
    std.each_key { |key, l| std_libs[key] << l }
    status = {}
    File.foreach(File.join(dir, "real", v, "lib-status.tsv"), chomp: true) do |l|
      lib, md, = l.split("\t")
      status[lib] = md
    end
    lib_lines = load_lib_lines(File.join(dir, "real", v, "lib.tsv"))
    sigs = read_tsv(File.join(dir, "db-extract", "sigs-#{v}.tsv")).reject { |r| r["lib"] == "_builtin" }.group_by { |r| r["lib"] }
    ev = read_tsv(File.join(dir, "result", v, "lib-entry-verdicts.tsv")).group_by { |r| r["lib"] }
    sigs.each do |lib, srows|
      md = status[lib]
      next if md.nil? || md == "failed" || !lib_lines.key?(lib)
      aliases = {}
      parent = lib.split("/").first
      real = {}
      if parent != lib && status[parent] && status[parent] != "failed" && lib_lines.key?(parent)
        real = load_real(lib_lines[parent], aliases)
      end
      real = builtin.merge(real).merge(load_real(lib_lines[lib], aliases))
      unless aliases.empty?
        by_class = real.keys.group_by(&:first)
        aliases.each do |path, name|
          (by_class[name] || []).each { |(_, kind, n)| real[[path, kind, n]] ||= real[[name, kind, n]] }
        end
      end
      prefer = [lib.tr("/", "-"), lib.split("/").first.tr("_", "-"), lib.split("/").first]
      rbs = lambda do |k, kind, name|
        key = rbs_key(k, kind, name)
        ls = std_libs[key]
        next core[key] if ls.empty?
        std[[key, prefer.find { |n| ls.include?(n) } || ls.min]]
      end
      units[lib][v] = {real: real, rbs: rbs, doc: load_doc(srows), verdict: load_verdict(ev[lib] || [])}
    end
  end
  units.keys.sort.each do |lib|
    vers.each_cons(2) do |a, b|
      da, db = units[lib][a], units[lib][b]
      next unless da && db
      keys = (da[:doc].keys | db[:doc].keys).sort
      diff_pair(a, b, da, db, keys).each { |r| rows << [lib] + r }
    end
  end
  rows.sort_by! { |r| [r[4], r[0], r[1], r[2], r[3]] }
  out, sum, head, off = "lib-changes.tsv", "lib-changes-summary.txt", ["lib"], 1
else
  data = {}
  vers.each do |v|
    rbs_fp = load_rbs(File.join(dir, "rbs", "#{v}.tsv"), false)
    vp = File.join(dir, "result", v, "entry-verdicts.tsv")
    data[v] = {real: load_real(File.join(dir, "real", v, "builtin.tsv")),
               rbs: ->(k, kind, name) { rbs_fp[rbs_key(k, kind, name)] },
               doc: load_doc(read_tsv(File.join(dir, "db-extract", "sigs-#{v}.tsv")).select { |r| r["lib"] == "_builtin" }),
               verdict: File.exist?(vp) ? load_verdict(read_tsv(vp)) : {}}
  end
  vers.each_cons(2) do |a, b|
    rows.concat(diff_pair(a, b, data[a], data[b], data[a][:real].keys & data[b][:real].keys))
  end
  rows.sort_by! { |r| [r[3], r[0], r[1], r[2]] }
  out, sum, head, off = "changes.tsv", "changes-summary.txt", [], 0
end

res = File.join(dir, "result")
FileUtils.mkdir_p(res)
File.open(File.join(res, out), "w") do |f|
  f.puts (head + %w[class kind name from to source real_before real_after rbs_before rbs_after doc_before doc_after doc_changed verdict_after flag]).join("\t")
  rows.each { |r| f.puts r.join("\t") }
end
File.open(File.join(res, sum), "w") do |f|
  f.puts "versions: #{vers.join(' ')}  rows=#{rows.size}", "", "[by flag]"
  rows.group_by(&:last).sort_by { |_, v| -v.size }.each { |k, v| f.puts "#{k}\t#{v.size}" }
  flags = rows.map(&:last).uniq.sort
  f.puts "", "[by version pair]", (["pair"] + flags + ["total"]).join("\t")
  vers.each_cons(2) do |a, b|
    rs = rows.select { |r| r[3 + off] == a && r[4 + off] == b }
    f.puts ["#{a}->#{b}", *flags.map { |fl| rs.count { |r| r.last == fl } }, rs.size].join("\t")
  end
end
puts File.read(File.join(res, sum))

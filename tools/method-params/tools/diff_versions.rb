# 段階 2: 隣り合う版の間で、実 Ruby・RBS・doc の引数指紋の変化を列挙する(組み込みのみ)
# usage: ruby tools/method-params/tools/diff_versions.rb <method-params dir> <ver...>
#   result/changes.tsv           変化のあったメソッドと flag
#   result/changes-summary.txt   flag ごと・版の組ごとの件数
require "fileutils"

dir, *vers = ARGV
abort "usage: diff_versions.rb <method-params dir> <ver...>" if vers.size < 2

def read_tsv(path)
  lines = File.readlines(path, chomp: true)
  head = lines.shift.split("\t", -1)
  lines.map { |l| head.zip(l.split("\t", -1)).to_h }
end

data = {}
vers.each do |v|
  real = {}
  File.foreach(File.join(dir, "real", v, "builtin.tsv"), chomp: true) do |l|
    f = l.split("\t", -1)
    next unless f[0] == "P"
    _, k, kind, _vis, name, arity, params, _owner, source = f
    real[[k, kind, name]] = {arity: arity.to_i, params: params, c: source == "C",
                             fp: "#{arity}|#{params}|#{source == 'C' ? 'C' : 'rb'}"}
  end
  rbs = Hash.new { |h, k| h[k] = [] }
  read_tsv(File.join(dir, "rbs", "#{v}.tsv")).each do |r|
    rbs[r["key"]] << "#{r['params']}|#{r['arity_min']}|#{r['arity_max']}|#{r['block']}"
  end
  rbs_fp = rbs.transform_values { |a| a.sort }
  doc = Hash.new { |h, k| h[k] = [] }
  read_tsv(File.join(dir, "db-extract", "sigs-#{v}.tsv")).each do |r|
    next unless r["lib"] == "_builtin"
    norm = r["status"] == "ok" ?
      [r["req"], r["opt"], r["rest"], r["kwreq"], r["kwopt"], r["kwrest"], r["block"], r["pos_names"]].join("/") :
      "raw:" + r["raw"].gsub(/\s+/, " ")
    r["names"].split(",").each do |n|
      kinds = case r["typemark"] when "#" then ["i"] when "." then ["s"] else %w[s i] end
      kinds.each { |kd| doc[[r["class"], kd, n]] << norm }
      doc[[r["class"], "i", "initialize"]] << norm if r["typemark"] == "." && n == "new"
    end
  end
  doc_fp = doc.transform_values { |a| a.uniq.sort }
  # 段階 1 のエントリ単位の判定(実 Ruby との突き合わせ)。複数エントリが同じキーに当たるときは
  # 一貫していない方を優先する
  verdict = {}
  vp = File.join(dir, "result", v, "entry-verdicts.tsv")
  read_tsv(vp).each do |r|
    kinds = case r["typemark"] when "#" then ["i"] when "." then ["s"] else %w[s i] end
    r["names"].split(",").each do |n|
      keys = kinds.map { |kd| [r["class"], kd, n] }
      keys << [r["class"], "i", "initialize"] if r["typemark"] == "." && n == "new"
      keys.each do |key|
        old = verdict[key]
        verdict[key] = r["real_verdict"] if old.nil? || %w[ok ok-split].include?(old)
      end
    end
  end if File.exist?(vp)
  data[v] = {real: real, rbs: rbs_fp, doc: doc_fp, verdict: verdict}
end

def rbs_of(d, k, kind, name)
  d[:rbs]["#{k}#{kind == 's' ? '.' : '#'}#{name}"]
end

rows = []
vers.each_cons(2) do |a, b|
  da, db = data[a], data[b]
  (da[:real].keys & db[:real].keys).each do |key|
    k, kind, name = key
    ra, rb = da[:real][key], db[:real][key]
    xa, xb = rbs_of(da, k, kind, name), rbs_of(db, k, kind, name)
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
end
rows.sort_by! { |r| [r[3], r[0], r[1], r[2]] }


res = File.join(dir, "result")
FileUtils.mkdir_p(res)
File.open(File.join(res, "changes.tsv"), "w") do |f|
  f.puts %w[class kind name from to source real_before real_after rbs_before rbs_after doc_before doc_after doc_changed verdict_after flag].join("\t")
  rows.each { |r| f.puts r.join("\t") }
end
File.open(File.join(res, "changes-summary.txt"), "w") do |f|
  f.puts "versions: #{vers.join(' ')}  rows=#{rows.size}", "", "[by flag]"
  rows.group_by(&:last).sort_by { |_, v| -v.size }.each { |k, v| f.puts "#{k}\t#{v.size}" }
  flags = rows.map(&:last).uniq.sort
  f.puts "", "[by version pair]", (["pair"] + flags + ["total"]).join("\t")
  vers.each_cons(2) do |a, b|
    rs = rows.select { |r| r[3] == a && r[4] == b }
    f.puts ["#{a}->#{b}", *flags.map { |fl| rs.count { |r| r.last == fl } }, rs.size].join("\t")
  end
end
puts File.read(File.join(res, "changes-summary.txt"))

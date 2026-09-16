# usage: ruby env_compare.rb <WORK> <ver> <entries-<ver>.tsv> [> env-diff-<ver>.tsv]
# measure_env.sh の結果($WORK/env/<ver>/{full,allruby}/real/<ver>/)を突き合わせ、ビルド環境に依存する差分を TSV で出す。
# 列: ver  lib  kind  class  typemark  name  info  libs(その差分が観測されたライブラリ・最大 3 つ)
#   kind: class-only-in-full / class-only-in-allruby / method-only-in-full / method-only-in-allruby / probe-differs / require
#   info: 可視性と DB 記載の有無(method-only-in-full)、プローブ結果の対(probe-differs)、require の成否(require)
# bundled/default gem の版ずれ由来(Gem::・Bundler・RDoc・ERB・Reline・IRB・Psych・Prism・JSON のクラスと rubygems/bundler/rdoc 配下のライブラリ)は除く。
# 2 つのビルドの teeny が違うときは、その間に追加されたメソッドも混ざるので ruby-v.txt で確認する。
work, v, ent_f = ARGV
full = "#{work}/env/#{v}/full/real/#{v}"; allr = "#{work}/env/#{v}/allruby/real/#{v}"
NOISE = /\A(Gem|Bundler|RDoc|RubyGems|Reline|IRB|ERB|Psych|Prism|JSON)(::|\z)/
ent = Hash.new { |h, k| h[k] = [] }
File.foreach(ent_f) { |l| lib, klass, t, name, = l.chomp.split("\t"); ent[[klass, name]] << [lib, t] }
doc = lambda { |klass, kind, name|
  hit = ent[[klass, name]].select { |lib, t| kind == "i" ? (t == "#" || t == ".#") : (t == "." || t == ".#") }
  hit.empty? ? "UNDOC" : "doc(#{hit.map(&:first).uniq.join(',')})"
}
load = lambda { |f|
  a_ = {}; m_ = {}; r_ = {}; x = nil
  File.foreach(f) do |l|
    r = l.chomp.split("\t")
    case r[0]
    when "A" then a_[r[1]] = r[2..]
    when "M" then m_[[r[1], r[2], r[4]]] = r[3]
    when "R" then r_[[r[1], r[2], r[3]]] = r[4]
    when "X" then x = r[3]
    end
  end
  [a_, m_, r_, x]
}
rows = Hash.new { |h, k| h[k] = [] }
add = lambda { |lib, kind, c, t, n, info| rows[[kind, c, t, n, info]] << lib }
report = lambda { |lib, ga, gm, gr, aa, am, ar|
  (ga.keys - aa.keys).sort.each { |k| next if k =~ NOISE; add.(lib, "class-only-in-full", k, "-", "-", ent.keys.any? { |c, _| c == k } ? "doc" : "UNDOC") }
  (aa.keys - ga.keys).sort.each { |k| next if k =~ NOISE; add.(lib, "class-only-in-allruby", k, "-", "-", "-") }
  (gm.keys - am.keys).sort.each { |c, kind, n| next if c =~ NOISE; add.(lib, "method-only-in-full", c, kind == "s" ? "." : "#", n, "#{gm[[c, kind, n]]} #{doc.(c, kind, n)}") }
  (am.keys - gm.keys).sort.each { |c, kind, n| next if c =~ NOISE; add.(lib, "method-only-in-allruby", c, kind == "s" ? "." : "#", n, am[[c, kind, n]]) }
  gr.each { |k, verdict| av = ar[k]; next if av.nil? || av == verdict; add.(lib, "probe-differs", k[0], k[1], k[2], "full=#{verdict} allruby=#{av}") }
}
ga, gm, gr, = load.("#{full}/builtin.tsv"); aa, am, ar, = load.("#{allr}/builtin.tsv")
report.("_builtin", ga, gm, gr, aa, am, ar)
Dir.glob("#{full}/libs/*.tsv").sort.each do |gf|
  id = File.basename(gf, ".tsv"); af = "#{allr}/libs/#{id}.tsv"
  next unless File.exist?(af)
  lib = File.read("#{work}/probe-in/#{v}/#{id}.name").strip
  next if lib =~ %r{\A(rubygems|bundler|rdoc)(/|\z)}   # 同梱 gem の版ずれと読み込み順の差しか出ないので除く
  ga, gm, gr, gx = load.(gf); aa, am, ar, ax = load.(af)
  if gx || ax
    add.(lib, "require", "-", "-", "-", "full=#{gx ? 'FAIL(' + gx[0, 60] + ')' : 'ok'} allruby=#{ax ? 'FAIL(' + ax[0, 60] + ')' : 'ok'}") if gx.nil? != ax.nil?
    next
  end
  report.(lib, ga, gm, gr, aa, am, ar)
end
puts %w[ver lib kind class typemark name info libs].join("\t")
rows.sort.each do |(kind, c, t, n, info), libs|
  u = libs.uniq
  puts [v, u.first, kind, c, t, n, info, u.first(3).join(",") + (u.size > 3 ? ",+#{u.size - 3}" : "")].join("\t")
end

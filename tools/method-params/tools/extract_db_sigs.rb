# doctree DB の全メソッドエントリ(typemark # . .#)のシグネチャ行を解析して TSV で出力する
# usage: bundle exec ruby tools/method-params/tools/extract_db_sigs.rb <dbpath> <outdir> <ver>   (doctree ディレクトリで実行)
#   <outdir>/db-extract/sigs-<ver>.tsv    シグネチャ行ごとの正規化した引数
#   <outdir>/db-extract/params-<ver>.tsv  エントリごとのシグネチャ側/本文側の引数名の集合
require "bitclust"
require "fileutils"

SIG_RE = /\A### (?:module_function def |def )/
PARAM_RE = /\A- \*\*(?:param|arg)\*\*\s+`([^`]+)`/

# 深さ 0 のカンマで分割する(括弧・引用符を考慮)
def split_params(str)
  items = []
  cur = +""
  depth = 0
  quote = nil
  i = 0
  while i < str.size
    c = str[i]
    if quote
      cur << c
      if c == "\\" && i + 1 < str.size
        i += 1
        cur << str[i]
      elsif c == quote
        quote = nil
      end
    else
      case c
      when '"', "'" then quote = c; cur << c
      when "(", "[", "{" then depth += 1; cur << c
      when ")", "]", "}" then depth -= 1; cur << c
      when ","
        if cur.end_with?("$") # グローバル変数 $, は区切りではなくトークン
          cur << c
        elsif depth <= 0
          items << cur.strip
          cur = +""
        else
          cur << c
        end
      else cur << c
      end
    end
    i += 1
  end
  items << cur.strip unless cur.strip.empty? && items.empty?
  items
end

IDENT = /[A-Za-z_][A-Za-z0-9_]*[?!]?/

# 1 つのシグネチャの引数文字列を分類する
def classify(params_str)
  r = {req: 0, opt: 0, rest: 0, kwreq: [], kwopt: [], kwrest: 0, block: 0,
       pos_names: [], names: [], unusual: nil}
  return r if params_str.nil? || params_str.empty?
  split_params(params_str).each do |item|
    case item
    when /\A(?:nil|true|false|-?\d+(?:\.\d+)?|"[^"]*"|'[^']*')\z/
      # リテラルは必須の位置引数として数え、名前の比較には使わない(pos_names の "=" 始まり)
      r[:req] += 1; r[:pos_names] << "=#{item}"
    when /\A(#{IDENT})\z/
      r[:req] += 1; r[:pos_names] << $1; r[:names] << $1
    when /\A(#{IDENT})\s*=\s*\S/
      r[:opt] += 1; r[:pos_names] << $1; r[:names] << $1
    when /\A\*(#{IDENT})?\z/, /\A\*(#{IDENT})\s*=\s*\S/, /\A(#{IDENT})\.\.\.\z/
      # *name = 既定値 と name... は可変長引数の表記として扱う
      r[:rest] = 1; r[:pos_names] << "*#{$1}"; r[:names] << $1 if $1
    when /\A\[(.*)\]\z/
      # [a, *b] のように配列の要素を引数として並べた表記は要素の名前を拾う
      r[:req] += 1; r[:pos_names] << item; r[:names].concat(classify($1)[:names])
    when /\A(#{IDENT}):\z/
      r[:kwreq] << $1; r[:names] << $1
    when /\A(#{IDENT}):\s*\S/
      r[:kwopt] << $1; r[:names] << $1
    when /\A\*\*(#{IDENT})?\z/
      r[:kwrest] = 1; r[:names] << $1 if $1
    when /\A&(#{IDENT})?\z/
      r[:block] = 1; r[:names] << $1 if $1
    when "..."
      r[:rest] = 1; r[:kwrest] = 1; r[:block] = 1
    else
      r[:unusual] ||= item
    end
  end
  r
end

db_path, outdir, ver = ARGV
abort "usage: extract_db_sigs.rb <dbpath> <outdir> <ver>" unless ver
dir = File.join(outdir, "db-extract")
FileUtils.mkdir_p(dir)
db = BitClust::MethodDatabase.new(db_path)

line_index = {} # file => {行文字列 => [行番号...]}
find_line = lambda do |file, raw|
  idx = (line_index[file] ||= begin
    h = Hash.new { |hh, k| hh[k] = [] }
    File.foreach(file).with_index(1) { |l, n| h[l.chomp.rstrip] << n } if File.exist?(file)
    h
  end)
  idx[raw.rstrip].first
end

entries = sig_count = unusual = perr = 0
sigs_f = File.open(File.join(dir, "sigs-#{ver}.tsv"), "w")
params_f = File.open(File.join(dir, "params-#{ver}.tsv"), "w")
sigs_f.puts %w[lib class typemark names loc idx raw name req opt rest kwreq kwopt kwrest block pos_names status].join("\t")
params_f.puts %w[lib class typemark names loc sig_names body_names n_param_lines].join("\t")

db.methods.sort_by { |m| [m.library.name, m.klass.name, m.typemark, m.names.join(",")] }.each do |m|
  next unless %w[# . .#].include?(m.typemark)
  entries += 1
  lib = m.library.name
  klass = m.klass.name
  names = m.names.join(",")
  src = m.source.to_s
  file = m.source_location.file.to_s
  # fenced code 内は除いて、シグネチャ行と param 行を拾う
  fence = false
  sig_lines = []
  body_names = []
  src.each_line do |l|
    l = l.chomp
    fence = !fence if l =~ /\A\s*```/
    next if fence || l =~ /\A\s*```/
    sig_lines << l if SIG_RE =~ l
    body_names << $1 if PARAM_RE =~ l
  end
  first_line = sig_lines.first && find_line.call(file, sig_lines.first)
  loc = file.empty? ? "-" : (first_line ? "#{file}:#{first_line}" : file)
  sig_names = []
  sig_lines.each_with_index do |raw, i|
    sig_count += 1
    status = "ok"
    row = nil
    begin
      sig = BitClust::MethodSignature.parse(raw.sub(SIG_RE, "--- "))
      c = classify(sig.params)
      c[:block] = 1 if sig.block
      sig_names.concat(c[:names])
      if c[:unusual]
        status = "unusual:#{c[:unusual]}"
        unusual += 1
      end
      row = [sig.name, c[:req], c[:opt], c[:rest], c[:kwreq].join(","), c[:kwopt].join(","),
             c[:kwrest], c[:block], c[:pos_names].join(",")]
    rescue BitClust::ParseError
      status = "parse-error"
      perr += 1
      row = ["-", 0, 0, 0, "", "", 0, 0, ""]
    end
    sigs_f.puts [lib, klass, m.typemark, names, loc, i, raw.strip, *row, status].join("\t")
  end
  norm = body_names.map { |n| n.sub(/\A(?:\*\*|\*|&)/, "").sub(/:\z/, "") }
  params_f.puts [lib, klass, m.typemark, names, loc, sig_names.uniq.sort.join(","),
                 norm.uniq.sort.join(","), body_names.size].join("\t")
end
sigs_f.close
params_f.close
warn "#{ver}: entries=#{entries} sig_lines=#{sig_count} unusual=#{unusual} parse-error=#{perr}"

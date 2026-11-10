require "bitclust/methodsignature"

# シグネチャ行の引数名と `- **param**` 行の名前を突き合わせる
module CheckParams
  module_function

  SIG_RE = /\A### (?:module_function def |def )/
  PARAM_RE = /\A- \*\*(?:param|arg)\*\*\s+`([^`]+)`/
  FENCE_RE = /\A\s*```/
  TARGET_TYPEMARKS = ["#", ".", ".#"].freeze
  IDENT = /[A-Za-z_][A-Za-z0-9_]*[?!]?/
  LITERAL_RE = /\A(?:nil|true|false|-?\d+(?:\.\d+)?|"[^"]*"|'[^']*')\z/

  Extracted = Struct.new(:sig_lines, :sig_names, :param_names, :param_line_count, :errors, keyword_init: true)

  Result = Struct.new(:status, :extracted, :only_in_signature, :only_in_params, keyword_init: true) do
    # シグネチャに引数があるのに param 行が無い
    def args_without_param_lines?
      status == :no_param_lines && !extracted.sig_names.empty?
    end
  end

  # 深さ 0 のカンマで分割する(括弧・引用符を考慮し、$, は区切りにしない)
  def split_params(str)
    items = []
    cur = +""
    depth = 0
    quote = nil
    i = 0
    while i < str.size
      c = str[i]
      cur << c
      if quote
        if c == "\\" && i + 1 < str.size
          i += 1
          cur << str[i]
        elsif c == quote
          quote = nil
        end
      else
        case c
        when '"', "'" then quote = c
        when "(", "[", "{" then depth += 1
        when ")", "]", "}" then depth -= 1
        when ","
          if depth <= 0 && !cur.end_with?("$,")
            items << cur.chop.strip
            cur = +""
          end
        end
      end
      i += 1
    end
    items << cur.strip unless cur.strip.empty? && items.empty?
    items
  end

  # 1 つのシグネチャの引数文字列から引数名を順に取り出す
  def signature_names(params_str)
    return [] if params_str.nil?
    names = split_params(params_str).flat_map do |item|
      case item
      when LITERAL_RE, "..." then []
      when /\A(#{IDENT})(?:\s*=\s*\S.*)?\z/ then [$1]
      when /\A\*(#{IDENT})?\z/, /\A\*(#{IDENT})\s*=\s*\S/, /\A(#{IDENT})\.\.\.\z/ then [$1].compact
      when /\A\[(.*)\]\z/ then signature_names($1)
      when /\A(#{IDENT}):(?:\s*\S.*)?\z/ then [$1]
      when /\A\*\*(#{IDENT})?\z/, /\A&(#{IDENT})?\z/ then [$1].compact
      else []
      end
    end
    (names - ["self"]).uniq
  end

  # param 行の名前から * ** & と末尾の : を除く。比較に使わない名前は nil
  def normalize_param_name(name)
    n = name.strip.sub(/\A(?:\*\*|\*|&)/, "").sub(/:\z/, "")
    return nil if n.empty? || n == "self" || n == "..."
    n
  end

  # エントリのソースからシグネチャ行と param 行を集める(フェンスの中は除く)
  # `i, j, k` のように 1 つの param 行に並べた名前はカンマで分ける
  def extract(source)
    sig_lines = []
    raw_params = []
    fence = false
    source.to_s.each_line(chomp: true) do |line|
      if FENCE_RE.match?(line)
        fence = !fence
        next
      end
      next if fence
      sig_lines << line if SIG_RE.match?(line)
      raw_params << $1 if PARAM_RE =~ line
    end
    sig_names = []
    errors = []
    sig_lines.each do |line|
      sig = BitClust::MethodSignature.parse(line.sub(SIG_RE, "--- "))
      sig_names.concat(signature_names(sig.params))
    rescue BitClust::ParseError => e
      errors << e
    end
    Extracted.new(sig_lines: sig_lines, sig_names: sig_names.uniq,
                  param_names: raw_params.flat_map { |s| s.split(",") }.filter_map { |n| normalize_param_name(n) }.uniq,
                  param_line_count: raw_params.size, errors: errors)
  end

  # シグネチャ側と param 行側の名前の集合を比べる
  def check(source)
    ex = extract(source)
    return Result.new(status: :no_param_lines, extracted: ex) if ex.param_line_count.zero?
    only_sig = (ex.sig_names - ex.param_names).sort
    only_param = (ex.param_names - ex.sig_names).sort
    status = only_sig.empty? && only_param.empty? ? :ok : :mismatch
    Result.new(status: status, extracted: ex, only_in_signature: only_sig, only_in_params: only_param)
  end

  # file の中で raw_line と同じ行(行末の空白は無視)の行番号を返す
  def locate(file, raw_line, cache = {})
    lines = cache.fetch(file) do
      cache[file] = File.exist?(file) ? File.readlines(file, chomp: true, encoding: "UTF-8").map(&:rstrip) : []
    end
    idx = lines.index(raw_line.rstrip)
    idx && idx + 1
  end

  # db の全メソッドエントリを検査して不一致を out に出し、不一致の件数を返す
  def run(db, out: $stdout, root: Dir.pwd)
    entries = db.methods.select { |m| TARGET_TYPEMARKS.include?(m.typemark) }
                .sort_by { |m| [m.library.name, m.klass.name, m.typemark, m.names.join(",")] }
    cache = {}
    with_param = mismatched = args_no_param = 0
    entries.each do |m|
      result = check(m.source)
      if result.status == :no_param_lines
        args_no_param += 1 if result.args_without_param_lines?
        next
      end
      with_param += 1
      next if result.status == :ok
      mismatched += 1
      out.puts "#{location_prefix(m, result, root, cache)}#{m.klass.name}#{m.typemark}#{m.name}: #{mismatch_message(result)}"
    end
    out.puts "entries=#{entries.size} with_param_lines=#{with_param} mismatched=#{mismatched} args_but_no_param_lines=#{args_no_param}"
    mismatched
  end

  # 「ファイル:行: 」の部分。わからない部分は省く
  def location_prefix(entry, result, root, cache)
    file = entry.source_location&.file&.to_s
    return "" if file.nil? || file.empty?
    first = result.extracted.sig_lines.first
    line = first && locate(File.expand_path(file, root), first, cache)
    line ? "#{file}:#{line}: " : "#{file}: "
  end

  # 片側だけにある引数名を並べた文
  def mismatch_message(result)
    parts = []
    parts << "シグネチャだけにある引数: #{result.only_in_signature.join(", ")}" unless result.only_in_signature.empty?
    parts << "param 行だけにある引数: #{result.only_in_params.join(", ")}" unless result.only_in_params.empty?
    parts.join(" / ")
  end
end

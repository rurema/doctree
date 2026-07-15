#!/usr/bin/env ruby
# frozen_string_literal: true
#
# fold_version_branches.rb — バージョン分岐畳み込みツール
#
# ■ 目的
#   manual/ 配下(または指定ディレクトリ配下)の *.md を対象に、
#   bitclust/lib/bitclust/preprocessor.rb と同じ文法で #@since/#@until/#@if/
#   #@else/#@end/#@samplecode をブロック木としてパースし、「サポート最小
#   バージョン」を境に真偽が確定するバージョン分岐(#@since/#@until/#@if)を
#   一括で部分評価してたたみ込む。#@if が部分的にしか確定しない場合は
#   #@since/#@until へ書き換える(可能な場合)。
#
# ■ 使い方
#   ruby tools/fold_version_branches.rb --min-version VER DIR
#   ruby tools/fold_version_branches.rb --min-version 3.0 manual
#   ruby tools/fold_version_branches.rb --min-version 3.0 --dry-run manual
#
#   --min-version VER  サポートする最小バージョン(必須。例: 3.0)
#   --dry-run           ファイルを書き換えず、変更されるファイル一覧と
#                        統計だけを表示する
#   DIR                 走査対象ディレクトリ(*.md を再帰的に走査)
#
# ■ 畳み込み規則(統一規則)
#   #@since VER'  は  version >= "VER'"
#   #@until VER'  は  version <  "VER'"
#   に脱糖し、#@if の各原子式 `version OP "リテラル L"` も同じ形に正規化した
#   うえで、以下の規則だけを使って判定する(VER はコマンドラインで指定した
#   サポート最小バージョン):
#
#     L <=> VER (Ruby の文字列比較 String#<=>) の結果で分岐:
#       L < VER  … >=  >  は常に真 / <  <=  ==  は常に偽 / != は常に真
#       L == VER … >=     は常に真 / <          は常に偽 / それ以外(==,!=,>,<=)は不定
#       L > VER  … すべて不定
#
#   「不定」の原子式を含む #@if は、and/or の他の原子式の真偽次第で
#   全体が真/偽に確定することがある(例: `a and b` で a が常に偽なら全体が
#   常に偽)。すべての原子式が確定して初めて全体を畳み込み、一部だけ確定
#   した場合は残った原子式だけの #@if(残り1個なら #@since/#@until)に書き
#   換える。
#
#   ※ 規則の妥当性条件: 「VER 以上のすべてのバージョン(将来 doctree が
#      対応する未知の版も含む)で真偽が変わらないこと」。上記の3ケースは
#      いずれもこれを満たす(L<VER および L==VER のケースは、対象が文字列
#      順序で VER 以上である限り比較結果が変わらない。L>VER は将来版との
#      大小関係が定まらないため不定のまま残す)。
#
# ■ 注意
#   - ここでの比較は Ruby の文字列比較であり、数値比較ではない
#     (bitclust の Preprocessor#eval_expr も `params['version']` という
#     文字列同士を `>=` 等で比較しているだけなので、これに合わせている。
#     例えば将来 "3.10" のような版が現れると "3.10" < "3.9" になる)。
#   - 畳み込むのは「VER 以上の任意の版で結果が変わらない」と機械的に言え
#     る規則だけである。曖昧な場合は #@if 等をそのまま残す(不定)。
#   - 行の削除は行単位のみで、前後の空行の詰め合わせは行わない(既知の
#     手作業差分として、ブロックに隣接する空行の整理は別途人手で行う)。
#   - パースエラーが1件でもあれば、どのファイルへも書き込む前に異常終了
#     する(部分適用を避けるため)。
#   - 適用後は必ず verify_preprocessor_output.rb で、変換前後の
#     BitClust::Preprocessor 出力がサポート対象の全バージョンでバイト単位
#     一致することを確認してから commit すること。生成される HTML の内容
#     は変わらないはずである。
#
# ■ 経緯
#   PR https://github.com/rurema/doctree/pull/3097 で「#@until 3.0」
#   ブロックの削除などを手作業寄りに行った際の手順を一般化したもの。
#   同 PR ではリテラルが正確に "3.0" の原子式のみを扱う Pass A と、
#   リテラルが "3.0" 未満(当時は "1." または "2." で始まるものに限定)の
#   原子式のみを扱う Pass B の2パス構成を使っていたが、本スクリプトでは
#   任意の --min-version に対して1パスで同じ判定を行う統一規則に置き
#   換えている(判定結果は同じになる。詳細はツール整備時の報告を参照)。

class ParseError < StandardError; end

Atom = Struct.new(:op, :literal)
TextNode = Struct.new(:line)

class CondNode
  attr_accessor :kind, :directive_line, :lineno, :atoms, :connective,
                :then_body, :else_line, :else_lineno, :else_body,
                :end_line, :end_lineno

  def initialize(kind:, directive_line:, lineno:)
    @kind = kind
    @directive_line = directive_line
    @lineno = lineno
    @then_body = []
    @else_body = nil
  end
end

class SamplecodeNode
  attr_accessor :begin_line, :lineno, :body, :end_line, :end_lineno

  def initialize(begin_line:, lineno:)
    @begin_line = begin_line
    @lineno = lineno
    @body = []
  end
end

# ---------------------------------------------------------------------------
# パース
# ---------------------------------------------------------------------------

def extract_bare_version_literal(raw, path, lineno)
  case raw
  when /\A"([\d.]+)"\z/ then $1
  when /\A'([\d.]+)'\z/ then $1
  when /\A[\d.]+\z/ then raw
  else
    raise ParseError, "#{path}:#{lineno}: cannot parse version literal: #{raw.inspect}"
  end
end

def unquote_atom_token(tok, path, lineno)
  case tok
  when /\A"(.*)"\z/m then $1
  when /\A'(.*)'\z/m then $1
  when /\A\d+\z/ then tok
  else
    raise ParseError, "#{path}:#{lineno}: cannot unquote literal token: #{tok.inspect}"
  end
end

ATOM_RE = /\A(?<lhs>"[^"]*"|'[^']*'|version|\d+)\s*(?<op>>=|<=|==|!=|<|>)\s*(?<rhs>"[^"]*"|'[^']*'|version|\d+)\z/
MIRROR_OP = { '<=' => '>=', '<' => '>', '>=' => '<=', '>' => '<', '==' => '==', '!=' => '!=' }.freeze

def parse_atom(text, path, lineno)
  t = text.strip
  m = ATOM_RE.match(t)
  raise ParseError, "#{path}:#{lineno}: cannot parse atom: #{t.inspect}" unless m

  lhs = m[:lhs]
  op = m[:op]
  rhs = m[:rhs]
  if lhs == 'version' && rhs != 'version'
    Atom.new(op, unquote_atom_token(rhs, path, lineno))
  elsif rhs == 'version' && lhs != 'version'
    Atom.new(MIRROR_OP.fetch(op), unquote_atom_token(lhs, path, lineno))
  else
    raise ParseError, "#{path}:#{lineno}: atom must compare version against a literal: #{t.inspect}"
  end
end

def strip_outer_parens(text)
  return text unless text.start_with?('(') && text.end_with?(')')

  depth = 0
  text.each_char.with_index do |ch, i|
    depth += 1 if ch == '('
    depth -= 1 if ch == ')'
    if depth.zero?
      return i == text.length - 1 ? text[1..-2].strip : text
    end
  end
  text
end

def parse_if_expr(node, line, path, lineno)
  text = line.sub(/\A\#@if/, '').strip
  text = strip_outer_parens(text)
  parts = text.split(/\s+(and|or)\s+/)
  atom_texts = parts.values_at(*0.step(parts.size - 1, 2).to_a)
  conjs = parts.values_at(*1.step(parts.size - 1, 2).to_a).compact
  if conjs.uniq.size > 1
    raise ParseError, "#{path}:#{lineno}: mixed and/or in a single \#@if not supported: #{text.inspect}"
  end

  node.connective = conjs.first
  node.atoms = atom_texts.map { |t| parse_atom(t, path, lineno) }
end

def current_target(stack)
  frame = stack.last
  case frame[:type]
  when :root
    frame[:body]
  when :cond
    frame[:in_else] ? frame[:node].else_body : frame[:node].then_body
  when :samplecode
    frame[:node].body
  end
end

def parse_file(path)
  lines = File.readlines(path)
  root_body = []
  stack = [{ type: :root, body: root_body }]

  lines.each_with_index do |line, idx|
    lineno = idx + 1
    case line
    when /\A\#@since\b/
      node = CondNode.new(kind: :since, directive_line: line, lineno: lineno)
      lit = extract_bare_version_literal(line.sub(/\A\#@\w+/, '').strip, path, lineno)
      node.atoms = [Atom.new('>=', lit)]
      node.connective = nil
      current_target(stack) << node
      stack.push({ type: :cond, node: node, in_else: false })
    when /\A\#@until\b/
      node = CondNode.new(kind: :until, directive_line: line, lineno: lineno)
      lit = extract_bare_version_literal(line.sub(/\A\#@\w+/, '').strip, path, lineno)
      node.atoms = [Atom.new('<', lit)]
      node.connective = nil
      current_target(stack) << node
      stack.push({ type: :cond, node: node, in_else: false })
    when /\A\#@if\b/
      node = CondNode.new(kind: :if, directive_line: line, lineno: lineno)
      parse_if_expr(node, line, path, lineno)
      current_target(stack) << node
      stack.push({ type: :cond, node: node, in_else: false })
    when /\A\#@samplecode\b/
      node = SamplecodeNode.new(begin_line: line, lineno: lineno)
      current_target(stack) << node
      stack.push({ type: :samplecode, node: node })
    when /\A\#@else\s*\z/
      frame = stack.last
      if frame[:type] != :cond
        raise ParseError, "#{path}:#{lineno}: \#@else with no matching \#@if/\#@since/\#@until"
      end
      if frame[:in_else]
        raise ParseError, "#{path}:#{lineno}: duplicate \#@else for the same block (unsupported)"
      end

      frame[:in_else] = true
      frame[:node].else_line = line
      frame[:node].else_lineno = lineno
      frame[:node].else_body = []
    when /\A\#@end\s*\z/
      frame = stack.pop
      if frame.nil? || frame[:type] == :root
        raise ParseError, "#{path}:#{lineno}: \#@end with no matching open block"
      end

      frame[:node].end_line = line
      frame[:node].end_lineno = lineno
    else
      if line.start_with?('#@') &&
         !(line =~ /\A\#@\#/ || line =~ /\A\#@todo\b/i || line =~ /\A\#@include\s*\(/)
        raise ParseError, "#{path}:#{lineno}: unknown preprocessor directive: #{line.chomp.inspect}"
      end
      current_target(stack) << TextNode.new(line)
    end
  end

  if stack.size != 1
    open_frame = stack[1]
    node = open_frame[:node]
    raise ParseError, "#{path}:#{node.lineno}: unterminated block (opened here, file ended before \#@end)"
  end

  root_body
end

# ---------------------------------------------------------------------------
# 評価
# ---------------------------------------------------------------------------

# atom (op, literal) を、サポート最小バージョン min_version との文字列比較
# だけで判定する統一規則。:true / :false / :undetermined を返す。
def evaluate_atom(op, literal, min_version)
  case literal <=> min_version
  when -1 # literal < min_version (文字列比較で必ず未対応の過去バージョン)
    case op
    when '>=', '>' then :true
    when '<', '<=', '==' then :false
    when '!=' then :true
    else raise ParseError, "unknown operator: #{op.inspect}"
    end
  when 0 # literal == min_version (境界そのもの)
    case op
    when '>=' then :true
    when '<' then :false
    else :undetermined # ==, !=, >, <= はサポート最小版の扱い次第で変わるため不定
    end
  else # literal > min_version (将来バージョンとの大小関係は不定)
    :undetermined
  end
end

# 戻り値: [:true, nil] | [:false, nil] | [:untouched, nil] | [:partial, residual_atoms]
def classify_cond(node, min_version)
  results = node.atoms.map { |a| evaluate_atom(a.op, a.literal, min_version) }

  if node.connective.nil?
    case results.first
    when :true then [:true, nil]
    when :false then [:false, nil]
    else [:untouched, nil]
    end
  elsif node.connective == 'and'
    if results.include?(:false)
      [:false, nil]
    elsif results.all? { |r| r == :true }
      [:true, nil]
    elsif results.include?(:true)
      residual = node.atoms.each_with_index.reject { |_a, i| results[i] == :true }.map(&:first)
      [:partial, residual]
    else
      [:untouched, nil]
    end
  elsif node.connective == 'or'
    if results.none? { |r| r == :undetermined }
      results.include?(:true) ? [:true, nil] : [:false, nil]
    else
      [:untouched, nil]
    end
  else
    raise ParseError, "unknown connective: #{node.connective.inspect}"
  end
end

def build_partial_line(node, residual, notes)
  eol = node.directive_line.end_with?("\n") ? "\n" : ''
  if residual.size == 1 && residual[0].op == '<'
    "\#@until #{residual[0].literal}#{eol}"
  elsif residual.size == 1 && residual[0].op == '>='
    "\#@since #{residual[0].literal}#{eol}"
  else
    expr = residual.map { |a| "version #{a.op} \"#{a.literal}\"" }.join(' and ')
    notes << :unusual_residual_form
    "\#@if (#{expr})#{eol}"
  end
end

# ---------------------------------------------------------------------------
# 出力構築
# ---------------------------------------------------------------------------

def render(nodes, min_version, changes, file, stats)
  lines = []
  nodes.each do |node|
    case node
    when TextNode
      lines << node.line
    when SamplecodeNode
      lines << node.begin_line
      lines.concat render(node.body, min_version, changes, file, stats)
      lines << node.end_line
    when CondNode
      verdict, residual = classify_cond(node, min_version)
      case verdict
      when :true
        stats[node.else_body ? :true_with_else : :true_no_else] += 1
        lines.concat render(node.then_body, min_version, changes, file, stats)
      when :false
        stats[node.else_body ? :false_with_else : :false_no_else] += 1
        lines.concat render(node.else_body, min_version, changes, file, stats) if node.else_body
      when :untouched
        lines << node.directive_line
        lines.concat render(node.then_body, min_version, changes, file, stats)
        if node.else_line
          lines << node.else_line
          lines.concat render(node.else_body, min_version, changes, file, stats)
        end
        lines << node.end_line
      when :partial
        notes = []
        new_line = build_partial_line(node, residual, notes)
        changes << { file: file, lineno: node.lineno, old: node.directive_line, new: new_line,
                     unusual: !notes.empty? }
        lines << new_line
        lines.concat render(node.then_body, min_version, changes, file, stats)
        if node.else_line
          lines << node.else_line
          lines.concat render(node.else_body, min_version, changes, file, stats)
        end
        lines << node.end_line
      end
    end
  end
  lines
end

# ---------------------------------------------------------------------------
# メイン
# ---------------------------------------------------------------------------

def parse_args(argv)
  min_version = nil
  dir = nil
  dry_run = false
  i = 0
  while i < argv.size
    case argv[i]
    when '--min-version'
      min_version = argv[i + 1]
      i += 2
    when /\A--min-version=(.*)\z/
      min_version = $1
      i += 1
    when '--dry-run'
      dry_run = true
      i += 1
    when '--help', '-h'
      puts "usage: fold_version_branches.rb --min-version VER [--dry-run] DIR"
      exit 0
    else
      raise "usage: fold_version_branches.rb --min-version VER [--dry-run] DIR (unexpected arg: #{argv[i].inspect})" if dir

      dir = argv[i]
      i += 1
    end
  end
  raise "usage: fold_version_branches.rb --min-version VER [--dry-run] DIR" unless min_version && dir
  unless min_version =~ /\A[\d.]+\z/
    raise "invalid --min-version: #{min_version.inspect} (must look like a version literal, e.g. 3.0)"
  end

  [min_version, dir, dry_run]
end

if $PROGRAM_NAME == __FILE__
  min_version, dir, dry_run = parse_args(ARGV)
  files = Dir.glob(File.join(dir, '**', '*.md')).sort

  new_contents = {}
  all_changes = []
  errors = []
  stats = Hash.new(0)

  files.each do |file|
    root_body = parse_file(file)
    changes = []
    new_lines = render(root_body, min_version, changes, file, stats)
    new_contents[file] = new_lines.join
    all_changes.concat(changes)
  rescue ParseError => e
    errors << e.message
  end

  if errors.any?
    warn "#{errors.size} parse error(s) — no file was written:"
    errors.each { |e| warn "  #{e}" }
    exit 1
  end

  changed_files = []
  new_contents.each do |file, content|
    orig = File.read(file)
    next if orig == content

    File.write(file, content) unless dry_run
    changed_files << file
  end

  puts "min-version=#{min_version} dir=#{dir}#{dry_run ? ' [dry-run: no file written]' : ''}"
  puts "scanned files: #{files.size}"
  puts "changed files: #{changed_files.size}"
  changed_files.each { |f| puts "  #{f}" }
  puts
  puts "folded blocks (evaluated at rendered positions; blocks nested inside a deleted branch are not counted separately):"
  puts "  always-true,  no \#@else (unwrap then)        : #{stats[:true_no_else]}"
  puts "  always-true,  with \#@else (keep then, drop else): #{stats[:true_with_else]}"
  puts "  always-false, no \#@else (delete block)       : #{stats[:false_no_else]}"
  puts "  always-false, with \#@else (keep else)        : #{stats[:false_with_else]}"
  puts
  puts "partial rewrites (\#@if simplified to \#@since/\#@until or reduced form):"
  if all_changes.empty?
    puts "  (none)"
  else
    all_changes.each do |c|
      marker = c[:unusual] ? ' [UNUSUAL RESIDUAL FORM]' : ''
      puts "  #{c[:file]}:#{c[:lineno]}: #{c[:old].chomp.inspect} -> #{c[:new].chomp.inspect}#{marker}"
    end
  end
end

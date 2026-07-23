#!/usr/bin/env ruby
# frozen_string_literal: true
#
# tools/parse_doctree.rb
#
# 使い方:
#   ruby tools/parse_doctree.rb [--dir /path/to/doctree/manual/api/_builtin] \
#     > doctree-entries.tsv
#
# --dir 省略時はこのスクリプトから見た標準レイアウト
#   (rurema/doctree/manual/api/_builtin) を使う。
#
# 標準ライブラリのみに依存(bitclust gem は require しない)。ただし
# メソッド名抽出や見出し判定の正規表現は
# bitclust/lib/bitclust/nameutils.rb・mdparser.rb・rrdparser.rb の実装を
# 意図的に写経している(該当箇所はコメントで参照元を明記)。乖離した場合は
# 抽出結果が実際の DB 生成結果とずれるので、bitclust 側の変更時はこの
# スクリプトも見直すこと。
#
# 目的:
#   doctree の組み込みクラスドキュメント(_builtin/*.md)から、メソッド/
#   定数/特殊変数の見出し(`### def ...` 等)と、それに紐付く明示的な
#   `{: since="X"}` / `{: until="X"}` 属性の一覧を抽出する。あわせて、
#   見出しを囲む bitclust プリプロセッサ条件(#@since/#@until/#@if)と
#   front matter のクラスレベル since/until も記録する。
#
#   これは「今そのバージョンで何が見えるか」を評価するツールではない
#   (#@if の真偽は評価しない)。存在するすべての見出しを、そこにかかって
#   いる生の条件つきで、漏れなく列挙するための構造抽出ツール。
#
# 出力(TSV, ヘッダ行なし, タブ区切り。1行 = 1シグネチャ行):
#   file        - 見出しが物理的に書かれているファイルのファイル名のみ
#                 (#@include で取り込まれる断片ファイルは、取り込み元では
#                 なく断片ファイル自身の名前になる。例: Fiber.current.md)
#   line        - `file` 内でのその見出し行の1始まりの行番号
#   class_name  - その時点で有効なクラス/モジュール名。ファイル中の
#                 `# class X < Y` / `# module X` / `# object X` /
#                 `# reopen X` / `# redefine X` を先頭から順に辿って
#                 更新する(1ファイルに複数エンティティがあり得る。例:
#                 SystemCallError.md は152個の `# class Errno::EXXX ...`
#                 を含む)。#@include 展開中は取り込み元の値を引き継ぐ。
#                 前方に一つもエンティティ見出しが無い場合のみ、ファイル名
#                 からのフォールバック(`Enumerator__Yielder` ->
#                 `Enumerator::Yielder`)を使う。
#   kind        - s(特異メソッド) / i(インスタンスメソッド) / c(定数) /
#                 v(特殊変数) / o(その他: module_function 、またはその
#                 見出しの種別を判別できなかった場合)
#   method_name - `[]=` `+` `any?` `$~` のような素の名前。引数・ブロック・
#                 戻り値は含めない。gvar は `$` を残す(DB 内部では先頭の
#                 `$` を1個外して格納するが、可読性のため本ツールでは
#                 表示形のまま残す。詳細は notes 参照)
#   since_attr  - 見出し直後(空行を挟まない)の `{: ...}` 属性行にある
#                 since= の値。属性行そのものが無ければ `-`、
#                 `since=""` (空文字の明示)なら `EMPTY`、それ以外は値
#                 そのもの(例 `1.9.1`)
#   until_attr  - 同上、until= について
#   pp_cond     - 見出しを囲む #@since/#@until/#@if の条件。無ければ `-`。
#                 複数入れ子なら外側から順に `,` 連結(例
#                 `since:3.4,until:4.0`)。#@if は `if:<式>` とし、
#                 その #@else 側は `since:X`<->`until:X` の入れ替え、
#                 `if:<式>` は `if_not:<式>` とする(#@if の式自体は
#                 評価しない。詳細は notes 参照)
#   class_since - この見出しを含む「トップレベルファイル」(#@include の
#                 展開元をたどった最上位のファイル)の front matter の
#                 since:。無ければ `-`
#   class_until - 同上、until: について

require 'optparse'

options = {
  dir: File.expand_path('../../../manual/api/_builtin', __dir__),
}

OptionParser.new do |opt|
  opt.banner = 'Usage: parse_doctree.rb [--dir DIR] > doctree-entries.tsv'
  opt.on('--dir DIR', 'path to doctree/manual/api/_builtin') { |v| options[:dir] = v }
end.parse!(ARGV)

DIR = options[:dir]

unless Dir.exist?(DIR)
  warn "directory not found: #{DIR}"
  exit 1
end

# ---------------------------------------------------------------------------
# 正規表現(bitclust/lib/bitclust/nameutils.rb:20-28, mdparser.rb:51,57,
# rrdparser.rb:274,333-334,530 を写経)
# ---------------------------------------------------------------------------

CONST_RE       = /[A-Z]\w*/
CONST_PATH_RE  = /#{CONST_RE}(?:::#{CONST_RE})*/
CLASS_PATH_RE  = /(?:#{CONST_PATH_RE}(?:::compatible)?|fatal|ARGF\.class|main)/
METHOD_NAME_RE = /\w+[?!=]?|===|==|=~|<=>|<=|>=|!=|!~|!@|!|\[\]=|\[\]|\*\*|>>|<<|\+@|\-@|[~+\-*\/%&|^<>`]/
TYPEMARK_RE    = /(?:\.|\#|\.\#|::|\$)/
GVAR_RE        = /\$(?:\w+|-.|\S)/

# 見出しの先頭に(実際には現れないが念のため)クラスパス+typemark が
# 付いているケースも許容してから名前本体を取る(rrdparser.rb:333
# SIGNATURE 相当)
NAME_AT_START_RE = /\A(?:#{CLASS_PATH_RE}#{TYPEMARK_RE})?(#{METHOD_NAME_RE})/o
GVAR_AT_START_RE  = /\A(#{GVAR_RE})/o

# mdparser.rb:51 SIG_RE / rrdparser.rb:530 MD_METHOD_SIG_PREFIX_RE
SIG_RE  = /\A### (module_function def |def |const |gvar )/
# mdparser.rb:53,55 H1_RE / H2_RE
H1_RE   = /\A#[^#]/
H2_RE   = /\A##[^#]/
FENCE_START_RE = /\A(`{3,})/
# rrdparser.rb:274 METHOD_ATTRIBUTE_LINE_RE
ATTR_RE = /\A\{:(.*)\}[ \t]*\z/

Entry = Struct.new(
  :file, :line, :class_name, :kind, :method_name,
  :since_attr, :until_attr, :pp_cond, :class_since, :class_until
)

# 1ファイル内(#@include 展開先も含む)で共有される可変状態。
# type: nil / :instance_method / :singleton_method / :module_function /
#       :constant / :special_variable  (mdparser.rb read_level2_blocks 相当)
Context = Struct.new(:class_name, :type, :fence_len)

Warning_ = Struct.new(:file, :line, :message)

$entries = []
$warnings = []
$file_cache = {}

def warn_entry(file, line, message)
  $warnings << Warning_.new(file, line, message)
end

def read_lines(path)
  File.read(path, encoding: 'UTF-8').split("\n", -1)
rescue Errno::ENOENT
  nil
end

def load_fragment_lines(name)
  $file_cache[name] ||= begin
    path = File.join(DIR, "#{name}.md")
    read_lines(path)
  end
end

# front matter (--- ... ---) の since:/until: スカラーだけを拾う。
# 他のキー(library/include/alias 等)やリスト項目、front matter 内に
# 混ざる #@until/#@end (例: Integer.md の alias: リストの版限定)は無視する。
def read_class_since_until(lines)
  return ['-', '-'] unless lines[0]&.strip == '---'

  since_v = nil
  until_v = nil
  i = 1
  while i < lines.length
    line = lines[i]
    break if line.strip == '---'

    if (m = /\A(since|until):\s*"?([^"\s][^"]*)?"?\s*\z/.match(line))
      key = m[1]
      val = (m[2] || '').strip
      since_v = val if key == 'since'
      until_v = val if key == 'until'
    end
    i += 1
  end
  [since_v || '-', until_v || '-']
end

def invert_label(label)
  case label
  when /\Asince:(.+)\z/ then "until:#{$1}"
  when /\Auntil:(.+)\z/ then "since:#{$1}"
  when /\Aif:(.+)\z/ then "if_not:#{$1}"
  when /\Aif_not:(.+)\z/ then "if:#{$1}"
  else "not(#{label})"
  end
end

def extract_pp_version(line)
  # "#@since 3.4" / "#@since \"3.4\"" / "#@until 2.7.0" のいずれも受理する
  # (rrdparser.rb build_cond_by_value と同じ2形式)
  line.sub(/\A\#@\w+/, '').strip.sub(/\A"(.*)"\z/, '\1')
end

def extract_name(line)
  m = SIG_RE.match(line)
  keyword = m[1]
  rest = line[m.end(0)..-1] || ''
  if keyword == 'gvar '
    gm = GVAR_AT_START_RE.match(rest)
    gm && gm[1]
  else
    nm = NAME_AT_START_RE.match(rest)
    nm && nm[1]
  end
end

def determine_kind(line, ctx, file, lineno)
  keyword = SIG_RE.match(line)[1]
  return 'v' if keyword == 'gvar '

  case ctx.type
  when :singleton_method then 's'
  when :instance_method then 'i'
  when :constant then 'c'
  when :special_variable then 'v'
  when :module_function
    'o'
  when nil
    warn_entry(file, lineno, "kind undetermined (no enclosing ## section) for #{line.strip.inspect}")
    'o'
  else
    'o'
  end
end

def handle_h1(line, ctx)
  content = line.sub(/\A#/, '').strip
  m = /\A(\S+)\s*([^\s<]+)(?:\s*<\s*(\S+))?\z/.match(content)
  return unless m

  type = m[1]
  name = m[2]
  return unless %w[class module object reopen redefine].include?(type)

  ctx.class_name = name
  if type == 'object'
    # mdparser.rb read_object_body: H2 が無くても既定で singleton_method
    ctx.type = :singleton_method
  else
    ctx.type = nil
  end
end

def handle_h2(line, ctx, file, lineno)
  content = line.sub(/\A##/, '').strip
  case content
  when /\A(?:(?:public|private|protected)\s+)?(?:(class|singleton|instance)\s+)?methods?\z/i
    t = ($1 || 'instance').downcase.sub('class', 'singleton')
    ctx.type = "#{t}_method".to_sym
  when /\Amodule\s+functions?\z/i
    ctx.type = :module_function
  when /\Aconstants?\z/i
    ctx.type = :constant
  when /\Aspecial\s+variables?\z/i
    ctx.type = :special_variable
  else
    warn_entry(file, lineno, "unknown ## header: #{content.inspect}")
  end
end

def parse_attr_line(line)
  m = ATTR_RE.match(line)
  since_v = nil
  until_v = nil
  flags = []
  m[1].strip.split(/\s+/).each do |tok|
    next if tok.empty?

    if (km = /\A(\w+)=(.*)\z/.match(tok))
      key = km[1]
      raw = km[2]
      qm = /\A"(.*)"\z/.match(raw)
      if qm
        since_v = qm[1] if key == 'since'
        until_v = qm[1] if key == 'until'
      end
    else
      flags << tok
    end
  end
  disp = ->(v) { v.nil? ? '-' : (v.empty? ? 'EMPTY' : v) }
  [disp.call(since_v), disp.call(until_v), flags]
end

# lines を先頭(または start_index)から末尾まで1行ずつ処理する。
# #@include は該当ファイルを読み込み、同じ ctx / pp_stack を引き継いで
# 再帰的に処理する(bitclust の Preprocessor は #@include 先を独立した
# 状態で前処理するが、外側の条件が false ならまるごとスキップされる点も
# 含め、外側条件と内側条件の AND を pp_cond に連結するのは等価)。
def process_lines(lines, file, start_index, ctx, pp_stack, class_since, class_until)
  i = start_index
  n = lines.length
  while i < n
    line = lines[i]
    lineno = i + 1

    case line
    when /\A\#@\#/ # プリプロセッサコメント
      i += 1
    when /\A\#@include\s*\(\s*(.*?)\s*\)/
      name = $1
      frag_lines = load_fragment_lines(name)
      if frag_lines
        depth_before = pp_stack.length
        process_lines(frag_lines, "#{name}.md", 0, ctx, pp_stack.dup, class_since, class_until)
        warn_entry(file, lineno, "pp_stack depth changed after \#@include(#{name})") if pp_stack.length != depth_before
      else
        warn_entry(file, lineno, "\#@include target not found: #{name}.md")
      end
      i += 1
    when /\A\#@since\b/
      pp_stack.push("since:#{extract_pp_version(line)}")
      i += 1
    when /\A\#@until\b/
      pp_stack.push("until:#{extract_pp_version(line)}")
      i += 1
    when /\A\#@if\b/
      expr = line.sub(/\A\#@if/, '').strip
      pp_stack.push("if:#{expr}")
      i += 1
    when /\A\#@else\s*\z/
      if pp_stack.empty?
        warn_entry(file, lineno, '#@else with no matching #@if/#@since/#@until')
      else
        pp_stack.push(invert_label(pp_stack.pop))
      end
      i += 1
    when /\A\#@end\s*\z/
      warn_entry(file, lineno, '#@end with no matching #@if/#@since/#@until') if pp_stack.empty?
      pp_stack.pop
      i += 1
    when /\A\#@todo/i
      i += 1
    when /\A\#@samplecode\b/
      i += 1 # 見出し検出に影響しないので構造上は無視してよい
    when /\A\#@/
      warn_entry(file, lineno, "unrecognized preprocessor directive: #{line.strip.inspect}")
      i += 1
    else
      if ctx.fence_len
        ctx.fence_len = nil if line =~ /\A`{#{ctx.fence_len}}\s*\z/
        i += 1
      elsif (fm = FENCE_START_RE.match(line))
        ctx.fence_len = fm[1].length
        i += 1
      elsif line =~ H1_RE
        handle_h1(line, ctx)
        i += 1
      elsif line =~ H2_RE
        handle_h2(line, ctx, file, lineno)
        i += 1
      elsif SIG_RE.match(line)
        name = extract_name(line)
        if name.nil?
          warn_entry(file, lineno, "could not extract method name from #{line.strip.inspect}")
          i += 1
          next
        end
        since_attr = '-'
        until_attr = '-'
        consumed = 0
        nxt = lines[i + 1]
        if nxt && ATTR_RE.match(nxt)
          since_attr, until_attr, = parse_attr_line(nxt)
          consumed = 1
        end
        kind = determine_kind(line, ctx, file, lineno)
        $entries << Entry.new(
          file, lineno, ctx.class_name || '?', kind, name,
          since_attr, until_attr,
          pp_stack.empty? ? '-' : pp_stack.join(','),
          class_since, class_until
        )
        i += 1 + consumed
      else
        i += 1
      end
    end
  end
end

def fallback_class_name(file)
  file.sub(/\.md\z/, '').gsub('__', '::')
end

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

all_files = Dir.glob(File.join(DIR, '*.md')).map { |p| File.basename(p) }.sort

# #@include(NAME) の対象になっているファイルはトップレベルからは処理せず、
# 取り込み元をたどって処理する(取り込み元の class_name/kind 文脈を
# 正しく引き継ぐため)。対象を探すのはコードフェンス内かどうかを問わない
# (bitclust の Preprocessor 自体がフェンスを知らない行単位のフィルタなので)
included_names = {}
all_files.each do |file|
  lines = read_lines(File.join(DIR, file))
  lines.each do |line|
    if (m = /\A\#@include\s*\(\s*(.*?)\s*\)/.match(line))
      included_names[m[1]] = true
    end
  end
end

top_level_files = all_files.reject { |f| included_names.key?(f.sub(/\.md\z/, '')) }

top_level_files.each do |file|
  lines = read_lines(File.join(DIR, file))
  next unless lines

  class_since, class_until = read_class_since_until(lines)
  ctx = Context.new(fallback_class_name(file), nil, nil)
  pp_stack = []
  process_lines(lines, file, 0, ctx, pp_stack, class_since, class_until)
  warn_entry(file, lines.length, "unterminated \#@if/\#@since/\#@until (pp_stack=#{pp_stack.inspect})") unless pp_stack.empty?
  warn_entry(file, lines.length, "unclosed code fence at EOF") if ctx.fence_len
end

$entries.each do |e|
  puts [
    e.file, e.line, e.class_name, e.kind, e.method_name,
    e.since_attr, e.until_attr, e.pp_cond, e.class_since, e.class_until
  ].join("\t")
end

if $warnings.any?
  warn "#{$warnings.size} warning(s):"
  $warnings.each do |w|
    warn "  #{w.file}:#{w.line}: #{w.message}"
  end
end
warn "#{$entries.size} entries from #{top_level_files.size} top-level files " \
     "(#{included_names.size} fragment files reached via " + '#@include' + ')'

# doctree の manual/api/<lib>.md front matter から require:/sublibrary: の
# リスト項目(サブ require 候補)を抜き出す。
#
# 前提: front matter は先頭の "---" 〜 次の "---" の間。
#   require:
#     - foo
#   #%until 4.1
#     - bar
#   #%else
#     - baz
#   #%end
# のようにディレクティブ行が混在することがあるが、"- " で始まる行だけを
# リスト項目として拾うので無視される(= 版分岐の両方の枝を候補として試す)。
#
# 戻り値: 文字列配列(重複除去)
def frontmatter_requires(doctree_root, lib)
  path = File.join(doctree_root, "manual", "api", "#{lib}.md")
  return [] unless File.exist?(path)
  lines = File.readlines(path)
  return [] if lines.empty? || lines[0].strip != "---"
  fm_end = lines[1..].index { |l| l.strip == "---" }
  return [] unless fm_end
  fm = lines[1, fm_end]

  items = []
  current_key = nil
  fm.each do |line|
    if line =~ /^(require|sublibrary):\s*$/
      current_key = $1
      next
    elsif line =~ /^#%/
      # 版分岐ディレクティブ(#%until/#%else/#%if/#%end 等)。
      # 両方の枝を候補として残すため current_key は維持したまま無視する。
      next
    elsif line =~ /^[A-Za-z_]\S*:/  # 別のトップレベルキー(値がインラインの場合も含む)
      current_key = nil
      next
    end
    next unless current_key
    if line =~ /^\s*-\s+(\S+)\s*$/
      items << $1
    end
  end
  items.uniq
end

if __FILE__ == $0
  root = ARGV[0] || "/home/debian/rurema/doctree"
  ARGV[1..].each do |lib|
    puts "#{lib}: #{frontmatter_requires(root, lib).inspect}"
  end
end

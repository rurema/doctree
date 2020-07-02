#!ruby

# RDoc をるりまのドキュメントに変換します。
# 新しく追加されたメソッドのドキュメントを書く際は、
# このスクリプトで生成したドキュメントを元にるりまの
# ドキュメントを書くと便利でしょう。
# また一次対応としては、インポートしたドキュメントを
# そのままるりまに反映しても構いません。


# Usage:
#   bin/generate-from-rdoc.rb [--since=VERSION] Klass#method
#
# Example:
#   bin/generate-from-rdoc.rb --since=2.7.0 'Symbol#start_with?' >> refm/api/src/_builtin/Symbol

require 'optparse'
require 'open3'

opt = ARGV.getopts('', 'since:')
since = opt['since']

md, status = Open3.capture2('ri', ARGV.first, '--format=markdown', '--no-pager')

raise "executing ri is failed" unless status.success?
raise md if md.match?(/\A.+not found/)

lines = md.lines.drop_while { |l| !l.match?(/^---/) }.drop(1)

# parse method signature
signatures = []
while (line = lines.shift) != "\n"
  signatures << line
end
lines.shift 2

# parse description and samplecode
prev = :desc
chunks = lines.chunk_while do |a, b|
  next true if b == "\n"

  cur = b.start_with?(' ') ? :code : :desc
  (prev == cur).tap do
    prev = cur
  end
end.to_a


puts "\#@since #{since}" if since
puts signatures.join.gsub(/^\s+(?:\w+\.)?/, '--- ')
puts

chunks.each.with_index do |lines, idx|
  if lines[0].start_with?(" ")
    puts "\#@samplecode"
    puts lines.join.rstrip.gsub(/^    /, '')
    puts "\#@end"
  else
    puts lines.join.rstrip
  end
  puts if idx != chunks.size - 1
end
puts "\#@end" if since

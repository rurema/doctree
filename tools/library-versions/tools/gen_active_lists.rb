# rurema-libs.tsv から各版の「有効ページ」名簿を作る(_builtin と要注意 require は除外)
SKIP = %w[_builtin debug]  # debug は require で対話デバッガが起動しうるため実測から除外(ツリー側で確認)
libs = File.readlines(ARGV[0]).drop(1).map { |l| l.chomp.split("\t", 4) }
%w[3.0 3.1 3.2 3.3 3.4 4.0 4.1].each do |v|
  gv = Gem::Version.new(v)
  active = libs.select do |name, since, until_, _|
    next false if SKIP.include?(name)
    next false if since && !since.empty? && Gem::Version.new(since) > gv
    next false if until_ && !until_.empty? && Gem::Version.new(until_) <= gv
    true
  end.map(&:first)
  File.write(File.join(ARGV[1], "active-#{v}.txt"), active.sort.join("\n") + "\n")
  puts "#{v}: #{active.size}"
end

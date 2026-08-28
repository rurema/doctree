#!/usr/bin/env ruby
SP = "/tmp/claude-1000/-home-debian-rurema/58ba4581-c6ee-4450-bb72-29d0c6d1cc48/scratchpad"

ver = ARGV[0] # 3.0 / 3.1 / 3.2
bundled_file = "#{SP}/lib-check/ruby-stdlib/raw/#{ver}-bundled_gems.txt"
active_file = "#{SP}/file-check/active-#{ver}.txt"

gems = {}
File.readlines(bundled_file).each do |line|
  line = line.strip
  next if line.empty? || line.start_with?("#")
  parts = line.split
  name, version, repo = parts[0], parts[1], parts[2]
  rev = parts[3]
  gems[name] = {version: version, repo: repo, rev: rev}
end

names = File.readlines(active_file).map(&:chomp).reject(&:empty?)

names.each do |name|
  full_conv = name.gsub("/", "-")
  first_seg = name.split("/").first
  candidate = nil
  if gems.key?(full_conv)
    candidate = full_conv
  elsif gems.key?(first_seg)
    candidate = first_seg
  elsif gems.key?(name)
    candidate = name
  end
  next unless candidate
  g = gems[candidate]
  puts "#{name}\tgem:#{candidate}\t#{g[:version]}\t#{g[:repo]}\t#{g[:rev]}"
end

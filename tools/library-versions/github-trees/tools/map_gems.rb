#!/usr/bin/env ruby
require 'set'
SP = "/tmp/claude-1000/-home-debian-rurema/58ba4581-c6ee-4450-bb72-29d0c6d1cc48/scratchpad"
GH = "#{SP}/file-check/github"

ver = ARGV[0] || "master"
bundled_file = ver == "master" ? "#{SP}/lib-check/ruby-stdlib/raw/master-bundled_gems.txt" : "#{SP}/lib-check/ruby-stdlib/raw/#{ver}-bundled_gems.txt"

gems = {}
File.readlines(bundled_file).each do |line|
  next if line.strip.empty? || line.start_with?("#")
  parts = line.split
  name, version, repo = parts[0], parts[1], parts[2]
  rev = parts[3]
  gems[name] = {version: version, repo: repo, rev: rev}
end

unresolved_file = ARGV[1]
names = File.readlines(unresolved_file).map { |l| l.split("\t").first }

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
  if candidate
    g = gems[candidate]
    puts "#{name}\tgem:#{candidate}\t#{g[:version]}\t#{g[:repo]}\t#{g[:rev]}"
  else
    puts "#{name}\tNOGEM\t\t\t"
  end
end

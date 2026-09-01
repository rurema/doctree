#!/usr/bin/env ruby
require 'set'
SP = "/tmp/claude-1000/-home-debian-rurema/58ba4581-c6ee-4450-bb72-29d0c6d1cc48/scratchpad"
GH = "#{SP}/file-check/github"

mapped_file = ARGV[0]  # e.g. mapped-4.1.tsv: name \t gem:xxx \t version \t repo \t rev
log_file = ARGV[1]     # gem-resolution log to extract ref used

# parse ref used per gemname from log
ref_used = {}
File.readlines(log_file).each do |line|
  if line =~ /^(\S+):\s+repo=\S+\s+ref=(\S+)/
    ref_used[$1] = $2
  end
end

cache = {}
def load_gem_files(gemname)
  path = "#{GH}/gem-#{gemname}-files.txt"
  return [] unless File.exist?(path)
  File.readlines(path).map(&:chomp)
end

File.readlines(mapped_file).each do |line|
  line = line.chomp
  next if line.empty?
  parts = line.split("\t")
  name = parts[0]
  gemtag = parts[1]
  if gemtag == "NOGEM"
    puts "#{name}\tno\tnone"
    next
  end
  gemname = gemtag.sub("gem:", "")
  files = (cache[gemname] ||= load_gem_files(gemname))
  # NOTE: files are paths relative to the gem's lib/ dir already (tree fetched at lib/ subtree sha)
  target = "#{name}.rb"
  if files.include?(target)
    ref = ref_used[gemname] || "?"
    puts "#{name}\tyes\tgem:#{gemname}@#{ref}"
  else
    puts "#{name}\tno\tgem:#{gemname}(checked,missing:lib/#{target})"
  end
end

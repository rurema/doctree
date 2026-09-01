#!/usr/bin/env ruby
SP = "/tmp/claude-1000/-home-debian-rurema/58ba4581-c6ee-4450-bb72-29d0c6d1cc48/scratchpad"
GH = "#{SP}/file-check/github"

ver = ARGV[0] # 3.0/3.1/3.2
candidates_file = "#{GH}/bundled-candidates-#{ver}.tsv"

cache = {}
def load_files(path)
  return [] unless File.exist?(path)
  File.readlines(path).map(&:chomp)
end

# candidates line: name \t gem:xxx \t version \t repo \t rev
File.readlines(candidates_file).each do |line|
  line = line.chomp
  next if line.empty?
  parts = line.split("\t")
  name, gemtag, version = parts[0], parts[1], parts[2]
  gemname = gemtag.sub("gem:", "")
  # special-case: rexml@3.4.4 for 3.2 reuses the master fetch file (no version suffix)
  path = if gemname == "rexml" && version == "3.4.4"
    "#{GH}/gem-rexml-files.txt"
  else
    "#{GH}/gem-#{gemname}-#{version}-files.txt"
  end
  files = (cache[path] ||= load_files(path))
  target = "#{name}.rb"
  if files.include?(target)
    puts "#{name}\tyes\tgem:#{gemname}@#{version}"
  else
    puts "#{name}\tno\tgem:#{gemname}@#{version}(checked,missing:lib/#{target})"
  end
end

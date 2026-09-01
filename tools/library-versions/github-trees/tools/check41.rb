#!/usr/bin/env ruby
# Check active-4.1.txt names against master lib/ext trees (in-tree pass only).
SP = "/tmp/claude-1000/-home-debian-rurema/58ba4581-c6ee-4450-bb72-29d0c6d1cc48/scratchpad"
GH = "#{SP}/file-check/github"

lib_files = File.readlines("#{GH}/master-lib-files.txt").map(&:chomp)
ext_files = File.readlines("#{GH}/master-ext-files.txt").map(&:chomp)
lib_set = lib_files.to_set rescue nil
require 'set'
lib_set = lib_files.to_set
ext_set = ext_files.to_set

names = File.readlines("#{SP}/file-check/active-4.1.txt").map(&:chomp).reject(&:empty?)

results = {}
names.each do |name|
  # 1. lib exact
  if lib_set.include?("#{name}.rb")
    results[name] = ["yes", "lib"]
    next
  end
  # 2. ext prefix match with extconf.rb or *.c present
  prefix = "#{name}/"
  prefix_matches = ext_files.select { |p| p.start_with?(prefix) }
  if prefix_matches.any? { |p| p.end_with?("extconf.rb") || p.end_with?(".c") }
    results[name] = ["yes", "ext"]
    next
  end
  # 3. ext suffix /lib/<name>.rb$
  suffix = "/lib/#{name}.rb"
  if ext_files.any? { |p| p.end_with?(suffix) }
    results[name] = ["yes", "ext"]
    next
  end
  # 4. unresolved -- needs manual/gem check
  results[name] = ["unresolved", prefix_matches.any? ? "ext-prefix-no-c" : "none"]
end

results.each do |name, (verdict, where)|
  puts "#{name}\t#{verdict}\t#{where}"
end

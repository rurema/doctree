#!/usr/bin/env ruby
SP = "/tmp/claude-1000/-home-debian-rurema/58ba4581-c6ee-4450-bb72-29d0c6d1cc48/scratchpad"
GH = "#{SP}/file-check/github"

pass1 = {}
File.readlines("#{GH}/pass1-4.1.tsv").each do |l|
  name, verdict, where = l.chomp.split("\t")
  pass1[name] = [verdict, where]
end

pass2 = {}
File.readlines("#{GH}/pass2-4.1.tsv").each do |l|
  name, verdict, where = l.chomp.split("\t")
  pass2[name] = [verdict, where]
end

# manual special cases (verified by hand -- see notes.md)
special = {
  "io/console/size" => ["yes", "ext:io/console/lib/console/size.rb (ext/<name>/lib/ maps to lib/io/<rest>)"],
  "kconv"           => ["yes", "gem:nkf@v0.3.0 (lib/kconv.rb ships alongside nkf.rb, name doesn't match gem name)"],
  "rbconfig"        => ["yes", "generated (tool/mkconfig.rb at build time; not a committed lib/ext source file -- caught only incidentally via ext/rbconfig/sizeof/ prefix)"],
}

names = File.readlines("#{SP}/file-check/active-4.1.txt").map(&:chomp).reject(&:empty?)

out = []
names.each do |name|
  if special.key?(name)
    verdict, where = special[name]
  elsif pass1.key?(name) && pass1[name][0] == "yes"
    verdict, where = pass1[name]
  elsif pass2.key?(name)
    verdict, where = pass2[name]
  else
    verdict, where = ["ERROR", "not-found-in-any-pass"]
  end
  out << [name, verdict, where]
end

puts "name\tverdict\twhere"
out.each { |row| puts row.join("\t") }

STDERR.puts "total=#{out.size} yes=#{out.count{|r|r[1]=="yes"}} no=#{out.count{|r|r[1]=="no"}} ERROR=#{out.count{|r|r[1]=="ERROR"}}"

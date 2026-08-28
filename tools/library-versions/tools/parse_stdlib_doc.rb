#!/usr/bin/env ruby
# Parse doc/standard_library.{rdoc,md} + gems/bundled_gems into <ver>.tsv (name, kind, source)

RAW = File.join(__dir__, "raw")
OUT = __dir__

VERSIONS = {
  "3.0" => "v3_0_7",
  "3.1" => "v3_1_7",
  "3.2" => "v3_2_11",
  "3.3" => "v3_3_12",
  "3.4" => "v3_4_10",
  "4.0" => "v4.0.6",
  "master" => "master",
}

# Alias map: rdoc-format "Bundled gems" display name -> actual gem name (as in gems/bundled_gems)
# Needed only for cross-checking against bundled_gems.txt for 3.0-3.3 (rdoc format), since
# those versions show CamelCase/Module-style names rather than the gem package name.
RDOC_BUNDLED_ALIAS = {
  "MiniTest" => "minitest",
  "PowerAssert" => "power_assert",
  "Rake" => "rake",
  "Test::Unit" => "test-unit",
  "REXML" => "rexml",
  "RSS" => "rss",
  "RBS" => "rbs",
  "TypeProf" => "typeprof",
  "Net::FTP" => "net-ftp",
  "Net::IMAP" => "net-imap",
  "Net::POP3" => "net-pop",
  "Net::SMTP" => "net-smtp",
  "Matrix" => "matrix",
  "Prime" => "prime",
  "DEBUGGER__" => "debug",
  "Racc" => "racc",
}

def parse_rdoc(path)
  entries = []
  top = nil
  sub = nil
  File.readlines(path, chomp: true).each do |line|
    if line =~ /^= (.+)$/
      top = $1.strip
      sub = nil
      next
    elsif line =~ /^== (.+)$/
      sub = $1.strip
      next
    end
    next unless top
    # item line: "Name:: description" -- name may itself contain "::" (e.g. Net::FTP),
    # so find the FIRST "::" that is followed by whitespace (the true rdoc delimiter).
    if line =~ /^(.+?)::\s+(.*)$/
      name = $1.strip
      entries << [name, top, sub]
    end
  end
  entries
end

def parse_md(path)
  entries = []
  top = nil
  sub = nil
  File.readlines(path, chomp: true).each do |line|
    if line =~ /^# (.+)$/
      top = $1.strip
      sub = nil
      next
    elsif line =~ /^## (.+)$/
      sub = $1.strip
      next
    end
    next unless top
    next unless line.start_with?("- ")
    body = line.sub(/^- /, "")
    # Strip an optional " ([GitHub][ref])" link annotation that follows the name
    # (present for Default/Bundled gem entries) before splitting name from description --
    # otherwise names containing "::" (e.g. "Net::HTTP") get mis-split at the link's colon.
    body = body.sub(/\s*\(\[GitHub\]\[[^\]]+\]\)/, "")
    name = nil
    if body =~ /^`([^`]+)`/
      name = $1
    elsif body =~ /^\[([^\]]+)\]/
      name = $1
    elsif body =~ /^(.+?):\s+.*$/
      # generic "Name: description" -- find the FIRST ":" followed by whitespace,
      # so a "::" inside the name itself (e.g. "Net::HTTP") is not mistaken for the delimiter.
      name = $1.strip
    end
    next unless name
    entries << [name, top, sub]
  end
  entries
end

def classify(top, sub)
  if top =~ /Default gems/
    "default-gem"
  elsif top =~ /Bundled gems/
    "bundled-gem"
  else
    # first/core section: "Ruby Standard Library"
    if sub =~ /Extensions/
      "ext"
    else
      "lib" # "Libraries" (fallback default if sub unrecognized)
    end
  end
end

def parse_bundled_gems_file(path)
  names = []
  File.readlines(path, chomp: true).each do |line|
    line = line.strip
    next if line.empty? || line.start_with?("#")
    names << line.split(/\s+/).first
  end
  names
end

VERSIONS.each do |ver, tag|
  rdoc_path = File.join(RAW, "#{ver}-standard_library.rdoc")
  md_path = File.join(RAW, "#{ver}-standard_library.md")
  raw_entries =
    if File.exist?(rdoc_path)
      parse_rdoc(rdoc_path)
    elsif File.exist?(md_path)
      parse_md(md_path)
    else
      []
    end

  rows = [] # [name, kind, source]
  seen = {} # kind => Set of names (for bundled/default alias checks)
  raw_entries.each do |name, top, sub|
    kind = classify(top, sub)
    rows << [name, kind, "stdlib-doc"]
  end

  # cross-check with gems/bundled_gems
  bg_path = File.join(RAW, "#{ver}-bundled_gems.txt")
  if File.exist?(bg_path) && !File.zero?(bg_path)
    bg_names = parse_bundled_gems_file(bg_path)
    doc_bundled_names = rows.select { |_, k, _| k == "bundled-gem" }.map { |n, _, _| n }

    is_rdoc = File.exist?(rdoc_path)
    covered = doc_bundled_names.map do |n|
      is_rdoc ? (RDOC_BUNDLED_ALIAS[n] || n) : n.downcase
    end

    bg_names.each do |bgn|
      next if covered.include?(bgn.downcase) || covered.include?(bgn)
      rows << [bgn, "bundled-gem", "bundled_gems-file"]
    end
  end

  rows.sort_by! { |n, k, s| [k, n.downcase] }

  out_path = File.join(OUT, "#{ver}.tsv")
  File.open(out_path, "w") do |f|
    f.puts "name\tkind\tsource"
    rows.each { |n, k, s| f.puts "#{n}\t#{k}\t#{s}" }
  end
  counts = rows.group_by { |_, k, _| k }.transform_values(&:size)
  puts "#{ver}: total=#{rows.size} #{counts}"
end

# --- reverse check: stdlib-doc bundled-gem entries not present in bundled_gems.txt ---
puts
puts "=== reverse check (stdlib bundled listed but not in bundled_gems.txt) ==="
VERSIONS.each do |ver, tag|
  bg_path = File.join(RAW, "#{ver}-bundled_gems.txt")
  next unless File.exist?(bg_path) && !File.zero?(bg_path)
  bg_names = parse_bundled_gems_file(bg_path).map(&:downcase)
  rdoc_path = File.join(RAW, "#{ver}-standard_library.rdoc")
  is_rdoc = File.exist?(rdoc_path)
  tsv = File.readlines(File.join(OUT, "#{ver}.tsv"), chomp: true).drop(1)
  tsv.each do |line|
    name, kind, source = line.split("\t")
    next unless kind == "bundled-gem" && source == "stdlib-doc"
    norm = is_rdoc ? (RDOC_BUNDLED_ALIAS[name] || name).downcase : name.downcase
    unless bg_names.include?(norm)
      puts "#{ver}: #{name} (normalized=#{norm}) not in bundled_gems.txt"
    end
  end
end

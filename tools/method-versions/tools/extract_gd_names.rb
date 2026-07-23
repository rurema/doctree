#!/usr/bin/env ruby
# frozen_string_literal: true
#
# tools/extract_gd_names.rb
#
# 使い方:
#   ruby tools/extract_gd_names.rb \
#     [--repo ../path/to/generated-documents] \
#     [--rev origin/main] \
#     [--out ../gd-db-names.tsv]
#
# 事前に `git -C <repo> fetch origin` で最新化しておくこと(読み取り専用)。
#
# 目的・経緯:
#   extract_gd_presence.rb (`gd-db-presence.tsv`) はファイルパスの存在
#   一覧に過ぎない。しかし bitclust の1つの MethodEntry ファイルは複数の
#   別名(例: Object の `i.__send__._builtin` は中身が
#   `names=__send__,send` で、"send" 単体のファイルは存在しない)を
#   1ファイルにまとめて持つことがあり、`MethodSinceCalculator` はファイル
#   の中身の `names=` プロパティを読んで名前ごとに since/until を計算する
#   (`bitclust/lib/bitclust/method_since_calculator.rb:48-56`
#   `m.names.each {|name| key = [c.name, m.typechar, name] ...}`)。
#   つまり本番のバッジ計算はパスではなく中身の names= を見ている。
#
#   compare.rb は当初、現行 doctree ソースを再スキャンして「本文を挟まず
#   連続する見出しは1チャンク」というルールでこの別名グループを推測していた
#   (`tools/compare.rb` の CHUNK_DB_ALT)。ところがこれは対象データが
#   「現在の doctree 構成」ベースであり、**過去に doctree 側で
#   分割済みだが凍結 DB 側はまだ分割前の合体ファイルのまま**、という
#   ケース(例: `Object#send`/`Object#__send__` は db-2.5.0 で分離される
#   前、db-1.8.7〜db-2.4.0 では `__send__` 1ファイルに
#   `names=__send__,send` としてまとまっていた)を検出できない。
#   このスクリプトは各版の DB ファイルの中身を実際に読んで `names=` を
#   直接取得することで、この限界を解消する(`git cat-file --batch` で
#   32000+ ファイルをまとめて読むことで実用速度を確保)。
#
# 出力(TSV, ヘッダ行なし, タブ区切り):
#   gd-db-names.tsv: db_version \t class_name \t typechar \t names(comma-joined, デコード済み)
#   (1行 = 1物理ファイル。gd-db-presence.tsv の1行に対応するが、
#    method_name 列の代わりに、そのファイルが実際に持つ全別名を持つ)

require 'optparse'
require 'open3'

# bitclust は doctree の慣例どおり BITCLUST_PATH で解決(未設定なら
# doctree checkout の隣に bitclust が clone されている前提の相対パス)。
bitclust_root = ENV['BITCLUST_PATH'] || File.expand_path('../../../../bitclust', __dir__)
$LOAD_PATH.unshift File.join(bitclust_root, 'lib')
require 'bitclust/nameutils'

NU = BitClust::NameUtils

options = {
  # デフォルトは doctree checkout の隣に generated-documents が clone
  # されている前提の相対パス(GD_PATH 環境変数でも指定可)
  repo: ENV['GD_PATH'] || File.expand_path('../../../../generated-documents', __dir__),
  rev: 'origin/main',
  out: File.expand_path('../gd-db-names.tsv', __dir__),
}

OptionParser.new do |opt|
  opt.on('--repo PATH') { |v| options[:repo] = v }
  opt.on('--rev REV') { |v| options[:rev] = v }
  opt.on('--out PATH') { |v| options[:out] = v }
end.parse!(ARGV)

def git_capture(repo, *args)
  out, status = Open3.capture2('git', '-C', repo, *args)
  raise "git #{args.join(' ')} failed (status=#{status.exitstatus})" unless status.success?

  out
end

repo = options[:repo]
rev = options[:rev]

top_entries = git_capture(repo, 'ls-tree', '--name-only', "#{rev}:db").lines.map(&:chomp)
db_names = top_entries.grep(/\Adb-/).sort_by { |n| Gem::Version.new(n.sub(/\Adb-/, '')) rescue n }
versions = db_names.map { |n| n.sub(/\Adb-/, '') }
warn "db versions (#{versions.size}): #{versions.join(', ')}"

method_paths_arg = db_names.map { |n| "db/#{n}/method" }
method_lines = git_capture(repo, 'ls-tree', '-r', '--name-only', rev, '--', *method_paths_arg).lines.map(&:chomp)

TYPECHARS = %w[i s m c v].freeze

# path => [version, class_name, typechar] (filtered to _builtin, valid typechar)
targets = {}
method_lines.each do |line|
  fields = line.split('/')
  next unless fields.size == 5
  next unless fields[0] == 'db' && fields[2] == 'method'

  classdir_enc = fields[3]
  filename_enc = fields[4]
  next if filename_enc.start_with?('=', '.')
  next if classdir_enc.start_with?('=', '.')

  decoded_filename = NU.decodeid(filename_enc)
  typechar, _mname_enc, libid_enc = decoded_filename.split('.', 3)
  next unless typechar && libid_enc
  next unless libid_enc == '_builtin'
  next unless TYPECHARS.include?(typechar)

  version = fields[1].sub(/\Adb-/, '')
  class_name = NU.classid2name(NU.decodeid(classdir_enc))
  targets[line] = [version, class_name, typechar]
end

warn "targets: #{targets.size} _builtin method files to read via git cat-file --batch"

# git cat-file --batch: feed "rev:path" lines, parse "<sha> <type> <size>\n<size bytes>\n"
results = {} # path => names(Array[String], decoded) or nil

Open3.popen2('git', '-C', repo, 'cat-file', '--batch') do |stdin, stdout, wait_thr|
  stdin.binmode
  stdout.binmode
  reader = Thread.new do
    targets.each_key do |path|
      header = stdout.gets
      raise "unexpected EOF from git cat-file --batch (path=#{path.inspect})" unless header

      header = header.chomp
      if header.end_with?(' missing')
        results[path] = nil
        next
      end

      _sha, _type, size = header.split(' ')
      content = stdout.read(size.to_i)
      stdout.read(1) # trailing newline after the object content
      names_line = content.each_line.find { |l| l.start_with?('names=') }
      if names_line
        raw_names = names_line.chomp.sub(/\Anames=/, '').split(',')
        results[path] = raw_names.map { |n| NU.decodename_url(n) }
      else
        results[path] = []
      end
    end
  end

  targets.each_key { |path| stdin.puts "#{rev}:#{path}" }
  stdin.close
  reader.join
  wait_thr.value
end

rows = [] # [version, class_name, typechar, names_csv]
targets.each do |path, (version, class_name, typechar)|
  names = results[path]
  next if names.nil? # should not happen (path came from ls-tree of the same rev)

  rows << [version, class_name, typechar, names.join(',')]
end

rows.sort_by! do |version, class_name, typechar, _names|
  [begin
     Gem::Version.new(version)
   rescue ArgumentError
     Gem::Version.new('0')
   end, class_name, typechar]
end

File.open(options[:out], 'w') do |f|
  rows.each { |row| f.puts row.join("\t") }
end
warn "wrote #{rows.size} rows to #{options[:out]}"

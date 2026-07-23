#!/usr/bin/env ruby
# frozen_string_literal: true
#
# tools/extract_gd_presence.rb
#
# 使い方:
#   ruby tools/extract_gd_presence.rb \
#     [--repo ../path/to/generated-documents] \
#     [--rev origin/main] \
#     [--out-presence ../gd-db-presence.tsv] \
#     [--out-classes  ../gd-db-classes.tsv]
#
# 事前に `git -C <repo> fetch origin` で最新化しておくこと
# (このスクリプト自体は読み取り専用・fetch は行わない)。
#
# 目的:
#   rurema/generated-documents (通称 gd。docs.ruby-lang.org の本番配信元。
#   ※ docs.ruby-lang.org リポジトリ自体は Capistrano デプロイ設定のみで
#     db は持たない。db/html は generated-documents 側にある。
#     system/bc-setup-all 参照)の各バージョン DB ツリーから
#   _builtin ライブラリのメソッド/クラスの「存在」一覧を抽出する。
#   これは本番のメソッド単位 since/until バッジ(全バージョン DB での
#   最古/最新出現)の自動計算そのものの入力を再現する。
#
# 実装メモ(詳細は notes-gd-db.md 参照):
#   db 配下のディレクトリ/ファイル名は bitclust の
#   BitClust::NameUtils.encodeid によるエンコーディング
#   (大文字を "-x" にした上で文字列全体を downcase したもの。
#    bitclust/lib/bitclust/nameutils.rb:248-250)がかかっている。
#   デコードは同 decodeid (同 253-255) で逆変換した上で、
#     class/#{cid}/#{typechar}.#{mname_enc}.#{libid_enc}
#   の形に分解し、classid2name / decodename_url / libid2name で
#   それぞれデコードする。
#
#   メソッド名・ライブラリ名側は "=XX"(2桁16進)による別のエンコーディング
#   (encodename_url, nameutils.rb:230-232)が使われており、encodeid の
#   "-x" 方式とは併記されていてもマーカー文字 ('-' 対 '=') が異なるため
#   衝突しない。よってパス全体に対して先に decodeid を適用してから
#   '.' でフィールド分割し、各フィールドを個別にデコードする、という
#   順序で問題なく処理できる。
#
# 出力(TSV, ヘッダ行なし, タブ区切り):
#   gd-db-presence.tsv: db_version \t class_name \t typechar \t method_name
#   gd-db-classes.tsv : db_version \t class_name
#
# typechar の意味 (nameutils.rb:162-168 NAME_TO_CHAR / 138-144 NAME_TO_MARK):
#   i => instance_method (#)   s => singleton_method (.)
#   m => module_function (.#)  c => constant (::)
#   v => special_variable ($)

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
  out_presence: File.expand_path('../gd-db-presence.tsv', __dir__),
  out_classes: File.expand_path('../gd-db-classes.tsv', __dir__),
}

OptionParser.new do |opt|
  opt.on('--repo PATH') { |v| options[:repo] = v }
  opt.on('--rev REV') { |v| options[:rev] = v }
  opt.on('--out-presence PATH') { |v| options[:out_presence] = v }
  opt.on('--out-classes PATH') { |v| options[:out_classes] = v }
end.parse!(ARGV)

def git_capture(repo, *args)
  out, status = Open3.capture2('git', '-C', repo, *args)
  raise "git #{args.join(' ')} failed (status=#{status.exitstatus})" unless status.success?

  out
end

repo = options[:repo]
rev = options[:rev]

# 1. db-* ディレクトリ一覧を取得
top_entries = git_capture(repo, 'ls-tree', '--name-only', "#{rev}:db").lines.map(&:chomp)
db_names = top_entries.grep(/\Adb-/).sort_by { |n| Gem::Version.new(n.sub(/\Adb-/, '')) rescue n }
versions = db_names.map { |n| n.sub(/\Adb-/, '') }

warn "db versions (#{versions.size}): #{versions.join(', ')}"

# 2. 全バージョン分の method/ 以下のパスを1回の git ls-tree で取得
method_paths_arg = db_names.map { |n| "db/#{n}/method" }
method_lines = git_capture(repo, 'ls-tree', '-r', '--name-only', rev, '--', *method_paths_arg).lines.map(&:chomp)

TYPECHARS = %w[i s m c v].freeze

presence_rows = [] # [db_version, class_name, typechar, method_name]
unexpected_typechars = Hash.new(0)

method_lines.each do |line|
  fields = line.split('/')
  next unless fields.size == 5 # db, db-X, method, classdir_enc, filename_enc
  next unless fields[0] == 'db' && fields[2] == 'method'

  db_name = fields[1]
  version = db_name.sub(/\Adb-/, '')
  classdir_enc = fields[3]
  filename_enc = fields[4]

  # =index / =sindex 等の索引ファイル、隠しファイルはスキップ
  next if filename_enc.start_with?('=', '.')
  next if classdir_enc.start_with?('=', '.')

  decoded_filename = NU.decodeid(filename_enc)
  typechar, mname_enc, libid_enc = decoded_filename.split('.', 3)
  next unless typechar && mname_enc && libid_enc
  next unless libid_enc == '_builtin' # 今回は _builtin ライブラリのみ対象

  unless TYPECHARS.include?(typechar)
    unexpected_typechars[typechar] += 1
    next
  end

  class_name = NU.classid2name(NU.decodeid(classdir_enc))
  method_name = NU.decodename_url(mname_enc)

  presence_rows << [version, class_name, typechar, method_name]
end

if unexpected_typechars.any?
  warn "WARNING: unexpected typechars encountered: #{unexpected_typechars.inspect}"
end

# バージョン順(Gem::Versionでソートできないものはそのまま)→クラス名→typechar→メソッド名
presence_rows.sort_by! do |version, class_name, typechar, method_name|
  [begin
     Gem::Version.new(version)
   rescue ArgumentError
     Gem::Version.new('0')
   end, class_name, typechar, method_name]
end

File.open(options[:out_presence], 'w') do |f|
  presence_rows.each do |row|
    f.puts row.join("\t")
  end
end
warn "wrote #{presence_rows.size} rows to #{options[:out_presence]}"

# 3. クラス一覧: 各バージョンの library/_builtin の "classes=" プロパティから取得
#    (class/ 以下の個々のファイルを全部読むより、_builtin ライブラリの
#     プロパティファイル1個を読む方がはるかに速く、かつ library=_builtin
#     の判定そのものである)
class_rows = [] # [db_version, class_name]

db_names.each do |db_name|
  version = db_name.sub(/\Adb-/, '')
  content =
    begin
      git_capture(repo, 'show', "#{rev}:db/#{db_name}/library/_builtin")
    rescue RuntimeError => e
      warn "WARNING: could not read library/_builtin for #{db_name}: #{e.message}"
      next
    end

  classes_line = content.lines.find { |l| l.start_with?('classes=') }
  next unless classes_line

  ids = classes_line.chomp.sub(/\Aclasses=/, '').split(',')
  ids.each do |cid|
    next if cid.empty?

    class_rows << [version, NU.classid2name(cid)]
  end
end

class_rows.sort_by! do |version, class_name|
  [begin
     Gem::Version.new(version)
   rescue ArgumentError
     Gem::Version.new('0')
   end, class_name]
end

File.open(options[:out_classes], 'w') do |f|
  class_rows.each do |row|
    f.puts row.join("\t")
  end
end
warn "wrote #{class_rows.size} rows to #{options[:out_classes]}"

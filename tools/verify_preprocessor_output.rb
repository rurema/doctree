#!/usr/bin/env ruby
# frozen_string_literal: true
#
# verify_preprocessor_output.rb — 変換前後のプリプロセス出力バイト一致検証
#
# ■ 目的
#   BASE_DIR/manual と WORK_DIR/manual 配下の全 *.md について、
#   BitClust::Preprocessor.read の出力が --versions で指定した全バージョン
#   でバイト単位で一致することを確認する。fold_version_branches.rb などで
#   manual/ の #@since/#@until/#@if を書き換えたあと、生成される内容が
#   (サポート対象バージョンの範囲で)本当に変わっていないことの確認に使う。
#
# ■ 使い方
#   ruby tools/verify_preprocessor_output.rb BASE_DIR WORK_DIR
#   ruby tools/verify_preprocessor_output.rb BASE_DIR WORK_DIR --versions 3.0,3.1,3.2,3.3,3.4,4.0,4.1,9.9
#
#   BASE_DIR / WORK_DIR  それぞれ直下に manual/ を持つディレクトリ
#                        (比較元・比較先。例: 変換前を展開した一時ディレクトリと、
#                        変換後の doctree チェックアウト本体)
#   --versions           カンマ区切りのバージョン一覧(省略時は下記のとおり
#                        doctree/Rakefile から自動決定する)
#
# ■ bitclust の解決
#   doctree/Gemfile は BITCLUST_PATH 環境変数(既定値 ../bitclust、doctree
#   ディレクトリ基準)のディレクトリがあればそちらを優先する、という慣行に
#   合わせている。本スクリプトは doctree/tools/ に置かれる想定なので、
#   既定値は一段深い ../../bitclust (このファイル基準) にしてある:
#     ENV["BITCLUST_PATH"] || File.expand_path("../../bitclust", __dir__)
#   の lib/ を $LOAD_PATH に追加してから bitclust/preprocessor を require する。
#
# ■ --versions のデフォルト
#   doctree/Rakefile の SUPPORTED_VERSIONS / UNRELEASED_VERSIONS (%w リテラル)
#   を正規表現で読み取り、その和集合に「将来バージョンガード」として "9.9"
#   を加えたものを使う(#@if の `>` 条件などが将来版で意図せず畳み込まれて
#   いないかの回帰確認のため)。Rakefile が見つからない・両定数を読み取れ
#   ない場合は、デフォルトを推測せずに --versions を明示するようエラーで
#   要求する。
#
# ■ 出力・終了コード
#   only_in_base / only_in_work / exceptions / mismatches のいずれかが
#   1件でもあれば "RESULT: FAILED" で終了コード1。すべて0件なら
#   "RESULT: ALL MATCH" で終了コード0。
#
# ■ 注意
#   - 比較は BitClust::Preprocessor.read の出力そのもの(バイト列)であり、
#     文字列比較の版判定規則自体の正しさはここでは検証しない
#     (fold_version_branches.rb 側のコメント・bitclust/lib/bitclust/
#     preprocessor.rb の eval_expr を参照)。
#   - fold_version_branches.rb で manual/ を書き換えたら、commit する前に
#     必ず本スクリプトで ALL MATCH を確認する運用とする。
#
# ■ 経緯
#   PR https://github.com/rurema/doctree/pull/3097 でのバージョン分岐畳み
#   込み作業時に使った一時検証スクリプトを、恒久ツールとして整備したもの。

def parse_args(argv)
  base_dir = nil
  work_dir = nil
  versions = nil
  i = 0
  while i < argv.size
    case argv[i]
    when '--versions'
      versions = argv[i + 1].split(',').map(&:strip)
      i += 2
    when /\A--versions=(.*)\z/
      versions = $1.split(',').map(&:strip)
      i += 1
    when '--help', '-h'
      puts "usage: verify_preprocessor_output.rb BASE_DIR WORK_DIR [--versions 3.0,3.1,...]"
      exit 0
    else
      if base_dir.nil?
        base_dir = argv[i]
      elsif work_dir.nil?
        work_dir = argv[i]
      else
        raise "usage: verify_preprocessor_output.rb BASE_DIR WORK_DIR [--versions 3.0,3.1,...] (unexpected arg: #{argv[i].inspect})"
      end
      i += 1
    end
  end
  raise "usage: verify_preprocessor_output.rb BASE_DIR WORK_DIR [--versions 3.0,3.1,...]" unless base_dir && work_dir

  [base_dir, work_dir, versions]
end

# doctree/Rakefile の SUPPORTED_VERSIONS / UNRELEASED_VERSIONS (%w[...] リテラル)
# を正規表現で読み取る。両方読み取れなければ nil を返す。
def default_versions_from_rakefile
  rakefile_path = File.expand_path('../Rakefile', __dir__)
  return nil unless File.file?(rakefile_path)

  content = File.read(rakefile_path)
  supported = content[/^SUPPORTED_VERSIONS\s*=\s*%w\[([^\]]*)\]/m, 1]
  unreleased = content[/^UNRELEASED_VERSIONS\s*=\s*%w\[([^\]]*)\]/m, 1]
  return nil unless supported && unreleased

  versions = supported.split(/\s+/) + unreleased.split(/\s+/)
  versions << '9.9' # 将来バージョンガード: どの版よりも大きい値として比較に混ぜておく
  versions.uniq
end

base_dir, work_dir, versions = parse_args(ARGV)

if versions.nil?
  versions = default_versions_from_rakefile
  if versions.nil?
    warn "doctree/Rakefile から SUPPORTED_VERSIONS / UNRELEASED_VERSIONS を読み取れませんでした。" \
         " --versions 3.0,3.1,... のように明示してください。"
    exit 1
  end
end

bitclust_path = ENV['BITCLUST_PATH'] || File.expand_path('../../bitclust', __dir__)
$LOAD_PATH.unshift(File.join(bitclust_path, 'lib'))

require 'bitclust/compat'
require 'bitclust/preprocessor'

base_root = File.expand_path(base_dir)
work_root = File.expand_path(work_dir)

base_files = Dir.glob(File.join(base_root, 'manual', '**', '*.md')).sort
work_files = Dir.glob(File.join(work_root, 'manual', '**', '*.md')).sort
base_rel = base_files.map { |f| f.sub("#{base_root}/", '') }
work_rel = work_files.map { |f| f.sub("#{work_root}/", '') }

only_in_base = base_rel - work_rel
only_in_work = work_rel - base_rel

mismatches = []
exceptions = []

rel_files = (base_rel & work_rel).sort
rel_files.each do |rel|
  base_path = File.join(base_root, rel)
  work_path = File.join(work_root, rel)

  versions.each do |v|
    params = { 'version' => v }
    base_out = begin
      BitClust::Preprocessor.read(base_path, params)
    rescue StandardError => e
      exceptions << "#{rel} [base] version=#{v}: #{e.class}: #{e.message}"
      nil
    end
    work_out = begin
      BitClust::Preprocessor.read(work_path, params)
    rescue StandardError => e
      exceptions << "#{rel} [work] version=#{v}: #{e.class}: #{e.message}"
      nil
    end
    next if base_out.nil? || work_out.nil?

    if base_out != work_out
      mismatches << "#{rel} version=#{v}: MISMATCH (base #{base_out.bytesize}B, work #{work_out.bytesize}B)"
    end
  end
end

puts "bitclust_path=#{bitclust_path}"
puts "base_root=#{base_root}"
puts "work_root=#{work_root}"
puts "versions=#{versions.join(',')}"
puts "files compared: #{rel_files.size} x versions: #{versions.size} = #{rel_files.size * versions.size} checks"
puts "only_in_base: #{only_in_base.size}"
only_in_base.each { |f| puts "  #{f}" }
puts "only_in_work: #{only_in_work.size}"
only_in_work.each { |f| puts "  #{f}" }
puts "exceptions: #{exceptions.size}"
exceptions.each { |e| puts "  #{e}" }
puts "mismatches: #{mismatches.size}"
mismatches.each { |m| puts "  #{m}" }

if only_in_base.empty? && only_in_work.empty? && exceptions.empty? && mismatches.empty?
  puts "RESULT: ALL MATCH"
  exit 0
else
  puts "RESULT: FAILED"
  exit 1
end

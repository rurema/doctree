# coding: utf-8
OLD_VERSIONS = %w[
  1.8.7 1.9.3
  2.0.0 2.1.0 2.2.0 2.3.0 2.4.0 2.5.0 2.6.0 2.7.0
]
SUPPORTED_VERSIONS = %w[3.0 3.1 3.2 3.3 3.4 4.0]
UNRELEASED_VERSIONS = %w[4.1]
# メンテナンスが継続している最古のバージョン。これより古い版の静的 HTML には
# bitclust statichtml --eol-warning で警告バナーを表示する。
# EOL 状況は https://www.ruby-lang.org/ja/downloads/branches/ を参照して更新する
MINIMUM_SUPPORTED_RUBY_VERSION = Gem::Version.new("3.3")
# ruby.wasm の npm パッケージ (@ruby/X.Y-wasm-wasi) が存在するバージョンの
# 静的 HTML にはサンプルコードの RUN ボタンを有効にする
# (bitclust statichtml --run-ruby-wasm)。https://github.com/ruby/ruby.wasm 参照
# npm 上の安定版は「<パッケージ版>-<ruby.wasm版>」形式（latest dist-tag の値）
RUBY_WASM_NPM_VERSION = "2.9.3-2.9.4"
RUBY_WASM_VERSIONS = %w[3.2 3.3 3.4 4.0]
def ruby_wasm_url(version)
  if RUBY_WASM_VERSIONS.include?(version)
    return "https://cdn.jsdelivr.net/npm/@ruby/#{version}-wasm-wasi@#{RUBY_WASM_NPM_VERSION}/dist/ruby+stdlib.wasm"
  end
  return ruby_head_wasm_url(version) if UNRELEASED_VERSIONS.include?(version)
  nil
end

# 未リリース版（/ja/master/ の実体）には head 用スナップショット
# (@ruby/head-wasm-wasi) を使う。ただしスナップショットの元になる ruby/ruby
# master のバージョンが version と一致するときだけ（リリース移行期に master
# が次の開発版に進んでいる場合は自動で無効になる）。URL はその日の next
# スナップショットに完全固定する。判定・取得に失敗してもビルドは止めず、
# RUN ボタンなしにフォールバックする。
def ruby_head_wasm_url(version)
  require "net/http"
  require "json"
  version_h = Net::HTTP.get(URI("https://raw.githubusercontent.com/ruby/ruby/master/include/ruby/version.h"))
  major = version_h[/RUBY_API_VERSION_MAJOR (\d+)/, 1]
  minor = version_h[/RUBY_API_VERSION_MINOR (\d+)/, 1]
  return nil unless version == "#{major}.#{minor}"
  tags = JSON.parse(Net::HTTP.get(URI("https://data.jsdelivr.com/v1/packages/npm/@ruby/head-wasm-wasi")))["tags"]
  snapshot = tags["next"] or return nil
  "https://cdn.jsdelivr.net/npm/@ruby/head-wasm-wasi@#{snapshot}/dist/ruby+stdlib.wasm"
rescue StandardError => e
  warn "ruby_head_wasm_url: #{e.class}: #{e.message} (disabling the RUN button for #{version})"
  nil
end
ALL_VERSIONS = [*OLD_VERSIONS, *SUPPORTED_VERSIONS, *UNRELEASED_VERSIONS]
CI_VERSIONS = [*SUPPORTED_VERSIONS, *UNRELEASED_VERSIONS]
HTML_DIRECTORY_BASE = ENV.fetch("HTML_DIRECTORY_BASE", "/tmp/html/")

def system(*commands)
  puts "Running #{commands.join(' ')}..."
  super(*commands)
end

# Gemfile は BITCLUST_PATH（既定値 ../bitclust）にディレクトリが存在すると
# そちらの bitclust を優先する。古いチェックアウトが残っていると
# `cannot load such file -- drb` や `invalid option: --markdowntree` のような
# 分かりにくいエラーで失敗するので、ビルド前に検査して案内を出す
# (https://github.com/rurema/bitclust/issues/230)
REQUIRED_BITCLUST_VERSION = Gem::Version.new("1.5.0")
def check_bitclust_version!
  begin
    require "bitclust/version"
  rescue LoadError
    abort "bitclust を読み込めませんでした。bundle install を実行してください。"
  end
  version = Gem::Version.new(BitClust::VERSION)
  return if version >= REQUIRED_BITCLUST_VERSION
  location = $LOADED_FEATURES.grep(%r{bitclust/version\.rb\z}).first
  abort <<~MESSAGE
    古い bitclust (#{version}) が使われています（#{REQUIRED_BITCLUST_VERSION} 以上が必要です）。
    使用中の bitclust: #{location}
    doctree の Gemfile は、環境変数 BITCLUST_PATH（既定値 ../bitclust）の
    ディレクトリが存在するとそちらの bitclust を優先します。過去に clone した
    古い bitclust が残っている場合は、次のいずれかで解決してから
    bundle install をやり直してください:
      * ../bitclust を最新にする (cd ../bitclust && git pull)
      * ../bitclust を使わないなら、ディレクトリを削除・改名するか、
        BITCLUST_PATH=/nonexistent のように存在しないパスを指定する
  MESSAGE
end

# ソースは manual/ の Markdown ツリー（manual/doc は manual/api から自動で取り込まれる）。
# 旧 refm/ は移行ウィンドウ中の凍結ソース。旧経路でビルドしたい場合は
# BITCLUST_SOURCE=refm を指定する。
def generate_database(version)
  check_bitclust_version!
  puts "generate database of #{version}"
  db = "/tmp/db-#{version}"
  succeeded = system("bundle", "exec",
                     "bitclust", "--database=#{db}",
                     "init", "version=#{version}", "encoding=UTF-8")
  raise "Failed to initialize BitClust database" unless succeeded
  if ENV["BITCLUST_SOURCE"] == "refm"
    succeeded = system("bundle", "exec", "bitclust", "--database=#{db}",
                       "update", "--stdlibtree=refm/api/src")
    raise "Failed to update BitClust database" unless succeeded
    capi_files = Dir.glob("refm/capi/src/*")
    succeeded = system("bundle", "exec", "bitclust", "--database=#{db}", "--capi",
                       "update", *capi_files)
    raise "Failed to update BitClust C API database" unless succeeded
  else
    succeeded = system("bundle", "exec", "bitclust", "--database=#{db}",
                       "update", "--markdowntree=manual/api")
    raise "Failed to update BitClust database" unless succeeded
    succeeded = system("bundle", "exec", "bitclust", "--database=#{db}", "--capi",
                       "update", "--markdowntree=manual/capi")
    raise "Failed to update BitClust C API database" unless succeeded
  end
end

def generate_statichtml(version)
  check_bitclust_version!
  db = "/tmp/db-#{version}"
  generate_database(version) unless File.exist?(db)
  puts "generate static html of #{version}"
  bitclust_gem_path = File.expand_path('../..', `gem which bitclust`)
  raise "bitclust gem not found" unless $?.success?
  # If you want to know the command line of https://docs.ruby-lang.org/ja/latest/ ,
  # see https://github.com/ruby/docs.ruby-lang.org/blob/master/system/bc-static-all
  # instead of here.
  commands = [
    "bundle", "exec",
    "bitclust", "--database=#{db}",
    "statichtml", "--outputdir=#{File.join(HTML_DIRECTORY_BASE, version)}",
    "--templatedir=#{bitclust_gem_path}/data/bitclust/template.offline",
    "--catalog=#{bitclust_gem_path}/data/bitclust/catalog",
    "--fs-casesensitive",
    "--canonical-base-url=https://docs.ruby-lang.org/ja/latest/",
  ]
  commands << "--eol-warning" if MINIMUM_SUPPORTED_RUBY_VERSION > version
  if (wasm_url = ruby_wasm_url(version))
    commands << "--run-ruby-wasm=#{wasm_url}"
  end
  commands << "--edit-base-url=https://github.com/rurema/doctree/edit/master/" unless ENV['CI']
  # To suppress progress bar
  # because it exceeded Travis CI max log length
  commands << "--quiet" if ENV['CI']
  commands << "--no-stop-on-syntax-error" if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.7')
  succeeded = system(*commands)
  raise "Failed to generate static html" unless succeeded
end

task :default => [:check_filename_case_conflicts, :check_indent_in_samplecode, :check_single_space_indent, :generate, :check_format]

namespace :generate do
  ALL_VERSIONS.each do |version|
    desc "Generate document database of #{version}"
    task version do
      generate_database(version)
    end
  end

  desc "Generate document database of all versions"
  multitask :all => ALL_VERSIONS

  desc "Generate document database for old versions"
  multitask :old => OLD_VERSIONS

  desc "Generate document database for supported versions"
  multitask :supported => SUPPORTED_VERSIONS

  desc "Generate document database for unreleased versions"
  multitask :unreleased => UNRELEASED_VERSIONS
end

desc "Generate document database"
multitask :generate => CI_VERSIONS.map {|version| "generate:#{version}" }

namespace :statichtml do
  ALL_VERSIONS.each do |version|
    desc "Generate static html of #{version}"
    task version do
      generate_statichtml(version)
    end
  end

  desc "Generate static html of all versions"
  multitask :all => ALL_VERSIONS

  desc "Generate static html for old versions"
  multitask :old => OLD_VERSIONS

  desc "Generate static html for supported versions"
  multitask :supported => SUPPORTED_VERSIONS

  desc "Generate static html for unreleased versions"
  multitask :unreleased => UNRELEASED_VERSIONS
end

desc "Generate static html"
multitask :statichtml => CI_VERSIONS.map {|version| "statichtml:#{version}" }

desc "Create index"
task :create_index do
  links = []
  Dir.glob(File.join(HTML_DIRECTORY_BASE, '*.*/doc/index.html')).each do |path|
    path = path.delete_prefix(HTML_DIRECTORY_BASE)
    links.push %Q[<li><a href="#{path}">#{path}</a></li>]
  end
  IO.write(File.join(HTML_DIRECTORY_BASE, 'index.html'), <<-'HTML'+links.sort.reverse.join("\n")+<<-'HTML')
<!DOCTYPE html>
<html lang="ja-JP">
<head>
  <meta name="robots" content="noindex">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<ul>
  HTML
</ul>
</body>
</html>
  HTML
end

desc "Check documentation format"
task check_format: [:statichtml] do
  res = []
  Dir.glob(File.join(HTML_DIRECTORY_BASE, '**/*.html')).each do |path|
    html = File.read(path, encoding: "UTF-8")

    a = html.lines.grep(/\[UNKNOWN_META_INFO\]/)
    if !a.empty?
      res.push("Found invalid meta info: #{a.first.chomp} in #{path}")
    end

    a = html.lines.grep(/<span class="compileerror">/)
    if !a.empty?
      res.push("Found invalid format link: #{a.first.chomp} in #{path}")
    end
  end
  if res.size > 0
    raise res.sort.uniq.join("\n")
  end
end

desc 'Check file names that differ only in case'
task :check_filename_case_conflicts do
  # 大文字小文字のみが異なるファイル名は macOS/Windows の case-insensitive な
  # ファイルシステムでチェックアウト不能になる（manual/api/rdoc/rdoc.lib.md の
  # ような .lib 回避と front matter の name: については bitclust の
  # doc/markdown-samples/MARKUP_SPEC.md §1.3 を参照）
  errors = Dir.glob('{manual,refm}/**/*')
              .group_by(&:downcase).values
              .select { |paths| paths.size > 1 }
              .map { |paths| "大文字小文字のみが異なるファイル名があります: #{paths.sort.join(' / ')}" }

  unless errors.empty?
    puts errors
    fail
  end
end

desc 'Check unnecessary indentation in samplecode'
task :check_indent_in_samplecode do
  errors = []
  `grep -rlF '\#@samplecode' manual refm`.lines(chomp: true).each do |path|
    lines = File.read(path).lines(chomp: true)
    lines.each.with_index(1) do |line, lineno|
      next unless line.start_with?('#@samplecode')
      next unless lines[lineno].start_with?(' ')

      errors << "#{path}:#{lineno}: \#@samplecode の中に不要なインデントがあります。削除してください"
    end
  end

  unless errors.empty?
    puts errors
    fail
  end
end

# #3246 で dlist（`- **term**:` の説明文）の継続行インデントを CommonMark
# 準拠の2スペースに統一したが、同一段落内で折り返された物理行（直前行が
# 2スペースインデントの本文で、その次の行）だけ半角スペース1個のまま
# 取り残される回帰が #3255 で見つかった。直前行が2スペースの本文なのに
# 当該行が1スペースなのは、ほぼ確実に同じ段落の折り返しが2スペースに
# 揃え損ねたものなので、その形だけを対象に検出する（`- item` のような
# リストマーカー行や、`- **term**:` 直後1行だけの説明のような、1スペース
# のままでも正しく描画される既存の書き方は対象外）。
desc 'Check dlist continuation lines use 2-space indent (not 1)'
task :check_single_space_indent do
  fence_re = /\A[ \t]*(`{3,}|~{3,})/
  errors = []
  Dir.glob('manual/**/*.md').sort.each do |path|
    lines = File.read(path).lines(chomp: true)
    in_fence = false
    fence_char = nil
    fence_len = 0
    prev_line = nil
    prev_was_fence = false
    lines.each.with_index(1) do |line, lineno|
      if (m = fence_re.match(line))
        char, len = m[1][0], m[1].length
        if !in_fence
          in_fence = true
          fence_char = char
          fence_len = len
        elsif char == fence_char && len >= fence_len
          in_fence = false
        end
        prev_line = line
        prev_was_fence = true
        next
      end
      next if in_fence

      if line =~ /\A [^ ]/ && !prev_was_fence && prev_line && prev_line =~ /\A {2}[^ ]/
        errors << "#{path}:#{lineno}: dlist 継続行のインデントが半角スペース1個です。直前行と同じ2個にしてください"
      end
      prev_line = line
      prev_was_fence = false
    end
  end

  unless errors.empty?
    puts errors
    fail
  end
end

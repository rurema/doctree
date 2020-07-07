OLD_VERSIONS = %w[1.8.7 1.9.3 2.0.0 2.1.0 2.2.0 2.3.0 2.4.0]
SUPPORTED_VERSIONS = %w[2.5.0 2.6.0 2.7.0]
UNRELEASED_VERSIONS = %w[2.8.0]
ALL_VERSIONS = [*OLD_VERSIONS, *SUPPORTED_VERSIONS, *UNRELEASED_VERSIONS]
HTML_DIRECTORY_BASE = ENV.fetch("HTML_DIRECTORY_BASE", "/tmp/html/")

def system(*commands)
  puts "Running #{commands.join(' ')}..."
  super(*commands)
end

def generate_database(version)
  puts "generate database of #{version}"
  db = "/tmp/db-#{version}"
  succeeded = system("bundle", "exec",
                     "bitclust", "--database=#{db}",
                     "init", "version=#{version}", "encoding=UTF-8")
  raise "Failed to initialize BitClust database" unless succeeded
  succeeded = system("bundle", "exec", "bitclust", "--database=#{db}",
                     "update", "--stdlibtree=refm/api/src")
  raise "Failed to update BitClust database" unless succeeded
  capi_files = Dir.glob("refm/capi/src/*")
  succeeded = system("bundle", "exec", "bitclust", "--database=#{db}", "--capi",
                     "update", *capi_files)
  raise "Failed to update BitClust C API database" unless succeeded
end

def generate_statichtml(version)
  db = "/tmp/db-#{version}"
  generate_database(version) unless File.exist?(db)
  puts "generate static html of #{version}"
  bitclust_gem_path = File.expand_path('../..', `bundle exec gem which bitclust`)
  raise "bitclust gem not found" unless $?.success?
  commands = [
    "bundle", "exec",
    "bitclust", "--database=#{db}",
    "statichtml", "--outputdir=#{File.join(HTML_DIRECTORY_BASE, version)}",
    "--templatedir=#{bitclust_gem_path}/data/bitclust/template.offline",
    "--catalog=#{bitclust_gem_path}/data/bitclust/catalog",
    "--fs-casesensitive",
    "--canonical-base-url=https://docs.ruby-lang.org/ja/latest/",
  ]
  # To suppress progress bar
  # because it exceeded Travis CI max log length
  commands << "--quiet" if ENV['CI']
  commands << "--no-stop-on-syntax-error" if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.7')
  succeeded = system(*commands)
  raise "Failed to generate static html" unless succeeded
end

task :default => [:check_indent_in_samplecode, :generate, :check_format]

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
multitask :generate => SUPPORTED_VERSIONS.map {|version| "generate:#{version}" }

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
multitask :statichtml => SUPPORTED_VERSIONS.map {|version| "statichtml:#{version}" }

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

desc 'Check unnecessary indentation in samplecode'
task :check_indent_in_samplecode do
  errors = []
  `git grep -F --name-only '\#@samplecode'`.lines(chomp: true).each do |path|
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

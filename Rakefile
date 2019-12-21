OLD_VERSIONS = %w[1.8.7 1.9.3 2.0.0 2.1.0 2.2.0 2.3.0]
SUPPORTED_VERSIONS = %w[2.4.0 2.5.0 2.6.0]
UNRELEASED_VERSIONS = %w[2.7.0]
ALL_VERSIONS = [*OLD_VERSIONS, *SUPPORTED_VERSIONS, *UNRELEASED_VERSIONS]
HTML_DIRECTORY_BASE = "/tmp/html/"

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
    "--canonical-base-url=http://localhost:9292/latest/"
  ]
  # To suppress progress bar
  # because it exceeded Travis CI max log length
  commands << "--quiet" if ENV['CI']
  succeeded = system(*commands)
  raise "Failed to generate static html" unless succeeded
  File.unlink("/tmp/html/latest") rescue nil
  File.symlink(version, "/tmp/html/latest")
end

task :default => [:generate, :check_format]

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
multitask :generate => [*OLD_VERSIONS, *SUPPORTED_VERSIONS].map {|version| "generate:#{version}" }

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
multitask :statichtml => [*OLD_VERSIONS, *SUPPORTED_VERSIONS].map {|version| "statichtml:#{version}" }

desc "Check documentation format"
task check_format: [:statichtml] do
  res = []
  Dir.glob(File.join(HTML_DIRECTORY_BASE, '**/*.html')).each do |path|
    html = File.read(path)

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

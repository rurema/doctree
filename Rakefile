
VERSIONS = ["1.8.7", "1.9.3", "2.0.0", "2.1.0", "2.2.0", "2.3.0", "2.4.0"]

def generate_database(version)
  puts version
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

task :default => [:generate, :check_prev_commit_format]

desc "Generate document database"
task :generate do
  VERSIONS.each do |version|
    generate_database(version)
  end
end

desc "Check previous commit format"
task :check_prev_commit_format do
  change_files = `git diff HEAD^ HEAD --name-only`.split
  res = []
  VERSIONS.each do |v|
    change_files.each do |path|
      if %r!\Arefm/api/!.match(path)
        File.read(path).scan(/^=[^=]\w+\s*(\S+)\s*(?:<\s*(\S+))?/).each do |k, pk|
          html = `bundle exec bitclust htmlfile --ruby=#{v} --target=#{k} #{path}`

          a = html.lines.grep(/<span class="compileerror">/)
          if !a.empty?
            res.push("Found invalid format link: #{a.first.chomp} in #{v}:#{path}")
          end

          a = html.lines.grep(/\[UNKNOWN_META_INFO\]/)
          if !a.empty?
            res.push("Found invalid meta info: #{a.first.chomp} in #{v}:#{path}")
          end
        end
      end
    end
  end
  if res.size > 0
    raise res.join("\n")
  end
end

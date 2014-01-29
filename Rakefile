
VERSIONS = ["1.8.7", "1.9.3", "2.0.0", "2.1.0"]

def generate_database(version)
  puts version
  db = "/tmp/db-#{version}"
  system("bundle", "exec",
         "bitclust", "--database=#{db}",
         "init", "version=#{version}", "encoding=UTF-8")
  system("bundle", "exec", "bitclust", "--database=#{db}",
         "update", "--stdlibtree=refm/api/src")
  capi_files = Dir.glob("refm/capi/src/*")
  system("bundle", "exec", "bitclust", "--database=#{db}", "--capi",
         "update", *capi_files)
end

task :default => [:generate]

desc "Generate document database"
task :generate do
  VERSIONS.each do |version|
    generate_database(version)
  end
end

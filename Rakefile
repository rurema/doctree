
VERSIONS = ["1.8.7", "1.9.3", "2.0.0", "2.1.0", "2.2.0", "2.3.0", "2.4.0"]

def generate_database(version)
  puts version
  db = "/tmp/db-#{version}"
  status = system("bundle", "exec",
                  "bitclust", "--database=#{db}",
                  "init", "version=#{version}", "encoding=UTF-8")
  raise "Failed to initialize BitClust database" unless status
  status = system("bundle", "exec", "bitclust", "--database=#{db}",
                  "update", "--stdlibtree=refm/api/src")
  raise "Failed to update BitClust database" unless status
  capi_files = Dir.glob("refm/capi/src/*")
  status = system("bundle", "exec", "bitclust", "--database=#{db}", "--capi",
                  "update", *capi_files)
  raise "Failed to update BitClust C API database" unless status
end

task :default => [:generate]

desc "Generate document database"
task :generate do
  VERSIONS.each do |version|
    generate_database(version)
  end
end

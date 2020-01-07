source "https://rubygems.org"

gem "rake"

bitclust_gems = proc do
  gem "bitclust-core"
  gem "bitclust-dev"
  gem "refe2"
end
bitclust_path = ENV.fetch('BITCLUST_PATH', '../bitclust')
if File.directory?(bitclust_path)
  path bitclust_path, &bitclust_gems
else
  git 'https://github.com/rurema/bitclust.git', &bitclust_gems
end

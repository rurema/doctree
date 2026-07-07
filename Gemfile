source "https://rubygems.org"

gem "rake"
gem "rackup"

bitclust_gems = proc do
  gem "bitclust-core"
  gem "bitclust-dev"
  gem "refe2"
end
bitclust_path = ENV.fetch('BITCLUST_PATH', '../bitclust')
if File.directory?(bitclust_path)
  path bitclust_path, &bitclust_gems
else
  # TODO: 一時ピン。--markdowntree は rurema/bitclust#189 のブランチにのみ
  # 存在するため、CI 用にフォークを指す。#189 マージ後に
  # rurema/bitclust.git へ戻すこと
  git 'https://github.com/znz/bitclust.git',
      branch: 'feature/markdown-conversion', &bitclust_gems
end

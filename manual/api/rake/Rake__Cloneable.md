---
library: rake
---
# module Rake::Cloneable

簡単に複製したオブジェクトを作成できるようにするための
Mixin モジュールです。

## Public Instance Methods

### def clone -> object

自身を複製します。

自身がフリーズされていれば返されるオブジェクトもフリーズされています。

```ruby
# Rakefile での記載例とする

task default: :test_rake_app
task :test_rake_app do
  file_list = FileList['a.c', 'b.c']
  clone = file_list.clone
  p clone               # => ["a.c", "b.c"]
  clone.exclude("a.c")
  p clone == file_list  # => false
end
```

### def dup -> object

自身と同じクラスのオブジェクトを作成後、自身のインスタンス変数を
全て新たに作成したオブジェクトにコピーします。

```ruby
# Rakefile での記載例とする

task default: :test_rake_app
task :test_rake_app do
  file_list = FileList['a.c', 'b.c']
  file_list.freeze
  dup = file_list.dup
  clone = file_list.clone
  p dup.exclude("a.c") # => ["b.c"]
  p clone.exclude("a.c") # => can't modify frozen Rake::FileList
end
```

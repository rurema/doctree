# doctree manual/api ライブラリ抽出メモ

- type: library 総数: 358

## since 付き (35 件)

- error_highlight: since=3.1
- irb/debug: since=3.3
- irb/default_commands: since=3.4
- irb/ext/eval_history: since=3.3
- irb/history: since=3.3
- irb/pager: since=3.3
- irb/startup_message: since=4.1
- irb/statement: since=3.3
- minitest/autorun: since=1.9.1
- minitest/mock: since=1.9.1
- minitest/spec: since=1.9.1
- minitest/unit: since=1.9.1
- prism: since=3.3
- rdoc/code_object/alias: since=3.4
- rdoc/code_object/anon_class: since=3.4
- rdoc/code_object/any_method: since=3.4
- rdoc/code_object/attr: since=3.4
- rdoc/code_object/class_module: since=3.4
- rdoc/code_object/constant: since=3.4
- rdoc/code_object/context: since=3.4
- rdoc/code_object/ghost_method: since=3.4
- rdoc/code_object/include: since=3.4
- rdoc/code_object/meta_method: since=3.4
- rdoc/code_object/normal_class: since=3.4
- rdoc/code_object/normal_module: since=3.4
- rdoc/code_object/require: since=3.4
- rdoc/code_object/single_class: since=3.4
- rdoc/code_object/top_level: since=3.4
- reline: since=2.7
- repl_type_completor: since=3.4
- ripper: since=1.9.0
- ripper/filter: since=1.9.0
- ripper/lexer: since=1.9.0
- ripper/sexp: since=1.9.0
- ubygems: since=1.9.1

## until 付き (66 件)

- cgi/cookie: until=4.0
- cgi/core: until=4.0
- cgi/html: until=4.0
- cgi/session: until=4.0
- cgi/session/pstore: until=4.0
- cmath: until=2.7.0
- dbm: until=3.1
- e2mmap: until=2.7.0
- fiber: until=3.1
- gdbm: until=3.1
- irb/cmd/chws: until=3.4
- irb/cmd/help: until=3.4
- irb/cmd/load: until=3.4
- irb/cmd/nop: until=4.0
- irb/cmd/pushws: until=3.4
- irb/cmd/subirb: until=3.4
- irb/ext/history: until=3.3
- irb/ext/math-mode: until=2.5.0
- irb/ext/save-history: until=3.3
- irb/extend-command: until=3.4
- irb/magic-file: until=3.3
- irb/ruby-token: until=2.7.0
- irb/slex: until=2.7.0
- irb/src_encoding: until=3.3
- mathn: until=2.5.0
- minitest/mock: until=4.0
- minitest/unit: until=4.0
- net/ftp: until=4.1
- net/pop: until=4.1
- profile: until=2.7.0
- profiler: until=2.7.0
- rdoc/alias: until=3.4
- rdoc/anon_class: until=3.4
- rdoc/any_method: until=3.4
- rdoc/attr: until=3.4
- rdoc/class_module: until=3.4
- rdoc/code_object/anon_class: until=4.1
- rdoc/code_object/ghost_method: until=4.1
- rdoc/code_object/meta_method: until=4.1
- rdoc/constant: until=3.4
- rdoc/context: until=3.4
- rdoc/ghost_method: until=3.4
- rdoc/include: until=3.4
- rdoc/meta_method: until=3.4
- rdoc/normal_class: until=3.4
- rdoc/normal_module: until=3.4
- rdoc/parser/ruby_tools: until=4.1
- rdoc/require: until=3.4
- rdoc/single_class: until=3.4
- rdoc/top_level: until=3.4
- rubygems/commands/query_command: until=4.0
- rubygems/indexer: until=3.3
- rubygems/server: until=3.1
- scanf: until=2.7.0
- set: until=3.2
- shell: until=2.7.0
- shell/builtin-command: until=2.7.0
- shell/command-processor: until=2.7.0
- shell/error: until=2.7.0
- shell/filter: until=2.7.0
- shell/process-controller: until=2.7.0
- shell/system-command: until=2.7.0
- sync: until=2.7.0
- thwait: until=2.7.0
- tracer: until=3.1
- ubygems: until=2.5.0

## トップレベル(サブパスなし) vs サブパス付き

- トップレベル(name に `/` を含まない): 101 件
- サブパス付き(name に `/` を含む): 257 件

## トップレベル第1階層ごとのサブライブラリ数

- bigdecimal/: 5 件
- cgi/: 6 件
- digest/: 5 件
- drb/: 8 件
- fiddle/: 2 件
- io/: 4 件
- irb/: 44 件
- json/: 13 件
- minitest/: 4 件
- net/: 7 件
- optparse/: 4 件
- racc/: 1 件
- rake/: 6 件
- rbconfig/: 1 件
- rdoc/: 61 件
- rexml/: 7 件
- rinda/: 2 件
- ripper/: 3 件
- rubygems/: 62 件
- shell/: 6 件
- syslog/: 1 件
- test/: 1 件
- win32/: 2 件
- yaml/: 2 件

## 特記事項

- non-library-files.tsv の総数(_builtin/ 除く): 639
- そのうちトップレベル(サブディレクトリでない)で type: library でないもの: 1 件
  - enumerator (type: (no front matter))

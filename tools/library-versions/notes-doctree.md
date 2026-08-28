# doctree manual/api ライブラリ抽出メモ

- type: library 総数: 365

## since 付き (18 件)

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
- reline: since=2.7
- ripper: since=1.9.0
- ripper/filter: since=1.9.0
- ripper/lexer: since=1.9.0
- ripper/sexp: since=1.9.0
- ubygems: since=1.9.1

## until 付き (35 件)

- cmath: until=2.7.0
- dbm: until=3.1
- e2mmap: until=2.7.0
- fiber: until=3.1
- gdbm: until=3.1
- irb/cmd/chws: until=3.4
- irb/cmd/help: until=3.4
- irb/cmd/load: until=3.4
- irb/cmd/pushws: until=3.4
- irb/cmd/subirb: until=3.4
- irb/ext/history: until=3.3
- irb/ext/math-mode: until=2.5.0
- irb/ext/save-history: until=3.4
- irb/extend-command: until=3.4
- irb/magic-file: until=3.3
- irb/ruby-token: until=2.7.0
- irb/slex: until=2.7.0
- irb/src_encoding: until=3.3
- mathn: until=2.5.0
- profile: until=2.7.0
- profiler: until=2.7.0
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

- トップレベル(name に `/` を含まない): 97 件
- サブパス付き(name に `/` を含む): 268 件

## トップレベル第1階層ごとのサブライブラリ数

- bigdecimal/: 5 件
- cgi/: 6 件
- digest/: 5 件
- drb/: 8 件
- fiddle/: 2 件
- io/: 4 件
- irb/: 44 件
- json/: 14 件
- minitest/: 4 件
- net/: 8 件
- optparse/: 4 件
- racc/: 1 件
- rake/: 10 件
- rbconfig/: 1 件
- rdoc/: 46 件
- rexml/: 7 件
- rinda/: 2 件
- ripper/: 3 件
- rubygems/: 82 件
- shell/: 6 件
- syslog/: 1 件
- test/: 1 件
- win32/: 2 件
- yaml/: 2 件

## 特記事項

- non-library-files.tsv の総数(_builtin/ 除く): 641
- そのうちトップレベル(サブディレクトリでない)で type: library でないもの: 1 件
  - enumerator (type: (no front matter))

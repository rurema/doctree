# ライブラリ単位突き合わせ(自動生成: crosscheck.rb)

## A. Ruby に存在するが rurema にページがない(版別)
- **3.0**: bundler(default-gem), rbs(bundled-gem), typeprof(bundled-gem)
- **3.1**: bundler(default-gem), rbs(bundled-gem), typeprof(bundled-gem)
- **3.2**: bundler(default-gem), error_highlight(default-gem), rbs(bundled-gem), set(default-gem), typeprof(bundled-gem)
- **3.3**: bundler(default-gem), error_highlight(default-gem), rbs(bundled-gem), set(default-gem), typeprof(bundled-gem)
- **3.4**: bundler(default-gem), error_highlight(default-gem), rbs(bundled-gem), repl_type_completor(bundled-gem), set(default-gem), typeprof(bundled-gem)
- **4.0**: bundler(default-gem), error_highlight(default-gem), rbs(bundled-gem), repl_type_completor(bundled-gem), typeprof(bundled-gem)
- **4.1**: bundler(default-gem), error_highlight(default-gem), rbs(bundled-gem), repl_type_completor(bundled-gem), typeprof(bundled-gem)

## B. rurema でその版に有効だが Ruby 側に存在しない(until 欠落・撤去漏れ候補)
- **3.0**: net/telnet, thread, xmlrpc
- **3.1**: net/telnet, thread, xmlrpc
- **3.2**: net/telnet, thread, xmlrpc
- **3.3**: net/telnet, thread, xmlrpc
- **3.4**: net/telnet, thread, xmlrpc
- **4.0**: net/telnet, thread, xmlrpc
- **4.1**: net/ftp, net/pop, net/telnet, thread, xmlrpc

## C. en rdoc との差(en 対象版のみ。en 掲載 = ソースツリー内 = lib/ext/default-gem)
### 3.2
- ja のみ(en に版別ページなし): debug, matrix, minitest, net/ftp, net/imap, net/pop, net/smtp, net/telnet, power_assert, prime, rake, rexml, rss, test/unit, thread, xmlrpc
- en のみ(rurema 未収載): bundler, error_highlight, set
### 3.3
- ja のみ(en に版別ページなし): debug, matrix, minitest, net/ftp, net/imap, net/pop, net/smtp, net/telnet, power_assert, prime, racc, rake, rexml, rss, test/unit, thread, xmlrpc
- en のみ(rurema 未収載): bundler, error_highlight, set
### 3.4
- ja のみ(en に版別ページなし): abbrev, base64, bigdecimal, csv, debug, drb, getoptlong, matrix, minitest, mutex_m, net/ftp, net/imap, net/pop, net/smtp, net/telnet, nkf, observer, power_assert, prime, racc, rake, resolv-replace, rexml, rinda, rss, syslog, test/unit, thread, xmlrpc
- en のみ(rurema 未収載): bundler, error_highlight, set
### 4.0
- ja のみ(en に版別ページなし): abbrev, base64, benchmark, bigdecimal, csv, debug, drb, fiddle, getoptlong, irb, logger, matrix, minitest, mutex_m, net/ftp, net/imap, net/pop, net/smtp, net/telnet, nkf, observer, ostruct, power_assert, prime, pstore, racc, rake, rdoc, readline, reline, resolv-replace, rexml, rinda, rss, syslog, test/unit, thread, win32ole, xmlrpc
- en のみ(rurema 未収載): bundler, error_highlight
### 4.1
- ja のみ(en に版別ページなし): abbrev, base64, benchmark, bigdecimal, csv, debug, drb, fiddle, getoptlong, irb, logger, matrix, minitest, mutex_m, net/ftp, net/imap, net/pop, net/smtp, net/telnet, nkf, observer, ostruct, power_assert, prime, pstore, racc, rake, rdoc, readline, reline, resolv-replace, rexml, rinda, rss, syslog, test/unit, thread, tsort, win32/registry, win32ole, xmlrpc
- en のみ(rurema 未収載): bundler, error_highlight

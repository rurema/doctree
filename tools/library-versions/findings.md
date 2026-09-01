# ライブラリ単位突き合わせ(自動生成: crosscheck.rb)

## A. Ruby に存在するが rurema にページがない(版別)
- **3.0**: (なし)
- **3.1**: (なし)
- **3.2**: set(default-gem)
- **3.3**: set(default-gem)
- **3.4**: set(default-gem)
- **4.0**: (なし)
- **4.1**: (なし)

## B. rurema でその版に有効だが Ruby 側に存在しない(until 欠落・撤去漏れ候補)
- **3.0**: thread
- **3.1**: thread
- **3.2**: thread
- **3.3**: thread
- **3.4**: thread
- **4.0**: thread
- **4.1**: thread

## C. en rdoc との差(en 対象版のみ。en 掲載 = ソースツリー内 = lib/ext/default-gem)
### 3.2
- ja のみ(en に版別ページなし): debug, matrix, minitest, net/ftp, net/imap, net/pop, net/smtp, power_assert, prime, rake, rbs, rexml, rss, test/unit, thread, typeprof
- en のみ(rurema 未収載): set
### 3.3
- ja のみ(en に版別ページなし): debug, matrix, minitest, net/ftp, net/imap, net/pop, net/smtp, power_assert, prime, racc, rake, rbs, rexml, rss, test/unit, thread, typeprof
- en のみ(rurema 未収載): set
### 3.4
- ja のみ(en に版別ページなし): abbrev, base64, bigdecimal, csv, debug, drb, getoptlong, matrix, minitest, mutex_m, net/ftp, net/imap, net/pop, net/smtp, nkf, observer, power_assert, prime, racc, rake, rbs, repl_type_completor, resolv-replace, rexml, rinda, rss, syslog, test/unit, thread, typeprof
- en のみ(rurema 未収載): set
### 4.0
- ja のみ(en に版別ページなし): abbrev, base64, benchmark, bigdecimal, csv, debug, drb, fiddle, getoptlong, irb, logger, matrix, minitest, mutex_m, net/ftp, net/imap, net/pop, net/smtp, nkf, observer, ostruct, power_assert, prime, pstore, racc, rake, rbs, rdoc, readline, reline, repl_type_completor, resolv-replace, rexml, rinda, rss, syslog, test/unit, thread, typeprof, win32ole
- en のみ(rurema 未収載): (なし)
### 4.1
- ja のみ(en に版別ページなし): abbrev, base64, benchmark, bigdecimal, csv, debug, drb, fiddle, getoptlong, irb, logger, matrix, minitest, mutex_m, net/imap, net/smtp, nkf, observer, ostruct, power_assert, prime, pstore, racc, rake, rbs, rdoc, readline, reline, repl_type_completor, resolv-replace, rexml, rinda, rss, syslog, test/unit, thread, tsort, typeprof, win32/registry, win32ole
- en のみ(rurema 未収載): (なし)

# tools/

doctree の原稿を扱う補助スクリプトを置くディレクトリです。

- `fold_version_branches.rb`: `manual/` の版分岐(`#%since`/`#%until`/`#%if`)を、サポート最小バージョンを境に畳み込む
- `verify_preprocessor_output.rb`: 畳み込みなどの書き換え前後で、プリプロセッサの出力が全バージョンでバイト一致することを検証する
- `vscode/rurema-markdown/`: `#%` 指令をハイライトする VS Code 拡張

実 Ruby との突き合わせで得た実測データとその再生成スクリプト(method-coverage・method-params・method-versions・library-versions)は、
2026 年 10 月に [rurema/doctree-measurements](https://github.com/rurema/doctree-measurements) へ移しました。
移す前のものは doctree の履歴(2026-10-24 の 5f0f77d5d まで)にあります。

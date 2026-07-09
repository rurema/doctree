# doctree のディレクトリ構造

```
manual/          リファレンスマニュアル本体（Markdown。編集はこちら）
  manual/api         クラスリファレンス（組み込み・標準添付ライブラリ）
  manual/capi        C API リファレンス
  manual/doc         Ruby言語仕様・NEWS などの文書
refm/            旧 RRD ソース（2026年7月に凍結。編集しない）
docs/            プロジェクト文書（この文書。旧 GitHub wiki を移設）
```

* 2026年7月の Markdown 移行で、リファレンスのソースは `refm/` から `manual/` に移りました。
  `refm/` は旧バージョン（Ruby 3.0 より前）向け情報の回収が終わり次第、削除される予定です。
* 旧構成（`refm/api/src`、`faq/` など）については git の履歴を参照してください。

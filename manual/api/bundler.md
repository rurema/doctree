---
type: library
category: Development
---
アプリケーションが依存する gem を Gemfile に記述し、その解決・インストール・ロードを一貫して行うためのライブラリです。

主なインターフェースは `bundle` コマンド(`bundle install`、`bundle exec` など)です。
Ruby コードからは主に次の API を利用します。

- `require "bundler/setup"`: Gemfile に従ってロードパスを設定します(`bundle exec` 相当の状態にします)
- `Bundler.setup`: 同じロードパス設定を明示的に行います(対象のグループも指定できます)
- `Bundler.require`: setup に加えて、Gemfile に書かれた gem をまとめて require します
- `Bundler.with_unbundled_env { ... }`: Bundler 由来の環境変数を取り除いた環境でブロックを実行します(Bundler 管理下のプロセスから別の Ruby プロセスを起動するときに使います)

このライブラリはdefault gemです。詳しい内容は下記のページを参照してください。

- 公式ドキュメント: <https://bundler.io/>
- rubygems.org: <https://rubygems.org/gems/bundler>
- プロジェクトページ: <https://github.com/rubygems/rubygems>
- リファレンス: <https://www.rubydoc.info/gems/bundler>

- **SEE** [lib:rubygems], [ref:d:glossary#default-gem]

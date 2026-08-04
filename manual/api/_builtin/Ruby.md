---
library: _builtin
since: "4.0"
---
# module Ruby

Ruby の実装間で可搬な情報を集めたモジュールです。
Ruby 4.0 で導入されました。

このモジュールで定義されている定数は、トップレベルで `RUBY_` を接頭辞に付けた定数（`RUBY_VERSION` など）と同じ値で参照できます。
たとえば `Ruby::VERSION` と [m:Object::RUBY_VERSION] は同じ文字列を返します。

また、このモジュールの下には、クラスやモジュールをプロセス内で隔離する実験的機能のためのクラス `Ruby::Box` も定義されています。

## Constants

### const VERSION -> String

Ruby のバージョンを表す文字列。

Ruby のバージョンは、major.minor.teeny という形式です。
トップレベル定数 [m:Object::RUBY_VERSION] と同じ値です。

### const RELEASE_DATE -> String

Ruby のリリース日を表す文字列。

トップレベル定数 [m:Object::RUBY_RELEASE_DATE] と同じ値です。

### const PLATFORM -> String

プラットフォームを表す文字列。

トップレベル定数 [m:Object::RUBY_PLATFORM] と同じ値です。

### const PATCHLEVEL -> 0

Ruby のパッチレベルを表す [c:Integer] オブジェクトです。

Ruby 4.0 以降はパッチレベルの増分をやめたため、リリース版では常に 0 になります（master などの開発版では -1 になります）。
トップレベル定数 [m:Object::RUBY_PATCHLEVEL] と同じ値です。

### const REVISION -> String

Ruby の GIT コミットハッシュを表す [c:String] オブジェクトです。

トップレベル定数 [m:Object::RUBY_REVISION] と同じ値です。

### const COPYRIGHT -> String

Ruby のコピーライトを表す文字列。

トップレベル定数 [m:Object::RUBY_COPYRIGHT] と同じ値です。

### const ENGINE -> String

Ruby 処理系実装の種類を表す文字列。

トップレベル定数 [m:Object::RUBY_ENGINE] と同じ値です。

### const ENGINE_VERSION -> String

Ruby 処理系実装のバージョンを表す文字列。

トップレベル定数 [m:Object::RUBY_ENGINE_VERSION] と同じ値です。

### const DESCRIPTION -> String

Ruby の詳細を表す文字列。

`ruby -v` で表示される内容が格納されています。
トップレベル定数 [m:Object::RUBY_DESCRIPTION] と同じ値です。

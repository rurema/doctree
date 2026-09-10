---
library: _builtin
---
# class RubyVM

Ruby の 内部情報へのアクセス手段を提供するクラスです。
デバッグ用、プロトタイピング用、研究用などのとても限定された用途向けです。
一般ユーザーは使うべきではありません。

## Singleton Methods

#%# :nodoc:
#%# --- SDR
#%#
#%# VMDEBUG を有効にしてコンパイルした時のみ有効
#%#
#%# :nodoc:
#%# --- NSDR
#%#
#%# VMDEBUG を有効にしてコンパイルした時のみ有効
#%#
#%# :nodoc:
#%# --- USAGE_ANALYSIS_INSN_STOP
#%#
#%# VM_COLLECT_USAGE_DETAILS を有効にしてコンパイルした時のみ有効
#%#
#%# :nodoc:
#%# --- USAGE_ANALYSIS_OPERAND_STOP
#%#
#%# VM_COLLECT_USAGE_DETAILS を有効にしてコンパイルした時のみ有効
#%#
#%# :nodoc:
#%# --- USAGE_ANALYSIS_REGISTER_STOP
#%#
#%# VM_COLLECT_USAGE_DETAILS を有効にしてコンパイルした時のみ有効

### def RubyVM.stat -> Hash
### def RubyVM.stat(hsh) -> Hash
### def RubyVM.stat(sym) -> Integer

VM 内部のキャッシュなどに関する統計情報を返します。

引数なしで呼び出すと、統計名のシンボルをキーとするハッシュを返します。
ハッシュを渡すとその内容が統計情報で上書きされ、そのハッシュを返します
(プローブ効果を避けるために使用します)。シンボルを渡すと、その統計名の値のみを返します。

- **param** `hsh` -- 結果を格納するハッシュを指定します。内容は上書きされます。
- **param** `sym` -- 取得したい統計名をシンボルで指定します。

- **raise** `ArgumentError` -- 未知の統計名をシンボルで指定した場合に発生します。

```ruby title="例"
p RubyVM.stat
# => {:constant_cache_invalidations=>2, :constant_cache_misses=>14,
#     :global_cvar_state=>27, :next_shape_id=>225, :shape_cache_size=>1024}
p RubyVM.stat(:next_shape_id)
# => 225
```

含まれる統計名と値は処理系の実装の詳細であり、バージョンによって変わります。この値に依存すべきではありません。

#%since 3.1
### def RubyVM.keep_script_lines -> bool
### def RubyVM.keep_script_lines=(bool)

読み込んだスクリプトのソースコードの行を記録するかどうかを取得、設定します。

有効にすると、以降にロードされたスクリプトのソースコードの行が記録され、
[m:RubyVM::InstructionSequence#script_lines] などから参照できるようになります。

このメソッドは Ruby 内部での利用、デバッグ、研究のための API です。それ以外の目的で使うべきではありません。将来のバージョンとの互換性も保証されません。

- **param** `bool` -- 記録を有効にするかどうかを true か false で指定します。

```ruby title="例"
p RubyVM.keep_script_lines # => false
RubyVM.keep_script_lines = true
p RubyVM.keep_script_lines # => true
RubyVM.keep_script_lines = false
```

#%end

## Constants

### const OPTS -> [String]

[c:RubyVM] のビルドオプションの一覧を返します。

### const INSTRUCTION_NAMES -> [String]

[c:RubyVM] の命令シーケンスの名前の一覧を返します。

- **SEE** [c:RubyVM::InstructionSequence]

#%# :nodoc: に関連する定数のため、コメントアウト。
#%# --- USAGE_ANALYSIS_INSN
#%# --- USAGE_ANALYSIS_REGS
#%# --- USAGE_ANALYSIS_INSN_BIGRAM

### const DEFAULT_PARAMS -> {Symbol => Integer}

[c:RubyVM] のデフォルトのパラメータを返します。

[注意] この値は CRuby 固有のものです。変更しても [c:RubyVM] の動作には影響しません。また、仕様は変更される場合があるため、この値に依存すべきではありません。

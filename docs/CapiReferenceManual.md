# C API リファレンス

<dl>
<dt>名前</dt>
<dd>C API リファレンス</dd>
<dt>URL</dt>
<dd><a href="https://docs.ruby-lang.org/ja/latest/function/index.html">https://docs.ruby-lang.org/ja/latest/function/index.html</a></dd>
<dt>ソース</dt>
<dd><code>manual/capi/*.md</code>（1ファイル = Ruby の1ソースファイル。例: <code>array.c.md</code>）</dd>
<dt>概要</dt>
<dd>
C API リファレンスは、拡張ライブラリや組み込み Ruby で用いる
C 言語の API (関数やマクロ) を記述したリファレンスです。
</dd>
</dl>

書式はクラスリファレンスとほぼ共通ですが、シグネチャの H3 に
`def` などのキーワードを付けません（C のシグネチャは型から始まるため）。

```markdown
### VALUE rb_ary_new()

空の Ruby の配列を作成し返します。
```

詳細は [MARKUP_SPEC.md](https://github.com/rurema/bitclust/blob/master/doc/markdown-samples/MARKUP_SPEC.md) の「C API リファレンス」の節を参照してください。

## 関連

* [ProjectTimeLine](archive/ProjectTimeLine.md)（歴史的経緯）
* [BitClust の使い方](https://github.com/rurema/bitclust/blob/master/doc/usage.md)

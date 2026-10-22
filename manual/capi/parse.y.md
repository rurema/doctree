### VALUE rb_backref_get(void)

現在の SCOPE の $~ の値を返します。

### void rb_backref_set(VALUE val)

現在の SCOPE の $~ に val を代入します。

### char *rb_id2name(ID id)

id に対応する文字列を返します。
返り値は開放できません。

### ID rb_id_attrset(ID id)

### ID rb_intern(const char *name)

任意の char* と一対一に対応する整数 ID を返す。

### int rb_is_class_id(ID id)

クラス変数名として有効な ID ならば真。

### int rb_is_const_id(ID id)

定数名として有効な ID ならば真。

### int rb_is_instance_id(ID id)

インスタンス変数名として有効な ID ならば真。

### int rb_is_local_id(ID id)

ローカル変数名として有効な ID ならば真。

### VALUE rb_lastline_get(void)

現在評価中の SCOPE の $_ の値を取得します。

### void rb_lastline_set(VALUE val)

現在評価中の SCOPE の $_ に val を代入します。

### VALUE rb_sym_all_symbols(void)

呼び出し時までに変換が行われたすべてのシンボルの配列を返す。

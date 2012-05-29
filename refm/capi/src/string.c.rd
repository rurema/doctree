--- VALUE rb_str_new(const char *ptr, long len)

ptr から len バイト分をコピーして
Ruby の文字列を作成し返します。

  rb_str_new(0,0)

では空文字列を生成して返します。

--- VALUE rb_str_new2(const char *ptr)

rb_str_new(ptr, strlen(ptr))

--- VALUE rb_str_new4(VALUE orig)

文字列 orig の変更不可能な複製を作成し返します。

--- VALUE rb_str_dup(VALUE str)

文字列 str の複製を作成し返します。

--- VALUE rb_str_substr(VALUE str, long beg, long len)
str[beg, len]

--- VALUE rb_str_cat(VALUE str, const char *ptr, long len)

文字列 str に、長さ len (NUL 含まず)の C の文字列
ptr を破壊的に連結します。

--- VALUE rb_str_cat2(VALUE str, const char *ptr)

文字列 str に C の文字列 ptr を破壊的に
連結します。ptr はヌル終端を仮定しています。

--- VALUE rb_str_concat(VALUE s1, VALUE s2)

equivalent to "s1.concat s2"

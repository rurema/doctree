#@# xpath_parser.rb と quickpath.rb でのみ使われているので
#@# 内部的な関数を保持するクラスであると思われる
= module REXML::Functions
内部用なのでユーザは使わないでください。

xpath のパースに使う関数を保持するモジュールです。

#@# == Class Methods
#@# 
#@# --- namespace_context=(x)
#@# #@todo
#@# 
#@# --- variables=(x)
#@# #@todo
#@# 
#@# --- namespace_context
#@# #@todo
#@# 
#@# --- variables
#@# #@todo
#@# 
#@# #@since 1.8.3
#@# --- context=(value)
#@# #@todo
#@# #@end
#@# 
#@# --- text
#@# #@todo
#@# 
#@# --- last
#@# #@todo
#@# 
#@# --- position
#@# #@todo
#@# 
#@# --- count(node_set)
#@# #@todo
#@# 
#@# --- id(object)
#@# #@todo
#@# 
#@# --- local_name(node_set = nil)
#@# #@todo
#@# 
#@# --- namespace_uri(node_set = nil)
#@# #@todo
#@# 
#@# --- name(node_set = nil)
#@# #@todo
#@# 
#@# --- get_namespace(node_set = nil)
#@# #@todo
#@# 
#@# --- string(object = nil)
#@# #@todo
#@# 
#@# --- concat(*objects)
#@# #@todo
#@# 
#@# --- starts_with(string, test)
#@# #@todo
#@# 
#@# --- contains(string, test)
#@# #@todo
#@# 
#@# --- substring_before(string, test)
#@# #@todo
#@# 
#@# --- substring_after(string, test)
#@# #@todo
#@# 
#@# --- substring(string, start, length = nil)
#@# #@todo
#@# 
#@# --- string_length(string)
#@# #@todo
#@# 
#@# --- normalize_space(string = nil)
#@# #@todo
#@# 
#@# --- translate(string, tr1, tr2)
#@# #@todo
#@# 
#@# --- boolean(object = nil)
#@# #@todo
#@# 
#@# --- not(object)
#@# #@todo
#@# 
#@# --- true
#@# #@todo
#@# 
#@# --- false
#@# #@todo
#@# 
#@# --- lang(language)
#@# #@todo
#@# 
#@# --- compare_language(lang1, lang2)
#@# #@todo
#@# 
#@# --- number(object = nil)
#@# #@todo
#@# 
#@# --- sum(nodes)
#@# #@todo
#@# 
#@# --- floor(number)
#@# #@todo
#@# 
#@# --- ceiling(number)
#@# #@todo
#@# 
#@# --- round(number)
#@# #@todo
#@# 
#@# #@since 1.8.3
#@# --- processing_instruction(node)
#@# #@todo
#@# #@end
#@# 
#@# --- method_missing(id)
#@# #@todo
#@# 
#@# #@if (version <= "1.8.2")
#@# --- index
#@# #@todo
#@# 
#@# --- index=(value)
#@# #@todo
#@# 
#@# --- node
#@# #@todo
#@# 
#@# --- node=(value)
#@# #@todo
#@# 
#@# --- size
#@# #@todo
#@# 
#@# --- size=(value)
#@# #@todo
#@# #@end
#@# 
#@# #@since 1.8.6
#@# --- string_value(o)
#@# #@todo
#@# #@end
#@# 

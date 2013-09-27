require time

ChangeLog ファイルを解析するためのサブライブラリです。

ChangeLog ファイルを解析して、[[c:RDoc::Markup::Document]] オブジェクト
に変換します。出力される HTML はサイドバーに日ごとに分けられます。

このサブライブラリは主に MRI の ChangeLog を解析するために使われますが、
GNU style の ChangeLog([[url:http://www.gnu.org/prep/standards/html_node/Style-of-Change-Logs.html]]
参照)であれば解析できます。

= class RDoc::Parser::ChangeLog < RDoc::Parser

include RDoc::Parser::Text

ChangeLog ファイルを解析するためのクラスです。

== Instance Methods

--- scan -> RDoc::TopLevel

ChangeLog ファイルを解析します。

@return [[c:RDoc::TopLevel]] オブジェクトを返します。

#@# 内部で使用するメソッドのため省略。
#@#
#@# --- continue_entry_body(entry_body, continuation)
#@#
#@# Attaches the +continuation+ of the previous line to the +entry_body+.
#@#
#@# Continued function listings are joined together as a single entry.
#@# Continued descriptions are joined to make a single paragraph.
#@#
#@# --- create_document(groups)
#@#
#@# Creates an RDoc::Markup::Document given the +groups+ of ChangeLog entries.
#@#
#@# --- create_entries(entries)
#@#
#@# Returns a list of ChangeLog entries an RDoc::Markup nodes for the given
#@# +entries+.
#@#
#@# --- create_items(items)
#@#
#@# Returns an RDoc::Markup::List containing the given +items+ in the
#@# ChangeLog
#@#
#@# --- group_entries(entries)
#@#
#@# Groups +entries+ by date.
#@#
#@# --- parse_entries
#@#
#@# Parses the entries in the ChangeLog.
#@#
#@# Returns an Array of each ChangeLog entry in order of parsing.
#@#
#@# A ChangeLog entry is an Array containing the ChangeLog title (date and
#@# committer) and an Array of ChangeLog items (file and function changed with
#@# description).
#@#
#@# An example result would be:
#@#
#@#    [ 'Tue Dec  4 08:33:46 2012  Eric Hodel  <drbrain@segment7.net>',
#@#      [ 'README.EXT:  Converted to RDoc format',
#@#        'README.EXT.ja:  ditto']]

---
type: library
include:
  - ERB::Util
require:
  - erb
  - fileutils
  - pathname
  - rdoc/generator/markup
---
HTML を生成するためのサブライブラリです。

# class RDoc::Generator::Darkfish

HTML を生成するためのクラスです。

## Instance Methods

#%# :not-new 指定のため new ではなく、initialize で定義。
### def initialize(store, options) -> RDoc::Generator::Darkfish

[c:RDoc::Generator::Darkfish] オブジェクトを初期化します。

- **param** `store` -- `RDoc::Store` オブジェクトを指定します。

- **param** `options` -- [c:RDoc::Options] オブジェクトを指定します。

### def generate -> ()

解析した情報を HTML ファイルや検索用のインデックスに出力します。

#%# --- asset_rel_path
#%# --- asset_rel_path=(val)
#%#
#%# The relative path to style sheets and javascript.  By default this is
#%# set the same as the rel_prefix.
#%#
#%# --- base_dir
#%#
#%# The path to generate files into, combined with <tt>--op</tt> from the
#%# options for a full path.
#%#
#%# --- classes
#%#
#%# Classes and modules to be used by this generator, not necessarily
#%# displayed.  See also #modsort
#%#
#%# --- dry_run
#%# --- dry_run=(val)
#%#
#%# No files will be written when dry_run is true.
#%#
#%# --- file_output
#%# --- file_output=(val)
#%#
#%# When false the generate methods return a String instead of writing to a
#%# file.  The default is true.
#%#
#%# --- files
#%#
#%# Files to be displayed by this generator
#%#
#%# --- json_index
#%#
#%# The JSON index generator for this Darkfish generator
#%#
#%# --- methods
#%#
#%# Methods to be displayed by this generator
#%#
#%# --- modsort
#%#
#%# Sorted list of classes and modules to be displayed by this generator
#%#
#%# --- store
#%#
#%# The RDoc::Store that is the source of the generated content
#%#
#%# --- outputdir
#%#
#%# The output directory
#%#
#%# --- debug_msg(*msg)
#%#
#%# Output progress information if debugging is enabled
#%#
#%# --- gen_sub_directories
#%#
#%# Create the directories the generated docs will live in if they don't
#%# already exist.
#%#
#%# --- write_style_sheet
#%#
#%# Copy over the stylesheet into the appropriate place in the output
#%# directory.
#%#
#%# --- copy_static
#%#
#%# Copies static files from the static_path into the output directory
#%#
#%# --- get_sorted_module_list(classes)
#%#
#%# Return a list of the documented modules sorted by salience first, then
#%# by name.
#%#
#%# --- generate_index
#%#
#%# Generate an index page which lists all the classes which are
#%# documented.
#%#
#%# --- generate_class(klass, template_file = nil)
#%#
#%# Generates a class file for +klass+
#%#
#%# --- generate_class_files
#%#
#%# Generate a documentation file for each class and module
#%#
#%# --- generate_file_files
#%#
#%# Generate a documentation file for each file
#%#
#%# --- generate_page(file)
#%#
#%# Generate a page file for +file+
#%#
#%# --- generate_servlet_not_found(path)
#%#
#%# Generates the 404 page for the RDoc servlet
#%#
#%# --- generate_servlet_root installed
#%#
#%# Generates the servlet root page for the RDoc servlet
#%#
#%# --- generate_table_of_contents
#%#
#%# Generate an index page which lists all the classes which are documented.
#%#
#%# --- setup
#%#
#%# Prepares for generation of output from the current directory
#%#
#%# --- get_svninfo(klass)
#%#
#%# Try to extract Subversion information out of the first constant whose
#%# value looks like a subversion Id tag. If no matching constant is found,
#%# and empty hash is returned.
#%#
#%# --- assemble_template(body_file)
#%#
#%# Creates a template from its components and the +body_file+.
#%#
#%# For backwards compatibility, if +body_file+ contains "<html" the body is
#%# used directly.
#%#
#%# --- render(file_name)
#%#
#%# Renders the ERb contained in +file_name+ relative to the template
#%# directory and returns the result based on the current context.
#%#
#%# --- render_template(template_file, out_file = nil)
#%#
#%# Load and render the erb template in the given +template_file+ and write
#%# it out to +out_file+.
#%#
#%# Both +template_file+ and +out_file+ should be Pathname-like objects.
#%#
#%# An io will be yielded which must be captured by binding in the caller.
#%#
#%# --- template_result(template, context, template_file)
#%#
#%# Creates the result for +template+ with +context+.  If an error is raised a
#%# Pathname +template_file+ will indicate the file where the error occurred.
#%#
#%# --- template_for(file, page = true, klass = ERB)
#%#
#%# Retrieves a cache template for +file+, if present, or fills the cache.

#%until 4.0
### def class_dir -> nil
### def file_dir -> nil

常に nil を返します。

生成するクラス・ファイルの HTML を出力ディレクトリのどこに置くか(出力ディレクトリからの相対パス)を返すためのフックです。
サブクラスでオーバーライドして使用します。

#%end

#%until 4.0
### def time_delta_string(seconds) -> String

seconds で指定した秒数を、人が読みやすい形式の文字列にして返します。

- **param** `seconds` -- 秒数を数値で指定します。

- **return** -- "less than a minute"、"3 minutes"、"about one hour"、"2 days"、
           "3 weeks" のように、秒数のおおまかさに応じた形式の文字列を返します。

#%end

## Constants

### const GENERATOR_DIR -> String

このファイルの親ディレクトリへのパスを表す文字列です。

テンプレートなどのリソースを検索するのに内部で使用します。

### const VERSION -> '3'

darkfish のバージョンです。

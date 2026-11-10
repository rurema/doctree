require "test/unit"
require "tmpdir"
require "fileutils"
require "stringio"
require_relative "../lib/check_params"

class TestCheckParamsSplitParams < Test::Unit::TestCase
  def test_simple
    assert_equal(["a", "b"], CheckParams.split_params("a, b"))
  end

  def test_nested_brackets
    assert_equal(["a = [1, 2]", "b = {x: 1, y: 2}", "c = f(1, 2)"],
                 CheckParams.split_params("a = [1, 2], b = {x: 1, y: 2}, c = f(1, 2)"))
  end

  def test_quotes
    assert_equal(['a = ","', "b = ','", 'c = "\\",\\""'],
                 CheckParams.split_params('a = ",", b = \',\', c = "\\",\\""'))
  end

  def test_global_comma
    assert_equal(["sep = $,", "x"], CheckParams.split_params("sep = $,, x"))
    assert_equal(["sep = $,"], CheckParams.split_params("sep = $,"))
  end

  def test_empty
    assert_equal([], CheckParams.split_params(""))
  end
end

class TestCheckParamsSignatureNames < Test::Unit::TestCase
  def names(str)
    CheckParams.signature_names(str)
  end

  def test_nil_and_empty
    assert_equal([], names(nil))
    assert_equal([], names(""))
  end

  def test_required_and_optional
    assert_equal(["a", "b", "c?"], names("a, b = 1, c? = nil"))
  end

  def test_rest
    assert_equal(["args", "rest"], names("*args, *rest = []"))
    assert_equal([], names("*"))
  end

  def test_dotted_rest
    assert_equal(["arg"], names("arg..."))
  end

  def test_bracket
    assert_equal(["a", "b", "c"], names("[a, *b], c"))
  end

  def test_keywords
    assert_equal(["req", "opt", "opts"], names("req:, opt: true, **opts"))
    assert_equal([], names("**"))
  end

  def test_block
    assert_equal(["block"], names("&block"))
    assert_equal([], names("&"))
  end

  def test_literals_and_specials
    assert_equal([], names('nil, true, false, 1, -2.5, "s", \'t\', ..., self'))
  end

  def test_global_default
    assert_equal(["sep"], names("sep = $,"))
  end

  def test_unknown_item
    assert_equal(["a"], names("a, 1 + 2"))
  end

  def test_unique
    assert_equal(["a"], names("a, [a]"))
  end
end

class TestCheckParamsNormalize < Test::Unit::TestCase
  def test_strip_marks
    assert_equal("a", CheckParams.normalize_param_name("**a"))
    assert_equal("a", CheckParams.normalize_param_name("*a"))
    assert_equal("a", CheckParams.normalize_param_name("&a"))
    assert_equal("a", CheckParams.normalize_param_name("a:"))
    assert_equal("a", CheckParams.normalize_param_name(" a "))
  end

  def test_ignored
    assert_nil(CheckParams.normalize_param_name(""))
    assert_nil(CheckParams.normalize_param_name("*"))
    assert_nil(CheckParams.normalize_param_name("self"))
    assert_nil(CheckParams.normalize_param_name("..."))
  end
end

class TestCheckParamsExtract < Test::Unit::TestCase
  def test_signature_and_param_lines
    src = <<~MD
      ### def join(sep = $,) -> String
      {: since="" }

      連結します。

      - **param** `sep` -- 区切り文字列
    MD
    r = CheckParams.extract(src)
    assert_equal(["### def join(sep = $,) -> String"], r.sig_lines)
    assert_equal(["sep"], r.sig_names)
    assert_equal(["sep"], r.param_names)
    assert_equal(1, r.param_line_count)
    assert_equal([], r.errors)
  end

  def test_aliases_unioned
    src = <<~MD
      ### def each(&block) -> self
      ### def each -> Enumerator
      ### module_function def foo(x, y: 1)
    MD
    assert_equal(["block", "x", "y"], CheckParams.extract(src).sig_names)
  end

  def test_fenced_code_skipped
    src = <<~MD
      ### def foo(a)

      ```ruby
      ### def bar(b)
      - **param** `c` -- 例の中
      ```

        ``` 
      - **param** `d` -- 字下げしたフェンスの中
        ```

      - **param** `a` -- 引数
    MD
    r = CheckParams.extract(src)
    assert_equal(["a"], r.sig_names)
    assert_equal(["a"], r.param_names)
    assert_equal(1, r.param_line_count)
  end

  def test_param_names_normalized_and_arg_lines
    src = <<~MD
      ### def foo(*args, **opts, &blk)
      - **param** `*args` -- 引数
      - **arg** `**opts` -- 引数
      - **param** `&blk` -- ブロック
      - **param** `self` -- 無視
      - **param** `args` -- 重複
    MD
    r = CheckParams.extract(src)
    assert_equal(["args", "opts", "blk"], r.param_names)
    assert_equal(5, r.param_line_count)
  end

  def test_comma_separated_param_line
    src = "### def [](i, j, k, ...)\n- **param** `i, j, k, ...` -- 各次元のインデックス\n"
    r = CheckParams.extract(src)
    assert_equal(["i", "j", "k"], r.param_names)
    assert_equal(1, r.param_line_count)
    assert_equal(:ok, CheckParams.check(src).status)
  end

  def test_const_not_target
    r = CheckParams.extract("### const FOO\n### gvar $foo\n")
    assert_equal([], r.sig_lines)
  end

  def test_parse_error
    src = "### def foo(a\n### def foo(b)\n"
    r = CheckParams.extract(src)
    assert_equal(["b"], r.sig_names)
    assert_equal(1, r.errors.size)
    assert_kind_of(BitClust::ParseError, r.errors.first)
  end
end

class TestCheckParamsCheck < Test::Unit::TestCase
  def test_ok
    r = CheckParams.check("### def foo(a, b: 1)\n- **param** `b:` -- x\n- **param** `a` -- y\n")
    assert_equal(:ok, r.status)
  end

  def test_mismatch
    r = CheckParams.check("### def foo(z, a, b)\n- **param** `a` -- x\n- **param** `d` -- y\n- **param** `c` -- y\n")
    assert_equal(:mismatch, r.status)
    assert_equal(["b", "z"], r.only_in_signature)
    assert_equal(["c", "d"], r.only_in_params)
  end

  def test_no_param_lines_with_args
    r = CheckParams.check("### def foo(a)\n")
    assert_equal(:no_param_lines, r.status)
    assert_true(r.args_without_param_lines?)
  end

  def test_no_param_lines_without_args
    r = CheckParams.check("### def foo -> nil\n")
    assert_equal(:no_param_lines, r.status)
    assert_false(r.args_without_param_lines?)
  end

  def test_only_ignored_param_line_is_still_param_line
    r = CheckParams.check("### def foo(a)\n- **param** `self` -- x\n")
    assert_equal(:mismatch, r.status)
    assert_equal(["a"], r.only_in_signature)
  end
end

class TestCheckParamsLocate < Test::Unit::TestCase
  def setup
    @dir = Dir.mktmpdir
    @file = File.join(@dir, "a.md")
    File.write(@file, "# A\n\n### def foo(a)  \n### def foo(a)\n")
  end

  def teardown
    FileUtils.rm_rf(@dir)
  end

  def test_found_first
    assert_equal(3, CheckParams.locate(@file, "### def foo(a)"))
  end

  def test_not_found
    assert_nil(CheckParams.locate(@file, "### def bar"))
    assert_nil(CheckParams.locate(File.join(@dir, "none.md"), "### def foo(a)"))
  end

  def test_cache
    cache = {}
    CheckParams.locate(@file, "### def foo(a)", cache)
    File.write(@file, "changed\n")
    assert_equal(3, CheckParams.locate(@file, "### def foo(a)", cache))
  end
end

class TestCheckParamsRun < Test::Unit::TestCase
  Named = Struct.new(:name)
  Location = Struct.new(:file)
  Entry = Struct.new(:typemark, :names, :klass, :library, :source, :source_location) do
    def name
      names.first
    end
  end
  DB = Struct.new(:methods)

  def entry(typemark, name, source, file: "manual/api/_builtin/Foo.md", klass: "Foo", lib: "_builtin")
    Entry.new(typemark, [name], Named.new(klass), Named.new(lib), source,
              file && Location.new(file))
  end

  def setup
    @root = Dir.mktmpdir
    FileUtils.mkdir_p(File.join(@root, "manual/api/_builtin"))
    File.write(File.join(@root, "manual/api/_builtin/Foo.md"), <<~MD)
      # class Foo

      ### def ok(a)
      - **param** `a` -- x

      ### def bad(a, b)
      - **param** `a` -- x
      - **param** `c` -- x

      ### def Foo.cbad(a)
      - **param** `c` -- x
    MD
  end

  def teardown
    FileUtils.rm_rf(@root)
  end

  def run_check(entries)
    out = StringIO.new
    n = CheckParams.run(DB.new(entries), out: out, root: @root)
    [n, out.string]
  end

  def test_reports_mismatches_sorted_with_summary
    entries = [
      entry(".", "cbad", "### def Foo.cbad(a)\n- **param** `c` -- x\n"),
      entry("#", "bad", "### def bad(a, b)\n- **param** `a` -- x\n- **param** `c` -- x\n"),
      entry("#", "ok", "### def ok(a)\n- **param** `a` -- x\n"),
      entry("#", "noparam", "### def noparam(x)\n"),
      entry("#", "noargs", "### def noargs -> nil\n"),
      entry("::", "CONST", "### const CONST\n- **param** `zzz` -- x\n"),
    ]
    n, out = run_check(entries)
    assert_equal(2, n)
    assert_equal(<<~OUT, out)
      manual/api/_builtin/Foo.md:6: Foo#bad: シグネチャだけにある引数: b / param 行だけにある引数: c
      manual/api/_builtin/Foo.md:10: Foo.cbad: シグネチャだけにある引数: a / param 行だけにある引数: c
      entries=5 with_param_lines=3 mismatched=2 args_but_no_param_lines=1
    OUT
  end

  def test_one_side_only
    n, out = run_check([entry("#", "bad", "### def bad(a, b)\n- **param** `a` -- x\n")])
    assert_equal(1, n)
    assert_equal("manual/api/_builtin/Foo.md:6: Foo#bad: シグネチャだけにある引数: b\n", out.lines.first)
  end

  def test_unknown_line_and_location
    entries = [
      entry("#", "x", "### def x(a)\n- **param** `b` -- x\n"),
      entry(".#", "y", "### module_function def y(a)\n- **param** `b` -- x\n", file: nil),
    ]
    n, out = run_check(entries)
    assert_equal(2, n)
    assert_equal(["manual/api/_builtin/Foo.md: Foo#x: シグネチャだけにある引数: a / param 行だけにある引数: b\n",
                  "Foo.#y: シグネチャだけにある引数: a / param 行だけにある引数: b\n"],
                 out.lines.first(2))
  end

  def test_no_mismatch_returns_zero
    n, out = run_check([entry("#", "ok", "### def ok(a)\n- **param** `a` -- x\n")])
    assert_equal(0, n)
    assert_equal("entries=1 with_param_lines=1 mismatched=0 args_but_no_param_lines=0\n", out)
  end
end

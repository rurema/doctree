category Windows

Win32 API を呼び出すためのライブラリです。

= class Win32API < Object

Win32 API を呼び出すためのクラスです。

=== 使用例 1: MessageBox
#@# Win32API のクラスメソッドにしてみた

  require 'Win32API'
  # require 'dl/win32'
  
  class Win32API
    # type flag
    MB_OK               = 0
    MB_OKCANCEL         = 1
    MB_ABORTRETRYIGNORE = 2
    MB_YESNOCANCEL      = 3
    MB_YESNO            = 4
    MB_RETRYCANCEL      = 5
    
    # return values
    IDOK     = 1
    IDCANCEL = 2
    IDABORT  = 3
    IDRETRY  = 4
    IDIGNORE = 5
    IDYES    = 6
    IDNO     = 7
    
    def Win32API.MessageBox(wnd, text, caption, type = MB_OK)
      messagebox = Win32API.new('user32', 'MessageBox', %w(p p p i), 'i')
      
      messagebox.call(wnd, text, caption, type)
    end
    
    def Win32API.MessageBoxEx(wnd, text, caption, type = MB_OK, languageid = 0)
      messagebox = Win32API.new('user32', 'MessageBoxEx', %w(p p p i i), 'i')
      
      messagebox.call(wnd, text, caption, type, languageid)
    end
  end
  
  p Win32API.MessageBox(0, "test message", "test caption")
  p Win32API.MessageBoxEx(0, "test message", "test caption")
  p Win32API.MessageBox(0, "てすと", "テスト")
  p Win32API.MessageBoxEx(0, "てすと", "テスト")

=== 使用例 2: Cygwin の uname コマンドの代わり

  require 'Win32API'
  
  module Cygwin
    def uname
      uname = Win32API.new 'cygwin1', 'uname', ['P'], 'I'
      utsname = ' ' * 100
      raise 'cannot get system name' if uname.call(utsname) == -1
      
      utsname.unpack('A20' * 5)
    end
    module_function :uname
  end
  
  p Cygwin.uname
  
  => ["CYGWIN_98-4.10", "hoge", "1.1.7(0.31/3/2)", "2000-12-25 12:39", "i586"]

=== 使用例 3: Cygwin の cygpath コマンドの代わり

  require 'Win32API'
  
  module Cygwin
    @conv_to_full_posix_path =
      Win32API.new('cygwin1.dll', 'cygwin_conv_to_full_posix_path', 'PP', 'I')
    @conv_to_posix_path =
      Win32API.new('cygwin1.dll', 'cygwin_conv_to_posix_path', 'PP', 'I')
    @conv_to_full_win32_path =
      Win32API.new('cygwin1.dll', 'cygwin_conv_to_full_win32_path', 'PP', 'I')
    @conv_to_win32_path =
      Win32API.new('cygwin1.dll', 'cygwin_conv_to_win32_path', 'PP', 'I')
    
    def cygpath(options, path)
      absolute = shortname = false
      func = nil
      options.delete(" \t-").each_byte {|opt|
        case opt
        when ?u
          func = [@conv_to_full_posix_path, @conv_to_posix_path]
        when ?w
          func = [@conv_to_full_win32_path, @conv_to_win32_path]
        when ?a
          absolute = true
        when ?s
          shortname = true
        end
      }
      raise ArgumentError "first argument must contain -u or -w" if func.nil?
      func = absolute ? func[0] : func[1]
      buf = "\0" * 300
      if func.Call(path, buf) == -1
        raise "cannot convert path name"
      end
      buf.delete!("\0")
      buf
    end
    module_function :cygpath
  end
  
  p Cygwin.cygpath("-u", 'c:\\')         # => "/cygdrive/c"
  p Cygwin.cygpath("-w", '/cygdrive/c')  # => "c:\\"
  p Cygwin.cygpath("-wa", '.')           # => "d:\\home\\arai"

== Class Methods

--- new(dllname, func, import, export)
#@todo

DLL dllname をロードし、API func のオブジェクトを生成します。

第 3 引数 import には func の引数の型のリストを指定します。
nil の場合は引数なしと見なされます。

第 4 引数 export には func の戻り値の型を指定します。
nil の場合は戻り値なし (void) と見なされます。

第 3 引数 import と第 4 引数 export で
型を指定するには以下の文字列を用います。

: "p"
    ポインタ
#@# あらい: 2001-03-23 本当?
: "n", "l"
    long
: "i"
    int
: "v"
    void

== Instance Methods

--- call(*args)
--- Call(*args)
#@todo

API を呼び出します。
指定する引数と戻り値は [[m:Win32API.new]] の引数の指定に従います。
特にポインタを渡してそのポインタの指す領域に値が設定される場合は
その領域をあらかじめ確保しておく必要があります。

例えば、引数のバッファに書き込む関数を呼び出すには以下のようにします。

  require 'Win32API'
  api = Win32API.new('foo.dll', 'foo', 'p', 'v')
  buf = "\0" * 256
  api.call(buf)

ポインタの配列を渡す場合は以下のようにします。
#@# あらい: 2001-03-23 まだ試してない。あってるかな？
#@# バグ？: 2004-01-29 obj.call([args.pack("p3")].pack("P"))のような？

  require 'Win32API'
  api = Win32API.new('foo.dll', 'foo', 'p', 'v')
  args = ["\0" * 256, "\0" * 256, "\0" * 256]
  api.call(args.pack("p3"))

= class Win32API < Object

Win32 API をコールするためのクラスです。

=== 使用例

MessageBox (Win32API のクラスメソッドにしてみた)

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

Cygwin の uname コマンドの代わり

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

Cygwin の cygpath コマンドの代わり

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

--- new(dllname, proc, import, export)

DLL dllname をロードし、API関数 proc のオブジェクトを
生成します。import には proc の引数の型のリストを、
export には proc の戻り値の型を指定します。

型の指定は以下の文字列または配列です。

: "p"
    ポインタ
#@# あらい: 2001-03-23 本当?
: "n", "l"
    long
: "i"
    int
: "v"
    void

import が nil の場合は引数なしと見なされます。
また、export が nil の場合は戻り値なし (void) と見なされます。

== Instance Methods

--- call([args ...])
--- Call([args ...])

API 関数をコールします。指定する引数と戻り値は new の引数の
指定に従います。特にポインタを渡してそのポインタの指す領域に値が
設定される場合はその領域をあらかじめ確保しておく必要があります。

例えば、文字列が返る関数をコールする場合は以下のようにします。

  obj = Win32API.new('dllname.dll', 'foo', 'p', 'v')
  arg = "\0" * 256
  obj.call(arg)

ポインタの配列を渡す場合は以下のようにします。
#@# あらい: 2001-03-23 まだ試してない。あってるかな？
#@# バグ？: 2004-01-29 obj.call([args.pack("p3")].pack("P"))のような？

  obj = Win32API.new('dllname.dll', 'foo', 'p', 'v')
  args = ["\0" * 256, "\0" * 256, "\0" * 256,]
  obj.call(args.pack("p3"))

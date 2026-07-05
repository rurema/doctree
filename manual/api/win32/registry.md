---
type: library
category: Windows
---
win32/registry は Win32 プラットフォームでレジストリをアクセスするための
ライブラリです。Win32 API の呼び出しに [c:Win32API] を使います。

```
require 'win32/registry'

Win32::Registry::HKEY_CURRENT_USER.open('SOFTWARE\foo') do |reg|
  value = reg['foo']                               # 値の読み込み
  value = reg['foo', Win32::Registry::REG_SZ]      # 型を限定した読み込み
  type, value = reg.read('foo')                    # 値の読み込み
  reg['foo'] = 'bar'                               # 値の書き込み
  reg['foo', Win32::Registry::REG_SZ] = 'bar'      # 型指定付き値の書き込み
  reg.write('foo', Win32::Registry::REG_SZ, 'bar') # 値の書き込み

  reg.each_value { |name, type, data| ... }        # 値の列挙
  reg.each_key { |key, wtime| ... }                # サブキーの列挙

  reg.delete_value('foo')                          # 値の削除
  reg.delete_key('foo')                            # サブキーの削除
  reg.delete_key('foo', true)                      # サブキーの再帰削除
end
```

### WSH を用いたレジストリアクセス

レジストリをアクセスするには [c:WIN32OLE] を使って WScript.Shell オブジェクト経由でアクセスする方法もあります。

`````
require 'win32ole'

wsh = WIN32OLE.new('WScript.Shell')
value = wsh.RegRead 'HKLM\Software\Microsoft\Windows\...'
wsh.RegWrite 'HKCU\Software\foo\barfile\shell\open\command\\', '"C:\..." "%1"', 'REG_SZ'
`````

ただし，キーを列挙したり，自由なバイナリ値を読み書きできません。


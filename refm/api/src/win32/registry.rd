#@since 1.8.0
category Windows

win32/registry は Win32 プラットフォームでレジストリをアクセスするための
ライブラリです。Win32 API の呼び出しに [[c:Win32API]] を使います。

//emlist{
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
//}

=== WSH を用いたレジストリアクセス

レジストリをアクセスするには [[c:WIN32OLE]] を使って WScript.Shell オブジェクト経由でアクセスする方法もあります。

  require 'win32ole'

  wsh = WIN32OLE.new('WScript.Shell')
  value = wsh.RegRead 'HKLM\Software\Microsoft\Windows\...'
  wsh.RegWrite 'HKCU\Software\foo\barfile\shell\open\command\\', '"C:\..." "%1"', 'REG_SZ'

ただし，キーを列挙したり，自由なバイナリ値を読み書きすることができません。

= class Win32::Registry < Object

include Enumerable
include Win32::Registry::Constants

== Class Methods

--- new(key, subkey, desired = KEY_READ, opt = REG_OPTION_RESERVED)
--- new(key, subkey, desired = KEY_READ, opt = REG_OPTION_RESERVED) {|reg| ... }
--- open(key, subkey, desired = KEY_READ, opt = REG_OPTION_RESERVED)
--- open(key, subkey, desired = KEY_READ, opt = REG_OPTION_RESERVED) {|reg| ... }
#@todo

レジストリキー key 下のキー subkey を開き，
開いたキーを表す Win32::Registry オブジェクトを返します。
key は親のキーを Win32::Registry オブジェクトで指定します。
親のキーには定義済キー HKEY_* を使用できます (⇒[[c:Win32::Registry::Constants]])

desired はアクセスマスクです。opt はキーのオプションです。
詳細は以下の MSDN Library を参照してください。

 * Registry Key Security and Access Rights: [[url:http://msdn.microsoft.com/library/en-us/sysinfo/base/registry_key_security_and_access_rights.asp]]

ブロックが与えられると，キーは自動的に閉じられます。

--- create(key, subkey, desired = KEY_ALL_ACCESS, opt = REG_OPTION_RESERVED)
--- create(key, subkey, desired = KEY_ALL_ACCESS, opt = REG_OPTION_RESERVED) {|reg| ... }
#@todo

レジストリキー key 下にキー subkey を作成し，
開いたキーを表す Win32::Registry オブジェクトを返します。
key は親のキーを Win32::Registry オブジェクトで指定します。
親のキーには定義済キー HKEY_* を使用できます (⇒[[c:Win32::Registry::Constants]])

サブキーが既に存在していればキーはただ開かれ，[[m:Win32::Registry#created?]]
メソッドが false を返します。

ブロックが与えられると，キーは自動的に閉じられます。

--- expand_environ(str)
#@todo

str の %\w+% という並びを環境変数に置換します。
REG_EXPAND_SZ で用いられます。

詳細は以下の Win32 API を参照してください。

 * ExpandEnvironmentStrings: [[url:http://msdn.microsoft.com/library/en-us/sysinfo/base/expandenvironmentstrings.asp]]

--- type2name(type)
#@todo

レジストリ値の型を整数から可読文字列に変換します。

--- wtime2time(wtime)
#@todo

64bit の FILETIME を Time オブジェクトに変換します。

詳細は以下の MSDN Library を参照してください。

 * FILETIME Structure: [[url:http://msdn.microsoft.com/library/en-us/sysinfo/base/filetime_str.asp]]

--- time2wtime(time)
#@todo

Time オブジェクトまたは Integer オブジェクトを受け取り，
64bit の FILETIME に変換します。

== Instance Methods

--- open(subkey, desired = KEY_READ, opt = REG_OPTION_RESERVED)
#@todo

[[m:Win32::Registry.open]](self, subkey, desired, opt) と同じです。

--- create(subkey, desired = KEY_ALL_ACCESS, opt = REG_OPTION_RESERVED)
#@todo

[[m:Win32::Registry.create]](self, subkey, desired, opt) と同じです。

--- close
#@todo

開かれているキーを閉じます。

閉じられた後では，多くのメソッドは例外を発生します。

--- read(name, *rtype)
#@todo

レジストリ値 name を読み，[ type, data ]
の配列で返します。
name が nil の場合，(標準) レジストリ値が読み込まれます。

type はレジストリ値の型です。(⇒[[c:Win32::Registry::Constants]])
data はレジストリ値のデータで，クラスは以下の通りです:
  * REG_SZ, REG_EXPAND_SZ
    String
  * REG_MULTI_SZ
    String の配列
  * REG_DWORD, REG_DWORD_BIG_ENDIAN, REG_QWORD
    Integer
  * REG_BINARY
    String (バイナリデータを含みます)

オプション引数 rtype が指定されていた場合，レジストリ値の型が
与えられた rtype の配列に存在するかチェックされ，存在しない場合に
[[c:TypeError]] が発生します。

--- [](name, *rtype)
#@todo

レジストリ値 name を読み，その値を返します。クラスは
[[m:Win32::Registry#read]] に準じます。

レジストリ値の型が REG_EXPAND_SZ だった場合，環境変数が置換されます。
レジストリ値の型が REG_SZ, REG_EXPAND_SZ, REG_MULTI_SZ, REG_DWORD,
REG_DWORD_BIG_ENDIAN, REG_QWORD 以外だった場合は TypeError が発生します。

オプション引数 rtype の意味は read と同じです。

--- read_s(name)
--- read_i(name)
--- read_bin(name)
#@todo

型がそれぞれ REG_SZ(read_s), REG_DWORD(read_i), REG_BINARY(read_bin)
であるレジストリ値 name を読み，その値を返します。

型がマッチしなかった場合，TypeError が発生します。

--- read_s_expand(name)
#@todo

型が REG_SZ または REG_EXPAND_SZ であるレジストリ値 name を読み，
その値を返します。

型が REG_EXPAND_SZ だった場合，環境変数が置換された値が返ります。
REG_SZ または REG_EXPAND_SZ 以外だった場合，TypeError が発生します。

--- write(name, type, data)
#@todo

レジストリ値 name に型 type で data を書き込みます。
name が nil の場合，(標準) レジストリ値に書き込みます。

type はレジストリ値の型です。(⇒[[c:Win32::Registry::Constants]])
data のクラスは [[m:Win32::Registry#read]]
メソッドに準じていなければなりません。

--- [](name, wtype = nil)
#@todo

レジストリ値 name に value を書き込みます。

オプション引数 wtype を指定した場合は，その型で書き込みます。
指定しなかった場合，value のクラスに応じて次の型で書き込みます:
  * Integer
    REG_DWORD
  * String
    REG_SZ
  * Array
    REG_MULTI_SZ

--- write_s(name, value)
--- write_i(name, value)
--- write_bin(name, value)
#@todo

レジストリ値 name に value を書き込みます。

レジストリ値の型はそれぞれ REG_SZ(write_s), REG_DWORD(write_i),
REG_BINARY(write_bin) です。

--- each {|name, type, value| ... }
--- each_value {|name, type, value| ... }
#@todo

キーが持つレジストリ値を列挙します。

--- each_key {|subkey, wtime| ... }
#@todo

キーのサブキーを列挙します。

subkey はサブキーの名前を表す String です。
wtime は最終更新時刻を表す FILETIME (64-bit 整数) です。
(⇒[[m:Win32::Registry.wtime2time]])

--- delete(name)
--- delete_value(name)
#@todo

レジストリ値 name を削除します。
(標準) レジストリ値を削除することはできません。

--- delete_key(name, recursive = false)
#@todo

サブキー name とそのキーが持つすべての値を削除します。

recursive が false の場合，そのサブキーはサブキーを持っていてはなりません。
true の場合，キーは再帰的に削除されます。

--- flush
#@todo

キーの全てのデータをレジストリファイルに書き込みます。

--- created?
#@todo

キーが新しく作成された場合，真を返します。
(⇒[[m:Win32::Registry.create]])

--- opened?
#@todo

キーがまだ閉じられていない場合，真を返します。

--- parent
#@todo

親のキーを表す Win32::Registry オブジェクトを返します。
定義済キーでは nil を返します。

--- keyname
#@todo

[[m:Win32::Registry.open]] または [[m:Win32::Registry.create]] に指定された
subkey の値を返します。

--- disposition
#@todo

キーの disposition 値を返します。
(REG_CREATED_NEW_KEY または REG_OPENED_EXISTING_KEY)

--- name
--- to_s
#@todo

キーのフルパスを 'HKEY_CURRENT_USER\SOFTWARE\foo\bar'
のような形で返します。

--- info
#@todo

キー情報を以下の値の配列で返します:
  * num_keys
    サブキーの個数
  * max_key_length
    サブキー名の最大長
  * num_values
    値の個数
  * max_value_name_length
    値の名前の最大長
  * max_value_length
    値の最大長
  * descriptor_length
    セキュリティ記述子の長さ
  * wtime
    最終更新時刻 (FILETIME)

詳細は以下の Win32 API を参照してください。

 * RegQueryInfoKey: [[url:http://msdn.microsoft.com/library/en-us/sysinfo/base/regqueryinfokey.asp]]

--- num_keys
--- max_key_length
--- num_values
--- max_value_name_length
--- max_value_length
--- descriptor_length
--- wtime
#@todo

キー情報の個々の値を返します。


--- []=(name, rtype, value = nil)
#@todo

--- _dump
#@todo

--- hkey
#@todo

--- inspect
#@todo

--- keys
#@todo

--- open?
#@todo


== Constants

--- HKEY_CLASSES_ROOT        -> Win32::Registry
--- HKEY_CURRENT_USER        -> Win32::Registry
--- HKEY_LOCAL_MACHINE       -> Win32::Registry
--- HKEY_USERS               -> Win32::Registry
--- HKEY_PERFORMANCE_DATA    -> Win32::Registry
--- HKEY_PERFORMANCE_TEXT    -> Win32::Registry
--- HKEY_PERFORMANCE_NLSTEXT -> Win32::Registry
--- HKEY_CURRENT_CONFIG      -> Win32::Registry
--- HKEY_DYN_DATA            -> Win32::Registry
#@todo

それぞれの定義済キーを表す Win32::Registry オブジェクトです。

詳細は以下の MSDN Library を参照してください。

 * Predefined Keys: [[url:http://msdn.microsoft.com/library/en-us/sysinfo/base/predefined_keys.asp]]

= module Win32::Registry::API
== Module Functions
--- CloseKey(hkey)
--- CreateKey(hkey, name, opt, desired)
--- DeleteKey(hkey, name)
--- DeleteValue(hkey, name)
--- EnumKey(hkey, index)
--- EnumValue(hkey, index)
--- FlushKey(hkey)
--- OpenKey(hkey, name, opt, desired)
--- QueryInfoKey(hkey)
--- QueryValue(hkey, name)
--- SetValue(hkey, name, type, data, size)
--- check(result)
--- packdw(dw)
--- packqw(qw)
--- unpackdw(dw)
--- unpackqw(qw)
#@todo

== Constants
--- RegCloseKey
--- RegCreateKeyExA
--- RegDeleteKey
--- RegDeleteValue
--- RegEnumKeyExA
--- RegEnumValueA
--- RegFlushKey
--- RegOpenKeyExA
--- RegQueryInfoKey
--- RegQueryValueExA
--- RegSetValueExA
#@todo

= class Win32::Registry::Error < StandardError

== Instance Methods

--- code
#@todo

== Constants

--- FormatMessageA
#@todo


= class Win32::Registry::PredefinedKey < Win32::Registry

== Class Methods

--- new(hkey, keyname)
#@todo

== Instance Methods

--- class
#@todo

--- close
#@todo

= module Win32::Registry::Constants

詳細は以下の MSDN Library を参照してください。

 * Registry: [[url:http://msdn.microsoft.com/library/en-us/sysinfo/base/registry.asp]]

== Constants

--- HKEY_CLASSES_ROOT
--- HKEY_CURRENT_USER
--- HKEY_LOCAL_MACHINE
--- HKEY_USERS
--- HKEY_PERFORMANCE_DATA
--- HKEY_PERFORMANCE_TEXT
--- HKEY_PERFORMANCE_NLSTEXT
--- HKEY_CURRENT_CONFIG
--- HKEY_DYN_DATA
#@todo

定義済キー値。
これらは Integer で、Win32::Registry オブジェクトではありません。

--- REG_NONE
--- REG_SZ
--- REG_EXPAND_SZ
--- REG_BINARY
--- REG_DWORD
--- REG_DWORD_LITTLE_ENDIAN
--- REG_DWORD_BIG_ENDIAN
--- REG_LINK
--- REG_MULTI_SZ
--- REG_RESOURCE_LIST
--- REG_FULL_RESOURCE_DESCRIPTOR
--- REG_RESOURCE_REQUIREMENTS_LIST
--- REG_QWORD
--- REG_QWORD_LITTLE_ENDIAN
#@todo

レジストリ値の型。

--- STANDARD_RIGHTS_READ
--- STANDARD_RIGHTS_WRITE
--- KEY_QUERY_VALUE
--- KEY_SET_VALUE
--- KEY_CREATE_SUB_KEY
--- KEY_ENUMERATE_SUB_KEYS
--- KEY_NOTIFY
--- KEY_CREATE_LINK
--- KEY_READ
--- KEY_WRITE
--- KEY_EXECUTE
--- KEY_ALL_ACCESS
#@todo

セキュリティアクセスマスク。


--- REG_CREATED_NEW_KEY
--- REG_OPENED_EXISTING_KEY
#@todo

キーが新しく作られたか、既存キーが開かれたか。
[[m:Win32::Registry#disposition]] メソッドも参照してください。

--- REG_OPTION_RESERVED
--- REG_OPTION_NON_VOLATILE
--- REG_OPTION_VOLATILE
--- REG_OPTION_CREATE_LINK
--- REG_OPTION_BACKUP_RESTORE
--- REG_OPTION_OPEN_LINK
--- REG_LEGAL_OPTION
#@todo

--- REG_WHOLE_HIVE_VOLATILE
--- REG_REFRESH_HIVE
--- REG_NO_LAZY_FLUSH
--- REG_FORCE_RESTORE
#@todo

--- MAX_KEY_LENGTH
--- MAX_VALUE_LENGTH
#@todo

#@end

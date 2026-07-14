---
library: win32/registry
---
# module Win32::Registry::Constants

詳細は以下の MSDN Library を参照してください。

 - Registry: <http://msdn.microsoft.com/library/en-us/sysinfo/base/registry.asp>

## Constants

### const HKEY_CLASSES_ROOT
### const HKEY_CURRENT_USER
### const HKEY_LOCAL_MACHINE
### const HKEY_USERS
### const HKEY_PERFORMANCE_DATA
### const HKEY_PERFORMANCE_TEXT
### const HKEY_PERFORMANCE_NLSTEXT
### const HKEY_CURRENT_CONFIG
### const HKEY_DYN_DATA
#@todo

定義済キー値。
これらは Integer で、Win32::Registry オブジェクトではありません。

### const REG_NONE
### const REG_SZ
### const REG_EXPAND_SZ
### const REG_BINARY
### const REG_DWORD
### const REG_DWORD_LITTLE_ENDIAN
### const REG_DWORD_BIG_ENDIAN
### const REG_LINK
### const REG_MULTI_SZ
### const REG_RESOURCE_LIST
### const REG_FULL_RESOURCE_DESCRIPTOR
### const REG_RESOURCE_REQUIREMENTS_LIST
### const REG_QWORD
### const REG_QWORD_LITTLE_ENDIAN
#@todo

レジストリ値の型。

### const STANDARD_RIGHTS_READ
### const STANDARD_RIGHTS_WRITE
### const KEY_QUERY_VALUE
### const KEY_SET_VALUE
### const KEY_CREATE_SUB_KEY
### const KEY_ENUMERATE_SUB_KEYS
### const KEY_NOTIFY
### const KEY_CREATE_LINK
### const KEY_READ
### const KEY_WRITE
### const KEY_EXECUTE
### const KEY_ALL_ACCESS
#@todo

セキュリティアクセスマスク。


### const REG_CREATED_NEW_KEY
### const REG_OPENED_EXISTING_KEY
#@todo

キーが新しく作られたか、既存キーが開かれたか。
[m:Win32::Registry#disposition] メソッドも参照してください。

### const REG_OPTION_RESERVED
### const REG_OPTION_NON_VOLATILE
### const REG_OPTION_VOLATILE
### const REG_OPTION_CREATE_LINK
### const REG_OPTION_BACKUP_RESTORE
### const REG_OPTION_OPEN_LINK
### const REG_LEGAL_OPTION
#@todo

### const REG_WHOLE_HIVE_VOLATILE
### const REG_REFRESH_HIVE
### const REG_NO_LAZY_FLUSH
### const REG_FORCE_RESTORE
#@todo

### const MAX_KEY_LENGTH
### const MAX_VALUE_LENGTH
#@todo


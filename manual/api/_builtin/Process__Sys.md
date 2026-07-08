---
library: _builtin
---
# module Process::Sys

ユーザ ID・グループ ID を操作するシステムコールを直接呼ぶためのモジュールです。

ポータブルにユーザ ID・グループ ID を操作するためのモジュール [c:Process::UID], [c:Process::GID] 
も提供されています。Process::Sys と [c:Process::UID] や [c:Process::GID] を同時に使うことは
非推奨です。

## Module Functions

### module_function def getuid    -> Integer

システムコールの [man:getuid(2)] を呼びます。返り値を整数で返します。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

### module_function def geteuid    -> Integer

システムコールの [man:geteuid(2)] を呼びます。返り値を整数で返します。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

### module_function def getgid    -> Integer

システムコールの [man:getgid(2)] を呼びます。返り値を整数で返します。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

### module_function def getegid    -> Integer

システムコールの [man:getegid(2)] を呼びます。返り値を整数で返します。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

### module_function def setuid(id)    -> nil

システムコールの [man:setuid(2)] を呼びます。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

- **raise** `Errno::EXXX` -- システムコールに失敗した場合に発生します。

### module_function def setgid(id)    -> nil

システムコールの [man:setgid(2)] を呼びます。

- **param** `id` -- システムコールの引数を整数で指定します。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

- **raise** `Errno::EXXX` -- システムコールに失敗した場合に発生します。

### module_function def setruid(id)    -> nil

システムコールの setruid を呼びます。

- **param** `id` -- システムコールの引数を整数で指定します。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

- **raise** `Errno::EXXX` -- システムコールに失敗した場合に発生します。

### module_function def setrgid(id)    -> nil

システムコールの setrgid を呼びます。

- **param** `id` -- システムコールの引数を整数で指定します。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

- **raise** `Errno::EXXX` -- システムコールに失敗した場合に発生します。

### module_function def seteuid(id)    -> nil

システムコールの [man:seteuid(2)] を呼びます。

- **param** `id` -- システムコールの引数を整数で指定します。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

- **raise** `Errno::EXXX` -- システムコールに失敗した場合に発生します。

### module_function def setegid(id)    -> nil

システムコールの [man:setegid(2)] を呼びます。

- **param** `id` -- システムコールの引数を整数で指定します。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

- **raise** `Errno::EXXX` -- システムコールに失敗した場合に発生します。

### module_function def setreuid(rid, eid)    -> nil

システムコールの [man:setreuid(2)] を呼びます。

- **param** `rid` -- システムコールの引数を整数で指定します。

- **param** `eid` -- システムコールの引数を整数で指定します。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

- **raise** `Errno::EXXX` -- システムコールに失敗した場合に発生します。

### module_function def setregid(rid, eid)    -> nil

システムコールの [man:setregid(2)] を呼びます。

- **param** `rid` -- システムコールの引数を整数で指定します。

- **param** `eid` -- システムコールの引数を整数で指定します。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

- **raise** `Errno::EXXX` -- システムコールに失敗した場合に発生します。

### module_function def setresuid(rid, eid, sid)    -> nil

システムコールの setresuid を呼びます。

- **param** `rid` -- システムコールの引数を整数で指定します。

- **param** `eid` -- システムコールの引数を整数で指定します。

- **param** `sid` -- システムコールの引数を整数で指定します。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

- **raise** `Errno::EXXX` -- システムコールに失敗した場合に発生します。

### module_function def setresgid(rid, eid, sid)    -> nil

システムコールの setresgid を呼びます。

- **param** `rid` -- システムコールの引数を整数で指定します。

- **param** `eid` -- システムコールの引数を整数で指定します。

- **param** `sid` -- システムコールの引数を整数で指定します。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

- **raise** `Errno::EXXX` -- システムコールに失敗した場合に発生します。

### module_function def issetugid    -> bool

システムコールの issetugid() を呼びます。

プロセスが setuid もしくは setgid ビットを使って
起動されている場合に真を返します。

- **raise** `NotImplementedError` -- システムコールが現在のプラットフォームで提供されていない場合に発生します。

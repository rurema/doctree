[[lib:yaml]] のバックエンドライブラリです。YAML バージョン 1.0 を扱う事ができます。

#@since 1.9.2
このライブラリは obsolete です。[[lib:psych]] を使用してください。
#@end

= module YAML::Syck

[[lib:yaml]] のバックエンドのためのモジュールです。

== Constants

#@until 1.9.2
--- VERSION -> String

[[lib:syck]] のバージョンを返します。
#@end

--- DefaultResolver -> YAML::Syck::Resolver
#@todo

--- GenericResolver -> YAML::Syck::Resolver
#@todo

== Module Functions

--- compile(io)
#@todo

Convert YAML to bytecode

= class YAML::Syck::Resolver

== Class Methods

--- new -> YAML::Syck::Resolver
#@todo

自身を初期化します。

== Instance Methods

--- tags
#@todo

--- tags=(val)
#@todo

--- add_type(taguri, cls)
#@todo

--- use_types_at(hsh)
#@todo

--- detect_implicit(val)
#@todo

--- transfer(type, val)
#@todo

--- node_import(node)
#@todo

--- tagurize(val) -> String
#@todo

= class YAML::Syck::Parser

== Class Methods

--- new(options = {}) -> YAML::Syck::Parser
#@todo

自身を初期化します。

== Instance Methods

--- options(val)
#@todo

--- options=(val)
#@todo

--- resolver(val)
#@todo

--- resolver=(val)
#@todo

--- input(val)
#@todo

--- input=(val)
#@todo

--- bufsize(val)
#@todo

--- bufsize=(val)
#@todo

--- load(io)
#@# --- load(io) { ... }

--- load_documents(io)
--- load_documents(io) { |doc| ... }
#@todo

--- set_resolver(resolver)
#@todo

= class YAML::Syck::Node

== Instance Methods

#@until 1.9.3
--- initialize_copy(orig) -> YAML::Syck::Node
#@todo

Cloning method for all node types
#@end

--- emitter
#@todo

--- emitter=(val)
#@todo

--- resolver
#@todo

--- resolver=(val)
#@todo

--- kind
#@todo

--- kind=(val)
#@todo

--- type_id
#@todo

--- type_id=(val)
#@todo

--- value
#@todo

--- value=(val)
#@todo

--- type_id=(val)
#@todo

--- transform
#@todo

= class YAML::Syck::Scalar

== Class Methods

--- new(type_id, val, style) -> YAML::Syck::Scalar
#@todo

自身を初期化します。

== Instance Methods

--- value=(val)
#@todo

--- style=(val)
#@todo

= class YAML::Syck::Seq

== Class Methods

--- new(type_id, val, style) -> YAML::Syck::Seq
#@todo

自身を初期化します。

== Instance Methods

--- value=(val)
#@todo

--- add(key, val)
#@todo

--- style=(val)
#@todo

= class YAML::Syck::Map

== Class Methods

--- new(type_id, val, style) -> YAML::Syck::Map
#@todo

自身を初期化します。

== Instance Methods

--- value=(val)
#@todo

--- add(key, val)
#@todo

--- style=(val)
#@todo

= class YAML::PrivateType

== Class Methods

--- new(type_id, val) -> YAML::PrivateType
#@todo

自身を初期化します。

== Instance Methods

--- type_id
#@todo

--- type_id=(val)
#@todo

--- value
#@todo

--- value=(val)
#@todo

= class YAML::DomainType

== Class Methods

--- new(domain, type_id, val) -> YAML::DomainType
#@todo

自身を初期化します。

== Instance Methods

--- domain
#@todo

--- domain=(val)
#@todo

--- type_id
#@todo

--- type_id=(val)
#@todo

--- value
#@todo

--- value=(val)
#@todo

= class YAML::Object

== Class Methods

--- new(klass, ivars) -> YAML::Object
#@todo

自身を初期化します。

== Instance Methods

--- class
#@todo

--- class=(val)
#@todo

--- ivars
#@todo

--- ivars=(val)
#@todo

--- yaml_initialize(klass, ivars) -> YAML::Object
#@todo

= class YAML::Syck::BadAlias

include Comparable

== Class Methods

--- new(name) -> YAML::Syck::BadAlias
#@todo

自身を初期化します。

== Instance Methods

--- name -> String
#@todo

--- name=(val)
#@todo

--- <=>(other) -> Integer | nil

自身の名前を比較します。

@see [[m:String#<=>]]

= class YAML::Syck::MergeKey

= class YAML::Syck::DefaultKey

= class YAML::Syck::Out

== Class Methods

--- new(emitter) -> YAML::Syck::Out
#@todo

自身を初期化します。

== Instance Methods

--- emitter -> YAML::Syck::Emitter
#@todo

--- emitter=(val)
#@todo

--- map(type_id, style = nil)
#@todo

--- seq(type_id, style = nil)
#@todo

--- scalar(type_id, str, style = nil)
#@todo

= class YAML::Syck::Emitter

== Class Methods

--- new(*options) -> YAML::Syck::Emitter
#@todo

自身を初期化します。

== Instance Methods

--- level
#@todo

--- level=(value)
#@todo

--- reset(*options) -> YAML::Syck::Emitter
#@todo

--- emit(object_id)
#@todo

--- set_resolver(resolver) -> YAML::Syck::Emitter
#@todo

--- node_export(node)
#@todo

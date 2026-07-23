# -*- coding: us-ascii -*-
# dump_methods.rb : dump all builtin modules/classes and the methods they
# define themselves (inherit=false), with visibility.
#
# Requirements: must run unmodified on Ruby 1.8.6 .. 4.x, without requiring
# any library (so that only builtin classes/methods are observed).
# Run with --disable-gems where supported (1.9.1+).
#
# NOTE: everything is done with local variables and lambdas -- no toplevel
# def / constant -- so the script itself does not contaminate the dump.
#
# Output (TSV, one record per line):
#   V <RUBY_VERSION> <RUBY_PATCHLEVEL> <RUBY_DESCRIPTION>
#   P <constant path> <canonical module name>   # incl. aliases (Fixnum -> Integer)
#   A <name> <class|module> <superclass> <ancestors joined by ,>
#   M <name> <s|i> <pub|priv|prot> <method name>
#     s = singleton method (defined on the singleton class itself)
#     i = instance method  (defined on the class/module itself)
#
# In addition to modules reachable from Object.constants, three non-module
# objects documented in _builtin are dumped specially:
#   ENV, ARGF (singleton methods, kind "s", A type "object"),
#   main (toplevel self), and the ARGF.class class itself on 1.9+.

$VERBOSE = nil

main_obj = self

safe_name = lambda {|mod|
  begin
    n = mod.name
    if n.nil?
      nil
    else
      n = n.to_s
      n.empty? ? nil : n
    end
  rescue Exception
    nil
  end
}

own_constants = lambda {|mod|
  begin
    if mod.method(:constants).arity == 0
      # 1.8: constants() includes inherited ones; const_defined? checks own table only
      mod.constants.select {|c| begin; mod.const_defined?(c); rescue Exception; false; end }
    else
      mod.constants(false)
    end
  rescue Exception
    []
  end
}

# On old rubies (<= 1.9.1), instance_methods(false) on a singleton class
# leaks methods inherited from Class/Module. Where UnboundMethod#owner is
# available (1.8.7+) we filter exactly by owner == the class itself; on
# 1.8.6 we fall back to singleton_methods(false) + subtraction.
have_owner = Object.instance_method(:clone).respond_to?(:owner)

meth_list = lambda {|mod, sel|
  begin
    names = mod.send(sel, false).map {|m| m.to_s }
    if have_owner
      names = names.select {|m|
        begin
          mod.instance_method(m).owner == mod
        rescue Exception
          true
        end
      }
    end
    names.sort
  rescue Exception
    []
  end
}

# 1.8.6 only: own singleton methods without owner support.
# Returns [[vis, name], ...]
singleton_meths_186 = lambda {|mod, sing|
  begin
    pub = mod.singleton_methods(false).map {|m| m.to_s }
    leak = (mod.class.private_instance_methods(true) +
            mod.class.instance_methods(true)).map {|m| m.to_s }
    priv = sing.private_instance_methods(false).map {|m| m.to_s } - leak - pub
    pub.sort.map {|m| ["pub", m] } + priv.sort.map {|m| ["priv", m] }
  rescue Exception
    []
  end
}

queue = [[Object, "Object"]]
seen = {}        # object_id => true
seen_paths = {}  # "path\tname" => true
order = []       # [name, mod]
paths = []       # [path, canonical name]

while !queue.empty?
  pair = queue.shift
  mod = pair[0]
  path = pair[1]
  nm = safe_name.call(mod) || path
  pkey = path + "\t" + nm
  unless seen_paths[pkey]
    seen_paths[pkey] = true
    paths.push([path, nm])
  end
  next if seen[mod.object_id]
  seen[mod.object_id] = true
  order.push([nm, mod])
  own_constants.call(mod).each do |c|
    cs = c.to_s
    begin
      next if mod.respond_to?(:autoload?) && mod.autoload?(c)
    rescue Exception
    end
    v = nil
    begin
      v = mod.const_get(c)
    rescue Exception
      next
    end
    next unless v.is_a?(Module)
    child_path = (path == "Object") ? cs : (path + "::" + cs)
    queue.push([v, child_path])
  end
end

# ARGF.class is a real class (1.9+) but reachable only through the ARGF
# object, not through any constant. On 1.8 ARGF.class is Object (skipped).
begin
  if defined?(ARGF) && safe_name.call(ARGF.class) == "ARGF.class" &&
     !seen[ARGF.class.object_id]
    seen[ARGF.class.object_id] = true
    order.push(["ARGF.class", ARGF.class])
  end
rescue Exception
end

patch = defined?(RUBY_PATCHLEVEL) ? RUBY_PATCHLEVEL.to_s : ""
desc  = defined?(RUBY_DESCRIPTION) ? RUBY_DESCRIPTION : ""
puts "V\t#{RUBY_VERSION}\t#{patch}\t#{desc}"

paths.sort.each do |path, nm|
  puts "P\t#{path}\t#{nm}"
end

order.sort.each do |nm, mod|
  type = mod.instance_of?(Class) ? "class" : "module"
  sup = ""
  if mod.instance_of?(Class)
    begin
      s = mod.superclass
      sup = s ? (safe_name.call(s) || "?") : ""
    rescue Exception
      sup = "?"
    end
  end
  anc = mod.ancestors.map {|a| safe_name.call(a) || "?" }.join(",")
  puts "A\t#{nm}\t#{type}\t#{sup}\t#{anc}"

  sing = class << mod; self; end
  if have_owner
    targets = [["s", sing], ["i", mod]]
  else
    singleton_meths_186.call(mod, sing).each do |vis, m|
      puts "M\t#{nm}\ts\t#{vis}\t#{m}"
    end
    targets = [["i", mod]]
  end
  targets.each do |kind, target|
    [["pub",  :public_instance_methods],
     ["priv", :private_instance_methods],
     ["prot", :protected_instance_methods]].each do |vis, sel|
      meth_list.call(target, sel).each do |m|
        puts "M\t#{nm}\t#{kind}\t#{vis}\t#{m}"
      end
    end
  end
end

# --- special non-module objects (ENV, ARGF, main) ---
specials = []
begin
  specials.push(["ARGF", ARGF]) if defined?(ARGF)
rescue Exception
end
begin
  specials.push(["ENV", ENV]) if defined?(ENV)
rescue Exception
end
specials.push(["main", main_obj])

specials.each do |nm, obj|
  cls = begin
    safe_name.call(obj.class) || "?"
  rescue Exception
    "?"
  end
  puts "A\t#{nm}\tobject\t#{cls}\t"
  sing = class << obj; self; end
  if have_owner
    [["pub",  :public_instance_methods],
     ["priv", :private_instance_methods],
     ["prot", :protected_instance_methods]].each do |vis, sel|
      meth_list.call(sing, sel).each do |m|
        puts "M\t#{nm}\ts\t#{vis}\t#{m}"
      end
    end
  else
    singleton_meths_186.call(obj, sing).each do |vis, m|
      puts "M\t#{nm}\ts\t#{vis}\t#{m}"
    end
  end
end

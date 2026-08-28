# エントリ駆動プローブ: ARGV[0] を require し、標準入力の
# 「class \t typemark \t name」各行の実在を判定して結果を出力する。
# 出力: class \t typemark \t name \t verdict
#   verdict: ok / no-method / no-class / bad-name / lib-require-failed
libname = ARGV[0]
ARGV.clear  # test/unit 等の autorunner が ARGV を読むのを防ぐ
begin
  require libname
rescue LoadError, StandardError => e
  # require 自体が失敗したら全行その旨を返す
  $stdin.each_line do |l|
    c, t, n = l.chomp.split("\t", 3)
    puts [c, t, n, "lib-require-failed"].join("\t")
  end
  exit
end

def resolve(path)
  path.split("::").inject(Object) { |mod, name| mod.const_get(name, false) }
rescue NameError, TypeError
  nil
end

CACHE = {}
$stdin.each_line do |l|
  c, t, n, = l.chomp.split("\t", 3)
  verdict =
    if t == "$"
      # 特殊変数・グローバル変数(English 等)。エントリ名に $ が付かないので補う
      gv = n.start_with?("$") ? n : "$#{n}"
      begin
        eval("defined?(#{gv})") ? "ok" : "no-method"
      rescue SyntaxError, StandardError
        "bad-name"
      end
    else
      k = (CACHE.key?(c) ? CACHE[c] : (CACHE[c] = resolve(c)))
      if k.nil?
        "no-class"
      elsif !k.is_a?(Module)
        # クラスページが定数(オブジェクト)なことがある。その場合は特異メソッドで判定
        km = k.singleton_class rescue nil
        sym = n.to_sym rescue nil
        if km.nil? || sym.nil? then "bad-name"
        elsif km.method_defined?(sym) || km.private_method_defined?(sym) then "ok"
        else "no-method"
        end
      else
        sym = n.to_sym rescue nil
        if sym.nil?
          "bad-name"
        else
          case t
          when "#"
            found = k.method_defined?(sym) || k.private_method_defined?(sym)
            # mkmf 等は「Kernel の関数」として文書化されるが実体は Object へ include される
            found ||= (c == "Kernel" && (Object.method_defined?(sym) || Object.private_method_defined?(sym)))
            found ? "ok" : "no-method"
          when ".", ".#"
            sc = k.singleton_class
            found = sc.method_defined?(sym) || sc.private_method_defined?(sym)
            # module function は instance 側にもある
            found ||= (t == ".#" && (k.method_defined?(sym) || k.private_method_defined?(sym)))
            found ? "ok" : "no-method"
          when "::"
            begin
              k.const_defined?(sym, true) ? "ok" : "no-method"
            rescue NameError
              "bad-name"
            end
          else
            "bad-name"
          end
        end
      end
    end
  puts [c, t, n, verdict].join("\t")
end
$stdout.flush
exit!(0)  # test/unit 等の at_exit(autorunner)による出力汚染を防ぐ

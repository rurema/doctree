# require 可否の分類。結果は ENV['OUT'] のファイルに 1 語で書く(at_exit 汚染回避のため exit! する)
# ok / missing(ファイル不在) / loaderr(他の LoadError) / err:<Class>(ロード中エラー)
name = ARGV[0]
ARGV.clear
verdict =
  begin
    require name
    "ok"
  rescue LoadError => e
    e.message.include?("-- #{name}") ? "missing" : "loaderr"
  rescue Exception => e
    "err:#{e.class}"
  end
File.write(ENV["OUT"], verdict)
exit!(0)

require 'rack/static'

HTML_DIRECTORY_BASE = ENV.fetch("HTML_DIRECTORY_BASE", "/tmp/html/")

use Rack::Static, urls: [''], root: HTML_DIRECTORY_BASE, index: 'index.html', cascade: true
run do |env|
  path_info = env[Rack::PATH_INFO]
  if path_info == '/index.html'
    links = []
    Dir.glob(File.join(HTML_DIRECTORY_BASE, '*.*/doc/index.html')).each do |path|
      path = path.delete_prefix(HTML_DIRECTORY_BASE)
      links.push %Q[<li><a href="#{path}">#{path}</a></li>\n]
    end
    html = [<<-'HTML', *links.sort.reverse, <<-'HTML']
<!DOCTYPE html>
<html lang="ja-JP">
<head>
<meta name="robots" content="noindex">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<ul>
HTML
</ul>
</body>
</html>
HTML
    [200, {'content-type' => 'text/html; charset=utf-8'}, html]
  else
    [404, {'content-type' => 'text/plain; charset=utf-8'}, ["File not found: #{path_info}"]]
  end
end

require 'uri'

module URLHelper
  def valid_url(uri)
    uri = uri[5..-1] if uri[0..4] == 'url("'
    uri = uri[0..-3] if uri[-2..-1] == '")'
    return nil if uri !~ /^(http|https):/
    uri
  end

  def parse_url(url)
    return URI.parse(url) rescue URI.parse('')
  end

  def file_name(path)
    File.basename(path, File.extname(path))
  end
end
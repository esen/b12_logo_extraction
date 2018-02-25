require 'json'

class JsonBrowser < Browser
  WIDTH = 400
  HEIGHT = 800
  PIXEL_RATIO = 1
  TOUCH = false

  def navigate(file_path)
    @root = JSON(File.read(file_path))
    @host = @root['host']
  end

  def html_root_node
    JsonHtmlNode.new(@root, self)
  end

  def title
    @title || @root['title']
  end
end
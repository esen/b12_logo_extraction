class JsonHtmlNode < HtmlNode
  def initialize(element, browser)
    super(browser)
    @_element = element

    @tag_name          = element['tag_name']
    @id                = element['id']
    @href              = element['href']
    @src               = element['src']
    @data_original_src = element['data_original_src']
    @_class            = element['class']
    @background_image  = element['background_image']
    @text              = element['text']
    @alt               = element['alt']
    @visible_area      = element['visible_area'].to_i
    @x_coordinate      = element['x_coordinate'].to_i
    @y_coordinate      = element['y_coordinate'].to_i
  end

  def child_elements
    @_element['children'].map do |element|
      JsonHtmlNode.new(element, browser)
    end
  end
end
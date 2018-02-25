class GoogleChromeHtmlNode < HtmlNode
  def initialize(element, browser)
    super(browser)
    @_element = element

    @tag_name          = element.tag_name
    @id                = element.attribute(:id)
    @href              = element.attribute(:href)
    @src               = element.attribute(:src)
    @data_original_src = element.attribute('data-original-src')
    @_class            = element.attribute(:class)
    bi                 = element.css_value('background-image')
    @background_image  = (bi == 'none' ? nil : bi)
    @text              = element.css_value(:text)
    @alt               = element.css_value(:alt)
    @visible_area      = element.attribute(:clientHeight).to_i * element.attribute(:clientWidth).to_i
    @x_coordinate      = element.location.x
    @y_coordinate      = element.location.y
  end

  def child_elements
    @_element.find_elements(:xpath => '*').map do |element|
      GoogleChromeHtmlNode.new(element, browser)
    end
  end
end
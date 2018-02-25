class HtmlNode
  include URLHelper
  include RelevanceCalculator
  ACCEPTABLE_AREA = 200*600

  attr_accessor :browser,
                :relevance, :logo_url,
                :tag_name, :children,
                :id, :_class, :data_original_src,
                :href, :src, :background_image, :text, :alt,
                :visible_area, :x_coordinate, :y_coordinate


  def initialize(browser)
    @browser   = browser
    @children  = []
    @relevance ||= 0
  end

  def candidate?
    !self.logo_url.nil? && acceptable_logo_size?
  end

  # Checks if a 'href' attribute of this element navigates to any other website
  def navigates_to_other_site?
    if blank?(self.href)
      false
    else
      url = parse_url(self.href)

      url.host != browser.host
    end
  end

  def blank?(obj)
    !obj || obj.empty?
  end

  def acceptable_logo_size?
    self.visible_area && self.visible_area <= ACCEPTABLE_AREA
  end

  # id, class, and data_original_src of the element
  def element_identifiers
    _ei = self._class.to_s.split(' ').map(&:strip)
    _ei << self.id
    _ei << self.data_original_src
    _ei.reject(&:nil?).reject(&:empty?)
  end

  def child_elements
    raise Exception.new('This method must be overridden!')
  end
end
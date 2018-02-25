class Browser
  include URLHelper
  attr_accessor :tree, :title, :best_node, :host

  def scan(url)
    @tree = {}
    @best_node = nil

    navigate(url)
    @tree = html_root_node
    scan_element(@tree)
  end

  def scan_element(element)
    return if element.navigates_to_other_site?

    element.child_elements.each do |child_element|
      child_element.calculate_relevance(element.relevance)
      scan_element(child_element)

      if child_element.candidate?
        # Keep the best candidate found
        if (!self.best_node || self.best_node.relevance < child_element.relevance) && child_element.logo_url
          self.best_node = child_element
        end
      end
    end
  end

  def navigate(url)
    raise Exception.new('This method must be overridden!')
  end

  def html_root_node
    raise Exception.new('This method must be overridden!')
  end

  def title
    raise Exception.new('This method must be overridden!')
  end
end
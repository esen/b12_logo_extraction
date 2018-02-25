module RelevanceCalculator
  LOGO = 'logo'
  MAX_RELEVANCE = 1000

  def calculate_relevance(parent_relevance)
    # Child elements inherit relevance from their parents.
    # This is for cases where image url doesn't contain 'logo' string,
    # but it's parent elements have 'logo' in their id or class or data-original-src
    #
    # The relevance of parents are subtracted by 1 when passing to child elements.
    # This is because we assume, that images found in child elements are more relevant
    self.relevance = [parent_relevance - 1, 0].max

    calculate_common_relevance

    if tag_name == 'img' && src
      valid_url = valid_url(src)
      calculate_image_relevance(valid_url) if valid_url
    end

    if background_image
      valid_url = valid_url(background_image)
      calculate_image_relevance(valid_url) if valid_url
    end
  end

  # Relevance of any element NOT containing an image is calculated from element's id, class or data_original_src
  def calculate_common_relevance
    element_identifiers.each do |element_identifier|
      _relevance = _relevance(element_identifier)
      self.relevance = _relevance if self.relevance < _relevance
    end
  end

  def calculate_image_relevance(url)
    url = parse_url(url)
    _relevance = _relevance(file_name(url.path))

    if _relevance > self.relevance
      self.relevance = _relevance
      self.logo_url = url
    else
      return if self.logo_url

      # If has inherited relevance, set logo_url
      self.logo_url = url if self.relevance > 0
    end
  end


  # The simplest relevance calculation.
  def _relevance(sample)
    sample.downcase!

    # If image is not visible when site is opened, then we assume it can't be a logo
    return 0 if self.y_coordinate > browser.class::HEIGHT

    if sample !~ Regexp.new(LOGO)
      # if the sample doesn't contain word 'logo', check if it matches with page's title
      title_parts = browser.title.split(/[\W_]+/).map(&:downcase)
      sample_parts = sample.split(/[\W_]+/).map(&:downcase)

      return (title_parts & sample_parts).count
    end

    MAX_RELEVANCE - sample.gsub(LOGO, '').length
  end
end
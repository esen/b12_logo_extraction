require 'spec_helper'

describe HtmlNode do
  let!(:file_path) { './spec/fixtures/unit_test_fixture.json' }
  let!(:browser) do
    b = JsonBrowser.new
    b.scan(file_path)
    b
  end
  let!(:element) { HtmlNode.new(browser) }

  context '#initialize' do
    it 'should set defaults' do
      expect(element.browser).to eq(browser)
      expect(element.children).to eq([])
      expect(element.relevance).to eq(0)
    end
  end

  context '#candidate?' do
    it 'should return false if logo_url is not set' do
      element.logo_url = nil
      expect(element.candidate?).to be_falsey
    end

    it 'should return false if element\'s size is not acceptable' do
      element.logo_url = 'sample_image'
      expect(element).to receive(:acceptable_logo_size?).and_return(false)
      expect(element.candidate?).to be_falsey
    end

    it 'should return true otherwise' do
      element.logo_url = 'sample_image'
      expect(element).to receive(:acceptable_logo_size?).and_return(true)
      expect(element.candidate?).to be_truthy
    end
  end

  context '#navigates_to_other_site?' do
    it 'should return true if url domain in href does not match site\'s domain' do
      element.href = 'http://otherdomain.com'
      browser.host = 'samedomain.com'
      expect(element.navigates_to_other_site?).to be_truthy
    end

    it 'should return false if url domain in href matches site\'s domain' do
      element.href = 'http://samedomain.com'
      browser.host = 'samedomain.com'
      expect(element.navigates_to_other_site?).to be_falsey
    end

    it 'should return false if href is nil' do
      element.href = nil
      expect(element.navigates_to_other_site?).to be_falsey
    end
  end

  context '#acceptable_logo_size?' do
    it 'should return false if visible_area is nil' do
      element.visible_area = nil
      expect(element.acceptable_logo_size?).to be_falsey
    end

    it 'should return false if visible_area is more than acceptable area' do
      element.visible_area = HtmlNode::ACCEPTABLE_AREA + 1
      expect(element.acceptable_logo_size?).to be_falsey
    end

    it 'should return true if visible_area is equal or less than acceptable area' do
      element.visible_area = HtmlNode::ACCEPTABLE_AREA
      expect(element.acceptable_logo_size?).to be_truthy
    end
  end

  context '#element_identifiers' do
    it 'should return list containing id, classes and original_data_src of an element' do
      element.id = 'id'
      element._class = 'logo logo2'
      element.data_original_src = 'logosrc'
      expect(element.element_identifiers).to match_array ['id', 'logo', 'logo2', 'logosrc']
    end
  end
end
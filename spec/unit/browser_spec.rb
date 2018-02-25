require 'spec_helper'

describe Browser do
  let!(:file_path) { './spec/fixtures/unit_test_fixture.json' }
  let!(:browser) { JsonBrowser.new }
  let!(:root_element) { JsonHtmlNode.new(JSON(File.read(file_path)), browser) }
  before { allow(browser).to receive(:html_root_node).and_return(root_element) }

  describe '#scan' do
    subject { browser.scan(file_path) }

    it 'should set navigate to given url' do
      expect(browser).to receive(:navigate).with(file_path)
      subject
    end

    it 'should trigger scan on root element' do
      expect(browser).to receive(:scan_element).with(root_element)
      subject
    end
  end

  describe '#scan_element' do
    subject { browser.scan_element(root_element) }

    it 'should return if element navigates to other site' do
      expect(root_element).to receive(:navigates_to_other_site?).and_return(true)
      expect(root_element).not_to receive(:child_elements)
      subject
    end

    context 'when element does not navigate to other site' do
      before{
        expect(root_element).to receive(:navigates_to_other_site?).and_return(false)
        allow(root_element).to receive(:child_elements).and_return(root_element.child_elements)
      }
      let!(:child_element) { root_element.child_elements[0] }

      it 'should calculate relevance of each child element' do
        expect(child_element).to receive(:calculate_relevance).with(root_element.relevance)
        subject
      end

      it 'should call scan_element on child elements' do
        expect(browser).to receive(:scan_element).with(root_element).and_call_original
        expect(browser).to receive(:scan_element).with(child_element)
        subject
      end

      context 'when element is a candidate' do
        before {
          expect(child_element).to receive(:candidate?).and_return(true)
        }

        it 'should set the best_node if best' do
          child_element.logo_url = 'sample_url.png'
          child_element.relevance = 1000
          subject
          expect(browser.best_node).to eq(child_element)
        end
      end
    end
  end
end
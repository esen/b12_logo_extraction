require 'spec_helper'

describe RelevanceCalculator do
  let!(:file_path) { './spec/fixtures/unit_test_fixture.json' }
  let!(:browser) do
    b = JsonBrowser.new
    b.scan(file_path)
    b
  end

  let!(:parent_element) { browser.tree }
  let!(:child_element) { parent_element.child_elements[0] }
  let!(:sample_image) { 'https://sample_images.com/1.png' }


  describe '#calculate_relevance' do
    let!(:parent_relevance) { 100 }
    subject { child_element.calculate_relevance(parent_relevance) }

    it 'should set relevance from parent' do
      subject
      expect(child_element.relevance).to eq(parent_relevance - 1)
    end

    it 'should calculate common relevance' do
      expect(child_element).to receive(:calculate_common_relevance)
      subject
    end

    context 'when has valid src' do
      it 'should calculate image relevance from src attribute' do
        child_element.src = sample_image
        expect(child_element).to receive(:calculate_image_relevance).with(sample_image)
        subject
      end
    end

    context 'when src is not valid' do
      let!(:invalid_image_url) { 'not_valid.png' }

      it 'should not calculate image relevance if image is not a valid url' do
        child_element.src = invalid_image_url
        expect(child_element).not_to receive(:calculate_image_relevance)
        subject
      end
    end

    context 'when has valid background_image' do
      it 'should calculate image relevance from background_image attribute' do
        child_element.background_image = sample_image
        expect(child_element).to receive(:calculate_image_relevance).with(sample_image)
        subject
      end
    end
  end

  describe '#calculate_common_relevance' do
    before {
      allow(child_element).to receive(:element_identifiers).and_return(['some_id'])
      allow(child_element).to receive(:_relevance).and_return(1000)
    }

    it 'should set the highest relevance found' do
      child_element.relevance = 0
      child_element.calculate_common_relevance
      expect(child_element.relevance).to eq(1000)
      expect(child_element.logo_url).to eq(nil)
    end
  end

  describe '#calculate_image_relevance' do
    it 'should set the highest relevance found' do
      allow(child_element).to receive(:_relevance).and_return(1000)
      child_element.relevance = 0
      child_element.logo_url = nil
      child_element.calculate_image_relevance(sample_image)
      expect(child_element.relevance).to eq(1000)
      expect(child_element.logo_url.to_s).to eq(sample_image)
    end

    context 'if image url relevance is 0' do
      it 'should set logo_url if parent relevance is > 0' do
        allow(child_element).to receive(:_relevance).and_return(0)
        child_element.relevance = 5
        child_element.logo_url = nil
        child_element.calculate_image_relevance(sample_image)
        expect(child_element.relevance).to eq(5)
        expect(child_element.logo_url.to_s).to eq(sample_image)
      end
    end
  end

  describe '#_relevance' do
    context 'when element is not in the visible area' do
      before {
        child_element.y_coordinate = browser.class::HEIGHT + 1
      }

      it 'should return 0' do
        expect(child_element._relevance('logo')).to eq(0)
      end
    end

    context 'when sample has "logo" string' do
      it 'should return MAX_RELEVANCE - number of symbols around "logo" substring' do
        expect(child_element._relevance('xlogo_1')).to eq(RelevanceCalculator::MAX_RELEVANCE - 3)
      end
    end

    context 'when sample has not "logo" string' do
      context 'when sample has words matching the words in page title' do
        it 'should return number of matching words' do
          browser.title = 'Some Site title'
          expect(child_element._relevance('some sample name')).to eq(1)
        end
      end

      context 'when sample has no words matching the words in page title' do
        it 'should return 0' do
          browser.title = 'Some Site title'
          expect(child_element._relevance('sample name')).to eq(0)
        end
      end
    end


  end
end
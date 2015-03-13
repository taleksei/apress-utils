require File.expand_path('../../../../spec_helper', __FILE__)

describe Apress::Utils::StringTools do
  describe '#sanitize' do
    it 'removes style tags from string' do
      sanitized_string = described_class.sanitize('test string<style>body { color: red; }</style>')
      expect(sanitized_string).to eq 'test string'
    end

    it 'removes javascript from string' do
      sanitized_string = described_class.sanitize('test string<javascript>alert("ALERT");</javascript>' )
      expect(sanitized_string).to eq 'test string'
    end
  end
end

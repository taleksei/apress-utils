require 'spec_helper'

RSpec.describe Apress::Utils::UrlParser do
  let(:url) { 'http://www.google.com:80/some/path?http://www.example.org;foo=bar' }

  it 'correctly parses url with all of the parts present' do
    expect(described_class.extract_scheme(url)).to eq('http://')
    expect(described_class.extract_host(url)).to eq('www.google.com')
    expect(described_class.extract_port(url)).to eq(':80')
    expect(described_class.extract_path(url)).to eq('/some/path')
    expect(described_class.extract_query(url)).to eq('?http://www.example.org;foo=bar')
  end
end

# coding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe URI do
  context 'domains with underscore in hostname' do
    let(:link) { 'http://user:passwd@hello_world.example.com:1234/a/b/c?x=z#y' }
    let(:parsed_link) { URI.parse(link) }

    it do
      expect { parsed_link }.not_to raise_error
      expect(parsed_link.scheme).to eq 'http'
      expect(parsed_link.user).to eq 'user'
      expect(parsed_link.password).to eq 'passwd'
      expect(parsed_link.hostname).to eq 'hello_world.example.com'
      expect(parsed_link.port).to eq 1234
      expect(parsed_link.path).to eq '/a/b/c'
      expect(parsed_link.query).to eq 'x=z'
      expect(parsed_link.fragment).to eq 'y'
    end
  end

  context 'domains with unicode in hostname' do
    let(:link) { 'http://user:passwd@фермаежей.рф:1234/a/b/c?x=z#y' }
    let(:parsed_link) { URI.parse(link) }

    it do
      expect { parsed_link }.not_to raise_error
      expect(parsed_link.scheme).to eq 'http'
      expect(parsed_link.user).to eq 'user'
      expect(parsed_link.password).to eq 'passwd'
      expect(parsed_link.hostname).to eq 'xn--80ajbaetq5a8a.xn--p1ai'
      expect(parsed_link.port).to eq 1234
      expect(parsed_link.path).to eq '/a/b/c'
      expect(parsed_link.query).to eq 'x=z'
      expect(parsed_link.fragment).to eq 'y'
    end
  end
end

require 'spec_helper'

class ApplicationController < ActionController::Base
end

describe ApplicationController, type: :controller do
  context 'when cache is exist' do
    context 'when cache with content' do
      before do
        controller.perform_caching = true
        controller.write_fragment('test', layout: 'layout_text', content: 'content_text')
      end

      it 'read one time' do
        expect(controller.read_fragment('test')).to eq 'layout_text'
        expect(controller.cached_content_for).to eq(content: 'content_text')
      end

      it 'read two times' do
        controller.read_fragment('test')

        expect(controller.read_fragment('test')).to eq 'layout_text'
        expect(controller.cached_content_for).to eq(content: 'content_text')
      end
    end

    context 'when cache without content' do
      before do
        controller.perform_caching = true
        controller.write_fragment('test', layout: 'layout_text')
      end

      it do
        expect(controller.read_fragment('test')).to eq 'layout_text'
        expect(controller.cached_content_for).to eq({})
      end
    end
  end

  context 'when cache is not exist' do
    it 'read empty hash' do
      expect(controller.read_fragment('test')).to eq nil
      expect(controller.cached_content_for).to eq nil
    end
  end
end

# frozen_string_literal: true
require 'spec_helper'

RSpec.describe ActionView::Helpers::FormHelper, type: :helper do
  describe '#html_options_for_form' do
    let(:expected_html) do
      if ::Rails::VERSION::MAJOR < 4.2
        {
          'accept-charset' => 'UTF-8',
          'action' => '/spec',
        }
      else
        {
          'accept-charset' => 'UTF-8',
          'action' => '/spec',
          'onsubmit' => 'formSubmitter.disableButtons(this, null, null);',
        }
      end
    end
    let(:result) { helper.html_options_for_form({controller: :application, action: :show}, {}) }

    it do
      expect(result).to eq(expected_html)
    end
  end
end

# frozen_string_literal: true
require 'spec_helper'

RSpec.describe ActionView::Helpers::FormTagHelper, type: :helper do
  describe '#form_tag' do
    context 'without block' do
      let(:expected_html) do
        if ::Apress::Utils.rails40?
          "<form accept-charset=\"UTF-8\" accept-encoding=\"UTF-8\" action=\"/spec\" method=\"post\""\
            " onsubmit=\"formSubmitter.disableButtons(this, null, null);\">"\
            "<div style=\"margin:0;padding:0;display:inline\">"\
            "<input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div>"
        elsif ::Apress::Utils.rails41?
          "<form accept-charset=\"UTF-8\" accept-encoding=\"UTF-8\" action=\"/spec\" method=\"post\""\
            " onsubmit=\"formSubmitter.disableButtons(this, null, null);\">"\
            "<div style=\"display:none\">"\
            "<input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div>"
        else
          '<form onsubmit="formSubmitter.disableButtons(this, null, null);" action="/spec"'\
            ' accept-charset="UTF-8" accept-encoding="UTF-8" method="post">'\
            '<input name="utf8" type="hidden" value="&#x2713;" />'
        end
      end
      let(:result) { helper.form_tag({controller: :application, action: :show}, {method: :post}) }

      it do
        expect(result).to be_html_safe
        expect(result).to eq(expected_html)
      end
    end

    context 'with block' do
      let(:expected_html) do
        if ::Apress::Utils.rails40?
          "<form accept-charset=\"UTF-8\" accept-encoding=\"UTF-8\" action=\"/spec\" method=\"post\""\
            " onsubmit=\"formSubmitter.disableButtons(this, null, null);\">"\
            "<div style=\"margin:0;padding:0;display:inline\">"\
            "<input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div>"\
            "<input id=\"my_awesome_tag\" name=\"my_awesome_tag\" type=\"hidden\" value=\"100_500\" />"\
          "</form>"
        elsif ::Apress::Utils.rails41?
          "<form accept-charset=\"UTF-8\" accept-encoding=\"UTF-8\" action=\"/spec\" method=\"post\""\
            " onsubmit=\"formSubmitter.disableButtons(this, null, null);\">"\
            "<div style=\"display:none\">"\
            "<input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div>"\
            "<input id=\"my_awesome_tag\" name=\"my_awesome_tag\" type=\"hidden\" value=\"100_500\" />"\
          "</form>"
        else
          "<form onsubmit=\"formSubmitter.disableButtons(this, null, null);\" action=\"/spec\""\
            " accept-charset=\"UTF-8\" accept-encoding=\"UTF-8\" method=\"post\">"\
            "<input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" />"\
            "<input type=\"hidden\" name=\"my_awesome_tag\" id=\"my_awesome_tag\" value=\"100_500\" />"\
          "</form>"
        end
      end
      let(:result) do
        helper.form_tag({controller: :application, action: :show}, {method: :post}) do
          hidden_field_tag(:my_awesome_tag, '100_500')
        end
      end

      it do
        expect(result).to be_html_safe
        expect(result).to eq(expected_html)
      end
    end
  end
end

# frozen_string_literal: true
require 'spec_helper'

describe Apress::Utils::EmailValidation do
  shared_examples_for 'valid email' do |emails|
    emails.each do |email|
      it "#{email} matches regexp" do
        expect(email).to match Apress::Utils::EmailValidation.regexp
      end
    end
  end

  shared_examples_for 'invalid email' do |emails|
    emails.each do |email|
      it "#{email} does not match regexp" do
        expect(email).to_not match Apress::Utils::EmailValidation.regexp
      end
    end
  end

  context 'when email is valid' do
    it_behaves_like('valid email', %w{valid.email@email.com va-l-id_email@email.com validemail@email.com valid.email@e-mail.com valid_email@e.mail.com v3alid_email01@e.mail.com })
  end

  context 'when email is invalid' do
    it_behaves_like('invalid email', %w{inv&alidemail@email.com invalid.email@e_mail.com inv#alid-email@email.com envalid$email.com invalid@email invalid@email.96})
  end
end
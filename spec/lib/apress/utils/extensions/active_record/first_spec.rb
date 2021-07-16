# frozen_string_literal: true
require "spec_helper"

describe Apress::Utils::Extensions::ActiveRecord::FinderMethods do
  it "cache records" do
    expect { Person.first.inspect }.to make_database_queries(matching: /SELECT.*FROM.*people"\s*LIMIT 1/)
  end
end


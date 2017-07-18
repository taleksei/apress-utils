require 'spec_helper'

RSpec.describe Apress::Utils::Extensions::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter do
  it do
    if Apress::Utils.rails41?
      skip 'Need enum defaults patch'
    else
      expect(Person.new.state).to eq('pending')
      expect(Person.new.state_was).to eq('pending')
    end
  end
end

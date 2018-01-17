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

  it 'allow nil assignment' do
    person = Person.new

    person.state = nil

    expect(person.state).to be_nil
  end

  it { expect(Person.new.is_priority).to eq false }
end

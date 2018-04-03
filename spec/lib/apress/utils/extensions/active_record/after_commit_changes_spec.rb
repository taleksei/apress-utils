require 'spec_helper'

describe Apress::Utils::Extensions::ActiveRecord::AfterCommitChanges do
  let!(:person) { Person.create first_name: 'first', last_name: 'last' }

  before do
    Person.send(:include, Apress::Utils::Extensions::ActiveRecord::AfterCommitChanges)

    Person.transaction do
      person.update_attributes! first_name: 'new_first'
      person.update_attributes! last_name: 'new_last'
      person.save!
    end
  end

  it 'stores changes before next commit' do
    expect { person.save! }.to change { person.before_commit_changed }.from(%w(first_name last_name)).to([])
  end
end

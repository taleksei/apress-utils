# frozen_string_literal: true
require File.expand_path("../../../../../../spec_helper", __FILE__)

describe Apress::Utils::Extensions::ActiveRecord::GroupAttributes do
  context "common" do
    before do
      ActiveRecord::Base.connection.execute(<<-SQL)
        CREATE TABLE public.tmp_ar_model (
          id serial not null,
          group_name_prop_name integer
        );
      SQL

      class TmpArModel < ActiveRecord::Base
        self.table_name = 'tmp_ar_model'
        self.primary_key = 'id'

        include ::Apress::Utils::Extensions::ActiveRecord::GroupAttributes
      end

      @value = 336
      @record = TmpArModel.create(:group_name_prop_name => @value)
    end

    it "should work correctly with groups" do
      p = TmpArModel.first
      p[:group_name][:prop_name].should == @value
      p[:group_name].prop_name.should == @value
      p.group_name_prop_name.should == @value
    end
  end
end

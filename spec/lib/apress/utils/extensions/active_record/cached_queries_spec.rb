require "spec_helper"
require 'timecop'

describe Apress::Utils::Extensions::ActiveRecord::CachedQueries do
  let!(:model) do
    CachedQuery.tap do |klass|
      %i[@cached_queries_store @cache_options].each do |variable|
        klass.remove_instance_variable(variable) if klass.instance_variable_defined?(variable)
      end
    end
  end

  let!(:original_cached_queries_expires_in) { model.cached_queries_expires_in }
  let!(:original_cached_queries_local_expires_in) { model.cached_queries_local_expires_in }
  let!(:original_cached_queries_with_tags) { model.cached_queries_with_tags }

  before { Timecop.freeze }

  after do
    model.cached_queries_expires_in = original_cached_queries_expires_in
    model.cached_queries_local_expires_in = original_cached_queries_local_expires_in
    model.cached_queries_with_tags = original_cached_queries_with_tags
    Timecop.return
  end

  it "cache records" do
    model.create name: "test"
    expect(model.first).to be_present
    model.delete_all
    expect(model.first).to be_present
    Rails.cache.clear
    expect(model.first).to be_present
    model.reset_local_query_cache
    expect(model.first).to be_nil
  end

  context 'when cached_queries_expires_in is given' do
    before { model.cached_queries_expires_in = 3 }

    it "cache records with expires_in" do
      model.create name: "test"
      expect(model.first).to be_present
      model.delete_all
      expect(model.first).to be_present
      Timecop.freeze(Time.now + 4)
      expect(model.first).to be_nil
    end
  end

  context 'when cached_queries_local_expires_in is given' do
    let(:cached_at) { Time.now }

    before { model.cached_queries_local_expires_in = 3 }

    it 'records cache will not invalidated' do
      model.create name: "test"

      expect(model.first).to be_present
      model.delete_all
      expect(model.first).to be_present
      Timecop.freeze(cached_at + 4)
      expect(model.first).to be_present
    end

    context 'when cache store cleared' do
      it 'cache records with local_expires_in' do
        model.create name: "test"

        expect(model.first).to be_present
        model.delete_all
        Rails.cache.clear
        expect(model.first).to be_present
        Timecop.freeze(cached_at + 4)
        expect(model.first).to be_nil
      end
    end

    context 'when expires_in less than local_expires_in' do
      before { model.cached_queries_expires_in = 1 }

      it 'cache records with local_expires_in' do
        model.create name: "test"

        expect(model.first).to be_present
        model.delete_all
        expect(model.first).to be_present
        Timecop.freeze(cached_at + 2)
        expect(model.first).to be_present
        Timecop.freeze(cached_at + 4)
        expect(model.first).to be_nil
      end
    end

    context 'when expires_in great than local_expires_in' do
      before { model.cached_queries_expires_in = 5 }

      it 'cache records with expires_in' do
        model.create name: "test"

        expect(model.first).to be_present
        model.delete_all
        expect(model.first).to be_present
        Timecop.freeze(cached_at + 4)
        expect(model.first).to be_present
        Timecop.freeze(cached_at + 7)
        expect(model.first).to be_nil
      end
    end
  end

  it "don't cache it in run_without_cache block" do
    model.run_without_cache do
      model.create name: "test"
      expect(model.first).to be_present
      model.delete_all
      expect(model.first).to be_blank
    end
  end

  it "clear all caches" do
    model.create name: "test"
    expect(model.first).to be_present
    model.delete_all
    expect(model.first).to be_present
    Rails.cache.clear
    expect(model.first).to be_present
    model.reset_local_query_cache
    expect(model.first).to be_nil
  end

  context 'when cached queries with tags' do
    before { model.cached_queries_with_tags = true }

    it 'clears cache after destroy' do
      record = model.create name: 'test'
      expect(model.first).to be_present
      record.destroy
      expect(model.first).to be_nil
    end

    it 'clears cache after save' do
      record = model.create name: 'test'
      expect(model.first).to be_present
      record.update_attributes(name: 'test2')
      expect(model.first.name).to eq 'test2'
    end
  end

  context 'when cached_query_store is assigned' do
    before do
      Rails.application.config.cached_query_store = ActiveSupport::Cache::MemoryStore.new

      class TestModel < ActiveRecord::Base
        include Apress::Utils::Extensions::ActiveRecord::CachedQueries
      end

      TestModel.create name: "custom store"
    end

    after do
      Rails.application.config.cached_query_store = nil
    end

    it 'cache records in assigned store' do
      expect(TestModel.first).to be_present
      TestModel.delete_all
      expect(TestModel.first).to be_present
      Rails.cache.clear
      expect(TestModel.first).to be_present
      Rails.application.config.cached_query_store.clear
      TestModel.reset_local_query_cache
      expect(TestModel.first).to be_nil
    end
  end
end


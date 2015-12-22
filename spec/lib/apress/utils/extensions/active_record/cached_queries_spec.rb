require "spec_helper"

describe Apress::Utils::Extensions::ActiveRecord::CachedQueries do
  let(:model) { CachedQuery }
  let(:model_with_expire) { CachedQueryWithExpire }

  it "cache records" do
    model.create name: "test"
    expect(model.first).to be_present
    model.delete_all
    expect(model.first).to be_present
    Rails.cache.clear
    expect(model.first).to be_nil
  end

  it "cache records with expires_in" do
    model_with_expire.create name: "test"
    expect(model_with_expire.first).to be_present
    model_with_expire.delete_all
    expect(model_with_expire.first).to be_present
    sleep(5)
    expect(model_with_expire.first).to be_nil
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
    Rails.cache.clear
    expect(model.first).to be_nil
  end
end


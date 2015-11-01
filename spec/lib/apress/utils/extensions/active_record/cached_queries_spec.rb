require "spec_helper"

describe Apress::Utils::Extensions::ActiveRecord::CachedQueries do
  let(:model) { CachedQuery }

  it "cache records" do
    model.create name: "test"
    expect(model.first).to be_present
    model.delete_all
    expect(model.first).to be_present
    Redis.current.flushdb
    expect(model.first).to be_nil
  end

  it "clear cache after destroy" do
    record = model.create name: "test"
    expect(model.first).to be_present
    record.destroy
    expect(model.first).to be_nil
  end

  it "clear cache after save" do
    record = model.create name: "test"
    expect(model.first).to be_present
    record.update_attributes(name: "test2")
    expect(model.first.name).to eq "test2"
  end

  it "clear all caches" do
    model.create name: "test"
    expect(model.first).to be_present
    model.delete_all
    Rails.cache.clear
    expect(model.first).to be_nil
  end
end

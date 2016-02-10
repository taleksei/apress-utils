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

  context 'when cached queries with tags' do
    let(:model_with_tags) { CachedQueryWithTags }

    it 'clears cache after destroy' do
      record = model_with_tags.create name: 'test'
      expect(model_with_tags.first).to be_present
      record.destroy
      expect(model_with_tags.first).to be_nil
    end

    it 'clears cache after save' do
      record = model_with_tags.create name: 'test'
      expect(model_with_tags.first).to be_present
      record.update_attributes(name: 'test2')
      expect(model_with_tags.first.name).to eq 'test2'
    end
  end
end


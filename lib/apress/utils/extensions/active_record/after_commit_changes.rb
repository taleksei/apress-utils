# -*- encoding : utf-8 -*-
module Apress::Utils::Extensions::ActiveRecord::AfterCommitChanges
  extend ActiveSupport::Concern

  included do
    before_save :clear_before_commit_changes
    after_save  :store_before_commit_changes

    attribute_method_suffix '_before_commit_changed?', '_before_commit_was'
  end

  def before_commit_changed?
    !before_commit_changed_attributes.empty?
  end

  def before_commit_changed
    before_commit_changed_attributes.keys
  end

  protected

  def before_commit_changed_attributes
    @before_commit_changed_attributes ||= {}
  end

  def clear_before_commit_changes
    @before_commit_changed_attributes = {}
  end

  def store_before_commit_changes
    @before_commit_changed_attributes = self.changes
  end

  # Handle <tt>*_changed?</tt> for +method_missing+.
  def attribute_before_commit_changed?(attr)
    before_commit_changed_attributes.include?(attr)
  end

  # Handle <tt>*_was</tt> for +method_missing+.
  def attribute_before_commit_was(attr)
    attribute_before_commit_changed?(attr) ? before_commit_changed_attributes[attr] : __send__(attr)
  end
end
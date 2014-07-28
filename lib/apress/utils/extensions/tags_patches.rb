# -*- encoding : utf-8 -*-
if defined?(ActsAsTaggableOn::Tag)
  ActsAsTaggableOn::Tag.class_eval do
    def self.named(name)
      where(["lower(name) = ?", name.mb_chars.downcase])
    end

    def self.named_any(list)
      where(["lower(name) in (?)", list.map{|tag| tag.mb_chars.downcase } ])
    end

    def self.named_like(name)
      where(["name #{like_operator} ?", "%#{name.mb_chars.downcase}%"])
    end

    def self.named_like_any(list)
      where(list.map { |tag| sanitize_sql(["lower(name) LIKE ?", "%#{tag.to_s.mb_chars.downcase}%"]) }.join(" OR "))
    end
  end
end

module Apress::Utils::Extensions::ActiveRecord::GroupAttributes
  attr_accessor :group_prefix

  def add_group_prefix(prefix)
    @group_prefix = @group_prefix.to_s + prefix.to_s + '_'
    self
  end

  def method_missing(symbol, *args)
    method = (self.group_prefix.to_s + symbol.to_s).to_sym

    if respond_to? method
      send method, *args
    else
      super
    end
  end

  def [](symbol)
    if respond_to? symbol
      send symbol
    elsif respond_to?(method = (self.group_prefix.to_s + symbol.to_s).to_sym)
      send method
    else
      self.clone.add_group_prefix(symbol.to_s)
    end
  end
end
module ActiveSupport
  class << self
    delegate :time_precision, :time_precision, to: :'ActiveSupport::JSON::Encoding'
  end

  module JSON
    module Encoding
      class << self
        # Sets the precision of encoded time values.
        # Defaults to 3 (equivalent to millisecond precision)
        attr_accessor :time_precision
      end

      self.time_precision = 3
    end
  end
end

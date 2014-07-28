# -*- encoding : utf-8 -*-
module Apress
  module Utils
    module Coalesce
      def coalesce(*args)
        args.compact.first
      end
    end
  end
end

# coding: utf-8
# frozen_string_literal: true
module Apress
  module Utils
    module Extensions
      module Uri
        module ParsersOverrides
          extend ActiveSupport::Concern

          included do
            alias_method :_original_split, :split

            # хак, фиксит работу с доменами, в которых есть "_" и переводит в punycode
            # source: http://stackoverflow.com/a/17108137/2091157
            def split(url)
              return _original_split(url) unless url

              a = ::Addressable::URI.parse(url).normalize
              [a.scheme, a.userinfo, a.host, a.port, nil, a.path, nil, a.query, a.fragment]
            end
          end
        end
      end
    end
  end
end

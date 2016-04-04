# coding: utf-8
require 'open-uri'
require 'addressable/uri'

# хак, фиксит работу с доменами, в которых есть "_" и переводит в punycode
# source: http://stackoverflow.com/a/17108137/2091157
module URI
  class Parser
    def split(url)
      a = Addressable::URI.parse(url).normalize
      [a.scheme, a.userinfo, a.host, a.port, nil, a.path, nil, a.query, a.fragment]
    end
  end
end

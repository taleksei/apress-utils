module Rack
  module Multipart
    class Parser
      # Исправляет ошибку при загрузке файлов в именами содержащими знак %
      #
      # Взято из [rack 1.4.5](https://github.com/rack/rack/blob/1.4.5/lib/rack/multipart/parser.rb#L126-144),
      # который подключается в [rails 3.2](https://github.com/rails/rails/blob/v3.2.22.2/actionpack/actionpack.gemspec#L26)
      def get_filename(head)
        filename = nil
        if head =~ RFC2183
          filename = Hash[head.scan(DISPPARM)]['filename']
          filename = $1 if filename and filename =~ /^"(.*)"$/
        elsif head =~ BROKEN_QUOTED
          filename = $1
        elsif head =~ BROKEN_UNQUOTED
          filename = $1
        end

        if filename && filename.scan(/%.?.?/).all? { |s| s =~ /%[0-9a-fA-F]{2}/ }
          filename = Utils.unescape(filename)
        end
        if filename && filename !~ /\\[^\\"]/
          filename = filename.gsub(/\\(.)/, '\1')
        end
        filename
      end
    end
  end
end

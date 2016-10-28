class CachedQueryWithExpire < ActiveRecord::Base
  self.table_name = 'cached_queries'
  include Apress::Utils::Extensions::ActiveRecord::CachedQueries
  self.cached_queries_expires_in = 3
end

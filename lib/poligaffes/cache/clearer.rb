module Poligaffes
  module Cache
    module Clearer

      def clear_homepage_cache
        Rails.cache.delete_matched 'home-'
      end

    end # module Clearer
  end # module Cache
end # module Poligaffes
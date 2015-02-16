module Poligaffes
  module Cache
    module Clearer

      def clear_homepage_cache
        Rails.cache.delete_matched 'home-'
      end

      def clear_yair_page_cache
        Rails.cache.delete_matched "yairs/#{self.yair.id}"
      end

    end # module Clearer
  end # module Cache
end # module Poligaffes
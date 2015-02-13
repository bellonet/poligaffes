require 'time'
require 'poligaffes/facebook/errors'

module Poligaffes
  module Facebook

    class ApiPool
      def initialize(*graphs)
        @apis = graphs.map { |g| [g, 'ok'] }
      end

      def method_missing(sym, *args, &block)
        @apis.count.times do |i|
          api = get_nothrottle_api()
          begin
            return api[0].__send__ sym, *args, &block
          rescue Koala::Facebook::ClientError => e
            if [17, 613].include? e.fb_error_code # API RATE LIMIT
              api[1] = 'throttled'
              $stderr.write " Graph API Error: #{e.inspect} "
              next
            else
              raise e
            end
          end
        end
        raise "Poligaffes::Facebook::ApiPool Ran out of APIs in pool... "
      end

      private

      def get_nothrottle_api
        @apis.each do |api|
          return api if api[1] == 'ok'
        end
      end
    end

  end # module Facebook
end # module Poligaffes
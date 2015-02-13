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
            api[1] = 'throttled'
            $stderr.write " Graph API Error: #{e.inspect} "
            next
          end
        end
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
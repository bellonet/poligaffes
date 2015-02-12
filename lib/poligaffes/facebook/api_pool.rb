require 'time'
require 'poligaffes/facebook/errors'

module Poligaffes
  module Facebook

    class ApiPool
      def initialize(*graphs)
        @apis = graphs.map { |g| [g, DateTime.new(0)] }
      end

      def method_missing(sym, *args, &block)
        @apis.each do |api|
          begin
            return api[0].__send__ sym, *args, &block
          rescue Koala::Facebook::ClientError => e
            $stderr.write " Graph API Error: #{e.inspect} "
            next
          end
        end
      end
    end

  end # module Facebook
end # module Poligaffes
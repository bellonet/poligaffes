require 'koala'
require 'pry'

module Poligaffes
  module Facebook
    module Errors
      def call_with_retries &block
        while true do
          begin
            $stdout.write(',')
            block.call()
            break
          rescue Koala::Facebook::ServerError => e
            $stderr.write " Graph API Error: #{e.inspect} "
            #   2: Temporary issue due to downtime - retry the operation after waiting.
            #   4: Temporary issue due to throttling - retry the operation after waiting and examine your API request volume.
            #  17: Temporary issue due to throttling - retry the operation after waiting and examine your API request volume.
            # 341: Temporary issue due to downtime or throttling - retry the operation after waiting and examine your API request volume.
            if not [2, 4, 17, 341].include? e.fb_error_code
              raise e
            end
            sleep 3
            $stderr.write "retrying"
          end
        end
      end
    end
  end
end
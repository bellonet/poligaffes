require 'koala'

module Poligaffes
  module Facebook
    module Errors

      NUM_RETRIES = 10
      WAIT_SECONDS = 5
      def call_with_retries &block
        success = false
        NUM_RETRIES.times do
          begin
            $stdout.write(',')
            return block.call()
            success = true
            break
          rescue Koala::Facebook::ServerError => e
            $stderr.write " Graph API Error: #{e.inspect} "
            #   1: Possibly a temporary issue due to downtime - retry the operation after waiting, if it occurs again, check you are requesting an existing API.
            #   2: Temporary issue due to downtime - retry the operation after waiting.
            #   4: Temporary issue due to throttling - retry the operation after waiting and examine your API request volume.
            #  17: Temporary issue due to throttling - retry the operation after waiting and examine your API request volume.
            # 341: Temporary issue due to downtime or throttling - retry the operation after waiting and examine your API request volume.
            if not [1, 2, 4, 17, 341].include? e.fb_error_code
              raise e
            end
            $stderr.write "sleeping #{WAIT_SECONDS} seconds. "
            sleep WAIT_SECONDS
            $stderr.write "retrying"

          rescue Koala::Facebook::ClientError => e
            if e.fb_error_code = 613 # API RATE LIMIT
              raise e
            end
            $stderr.write e.message
            $stderr.write "\n SKIPPING!\n"
            return nil
          end
        end
        unless success
          $stderr.write "\n"
          $stderr.write "Too many errors. Skipping this one for now.\n"
          return nil
        end
      end
    end
  end
end
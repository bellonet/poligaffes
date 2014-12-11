require 'time'
require 'poligaffes/facebook/errors'

class SinceRespectingCursor
  include Enumerable
  include Poligaffes::Facebook::Errors

  def initialize(g, method_name, *args)
    @g = g
    @method_name = method_name
    @args = args
    if @args[-1].is_a?(Hash) && args[-1].has_key?(:since)
      @since = args[-1][:since]
    else
      @since = nil
    end

  end

  def each
    call_with_retries do
      @posts = @g.__send__(@method_name, *@args)
    end
    if @posts and @posts.any?
      reached_past_since_limit = false
      while true do
        @posts.each do |p|
          if @since && DateTime.strptime(p['created_time']) < @since
            reached_past_since_limit = true
            break
          end
          yield p
        end
        break if reached_past_since_limit
        call_with_retries do
          @posts = @posts.next_page
        end
        break if not @posts
      end
    end
  end
end
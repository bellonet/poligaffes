require 'time'
require 'koala'

class SinceRespectingCursor
  include Enumerable

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
    @posts = @g.__send__(@method_name, *@args)
    if @posts.any?
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
        @posts = @posts.next_page
      end
    end
  end
end
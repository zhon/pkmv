
require 'thread'

class ThreadPool

  Q_END = Object.new

  def initialize(thread_count)
    @thread_count = thread_count
    @queue = Queue.new
    @threads = []
  end

  # Item must be a proc or lambda
  def push item
    @queue.push item
  end
  alias :<< push

  def process
    @threads = @thread_count.times.map do
      Thread.new do
        until (item = @queue.pop) == Q_END
          item.call
        end
      end
    end
  end

  def finish
    @thread_count.times { @queue << Q_END }
    @threads.each(&:join)
  end

end

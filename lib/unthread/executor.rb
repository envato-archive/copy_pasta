module Unthread
  class Executor
    attr_reader :promises

    def initialize(num_threads)
      @thread_pool = Concurrent::FixedThreadPool.new(num_threads)
      @promises    = []
    end

    def queue(&block)
      future = Concurrent::Promise.new(executor: @thread_pool, &block)
      @promises << future.execute
    end

    def run
      Concurrent::Promise.zip(*@promises).value!
    end
  end
end

module CopyPasta
  # Public: Executes work across threads.
  class Executor
    # Public: Array of Concurrent::Promise to execute.
    attr_reader :promises

    # Public: Creates an instance of Executor.
    #
    # num_threads - Number of threads to use.
    def initialize(num_threads)
      @thread_pool = Concurrent::FixedThreadPool.new(num_threads)
      @promises    = []
    end

    # Public: Queue work to be done across threads.
    #
    # block - Block to be executed when called.
    def queue(&block)
      future = Concurrent::Promise.new(executor: @thread_pool, &block)
      @promises << future.execute
    end

    # Public: Executes all Concurrent::Promises queued and waits for their
    # return values
    def run
      Concurrent::Promise.zip(*@promises).value!
    end
  end
end

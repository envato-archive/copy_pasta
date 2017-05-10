module Unthread
  class DirectoryCreator

    def self.run(directories, output_dir, threads: 100)
      creator = new(directories, output_dir, threads)
      creator.queue
      creator.shutdown
    end

    attr_reader :pool

    def initialize(directories, output_dir, threads)
      @directories = directories
      @output_dir  = output_dir
      @created     = Concurrent::Array.new
      @pool        = Concurrent::FixedThreadPool.new(threads, max_queue: 0)
    end

    def queue
      @directories.sort_by(&:size).reverse_each do |dir|
        pool.post do
          next if @created.include?(dir.fetch(:file_name))

          FileUtils.mkdir_p(File.join(@output_dir, dir.fetch(:file_name)), mode: dir.fetch(:mode))
          @created.concat Unthread::ParentDirectory.find(dir.fetch(:file_name))
        end
      end
    end

    def shutdown
      pool.shutdown
      pool.wait_for_termination
    end
  end
end

module Unthread
  class FileCreator

    def self.run(files, output_dir, threads: 100)
      creator = new(files, output_dir, threads)
      creator.queue
      creator.shutdown
    end

    attr_reader :pool

    def initialize(files, output_dir, threads)
      @files      = files
      @output_dir = output_dir
      @pool       = Concurrent::FixedThreadPool.new(threads, max_queue: 0)
    end

    def queue
      @files.each do |file|
        pool.post do
          File.open(File.join(@output_dir, file.fetch(:file_name)), "wb", perm: file.fetch(:mode)) do |io|
            io.write(file.fetch(:content))
          end
        end
      end
    end

    def shutdown
      pool.shutdown
      pool.wait_for_termination
    end
  end
end

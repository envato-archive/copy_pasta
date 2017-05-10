module Unthread
  class DirectoryCreator

    def self.run(directories, output_dir, threads: 100)
      creator = new(directories, output_dir, threads)
      creator.queue
      creator.shutdown
    end

    attr_reader :executor

    def initialize(directories, output_dir, threads)
      @directories = directories
      @output_dir  = output_dir
      @created     = Concurrent::Array.new
      @executor    = Unthread::Executor.new(threads)
    end

    def queue
      @directories.sort_by(&:size).reverse_each do |dir|
        executor.queue do
          next if @created.include?(dir.fetch(:file_name))

          FileUtils.mkdir_p(File.join(@output_dir, dir.fetch(:file_name)), mode: dir.fetch(:mode))
          @created.concat Unthread::ParentDirectory.find(dir.fetch(:file_name))
        end
      end
    end

    def shutdown
      executor.run
    end
  end
end

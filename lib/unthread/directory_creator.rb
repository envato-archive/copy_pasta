module Unthread
  # Public: Concurrently creates directories.
  class DirectoryCreator
    # Public: Creates directories in the given output dir.
    #
    # directories - Array of paths to create.
    # output_dir  - String path to the output directory.
    # threads     - Number of threads used for directory creation.
    # Default is 100.
    def self.run(directories, output_dir, threads: 100)
      creator = new(directories, output_dir, threads)
      creator.queue
      creator.run
    end

    # Public: The thread manager for creating directories
    attr_reader :executor

    # Public: Initialize a new DirectoryCreator.
    #
    # directories - Array of paths to create.
    # output_dir  - String path to the output directory.
    # threads     - Number of threads to use for directory creation
    def initialize(directories, output_dir, threads)
      @directories = directories
      @output_dir  = output_dir
      @created     = Concurrent::Array.new
      @executor    = Unthread::Executor.new(threads)
    end

    # Public: Adds all directories to the queue to be created.
    def queue
      @directories.sort_by(&:size).reverse_each do |dir|
        executor.queue { create_directory(dir[:file_name], dir[:mode]) }
      end
    end

    # Public: Creates all directories.
    def run
      executor.run
    end

    private

    # Private: Recursively creates the given directory while tracking the
    # parents it created.
    #
    # dir  - String directory to create.
    # mode - Numeric directory permissions(chmod).
    def create_directory(dir, mode)
      return if @created.include?(dir)

      FileUtils.mkdir_p(File.join(@output_dir, dir), mode: mode)
      @created.concat Unthread::ParentDirectory.find(dir)
    end
  end
end

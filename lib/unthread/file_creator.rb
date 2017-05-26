module Unthread
  # Public: Concurrently creates files.
  class FileCreator
    # Public: Creates files in the given output dir.
    #
    # files      - Array of files to create.
    # output_dir - String path to the output directory.
    # threads    - Number of threads to use for file creation. Default is 100.
    def self.run(files, output_dir, threads: 100)
      creator = new(files, output_dir, threads)
      creator.create_work
      creator.run
    end

    # Public: The thread manager for creating directories
    attr_reader :executor

    # Public: Initialize a new FileCreator.
    #
    # files      - Array of files to create.
    # output_dir - String path to the output directory.
    # threads    - Number of threads to use for directory creation
    def initialize(files, output_dir, threads)
      @files      = files
      @output_dir = output_dir
      @executor   = Unthread::Executor.new(threads)
    end

    # Public: Adds all files to the queue to be created.
    def create_work
      @files.each do |file|
        executor.queue { file.copy_file(@output_dir) }
      end
    end

    # Public: Creates all files.
    #
    # Returns an array of files created
    def run
      executor.run
      @files.map { |file| File.join(@output_dir, file.relative_file_name) }
    end
  end
end

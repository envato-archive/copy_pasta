module Unthread
  # Public: Concurrently creates files.
  class FileCreator


    # Public: Creates files in the given output dir.
    #
    # directories - Array of paths to create.
    # output_dir  - String path to the output directory.
    # threads     - Number of threads to use for file creation. Default is 100.
    def self.run(files, output_dir, threads: 100)
      creator = new(files, output_dir, threads)
      creator.queue
      creator.shutdown
    end

    # Public: The thread manager for creating directories
    attr_reader :executor

    # Public: Initialize a new FileCreator.
    #
    # files       - Array of files to create.
    # output_dir  - String path to the output directory.
    # threads     - Number of threads to use for directory creation
    def initialize(files, output_dir, threads)
      @files      = files
      @output_dir = output_dir
      @executor   = Unthread::Executor.new(threads)
    end

    # Public: Adds all files to the queue to be created.
    def queue
      @files.each do |file|
        executor.queue { create_file(**file.to_hash) }
      end
    end

    # Public: Shutsdown the Unthread::Executor.
    def shutdown
      executor.run
    end

    private

    # Public: Writes a file to the output_dir.
    #
    # file    - String path to the file.
    # mode    - Numeric file permission(chmod).
    # content - String contents of the file.
    def create_file(file_name:, mode:, content:)
      File.open(File.join(@output_dir, file_name), "wb", perm: mode) do |io|
        io.write(content)
      end
    end
  end
end

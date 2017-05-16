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

      start = Time.now
      output = Concurrent::TimerTask.new(execution_interval: 1) do
        processed    = creator.executor.completed_task_count
        files_per_sec = processed / (Time.now - start)
        percent      = (processed / creator.files.size.to_f) * 100

        print "\f%.2f r/s - %d/%d %d%%" % [reqs_per_sec, processed, creator.files.size, percent]
      end


      output.execute
      creator.create_work
      creator.run
      output.shutdown
      puts
    end

    # Public: The thread manager for creating directories
    attr_reader :executor

    attr_reader :files

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
    def create_work
      @files.each do |file|
        executor.queue { create(file[:file_name], file[:mode], file[:content]) }
      end
    end

    # Public: Creates all files.
    def run
      executor.run
    end

    private

    # Public: Writes a file to the output_dir.
    #
    # file    - String path to the file.
    # mode    - Numeric file permission(chmod).
    # content - String contents of the file.
    def create(file_name, mode, content)
      File.open(File.join(@output_dir, file_name), "wb", perm: mode) do |io|
        io.write(content)
      end
    end
  end
end

module Unthread
  class FileCreator

    def self.run(files, output_dir, threads: 100)
      creator = new(files, output_dir, threads)
      creator.queue
      creator.shutdown
    end

    attr_reader :executor

    def initialize(files, output_dir, threads)
      @files      = files
      @output_dir = output_dir
      @executor   = Unthread::Executor.new(threads)
    end

    def queue
      @files.each do |file|
        executor.queue do
          File.open(File.join(@output_dir, file.fetch(:file_name)), "wb", perm: file.fetch(:mode)) do |io|
            io.write(file.fetch(:content))
          end
        end
      end
    end

    def shutdown
      executor.run
    end
  end
end

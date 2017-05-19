module Unthread
  # Public: Reads files and directories from a given path.
  class DirectoryReader
    # Public: Creates an instance of DirectoryReader.
    #
    # directory - The directory to read files and folders from.
    # pattern   - A regex to match specific files and directories.
    def initialize(directory, pattern = nil)
      @directory = directory
      @pattern   = pattern ? Regexp.new(pattern) : false
      @entries   = io_reader
    end

    # Public: List of directories from the given path.
    #
    # Returns an Array
    def directories
      matching_files.select(&:directory?)
    end

    # Public: List of files from the given path.
    #
    # Returns an Array
    def files
      matching_files.select(&:file?)
    end

    private

    # Private: Iterates through a directory creating an FileAttribute instance
    # for each file.
    #
    # Returns an Array of FileAttribute
    def io_reader
      Dir.glob(File.join(@directory, "/**/*")).map do |path|
        FileAttribute.new(path, @directory)
      end
    end

    # Private: Builds a list of files and directories to copy.
    #
    # Returns an Array
    def matching_files
      return @entries unless @pattern
      @entries.select { |entry| entry.file_name.match(@pattern) }
    end
  end
end

module Unthread
  # Public: Reads files and directories from a tar archive.
  class TarReader
    # Public - Creates an instance of Entry.
    #
    # tar     - String path to the tar file to extract.
    # pattern - A regex to extract specific files and directories.
    def initialize(tar, pattern = nil)
      @tar     = File.expand_path(tar)
      @pattern = pattern ? Regexp.new(pattern) : false
      @entries = tar_reader.to_a
    end

    # Public: List the directories in a tar
    #
    # Returns Array
    def directories
      matching_files.select { |entry| entry[:directory] }
    end

    # Public: List the files in a tar
    #
    # Returns Array
    def files
      matching_files.select { |entry| entry[:file] }
    end

    private

    # Private: Determines how to read the stream from a given tar or tar.gz.
    #
    # Returns a Zlib::GzipReader or String
    def io_reader
      Zlib::GzipReader.new(File.open(@tar))
    rescue Zlib::GzipFile::Error
      @tar
    end

    # Private: Creates a Minitar reader
    #
    # Returns an instance of Archive::Tar::Minitar::Input
    def tar_reader
      Archive::Tar::Minitar::Input.new(io_reader)
    end

    # Private: Read each entry from a tar file.
    #
    # Returns an Array
    def matching_files
      return @entries unless @pattern
      @entries.select { |entry| entry[:file_name].match(@pattern) }
    end
  end
end

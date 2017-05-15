module Unthread
  # Public: Reads files and directories from a tar archive.
  class Entry
    # Public - Creates an instance of Entry.
    #
    # tar     - String path to the tar file to extract.
    # pattern - A regex to extract specific files and directories.
    def initialize(tar, pattern = nil)
      @tar        = File.expand_path(tar)
      @tar_reader = Archive::Tar::Minitar::Input.new(stream_reader)
      @entries    = []
      @pattern    = pattern ? Regexp.new(pattern) : false
      read_tar
    end

    # Public: List the directories in a tar
    #
    # Returns Array
    def directories
      @entries.select { |entry| entry[:directory] }
    end

    # Public: List the files in a tar
    #
    # Returns Array
    def files
      @entries.reject { |entry| entry[:directory] }
    end

    private

    # Private: Determines how to read the stream from a given tar or tar.gz.
    #
    # Returns a Zlib::GzipReader or String
    def stream_reader
      Zlib::GzipReader.new(File.open(@tar))
    rescue Zlib::GzipFile::Error
      @tar
    end

    # Private: Read each entry from a tar file.
    def read_tar
      @tar_reader.each_entry do |entry|
        next unless entry.file? || entry.directory?

        if !@pattern || entry.full_name.match(@pattern)
          @entries << entry.to_hash
        end
      end
    end
  end
end

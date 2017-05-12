module Unthread
  # Public: Reads files and directories from a tar archive.
  class Entry
    # Public: Array of files within an archive.
    attr_reader :files

    # Public: Array of directories within an archive.
    attr_reader :directories

    # Public - Creates an instance of Entry.
    #
    # tar - String path to the tar file to extract.
    def initialize(tar)
      @tar         = File.expand_path(tar)
      @tar_reader  = Archive::Tar::Minitar::Input.new(stream_reader)
      @files       = []
      @directories = []
      read_tar
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
        hash = entry.to_hash

        if entry.file?
          @files << hash
        elsif entry.directory?
          @directories << hash
        end
      end
    end
  end
end

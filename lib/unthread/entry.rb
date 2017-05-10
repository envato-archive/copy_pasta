module Unthread
  class Entry
    attr_reader :files, :directories

    def initialize(tar)
      @tar         = File.expand_path(tar)
      @tar_reader  = Archive::Tar::Minitar::Input.new(reader)
      @files       = []
      @directories = []
      read_tar
    end

    private

    def reader
      begin
        Zlib::GzipReader.new(File.open(@tar))
      rescue Zlib::GzipFile::Error
        File.open(@tar)
      end
    end

    def read_tar
      @tar_reader.each_entry do |entry|
        if entry.file?
          @files << {
            file_name: entry.full_name,
            mode: entry.mode,
            content: entry.read,
          }
        elsif entry.directory?
          @directories << {
            file_name: entry.full_name,
            mode: entry.mode,
          }
        end
      end
    end
  end
end

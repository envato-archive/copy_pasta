module Unthread
  class Entry
    attr_reader :files, :directories

    def initialize(tar)
      @tar         = Archive::Tar::Minitar::Input.new(File.open(File.expand_path(tar)))
      @files       = []
      @directories = []
      read_tar
    end

    private

    def read_tar
      @tar.each_entry do |entry|
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

module Unthread
  # Public: Reads the file attributes for a given file.
  class FileAttribute
    extend Forwardable

    def_delegators :@stat, :file?, :directory?, :mode, :size

    # Public: Creates an instance of FileAttribute
    #
    # file     - The path to the file to read attributes from.
    # base_dir - The base directory of the source.
    def initialize(file, base_dir)
      @file = file
      @stat = File.stat(@file)
      @base_dir = base_dir
    end

    # Public: The full path to the source file
    #
    # Returns String
    def file_name
      @file
    end

    # Public: The file_name with the base_dir removed
    #
    # Returns String
    def relative_file_name
      @file.sub(%r{\A#{@base_dir}/}, "")
    end

    def copy_file(destination)
      FileUtils.cp(file_name, File.join(destination, relative_file_name))
    end

    def create_directory(destination)
      FileUtils.mkdir_p(File.join(destination, relative_file_name), mode: mode)
    end
  end
end

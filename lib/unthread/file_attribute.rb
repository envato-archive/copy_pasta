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
      @file     = file
      @stat     = File.stat(@file)
      @base_dir = Regexp.escape(base_dir)
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

    # Public: Copies the file to the destination.
    #
    # destination_directory - The target directory to copy the file to.
    #
    # Returns Array
    def copy_file(destination_directory)
      File.open(File.join(destination_directory, relative_file_name), "wb", perm: mode) do |io|
        io.write(content)
      end
    end

    # Public: Creates the directory in the given destination_directory
    #
    # destination_directory - The target to create the directory in.
    def create_directory(destination_directory)
      FileUtils.mkdir_p(File.join(destination_directory, relative_file_name), mode: mode)
    end

    private

    # Private: Read the contents of the source file
    #
    # Returns an IO
    def content
      File.read(file_name)
    end
  end
end

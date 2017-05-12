module Unthread
  # Public: Detects the parent paths of a given directory
  class ParentDirectory
    class << self
      # Public: Find all the parent directories of a given path
      #
      # path - String path to the directory to find parents.
      def find(path)
        pd = new(path)
        pd.parents
      end
    end

    # Public: Array of parent directories
    attr_reader :parents

    # Public: Creates an instances of ParentDirectory.
    #
    # path - String path to the directory to find parents.
    def initialize(path)
      @path    = path.gsub(/\/{1,}+/, '/')
      @parents = find_parents.tap { |parent| parent.delete('/') }
      @parents.map! { |parent| File.join(parent, '/') }
    end

    private

    # Public: Walks up the path to find each parent directory.
    #
    # Returns an Array of parent directories
    def find_parents
      @path.count("/").times.map do
        new_path = File.dirname(@path)
        @path = new_path unless %w(/ .).include?(new_path)
      end.compact
    end
  end
end

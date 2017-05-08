module Unthread
  class ParentDirectory
    class << self
      def find(path)
        pd = new(path)
        pd.parents
      end
    end

    attr_reader :parents

    def initialize(path)
      @path    = path.gsub(/\/{1,}+/, '/')
      @parents = find_parents.tap { |p| p.delete('/') }
      @parents.map! { |parent| File.join(parent, '/') }
    end

    private

    def find_parents
      @path.count("/").times.map do
        new_path = File.dirname(@path)
        @path = new_path unless %w(/ .).include?(new_path)
      end.compact
    end
  end
end

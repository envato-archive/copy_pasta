module CoreExtensions
  # Public: Adds to_hash to Archive::Tar::Minitar::Reader::EntryStream.
  module MinitarEntryStream
    # Public: Converts a tar entry to a hash.
    #
    # Returns a Hash.
    def to_hash
      { file_name: full_name, mode: mode, content: read, directory: directory?, file: file? }
    end
  end

  # Public: Adds the map method to Input
  module MinitarMap
    # Public: Converts entries to an array
    #
    # Returns an Array
    def to_a
      each_entry.map(&:to_hash).select { |entry| entry[:directory] || entry[:file] }
    end
  end
end

Archive::Tar::Minitar::Reader::EntryStream.include(CoreExtensions::MinitarEntryStream)
Archive::Tar::Minitar::Input.include(CoreExtensions::MinitarMap)

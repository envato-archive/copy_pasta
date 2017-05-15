module CoreExtensions
  # Public: Adds to_hash to Archive::Tar::Minitar::Reader::EntryStream.
  module MinitarEntryStream
    # Public: Converts a tar entry to a hash.
    #
    # Returns a Hash.
    def to_hash
      { file_name: full_name, mode: mode, content: read }
    end
  end
end

Archive::Tar::Minitar::Reader::EntryStream
  .include(CoreExtensions::MinitarEntryStream)

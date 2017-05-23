require "spec_helper"

describe Unthread::DirectoryReader do
  let(:example_dir_structure) { "/tmp/example_dir_structure" }
  let(:described_instance) { described_class.new(example_dir_structure) }

  before do
    FileUtils.rm_rf(example_dir_structure)
    FileUtils.mkdir_p(File.join(example_dir_structure, "sub", "dir"))
    FileUtils.touch(File.join(example_dir_structure, "1.txt"))
    FileUtils.touch(File.join(example_dir_structure, "sub", "dir", "2.txt"))
  end

  describe "#directories" do
    let(:directory_names) { described_instance.directories.map(&:file_name) }
    let(:expected_directories) do
      [
        File.join(example_dir_structure, "sub"),
        File.join(example_dir_structure, "sub", "dir")
      ]
    end

    it "returns directories only" do
      expect(directory_names).to include(*expected_directories)
    end
  end

  describe "#files" do
    let(:file_names) { described_instance.files.map(&:file_name) }
    let(:expected_files) do
      [
        File.join(example_dir_structure, "1.txt"),
        File.join(example_dir_structure, "sub", "dir", "2.txt")
      ]
    end

    it "returns files only" do
      expect(file_names).to include(*expected_files)
    end
  end

  context "Patterns" do
    let(:described_instance) { described_class.new(example_dir_structure, '\Asub/dir') }

    describe "#directories" do
      let(:directory_names) { described_instance.directories.map(&:file_name) }
      let(:expected_directories) do
        [
          File.join(example_dir_structure, "sub", "dir")
        ]
      end

      it "returns directories only" do
        expect(directory_names).to include(*expected_directories)
      end
    end

    describe "#files" do
      let(:file_names) { described_instance.files.map(&:file_name) }
      let(:expected_files) do
        [
          File.join(example_dir_structure, "sub", "dir", "2.txt")
        ]
      end

      it "returns files only" do
        expect(file_names).to include(*expected_files)
      end
    end
  end
end

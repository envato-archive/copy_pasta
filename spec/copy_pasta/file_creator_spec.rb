require "spec_helper"

describe CopyPasta::FileCreator do
  let(:files) { CopyPasta::DirectoryReader.new(source_directory).files }
  let(:described_instance) { described_class.new(files, source_directory, 1) }
  let(:source_directory) { "/tmp/output" }
  let(:destination_directory) { "/tmp/output2" }

  before do
    FileUtils.rm_rf(source_directory)
    FileUtils.rm_rf(destination_directory)

    FileUtils.mkdir_p(source_directory)
    FileUtils.mkdir_p(File.join(source_directory, "sub", "dir"))
    FileUtils.mkdir_p(destination_directory)
    FileUtils.mkdir_p(File.join(destination_directory, "sub", "dir"))

    FileUtils.touch("/tmp/output/1.txt")
    FileUtils.touch("/tmp/output/2.txt")
    FileUtils.touch("/tmp/output/sub/dir/3.txt")
  end

  describe "#create_work" do
    it "queues the creation" do
      allow(described_instance.executor).to receive(:queue)
      described_instance.create_work

      expect(described_instance.executor)
        .to have_received(:queue).exactly(files.count).times
    end
  end

  describe "#run" do
    before do
      allow(described_instance.executor).to receive(:run)
    end

    it "executes all work in the queue" do
      described_instance.run
      expect(described_instance.executor).to have_received(:run)
    end

    it "returns an array of created files" do
      expect(described_instance.run).to include(*files.map(&:file_name))
    end
  end

  describe "#self.run" do
    let(:path) { "/tmp/output2" }
    let(:dir_reader) { CopyPasta::DirectoryReader.new(destination_directory) }
    let(:created_files) { dir_reader.files.map(&:file_name) }

    before { described_class.run(files, path, threads: 1) }

    it "creates all files" do
      expect(created_files)
        .to include("/tmp/output2/1.txt", "/tmp/output2/2.txt", "/tmp/output2/sub/dir/3.txt")
    end
  end
end

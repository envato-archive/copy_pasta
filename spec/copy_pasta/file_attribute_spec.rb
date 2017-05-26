require "spec_helper"

describe CopyPasta::FileAttribute do
  let(:described_instance) { described_class.new("/tmp/file.txt", "/tmp") }
  let(:stat_double) { instance_double(File::Stat) }

  before do
    allow(stat_double).to receive(:mode).and_return(123)
    allow(File).to receive(:stat).and_return(stat_double)
  end

  describe "#file_name" do
    subject { described_instance.file_name }

    it { is_expected.to eql("/tmp/file.txt") }
  end

  describe "#relative_file_name" do
    subject { described_instance.relative_file_name }

    it { is_expected.to eql("file.txt") }
  end

  describe "#copy_file" do
    let(:write_double) { instance_double(File) }

    before do
      allow(described_instance).to receive(:content).and_return("testing")
      allow(write_double).to receive(:write).with("testing")
      allow(File).to receive(:open).with("/tmp2/file.txt", "wb", perm: 123).and_yield(write_double)

      described_instance.copy_file("/tmp2")
    end

    it "writes the file to the destination directory" do
      expect(File).to have_received(:open).with("/tmp2/file.txt", "wb", perm: 123)
    end

    it "uses the source file's content for writing" do
      expect(write_double).to have_received(:write).with("testing")
    end
  end

  describe "#create_directory" do
    let(:described_instance) { described_class.new("/tmp/dir/subdir", "/tmp") }

    it "creates the destination directory" do
      allow(FileUtils).to receive(:mkdir_p).with("/tmp2/dir/subdir", mode: 123)
      described_instance.create_directory("/tmp2")
      expect(FileUtils).to have_received(:mkdir_p).with("/tmp2/dir/subdir", mode: 123)
    end
  end
end

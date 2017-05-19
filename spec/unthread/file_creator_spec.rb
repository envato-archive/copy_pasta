require "spec_helper"

describe Unthread::FileCreator do
  let(:described_instance) { described_class.new(files, scratch_dir, 1) }

  let(:scratch_dir) { "/tmp/output" }
  let(:stat_1_double) { instance_double(File::Stat) }
  let(:stat_2_double) { instance_double(File::Stat) }
  let(:file1) { Unthread::FileAttribute.new("/tmp/output/1.txt", scratch_dir) }
  let(:file2) { Unthread::FileAttribute.new("/tmp/output/2.txt", scratch_dir) }
  let(:files) { [file1, file2] }

  before do
    FileUtils.rm_rf(scratch_dir)
    FileUtils.mkdir_p(File.join(scratch_dir, "output"))

    allow(File).to receive(:stat).with("/tmp/output/1.txt").and_return(stat_1_double)
    allow(File).to receive(:stat).with("/tmp/output/2.txt").and_return(stat_2_double)
  end

  describe "#queue" do
    it "queues the creation" do
      allow(described_instance.executor).to receive(:queue)
      described_instance.create_work

      expect(described_instance.executor)
        .to have_received(:queue).exactly(files.count).times
    end
  end

  describe "#run" do
    it "executes all work in the queue" do
      allow(described_instance.executor).to receive(:run)
      described_instance.run
      expect(described_instance.executor).to have_received(:run)
    end
  end

  describe "#self.run" do
    let(:path) { "/tmp/output2" }

    before do
      allow(FileUtils).to receive(:cp)
        .with(file1.file_name, File.join(path, file1.relative_file_name))
      allow(FileUtils).to receive(:cp)
        .with(file2.file_name, File.join(path, file2.relative_file_name))

      described_class.run(files, path, threads: 1)
    end

    it "copies file1" do
      expect(FileUtils).to have_received(:cp)
        .with(file1.file_name, File.join(path, file1.relative_file_name))
    end

    it "copies file2" do
      expect(FileUtils).to have_received(:cp)
        .with(file2.file_name, File.join(path, file2.relative_file_name))
    end
  end
end

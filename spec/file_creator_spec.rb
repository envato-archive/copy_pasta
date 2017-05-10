require "spec_helper"

describe Unthread::FileCreator do
  let(:files) do
    [
      { file_name: "output/1.txt", content: "1", mode: 0644 },
      { file_name: "output/2.txt", content: "2", mode: 0644 }
    ]
  end

  let(:scratch_dir) { "/tmp/output" }

  subject { described_class.new(files, scratch_dir, 1) }

  before(:each) do
    FileUtils.rm_rf(scratch_dir)
    FileUtils.mkdir_p(File.join(scratch_dir, "output"))
  end

  describe "#queue" do
    it "queues the creation" do
      expect(subject.pool).to receive(:post).exactly(files.count).times
      subject.queue
    end
  end

  describe "#shutdown" do
    it "turns the pool off" do
      subject.shutdown
      expect(subject.pool).to be_shutdown
    end
  end

  describe "#self.run" do
    it "creates the needed files" do
      described_class.run(files, scratch_dir, threads: 1)

      expect(File.read(File.join(scratch_dir, "output", "1.txt"))).to eql("1")
      expect(File.read(File.join(scratch_dir, "output", "2.txt"))).to eql("2")
    end
  end
end

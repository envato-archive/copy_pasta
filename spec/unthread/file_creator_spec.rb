require "spec_helper"

describe Unthread::FileCreator do
  let(:described_instance) { described_class.new(files, scratch_dir, 1) }

  let(:files) do
    [
      { file_name: "output/1.txt", content: "1", mode: 0o644 },
      { file_name: "output/2.txt", content: "2", mode: 0o644 }
    ]
  end

  let(:scratch_dir) { "/tmp/output" }

  before do
    FileUtils.rm_rf(scratch_dir)
    FileUtils.mkdir_p(File.join(scratch_dir, "output"))
  end

  describe "#queue" do
    it "queues the creation" do
      allow(described_instance.executor).to receive(:queue)
      described_instance.queue

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
    let(:path) { File.join(scratch_dir, "output") }

    before { described_class.run(files, scratch_dir, threads: 1) }

    it { expect(File.read(File.join(path, "1.txt"))).to eql("1") }
    it { expect(File.read(File.join(path, "2.txt"))).to eql("2") }
  end
end

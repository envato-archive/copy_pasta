require "spec_helper"

describe Unthread::DirectoryCreator do
  let(:directories) do
    [
      { file_name: "output/", mode: 493 },
      { file_name: "output/a/", mode: 493 },
      { file_name: "output/b/", mode: 493 },
      { file_name: "output/c/", mode: 493 },
      { file_name: "output/b/subdir/", mode: 493 },
      { file_name: "output/b/subdir/neat/", mode: 493 }
    ]
  end

  let(:dir_names) do
    directories.map {|dir| File.join(scratch_dir, dir.fetch(:file_name)) }
  end

  let(:scratch_dir) { "/tmp/output" }

  subject { described_class.new(directories, scratch_dir, 1) }

  before(:each) { FileUtils.rm_rf(scratch_dir) }

  describe "#queue" do
    it "queues the creation" do
      expect(subject.executor).to receive(:queue).exactly(directories.count).times
      subject.queue
    end
  end

  describe "#shutdown" do
    it "turns the pool off" do
      expect(subject.executor).to receive(:run)
      subject.shutdown
    end
  end

  describe "#self.run" do
    it "creates all dirs" do
      described_class.run(directories, "/tmp/output", threads: 1)
      created = Dir.glob(File.join(scratch_dir, "**", "*")).select { |f| File.directory? f }
      created.map! { |dir| File.join(dir, "/") }

      expect(created).to include(*dir_names)
    end

    it "doesn't issue unneeded mkdirs" do
      expect(FileUtils).to receive(:mkdir_p).exactly(3).times
      described_class.run(directories, "/tmp/output", threads: 1)
    end
  end
end

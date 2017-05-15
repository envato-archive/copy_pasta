require "spec_helper"

describe Unthread::DirectoryCreator do
  let(:described_instance) { described_class.new(directories, scratch_dir, 1) }

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
    directories.map { |dir| File.join(scratch_dir, dir.fetch(:file_name)) }
  end

  let(:scratch_dir) { "/tmp/output" }

  before { FileUtils.rm_rf(scratch_dir) }

  context "Executor" do
    let(:executor) { described_instance.executor }

    describe "#queue" do
      it "queues the creation" do
        allow(executor).to receive(:queue)
        described_instance.create_work

        expect(executor).to have_received(:queue)
          .exactly(directories.count).times
      end
    end

    describe "#shutdown" do
      it "turns the pool off" do
        allow(executor).to receive(:run)
        described_instance.run

        expect(executor).to have_received(:run)
      end
    end
  end

  describe "#self.run" do
    it "creates all dirs" do
      described_class.run(directories, "/tmp/output", threads: 1)
      created = Dir.glob(File.join(scratch_dir, "**", "*"))
        .select { |f| File.directory? f }
      created.map! { |dir| File.join(dir, "/") }

      expect(created).to include(*dir_names)
    end

    it "doesn't issue unneeded mkdirs" do
      allow(FileUtils).to receive(:mkdir_p)
      described_class.run(directories, "/tmp/output", threads: 1)

      expect(FileUtils).to have_received(:mkdir_p).exactly(3).times
    end
  end
end

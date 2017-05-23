require "spec_helper"

describe Unthread::DirectoryCreator do
  context "Executor" do
    let(:described_instance) { described_class.new([1, 2], "/tmp/output", 1) }
    let(:executor) { described_instance.executor }

    describe "#create_work" do
      it "queues the creation" do
        allow(executor).to receive(:queue)
        described_instance.create_work

        expect(executor).to have_received(:queue).exactly(2).times
      end
    end

    describe "#shutdown" do
      it "turns the pool off" do
        allow(executor).to receive(:run)
        described_instance.run

        expect(executor).to have_received(:run)
      end
    end

    describe "#self.run" do
      let(:scratch_source) { "/tmp/output" }
      let(:scratch_destination) { "/tmp/output2" }
      let(:directory_reader) { Unthread::DirectoryReader.new(scratch_source) }

      let(:source_directories) do
        ["/tmp/output/dir", "/tmp/output/dir/sub"]
      end

      let(:destination_directories) do
        ["/tmp/output2/dir", "/tmp/output2/dir/sub"]
      end

      before do
        FileUtils.rm_rf(scratch_source)
        FileUtils.rm_rf(scratch_destination)
        source_directories.each { |dir| FileUtils.mkdir_p(dir) }
      end

      it "creates the expected directories" do
        described_class.run(directory_reader.directories, "/tmp/output2", threads: 1)
        expect(Dir.glob(File.join(scratch_destination, "**", "*"))).to eql(destination_directories)
      end
    end
  end
end

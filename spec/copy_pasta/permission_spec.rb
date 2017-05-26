require "spec_helper"

describe CopyPasta::Permission do
  let(:files) { ["/tmp/1.txt", "/tmp/2.txt"] }
  let(:described_instance) { described_class.new(files, {}) }

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
      expect(described_instance.run).to include(*files)
    end
  end

  describe "#self.run" do
    let(:mode) { "0777" }
    let(:user) { "user" }
    let(:group) { "group" }
    let(:file) { "/tmp/1.txt" }

    before do
      allow(FileUtils).to receive(:chmod).with(mode, file)
      allow(FileUtils).to receive(:chown).with(user, group, file)
      allow(FileUtils).to receive(:chown).with(user, nil, file)
      allow(FileUtils).to receive(:chown).with(nil, group, file)
    end

    context "Chmod" do
      it "chmod the files" do
        described_class.set([file], mode: mode)
        expect(FileUtils).to have_received(:chmod).with(mode, file)
      end

      it "does not chmod the files" do
        described_class.set([file])
        expect(FileUtils).not_to have_received(:chmod).with(mode, file)
      end
    end

    context "Chown" do
      it "chowns the files with the user" do
        described_class.set([file], user: user)
        expect(FileUtils).to have_received(:chown).with(user, nil, file)
      end

      it "chowns the files with the group" do
        described_class.set([file], group: group)
        expect(FileUtils).to have_received(:chown).with(nil, group, file)
      end

      it "chowns the files with the user and group" do
        described_class.set([file], user: user, group: group)
        expect(FileUtils).to have_received(:chown).with(user, group, file)
      end

      it "does not chown the files" do
        described_class.set([file])
        expect(FileUtils).not_to have_received(:chown)
      end
    end

    it "uses the number of threads specificed" do
      allow(CopyPasta::Executor).to receive(:new).with(10)
      described_class.new(files, threads: 10)
      expect(CopyPasta::Executor).to have_received(:new).with(10)
    end
  end
end

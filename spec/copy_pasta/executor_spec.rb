require "spec_helper"

describe CopyPasta::Executor do
  let(:described_instance) { described_class.new(1) }

  describe "#queue" do
    it "adds jobs to @promises" do
      expect { described_instance.queue { 1 } }
        .to change { described_instance.promises.size }.from(0).to(1)
    end
  end

  describe "#run" do
    let(:jobs) { [1, 2, 3] }

    it "runs all promises" do
      jobs.each { |job| described_instance.queue { job } }
      expect(described_instance.run).to include(*jobs)
    end
  end
end

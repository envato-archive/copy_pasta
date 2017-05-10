require "spec_helper"

describe Unthread::Executor do
  subject { described_class.new(1) }

  describe "#queue" do
    it "adds jobs to @promises" do
      expect { subject.queue { 1 } }
        .to change { subject.promises.size }.from(0).to(1)
    end
  end

  describe "#run" do
    let(:jobs) { [1,2,3] }

    it "runs all promises" do
      jobs.each { |job| subject.queue { job } }
      expect(subject.run).to include(*jobs)
    end
  end
end

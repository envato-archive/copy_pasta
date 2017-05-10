require "spec_helper"

describe Unthread::Entry do
  let(:example_tar) do
    File.join(File.dirname(__FILE__), "output.tar")
  end

  let(:example_tar_gz) do
    File.join(File.dirname(__FILE__), "output.tar.gz")
  end

  let(:directories) do
    [
      { file_name: "output/", mode: 493 },
      { file_name: "output/a/", mode: 493 },
      { file_name: "output/b/", mode: 493 },
      { file_name: "output/c/", mode: 493 },
      { file_name: "output/b/subdir/", mode: 493 }
    ]
  end

  let(:files) do
    [
      { file_name: "output/a/0", content: "0\n", mode: 420 },
      { file_name: "output/a/1", content: "1\n", mode: 420 }
    ]
  end

  subject { described_class.new(example_tar) }

  context "Tar Support" do
    describe "#directories" do
      it "returns directories" do
        expect(subject.directories).to eql(directories)
      end
    end

    describe "#files" do
      it "returns files" do
        expect(subject.files).to eql(files)
      end
    end
  end

  context "Gzip Support" do
    subject { described_class.new(example_tar_gz) }

    describe "#directories" do
      it "returns directories" do
        expect(subject.directories).to eql(directories)
      end
    end

    describe "#files" do
      it "returns files" do
        expect(subject.files).to eql(files)
      end
    end
  end
end

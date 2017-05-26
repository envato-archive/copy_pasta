require "spec_helper"

describe CopyPasta::ParentDirectory do
  subject { described_class.find(path) }

  let(:resolved_paths) do
    [
      "/home/ubuntu/tmp/",
      "/home/ubuntu/",
      "/home/"
    ]
  end

  let(:path) { "/home/ubuntu/tmp/stuff" }

  it { is_expected.to eql(resolved_paths) }

  it { is_expected.not_to include(path) }

  it { is_expected.not_to include("/") }
end

require "spec_helper"

describe Unthread::ParentDirectory do
  let(:resolved_paths) do
    [
      "/home/ubuntu/tmp/",
      "/home/ubuntu/",
      "/home/"
    ]
  end

  let(:path) { '/home/ubuntu/tmp/stuff' }
  subject { Unthread::ParentDirectory.find(path) }

  it "resolves parent directories" do
    expect(subject).to eql(resolved_paths)
  end

  it "doesn't include itself" do
    expect(subject).not_to include(path)
  end

  it "doesn't include /" do
    expect(subject).not_to include('/')
  end
end

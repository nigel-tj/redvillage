require "test_helper"

describe Artist do
  let(:artist) { Artist.new }

  it "must be valid" do
    artist.must_be :valid?
  end
end

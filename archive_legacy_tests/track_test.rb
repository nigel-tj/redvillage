require "test_helper"

describe Track do
  let(:track) { Track.new }

  it "must be valid" do
    value(track).must_be :valid?
  end
end

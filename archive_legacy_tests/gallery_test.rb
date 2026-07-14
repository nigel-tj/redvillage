require "test_helper"

describe Gallery do
  let(:gallery) { Gallery.new }

  it "must be valid" do
    gallery.must_be :valid?
  end
end

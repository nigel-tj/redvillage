require "test_helper"

describe GalleryBanner do
  let(:gallery_banner) { GalleryBanner.new }

  it "must be valid" do
    value(gallery_banner).must_be :valid?
  end
end

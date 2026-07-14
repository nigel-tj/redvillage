require "test_helper"

describe MusicBanner do
  let(:music_banner) { MusicBanner.new }

  it "must be valid" do
    value(music_banner).must_be :valid?
  end
end

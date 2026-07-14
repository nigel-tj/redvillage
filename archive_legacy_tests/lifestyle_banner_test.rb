require "test_helper"

describe LifestyleBanner do
  let(:lifestyle_banner) { LifestyleBanner.new }

  it "must be valid" do
    value(lifestyle_banner).must_be :valid?
  end
end

require "test_helper"

describe FeatureBanner do
  let(:feature_banner) { FeatureBanner.new }

  it "must be valid" do
    value(feature_banner).must_be :valid?
  end
end

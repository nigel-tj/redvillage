require "test_helper"

describe Feature do
  let(:feature) { Feature.new }

  it "must be valid" do
    feature.must_be :valid?
  end
end

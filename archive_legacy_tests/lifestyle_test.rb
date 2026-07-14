require "test_helper"

describe Lifestyle do
  let(:lifestyle) { Lifestyle.new }

  it "must be valid" do
    value(lifestyle).must_be :valid?
  end
end

require "test_helper"

describe Store do
  let(:store) { Store.new }

  it "must be valid" do
    value(store).must_be :valid?
  end
end

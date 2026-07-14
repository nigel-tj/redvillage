require "test_helper"

describe MainBanner do
  let(:main_banner) { MainBanner.new }

  it "must be valid" do
    value(main_banner).must_be :valid?
  end
end

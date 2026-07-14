require "test_helper"

describe Email do
  let(:email) { Email.new }

  it "must be valid" do
    value(email).must_be :valid?
  end
end

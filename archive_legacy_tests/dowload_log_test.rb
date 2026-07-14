require "test_helper"

describe DowloadLog do
  let(:dowload_log) { DowloadLog.new }

  it "must be valid" do
    value(dowload_log).must_be :valid?
  end
end

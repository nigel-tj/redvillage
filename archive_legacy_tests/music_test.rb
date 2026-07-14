require "test_helper"

describe Music do
  let(:music) { Music.new }

  it "must be valid" do
    music.must_be :valid?
  end
end

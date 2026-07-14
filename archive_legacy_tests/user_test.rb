require "test_helper"

describe User do
  let(:valid_attributes) do
    {
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    }
  end

  it "is invalid without required attributes" do
    user = User.new

    _(user).wont_be :valid?
    _(user.errors[:name]).wont_be_empty
    _(user.errors[:email]).wont_be_empty
    _(user.errors[:password]).wont_be_empty
  end

  it "defaults to member role" do
    user = User.new(valid_attributes)

    _(user).must_be :valid?
    _(user.role).must_equal "member"
  end
end

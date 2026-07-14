require "test_helper"

describe ComingSoonController do
  it "should get index" do
    get :index
    value(response).must_be :success?
  end

end

require "test_helper"

describe LifestylesController do
  it "should get index" do
    get :index
    value(response).must_be :success?
  end

  it "should get new" do
    get :new
    value(response).must_be :success?
  end

  it "should get create" do
    get :create
    value(response).must_be :success?
  end

  it "should get update" do
    get :update
    value(response).must_be :success?
  end

end

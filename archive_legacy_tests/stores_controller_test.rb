require "test_helper"

describe StoresController do
  it "should get index" do
    get :index
    value(response).must_be :success?
  end

  it "should get new" do
    get :new
    value(response).must_be :success?
  end

  it "should get show" do
    get :show
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

  it "should get activate" do
    get :activate
    value(response).must_be :success?
  end

  it "should get deactivate" do
    get :deactivate
    value(response).must_be :success?
  end

end

require "test_helper"

describe AlbumsController do
  it "should get new" do
    get :new
    value(response).must_be :success?
  end

  it "should get all_albums" do
    get :all_albums
    value(response).must_be :success?
  end

  it "should get edit" do
    get :edit
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

  it "should get delete" do
    get :delete
    value(response).must_be :success?
  end

end

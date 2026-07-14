require "test_helper"

describe FeatureBannersController do
  let(:feature_banner) { feature_banners :one }

  it "gets index" do
    get :index
    value(response).must_be :success?
    value(assigns(:feature_banners)).wont_be :nil?
  end

  it "gets new" do
    get :new
    value(response).must_be :success?
  end

  it "creates feature_banner" do
    expect {
      post :create, feature_banner: { description: feature_banner.description, image: feature_banner.image, link: feature_banner.link, name: feature_banner.name }
    }.must_change "FeatureBanner.count"

    must_redirect_to feature_banner_path(assigns(:feature_banner))
  end

  it "shows feature_banner" do
    get :show, id: feature_banner
    value(response).must_be :success?
  end

  it "gets edit" do
    get :edit, id: feature_banner
    value(response).must_be :success?
  end

  it "updates feature_banner" do
    put :update, id: feature_banner, feature_banner: { description: feature_banner.description, image: feature_banner.image, link: feature_banner.link, name: feature_banner.name }
    must_redirect_to feature_banner_path(assigns(:feature_banner))
  end

  it "destroys feature_banner" do
    expect {
      delete :destroy, id: feature_banner
    }.must_change "FeatureBanner.count", -1

    must_redirect_to feature_banners_path
  end
end

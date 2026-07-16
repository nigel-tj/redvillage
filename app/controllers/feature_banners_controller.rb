class FeatureBannersController < ApplicationController
  include RoleBasedAccess

  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_banner_manager, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_feature_banner, only: [:show, :edit, :update, :destroy]

  # GET /feature_banners
  # GET /feature_banners.json
  def index
    @feature_banners = FeatureBanner.all
  end

  # GET /feature_banners/1
  # GET /feature_banners/1.json
  def show
  end

  # GET /feature_banners/new
  def new
    @feature_banner = FeatureBanner.new
  end

  # GET /feature_banners/1/edit
  def edit
  end

  # POST /feature_banners
  # POST /feature_banners.json
  def create
    @feature_banner = FeatureBanner.new(feature_banner_params)

    respond_to do |format|
      if @feature_banner.save
        format.html { redirect_to @feature_banner, notice: 'Feature banner was successfully created.' }
        format.json { render :show, status: :created, location: @feature_banner }
      else
        format.html { render :new }
        format.json { render json: @feature_banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feature_banners/1
  # PATCH/PUT /feature_banners/1.json
  def update
    respond_to do |format|
      if @feature_banner.update(feature_banner_params)
        format.html { redirect_to @feature_banner, notice: 'Feature banner was successfully updated.' }
        format.json { render :show, status: :ok, location: @feature_banner }
      else
        format.html { render :edit }
        format.json { render json: @feature_banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feature_banners/1
  # DELETE /feature_banners/1.json
  def destroy
    @feature_banner.destroy
    respond_to do |format|
      format.html { redirect_to feature_banners_url, notice: 'Feature banner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_feature_banner
      @feature_banner = FeatureBanner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_banner_params
      params.require(:feature_banner).permit(:name, :description, :image, :link)
    end
end

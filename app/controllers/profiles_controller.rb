class ProfilesController < ApplicationController
  include RoleBasedAccess
  
  before_action :authenticate_user!, only: [:edit, :update, :my_profile]
  before_action :set_profile, only: [:show, :edit, :update]
  before_action :authorize_profile_access, only: [:edit, :update]
  
  layout "admin", only: [:edit, :update]

  def show
    @user = @profile.user
    
    # Check if profile is public or user is viewing their own/admin
    unless @profile.public_profile? || (user_signed_in? && (current_user == @user || current_user.admin?))
      flash[:alert] = "This profile is private."
      redirect_to root_path
      return
    end
    
    render layout: determine_layout
  end

  def edit
    @user = @profile.user
  end

  def update
    @user = @profile.user
    
    if @profile.update(profile_params)
      flash[:notice] = "Profile updated successfully."
      redirect_to profile_path(@profile)
    else
      render :edit
    end
  end

  def my_profile
    current_user.ensure_profile_exists
    redirect_to profile_path(current_user.profile)
  end

  private

  def set_profile
    if params[:id].present?
      @profile = Profile.find(params[:id])
    else
      @profile = current_user.profile || current_user.create_profile
    end
  end

  def authorize_profile_access
    unless current_user.admin? || current_user == @profile.user
      flash[:alert] = "You don't have permission to edit this profile."
      redirect_to root_path
    end
  end

  def profile_params
    params.require(:profile).permit(
      :bio, 
      :phone, 
      :website,
      :profile_picture,
      :cover_image,
      :facebook_url,
      :twitter_url,
      :instagram_url,
      :linkedin_url,
      :youtube_url,
      :spotify_url,
      :soundcloud_url,
      :pinterest_url,
      :tiktok_url,
      :specialization,
      :experience,
      :location,
      :public_profile
    )
  end

  def determine_layout
    # Use admin layout for backstage users viewing their own profile, public layout for others
    if user_signed_in? && current_user.can_access_backend? && current_user == @user
      'admin'
    else
      'new_look_layout'
    end
  end
end


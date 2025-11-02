class ImpersonationsController < ApplicationController
  include RoleBasedAccess

  before_action :require_admin

  def create
    unless current_user&.admin?
      flash[:alert] = "Only admins can impersonate users."
      redirect_to root_path
      return
    end

    @user = User.find(params[:id])
    
    if @user == current_user
      flash[:alert] = "You cannot impersonate yourself."
      redirect_to users_path
      return
    end

    session[:original_user_id] = current_user.id
    sign_in(@user)
    flash[:notice] = "Now impersonating #{@user.name} (#{@user.role})"
    redirect_to dashboard_path_for(@user)
  end

  def destroy
    if session[:original_user_id].present?
      original_user = User.find(session[:original_user_id])
      session.delete(:original_user_id)
      sign_in(original_user)
      flash[:notice] = "Stopped impersonating. Welcome back, #{original_user.name}!"
      redirect_to admin_dashboard_path
    else
      flash[:alert] = "Not currently impersonating anyone."
      redirect_to root_path
    end
  end

  private

  def dashboard_path_for(user)
    case user.role
    when 'admin'
      admin_dashboard_path
    when 'dj'
      dj_dashboard_path
    when 'artist'
      artist_dashboard_path
    when 'photographer'
      photographer_dashboard_path
    when 'videographer'
      videographer_dashboard_path
    when 'curator'
      curator_dashboard_path
    when 'designer'
      designer_dashboard_path
    when 'editor'
      editor_dashboard_path
    else
      root_path
    end
  end
end


class UsersController < ApplicationController
  include RoleBasedAccess
  
  before_action :authenticate_user!
  before_action :require_admin, only: [:index, :update, :destroy]
  after_action :verify_authorized

  def index
    @users = User.all
    @users = @users.where(role: params[:role]) if params[:role].present?
    authorize User
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  def is_signed_in?
    if user_signed_in? # if user signed
      true
    end
  end
    
  private

  def secure_params
    params.require(:user).permit(:name, :email, :role)
  end

end

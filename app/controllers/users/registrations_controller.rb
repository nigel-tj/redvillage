class Users::RegistrationsController < Devise::RegistrationsController
  layout "authentication"
  
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  
  def new
    @step = params[:step] || 1
    @step = @step.to_i.clamp(1, 3)  # Ensure step is between 1 and 3
    super
  end

  def create
    @step = params[:step].present? ? params[:step].to_i : 1
    
    # If step 1, validate and move to step 2
    if @step == 1
      build_resource(user_params)
      resource.valid?
      
      # Check if step 1 fields are valid
      if resource.errors[:name].blank? && resource.errors[:email].blank? && resource.errors[:password].blank?
        # Store params for step 2
        @step1_data = params.require(:user).permit(:name, :email, :password, :password_confirmation)
        @step = 2
        render :new
      else
        # Stay on step 1 with errors
        @step = 1
        render :new
      end
    else
      # Step 2 - complete registration
      super do |resource|
        if resource.persisted?
          # Set onboarding completion based on role
          if resource.member?
            session[:onboarding_complete] = true
          end
          return
        else
          @step = 2
          @step1_data = params.require(:user).permit(:name, :email, :password, :password_confirmation)
          return render :new
        end
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role])
  end

  def after_sign_up_path_for(resource)
    if resource.member?
      # Redirect to member dashboard or welcome page
      root_path
    else
      admin_path
    end
  end
end

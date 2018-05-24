class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  skip_before_action :authenticate_user!, on: [:new, :create]
  skip_before_action :ensure_within_period_end!

  # GET /resource/sign_up
  def new
    super
    session[:registerable_email] = nil
    session[:loginable_email] = nil
  end

  # POST /resource
  def create
    unless redirect_if_already_registered
      super
      MessageMailer.welcome(params[:user][:email]).deliver_later
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  private
  
  def redirect_if_already_registered
    user = User.find_by(email: params[:user][:email])
    if user
      session[:loginable_email] = params[:user][:email]
      redirect_to new_user_session_path, flash: {
        info: 'Email registered, try signing in!'
      }
    end
  end
end

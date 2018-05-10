class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super unless redirect_if_not_registered
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def redirect_if_not_registered
    user = User.find_by(email: params[:user][:email])
    return false if user
    session[:registerable_email] = params[:user][:email]
    redirect_to new_user_registration_path, flash: {
      info: 'Email not registered, try signing up!'
    }
  end
end

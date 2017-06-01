
class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, :only => [ :create ]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    user = User.find_or_create_by_credentials(username: params[:user][:username], password: params[:user][:password])
    render json: user
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
end

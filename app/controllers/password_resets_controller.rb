class PasswordResetsController < ApplicationController
  before_action :load_user_from_token, only: [:edit, :update]
  before_action :check_token_expiry, only: [:edit, :update]

  def new
  end

  def create
    user = User.find_by(email: params[:email]&.downcase)
    if user
      user.generate_reset_password_token
      # TODO: Send email with reset link
    end
    redirect_to login_path, notice: "If that email exists, we've sent password reset instructions."
  end

  def edit
  end

  def update
    if @user.update(password_params)
      @user.clear_reset_password_token
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Password has been reset. Welcome back!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_user_from_token
    token = params[:token]
    @user = User.find_by(reset_password_token: token)
    redirect_to new_password_reset_path, alert: "Invalid or expired reset link." unless @user
  end

  def check_token_expiry
    redirect_to new_password_reset_path, alert: "Reset link has expired. Please request a new one." if @user.reset_password_token_expired?
  end

  def password_params
    params.permit(:password, :password_confirmation)
  end
end

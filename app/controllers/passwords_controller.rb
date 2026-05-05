class PasswordsController < ApplicationController
  before_action :require_user

  def edit
  end

  def update
    if Current.user.authenticate(params[:current_password])
      if Current.user.update(password_params)
        redirect_to root_path, notice: "Password updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      Current.user.errors.add(:current_password, "is incorrect")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.permit(:password, :password_confirmation)
  end
end

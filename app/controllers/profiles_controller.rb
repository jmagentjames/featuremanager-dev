class ProfilesController < ApplicationController
  before_action :require_user

  def show
  end

  def update
    if Current.user.update(profile_params)
      redirect_to profile_path, notice: "Profilen har uppdaterats."
    else
      flash.now[:alert] = "Kunde inte uppdatera profilen."
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    user = Current.user

    if user.authenticate(params[:password])
      session[:user_id] = nil
      Current.user = nil
      user.destroy
      redirect_to root_path, notice: "Ditt konto har raderats."
    else
      redirect_to profile_path, alert: "Felaktigt lösenord. Kontot raderades inte."
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :email)
  end
end

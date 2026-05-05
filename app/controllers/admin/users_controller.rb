class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.order(created_at: :desc)
  end

  def toggle_admin
    @user = User.find(params[:id])
    @user.update!(admin: !@user.admin?)
    redirect_to admin_users_path, notice: "Adminstatus uppdaterad för #{@user.name}."
  end

  def reset_password
    @user = User.find(params[:id])
    token = @user.generate_reset_password_token
    @user.save!
    url = edit_password_reset_url(token)
    Rails.logger.info "PASSWORD RESET URL for #{@user.email}: #{url}"
    puts "PASSWORD RESET URL for #{@user.email}: #{url}"
    redirect_to admin_users_path, notice: "Återställningslänk genererad för #{@user.name}. Se serverloggen."
  end

  def destroy
    @user = User.find(params[:id])

    if @user == Current.user
      redirect_to admin_users_path, alert: "Du kan inte ta bort ditt eget konto."
      return
    end

    @user.destroy!
    redirect_to admin_users_path, notice: "#{@user.name} har tagits bort."
  end
end

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

  # Changes to the importmap will invalidate the etag for HTML responses

  before_action :set_current_user
  helper_method :current_user

  private

  def set_current_user
    Current.user = User.find_by(id: session[:user_id])
  end

  def current_user
    Current.user
  end

  def require_user
    redirect_to login_path, alert: "You must be logged in." unless Current.user
  end

  def require_admin
    redirect_to root_path, alert: "Access denied." unless Current.user&.admin?
  end
end

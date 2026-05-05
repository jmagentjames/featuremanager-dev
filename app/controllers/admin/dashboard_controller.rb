class Admin::DashboardController < Admin::ApplicationController
  def index
    @unread_messages = Message.unread.count
    @total_users = User.count
  end
end

class Admin::MessagesController < Admin::ApplicationController
  def index
    @messages = Message.all.order(created_at: :desc)
  end

  def show
    @message = Message.find(params[:id])
    @message.update!(is_read: true) if !@message.is_read?
  end

  def mark_read
    @message = Message.find(params[:id])
    @message.update!(is_read: true)
    redirect_back_or_to [:admin, @message]
  end

  def mark_all_read
    Message.unread.update_all(is_read: true)
    redirect_to admin_messages_path, notice: "All messages marked as read."
  end

  private

  def redirect_back_or_to(destination)
    redirect_to request.referer || destination
  end
end

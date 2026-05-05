class Admin::MessagesController < Admin::ApplicationController
  def index
    @messages = Message.all.order(created_at: :desc)
  end

  def show
    @message = Message.find(params[:id])
    @message.update!(is_read: true) if !@message.is_read?
  end
end

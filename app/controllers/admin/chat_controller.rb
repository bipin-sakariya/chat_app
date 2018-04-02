class Admin::ChatController < ApplicationController

  def show
    cookies[:code] = User.first.code
    @user_sender = User.find_by(code:params[:id])
    @user = User.first
    @conversation = Conversation.find_by(sender_id: @user_sender.id, recipient_id: User.first)
    @message = Message.new
  end

  def create
     @conversation = Conversation.includes(:recipient).find(params[:message][:conversation])
     @message = @conversation.messages.create!(message_params)

     respond_to do |format|
       format.js
     end
  end

 private

 def message_params
   params.require(:message).permit(:user_id, :body)
 end
end

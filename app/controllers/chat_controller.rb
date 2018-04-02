require 'messagebird'
class ChatController < ApplicationController
  def index
     if !session[:code].present?
        @code = SecureRandom.hex(6)
        session[:code] = @code
        cookies[:code]= @code
        @user = User.create(code: session[:code])
        @conversation = Conversation.new(recipient: User.first, sender: @user)
        @conversation.save
     else
        @code = session[:code]
        @user = User.find_by(code: @code)
        if @user.present?
          @conversation = @user.conversations.first
        else
          session.delete(:code)
          cookies[:code]= nil
           redirect_to chat_index_path
        end
        cookies[:code] = @code
     end
  end


  def create
   @conversation = Conversation.includes(:recipient).find(params[:message][:conversation])
   # for send message
   if @conversation.messages.blank?
     require 'messagebird'
      begin
        key = 'BqAkDucda9l9SqsaNaw94LO8f'
        # Create a MessageBird client with the specified ACCESS_KEY.
        client = MessageBird::Client.new(key)
        url = 'http://localhost:3000/admin/chat/' + session[:code]
        # Send a new message.
        msg = client.message_create('Admin there', '+919033298496',url, :reference => 'Foobar')

      rescue MessageBird::ErrorException => ex
        puts
        puts 'An error occured while requesting a Message object:'
        puts

        ex.errors.each do |error|
          puts "  code        : #{error.code}"
          puts "  description : #{error.description}"
          puts "  parameter   : #{error.parameter}"
          puts
        end
      end
   end
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

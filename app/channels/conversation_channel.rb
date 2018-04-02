class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversations-#{current_user.id}"
  end

  def unsubscribed
    # puts "=========-------------------#{current_user.id}"
    # if current_user!= User.first
    #   @user = User.find(current_user.id)
    #   @user.destroy
    # end
  end

  def speak(data)
    message_params = data['message'].each_with_object({}) do |el, hash|
      hash[el.values.first] = el.values.last
    end
  end
end

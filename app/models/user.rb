class User < ApplicationRecord
  has_many :messages ,dependent: :destroy
  has_many :conversations, foreign_key: :sender_id ,dependent: :destroy

   # after_destroy { destroy_session }
   #
   # def destroy_session
   #   session.delete(:code)
   # end
end

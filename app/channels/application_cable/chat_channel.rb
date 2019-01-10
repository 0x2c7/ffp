module ApplicationCable
  class ChatChannel < ApplicationCable::Channel
    def subscribed
      stream_from "chat_#{params[:user_id]}"
    end
  end
end

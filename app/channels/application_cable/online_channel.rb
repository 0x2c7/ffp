module ApplicationCable
  class OnlineChannel < ApplicationCable::Channel
    def subscribed
      stream_from "online_#{params[:user_id]}"
    end
  end
end

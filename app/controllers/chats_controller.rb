class ChatsController < ApplicationController
  before_action :get_friends, only: [:show, :index]
  before_action :find_friend, only: [:show, :send_message]
  before_action :get_messages, only: [:show]

  def index
  end

  def show
    get_messages
  end

  def send_message
    @message = current_user.messages.new
    @message.receiver = @friend
    @message.content = params[:message][:content]
    @message.save

    get_friends
    get_messages
  end

  private

  def get_friends
    sending_ids =
      Message
        .where("user_id = ?",  current_user.id)
        .group(:receiver_id)
        .maximum(:created_at)
        .to_a
    receiving_ids =
      Message
        .where("receiver_id = ?",  current_user.id)
        .group(:user_id)
        .maximum(:created_at)
        .to_a
    ids = (sending_ids + receiving_ids).sort_by(&:second).reverse.map(&:first).uniq
    @friends =
      if ids.blank?
        User.none
      else
        User.find_ordered(ids)
      end
  end

  def find_friend
    @friend = User.find_by(id: params[:id])
    if @friend.blank?
      redirect_to chats_path, alert: "Friend not found"
    end
  end

  def get_messages
    @messages = Message.where("(user_id = ? AND receiver_id = ?) OR (user_id = ? AND receiver_id = ?)", current_user.id, @friend.id, @friend.id, current_user.id).includes(:user, :receiver)
  end
end

class ChatsController < ApplicationController
  before_action :get_friends, only: [:show, :index, :update_sidebar]
  before_action :find_friend, only: [:show, :send_message, :update_sidebar]
  before_action :get_messages, only: [:show]

  def index
  end

  def update_sidebar
  end

  def show
    get_messages
  end

  def send_message
    @message = current_user.messages.new
    @message.receiver = @friend
    @message.content = params[:message][:content]

    get_friends
    get_messages

    if @message.content.present? && @message.save
      senderMessages = ChatsController.render(
        template: 'chats/_messages',
        layout: false,
        assigns: {
          messages: @messages,
          current_user: current_user
        }
      )
      receiverMessages = ChatsController.render(
        template: 'chats/_messages',
        layout: false,
        assigns: {
          messages: @messages,
          current_user: @friend
        }
      )
      ActionCable.server.broadcast("chat_#{current_user.id}_#{@friend.id}", messages: senderMessages)
      ActionCable.server.broadcast("chat_#{@friend.id}_#{current_user.id}", messages: receiverMessages)
      current_user.touch(:online_at)
      (current_user.friend_ids + [current_user.id]).each do |friend_id|
        ActionCable.server.broadcast("online_#{friend_id}", {})
      end
    end
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
    @messages = Message.where("(user_id = ? AND receiver_id = ?) OR (user_id = ? AND receiver_id = ?)", current_user.id, @friend.id, @friend.id, current_user.id).order(created_at: :asc).includes(:user, :receiver)
  end
end

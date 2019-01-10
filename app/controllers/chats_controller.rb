class ChatsController < ApplicationController
  before_action :find_friends
  before_action :find_friend, only: [:show]

  def index
  end

  def show
  end

  private

  def find_friends
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
end

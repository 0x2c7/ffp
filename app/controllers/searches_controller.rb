class SearchesController < ApplicationController
  def index
    @users = User.where("email like ?", "%#{params[:keyword]}%").limit(5)
    ids = current_user.friend_ids + @users.pluck(:id)
    @suggested_users = User.where.not(id: ids).limit(10)
  end
end

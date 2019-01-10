class TimelinesController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :create_post, :add_friend, :delete_friend]
  before_action :check_owner, only: [:edit, :update, :create_post]
  before_action :check_not_owner, only: [:add_friend, :delete_friend]
  before_action :new_post, only: [:show, :create_post]

  def index
    connections = (current_user.friends.map(&:id) + [current_user.id]).uniq
    @posts = Post.where(user_id: connections).order(created_at: :desc)
  end

  def show
    @posts = @user.posts.order(created_at: :desc)
    @friendship = Friendship.find_by(user_id: current_user.id, friend_id: @user.id)
  end

  def edit
  end

  def update
    if params[:user][:avatar]
      @user.avatar.attach(params[:user][:avatar])
    end

    if params[:user][:cover]
      @user.cover.attach(params[:user][:cover])
    end

    redirect_to timeline_path(@user)
  end

  def create_post
    @post.assign_attributes(params.require(:post).permit(:content, :image))
    if @post.save
      redirect_to timeline_path(@user)
    else
      render :show
    end
  end

  def add_friend
    @user.friends << current_user
    current_user.friends << @user
    redirect_to timeline_path(@user)
  end

  def delete_friend
    Friendship.where(user_id: current_user.id, friend_id: @user.id).destroy_all
    Friendship.where(friend_id: current_user.id, user_id: @user.id).destroy_all
    redirect_to timeline_path(@user)
  end

  private

  def find_user
    @user = User.find_by(id: params[:id])
    if @user.blank?
      redirect_to root_path, alert: "User not found"
    end
  end

  def check_owner
    if @user.id != current_user.id
      redirect_to root_path, alert: "You can not do this action"
    end
  end

  def check_not_owner
    if @user.id == current_user.id
      redirect_to root_path, alert: "You can not do this action"
    end
  end

  def new_post
    @post = @user.posts.new
  end
end

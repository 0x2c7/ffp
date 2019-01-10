class TimelinesController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :create_post]
  before_action :check_same_user, only: [:edit, :update, :create_post]
  before_action :new_post, only: [:show, :create_post]

  def show
    @posts = @user.posts.order(created_at: :desc)
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

  def index
    connections = [current_user.id]
    @posts = Post.where(user_id: connections)
  end

  def create_post
    @post.assign_attributes(params.require(:post).permit(:content, :image))
    if @post.save
      redirect_to timeline_path(@user)
    else
      render :show
    end
  end

  private

  def find_user
    @user = User.find_by(id: params[:id])
    if @user.blank?
      redirect_to root_path, alert: "User not found"
    end
  end

  def check_same_user
    if @user.id != current_user.id
      redirect_to root_path, alert: "You can not do this action"
    end
  end

  def new_post
    @post = @user.posts.new
  end
end

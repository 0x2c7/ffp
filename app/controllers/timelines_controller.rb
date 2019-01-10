class TimelinesController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]

  def show
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
  end

  private

  def find_user
    @user = User.find_by(id: params[:id])
    if @user.blank?
      redirect_to root_path, alert: "User not found"
    end
  end
end

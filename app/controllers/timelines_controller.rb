class TimelinesController < ApplicationController
  before_action :find_user, only: :show

  def show
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

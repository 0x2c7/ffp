module ApplicationHelper
  def online_count
    if user_signed_in?
      current_user.friends.where('online_at > ?', Time.now - 5.minutes).count
    end
  end
end

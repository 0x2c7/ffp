class AddTimestampToFriendships < ActiveRecord::Migration[5.2]
  def change
    add_column :friendships, :created_at, :datetime
    add_column :friendships, :updated_at, :datetime
  end
end

class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.references :user
      t.bigint :friend_id
      t.timestamp
    end
  end
end

class AddCreatedAtToPosts < ActiveRecord::Migration[5.2]
  def change
    change_table :posts do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

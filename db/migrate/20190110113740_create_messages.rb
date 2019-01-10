class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :user, foreign_key: true
      t.bigint :receiver_id
      t.text :content
      t.timestamp
    end
  end
end

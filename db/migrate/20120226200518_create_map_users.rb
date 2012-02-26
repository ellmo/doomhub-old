class CreateMapUsers < ActiveRecord::Migration
  def change
    create_table :map_users do |t|
      t.integer :map_id
      t.integer :user_id

      t.timestamps
    end
  end
end
